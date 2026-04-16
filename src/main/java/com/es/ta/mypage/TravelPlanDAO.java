package com.es.ta.mypage;

import com.es.ta.resultpage.TravelResultVDTO;
import com.es.ta.main.DBManager_new;
import com.fasterxml.jackson.databind.ObjectMapper;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;


public class TravelPlanDAO {
    public static boolean savePlan(int userId, TravelResultVDTO result, String title) {
        Connection con = null;
        PreparedStatement pstmt = null;

        String sql = "INSERT INTO travel_plan (" +
                "plan_id, user_id, destination, title, start_date, end_date, days, travelers, " +
                "travel_style, total_estimated_cost, currency, overview, success, message, response_json, created_at, updated_at" +
                ") VALUES (" +
                "travel_plan_seq.NEXTVAL, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, SYSDATE, SYSDATE" +
                ")";

        try {
            ObjectMapper mapper = new ObjectMapper();
            String responseJson = mapper.writeValueAsString(result);

            con = DBManager_new.connect();
            pstmt = con.prepareStatement(sql);

            pstmt.setInt(1, userId);
            pstmt.setString(2, result.getSummary().getDestination());
            pstmt.setString(3, title);

            if (result.getSummary().getStartDate() != null && !result.getSummary().getStartDate().isEmpty()) {
                pstmt.setDate(4, java.sql.Date.valueOf(result.getSummary().getStartDate()));
            } else {
                pstmt.setDate(4, null);
            }

            if (result.getSummary().getEndDate() != null && !result.getSummary().getEndDate().isEmpty()) {
                pstmt.setDate(5, java.sql.Date.valueOf(result.getSummary().getEndDate()));
            } else {
                pstmt.setDate(5, null);
            }

            pstmt.setInt(6, result.getSummary().getDays());
            pstmt.setInt(7, result.getSummary().getTravelers());
            pstmt.setString(8, result.getSummary().getTravelStyle());
            pstmt.setInt(9, result.getSummary().getTotalEstimatedCost());
            pstmt.setString(10, result.getSummary().getCurrency());
            pstmt.setString(11, result.getSummary().getOverview());
            pstmt.setInt(12, result.isSuccess() ? 1 : 0);
            pstmt.setString(13, result.getMessage());
            pstmt.setString(14, responseJson);

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

    public static ArrayList<TravelPlanDTO> getPlansByUserId(int userId) {
        ArrayList<TravelPlanDTO> plans = new ArrayList<>();

        Connection con = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        String sql = "SELECT tp.plan_id, tp.user_id, tp.destination, tp.title, tp.start_date, tp.end_date, " +
                "tp.days, tp.travelers, tp.travel_style, tp.total_estimated_cost, tp.currency, tp.overview, " +
                "tp.success, tp.message, tp.response_json, tp.posted, tp.created_at, tp.updated_at, " +
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
                "ORDER BY CASE WHEN ps_user.plan_id IS NULL THEN 1 ELSE 0 END, tp.created_at DESC";

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
                plan.setTravelStyle(rs.getString("travel_style"));
                plan.setTotalEstimatedCost(rs.getInt("total_estimated_cost"));
                plan.setCurrency(rs.getString("currency"));
                plan.setOverview(rs.getString("overview"));
                plan.setSuccess(rs.getInt("success"));
                plan.setMessage(rs.getString("message"));
                plan.setResponseJson(rs.getString("response_json"));
                plan.setPosted(rs.getInt("posted"));
                plan.setLikeCnt(rs.getInt("like_cnt"));
                plan.setStarred(rs.getInt("is_starred") == 1);
                plan.setOriginalUserId(rs.getInt("original_user_id"));
                plan.setCopiedModified(rs.getInt("copied_modified"));
                plan.setCreatorName(rs.getString("creator_name"));
                plan.setEditorName(rs.getString("editor_name"));
                plan.setCreatedAt(rs.getDate("created_at"));
                plan.setUpdatedAt(rs.getDate("updated_at"));
                plans.add(plan);
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
                "days, travelers, travel_style, total_estimated_cost, currency, overview, " +
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
                plan.setTravelStyle(rs.getString("travel_style"));
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
                        "days, travelers, travel_style, total_estimated_cost, currency, overview, " +
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
                plan.setTravelStyle(rs.getString("travel_style"));
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




}
