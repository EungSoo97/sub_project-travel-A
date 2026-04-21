package com.es.ta.live;

import com.es.ta.ai.FastApiService;

import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.net.URI;
import java.net.URLEncoder;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.nio.charset.StandardCharsets;
import java.time.Duration;
import java.util.stream.Collectors;

/**
 * 브라우저 → 동일 출처 GET → FastAPI {@code GET /api/v1/live-travel/dashboard} 프록시.
 * (CORS 없이 Live 대시보드 JSON을 JSP/JS에서 사용)
 */
@WebServlet(name = "LiveDashboardC", value = "/live/dashboard-data")
public class LiveDashboardC extends HttpServlet {

    private static final Duration TIMEOUT = Duration.ofSeconds(60);

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException {
        response.setCharacterEncoding(StandardCharsets.UTF_8.name());

        String planId = request.getParameter("planId");
        if (planId == null || planId.isBlank()) {
            planId = "1";
        }
        String day = request.getParameter("day");
        String activityId = request.getParameter("activityId");
        String destination = request.getParameter("destination");
        // 선택된 activity 의 좌표 — FastAPI 가 위치 기반 추천·교통을 산출할 때 사용.
        String lat = request.getParameter("lat");
        String lng = request.getParameter("lng");

        StringBuilder url = new StringBuilder(FastApiService.resolveFastApiBaseUrl());
        if (!url.toString().endsWith("/")) {
            url.append("/");
        }
        url.append("live-travel/dashboard?planId=").append(URLEncoder.encode(planId.trim(), StandardCharsets.UTF_8));
        if (day != null && !day.isBlank()) {
            url.append("&day=").append(URLEncoder.encode(day.trim(), StandardCharsets.UTF_8));
        }
        if (activityId != null && !activityId.isBlank()) {
            url.append("&activityId=").append(URLEncoder.encode(activityId.trim(), StandardCharsets.UTF_8));
        }
        if (destination != null && !destination.isBlank()) {
            url.append("&destination=").append(URLEncoder.encode(destination.trim(), StandardCharsets.UTF_8));
        }
        if (lat != null && !lat.isBlank()) {
            url.append("&lat=").append(URLEncoder.encode(lat.trim(), StandardCharsets.UTF_8));
        }
        if (lng != null && !lng.isBlank()) {
            url.append("&lng=").append(URLEncoder.encode(lng.trim(), StandardCharsets.UTF_8));
        }

        try {
            HttpRequest httpRequest = HttpRequest.newBuilder()
                    .uri(URI.create(url.toString()))
                    .header("Accept", "application/json")
                    .timeout(TIMEOUT)
                    .GET()
                    .build();

            HttpClient client = HttpClient.newBuilder()
                    .version(HttpClient.Version.HTTP_1_1)
                    .connectTimeout(Duration.ofSeconds(10))
                    .build();

            HttpResponse<String> httpResponse = client.send(httpRequest, HttpResponse.BodyHandlers.ofString(StandardCharsets.UTF_8));

            response.setContentType("application/json;charset=UTF-8");
            response.setStatus(httpResponse.statusCode());
            response.getWriter().write(httpResponse.body());
        } catch (InterruptedException e) {
            Thread.currentThread().interrupt();
            writeError(response, 502, "Live dashboard 요청이 중단되었습니다.");
        } catch (Exception e) {
            e.printStackTrace();
            writeError(response, 502, "FastAPI Live 대시보드를 불러오지 못했습니다: " + e.getMessage());
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        response.setContentType("application/json; charset=UTF-8");

        String body = request.getReader().lines().collect(Collectors.joining("\n"));
        if (body == null || body.trim().isEmpty()) {
            writeError(response, 400, "EMPTY_REQUEST_BODY: 실시간 여행 요청 본문이 비어 있습니다.");
            return;
        }

        try {
            StringBuilder url = new StringBuilder(FastApiService.resolveFastApiBaseUrl());
            if (!url.toString().endsWith("/")) {
                url.append('/');
            }
            url.append("live-travel/dashboard");

            HttpRequest fastApiRequest = HttpRequest.newBuilder()
                    .uri(URI.create(url.toString()))
                    .timeout(TIMEOUT)
                    .header("Accept", "application/json")
                    .header("Content-Type", "application/json; charset=UTF-8")
                    .POST(HttpRequest.BodyPublishers.ofString(body, StandardCharsets.UTF_8))
                    .build();

            HttpClient client = HttpClient.newBuilder()
                    .version(HttpClient.Version.HTTP_1_1)
                    .connectTimeout(Duration.ofSeconds(10))
                    .build();

            HttpResponse<String> fastApiResponse = client.send(fastApiRequest, HttpResponse.BodyHandlers.ofString(StandardCharsets.UTF_8));
            response.setStatus(fastApiResponse.statusCode());
            response.getWriter().write(fastApiResponse.body());
        } catch (IllegalStateException e) {
            writeError(response, 500, "FASTAPI_URL_NOT_CONFIGURED: " + e.getMessage());
        } catch (InterruptedException e) {
            Thread.currentThread().interrupt();
            writeError(response, 504, "FASTAPI_REQUEST_INTERRUPTED: FastAPI 실시간 여행 요청이 중단되었습니다.");
        } catch (Exception e) {
            writeError(response, 502, "FASTAPI_DASHBOARD_POST_FAILED: " + e.getMessage());
        }
    }
    private static void writeError(HttpServletResponse response, int status, String message) throws IOException {
        response.setStatus(status);
        response.setContentType("application/json;charset=UTF-8");
        String escaped = message
                .replace("\\", "\\\\")
                .replace("\"", "\\\"")
                .replace("\n", " ")
                .replace("\r", " ");
        response.getWriter().write("{\"success\":false,\"message\":\"" + escaped + "\"}");
    }
}
