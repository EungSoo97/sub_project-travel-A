
package com.es.ta.ai;

import com.google.gson.Gson;
import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;

    public class TravelDao {
        private final Gson gson = new Gson();

        /**
         * 요청 데이터를 JSON 파일로 서버에 기록 (디버깅/로그용)
         */
        public void saveRequestLog(TravelRequestDto dto, String realPath) throws IOException {
            String json = gson.toJson(dto);
            Path dir = Paths.get(realPath);
            if (!Files.exists(dir)) {
                Files.createDirectories(dir);
            }
            Path requestPath = dir.resolve("request.json");
            Files.write(requestPath, json.getBytes(StandardCharsets.UTF_8));
        }

        /**
         * FastAPI 서버로부터 여행 계획 데이터를 가져옴
         */
        public TravelResponseDto fetchTravelPlan(TravelRequestDto dto) {
            // 기존에 구현된 FastApiService를 호출
            return FastApiService.callFastApi(dto);
        }
    }


