package com.es.ta.resultpage;

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

        request.setAttribute("content", "view/resultpage/scheduleEdit.jsp");
        request.getRequestDispatcher("index.jsp").forward(request, response);



    }

    public void destroy() {
    }
}