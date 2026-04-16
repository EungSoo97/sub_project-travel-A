package com.es.ta.explore;

import com.google.gson.JsonArray;
import com.google.gson.JsonObject;
import com.google.gson.JsonParser;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.net.HttpURLConnection;
import java.net.URL;
import java.nio.charset.StandardCharsets;
import java.util.ArrayList;
import java.util.LinkedHashSet;
import java.util.List;
import java.util.Set;

public class GooglePlaceImageService {

    public static String getThumbnailUrlByKeyword(String keyword, String apiKey) {
        System.out.println("API KEY = " + apiKey);

        if (keyword == null || keyword.trim().isEmpty()) {
            return null;
        }

        if (apiKey == null || apiKey.trim().isEmpty()) {
            System.out.println("[GooglePlaceImageService] API key is missing.");
            return null;
        }

        try {
            List<String> queries = buildTravelQueries(keyword);

            for (String query : queries) {
                System.out.println("[GooglePlaceImageService] trying query = " + query);

                String photoName = searchBestPhotoName(query, apiKey);
                if (photoName != null && !photoName.isEmpty()) {
                    return buildPhotoMediaUrl(photoName, apiKey);
                }
            }

            return null;
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    private static List<String> buildTravelQueries(String keyword) {
        String k = keyword == null ? "" : keyword.trim();

        Set<String> queries = new LinkedHashSet<>();

        if (k.isEmpty()) {
            queries.add("Japan attraction");
            return new ArrayList<>(queries);
        }

        boolean korean = k.matches(".*[가-힣].*");

        // 특정 장소보다 도시명일 가능성이 높은 경우 scenic 우선
        boolean broadCityKeyword =
                !(k.toLowerCase().contains("museum") ||
                        k.toLowerCase().contains("gallery") ||
                        k.toLowerCase().contains("station") ||
                        k.toLowerCase().contains("airport") ||
                        k.contains("박물관") ||
                        k.contains("미술관") ||
                        k.contains("역") ||
                        k.contains("공항"));

        if (korean) {
            if (broadCityKeyword) {
                queries.add(k + " 일본 랜드마크");
                queries.add(k + " 일본 관광명소");
                queries.add(k + " 일본 여행지");
                queries.add(k + " 일본 야경");
            }
            queries.add(k + " 일본");
        } else {
            if (broadCityKeyword) {
                queries.add(k + " landmark Japan");
                queries.add(k + " attraction Japan");
                queries.add(k + " sightseeing Japan");
                queries.add(k + " skyline Japan");
            }
            queries.add(k + ", Japan");
        }

        return new ArrayList<>(queries);
    }
    private static String searchBestPhotoName(String query, String apiKey) throws Exception {
        URL url = new URL("https://places.googleapis.com/v1/places:searchText");
        HttpURLConnection conn = (HttpURLConnection) url.openConnection();

        conn.setRequestMethod("POST");
        conn.setRequestProperty("Content-Type", "application/json; charset=UTF-8");
        conn.setRequestProperty("X-Goog-Api-Key", apiKey);
        conn.setRequestProperty("X-Goog-FieldMask", "places.displayName,places.formattedAddress,places.photos");
        conn.setDoOutput(true);

        String body = "{\"textQuery\":\"" + escapeJson(query) + "\"}";

        try (OutputStream os = conn.getOutputStream()) {
            os.write(body.getBytes(StandardCharsets.UTF_8));
        }

        String response = readResponse(conn);
        JsonObject root = JsonParser.parseString(response).getAsJsonObject();

        if (!root.has("places")) return null;

        JsonArray places = root.getAsJsonArray("places");

        int bestScore = -9999;
        String bestPhoto = null;

        for (int i = 0; i < places.size(); i++) {
            JsonObject place = places.get(i).getAsJsonObject();

            String name = "";
            if (place.has("displayName")) {
                JsonObject dn = place.getAsJsonObject("displayName");
                if (dn.has("text")) {
                    name = dn.get("text").getAsString().toLowerCase();
                }
            }

            String address = place.has("formattedAddress")
                    ? place.get("formattedAddress").getAsString().toLowerCase()
                    : "";

            if (!place.has("photos")) continue;

            JsonArray photos = place.getAsJsonArray("photos");
            if (photos == null || photos.size() == 0) continue;

            int score = 0;

            // ❌ 나쁜 후보
            if (name.contains("hotel") || name.contains("airport") || name.contains("station")) score -= 50;
            if (address.contains("airport")) score -= 50;

            // ❌ 흔한 건물 느낌
            if (name.contains("building") || name.contains("office")) score -= 20;

            // ⭐ 좋은 후보
            if (name.contains("temple") || name.contains("shrine")) score += 40;
            if (name.contains("tower") || name.contains("castle")) score += 40;
            if (name.contains("park") || name.contains("garden")) score += 30;
            if (name.contains("street") || name.contains("market")) score += 30;

            // ⭐ 일본 특화
            if (name.contains("sensō") || name.contains("asakusa")) score += 50;
            if (name.contains("shibuya") || name.contains("tokyo tower")) score += 50;

            // ⭐ 점수 높은 place 선택
            if (score > bestScore) {
                bestScore = score;

                // 🔥 여기 핵심 (사진 선택 개선)
                if (photos.size() >= 3) {
                    JsonObject photo = photos.get(2).getAsJsonObject(); // ⭐ 3번째 사진
                    if (photo.has("name")) {
                        bestPhoto = photo.get("name").getAsString();
                    }
                } else {
                    // fallback (2번째 or 1번째)
                    int idx = Math.min(1, photos.size() - 1);
                    JsonObject photo = photos.get(idx).getAsJsonObject();
                    if (photo.has("name")) {
                        bestPhoto = photo.get("name").getAsString();
                    }
                }
            }
        }

        return bestPhoto;
    }
    private static String buildPhotoMediaUrl(String photoName, String apiKey) {
        return "https://places.googleapis.com/v1/" + photoName
                + "/media?key=" + apiKey
                + "&maxWidthPx=1200";
    }

    private static String escapeJson(String text) {
        return text
                .replace("\\", "\\\\")
                .replace("\"", "\\\"")
                .replace("\n", " ")
                .replace("\r", " ");
    }

    private static String readResponse(HttpURLConnection conn) throws Exception {
        BufferedReader br;
        int code = conn.getResponseCode();

        if (code >= 200 && code < 300) {
            br = new BufferedReader(new InputStreamReader(conn.getInputStream(), StandardCharsets.UTF_8));
        } else {
            br = new BufferedReader(new InputStreamReader(conn.getErrorStream(), StandardCharsets.UTF_8));
        }

        StringBuilder sb = new StringBuilder();
        String line;
        while ((line = br.readLine()) != null) {
            sb.append(line);
        }
        br.close();

        return sb.toString();
    }
}