package com.es.ta.mypage;

import com.es.ta.account.AccountDTO;
import com.es.ta.resultpage.TravelResultVDTO;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet(name = "SavePlanC", value = "/save-plan")
public class SavePlanC extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession();
        AccountDTO loginUser = (AccountDTO) session.getAttribute("user");

        if (loginUser == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        TravelResultVDTO result = (TravelResultVDTO) session.getAttribute("latestTravelResult");

        if (result == null) {
            response.sendRedirect(request.getContextPath() + "/mypage");
            return;
        }

        String title = request.getParameter("title");
        if (title == null || title.trim().isEmpty()) {
            if (result.getSummary() != null && result.getSummary().getTitle() != null
                    && !result.getSummary().getTitle().trim().isEmpty()) {
                title = result.getSummary().getTitle();
            } else if (result.getSummary() != null && result.getSummary().getDestination() != null
                    && !result.getSummary().getDestination().trim().isEmpty()) {
                title = result.getSummary().getDestination() + " 여행";
            } else {
                title = "저장된 여행";
            }
        }

        int userId = loginUser.getUser_id();
        boolean ok = TravelPlanDAO.savePlan(userId, result, title);

        if (ok) {
            session.removeAttribute("latestTravelResult");
            response.sendRedirect(request.getContextPath() + "/mypage");
        } else {
            request.setAttribute("errorMsg", "여행 저장에 실패했습니다.");
            request.setAttribute("content", "view/resultpage/resultpage.jsp");
            request.getRequestDispatcher("index.jsp").forward(request, response);
        }
    }
}