package com.es.ta.mypage;

import com.es.ta.account.AccountDTO;

import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet("/settings")
@MultipartConfig(
        fileSizeThreshold = 1024 * 1024,
        maxFileSize = 1024 * 1024 * 5,
        maxRequestSize = 1024 * 1024 * 25
)
public class SettingsC extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        AccountDTO loginUser = (AccountDTO) session.getAttribute("user");

        if (loginUser == null) {
            response.sendRedirect("login");
            return;
        }

        AccountDTO userInfo = SettingsDAO.getUserInfo(request);
        request.setAttribute("userInfo", userInfo);

        request.setAttribute("content", "view/mypage/settings.jsp");
        request.getRequestDispatcher("index.jsp").forward(request, response);
    }
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("utf-8");

        HttpSession session = request.getSession();
        AccountDTO loginUser = (AccountDTO) session.getAttribute("user");

        if (loginUser == null) {
            response.sendRedirect("login");
            return;
        }

        String action = request.getParameter("action");

        if ("delete".equals(action)) {
            boolean result = SettingsDAO.deleteUser(request);

            if (result) {
                response.sendRedirect(request.getContextPath() + "/");
            } else {
                request.setAttribute("error", "회원 탈퇴 실패");
                request.setAttribute("content", "view/mypage/settings.jsp");
                request.getRequestDispatcher("index.jsp").forward(request, response);
            }
            return;
        }

        boolean result = SettingsDAO.updateUserInfo(request);

        if (result) {
            response.sendRedirect(request.getContextPath() + "/mypage?settingsSuccess=1");
        } else {
            request.setAttribute("error", "회원정보 수정 실패");
            request.setAttribute("content", "view/mypage/settings.jsp");
            request.getRequestDispatcher("index.jsp").forward(request, response);
        }
}
}
