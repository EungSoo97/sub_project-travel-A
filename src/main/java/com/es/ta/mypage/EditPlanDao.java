package com.es.ta.mypage;

import com.es.ta.resultpage.TravelResultVDTO;
import com.es.ta.main.DBManager_new;
import com.es.ta.util.PlanImageResolver;
import com.fasterxml.jackson.databind.ObjectMapper;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class EditPlanDao {

    private static final ObjectMapper mapper = new ObjectMapper();

    // ── JSON 직렬화 ──
    private String toJson(TravelResultVDTO result) {
        try {
            return mapper.writeValueAsString(result);
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    // ── 저장된 플랜 불러오기 (planId 기반) ──
    public TravelResultVDTO getPlanById(String planId) {
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        String sql = "SELECT response_json FROM travel_plan WHERE plan_id = ?";
        try {
            con = DBManager_new.connect();
            ps = con.prepareStatement(sql);
            ps.setString(1, planId);
            rs = ps.executeQuery();
            if (rs.next()) {
                String json = rs.getString("response_json");
                return mapper.readValue(json, TravelResultVDTO.class);
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            DBManager_new.close(con, ps, rs);
        }
        return null;
    }

    // ── 플랜 저장 (신규) ──
    public boolean savePlan(String userId, TravelResultVDTO result) {
        Connection con = null;
        PreparedStatement ps = null;
        String sql =
            "INSERT INTO travel_plan (user_id, destination, days, response_json, thumbnail_url, created_at) VALUES (?, ?, ?, ?, ?, sysdate)";
        try {
            con = DBManager_new.connect();
            ps = con.prepareStatement(sql);
            ps.setString(1, userId);
            ps.setString(2, result.getSummary().getDestination());
            ps.setInt(3, result.getSummary().getDays());
            ps.setString(4, toJson(result));
            ps.setString(5, PlanImageResolver.resolveThumbnailUrl(result));
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            DBManager_new.close(con, ps, null);
        }
        return false;
    }

    // ── 플랜 수정 ──
    public boolean updatePlan(String planId, TravelResultVDTO result) {
        Connection con = null;
        PreparedStatement ps = null;
        String sql =
            "UPDATE travel_plan "+
            "SET response_json = ?, thumbnail_url = ?, updated_at = sysdate "+
            "WHERE plan_id = ?"
            ;
        try {
            con = DBManager_new.connect();
            ps = con.prepareStatement(sql);
            ps.setString(1, toJson(result));
            ps.setString(2, PlanImageResolver.resolveThumbnailUrl(result));
            ps.setString(3, planId);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            DBManager_new.close(con, ps, null);
        }
        return false;
    }

    // ── 플랜 삭제 ──
    public boolean deletePlan(String planId) {
        Connection con = null;
        PreparedStatement ps = null;
        String sql = "DELETE FROM travel_plan WHERE plan_id = ?";
        try {
            con = DBManager_new.connect();
            ps = con.prepareStatement(sql);
            ps.setString(1, planId);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            DBManager_new.close(con, ps, null);
        }
        return false;
    }
}
