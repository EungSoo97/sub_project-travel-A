package com.es.ta.userreaction;


import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet(name = "ReviewC", value = "/review")
public class ReviewC extends HttpServlet {

    public void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
        // 좋아요 저장


    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        // 후기 저장
        // 로그인 체크
        if (request.getSession().getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        UserreactionDAO.userreview(request);
        String planId = request.getParameter("planId");
        response.sendRedirect(request.getContextPath() + "/detail-page?id=" + planId + "&reviewSuccess=true");
    }
}
