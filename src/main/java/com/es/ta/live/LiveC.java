package com.es.ta.live;

import com.es.ta.account.AccountDTO;
import com.es.ta.mypage.TravelPlanDAO;
import com.es.ta.mypage.TravelPlanDTO;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet(name = "LiveC", value = "/live")
public class LiveC extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws IOException, ServletException {

        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html; charset=UTF-8");

        HttpSession session = request.getSession();
        AccountDTO loginUser = (AccountDTO) session.getAttribute("user");

        if (loginUser == null) {
            String planId = request.getParameter("planId");
            if (planId == null || planId.trim().isEmpty()) {
                response.sendRedirect(request.getContextPath() + "/login?returnUrl=/live-select");
            } else {
                response.sendRedirect(request.getContextPath() + "/login?returnUrl=/live?planId=" + planId);
            }
            return;
        }

        String planIdStr = request.getParameter("planId");
        if (planIdStr == null || planIdStr.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/live-select");
            return;
        }

        int planId;
        try {
            planId = Integer.parseInt(planIdStr);
        } catch (Exception e) {
            response.sendRedirect(request.getContextPath() + "/live-select");
            return;
        }

        int userId = loginUser.getUser_id();
        TravelPlanDTO selectedPlan = TravelPlanDAO.getPlanByPlanIdAndUserId(planId, userId);

        if (selectedPlan == null) {
            response.sendRedirect(request.getContextPath() + "/live-select");
            return;
        }

        request.setAttribute("selectedPlan", selectedPlan);
        request.setAttribute("content", "view/live/live.jsp");
        request.getRequestDispatcher("index.jsp").forward(request, response);
    }
}

