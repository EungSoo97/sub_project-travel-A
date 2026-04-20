package com.es.ta.explore;

import com.es.ta.main.DBManager_new;
import com.google.gson.JsonArray;
import com.google.gson.JsonElement;
import com.google.gson.JsonObject;
import com.google.gson.JsonParser;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.LinkedHashSet;
import java.util.List;
import java.util.Set;
import java.util.regex.Matcher;
import java.util.regex.Pattern;
import com.es.ta.resultpage.ResultpageDAO;
import com.es.ta.resultpage.TravelResultVDTO;


public class ExploreDAO {

    public static List<ExploreDTO> searchAutocomplete(String keyword) {
        List<ExploreDTO> result = new ArrayList<>();

        String sql =
                "SELECT plan_id, destination, title, travel_style, request_styles, response_json " +
                        "FROM travel_plan " +
                        "WHERE posted = 1 " +
                        "  AND (destination LIKE ? " +
                        "   OR title LIKE ? " +
                        "   OR request_styles LIKE ? " +
                        "   OR request_themes LIKE ?) " +
                        "ORDER BY " +
                        "   CASE " +
                        "       WHEN destination LIKE ? THEN 1 " +
                        "       WHEN title LIKE ? THEN 2 " +
                        "       ELSE 3 " +
                        "   END, " +
                        "   created_at DESC " +
                        "FETCH FIRST 5 ROWS ONLY";

        Connection con = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        try {
            con = DBManager_new.connect();
            pstmt = con.prepareStatement(sql);

            String q = "%" + keyword + "%";
            String startsQ = keyword + "%";

            pstmt.setString(1, q);
            pstmt.setString(2, q);
            pstmt.setString(3, q);
            pstmt.setString(4, q);
            pstmt.setString(5, startsQ);
            pstmt.setString(6, startsQ);

            rs = pstmt.executeQuery();

            while (rs.next()) {
                ExploreDTO dto = new ExploreDTO();

                dto.setPlanId(rs.getInt("plan_id"));
                dto.setDestination(rs.getString("destination"));
                dto.setTitle(rs.getString("title"));
                dto.setTravelStyle(displayTravelStyle(rs.getString("request_styles"), rs.getString("travel_style")));

                String responseJson = rs.getString("response_json");
                List<String> tags = parseCustomTags(responseJson);
                addCsvTags(tags, rs.getString("request_styles"));
                dto.setCustomTags(tags);

                result.add(dto);
            }

        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            DBManager_new.close(con, pstmt, rs);
        }

        return result;
    }

    public static List<String> getPopularTags() {
        List<String> result = new ArrayList<>();

        String sql =
                "SELECT plan_id, response_json, request_styles " +
                        "FROM travel_plan " +
                        "WHERE posted = 1 " +
                        "  AND (response_json LIKE '%customTags%' OR request_styles IS NOT NULL) " +
                        "ORDER BY created_at DESC";

        Connection con = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        try {
            con = DBManager_new.connect();
            pstmt = con.prepareStatement(sql);
            rs = pstmt.executeQuery();

            Set<String> unique = new LinkedHashSet<>();

            while (rs.next() && unique.size() < 5) {
                int planId = rs.getInt("plan_id");
                String responseJson = rs.getString("response_json");

                List<String> tags = parseCustomTags(responseJson);
                addCsvTags(tags, rs.getString("request_styles"));
                System.out.println("planId=" + planId + ", parsedTags=" + tags);

                for (String tag : tags) {
                    if (tag != null && !tag.isBlank()) {
                        unique.add(tag.trim());
                    }
                    if (unique.size() == 5) {
                        break;
                    }
                }
            }

            result.addAll(unique);
            System.out.println("popular tagList = " + result);

        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            DBManager_new.close(con, pstmt, rs);
        }

        return result;
    }
    private static List<String> parseCustomTags(String json) {
        List<String> tags = new ArrayList<>();

        if (json == null || json.trim().isEmpty()) {
            return tags;
        }

        try {
            Pattern pattern = Pattern.compile("\"?customTags\"?\\s*:\\s*\\[(.*?)\\]", Pattern.DOTALL);
            Matcher matcher = pattern.matcher(json);

            while (matcher.find()) {
                String inside = matcher.group(1).trim();

                if (inside.isEmpty()) {
                    continue;
                }

                String[] parts = inside.split(",");
                for (String part : parts) {
                    String tag = part.trim()
                            .replace("\"", "")
                            .replace("'", "")
                            .replace("\\", "");
                    tag = convertTag(tag);
                    if (!tag.isEmpty()
                            && !tags.contains(tag)
                            && !"ROUND_TRIP".equalsIgnoreCase(tag)
                            && !tag.contains("�")) {
                        tags.add(tag);
                    }
                }
            }

            System.out.println("parsed tags = " + tags);

        } catch (Exception e) {
            System.out.println("parseCustomTags failed");
            e.printStackTrace();
        }

        return tags;
    }
    private static void collectCustomTags(JsonElement element, Set<String> tags) {
        if (element == null || element.isJsonNull()) return;

        if (element.isJsonObject()) {
            JsonObject obj = element.getAsJsonObject();

            if (obj.has("customTags")) {
                JsonElement customTagsElement = obj.get("customTags");

                if (customTagsElement.isJsonArray()) {
                    JsonArray arr = customTagsElement.getAsJsonArray();
                    for (int i = 0; i < arr.size(); i++) {
                        addTagValue(arr.get(i), tags);
                    }
                } else {
                    addTagValue(customTagsElement, tags);
                }
            }

            for (String key : obj.keySet()) {
                collectCustomTags(obj.get(key), tags);
            }
            return;
        }

        if (element.isJsonArray()) {
            JsonArray arr = element.getAsJsonArray();
            for (int i = 0; i < arr.size(); i++) {
                collectCustomTags(arr.get(i), tags);
            }
            return;
        }

        if (element.isJsonPrimitive() && element.getAsJsonPrimitive().isString()) {
            String raw = element.getAsString();
            if (looksLikeJson(raw)) {
                JsonElement nested = parseLenient(raw);
                if (nested != null) {
                    collectCustomTags(nested, tags);
                }
            }
        }
    }

    private static void addTagValue(JsonElement element, Set<String> tags) {
        if (element == null || element.isJsonNull()) return;

        if (element.isJsonArray()) {
            JsonArray arr = element.getAsJsonArray();
            for (int i = 0; i < arr.size(); i++) {
                addTagValue(arr.get(i), tags);
            }
            return;
        }

        String value;
        try {
            value = element.getAsString();
        } catch (Exception e) {
            return;
        }

        if (value == null) return;

        value = value.trim()
                .replace("\"", "")
                .replace("'", "")
                .replace("[", "")
                .replace("]", "");

        if (value.isEmpty()) return;

        if (looksLikeJson(value)) {
            JsonElement nested = parseLenient(value);
            if (nested != null) {
                collectCustomTags(nested, tags);
            }
            return;
        }

        // "a,b,c" 같이 문자열 하나로 들어온 경우 분리
        if (value.contains(",")) {
            String[] split = value.split(",");
            for (String part : split) {
                String tag = normalizeTag(part);
                if (!tag.isEmpty()) {
                    tags.add(tag);
                }
            }
            return;
        }

        String tag = normalizeTag(value);
        if (!tag.isEmpty()) {
            tags.add(tag);
        }
    }

    private static String normalizeTag(String tag) {
        if (tag == null) return "";

        String cleaned = tag.trim()
                .replace("#", "")
                .replace("\"", "")
                .replace("'", "");

        if (cleaned.isEmpty()) return "";
        if ("ROUND_TRIP".equalsIgnoreCase(cleaned)) return "";

        return cleaned;
    }

    private static boolean looksLikeJson(String text) {
        if (text == null) return false;
        String t = text.trim();
        return (t.startsWith("{") && t.endsWith("}")) ||
                (t.startsWith("[") && t.endsWith("]"));
    }

    private static JsonElement parseLenient(String json) {
        if (json == null) return null;

        String normalized = json.trim()
                .replace('\'', '"')
                .replace("\\\"", "\"")
                .replace("\"{", "{")
                .replace("}\"", "}")
                .replace("\"[", "[")
                .replace("]\"", "]");

        try {
            return JsonParser.parseString(normalized);
        } catch (Exception ignored) {
            return null;
        }
    }

    private static String convertTag(String tag) {
        if (tag == null) return "";

        switch (tag.toLowerCase()) {
            case "onsen": return "온천";
            case "market": return "시장";
            case "shopping": return "쇼핑";
            case "healing": return "힐링";
            case "romantic": return "로맨틱";
            case "nature": return "자연";
            case "food": return "맛집";
            case "jibiyong":   // 혹시 이런 식으로 들어온 경우
            case "저비용":
                return "";
            default:
                return tag;
        }
    }

    public static List<TravelResultVDTO> searchPlans(String q, String selectedTags, String googleApiKey) {

        List<TravelResultVDTO> allPlans = ResultpageDAO.getPlanList(googleApiKey);
        List<TravelResultVDTO> result = new ArrayList<>();

        String keyword = (q != null) ? q.trim().toLowerCase() : "";

        List<String> tagList = new ArrayList<>();
        if (selectedTags != null && !selectedTags.trim().isEmpty()) {
            String[] tags = selectedTags.split(",");
            for (String tag : tags) {
                tagList.add(tag.trim().toLowerCase());
            }
        }

        for (TravelResultVDTO plan : allPlans) {

            boolean matchKeyword = true;
            boolean matchTag = true;

            if (!keyword.isEmpty()) {
                String title = (plan.getSummary() != null && plan.getSummary().getTitle() != null)
                        ? plan.getSummary().getTitle().toLowerCase()
                        : "";

                String destination = (plan.getSummary() != null && plan.getSummary().getDestination() != null)
                        ? plan.getSummary().getDestination().toLowerCase()
                        : "";

                matchKeyword = matchesKeyword(plan, keyword, title, destination);
            }

            if (!tagList.isEmpty()) {
                matchTag = matchesSelectedTags(plan, tagList);
            }

            if (matchKeyword && matchTag) {
                result.add(plan);
            }
        }

        return result;
    }

    private static boolean matchesKeyword(TravelResultVDTO plan, String keyword, String title, String destination) {
        if (keyword == null || keyword.isBlank()) {
            return true;
        }

        String token = normalizeSearchToken(keyword);
        if (safeLower(title).contains(token) || safeLower(destination).contains(token)) {
            return true;
        }

        if (plan == null || plan.getSummary() == null) {
            return false;
        }

        TravelResultVDTO.Summary summary = plan.getSummary();
        if (safeLower(summary.getTravelStyle()).contains(token)) {
            return true;
        }

        List<String> tags = new ArrayList<>();
        tags.addAll(summary.getCustomTags());
        if (summary.getRequestStyles() != null) {
            tags.addAll(summary.getRequestStyles());
        }
        if (summary.getRequestThemes() != null) {
            tags.addAll(summary.getRequestThemes());
        }

        return containsInList(tags, token);
    }

    private static boolean matchesSelectedTags(TravelResultVDTO plan, List<String> tagList) {
        if (plan == null || plan.getSummary() == null || tagList == null || tagList.isEmpty()) {
            return true;
        }

        TravelResultVDTO.Summary summary = plan.getSummary();
        List<String> planTags = new ArrayList<>();

        planTags.addAll(summary.getCustomTags());
        if (summary.getRequestStyles() != null) {
            planTags.addAll(summary.getRequestStyles());
        }
        if (summary.getRequestThemes() != null) {
            planTags.addAll(summary.getRequestThemes());
        }

        String travelStyle = safeLower(summary.getTravelStyle());

        for (String rawTag : tagList) {
            String tag = normalizeSearchToken(rawTag);
            if (tag.isEmpty()) {
                continue;
            }

            if (containsInList(planTags, tag) || travelStyle.contains(tag)) {
                return true;
            }
        }

        return false;
    }


    private static String normalizeSearchToken(String text) {
        if (text == null) return "";
        return text.trim()
                .replace("#", "")
                .replace("\"", "")
                .replace("'", "")
                .toLowerCase();
    }

    private static String safeLower(String text) {
        return text == null ? "" : text.toLowerCase().trim();
    }

    private static boolean containsInList(List<String> list, String token) {
        if (list == null || token == null || token.isEmpty()) {
            return false;
        }

        for (String item : list) {
            if (item == null) continue;

            String normalizedItem = item.trim()
                    .replace("#", "")
                    .toLowerCase();

            if (normalizedItem.contains(token) || token.contains(normalizedItem)) {
                return true;
            }
        }

        return false;
    }

    private static String displayTravelStyle(String requestStyles, String travelStyle) {
        if (requestStyles != null && !requestStyles.trim().isEmpty()) {
            return requestStyles.trim();
        }
        return travelStyle;
    }

    private static void addCsvTags(List<String> tags, String csv) {
        if (tags == null || csv == null || csv.trim().isEmpty()) {
            return;
        }

        for (String part : csv.split(",")) {
            String tag = normalizeTag(part);
            if (!tag.isEmpty() && !tags.contains(tag)) {
                tags.add(tag);
            }
        }
    }
}
