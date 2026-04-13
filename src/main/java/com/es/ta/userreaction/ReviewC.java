package com.es.ta.userreaction;

import com.es.ta.account.AccountDTO;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.net.URLEncoder;

@WebServlet(name = "ReviewC", value = "/review")
public class ReviewC extends HttpServlet {

    public void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        AccountDTO user = (AccountDTO) request.getSession().getAttribute("user");
        if (user == null) {
            String planId = request.getParameter("planId");
            String returnUrl = "/detail-page" + (planId == null || planId.trim().isEmpty() ? "" : "?id=" + planId);
            response.sendRedirect(request.getContextPath() + "/login?returnUrl=" + URLEncoder.encode(returnUrl, "UTF-8"));
            return;
        }

        String action = request.getParameter("action");
        String planId = request.getParameter("planId");

        if ("delete".equals(action)) {
            deleteReview(request, user);
            response.sendRedirect(request.getContextPath() + "/detail-page?id=" + planId + "&reviewDeleted=true");
            return;
        }

        UserreactionDAO.userreview(request);
        response.sendRedirect(request.getContextPath() + "/detail-page?id=" + planId + "&reviewSuccess=true");
    }

    private void deleteReview(HttpServletRequest request, AccountDTO user) {
        try {
            int reviewId = Integer.parseInt(request.getParameter("reviewId"));
            int planId = Integer.parseInt(request.getParameter("planId"));

            UserreactionDAO.deleteReviewByOwner(reviewId, planId, user.getUser_id());
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
