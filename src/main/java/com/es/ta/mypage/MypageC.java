package com.es.ta.mypage;


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

@WebServlet(name = "MypageC", value = "/mypage")
public class MypageC extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws IOException, ServletException {
        HttpSession session = request.getSession();
        AccountDTO loginUser = (AccountDTO) session.getAttribute("user");

        if (loginUser == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        int userId = loginUser.getUser_id();

        ArrayList<TravelPlanDTO> plans = TravelPlanDAO.getPlansByUserId(userId);
        System.out.println("로그인 userId = " + userId);
        System.out.println("조회된 plan 개수 = " + plans.size());
        request.setAttribute("savedTrips", plans);
        request.setAttribute("content", "view/mypage/mypage.jsp");
        request.getRequestDispatcher("index.jsp").forward(request, response);

    }


    @Override
    public void destroy() {
    }
}