package com.es.ta.account;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet(name = "AccountC", value = "/account")
public class AccountC extends HttpServlet {

    public void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {

        request.setAttribute("content", "view/account/account.jsp");
        request.getRequestDispatcher("index.jsp").forward(request, response);

    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("utf-8");

        boolean created = AccountDAO.newuser(request);
        if (!created) {
            request.setAttribute("accountError", "회원가입에 실패했습니다. 아이디나 이메일 중복 여부를 확인해주세요.");
            request.setAttribute("content", "view/account/account.jsp");
            request.getRequestDispatcher("index.jsp").forward(request, response);
            return;
        }

        request.setAttribute("content", "view/main/home.jsp");
        request.getRequestDispatcher("index.jsp").forward(request, response);
    }

    public void destroy() {
    }
}
