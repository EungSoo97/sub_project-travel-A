package com.es.ta.mypage;

import com.es.ta.resultpage.TravelResultVDTO;
import com.es.ta.main.DBManager_new;
import com.es.ta.util.PlanImageResolver;
import com.fasterxml.jackson.databind.ObjectMapper;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.LinkedHashSet;
import java.util.List;


public class TravelPlanDAO {
    public static boolean savePlan(int userId, TravelResultVDTO result, String title) {
        Connection con = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        String sql = "INSERT INTO travel_plan (" +
                "plan_id, user_id, destination, title, start_date, end_date, days, travelers, " +
                "travel_style, request_styles, total_estimated_cost, currency, overview, success, message, response_json, thumbnail_url, created_at, updated_at" +
                ") VALUES (" +
                "?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, SYSDATE, SYSDATE" +
                ")";

        try {
            ObjectMapper mapper = new ObjectMapper();
            String responseJson = mapper.writeValueAsString(result);

            con = DBManager_new.connect();
            int planId = getNextPlanId(con);
            pstmt = con.prepareStatement(sql);

            pstmt.setInt(1, planId);
            pstmt.setInt(2, userId);
            pstmt.setString(3, result.getSummary().getDestination());
            pstmt.setString(4, title);

            if (result.getSummary().getStartDate() != null && !result.getSummary().getStartDate().isEmpty()) {
                pstmt.setDate(5, java.sql.Date.valueOf(result.getSummary().getStartDate()));
            } else {
                pstmt.setDate(5, null);
            }

            if (result.getSummary().getEndDate() != null && !result.getSummary().getEndDate().isEmpty()) {
                pstmt.setDate(6, java.sql.Date.valueOf(result.getSummary().getEndDate()));
            } else {
                pstmt.setDate(6, null);
            }

            pstmt.setInt(7, result.getSummary().getDays());
            pstmt.setInt(8, result.getSummary().getTravelers());
            pstmt.setString(9, result.getSummary().getTravelStyle());
            pstmt.setString(10, buildRequestStyles(result));
            pstmt.setInt(11, result.getSummary().getTotalEstimatedCost());
            pstmt.setString(12, result.getSummary().getCurrency());
            pstmt.setString(13, result.getSummary().getOverview());
            pstmt.setInt(14, result.isSuccess() ? 1 : 0);
            pstmt.setString(15, result.getMessage());
            pstmt.setString(16, responseJson);
            pstmt.setString(17, PlanImageResolver.resolveThumbnailUrl(result, planId));

            return pstmt.executeUpdate() == 1;

        } catch (Exception e) {
            e.printStackTrace();
            return false;
        } finally {
            try {
                if (rs != null) rs.close();
                if (pstmt != null) pstmt.close();
                if (con != null) con.close();
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
    }

    private static int getNextPlanId(Connection con) throws Exception {
        try (PreparedStatement pstmt = con.prepareStatement("SELECT travel_plan_seq.NEXTVAL FROM dual");
             ResultSet rs = pstmt.executeQuery()) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        }
        throw new IllegalStateException("Failed to allocate plan id");
    }

    private static String buildRequestStyles(TravelResultVDTO result) {
        if (result == null || result.getSummary() == null) {
            return "";
        }

        LinkedHashSet<String> values = new LinkedHashSet<>();
        TravelResultVDTO.Summary summary = result.getSummary();

        addAll(values, summary.getRequestStyles());
        addAll(values, summary.getRequestThemes());
        addAll(values, summary.getCustomTags());

        if (values.isEmpty() && summary.getTravelStyle() != null && !summary.getTravelStyle().isBlank()) {
            addCsv(values, summary.getTravelStyle());
        }

        return String.join(", ", values);
    }

    private static void addAll(LinkedHashSet<String> values, List<String> source) {
        if (source == null) {
            return;
        }

        for (String value : source) {
            addCsv(values, value);
        }
    }

    private static void addCsv(LinkedHashSet<String> values, String value) {
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

    public static ArrayList<TravelPlanDTO> getPlansByUserId(int userId) {
        ArrayList<TravelPlanDTO> plans = new ArrayList<>();

        Connection con = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        String sql = "SELECT tp.plan_id, tp.user_id, tp.destination, tp.title, tp.start_date, tp.end_date, " +
                "tp.days, tp.travelers, tp.travel_style, tp.request_styles, tp.total_estimated_cost, tp.currency, tp.overview, " +
                "tp.success, tp.message, tp.response_json, " +
                "NVL(tp.thumbnail_url, ( " +
                "    SELECT src.thumbnail_url " +
                "    FROM travel_plan src " +
                "    WHERE src.posted = 1 " +
                "    AND src.thumbnail_url IS NOT NULL " +
                "    AND src.plan_id <> tp.plan_id " +
                "    AND DBMS_LOB.COMPARE(src.response_json, tp.response_json) = 0 " +
                "    FETCH FIRST 1 ROW ONLY " +
                ")) AS thumbnail_url, " +
                "tp.posted, NVL(tp.live_tracking, 0) AS live_tracking, tp.created_at, tp.updated_at, " +
                "NVL(tp.original_user_id, 0) AS original_user_id, NVL(tp.copied_modified, 1) AS copied_modified, " +
                "NVL(pl.like_cnt, 0) AS like_cnt, " +
                "CASE WHEN ps_user.plan_id IS NULL THEN 0 ELSE 1 END AS is_starred, " +
                "NVL(creator.u_name, '') AS creator_name, NVL(editor.u_name, '') AS editor_name " +
                "FROM travel_plan tp " +
                "LEFT JOIN ( " +
                "    SELECT plan_id, COUNT(*) AS like_cnt " +
                "    FROM plan_like " +
                "    GROUP BY plan_id " +
                ") pl ON tp.plan_id = pl.plan_id " +
                "LEFT JOIN plan_star ps_user ON tp.plan_id = ps_user.plan_id AND ps_user.user_id = ? " +
                "LEFT JOIN user_info creator ON NVL(tp.original_user_id, tp.user_id) = creator.u_user_id " +
                "LEFT JOIN user_info editor ON tp.user_id = editor.u_user_id " +
                "WHERE tp.user_id = ? " +
                "ORDER BY NVL(tp.live_tracking, 0) DESC, CASE WHEN ps_user.plan_id IS NULL THEN 1 ELSE 0 END, tp.created_at DESC";

        try {
            con = DBManager_new.connect();
            pstmt = con.prepareStatement(sql);
            pstmt.setInt(1, userId);
            pstmt.setInt(2, userId);
            rs = pstmt.executeQuery();

            while (rs.next()) {
                TravelPlanDTO plan = new TravelPlanDTO();
                plan.setPlanId(rs.getInt("plan_id"));
                plan.setUserId(rs.getInt("user_id"));
                plan.setDestination(rs.getString("destination"));
                plan.setTitle(rs.getString("title"));
                plan.setStartDate(rs.getDate("start_date"));
                plan.setEndDate(rs.getDate("end_date"));
                plan.setDays(rs.getInt("days"));
                plan.setTravelers(rs.getInt("travelers"));
                plan.setRequestStyles(rs.getString("request_styles"));
                plan.setTravelStyle(displayTravelStyle(rs.getString("request_styles"), rs.getString("travel_style")));
                plan.setTotalEstimatedCost(rs.getInt("total_estimated_cost"));
                plan.setCurrency(rs.getString("currency"));
                plan.setOverview(rs.getString("overview"));
                plan.setSuccess(rs.getInt("success"));
                plan.setMessage(rs.getString("message"));
                plan.setResponseJson(rs.getString("response_json"));
                plan.setPosted(rs.getInt("posted"));
                plan.setLiveTracking(rs.getInt("live_tracking"));
                plan.setLikeCnt(rs.getInt("like_cnt"));
                plan.setStarred(rs.getInt("is_starred") == 1);
                plan.setOriginalUserId(rs.getInt("original_user_id"));
                plan.setCopiedModified(rs.getInt("copied_modified"));
                plan.setCreatorName(rs.getString("creator_name"));
                plan.setEditorName(rs.getString("editor_name"));
                plan.setCreatedAt(rs.getDate("created_at"));
                plan.setUpdatedAt(rs.getDate("updated_at"));
                plans.add(plan);
                plan.setThumbnailUrl(rs.getString("thumbnail_url"));

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

        return plans;
    }

    public static TravelPlanDTO getPlanByPlanIdAndUserId(int planId, int userId) {
        TravelPlanDTO plan = null;

        Connection con = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        String sql = "SELECT plan_id, user_id, destination, title, start_date, end_date, " +
                "days, travelers, travel_style, request_styles, total_estimated_cost, currency, overview, " +
                "success, message, response_json, created_at, updated_at " +
                "FROM travel_plan " +
                "WHERE plan_id = ? AND user_id = ?";

        try {
            con = DBManager_new.connect();
            pstmt = con.prepareStatement(sql);
            pstmt.setInt(1, planId);
            pstmt.setInt(2, userId);
            rs = pstmt.executeQuery();

            if (rs.next()) {
                plan = new TravelPlanDTO();
                plan.setPlanId(rs.getInt("plan_id"));
                plan.setUserId(rs.getInt("user_id"));
                plan.setDestination(rs.getString("destination"));
                plan.setTitle(rs.getString("title"));
                plan.setStartDate(rs.getDate("start_date"));
                plan.setEndDate(rs.getDate("end_date"));
                plan.setDays(rs.getInt("days"));
                plan.setTravelers(rs.getInt("travelers"));
                plan.setRequestStyles(rs.getString("request_styles"));
                plan.setTravelStyle(displayTravelStyle(rs.getString("request_styles"), rs.getString("travel_style")));
                plan.setTotalEstimatedCost(rs.getInt("total_estimated_cost"));
                plan.setCurrency(rs.getString("currency"));
                plan.setOverview(rs.getString("overview"));
                plan.setSuccess(rs.getInt("success"));
                plan.setMessage(rs.getString("message"));
                plan.setResponseJson(rs.getString("response_json"));
                plan.setCreatedAt(rs.getDate("created_at"));
                plan.setUpdatedAt(rs.getDate("updated_at"));
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

        return plan;
    }
    public static final TravelPlanDAO DAO = new TravelPlanDAO();

    private TravelPlanDAO() {
    }


    public boolean existsPlan(int planId) {
        String sql = "SELECT 1 FROM travel_plan WHERE plan_id = ?";
        Connection con = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        try {
            con = DBManager_new.connect();
            pstmt = con.prepareStatement(sql);
            pstmt.setInt(1, planId);
            rs = pstmt.executeQuery();
            return rs.next();
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        } finally {
            DBManager_new.close(con, pstmt, rs);
        }
    }

    public static boolean deletePlanByPlanIdAndUserId(int planId, int userId) {
        Connection con = null;
        PreparedStatement deleteReviews = null;
        PreparedStatement deleteLikes = null;
        PreparedStatement deleteStars = null;
        PreparedStatement deletePlan = null;

        try {
            con = DBManager_new.connect();
            con.setAutoCommit(false);

            deleteReviews = con.prepareStatement("DELETE FROM review WHERE plan_id = ?");
            deleteReviews.setInt(1, planId);
            deleteReviews.executeUpdate();

            deleteLikes = con.prepareStatement("DELETE FROM plan_like WHERE plan_id = ?");
            deleteLikes.setInt(1, planId);
            deleteLikes.executeUpdate();

            deleteStars = con.prepareStatement("DELETE FROM plan_star WHERE plan_id = ?");
            deleteStars.setInt(1, planId);
            deleteStars.executeUpdate();

            deletePlan = con.prepareStatement("DELETE FROM travel_plan WHERE plan_id = ? AND user_id = ?");
            deletePlan.setInt(1, planId);
            deletePlan.setInt(2, userId);

            boolean deleted = deletePlan.executeUpdate() == 1;
            con.commit();
            return deleted;
        } catch (Exception e) {
            e.printStackTrace();
            try {
                if (con != null) {
                    con.rollback();
                }
            } catch (Exception rollbackError) {
                rollbackError.printStackTrace();
            }
            return false;
        } finally {
            try {
                if (deletePlan != null) deletePlan.close();
                if (deleteStars != null) deleteStars.close();
                if (deleteLikes != null) deleteLikes.close();
                if (deleteReviews != null) deleteReviews.close();
                if (con != null) {
                    con.setAutoCommit(true);
                    con.close();
                }
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
    }

    public static ArrayList<TravelPlanDTO> getTrendList(int userId) {
        ArrayList<TravelPlanDTO> trendList = new ArrayList<>();
        Connection con =null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        String sql ="SELECT destination, COUNT(*) as cnt " +
                "FROM travel_plan " +
                "WHERE user_id = ? " +
                "GROUP BY destination " +
                "ORDER BY cnt DESC";
        try {
            con = DBManager_new.connect();
            ps = con.prepareStatement(sql);
            ps.setInt(1, userId);
            rs = ps.executeQuery();

            while (rs.next()){
                TravelPlanDTO plan = new TravelPlanDTO();
                plan.setDestination(rs.getString("destination"));
                plan.setPlanId(rs.getInt("cnt"));
                trendList.add(plan);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }finally {
            DBManager_new.close(con, ps, rs);
        }
        return trendList;
    }

    public static ArrayList<TravelPlanDTO> searchPlansByUserId(int userId, String keyword) {
        ArrayList<TravelPlanDTO> plans = new ArrayList<>();

        Connection con = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        String sql =
                        "SELECT plan_id, user_id, destination, title, start_date, end_date, " +
                        "days, travelers, travel_style, request_styles, total_estimated_cost, currency, overview, " +
                        "success, message, response_json, created_at, updated_at " +
                        "FROM travel_plan " +
                        "WHERE user_id = ? " +
                        "AND (LOWER(title) LIKE ? OR LOWER(destination) LIKE ?) " +
                        "ORDER BY created_at DESC";

        try {
            con = DBManager_new.connect();
            pstmt = con.prepareStatement(sql);
            pstmt.setInt(1, userId);
            pstmt.setString(2, "%" + keyword.toLowerCase() + "%");
            pstmt.setString(3, "%" + keyword.toLowerCase() + "%");
            rs = pstmt.executeQuery();

            while (rs.next()) {
                TravelPlanDTO plan = new TravelPlanDTO();
                plan.setPlanId(rs.getInt("plan_id"));
                plan.setUserId(rs.getInt("user_id"));
                plan.setDestination(rs.getString("destination"));
                plan.setTitle(rs.getString("title"));
                plan.setStartDate(rs.getDate("start_date"));
                plan.setEndDate(rs.getDate("end_date"));
                plan.setDays(rs.getInt("days"));
                plan.setTravelers(rs.getInt("travelers"));
                plan.setRequestStyles(rs.getString("request_styles"));
                plan.setTravelStyle(displayTravelStyle(rs.getString("request_styles"), rs.getString("travel_style")));
                plan.setTotalEstimatedCost(rs.getInt("total_estimated_cost"));
                plan.setCurrency(rs.getString("currency"));
                plan.setOverview(rs.getString("overview"));
                plan.setSuccess(rs.getInt("success"));
                plan.setMessage(rs.getString("message"));
                plan.setResponseJson(rs.getString("response_json"));
                plan.setCreatedAt(rs.getDate("created_at"));
                plan.setUpdatedAt(rs.getDate("updated_at"));
                plans.add(plan);
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            DBManager_new.close(con, pstmt, rs);
        }

        return plans;
    }

    public static ArrayList<TravelPlanDTO> searchPlanSuggestionsByUserId(int userId, String keyword) {
        ArrayList<TravelPlanDTO> plans = new ArrayList<>();

        Connection con = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        String sql =
                "SELECT plan_id, destination, title " +
                        "FROM travel_plan " +
                        "WHERE user_id = ? " +
                        "AND (LOWER(title) LIKE ? OR LOWER(destination) LIKE ?) " +
                        "ORDER BY created_at DESC";

        try {
            con = DBManager_new.connect();
            pstmt = con.prepareStatement(sql);
            pstmt.setInt(1, userId);
            pstmt.setString(2, "%" + keyword.toLowerCase() + "%");
            pstmt.setString(3, "%" + keyword.toLowerCase() + "%");
            rs = pstmt.executeQuery();

            int count = 0;
            while (rs.next() && count < 5) {
                TravelPlanDTO plan = new TravelPlanDTO();
                plan.setPlanId(rs.getInt("plan_id"));
                plan.setDestination(rs.getString("destination"));
                plan.setTitle(rs.getString("title"));
                plans.add(plan);
                count++;
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            DBManager_new.close(con, pstmt, rs);
        }

        return plans;
    }

    private static String displayTravelStyle(String requestStyles, String travelStyle) {
        if (requestStyles != null && !requestStyles.trim().isEmpty()) {
            return requestStyles.trim();
        }
        return travelStyle;
    }




}
