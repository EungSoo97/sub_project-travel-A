package com.es.ta.mypage;

import com.es.ta.main.DBManager_new;
import com.es.ta.util.PlanImageResolver;

import java.sql.*;

public class MyPlanPageDAO {


    public static TravelPlanDTO getPlanByPlanId(int planId) {
        TravelPlanDTO plan = null;

        Connection con = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        String sql = "SELECT tp.plan_id, tp.user_id, tp.destination, tp.title, tp.start_date, tp.end_date, " +
                "tp.days, tp.travelers, tp.travel_style, tp.request_styles, tp.total_estimated_cost, tp.currency, tp.overview, " +
                "tp.success, tp.message, tp.response_json, tp.thumbnail_url, tp.posted, NVL(tp.live_tracking, 0) AS live_tracking, tp.post_date, tp.created_at, tp.updated_at, " +
                "NVL(tp.original_user_id, 0) AS original_user_id, NVL(tp.copied_modified, 1) AS copied_modified, " +
                "NVL(pl.like_cnt, 0) AS like_cnt, NVL(creator.u_name, '') AS creator_name, NVL(editor.u_name, '') AS editor_name " +
                "FROM travel_plan tp " +
                "LEFT JOIN ( " +
                "    SELECT plan_id, COUNT(*) AS like_cnt " +
                "    FROM plan_like " +
                "    GROUP BY plan_id " +
                ") pl ON tp.plan_id = pl.plan_id " +
                "LEFT JOIN user_info creator ON NVL(tp.original_user_id, tp.user_id) = creator.u_user_id " +
                "LEFT JOIN user_info editor ON tp.user_id = editor.u_user_id " +
                "WHERE tp.plan_id = ?";

        try {
            con = DBManager_new.connect();
            pstmt = con.prepareStatement(sql);
            pstmt.setInt(1, planId);
            rs = pstmt.executeQuery();

            if (rs.next()) {
                plan = mapPlan(rs);
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            DBManager_new.close(con, pstmt, rs);
        }

        return plan;
    }

    public static TravelPlanDTO getPlanByPlanIdAndUserId(int planId, int userId) {
        TravelPlanDTO plan = null;

        Connection con = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        String sql = "SELECT tp.plan_id, tp.user_id, tp.destination, tp.title, tp.start_date, tp.end_date, " +
                "tp.days, tp.travelers, tp.travel_style, tp.request_styles, tp.total_estimated_cost, tp.currency, tp.overview, " +
                "tp.success, tp.message, tp.response_json, tp.thumbnail_url, tp.posted, NVL(tp.live_tracking, 0) AS live_tracking, tp.post_date, tp.created_at, tp.updated_at, " +
                "NVL(tp.original_user_id, 0) AS original_user_id, NVL(tp.copied_modified, 1) AS copied_modified, " +
                "NVL(pl.like_cnt, 0) AS like_cnt, NVL(creator.u_name, '') AS creator_name, NVL(editor.u_name, '') AS editor_name " +
                "FROM travel_plan tp " +
                "LEFT JOIN ( " +
                "    SELECT plan_id, COUNT(*) AS like_cnt " +
                "    FROM plan_like " +
                "    GROUP BY plan_id " +
                ") pl ON tp.plan_id = pl.plan_id " +
                "LEFT JOIN user_info creator ON NVL(tp.original_user_id, tp.user_id) = creator.u_user_id " +
                "LEFT JOIN user_info editor ON tp.user_id = editor.u_user_id " +
                "WHERE tp.plan_id = ? AND tp.user_id = ?";

        try {
            con = DBManager_new.connect();
            pstmt = con.prepareStatement(sql);
            pstmt.setInt(1, planId);
            pstmt.setInt(2, userId);
            rs = pstmt.executeQuery();

            if (rs.next()) {
                plan = mapPlan(rs);
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

    public static boolean copyPostedPlanToUser(int sourcePlanId, int targetUserId) {
        Connection con = null;
        PreparedStatement ps = null;

        String sql = "INSERT INTO travel_plan (" +
                "plan_id, user_id, destination, title, start_date, end_date, days, travelers, " +
                "travel_style, request_styles, total_estimated_cost, currency, overview, success, message, " +
                "response_json, thumbnail_url, posted, post_date, original_user_id, copied_modified, created_at, updated_at" +
                ") " +
                "SELECT travel_plan_seq.NEXTVAL, ?, destination, title, start_date, end_date, days, travelers, " +
                "travel_style, request_styles, total_estimated_cost, currency, overview, success, message, " +
                "response_json, thumbnail_url, 0, NULL, NVL(original_user_id, user_id), 0, SYSDATE, SYSDATE " +
                "FROM travel_plan " +
                "WHERE plan_id = ? AND posted = 1 AND user_id <> ?";

        try {
            con = DBManager_new.connect();
            ps = con.prepareStatement(sql);
            ps.setInt(1, targetUserId);
            ps.setInt(2, sourcePlanId);
            ps.setInt(3, targetUserId);

            return ps.executeUpdate() == 1;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        } finally {
            DBManager_new.close(con, ps, null);
        }
    }

    public static boolean existsCopiedPlanByResponseJson(int sourcePlanId, int targetUserId) {
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        String sql = "SELECT COUNT(*) " +
                "FROM travel_plan mine " +
                "JOIN travel_plan source ON DBMS_LOB.COMPARE(mine.response_json, source.response_json) = 0 " +
                "WHERE source.plan_id = ? " +
                "AND mine.user_id = ? " +
                "AND mine.plan_id <> source.plan_id";

        try {
            con = DBManager_new.connect();
            ps = con.prepareStatement(sql);
            ps.setInt(1, sourcePlanId);
            ps.setInt(2, targetUserId);
            rs = ps.executeQuery();

            return rs.next() && rs.getInt(1) > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        } finally {
            DBManager_new.close(con, ps, rs);
        }
    }

    public static boolean updatePlanByPlanIdAndUserId(TravelPlanDTO plan) {
        Connection con = null;
        PreparedStatement pstmt = null;

        String sql = "UPDATE travel_plan " +
                "SET destination = ?, title = ?, start_date = ?, end_date = ?, days = ?, travelers = ?, " +
                "travel_style = ?, total_estimated_cost = ?, currency = ?, overview = ?, response_json = ?, thumbnail_url = ?, copied_modified = 1, updated_at = SYSDATE " +
                "WHERE plan_id = ? AND user_id = ?";

        try {
            con = DBManager_new.connect();
            pstmt = con.prepareStatement(sql);
            pstmt.setString(1, plan.getDestination());
            pstmt.setString(2, plan.getTitle());
            pstmt.setDate(3, toSqlDate(plan.getStartDate()));
            pstmt.setDate(4, toSqlDate(plan.getEndDate()));
            pstmt.setInt(5, plan.getDays());
            pstmt.setInt(6, plan.getTravelers());
            pstmt.setString(7, plan.getTravelStyle());
            pstmt.setInt(8, plan.getTotalEstimatedCost());
            pstmt.setString(9, plan.getCurrency());
            pstmt.setString(10, plan.getOverview());
            pstmt.setString(11, plan.getResponseJson());
            pstmt.setString(12, PlanImageResolver.resolveThumbnailUrl(plan.getResponseJson(), plan.getDestination(), plan.getPlanId()));
            pstmt.setInt(13, plan.getPlanId());
            pstmt.setInt(14, plan.getUserId());

            return pstmt.executeUpdate() == 1;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        } finally {
            try {
                if (pstmt != null) pstmt.close();
                if (con != null) con.close();
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
    }

    private static Date toSqlDate(java.util.Date date) {
        if (date == null) {
            return null;
        }
        return new Date(date.getTime());
    }

    private static TravelPlanDTO mapPlan(ResultSet rs) throws SQLException {
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
        plan.setOriginalUserId(rs.getInt("original_user_id"));
        plan.setCopiedModified(rs.getInt("copied_modified"));
        plan.setLikeCnt(rs.getInt("like_cnt"));
        plan.setCreatorName(rs.getString("creator_name"));
        plan.setEditorName(rs.getString("editor_name"));
        plan.setPostDate(rs.getDate("post_date"));
        plan.setCreatedAt(rs.getDate("created_at"));
        plan.setUpdatedAt(rs.getDate("updated_at"));
        plan.setThumbnailUrl(rs.getString("thumbnail_url"));

        return plan;
    }

    private static String displayTravelStyle(String requestStyles, String travelStyle) {
        if (requestStyles != null && !requestStyles.trim().isEmpty()) {
            return requestStyles.trim();
        }
        return travelStyle;
    }

    // 기존 MyPlanPageDAO 에 메서드 추가
    public static boolean updatePostedByPlanIdAndUserId(int planId, int userId, boolean posted) {
        Connection con = null;
        PreparedStatement ps = null;

        String sql = "UPDATE travel_plan " +
                "SET posted = ?, " +
                "post_date = CASE WHEN ? = 1 THEN SYSDATE ELSE NULL END, " +
                "updated_at = SYSDATE " +
                "WHERE plan_id = ? AND user_id = ?";

        try {
            con = DBManager_new.connect();
            ps = con.prepareStatement(sql);
            int postedValue = posted ? 1 : 0;
            ps.setInt(1, postedValue);
            ps.setInt(2, postedValue);
            ps.setInt(3, planId);
            ps.setInt(4, userId);

            return ps.executeUpdate() == 1;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        } finally {
            DBManager_new.close(con, ps, null);
        }
    }

    public static boolean updateResponseJson(int planId, int userId, String responseJson) {
        Connection con = null;
        PreparedStatement ps = null;

        String sql =
        "UPDATE travel_plan " +
        "SET response_json = ?, "+
        "   thumbnail_url = ?, " +
        "   copied_modified = 1, "+
        "   updated_at    = sysdate "+
        "WHERE plan_id = ? "+
        "AND user_id = ?";
        try {
            con = DBManager_new.connect();
            ps = con.prepareStatement(sql);
            ps.setString(1, responseJson);
            TravelPlanDTO plan = getPlanByPlanIdAndUserId(planId, userId);
            String destination = plan != null ? plan.getDestination() : "";
            ps.setString(2, PlanImageResolver.resolveThumbnailUrl(responseJson, destination, planId));
            ps.setInt(3, planId);
            ps.setInt(4, userId);

            int rows = ps.executeUpdate();
            return rows > 0;

        }catch (Exception e){
            e.printStackTrace();
        }finally {
            DBManager_new.close(con, ps, null);
        }
            return false;

    }
}
