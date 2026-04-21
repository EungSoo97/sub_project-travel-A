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
import java.util.Comparator;
import java.util.LinkedHashSet;
import java.util.List;
import java.util.Locale;
import java.util.Set;

public class GooglePlaceImageService {

    private static final double DEFAULT_LOCATION_BIAS_RADIUS_METERS = 12000d;

    public static String getThumbnailUrlByKeyword(String keyword, String apiKey) {
        return getThumbnailUrlByKeyword(keyword, apiKey, null, null, 0);
    }

    public static String getThumbnailUrlByKeyword(String keyword, String apiKey, int variantSeed) {
        return getThumbnailUrlByKeyword(keyword, apiKey, null, null, variantSeed);
    }

    public static String getThumbnailUrlByKeyword(String keyword, String apiKey, Double lat, Double lng, int variantSeed) {
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

            for (int i = 0; i < queries.size(); i++) {
                String query = queries.get(i);
                System.out.println("[GooglePlaceImageService] trying query = " + query
                        + ", lat=" + lat + ", lng=" + lng);

                String photoName = searchBestPhotoName(query, apiKey, lat, lng, variantSeed + i);
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

        queries.add(k);

        boolean korean = k.matches(".*[가-힣].*");
        boolean broadCityKeyword =
                !(k.toLowerCase(Locale.ROOT).contains("museum")
                        || k.toLowerCase(Locale.ROOT).contains("gallery")
                        || k.toLowerCase(Locale.ROOT).contains("station")
                        || k.toLowerCase(Locale.ROOT).contains("airport")
                        || k.contains("박물관")
                        || k.contains("미술관")
                        || k.contains("역")
                        || k.contains("공항"));

        if (korean) {
            if (broadCityKeyword) {
                queries.add(k + " 일본 랜드마크");
                queries.add(k + " 일본 관광명소");
                queries.add(k + " 일본 여행지");
                queries.add(k + " 일본 풍경");
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

    private static String searchBestPhotoName(String query, String apiKey, Double lat, Double lng, int variantSeed) throws Exception {
        URL url = new URL("https://places.googleapis.com/v1/places:searchText");
        HttpURLConnection conn = (HttpURLConnection) url.openConnection();

        conn.setRequestMethod("POST");
        conn.setRequestProperty("Content-Type", "application/json; charset=UTF-8");
        conn.setRequestProperty("X-Goog-Api-Key", apiKey);
        conn.setRequestProperty("X-Goog-FieldMask", "places.displayName,places.formattedAddress,places.photos");
        conn.setDoOutput(true);

        String body = buildSearchRequestBody(query, lat, lng);

        try (OutputStream os = conn.getOutputStream()) {
            os.write(body.getBytes(StandardCharsets.UTF_8));
        }

        String response = readResponse(conn);
        JsonObject root = JsonParser.parseString(response).getAsJsonObject();

        if (!root.has("places")) {
            return null;
        }

        JsonArray places = root.getAsJsonArray("places");
        List<PhotoCandidate> candidates = new ArrayList<>();

        for (int i = 0; i < places.size(); i++) {
            JsonObject place = places.get(i).getAsJsonObject();

            String name = "";
            if (place.has("displayName")) {
                JsonObject displayName = place.getAsJsonObject("displayName");
                if (displayName.has("text")) {
                    name = placeText(displayName.get("text").getAsString());
                }
            }

            String address = place.has("formattedAddress")
                    ? placeText(place.get("formattedAddress").getAsString())
                    : "";

            if (!place.has("photos")) {
                continue;
            }

            JsonArray photos = place.getAsJsonArray("photos");
            if (photos == null || photos.size() == 0) {
                continue;
            }

            int score = scorePlace(name, address);

            for (int photoIndex : buildPhotoPreferenceOrder(photos.size(), variantSeed + i)) {
                JsonObject photo = photos.get(photoIndex).getAsJsonObject();
                if (!photo.has("name")) {
                    continue;
                }
                candidates.add(new PhotoCandidate(photo.get("name").getAsString(), score, i, photoIndex));
            }
        }

        if (candidates.isEmpty()) {
            return null;
        }

        candidates.sort(Comparator
                .comparingInt(PhotoCandidate::score).reversed()
                .thenComparingInt(PhotoCandidate::placeIndex)
                .thenComparingInt(PhotoCandidate::photoIndex));

        int candidateIndex = Math.floorMod(variantSeed, Math.min(candidates.size(), 6));
        return candidates.get(candidateIndex).photoName();
    }

    private static String buildSearchRequestBody(String query, Double lat, Double lng) {
        JsonObject body = new JsonObject();
        body.addProperty("textQuery", query);

        if (isValidCoordinate(lat, lng)) {
            JsonObject center = new JsonObject();
            center.addProperty("latitude", lat);
            center.addProperty("longitude", lng);

            JsonObject circle = new JsonObject();
            circle.add("center", center);
            circle.addProperty("radius", DEFAULT_LOCATION_BIAS_RADIUS_METERS);

            JsonObject locationBias = new JsonObject();
            locationBias.add("circle", circle);
            body.add("locationBias", locationBias);
        }

        return body.toString();
    }

    private static int scorePlace(String name, String address) {
        int score = 0;

        if (name.contains("hotel") || name.contains("airport") || name.contains("station")) {
            score -= 50;
        }
        if (address.contains("airport")) {
            score -= 50;
        }

        if (name.contains("building") || name.contains("office")) {
            score -= 20;
        }

        if (name.contains("temple") || name.contains("shrine")) {
            score += 40;
        }
        if (name.contains("tower") || name.contains("castle")) {
            score += 40;
        }
        if (name.contains("park") || name.contains("garden")) {
            score += 30;
        }
        if (name.contains("street") || name.contains("market")) {
            score += 30;
        }

        if (name.contains("senso") || name.contains("asakusa")) {
            score += 50;
        }
        if (name.contains("shibuya") || name.contains("tokyo tower")) {
            score += 50;
        }

        return score;
    }

    private static List<Integer> buildPhotoPreferenceOrder(int photoCount, int variantSeed) {
        List<Integer> indices = new ArrayList<>();
        if (photoCount <= 0) {
            return indices;
        }

        int preferredIndex;
        if (photoCount >= 3) {
            preferredIndex = 2;
        } else if (photoCount == 2) {
            preferredIndex = 1;
        } else {
            preferredIndex = 0;
        }

        indices.add(preferredIndex);

        int rotatedStart = Math.floorMod(variantSeed, photoCount);
        for (int offset = 0; offset < photoCount; offset++) {
            int idx = (rotatedStart + offset) % photoCount;
            if (!indices.contains(idx)) {
                indices.add(idx);
            }
        }

        return indices;
    }

    private static String buildPhotoMediaUrl(String photoName, String apiKey) {
        return "https://places.googleapis.com/v1/" + photoName
                + "/media?key=" + apiKey
                + "&maxWidthPx=1200";
    }

    private static String placeText(String text) {
        return text == null ? "" : text.trim().toLowerCase(Locale.ROOT);
    }

    private static boolean isValidCoordinate(Double lat, Double lng) {
        return lat != null && lng != null
                && !lat.isNaN() && !lng.isNaN()
                && lat >= -90 && lat <= 90
                && lng >= -180 && lng <= 180;
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

    private record PhotoCandidate(String photoName, int score, int placeIndex, int photoIndex) {
    }
}
