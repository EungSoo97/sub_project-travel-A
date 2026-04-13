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

        String sql = "SELECT plan_id, user_id, destination, title, start_date, end_date, " +
                "days, travelers, travel_style, total_estimated_cost, currency, overview, " +
                "success, message, response_json, created_at, updated_at " +
                "FROM travel_plan " +
                "WHERE user_id = ? " +
                "ORDER BY created_at DESC";

        try {
            con = DBManager_new.connect();
            pstmt = con.prepareStatement(sql);
            pstmt.setInt(1, userId);
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




}