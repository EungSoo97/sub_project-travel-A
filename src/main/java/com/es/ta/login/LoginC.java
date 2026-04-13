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
        request.setAttribute("returnUrl", normalizeReturnUrl(request.getParameter("returnUrl")));
        request.setAttribute("content", "view/login/login.jsp");
        request.getRequestDispatcher("index.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        String returnUrl = normalizeReturnUrl(request.getParameter("returnUrl"));
        boolean success = AccountDAO.loginProcess(request);

        if (success) {
            response.sendRedirect(request.getContextPath() + returnUrl);
            return;
        }

        request.setAttribute("loginError", "아이디 또는 비밀번호가 올바르지 않습니다.");
        request.setAttribute("returnUrl", returnUrl);
        request.setAttribute("content", "view/login/login.jsp");
        request.getRequestDispatcher("index.jsp").forward(request, response);
    }

    public void destroy() {
    }

    private String normalizeReturnUrl(String returnUrl) {
        if (returnUrl == null || returnUrl.trim().isEmpty()) {
            return "/";
        }

        String value = returnUrl.trim();
        if (!value.startsWith("/") || value.startsWith("//") || value.contains("://")) {
            return "/";
        }

        return value;
    }
}
