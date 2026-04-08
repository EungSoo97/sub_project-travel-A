package com.es.ta.resultpage;

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

@WebServlet(name = "ResultpageC", value = "/result-page")
public class ResultpageC extends HttpServlet {

    public void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {

        request.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession();
        AccountDTO loginUser = (AccountDTO) session.getAttribute("user");

        if (loginUser == null) {
            request.setAttribute("content", "view/login/login.jsp");
            request.getRequestDispatcher("index.jsp").forward(request, response);
            return;
        } else {

            String planIdParam = request.getParameter("id");
            if (planIdParam == null || planIdParam.trim().isEmpty()) {
                response.sendRedirect("mypage");
                return;
            }

            try {
                int planId = Integer.parseInt(planIdParam);
                int userId = loginUser.getUser_id();

                TravelPlanDTO savedPlan = TravelPlanDAO.getPlanByPlanIdAndUserId(planId, userId);

                if (savedPlan == null) {
                    request.setAttribute("errorMsg", "해당 여행 플랜을 찾을 수 없습니다.");
                } else {
                    TravelResponseDTO result = TravelJsonParser.parse(savedPlan.getResponseJson());

                    session.setAttribute("latestTravelResult", result);
                    request.setAttribute("savedPlan", savedPlan);
                    request.setAttribute("result", result);
                }

            } catch (Exception e) {
                e.printStackTrace();
                request.setAttribute("errorMsg", "여행 플랜을 불러오는 중 오류가 발생했습니다.");
            }

            request.setAttribute("content", "view/resultpage/resultpage.jsp");
            request.getRequestDispatcher("index.jsp").forward(request, response);
        }
        }



    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setAttribute("content", "view/resultpage/resultpage.jsp");
        request.getRequestDispatcher("index.jsp").forward(request, response);
    }


    public void destroy() {
    }
}