package com.es.ta.mypage;

import com.es.ta.main.DBManager_new;

import java.sql.*;

public class MyPlanPageDAO {


    public static TravelPlanDTO getPlanByPlanId(int planId) {
        TravelPlanDTO plan = null;

        Connection con = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        String sql = "SELECT plan_id, user_id, destination, title, start_date, end_date, " +
                "days, travelers, travel_style, total_estimated_cost, currency, overview, " +
                "success, message, response_json, posted, post_date, created_at, updated_at " +
                "FROM travel_plan " +
                "WHERE plan_id = ?";

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

        String sql = "SELECT plan_id, user_id, destination, title, start_date, end_date, " +
                "days, travelers, travel_style, total_estimated_cost, currency, overview, " +
                "success, message, response_json, posted, post_date, created_at, updated_at " +
                "FROM travel_plan " +
                "WHERE plan_id = ? AND user_id = ?";

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
                "travel_style, total_estimated_cost, currency, overview, success, message, " +
                "response_json, posted, post_date, created_at, updated_at" +
                ") " +
                "SELECT travel_plan_seq.NEXTVAL, ?, destination, title, start_date, end_date, days, travelers, " +
                "travel_style, total_estimated_cost, currency, overview, success, message, " +
                "response_json, 0, NULL, SYSDATE, SYSDATE " +
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
                "travel_style = ?, total_estimated_cost = ?, currency = ?, overview = ?, response_json = ?, updated_at = SYSDATE " +
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
            pstmt.setInt(12, plan.getPlanId());
            pstmt.setInt(13, plan.getUserId());

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
        plan.setTravelStyle(rs.getString("travel_style"));
        plan.setTotalEstimatedCost(rs.getInt("total_estimated_cost"));
        plan.setCurrency(rs.getString("currency"));
        plan.setOverview(rs.getString("overview"));
        plan.setSuccess(rs.getInt("success"));
        plan.setMessage(rs.getString("message"));
        plan.setResponseJson(rs.getString("response_json"));
        plan.setPosted(rs.getInt("posted"));
        plan.setPostDate(rs.getDate("post_date"));
        plan.setCreatedAt(rs.getDate("created_at"));
        plan.setUpdatedAt(rs.getDate("updated_at"));
        plan.setThumbnailUrl(rs.getString("thumbnail_url"));

        return plan;
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
        "   updated_at    = sysdate "+
        "WHERE plan_id = ? "+
        "AND user_id = ?";
        try {
            con = DBManager_new.connect();
            ps = con.prepareStatement(sql);
            ps.setString(1, responseJson);
            ps.setInt(2, planId);
            ps.setInt(3, userId);

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
