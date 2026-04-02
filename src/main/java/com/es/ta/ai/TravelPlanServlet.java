package com.es.ta.ai;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.Arrays;

@WebServlet("/planner/result")
public class TravelPlanServlet extends HttpServlet {

    private final TravelDao travelDao = new TravelDao();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        try {
            // 1. 파라미터 추출 및 DTO 생성
            TravelRequestDto dto = TravelRequestDto.builder()
                    .destination(req.getParameter("destination"))
                    .startDate(req.getParameter("startDate"))
                    .endDate(req.getParameter("endDate"))
                    .travelers(Integer.parseInt(req.getParameter("travelers")))
                    .minbudget(Integer.parseInt(req.getParameter("min-budget")))
                    .maxbudget(Integer.parseInt(req.getParameter("max-budget")))
                    .styles(Arrays.asList("healing", "food")) // 기본값 또는 추가 파라미터 처리
                    .themes(Arrays.asList("shopping", "cafe"))
                    .build();

            // 2. DAO를 통한 로그 기록 (Real Path 전달)
            String logPath = req.getServletContext().getRealPath("/json");
            travelDao.saveRequestLog(dto, logPath);

            // 3. DAO를 통한 AI 데이터 획득
            TravelResponseDto result = travelDao.fetchTravelPlan(dto);

            // 4. 결과 검증 및 응답 제어
            if (result == null || !result.isSuccess()) {
                String errorMsg = (result != null) ? result.getMessage() : "AI 응답 실패";
                req.setAttribute("error", errorMsg);
            } else {
                req.setAttribute("result", result);
            }

            req.setAttribute("result", result);
            req.setAttribute("content", "view/resultpage/resultpage.jsp");
            req.getRequestDispatcher("/index.jsp").forward(req, resp);

        } catch (Exception e) {
            e.printStackTrace();
            req.setAttribute("error", "서버 처리 중 오류 발생: " + e.getMessage());
            req.getRequestDispatcher("/result.jsp").forward(req, resp);
        }
    }
}
