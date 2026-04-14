package com.es.ta.explore;

import com.es.ta.resultpage.ResultpageDAO;
import com.es.ta.resultpage.TravelResultVDTO;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet(name = "ExploreC", value = "/explore")
public class ExploreC extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws IOException, ServletException {

        request.setCharacterEncoding("UTF-8");

        String q = request.getParameter("q");
        String selectedTags = request.getParameter("selectedTags");
        System.out.println("q = " + q);
        System.out.println("selectedTags = " + selectedTags);
        boolean hasQ = q != null && !q.trim().isEmpty();
        boolean hasSelectedTags = selectedTags != null && !selectedTags.trim().isEmpty();

        List<TravelResultVDTO> planList;

        if (hasQ || hasSelectedTags) {
            planList = ExploreDAO.searchPlans(q, selectedTags);
        } else {
            planList = ResultpageDAO.getPlanList();
        }

        request.setAttribute("planList", planList);
        request.setAttribute("tagList", ExploreDAO.getPopularTags());

        request.setAttribute("content", "view/explore/explore.jsp");
        request.getRequestDispatcher("index.jsp").forward(request, response);
    }
}