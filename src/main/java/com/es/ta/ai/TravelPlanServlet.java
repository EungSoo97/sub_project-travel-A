package com.es.ta.ai;

import com.fasterxml.jackson.databind.ObjectMapper;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.Arrays;
import java.util.Collections;
import java.util.List;

@WebServlet("/planner/result")
public class TravelPlanServlet extends HttpServlet {

    private final TravelDao travelDao = new TravelDao();
    private final ObjectMapper objectMapper = new ObjectMapper();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        req.setCharacterEncoding("UTF-8");
        resp.setCharacterEncoding("UTF-8");
        resp.setContentType("text/html; charset=UTF-8");

        try {
            String[] customTagsArr = req.getParameterValues("customTag");

            List<String> customTags = (customTagsArr != null)
                    ? Arrays.asList(customTagsArr)
                    : Collections.emptyList();

            // 1. 요청 DTO 생성
            TravelRequestDto requestDto = TravelRequestDto.builder()
                    .destination(req.getParameter("destination"))
                    .startDate(req.getParameter("startDate"))
                    .endDate(req.getParameter("endDate"))
                    .travelers(parseInt(req.getParameter("travelers"), 1))
                    .minbudget(parseInt(req.getParameter("min-budget"), 0))
                    .maxbudget(parseInt(req.getParameter("max-budget"), 0))
                    .styles(Arrays.asList("healing", "food"))
                    .themes(Arrays.asList("shopping", "cafe"))
                    .customTag(customTags)
                    .build();

            // 2. 요청 로그 저장
            String logPath = req.getServletContext().getRealPath("/json");
            travelDao.saveRequestLog(requestDto, logPath);

            // 3. AI 응답 받기
            TravelResponseDto result = travelDao.fetchTravelPlan(requestDto);

            // 4. 응답 JSON 문자열 만들기
            String responseJson = objectMapper.writeValueAsString(result);

            // 5. DB 저장
            if (result != null) {
                try {
                    travelDao.insertTravelPlan(requestDto, result, responseJson);
                } catch (Exception dbError) {
                    dbError.printStackTrace();
                    req.setAttribute("dbWarning", "일정 생성은 성공했지만 DB 저장에는 실패했습니다.");
                }
            }

            // 6. 화면 전달
            if (result == null || !result.isSuccess()) {
                String errorMsg = (result != null) ? result.getMessage() : "AI 응답 실패";
                req.setAttribute("error", errorMsg);
            } else {
                req.setAttribute("result", result);
            }

            req.setAttribute("content", "view/resultpage/resultpage.jsp");
            req.getRequestDispatcher("/index.jsp").forward(req, resp);

        } catch (Exception e) {
            e.printStackTrace();
            req.setAttribute("error", "서버 처리 중 오류 발생: " + e.getMessage());
            req.getRequestDispatcher("/result.jsp").forward(req, resp);
        }
    }

    private int parseInt(String value, int defaultValue) {
        try {
            return (value == null || value.trim().isEmpty()) ? defaultValue : Integer.parseInt(value);
        } catch (Exception e) {
            return defaultValue;
        }
    }
}
