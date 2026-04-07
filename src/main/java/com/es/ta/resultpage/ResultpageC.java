package com.es.ta.resultpage;

import com.es.ta.ai.TravelRequestDto;
import com.es.ta.ai.TravelResponseDto;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet(name = "ResultpageC", value = "/result-page")
public class ResultpageC extends HttpServlet {

    public void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {


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