package com.es.ta.mypage;

import com.es.ta.resultpage.TravelResultVDTO;
import com.es.ta.main.DBManager_new;   // 기존 DB 연결 유틸 클래스명으로 교체

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class EditPlanDao {

    // ── 저장된 플랜 불러오기 (planId 기반) ──
    public TravelResultVDTO getPlanById(String planId) {
        String sql = "SELECT plan_data FROM travel_plans WHERE plan_id = ?";

        try (Connection conn = DBManager_new.connect();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, planId);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                // JSON 직렬화 방식 사용 중이라면 역직렬화
                // String json = rs.getString("plan_data");
                // return new ObjectMapper().readValue(json, TravelResultDto.class);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    // ── 플랜 저장 (신규) ──
    public boolean savePlan(String userId, TravelResultVDTO result) {
        String sql = """
            INSERT INTO travel_plans (user_id, destination, days, plan_data, created_at)
            VALUES (?, ?, ?, ?, NOW())
            """;

        try (Connection conn = DBManager_new.connect();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, userId);
            ps.setString(2, result.getSummary().getDestination());
            ps.setInt(3, result.getSummary().getDays());
            // ps.setString(4, toJson(result));  // JSON 직렬화

            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    // ── 플랜 수정 ──
    public boolean updatePlan(String planId, TravelResultVDTO result) {
        String sql = """
            UPDATE travel_plans
            SET plan_data = ?, updated_at = NOW()
            WHERE plan_id = ?
            """;

        try (Connection conn = DBManager_new.connect();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            // ps.setString(1, toJson(result));
            ps.setString(2, planId);

            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    // ── 플랜 삭제 ──
    public boolean deletePlan(String planId) {
        String sql = "DELETE FROM travel_plans WHERE plan_id = ?";

        try (Connection conn = DBManager_new.connect();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, planId);
            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            e.printStackTrace();
        }finally {

        }
        return false;
    }
}