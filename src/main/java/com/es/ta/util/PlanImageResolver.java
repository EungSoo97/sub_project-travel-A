package com.es.ta.util;

import com.es.ta.ai.TravelResponseDto;
import com.es.ta.explore.GooglePlaceImageService;
import com.es.ta.resultpage.TravelResultVDTO;
import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;

import java.util.Iterator;
import java.util.Map;

public final class PlanImageResolver {

    private static final ObjectMapper JSON_MAPPER = new ObjectMapper();

    private PlanImageResolver() {
    }

    public static String resolveThumbnailUrl(TravelResponseDto responseDto, String responseJson, String destination) {
        String imageUrl = firstUsableImageUrl(responseDto);
        if (!imageUrl.isBlank()) {
            return imageUrl;
        }

        imageUrl = extractFirstImageUrl(responseJson);
        if (!imageUrl.isBlank()) {
            return imageUrl;
        }

        return fetchPlaceThumbnail(destination);
    }

    public static String resolveThumbnailUrl(TravelResultVDTO result) {
        if (result == null) {
            return "";
        }

        String imageUrl = firstUsableImageUrl(result);
        if (!imageUrl.isBlank()) {
            return imageUrl;
        }

        String destination = result.getSummary() != null ? nullSafe(result.getSummary().getDestination()) : "";
        return fetchPlaceThumbnail(destination);
    }

    public static String resolveThumbnailUrl(String responseJson, String destination) {
        String imageUrl = extractFirstImageUrl(responseJson);
        if (!imageUrl.isBlank()) {
            return imageUrl;
        }

        return fetchPlaceThumbnail(destination);
    }

    public static String extractFirstImageUrl(String responseJson) {
        if (responseJson == null || responseJson.isBlank()) {
            return "";
        }

        try {
            return findImageUrl(JSON_MAPPER.readTree(responseJson), "");
        } catch (Exception e) {
            return "";
        }
    }

    private static String firstUsableImageUrl(TravelResponseDto responseDto) {
        if (responseDto == null) {
            return "";
        }

        if (responseDto.getHotels() != null) {
            for (TravelResponseDto.HotelOption hotel : responseDto.getHotels()) {
                if (hotel != null && isUsableImageUrl(hotel.getImageUrl())) {
                    return hotel.getImageUrl().trim();
                }
            }
        }

        return "";
    }

    private static String firstUsableImageUrl(TravelResultVDTO result) {
        if (result == null) {
            return "";
        }

        if (result.getHotels() != null) {
            for (TravelResultVDTO.Hotel hotel : result.getHotels()) {
                if (hotel != null && isUsableImageUrl(hotel.getImageUrl())) {
                    return hotel.getImageUrl().trim();
                }
            }
        }

        return "";
    }

    private static String fetchPlaceThumbnail(String destination) {
        String keyword = nullSafe(destination).trim();
        if (keyword.isEmpty()) {
            return "";
        }

        String apiKey = nullSafe(ConfigLoader.get("GOOGLE_API_KEY")).trim();
        if (apiKey.isEmpty()) {
            return "";
        }

        String thumbnailUrl = GooglePlaceImageService.getThumbnailUrlByKeyword(keyword, apiKey);
        return thumbnailUrl == null ? "" : thumbnailUrl.trim();
    }

    private static String findImageUrl(JsonNode node, String fieldName) {
        if (node == null || node.isNull()) {
            return "";
        }

        if (node.isTextual()) {
            String value = node.asText("").trim();
            if (isImageField(fieldName) && isUsableImageUrl(value)) {
                return value;
            }
            return "";
        }

        if (node.isArray()) {
            for (JsonNode child : node) {
                String found = findImageUrl(child, fieldName);
                if (!found.isBlank()) {
                    return found;
                }
            }
            return "";
        }

        if (node.isObject()) {
            Iterator<Map.Entry<String, JsonNode>> fields = node.fields();
            while (fields.hasNext()) {
                Map.Entry<String, JsonNode> field = fields.next();
                String found = findImageUrl(field.getValue(), field.getKey());
                if (!found.isBlank()) {
                    return found;
                }
            }
        }

        return "";
    }

    private static boolean isImageField(String fieldName) {
        String key = nullSafe(fieldName).toLowerCase();
        return key.contains("image")
                || key.contains("photo")
                || key.contains("thumbnail")
                || key.contains("cover");
    }

    private static boolean isUsableImageUrl(String value) {
        String url = nullSafe(value).trim().toLowerCase();
        return url.startsWith("http://") || url.startsWith("https://");
    }

    private static String nullSafe(String value) {
        return value == null ? "" : value;
    }
}
