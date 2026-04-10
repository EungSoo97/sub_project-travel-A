package com.es.ta.userreaction;

import com.es.ta.account.AccountDTO;
import com.google.gson.Gson;
import com.google.gson.JsonObject;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.BufferedReader;
import java.io.IOException;

@WebServlet(name = "LikeC", value = "/like")
public class LikeC extends HttpServlet {

    private final UserreactionDAO userreactionDAO = new UserreactionDAO();
    private final Gson gson = new Gson();

    @Override
    public void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        JsonObject result = new JsonObject();

        try {
            String planIdStr = request.getParameter("planId");
            if (planIdStr == null || planIdStr.isEmpty()) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                result.addProperty("error", "planId required");
                response.getWriter().print(gson.toJson(result));
                return;
            }

            int planId = Integer.parseInt(planIdStr);
            int likeCount = userreactionDAO.countLikeByPlan(planId);

            result.addProperty("likeCount", likeCount);
            response.getWriter().print(gson.toJson(result));

        } catch (NumberFormatException e) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            result.addProperty("error", "invalid planId");
            response.getWriter().print(gson.toJson(result));
        } catch (Exception e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            result.addProperty("error", "server error");
            response.getWriter().print(gson.toJson(result));
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        JsonObject result = new JsonObject();

        try {
            AccountDTO user = (AccountDTO) request.getSession().getAttribute("user");
            if (user == null) {
                response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
                result.addProperty("error", "login required");
                response.getWriter().print(gson.toJson(result));
                return;
            }

            int userId = user.getUser_id();

            BufferedReader reader = request.getReader();
            StringBuilder sb = new StringBuilder();
            String line;

            while ((line = reader.readLine()) != null) {
                sb.append(line);
            }

            JsonObject json = gson.fromJson(sb.toString(), JsonObject.class);
            int planId = json.get("planId").getAsInt();

            boolean exists = userreactionDAO.existsLike(planId, userId);
            boolean liked;

            if (exists) {
                userreactionDAO.deleteLike(planId, userId);
                liked = false;
            } else {
                userreactionDAO.insertLike(planId, userId);
                liked = true;
            }

            int likeCount = userreactionDAO.countLikeByPlan(planId);

            result.addProperty("liked", liked);
            result.addProperty("likeCount", likeCount);

            response.getWriter().print(gson.toJson(result));

        } catch (Exception e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            result.addProperty("error", "server error");
            response.getWriter().print(gson.toJson(result));
        }
    }
}