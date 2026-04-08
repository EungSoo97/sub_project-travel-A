package com.es.ta.mypage;

import com.es.ta.account.AccountDTO;
import com.es.ta.resultpage.TravelJsonParser;
import com.es.ta.resultpage.TravelResultVDTO;

import javax.servlet.ServletContext;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.io.InputStream;
import java.util.Properties;

@WebServlet(name = "myplanpage", value = "/myplan-page")
public class MyPlanPageC extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
        request.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession(false);
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

        TravelResultVDTO result = TravelJsonParser.parse(savedPlan.getResponseJson());
        if (result == null) {
            request.setAttribute("errorMsg", "여행 계획을 불러오지 못했습니다.");
            request.setAttribute("content", "view/mypage/mypage.jsp");
            request.getRequestDispatcher("index.jsp").forward(request, response);
            return;
        }

        attachGoogleMapsConfig(request);
        session.setAttribute("latestTravelResult", result);
        request.setAttribute("savedPlan", savedPlan);
        request.setAttribute("result", result);
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

    private void attachGoogleMapsConfig(HttpServletRequest request) {
        Properties props = loadApplicationProperties(request.getServletContext());
        request.setAttribute("googleMapsApiKey", props.getProperty("GOOGLE_API_KEY", ""));
        request.setAttribute("googleMapsMapId", props.getProperty("GOOGLE_MAP_ID", ""));
    }

    private Properties loadApplicationProperties(ServletContext context) {
        Properties props = new Properties();

        try (InputStream in = context.getResourceAsStream("/WEB-INF/application.properties")) {
            if (in == null) {
                return props;
            }
            props.load(in);
        } catch (IOException e) {
            System.out.println("[MyPlanPageC] application.properties load failed: " + e.getMessage());
        }

        return props;
    }
}
