package com.es.ta.live;

import com.es.ta.account.AccountDTO;
import com.google.gson.Gson;
import com.google.gson.JsonObject;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.BufferedReader;
import java.io.IOException;

@WebServlet(name = "LiveTrackingC", value = "/live-tracking")
public class LiveTrackingC extends HttpServlet {

    private final Gson gson = new Gson();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession(false);
        AccountDTO user = session == null ? null : (AccountDTO) session.getAttribute("user");
        if (user == null) {
            writeError(response, HttpServletResponse.SC_UNAUTHORIZED, "login required");
            return;
        }

        JsonObject body = readJson(request);
        String action = body != null && body.has("action") ? body.get("action").getAsString() : "";
        Integer planId = body != null && body.has("planId") ? body.get("planId").getAsInt() : null;

        boolean ok;
        if ("start".equals(action)) {
            if (planId == null) {
                writeError(response, HttpServletResponse.SC_BAD_REQUEST, "planId required");
                return;
            }
            ok = LiveTrackingDAO.startTracking(user.getUser_id(), planId);
        } else if ("stop".equals(action)) {
            ok = planId == null
                    ? LiveTrackingDAO.stopAllTracking(user.getUser_id())
                    : LiveTrackingDAO.stopTracking(user.getUser_id(), planId);
        } else {
            writeError(response, HttpServletResponse.SC_BAD_REQUEST, "invalid action");
            return;
        }

        if (!ok) {
            writeError(response, HttpServletResponse.SC_BAD_REQUEST, "tracking update failed");
            return;
        }

        JsonObject result = new JsonObject();
        result.addProperty("success", true);
        result.addProperty("action", action);
        if ("start".equals(action) && planId != null) {
            result.addProperty("activePlanId", planId);
        }
        response.getWriter().print(gson.toJson(result));
    }

    private JsonObject readJson(HttpServletRequest request) throws IOException {
        StringBuilder sb = new StringBuilder();
        try (BufferedReader reader = request.getReader()) {
            String line;
            while ((line = reader.readLine()) != null) {
                sb.append(line);
            }
        }

        if (sb.length() == 0) {
            return new JsonObject();
        }
        return gson.fromJson(sb.toString(), JsonObject.class);
    }

    private void writeError(HttpServletResponse response, int status, String message) throws IOException {
        JsonObject result = new JsonObject();
        result.addProperty("success", false);
        result.addProperty("message", message);
        response.setStatus(status);
        response.getWriter().print(gson.toJson(result));
    }
}
