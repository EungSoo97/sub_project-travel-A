package com.es.ta.login;

import com.es.ta.account.AccountDAO;

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
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        boolean success = AccountDAO.loginProcess(request);
        if (success) {
            // 로그인 성공 → 메인으로
            response.sendRedirect(request.getContextPath() + "/");
        } else {
            // 로그인 실패 → 로그인 페이지 재표시 + 오류 메시지
            request.setAttribute("loginError", "아이디 또는 비밀번호가 올바르지 않습니다.");
            request.setAttribute("content", "view/login/login.jsp");
            request.getRequestDispatcher("index.jsp").forward(request, response);
        }
    }

    public void destroy() {
    }
}