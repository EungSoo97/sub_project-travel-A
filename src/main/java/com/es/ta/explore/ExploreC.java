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


    public void doGet(HttpServletRequest request, HttpServletResponse response)
            throws IOException, ServletException {

        // 🔥 1. 검색어 받기
        String q = request.getParameter("q");

        List<TravelResultVDTO> planList;

        // 🔥 2. 검색 여부 판단
        if (q != null && !q.trim().isEmpty()) {
            planList = ResultpageDAO.searchPlan(q);   // 🔥 검색
        } else {
            planList = ResultpageDAO.getPlanList();   // 🔥 전체
        }

        request.setAttribute("planList", planList);

        // 🔥 태그는 그대로
        List<String> tagList = ExploreDAO.getPopularTags();
        System.out.println("tagList = " + tagList);
        request.setAttribute("tagList", tagList);

        request.setAttribute("content", "view/explore/explore.jsp");
        request.getRequestDispatcher("index.jsp").forward(request, response);
    }
    }