package com.es.ta.ai;

import com.es.ta.main.DBManager_new;
import com.es.ta.util.PlanImageResolver;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Types;
import java.time.LocalDate;
import java.time.temporal.ChronoUnit;
import java.util.ArrayList;
import java.util.Comparator;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.LinkedHashSet;
import java.util.List;
import java.util.Map;

public class TravelDao {

    public static final TravelDao MDAO = new TravelDao();

    public TravelResponseDto fetchTravelPlan(TravelRequestDto dto) {
        System.out.println("[TravelDao] fetchTravelPlan START destination=" + dto.getDestination()
                + ", startDate=" + dto.getStartDate()
                + ", endDate=" + dto.getEndDate());
        TravelResponseDto response = FastApiService.callFastApi(dto);
        System.out.println("[TravelDao] fetchTravelPlan END resultNull=" + (response == null)
                + ", success=" + (response != null && response.isSuccess()));
        return response;
    }

    public void insertTravelPlan(TravelRequestDto requestDto,
                                 TravelResponseDto responseDto,
                                 String responseJson,
                                 Integer userId) {

        Connection con = null;
        PreparedStatement ps = null;

        String sql =
                "INSERT INTO travel_plan ( " +
                        "plan_id, user_id, destination, title, start_date, end_date, days, travelers, " +
                        "travel_style, request_styles, total_estimated_cost, currency, overview, success, message, response_json, thumbnail_url " +
                        ") VALUES ( " +
                        "travel_plan_seq.NEXTVAL, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ? " +
                        ")";

        try {
            System.out.println("[TravelDao] insertTravelPlan START");
            con = DBManager_new.connect();
            ps = con.prepareStatement(sql);

            TravelResponseDto.Summary summary = responseDto != null ? responseDto.getSummary() : null;

            // 1. user_id
            if (userId != null) {
                ps.setInt(1, userId);
            } else {
                ps.setNull(1, Types.NUMERIC);
            }

            // 2. destination
            ps.setString(2, getDestination(requestDto, summary));

            // 3. title
            ps.setString(3, getSafeString(summary != null ? summary.getTitle() : null));

            // 4. start_date
            setDateOrNull(ps, 4, getStartDate(requestDto, summary));

            // 5. end_date
            setDateOrNull(ps, 5, getEndDate(requestDto, summary));

            // 6. days
            ps.setInt(6, getDays(requestDto, summary));

            // 7. travelers
            ps.setInt(7, getTravelers(requestDto, summary));

            // 8. travel_style
            ps.setString(8, getTravelStyle(requestDto, summary));

            // 9. request_styles
            ps.setString(9, getRequestStyles(requestDto, summary));

            // 10. total_estimated_cost
            ps.setInt(10, summary != null ? summary.getTotalEstimatedCost() : 0);

            // 11. currency
            ps.setString(11, getSafeString(summary != null ? summary.getCurrency() : null, "KRW"));

            // 12. overview
            ps.setString(12, getSafeString(summary != null ? summary.getOverview() : null));

            // 13. success
            ps.setInt(13, (responseDto != null && responseDto.isSuccess()) ? 1 : 0);

            // 14. message
            ps.setString(14, getSafeString(responseDto != null ? responseDto.getMessage() : null));

            // 15. response_json
            ps.setString(15, getSafeString(responseJson, "{}"));

            // 16. thumbnail_url
            ps.setString(16, PlanImageResolver.resolveThumbnailUrl(
                    responseDto,
                    responseJson,
                    getDestination(requestDto, summary)
            ));

            System.out.println("[TravelDao] executing insert. destination=" + getDestination(requestDto, summary)
                    + ", title=" + getSafeString(summary != null ? summary.getTitle() : null)
                    + ", jsonLength=" + (responseJson == null ? 0 : responseJson.length()));
            ps.executeUpdate();
            System.out.println("travel_plan 저장 성공");

        } catch (Exception e) {
            e.printStackTrace();
            System.out.println("[TravelDao] insertTravelPlan ERROR: " + e.getMessage());
        } finally {
            DBManager_new.close(con, ps,null);
            System.out.println("[TravelDao] insertTravelPlan END");
        }
    }

    private void setDateOrNull(PreparedStatement ps, int index, String dateStr) throws Exception {
        if (dateStr != null && !dateStr.isBlank()) {
            ps.setDate(index, java.sql.Date.valueOf(dateStr));
        } else {
            ps.setNull(index, Types.DATE);
        }
    }

    private String getDestination(TravelRequestDto requestDto, TravelResponseDto.Summary summary) {
        if (summary != null && summary.getDestination() != null && !summary.getDestination().isBlank()) {
            return summary.getDestination();
        }
        return getSafeString(requestDto != null ? requestDto.getDestination() : null);
    }

    private String getStartDate(TravelRequestDto requestDto, TravelResponseDto.Summary summary) {
        if (summary != null && summary.getStartDate() != null && !summary.getStartDate().isBlank()) {
            return summary.getStartDate();
        }
        return requestDto != null ? requestDto.getStartDate() : null;
    }

    private String getEndDate(TravelRequestDto requestDto, TravelResponseDto.Summary summary) {
        if (summary != null && summary.getEndDate() != null && !summary.getEndDate().isBlank()) {
            return summary.getEndDate();
        }
        return requestDto != null ? requestDto.getEndDate() : null;
    }

    private int getDays(TravelRequestDto requestDto, TravelResponseDto.Summary summary) {
        if (summary != null && summary.getDays() > 0) {
            return summary.getDays();
        }

        String startDate = requestDto != null ? requestDto.getStartDate() : null;
        String endDate = requestDto != null ? requestDto.getEndDate() : null;

        try {
            if (startDate != null && endDate != null) {
                LocalDate start = LocalDate.parse(startDate);
                LocalDate end = LocalDate.parse(endDate);
                return (int) ChronoUnit.DAYS.between(start, end) + 1;
            }
        } catch (Exception ignored) {
        }

        return 0;
    }

    private int getTravelers(TravelRequestDto requestDto, TravelResponseDto.Summary summary) {
        if (summary != null && summary.getTravelers() > 0) {
            return summary.getTravelers();
        }
        return requestDto != null ? requestDto.getTravelers() : 0;
    }

    private String getTravelStyle(TravelRequestDto requestDto, TravelResponseDto.Summary summary) {
        if (summary != null && summary.getTravelStyle() != null && !summary.getTravelStyle().isBlank()) {
            return summary.getTravelStyle();
        }

        if (requestDto != null && requestDto.getStyles() != null && !requestDto.getStyles().isEmpty()) {
            return String.join(", ", requestDto.getStyles());
        }

        return "";
    }

    private String getRequestStyles(TravelRequestDto requestDto, TravelResponseDto.Summary summary) {
        LinkedHashSet<String> values = new LinkedHashSet<>();

        if (requestDto != null) {
            addAll(values, requestDto.getStyles());
            addAll(values, requestDto.getThemes());
            addAll(values, requestDto.getCustomTag());
        }

        if (summary != null) {
            addAll(values, summary.getRequestStyles());
            addAll(values, summary.getRequestThemes());
            addCustomTagsFromStrategy(values, summary.getTravelStrategy());
        }

        if (values.isEmpty()) {
            addCsv(values, getTravelStyle(requestDto, summary));
        }

        return String.join(", ", values);
    }

    private void addAll(LinkedHashSet<String> values, List<String> source) {
        if (source == null) {
            return;
        }

        for (String value : source) {
            addCsv(values, value);
        }
    }

    private void addCustomTagsFromStrategy(LinkedHashSet<String> values, Map<String, Object> strategy) {
        if (strategy == null) {
            return;
        }

        Object tags = strategy.get("customTags");
        if (tags instanceof List<?>) {
            for (Object tag : (List<?>) tags) {
                addCsv(values, tag != null ? String.valueOf(tag) : null);
            }
        } else if (tags != null) {
            addCsv(values, String.valueOf(tags));
        }
    }

    private void addCsv(LinkedHashSet<String> values, String value) {
        if (value == null) {
            return;
        }

        for (String part : value.split(",")) {
            String trimmed = part.trim();
            if (!trimmed.isEmpty()) {
                values.add(trimmed);
            }
        }
    }

    private String getSafeString(String value) {
        return value == null ? "" : value;
    }

    private String getSafeString(String value, String defaultValue) {
        return (value == null || value.isBlank()) ? defaultValue : value;
    }

    // 기존 메서드
    public void saveRequestLog(TravelRequestDto dto, String logPath) {
        // 기존 로직 유지
    }

//    public String getSavedTravelPlanJson(int planId) {
//        Connection con = null;
//        PreparedStatement ps = null;
//        ResultSet rs = null;
//        String json = null;
//
//        // plan_id를 기준으로 response_json 컬럼만 가져옵니다.
////        String sql = "SELECT response_json FROM travel_plan WHERE plan_id = ?";
//        String sql = "SELECT response_json FROM travel_plan WHERE DESTINATION = ?";
//
//        try {
//            con = DBManager_new.connect();
//            ps = con.prepareStatement(sql);
//            ps.setInt(1, planId);
//            rs = ps.executeQuery();
//
//            if (rs.next()) {
//                json = rs.getString("response_json");
//            }
//        } catch (Exception e) {
//            e.printStackTrace();
//            System.out.println("[TravelDao] getSavedTravelPlanJson ERROR: " + e.getMessage());
//        } finally {
//            // ResultSet(rs)까지 닫아주어야 합니다.
//            DBManager_new.close(con, ps, rs);
//        }
//        return json;
//    }
    public List<Map<String, Object>> getPlansByDestination(String destination) {
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        List<Map<String, Object>> list = new ArrayList<>();

        String sql = "SELECT plan_id, title, overview, days, travelers, " +
                "       travel_style, request_styles, total_estimated_cost, currency, " +
                "       destination, quality_score, start_date, end_date " +
                "FROM travel_plan " +
                "WHERE UPPER(destination) = UPPER(?) AND success = 1 AND posted = 1 " +
                "ORDER BY plan_id DESC";

        try {
            con = DBManager_new.connect();
            ps = con.prepareStatement(sql);
            ps.setString(1, destination);
            rs = ps.executeQuery();

            while (rs.next()) {
                list.add(mapPlanRow(rs));
            }

        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            DBManager_new.close(con, ps, rs);
        }
        return list;
    }

    public List<Map<String, Object>> getPlansByRequestStyle(String requestStyle) {
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        List<Map<String, Object>> list = new ArrayList<>();

        String sql = "SELECT plan_id, title, overview, days, travelers, " +
                "       travel_style, request_styles, total_estimated_cost, currency, " +
                "       destination, quality_score, start_date, end_date " +
                "FROM travel_plan " +
                "WHERE posted = 1 AND success = 1 AND request_styles IS NOT NULL " +
                "  AND LOWER(request_styles) LIKE LOWER(?) " +
                "ORDER BY plan_id DESC";

        try {
            con = DBManager_new.connect();
            ps = con.prepareStatement(sql);
            ps.setString(1, "%" + requestStyle + "%");
            rs = ps.executeQuery();

            while (rs.next()) {
                list.add(mapPlanRow(rs));
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            DBManager_new.close(con, ps, rs);
        }

        return list;
    }

    public List<Map<String, Object>> getTopRequestStyleTags(int limit) {
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        Map<String, Integer> counts = new HashMap<>();

        String sql = "SELECT request_styles FROM travel_plan " +
                "WHERE posted = 1 AND success = 1 AND request_styles IS NOT NULL";

        try {
            con = DBManager_new.connect();
            ps = con.prepareStatement(sql);
            rs = ps.executeQuery();

            while (rs.next()) {
                for (String tag : splitTags(rs.getString("request_styles"))) {
                    counts.put(tag, counts.getOrDefault(tag, 0) + 1);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            DBManager_new.close(con, ps, rs);
        }

        List<Map.Entry<String, Integer>> entries = new ArrayList<>(counts.entrySet());
        entries.sort(Comparator
                .<Map.Entry<String, Integer>>comparingInt(Map.Entry::getValue)
                .reversed()
                .thenComparing(Map.Entry::getKey));

        List<Map<String, Object>> result = new ArrayList<>();
        int max = Math.max(0, limit);
        for (int i = 0; i < entries.size() && i < max; i++) {
            Map.Entry<String, Integer> entry = entries.get(i);
            Map<String, Object> row = new LinkedHashMap<>();
            row.put("rank", i + 1);
            row.put("tag", entry.getKey());
            row.put("count", entry.getValue());
            result.add(row);
        }

        return result;
    }

    public List<Map<String, Object>> getTopDestinations(int limit) {
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        List<Map<String, Object>> result = new ArrayList<>();

        String sql = "SELECT destination, COUNT(*) AS cnt " +
                "FROM travel_plan " +
                "WHERE posted = 1 AND success = 1 AND destination IS NOT NULL " +
                "GROUP BY destination " +
                "ORDER BY cnt DESC, destination ASC";

        try {
            con = DBManager_new.connect();
            ps = con.prepareStatement(sql);
            rs = ps.executeQuery();

            int rank = 1;
            int max = Math.max(0, limit);
            while (rs.next() && result.size() < max) {
                Map<String, Object> row = new LinkedHashMap<>();
                row.put("rank", rank++);
                row.put("destination", nullSafe(rs.getString("destination")));
                row.put("count", rs.getInt("cnt"));
                row.put("imageUrl", findRepresentativeImageUrl(con, rs.getString("destination")));
                result.add(row);
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            DBManager_new.close(con, ps, rs);
        }

        return result;
    }

    private String findRepresentativeImageUrl(Connection con, String destination) {
        PreparedStatement imagePs = null;
        ResultSet imageRs = null;

        String sql = "SELECT tp.thumbnail_url, tp.response_json, NVL(pl.like_cnt, 0) AS like_cnt " +
                "FROM travel_plan tp " +
                "LEFT JOIN ( " +
                "    SELECT plan_id, COUNT(*) AS like_cnt " +
                "    FROM plan_like " +
                "    GROUP BY plan_id " +
                ") pl ON tp.plan_id = pl.plan_id " +
                "WHERE UPPER(tp.destination) = UPPER(?) AND tp.success = 1 AND tp.posted = 1 " +
                "ORDER BY NVL(pl.like_cnt, 0) DESC, tp.plan_id DESC";

        try {
            imagePs = con.prepareStatement(sql);
            imagePs.setString(1, destination);
            imageRs = imagePs.executeQuery();

            while (imageRs.next()) {
                String thumbnailUrl = nullSafe(imageRs.getString("thumbnail_url")).trim();
                if (!thumbnailUrl.isBlank() && (thumbnailUrl.startsWith("http://") || thumbnailUrl.startsWith("https://"))) {
                    return thumbnailUrl;
                }

                String imageUrl = PlanImageResolver.extractFirstImageUrl(imageRs.getString("response_json"));
                if (!imageUrl.isBlank()) {
                    return imageUrl;
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            DBManager_new.close(null, imagePs, imageRs);
        }

        return "";
    }

    private Map<String, Object> mapPlanRow(ResultSet rs) throws Exception {
        Map<String, Object> row = new LinkedHashMap<>();
        String requestStyles = rs.getString("request_styles");
        String travelStyle = nullSafe(requestStyles).isBlank()
                ? nullSafe(rs.getString("travel_style"))
                : requestStyles.trim();

        row.put("planId",             rs.getInt("plan_id"));
        row.put("title",              nullSafe(rs.getString("title")));
        row.put("overview",           nullSafe(rs.getString("overview")));
        row.put("days",               rs.getInt("days"));
        row.put("travelers",          rs.getInt("travelers"));
        row.put("travelStyle",        travelStyle);
        row.put("totalEstimatedCost", rs.getInt("total_estimated_cost"));
        row.put("currency",           nullSafe(rs.getString("currency"), "KRW"));
        row.put("destination",        nullSafe(rs.getString("destination")));
        row.put("qualityScore",       rs.getInt("quality_score"));

        java.sql.Date startDate = rs.getDate("start_date");
        java.sql.Date endDate   = rs.getDate("end_date");
        row.put("startDate", startDate != null ? startDate.toString() : "");
        row.put("endDate",   endDate   != null ? endDate.toString()   : "");

        return row;
    }

    private List<String> splitTags(String value) {
        List<String> tags = new ArrayList<>();
        if (value == null || value.trim().isEmpty()) {
            return tags;
        }

        for (String part : value.split(",")) {
            String tag = part.trim().replace("#", "");
            if (!tag.isEmpty() && !tags.contains(tag)) {
                tags.add(tag);
            }
        }

        return tags;
    }

    private String nullSafe(String value) {
        return value != null ? value : "";
    }

    private String nullSafe(String value, String defaultValue) {
        return (value != null && !value.isBlank()) ? value : defaultValue;
    }






}

