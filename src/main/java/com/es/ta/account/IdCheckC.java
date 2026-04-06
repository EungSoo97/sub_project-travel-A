package com.es.ta.account;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
@WebServlet(name = "IdCheckC", value = "/idcheck")
public class IdCheckC extends HttpServlet {

    public void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
        System.out.println("json id 요청(get)");
        response.setContentType("application/json; charset=UTF-8");

        String loginId = request.getParameter("login_id");
        int count = AccountDAO.idcheck(loginId);

        response.getWriter().write(String.valueOf(count));
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
    }

    public void destroy() {
    }
}