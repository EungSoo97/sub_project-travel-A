package com.es.ta.ai;

import com.fasterxml.jackson.databind.ObjectMapper;

import java.net.ConnectException;
import java.net.URI;
import java.net.http.HttpClient;
import java.net.http.HttpConnectTimeoutException;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.net.http.HttpTimeoutException;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.time.Duration;

public class FastApiService {

    private static final String DEFAULT_FAST_API_URL = "http://127.0.0.1:8000/api/v1/travel/plan";

    public static TravelResponseDto callFastApi(TravelRequestDto dto) {
        try {
            ObjectMapper mapper = new ObjectMapper();
            String json = mapper.writeValueAsString(dto);
            String fastApiUrl = resolveFastApiUrl();

            System.out.println("[FastApiService] callFastApi START");
            System.out.println("Request JSON = " + json);
            System.out.println("FastAPI URL = " + fastApiUrl);

            Path jsonDir = Paths.get(System.getProperty("java.io.tmpdir"), "travelA-debug-json");
            Files.createDirectories(jsonDir);
            System.out.println("Debug JSON dir = " + jsonDir.toAbsolutePath());

            Path requestPath = jsonDir.resolve("request.json");
            Files.writeString(requestPath, json, StandardCharsets.UTF_8);

            HttpRequest request = HttpRequest.newBuilder()
                    .uri(URI.create(fastApiUrl))
                    .header("Content-Type", "application/json; charset=UTF-8")
                    .header("Accept", "application/json")
                    .timeout(Duration.ofSeconds(300))
                    .POST(HttpRequest.BodyPublishers.ofString(json, StandardCharsets.UTF_8))
                    .build();

            HttpClient client = HttpClient.newBuilder()
                    .version(HttpClient.Version.HTTP_1_1)
                    .connectTimeout(Duration.ofSeconds(5))
                    .build();

            System.out.println("[FastApiService] sending HTTP request to FastAPI");
            HttpResponse<String> response =
                    client.send(request, HttpResponse.BodyHandlers.ofString(StandardCharsets.UTF_8));

            System.out.println("====== RESPONSE RECEIVED ======");
            System.out.println("Response status = " + response.statusCode());
            System.out.println("Response body = " + response.body());

            if (response.statusCode() != 200) {
                throw new RuntimeException("FastAPI returned status code: " + response.statusCode() + " body: " + response.body());
            }

            String responseBody = response.body();
            Path responsePath = jsonDir.resolve("result.json");
            Files.writeString(responsePath, responseBody, StandardCharsets.UTF_8);

            TravelResponseDto parsed = mapper.readValue(responseBody, TravelResponseDto.class);
            System.out.println("[FastApiService] callFastApi END parseSuccess=true");
            return parsed;

        } catch (HttpConnectTimeoutException e) {
            System.out.println("[FastApiService] CONNECT TIMEOUT: " + e.getMessage());
            throw new RuntimeException("Could not connect to FastAPI before the connect timeout. Check host/port and whether the FastAPI server is running.", e);
        } catch (HttpTimeoutException e) {
            System.out.println("[FastApiService] REQUEST TIMEOUT: " + e.getMessage());
            throw new RuntimeException("FastAPI request timed out. Check whether the FastAPI server is running and responding.", e);
        } catch (ConnectException e) {
            System.out.println("[FastApiService] CONNECT ERROR: " + e.getMessage());
            throw new RuntimeException("Could not connect to FastAPI. Check host/port and whether the FastAPI server is running.", e);
        } catch (Exception e) {
            e.printStackTrace();
            System.err.println("FastApiService communication error: " + e.getMessage());
            System.out.println("[FastApiService] callFastApi ERROR: " + e.getClass().getName() + " / " + e.getMessage());
            throw new RuntimeException("API communication error: " + e.getMessage(), e);
        }
    }

    private static String resolveFastApiUrl() {
        String systemPropertyUrl = System.getProperty("fastapi.url");
        if (systemPropertyUrl != null && !systemPropertyUrl.trim().isEmpty()) {
            return systemPropertyUrl.trim();
        }

        String envUrl = System.getenv("FAST_API_URL");
        if (envUrl != null && !envUrl.trim().isEmpty()) {
            return envUrl.trim();
        }

        return DEFAULT_FAST_API_URL;
    }

    /**
     * FastAPI 베이스 URL (예: http://host:8000/api/v1).
     * {@code fastapi.url} / {@code FAST_API_URL} 이 {@code .../travel/plan} 전체일 때 접미사를 제거한다.
     */
    public static String resolveFastApiBaseUrl() {
        String endpoint = resolveFastApiUrl();
        final String suffix = "/travel/plan";
        if (endpoint.endsWith(suffix)) {
            return endpoint.substring(0, endpoint.length() - suffix.length());
        }
        return endpoint;
    }
}
