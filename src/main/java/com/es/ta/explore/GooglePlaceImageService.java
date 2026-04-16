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

public class GooglePlaceImageService {

    // TODO: 본인 API 키로 바꿔
    private static final String API_KEY = "YOUR_GOOGLE_API_KEY";

    /**
     * destination 문자열로 Google Places 대표 사진 URL 생성
     */
    public static String getThumbnailUrlByDestination(String destination) {
        if (destination == null || destination.trim().isEmpty()) {
            return null;
        }

        try {
            String placeResourceName = searchPlaceResourceName(destination);
            if (placeResourceName == null) {
                return null;
            }

            String photoName = getFirstPhotoName(placeResourceName);
            if (photoName == null) {
                return null;
            }

            return buildPhotoMediaUrl(photoName);
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    /**
     * 1단계: destination으로 place resource name 찾기
     * 예: places/ChIJ...
     */
    private static String searchPlaceResourceName(String destination) throws Exception {
        URL url = new URL("https://places.googleapis.com/v1/places:searchText");
        HttpURLConnection conn = (HttpURLConnection) url.openConnection();

        conn.setRequestMethod("POST");
        conn.setRequestProperty("Content-Type", "application/json");
        conn.setRequestProperty("X-Goog-Api-Key", API_KEY);
        conn.setRequestProperty("X-Goog-FieldMask", "places.name");
        conn.setDoOutput(true);

        String query = destination + ", Japan";
        String body = "{\"textQuery\":\"" + escapeJson(query) + "\"}";

        try (OutputStream os = conn.getOutputStream()) {
            os.write(body.getBytes(StandardCharsets.UTF_8));
        }

        String response = readResponse(conn);
        JsonObject root = JsonParser.parseString(response).getAsJsonObject();
        JsonArray places = root.getAsJsonArray("places");

        if (places == null || places.size() == 0) {
            return null;
        }

        JsonObject firstPlace = places.get(0).getAsJsonObject();
        return firstPlace.has("name") ? firstPlace.get("name").getAsString() : null;
    }

    /**
     * 2단계: place resource name으로 첫 번째 photo name 찾기
     */
    private static String getFirstPhotoName(String placeResourceName) throws Exception {
        String endpoint = "https://places.googleapis.com/v1/" + placeResourceName;

        URL url = new URL(endpoint);
        HttpURLConnection conn = (HttpURLConnection) url.openConnection();

        conn.setRequestMethod("GET");
        conn.setRequestProperty("X-Goog-Api-Key", API_KEY);
        conn.setRequestProperty("X-Goog-FieldMask", "photos");

        String response = readResponse(conn);
        JsonObject root = JsonParser.parseString(response).getAsJsonObject();
        JsonArray photos = root.getAsJsonArray("photos");

        if (photos == null || photos.size() == 0) {
            return null;
        }

        JsonObject firstPhoto = photos.get(0).getAsJsonObject();
        return firstPhoto.has("name") ? firstPhoto.get("name").getAsString() : null;
    }

    /**
     * 3단계: photo name으로 실제 사진 media URL 생성
     */
    private static String buildPhotoMediaUrl(String photoName) {
        return "https://places.googleapis.com/v1/" + photoName
                + "/media?key=" + API_KEY
                + "&maxWidthPx=800";
    }

    private static String readResponse(HttpURLConnection conn) throws Exception {
        BufferedReader br;
        if (conn.getResponseCode() >= 200 && conn.getResponseCode() < 300) {
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

    private static String escapeJson(String text) {
        return text.replace("\\", "\\\\").replace("\"", "\\\"");
    }
}