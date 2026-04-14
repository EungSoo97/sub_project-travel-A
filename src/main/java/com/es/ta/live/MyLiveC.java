package com.es.ta.live;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet(name = "MyLiveC", value = "/my-live")
public class MyLiveC extends HttpServlet {

    public void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {


        String planId = request.getParameter("planId");

        System.out.println("planId: " + request.getParameter("planId"));
        System.out.println("destination: " + request.getParameter("destination"));

        request.setAttribute("planId", planId);

        request.setAttribute("content","view/live/myLive.jsp");
        request.getRequestDispatcher("index.jsp").forward(request,response);

    }

    public void destroy() {
    }
}