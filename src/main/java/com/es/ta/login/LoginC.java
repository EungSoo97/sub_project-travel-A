package com.es.ta.login;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet(name = "LoginC", value = "/login")
public class LoginC extends HttpServlet {
    public void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {

        request.setAttribute("content", "view/login/login.jsp");
        request.getRequestDispatcher("index.jsp").forward(request, response);

    }

    public void destroy() {
    }
}