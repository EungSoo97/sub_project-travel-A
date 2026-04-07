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
