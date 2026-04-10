package com.es.ta.userreaction;

import com.es.ta.account.AccountDTO;
import com.es.ta.mypage.TravelPlanDAO;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet("/star")
public class StarC extends HttpServlet {

    private final UserreactionDAO userreactionDAO = new UserreactionDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession(false);
        if (session == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        AccountDTO loginUser = (AccountDTO) session.getAttribute("user");
        if (loginUser == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String planIdParam = request.getParameter("planId");
        if (planIdParam == null || planIdParam.trim().isEmpty()) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "planId가 없습니다.");
            return;
        }

        int planId;
        try {
            planId = Integer.parseInt(planIdParam);
        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "planId 형식이 올바르지 않습니다.");
            return;
        }

        if (!TravelPlanDAO.DAO.existsPlan(planId)) {
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

        String referer = request.getHeader("Referer");
        if (referer != null && !referer.trim().isEmpty()) {
            response.sendRedirect(referer);
        } else {
            response.sendRedirect(request.getContextPath() + "/mypage");
        }
    }
}