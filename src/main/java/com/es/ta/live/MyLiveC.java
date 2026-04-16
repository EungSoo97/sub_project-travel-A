package com.es.ta.live;

import com.es.ta.account.AccountDTO;

import com.es.ta.resultpage.ResultpageDAO;
import com.es.ta.resultpage.TravelResultVDTO;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet(name = "MyLiveC", value = "/my-live")
public class MyLiveC extends HttpServlet {

    public void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
// 비로그인 상태 접근 차단: 세션에 user 없으면 로그인 페이지로
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        String planId = request.getParameter("planId");

        System.out.println("planId: " + request.getParameter("planId"));
        System.out.println("destination: " + request.getParameter("destination"));

        // planId to get detailed travel plan information
        if (planId != null && !planId.isEmpty()) {
            try {
                int planIdInt = Integer.parseInt(planId);
                TravelResultVDTO planDetail = ResultpageDAO.detailpage(planIdInt);
                
                if (planDetail != null) {
                    request.setAttribute("planDetail", planDetail);
                    request.setAttribute("planId", planId);
                    System.out.println("planDetail found: " + planDetail.getSummary().getDestination());
                } else {
                    System.out.println("planDetail is null");
                    request.setAttribute("error", "Cannot find travel plan.");
                }
            } catch (NumberFormatException e) {
                System.out.println("Invalid planId format: " + e.getMessage());
                request.setAttribute("error", "Invalid travel plan ID.");
            }
        } else {
            System.out.println("planId is null or empty");
            request.setAttribute("error", "Travel plan ID is required.");
        }

        request.setAttribute("content","view/live/myLive.jsp");
        request.getRequestDispatcher("index.jsp").forward(request,response);

    }

    public void destroy() {
    }
}
