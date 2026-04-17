package com.es.ta.mypage;

import com.es.ta.account.AccountDTO;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet(name = "PostPlanC", value = "/post-plan")
public class PostPlanC extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        AccountDTO loginUser = (AccountDTO) session.getAttribute("user");
        Integer planId = parsePlanId(request.getParameter("planId"));
        if (planId == null) {
            response.sendRedirect(request.getContextPath() + "/mypage");
            return;
        }

        TravelPlanDTO plan = MyPlanPageDAO.getPlanByPlanIdAndUserId(planId, loginUser.getUser_id());
        if (plan == null) {
            response.sendRedirect(request.getContextPath() + "/mypage");
            return;
        }

        boolean nextPosted = plan.getPosted() != 1;
        boolean canPostPlan = plan.getOriginalUserId() == 0 || plan.getCopiedModified() == 1;
        if (nextPosted && !canPostPlan) {
            response.sendRedirect(request.getContextPath() + "/myplan-page?id=" + planId + "&postBlocked=1");
            return;
        }

        MyPlanPageDAO.updatePostedByPlanIdAndUserId(planId, loginUser.getUser_id(), nextPosted);
        response.sendRedirect(request.getContextPath() + "/mypage?posted=" + (nextPosted ? "1" : "0"));
    }

    private Integer parsePlanId(String value) {
        try {
            return Integer.parseInt(value);
        } catch (Exception e) {
            return null;
        }
    }
}
