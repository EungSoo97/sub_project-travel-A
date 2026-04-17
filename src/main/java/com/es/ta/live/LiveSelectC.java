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
import java.util.ArrayList;

@WebServlet(name = "LiveSelectC", value = "/live-select")
public class LiveSelectC extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws IOException, ServletException {

        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html; charset=UTF-8");

        HttpSession session = request.getSession();
        AccountDTO loginUser = (AccountDTO) session.getAttribute("user");

        if (loginUser == null) {
            response.sendRedirect(request.getContextPath() + "/login?returnUrl=/live-select");
            return;
        }
        int userId = loginUser.getUser_id();
        String planKeyword = request.getParameter("planKeyword");

        ArrayList<TravelPlanDTO> planSearchList;
        if (planKeyword != null && !planKeyword.trim().isEmpty()) {
            planSearchList = TravelPlanDAO.searchPlansByUserId(userId, planKeyword.trim());
        } else {
            planSearchList = TravelPlanDAO.getPlansByUserId(userId);
        }

        request.setAttribute("planSearchList", planSearchList);
        request.setAttribute("planKeyword", planKeyword);

        request.setAttribute("content", "view/live/liveSelect.jsp");
        request.getRequestDispatcher("index.jsp").forward(request, response);
    }
}