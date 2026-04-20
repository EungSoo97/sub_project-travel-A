package com.es.ta.resultpage;

import com.es.ta.explore.GooglePlaceImageService;
import com.es.ta.main.DBManager_new;
import com.fasterxml.jackson.databind.DeserializationFeature;
import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;
import javax.servlet.ServletContext;
import java.io.InputStream;
import java.util.Properties;

public class ResultpageDAO {

    public static TravelResultVDTO detailpage(int planId) {
        Connection con = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        String sql = "SELECT response_json, travel_style, request_styles FROM travel_plan WHERE plan_id = ?";
        System.out.println("조회 planId = " + planId);

        try {
            con = DBManager_new.connect();
            pstmt = con.prepareStatement(sql);
            pstmt.setInt(1, planId);
            rs = pstmt.executeQuery();

            if (rs.next()) {
                String json = rs.getString("response_json");
                TravelResultVDTO result = TravelJsonParser.parse(json);

                if (result != null) {
                    result.setPlanId(planId);
                    applyDisplayTravelStyle(result, rs.getString("request_styles"), rs.getString("travel_style"));
                }
                return result;
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try {
                if (rs != null) rs.close();
                if (pstmt != null) pstmt.close();
                if (con != null) con.close();
            } catch (Exception e) {
                e.printStackTrace();
            }
        }

        return null;
    }

    private static void applyDisplayTravelStyle(TravelResultVDTO result, String requestStyles, String travelStyle) {
        if (result == null) {
            return;
        }
        if (result.getSummary() == null) {
            result.setSummary(new TravelResultVDTO.Summary());
        }

        if (requestStyles != null && !requestStyles.trim().isEmpty()) {
            result.getSummary().setTravelStyle(requestStyles.trim());
            List<String> tags = splitTags(requestStyles);
            result.getSummary().setRequestStyles(tags);
        } else if (travelStyle != null && !travelStyle.trim().isEmpty()) {
            result.getSummary().setTravelStyle(travelStyle.trim());
        }
    }

    private static List<String> splitTags(String value) {
        List<String> tags = new ArrayList<>();
        if (value == null || value.trim().isEmpty()) {
            return tags;
        }

        for (String part : value.split(",")) {
            String tag = part.trim();
            if (!tag.isEmpty() && !tags.contains(tag)) {
                tags.add(tag);
            }
        }
        return tags;
    }

    public static List<TravelResultVDTO> getPlanList(String googleApiKey) {
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        String sql = "SELECT tp.plan_id, tp.response_json, tp.travel_style, tp.request_styles, tp.thumbnail_url, NVL(pl.like_cnt, 0) AS like_cnt, " +
                "NVL(creator.u_name, '') AS original_user_name, NVL(editor.u_name, '') AS editor_user_name, " +
                "TO_CHAR(tp.post_date, 'YYYY-MM-DD HH24:MI') AS post_date\n" +
                "FROM travel_plan tp\n" +
                "LEFT JOIN (\n" +
                "    SELECT plan_id, COUNT(*) AS like_cnt\n" +
                "    FROM plan_like\n" +
                "    GROUP BY plan_id\n" +
                ") pl ON tp.plan_id = pl.plan_id\n" +
                "LEFT JOIN user_info creator ON NVL(tp.original_user_id, tp.user_id) = creator.u_user_id\n" +
                "LEFT JOIN user_info editor ON tp.user_id = editor.u_user_id\n" +
                "WHERE tp.posted = 1\n" +
                "ORDER BY tp.post_date DESC NULLS LAST, tp.plan_id DESC";

        List<TravelResultVDTO> list = new ArrayList<>();

        try {
            con = DBManager_new.connect();
            ps = con.prepareStatement(sql);
            rs = ps.executeQuery();

            ObjectMapper mapper = new ObjectMapper();
            mapper.configure(DeserializationFeature.FAIL_ON_UNKNOWN_PROPERTIES, false);

            while (rs.next()) {
                String jsonString = rs.getString("response_json");
                TravelResultVDTO dto = mapper.readValue(jsonString, TravelResultVDTO.class);

                dto.setPlanId(rs.getInt("plan_id"));
                dto.setLikeCnt(rs.getInt("like_cnt"));
                applyDisplayTravelStyle(dto, rs.getString("request_styles"), rs.getString("travel_style"));
                dto.setOriginalUserName(rs.getString("original_user_name"));
                dto.setEditorUserName(rs.getString("editor_user_name"));
                dto.setUserName(rs.getString("original_user_name"));
                dto.setPostDate(rs.getString("post_date"));

                String thumbnailUrl = rs.getString("thumbnail_url");

                if (thumbnailUrl == null || thumbnailUrl.trim().isEmpty()) {
                    String keyword = pickThumbnailKeyword(dto);
                    System.out.println("thumbnail keyword = " + keyword);

                    thumbnailUrl = GooglePlaceImageService.getThumbnailUrlByKeyword(keyword, googleApiKey);

                    if (thumbnailUrl != null && !thumbnailUrl.trim().isEmpty()) {
                        updateThumbnailUrl(dto.getPlanId(), thumbnailUrl);
                    }
                }

                dto.setThumbnailUrl(thumbnailUrl);
                list.add(dto);
            }
        } catch (Exception e) {
            throw new RuntimeException(e);
        } finally {
            DBManager_new.close(con, ps, rs);
        }

        return list;
    }
    public static List<TravelResultVDTO> getPlanListSorted(String sort, int startRow, int pageSize, String googleApiKey) {
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        String orderBy = "latest".equals(sort)
                ? "tp.post_date DESC NULLS LAST, tp.plan_id DESC"
                : "NVL(pl.like_cnt, 0) DESC, tp.plan_id DESC";

        String sql = "SELECT tp.plan_id, tp.response_json, tp.travel_style, tp.request_styles, tp.thumbnail_url, NVL(pl.like_cnt, 0) AS like_cnt, " +
                "NVL(creator.u_name, '') AS original_user_name, NVL(editor.u_name, '') AS editor_user_name, " +
                "TO_CHAR(tp.post_date, 'YYYY-MM-DD HH24:MI') AS post_date\n" +
                "FROM travel_plan tp\n" +
                "LEFT JOIN (\n" +
                "    SELECT plan_id, COUNT(*) AS like_cnt\n" +
                "    FROM plan_like\n" +
                "    GROUP BY plan_id\n" +
                ") pl ON tp.plan_id = pl.plan_id\n" +
                "LEFT JOIN user_info creator ON NVL(tp.original_user_id, tp.user_id) = creator.u_user_id\n" +
                "LEFT JOIN user_info editor ON tp.user_id = editor.u_user_id\n" +
                "WHERE tp.posted = 1\n" +
                "ORDER BY " + orderBy + "\n" +
                "OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";

        List<TravelResultVDTO> list = new ArrayList<>();

        try {
            con = DBManager_new.connect();
            ps = con.prepareStatement(sql);
            ps.setInt(1, startRow);
            ps.setInt(2, pageSize);
            rs = ps.executeQuery();

            ObjectMapper mapper = new ObjectMapper();
            mapper.configure(DeserializationFeature.FAIL_ON_UNKNOWN_PROPERTIES, false);

            while (rs.next()) {
                String jsonString = rs.getString("response_json");
                TravelResultVDTO dto = mapper.readValue(jsonString, TravelResultVDTO.class);

                dto.setPlanId(rs.getInt("plan_id"));
                dto.setLikeCnt(rs.getInt("like_cnt"));
                applyDisplayTravelStyle(dto, rs.getString("request_styles"), rs.getString("travel_style"));
                dto.setOriginalUserName(rs.getString("original_user_name"));
                dto.setEditorUserName(rs.getString("editor_user_name"));
                dto.setUserName(rs.getString("original_user_name"));
                dto.setPostDate(rs.getString("post_date"));

                String thumbnailUrl = rs.getString("thumbnail_url");

                if (thumbnailUrl == null || thumbnailUrl.trim().isEmpty()) {
                    String keyword = pickThumbnailKeyword(dto);

                    thumbnailUrl = GooglePlaceImageService.getThumbnailUrlByKeyword(keyword, googleApiKey);

                    if (thumbnailUrl != null && !thumbnailUrl.trim().isEmpty()) {
                        updateThumbnailUrl(dto.getPlanId(), thumbnailUrl);
                    }
                }

                dto.setThumbnailUrl(thumbnailUrl);
                list.add(dto);
            }
        } catch (Exception e) {
            throw new RuntimeException(e);
        } finally {
            DBManager_new.close(con, ps, rs);
        }
        return list;
    }
    public static int getTotalPlanCount() {
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        String sql = "SELECT COUNT(*) FROM travel_plan WHERE posted = 1";

        try {
            con = DBManager_new.connect();
            ps = con.prepareStatement(sql);
            rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (Exception e) {
            throw new RuntimeException(e);
        } finally {
            DBManager_new.close(con, ps, rs);
        }
        return 0;
    }

    public static List<TravelResultVDTO> searchPlans(String q, String selectedTags, String googleApiKey) {

        // 🔥 전체 플랜 가져오기 (썸네일 포함)
        List<TravelResultVDTO> allPlans = ResultpageDAO.getPlanList(googleApiKey);

        List<TravelResultVDTO> result = new ArrayList<>();

        // 🔍 검색어 정리
        String keyword = (q != null) ? q.trim().toLowerCase() : "";

        // 🏷️ 태그 파싱 (#먹방,#도쿄 형태)
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

            // 🔍 키워드 필터
            if (!keyword.isEmpty()) {
                String title = (plan.getSummary() != null && plan.getSummary().getTitle() != null)
                        ? plan.getSummary().getTitle().toLowerCase()
                        : "";
                String destination = (plan.getSummary() != null && plan.getSummary().getDestination() != null)
                        ? plan.getSummary().getDestination().toLowerCase()
                        : "";

                matchKeyword = title.contains(keyword) || destination.contains(keyword);
            }

            // 🏷️ 태그 필터
            if (!tagList.isEmpty()) {
                List<String> planTags = (plan.getSummary() != null && plan.getSummary().getCustomTags() != null)
                        ? plan.getSummary().getCustomTags()
                        : new ArrayList<>();

                matchTag = false;

                for (String tag : tagList) {
                    for (String planTag : planTags) {
                        if (planTag.toLowerCase().contains(tag)) {
                            matchTag = true;
                            break;
                        }
                    }
                    if (matchTag) break;
                }
            }

            // ✅ 둘 다 만족해야 추가
            if (matchKeyword && matchTag) {
                result.add(plan);
            }
        }

        return result;
    }
    public static void updateThumbnailUrl(int planId, String thumbnailUrl) {
        Connection con = null;
        PreparedStatement ps = null;

        String sql = "UPDATE travel_plan SET thumbnail_url = ? WHERE plan_id = ?";

        try {
            con = DBManager_new.connect();
            ps = con.prepareStatement(sql);
            ps.setString(1, thumbnailUrl);
            ps.setInt(2, planId);
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            DBManager_new.close(con, ps, null);
        }
    }
    private static String pickThumbnailKeyword(TravelResultVDTO dto) {
        String destination = null;

        if (dto != null && dto.getSummary() != null) {
            destination = safeTrim(dto.getSummary().getDestination());
        }

        if (dto != null && dto.getItinerary() != null) {
            for (TravelResultVDTO.Itinerary day : dto.getItinerary()) {
                if (day == null || day.getActivities() == null) {
                    continue;
                }

                for (TravelResultVDTO.Activity activity : day.getActivities()) {
                    if (activity == null) {
                        continue;
                    }

                    String type = safeTrim(activity.getType());
                    String category = safeTrim(activity.getCategory());
                    String name = safeTrim(activity.getName());

                    boolean isSpot =
                            "SPOT".equalsIgnoreCase(type) ||
                                    (category != null && (
                                            category.contains("관광") ||
                                                    category.contains("명소") ||
                                                    category.contains("랜드마크") ||
                                                    category.toLowerCase().contains("spot") ||
                                                    category.toLowerCase().contains("attraction")
                                    ));

                    // 대표 썸네일용으로는 별로인 장소들
                    boolean looksBadForThumbnail =
                            name != null && (
                                    name.toLowerCase().contains("museum") ||
                                            name.toLowerCase().contains("gallery") ||
                                            name.toLowerCase().contains("hotel") ||
                                            name.toLowerCase().contains("airport") ||
                                            name.toLowerCase().contains("station") ||
                                            name.toLowerCase().contains("service center") ||
                                            name.contains("박물관") ||
                                            name.contains("미술관") ||
                                            name.contains("호텔") ||
                                            name.contains("공항") ||
                                            name.contains("역") ||
                                            name.contains("안내소")
                            );

                    if (isSpot && name != null && !name.isEmpty() && !looksBadForThumbnail) {
                        if (destination != null && !destination.isEmpty()) {
                            return name + " " + destination;
                        }
                        return name;
                    }
                }
            }
        }

        // 관광지다운 대표 키워드가 없으면 도시 자체로
        if (destination != null && !destination.isEmpty()) {
            return destination;
        }

        return "Japan";
    }

    private static String safeTrim(String text) {
        return text == null ? null : text.trim();
    }
}
