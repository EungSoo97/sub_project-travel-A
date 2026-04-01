package com.es.ta.ai;


import com.fasterxml.jackson.databind.ObjectMapper;

import java.net.URI;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.nio.charset.StandardCharsets;

import java.time.Duration;

public class FastApiService {

    private static final String FAST_API_URL = "http://127.0.0.1:8000/api/v1/travel/plan";

    public static TravelResponseDto callFastApi(TravelRequestDto dto) {
        try {
            ObjectMapper mapper = new ObjectMapper();

            String json = mapper.writeValueAsString(dto);
            System.out.println("보내는 JSON = " + json);

            HttpRequest request = HttpRequest.newBuilder()
                    .uri(URI.create(FAST_API_URL))
                    .header("Content-Type", "application/json")
                    .timeout(Duration.ofSeconds(90))
                    .POST(HttpRequest.BodyPublishers.ofString(json, StandardCharsets.UTF_8))
                    .build();

            HttpClient client = HttpClient.newBuilder()
                    .version(HttpClient.Version.HTTP_1_1)
                    .connectTimeout(Duration.ofSeconds(5))
                    .build();
            HttpResponse<String> response =
                    client.send(request, HttpResponse.BodyHandlers.ofString(StandardCharsets.UTF_8));

            System.out.println("====== RESPONSE RECEIVED ======");
            System.out.println("응답 status = " + response.statusCode());
            System.out.println("응답 body = " + response.body());

            if (response.statusCode() != 200) {
                throw new RuntimeException("FastAPI returned status code: " + response.statusCode() + " body: " + response.body());
            }

            return mapper.readValue(response.body(), TravelResponseDto.class);

        } catch (Exception e) {
            e.printStackTrace();
            System.err.println("FastApiService 통신 에러 발생: " + e.getMessage());
            throw new RuntimeException("API 통신 에러: " + e.getMessage(), e);
        }
    }
}