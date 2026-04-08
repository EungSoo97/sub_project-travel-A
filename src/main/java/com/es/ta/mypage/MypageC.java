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

        if (loginUser != null) {
            // ↓↓↓ 여기 getter 이름 꼭 네 AccountDTO에 맞게 바꿔줘!
            int userId = loginUser.getUser_id();

            ArrayList<com.es.ta.mypage.TravelPlanDTO> savedTrips = com.es.ta.mypage.TravelPlanDAO.getPlansByUserId(userId);
            request.setAttribute("savedTrips", savedTrips);
        }

        request.setAttribute("content", "view/mypage/mypage.jsp");
        request.getRequestDispatcher("index.jsp").forward(request, response);
    }

    @Override
    public void destroy() {
    }
}