package com.es.ta.resultpage;

import com.es.ta.account.AccountDTO;
import com.es.ta.ai.TravelRequestDto;
import com.es.ta.ai.TravelResponseDto;
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

        String planIdParam = request.getParameter("planId");

        if (planIdParam != null && !planIdParam.isEmpty()) {
            try {
                int planId = Integer.parseInt(planIdParam);

                HttpSession session = request.getSession();
                AccountDTO loginUser = (AccountDTO) session.getAttribute("user");

                if (loginUser != null) {
                    int userId = loginUser.getUser_id();

                    TravelPlanDTO savedPlan = TravelPlanDAO.getPlanByPlanIdAndUserId(planId, userId);

                    if (savedPlan != null) {
                        TravelResponseDTO result = TravelJsonParser.parse(savedPlan.getResponseJson());

                        request.setAttribute("savedPlan", savedPlan);
                        request.setAttribute("result", result);
                    }
                }
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
        request.setAttribute("content", "view/resultpage/resultpage.jsp");
        request.getRequestDispatcher("index.jsp").forward(request, response);

    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

//        int id = Integer.parseInt(request.getParameter("id"));
//
//        TravelRequestDto result = ResultpageDAO.detailpage(id);
//
//        request.setAttribute("result", result);
//        request.setAttribute("content", "view/detailpage/detailpage.jsp");
//        request.getRequestDispatcher("index.jsp").forward(request, response);
// detail page C로 get요청 할꺼임


    }

    public void destroy() {
    }
}