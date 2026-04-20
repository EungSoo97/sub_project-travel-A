package com.es.ta.resultpage;

import com.es.ta.common.GoogleMapsConfig;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet(name = "ResultDraftC", value = "/result-draft")
public class ResultDraftC extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        TravelResultVDTO result = session != null
                ? (TravelResultVDTO) session.getAttribute("latestTravelResult")
                : null;

        if (result == null) {
            response.sendRedirect(request.getContextPath() + "/main");
            return;
        }

        GoogleMapsConfig.attach(request);
        request.setAttribute("result", result);
        request.setAttribute("content", "view/resultpage/resultpage.jsp");
        request.getRequestDispatcher("index.jsp").forward(request, response);
    }
}
