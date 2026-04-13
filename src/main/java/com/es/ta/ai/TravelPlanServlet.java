package com.es.ta.ai;

import com.es.ta.account.AccountDTO;
import com.fasterxml.jackson.databind.ObjectMapper;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.ServletContext;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.InputStream;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;
import java.util.Properties;

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
            String traceId = "TP-" + System.currentTimeMillis();
            req.setAttribute("traceId", traceId);
            System.out.println("[" + traceId + "] TravelPlanServlet.doGet START " + LocalDateTime.now());
            System.out.println("[" + traceId + "] URI=" + req.getRequestURI() + " QUERY=" + req.getQueryString());

            // 폼에서 `travelStyle` 체크박스 여러 개 → 동일 이름 반복 파라미터로 전달됨
            List<String> styles = readMultiValue(req, "styles", "style", "travelStyle");
            List<String> themes = readMultiValue(req, "themes", "theme", "moods", "mood");
            List<String> customTags = readMultiValue(req, "customTag", "customTags");

            int minB = parseInt(req.getParameter("min-budget"), 0);
            int maxB = parseInt(req.getParameter("max-budget"), 0);
            int budget = parseInt(req.getParameter("budget"), maxB > 0 ? maxB : (minB > 0 ? minB : 1_000_000));

            // 1. 요청 DTO 생성 (styles/themes는 폼 파라미터 — 하드코딩 금지)
            TravelRequestDto requestDto = TravelRequestDto.builder()
                    .destination(req.getParameter("destination"))
                    .startDate(req.getParameter("startDate"))
                    .endDate(req.getParameter("endDate"))
                    .travelers(parseInt(req.getParameter("travelers"), 1))
                    .budget(budget)
                    .tripType(firstNonBlank(req.getParameter("tripType"), "ROUND_TRIP"))
                    .minbudget(minB)
                    .maxbudget(maxB)
                    .styles(styles)
                    .themes(themes)
                    .customTag(customTags)
                    .build();
            System.out.println("[" + traceId + "] requestDto created: destination=" + requestDto.getDestination()
                    + ", startDate=" + requestDto.getStartDate()
                    + ", endDate=" + requestDto.getEndDate()
                    + ", travelers=" + requestDto.getTravelers()
                    + ", styles=" + requestDto.getStyles()
                    + ", themes=" + requestDto.getThemes());

            // 2. 요청 로그 저장
            String logPath = req.getServletContext().getRealPath("/json");
            travelDao.saveRequestLog(requestDto, logPath);
            System.out.println("[" + traceId + "] request log saved path=" + logPath);

            // 3. AI 응답 받기
            System.out.println("[" + traceId + "] calling TravelDao.fetchTravelPlan()");
            TravelResponseDto result = travelDao.fetchTravelPlan(requestDto);
            System.out.println("[" + traceId + "] fetchTravelPlan completed. resultNull=" + (result == null)
                    + ", success=" + (result != null && result.isSuccess()));

            // 4. 응답 JSON 문자열 만들기
            String responseJson = objectMapper.writeValueAsString(result);
            System.out.println("[" + traceId + "] responseJson length=" + responseJson.length());

            // 5. DB 저장
            if (result != null) {
                try {
                    // 세션에서 사용자 정보 조회
                    AccountDTO user = (AccountDTO) req.getSession().getAttribute("user");
                    Integer userId = (user != null) ? user.getUser_id() : null;
                    
                    System.out.println("[" + traceId + "] calling TravelDao.insertTravelPlan() with userId=" + userId);
                    travelDao.insertTravelPlan(requestDto, result, responseJson, userId);
                    System.out.println("[" + traceId + "] insertTravelPlan completed");
                } catch (Exception dbError) {
                    dbError.printStackTrace();
                    System.out.println("[" + traceId + "] insertTravelPlan failed: " + dbError.getMessage());
                    req.setAttribute("dbWarning", "일정 생성은 성공했지만 DB 저장에는 실패했습니다.");
                }
            }


            try {
                String jsonDir = req.getServletContext().getRealPath("/json/response");
                java.nio.file.Path dirPath = java.nio.file.Paths.get(jsonDir);

                // 디렉토리 없으면 생성
                java.nio.file.Files.createDirectories(dirPath);

                // 파일명: traceId 기반
                String fileName = "response_" + traceId + ".json";
                java.nio.file.Path filePath = dirPath.resolve(fileName);

                // JSON 저장
                java.nio.file.Files.writeString(
                        filePath,
                        responseJson,
                        java.nio.charset.StandardCharsets.UTF_8
                );

                System.out.println("[" + traceId + "] JSON 파일 저장 완료: " + filePath);

            } catch (Exception fileError) {
                fileError.printStackTrace();
                System.out.println("[" + traceId + "] JSON 파일 저장 실패: " + fileError.getMessage());
            }

            // 6. 화면 전달
            if (result == null || !result.isSuccess()) {
                String errorMsg = (result != null) ? result.getMessage() : "AI 응답 실패";
                req.setAttribute("error", errorMsg);
            } else {
                req.setAttribute("result", result);
            }

            attachGoogleMapsConfig(req);
            req.setAttribute("content", "view/resultpage/resultpage.jsp");
            System.out.println("[" + traceId + "] forwarding to /index.jsp");
            req.getRequestDispatcher("/index.jsp").forward(req, resp);

        } catch (Exception e) {
            e.printStackTrace();
            System.out.println("[TravelPlanServlet] ERROR: " + e.getMessage());
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

    private static String firstNonBlank(String a, String fallback) {
        return (a != null && !a.isBlank()) ? a.trim() : fallback;
    }

    /**
     * 동일 이름 반복(styles=a&styles=b) 또는 쉼표 구분(styles=a,b) 모두 지원.
     */
    private static List<String> readMultiValue(HttpServletRequest req, String... names) {
        for (String name : names) {
            String[] values = req.getParameterValues(name);
            if (values != null && values.length > 0) {
                List<String> out = new ArrayList<>();
                for (String value : values) {
                    if (value == null || value.isBlank()) {
                        continue;
                    }
                    for (String part : value.split(",")) {
                        String t = part.trim();
                        if (!t.isEmpty()) {
                            out.add(t);
                        }
                    }
                }
                if (!out.isEmpty()) {
                    return out;
                }
            }
            String single = req.getParameter(name);
            if (single != null && !single.trim().isEmpty()) {
                List<String> out = new ArrayList<>();
                for (String part : single.split(",")) {
                    String t = part.trim();
                    if (!t.isEmpty()) {
                        out.add(t);
                    }
                }
                if (!out.isEmpty()) {
                    return out;
                }
            }
        }
        return Collections.emptyList();
    }

    private void attachGoogleMapsConfig(HttpServletRequest req) {
        Properties props = loadApplicationProperties(req.getServletContext());
        req.setAttribute("googleMapsApiKey", props.getProperty("GOOGLE_API_KEY", ""));
        req.setAttribute("googleMapsMapId", props.getProperty("GOOGLE_MAP_ID", ""));
    }

    private Properties loadApplicationProperties(ServletContext context) {
        Properties props = new Properties();

        try (InputStream in = context.getResourceAsStream("/WEB-INF/application.properties")) {
            if (in == null) {
                return props;
            }
            props.load(in);
        } catch (IOException e) {
            System.out.println("[TravelPlanServlet] application.properties load failed: " + e.getMessage());
        }

        return props;
    }


}
