package com.es.ta.resultpage;

import com.es.ta.account.AccountDTO;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet(name = "EditPlanC", value = "/edit-plan")
public class EditPlanC extends HttpServlet {

    @Override
    public void doGet(HttpServletRequest request, HttpServletResponse response)
            throws IOException, ServletException {

        HttpSession session = request.getSession(false);

        // ── 로그인 체크 ──
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        // ── MyPlanPageC 에서 저장해둔 결과 꺼내기 ──
        TravelResultVDTO result = (TravelResultVDTO) session.getAttribute("latestTravelResult");

        if (result == null) {
            // 세션 만료 or 직접 URL 접근
            response.sendRedirect(request.getContextPath() + "/mypage");
            return;
        }

        request.setAttribute("result", result);
        request.setAttribute("content", "view/resultpage/scheduleEdit.jsp");
        request.getRequestDispatcher("index.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        // 저장 후 결과 페이지로 복귀
        // 필요 시 여기서 DB 업데이트 로직 추가
        response.sendRedirect(request.getContextPath() + "/myplan-page?id="
                + request.getParameter("planId"));
    }
}