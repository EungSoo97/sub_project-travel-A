package com.es.ta.mypage;

import com.es.ta.account.AccountDTO;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet(name = "DeletePlanC", value = "/delete-plan")
public class DeletePlanC extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        Integer planId = parsePlanId(request.getParameter("planId"));
        if (planId == null) {
            response.sendRedirect(request.getContextPath() + "/mypage?deleteFail=1");
            return;
        }

        AccountDTO loginUser = (AccountDTO) session.getAttribute("user");
        boolean deleted = TravelPlanDAO.deletePlanByPlanIdAndUserId(planId, loginUser.getUser_id());

        response.sendRedirect(request.getContextPath() + "/mypage?deleteSuccess=" + (deleted ? "1" : "0"));
    }

    private Integer parsePlanId(String value) {
        try {
            return Integer.parseInt(value);
        } catch (Exception e) {
            return null;
        }
    }
}
