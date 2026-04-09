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
    private UserreactionDAO userreactionDAO = new UserreactionDAO();
    private Gson gson = new Gson();

    public void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
        // 특정 플랜의 좋아요 개수 조회
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
            int likeCount = userreactionDAO.countByPlan(planId);
            
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
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        JsonObject result = new JsonObject();

        try {
            System.out.println("=== LikeC doPost Start ===");

            // 1. Check login
            AccountDTO user = (AccountDTO) request.getSession().getAttribute("user");
            System.out.println("User from session: " + user);

            if (user == null) {
                System.out.println("User is null - not logged in!");
                response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
                result.addProperty("error", "login required");
                response.getWriter().print(gson.toJson(result));
                return;
            }

            int userId = user.getUser_id();
            System.out.println("User ID: " + userId);

            // 2. Parse JSON
            BufferedReader reader = request.getReader();
            StringBuilder sb = new StringBuilder();
            String line;

            while ((line = reader.readLine()) != null) {
                sb.append(line);
            }

            String jsonStr = sb.toString();
            System.out.println("Received JSON: " + jsonStr);

            JsonObject json = gson.fromJson(jsonStr, JsonObject.class);
            int planId = json.get("planId").getAsInt();
            System.out.println("Plan ID: " + planId);

            // 3. Check if like exists
            boolean exists = userreactionDAO.exists(planId, userId);
            System.out.println("Like exists: " + exists);

            boolean liked;

            // 4. Toggle like
            if (exists) {
                System.out.println("Deleting like...");
                userreactionDAO.delete(planId, userId);
                liked = false;
            } else {
                System.out.println("Inserting like...");
                userreactionDAO.insert(planId, userId);
                liked = true;
            }

            // Get updated like count
            int likeCount = userreactionDAO.countByPlan(planId);
            System.out.println("Updated like count: " + likeCount);

            // 5. Send response
            result.addProperty("liked", liked);
            result.addProperty("likeCount", likeCount);

            response.getWriter().print(gson.toJson(result));
            System.out.println("=== LikeC doPost End ===");

        } catch (Exception e) {
            e.printStackTrace();

            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);

            result.addProperty("error", "server error");
            response.getWriter().print(gson.toJson(result));
        }
    }
}
