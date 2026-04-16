package com.es.ta.mypage;

import com.es.ta.account.AccountDTO;
import com.es.ta.common.GoogleMapsConfig;
import com.es.ta.resultpage.TravelJsonParser;
import com.es.ta.resultpage.TravelResultVDTO;
import com.es.ta.userreaction.UserreactionDAO;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet(name = "myplanpage", value = "/myplan-page")
public class MyPlanPageC extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws IOException, ServletException {

        HttpSession session = request.getSession(false);
        response.setHeader("Cache-Control", "no-store, no-cache, must-revalidate, max-age=0");
        response.setHeader("Pragma", "no-cache");
        response.setDateHeader("Expires", 0);

        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        AccountDTO loginUser = (AccountDTO) session.getAttribute("user");
        Integer planId = parsePlanId(request.getParameter("id"));
        if (planId == null) {
            response.sendRedirect(request.getContextPath() + "/mypage");
            return;
        }

        TravelPlanDTO savedPlan = MyPlanPageDAO.getPlanByPlanIdAndUserId(planId, loginUser.getUser_id());
        if (savedPlan == null) {
            response.sendRedirect(request.getContextPath() + "/mypage");
            return;
        }

        boolean liked = new UserreactionDAO().existsStar(savedPlan.getPlanId(), loginUser.getUser_id());

        TravelResultVDTO result = TravelJsonParser.parse(savedPlan.getResponseJson());
        if (result == null) {
            request.setAttribute("errorMsg", "여행 계획을 불러오지 못했습니다.");
            request.setAttribute("content", "view/mypage/mypage.jsp");
            request.getRequestDispatcher("index.jsp").forward(request, response);
            return;
        }
        result.setLikeCnt(savedPlan.getLikeCnt());
        result.setUserName(savedPlan.getCreatorName());

        GoogleMapsConfig.attach(request);

        session.setAttribute("latestTravelResult", result);

        request.setAttribute("savedPlan", savedPlan);
        request.setAttribute("result", result);
        request.setAttribute("liked", liked);
        request.setAttribute("canPostPlan", savedPlan.getOriginalUserId() == 0 || savedPlan.getCopiedModified() == 1);
        request.setAttribute("content", "view/mypage/myplanpage.jsp");
        request.getRequestDispatcher("index.jsp").forward(request, response);
    }

    private Integer parsePlanId(String value) {
        try {
            return Integer.parseInt(value);
        } catch (Exception e) {
            return null;
        }
    }
}
