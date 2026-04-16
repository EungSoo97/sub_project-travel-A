package com.es.ta.userreaction;

import com.es.ta.account.AccountDTO;
import com.es.ta.mypage.TravelPlanDAO;
import com.google.gson.Gson;
import com.google.gson.JsonObject;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.BufferedReader;
import java.io.IOException;

@WebServlet("/star")
public class StarC extends HttpServlet {

    private final UserreactionDAO userreactionDAO = new UserreactionDAO();
    private final Gson gson = new Gson();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        boolean jsonRequest = isJsonRequest(request);

        HttpSession session = request.getSession(false);
        if (session == null) {
            if (jsonRequest) {
                writeJsonError(response, HttpServletResponse.SC_UNAUTHORIZED, "login required");
                return;
            }
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        AccountDTO loginUser = (AccountDTO) session.getAttribute("user");
        if (loginUser == null) {
            if (jsonRequest) {
                writeJsonError(response, HttpServletResponse.SC_UNAUTHORIZED, "login required");
                return;
            }
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String planIdParam = readPlanId(request, jsonRequest);
        if (planIdParam == null || planIdParam.trim().isEmpty()) {
            if (jsonRequest) {
                writeJsonError(response, HttpServletResponse.SC_BAD_REQUEST, "planId required");
                return;
            }
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "planId가 없습니다.");
            return;
        }

        int planId;
        try {
            planId = Integer.parseInt(planIdParam);
        } catch (NumberFormatException e) {
            if (jsonRequest) {
                writeJsonError(response, HttpServletResponse.SC_BAD_REQUEST, "invalid planId");
                return;
            }
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "planId 형식이 올바르지 않습니다.");
            return;
        }

        if (!TravelPlanDAO.DAO.existsPlan(planId)) {
            if (jsonRequest) {
                writeJsonError(response, HttpServletResponse.SC_NOT_FOUND, "plan not found");
                return;
            }
            response.sendError(HttpServletResponse.SC_NOT_FOUND, "존재하지 않는 여행 계획입니다.");
            return;
        }

        int userId = loginUser.getUser_id();

        boolean exists = userreactionDAO.existsStar(planId, userId);
        if (exists) {
            userreactionDAO.deleteStar(planId, userId);
        } else {
            userreactionDAO.insertStar(planId, userId);
        }

        boolean starred = !exists;
        if (jsonRequest) {
            JsonObject result = new JsonObject();
            result.addProperty("success", true);
            result.addProperty("liked", starred);
            result.addProperty("starred", starred);
            result.addProperty("starCount", userreactionDAO.countStarByPlan(planId));
            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");
            response.getWriter().print(gson.toJson(result));
            return;
        }

        String referer = request.getHeader("Referer");
        if (referer != null && !referer.trim().isEmpty()) {
            response.sendRedirect(referer);
        } else {
            response.sendRedirect(request.getContextPath() + "/mypage");
        }
    }

    private boolean isJsonRequest(HttpServletRequest request) {
        String contentType = request.getContentType();
        String accept = request.getHeader("Accept");
        return (contentType != null && contentType.toLowerCase().contains("application/json"))
                || (accept != null && accept.toLowerCase().contains("application/json"));
    }

    private String readPlanId(HttpServletRequest request, boolean jsonRequest) throws IOException {
        if (!jsonRequest) {
            return request.getParameter("planId");
        }

        StringBuilder sb = new StringBuilder();
        try (BufferedReader reader = request.getReader()) {
            String line;
            while ((line = reader.readLine()) != null) {
                sb.append(line);
            }
        }

        JsonObject json = gson.fromJson(sb.toString(), JsonObject.class);
        return json != null && json.has("planId") ? json.get("planId").getAsString() : null;
    }

    private void writeJsonError(HttpServletResponse response, int status, String message) throws IOException {
        JsonObject result = new JsonObject();
        result.addProperty("success", false);
        result.addProperty("message", message);
        response.setStatus(status);
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        response.getWriter().print(gson.toJson(result));
    }
}
