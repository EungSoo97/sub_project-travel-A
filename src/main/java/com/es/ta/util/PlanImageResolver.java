package com.es.ta.util;

import com.cloudinary.Cloudinary;
import com.cloudinary.utils.ObjectUtils;
import com.es.ta.ai.TravelResponseDto;
import com.es.ta.explore.GooglePlaceImageService;
import com.es.ta.image.CloudinaryUtil;
import com.es.ta.resultpage.TravelResultVDTO;
import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;

import java.io.ByteArrayOutputStream;
import java.io.InputStream;
import java.net.HttpURLConnection;
import java.net.URL;
import java.util.Iterator;
import java.util.Map;
import java.util.UUID;

public final class PlanImageResolver {

    private static final ObjectMapper JSON_MAPPER = new ObjectMapper();
    private static final String THUMBNAIL_FOLDER = "thumbnail";

    private PlanImageResolver() {
    }

    public static String resolveThumbnailUrl(TravelResponseDto responseDto, String responseJson, String destination) {
        return resolveThumbnailUrl(responseDto, responseJson, destination, -1);
    }

    public static String resolveThumbnailUrl(TravelResponseDto responseDto, String responseJson, String destination, int planId) {
        return uploadToCloudinary(resolveSourceImageUrl(responseDto, responseJson, destination), destination, planId);
    }

    public static String resolveThumbnailUrl(TravelResultVDTO result) {
        return resolveThumbnailUrl(result, -1);
    }

    public static String resolveThumbnailUrl(TravelResultVDTO result, int planId) {
        if (result == null) {
            return "";
        }

        String responseJson = "";
        try {
            responseJson = JSON_MAPPER.writeValueAsString(result);
        } catch (Exception ignored) {
        }
        String destination = result.getSummary() != null ? nullSafe(result.getSummary().getDestination()) : "";
        String sourceUrl = firstUsableImageUrl(result);
        if (sourceUrl.isBlank()) {
            sourceUrl = extractFirstImageUrl(responseJson);
        }
        if (sourceUrl.isBlank()) {
            sourceUrl = fetchPlaceThumbnail(destination);
        }
        return uploadToCloudinary(sourceUrl, destination, planId);
    }

    public static String resolveThumbnailUrl(String responseJson, String destination) {
        return resolveThumbnailUrl(responseJson, destination, -1);
    }

    public static String resolveThumbnailUrl(String responseJson, String destination, int planId) {
        return uploadToCloudinary(resolveSourceImageUrl(null, responseJson, destination), destination, planId);
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

    private static String resolveSourceImageUrl(TravelResponseDto responseDto, String responseJson, String destination) {
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

    private static String firstUsableImageUrl(TravelResponseDto responseDto) {
        if (responseDto == null || responseDto.getHotels() == null) {
            return "";
        }

        for (TravelResponseDto.HotelOption hotel : responseDto.getHotels()) {
            if (hotel != null && isUsableImageUrl(hotel.getImageUrl())) {
                return hotel.getImageUrl().trim();
            }
        }

        return "";
    }

    private static String firstUsableImageUrl(TravelResultVDTO result) {
        if (result == null || result.getHotels() == null) {
            return "";
        }

        for (TravelResultVDTO.Hotel hotel : result.getHotels()) {
            if (hotel != null && isUsableImageUrl(hotel.getImageUrl())) {
                return hotel.getImageUrl().trim();
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

    private static String uploadToCloudinary(String imageUrl, String destination, int planId) {
        String normalizedUrl = nullSafe(imageUrl).trim();
        if (normalizedUrl.isEmpty()) {
            return "";
        }

        if (isThumbnailFolderUrl(normalizedUrl, planId)) {
            return normalizedUrl;
        }

        try {
            Cloudinary cloudinary = CloudinaryUtil.getInstance();
            byte[] imageBytes = downloadImageBytes(normalizedUrl);
            if (imageBytes == null || imageBytes.length == 0) {
                return normalizedUrl;
            }

            Map<?, ?> uploadResult = cloudinary.uploader().upload(
                    imageBytes,
                    ObjectUtils.asMap(
                            "folder", THUMBNAIL_FOLDER,
                            "public_id", buildPublicId(destination, planId),
                            "overwrite", true,
                            "unique_filename", false,
                            "resource_type", "image"
                    )
            );

            String secureUrl = uploadResult.get("secure_url") instanceof String
                    ? String.valueOf(uploadResult.get("secure_url")).trim()
                    : "";
            if (!secureUrl.isEmpty()) {
                return secureUrl;
            }

            Object fallbackUrl = uploadResult.get("url");
            return fallbackUrl == null ? "" : String.valueOf(fallbackUrl).trim();
        } catch (Exception e) {
            e.printStackTrace();
            return normalizedUrl;
        }
    }

    private static byte[] downloadImageBytes(String imageUrl) throws Exception {
        HttpURLConnection connection = null;

        try {
            connection = openConnection(imageUrl, 0);
            try (InputStream in = connection.getInputStream();
                 ByteArrayOutputStream out = new ByteArrayOutputStream()) {
                byte[] buffer = new byte[8192];
                int read;
                while ((read = in.read(buffer)) != -1) {
                    out.write(buffer, 0, read);
                }
                return out.toByteArray();
            }
        } finally {
            if (connection != null) {
                connection.disconnect();
            }
        }
    }

    private static HttpURLConnection openConnection(String imageUrl, int redirectCount) throws Exception {
        if (redirectCount > 5) {
            throw new IllegalStateException("Too many redirects while downloading thumbnail");
        }

        HttpURLConnection connection = (HttpURLConnection) new URL(imageUrl).openConnection();
        connection.setInstanceFollowRedirects(false);
        connection.setConnectTimeout(10000);
        connection.setReadTimeout(15000);
        connection.setRequestProperty("User-Agent", "Mozilla/5.0");

        int status = connection.getResponseCode();
        if (status >= 300 && status < 400) {
            String redirectUrl = connection.getHeaderField("Location");
            connection.disconnect();
            if (redirectUrl == null || redirectUrl.isBlank()) {
                throw new IllegalStateException("Redirect location is empty");
            }
            return openConnection(redirectUrl, redirectCount + 1);
        }

        if (status < 200 || status >= 300) {
            throw new IllegalStateException("Thumbnail download failed with status " + status);
        }

        return connection;
    }

    private static String buildPublicId(String destination, int planId) {
        if (planId > 0) {
            return String.valueOf(planId);
        }

        String base = nullSafe(destination)
                .trim()
                .toLowerCase()
                .replaceAll("[^a-z0-9]+", "-")
                .replaceAll("^-+|-+$", "");

        if (base.isEmpty()) {
            base = "plan-thumbnail";
        }

        return base + "-" + UUID.randomUUID();
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

    private static boolean isCloudinaryUrl(String value) {
        return nullSafe(value).contains("res.cloudinary.com");
    }

    private static boolean isThumbnailFolderUrl(String value, int planId) {
        String normalized = nullSafe(value).trim();
        if (!isCloudinaryUrl(normalized) || !normalized.contains("/" + THUMBNAIL_FOLDER + "/")) {
            return false;
        }
        if (planId <= 0) {
            return true;
        }
        return normalized.contains("/" + THUMBNAIL_FOLDER + "/" + planId);
    }

    private static String nullSafe(String value) {
        return value == null ? "" : value;
    }
}
