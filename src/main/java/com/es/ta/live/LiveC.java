package com.es.ta.live;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet(name = "LiveC", value = "/live")
public class LiveC extends HttpServlet {

    public void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {

        request.setAttribute("content","view/live/live.jsp");
        request.getRequestDispatcher("index.jsp").forward(request,response);

    }

    public void destroy() {
    }
}