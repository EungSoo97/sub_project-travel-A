package com.es.ta.image;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet(name = "image", value = "/image-page")
public class ImageC extends HttpServlet {

    public void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {


        imageDAO.addfunction(request);


        request.getRequestDispatcher("index.jsp").forward(request,response);
    }

    public void destroy() {
    }
}