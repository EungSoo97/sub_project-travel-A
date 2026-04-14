package com.es.ta.resultpage;

import com.es.ta.main.DBManager_new;
import com.fasterxml.jackson.databind.DeserializationFeature;
import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class ResultpageDAO {

    public static TravelResultVDTO detailpage(int planId) {
        Connection con = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        String sql = "SELECT response_json FROM travel_plan WHERE plan_id = ?";
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

    public static List<TravelResultVDTO> getPlanList() {
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
//        String sql = "SELECT plan_id, response_json FROM travel_plan";
        String sql = "SELECT tp.plan_id, tp.response_json, NVL(pl.like_cnt, 0) AS like_cnt\n" +
                "FROM travel_plan tp\n" +
                "LEFT JOIN (\n" +
                "    SELECT plan_id, COUNT(*) AS like_cnt\n" +
                "    FROM plan_like\n" +
                "    GROUP BY plan_id\n" +
                ") pl ON tp.plan_id = pl.plan_id\n" +
                "ORDER BY tp.plan_id DESC";

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

                list.add(dto);
            }
        } catch (Exception e) {
            throw new RuntimeException(e);
        } finally {
            DBManager_new.close(con, ps, rs);
        }
        return list;
    }
    public static List<TravelResultVDTO> getPlanListSorted(String sort, int startRow, int pageSize) {
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        String orderBy = "latest".equals(sort)
                ? "tp.plan_id DESC"
                : "NVL(pl.like_cnt, 0) DESC, tp.plan_id DESC";

        String sql = "SELECT tp.plan_id, tp.response_json, NVL(pl.like_cnt, 0) AS like_cnt\n" +
                "FROM travel_plan tp\n" +
                "LEFT JOIN (\n" +
                "    SELECT plan_id, COUNT(*) AS like_cnt\n" +
                "    FROM plan_like\n" +
                "    GROUP BY plan_id\n" +
                ") pl ON tp.plan_id = pl.plan_id\n" +
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

        String sql = "SELECT COUNT(*) FROM travel_plan";

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

    public static List<TravelResultVDTO> searchPlan(String keyword) {
        List<TravelResultVDTO> list = new ArrayList<>();

        String sql =
                "SELECT * FROM travel_plan " +
                        "WHERE destination LIKE ? " +
                        "   OR title LIKE ? " +
                        "   OR travel_style LIKE ? " +
                        "ORDER BY created_at DESC";

        Connection con = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        try {
            con = DBManager_new.connect();
            pstmt = con.prepareStatement(sql);

            String q = "%" + keyword + "%";

            pstmt.setString(1, q);
            pstmt.setString(2, q);
            pstmt.setString(3, q);

            rs = pstmt.executeQuery();

            while (rs.next()) {

                // 🔥👇 여기부터 getPlanList에서 복붙
                TravelResultVDTO dto = new TravelResultVDTO();

                dto.setPlanId(rs.getInt("plan_id"));

                // ⚠️ 여기 중요
                // getPlanList에서 summary 세팅 / JSON 파싱 / 값 넣는 코드
                // 👉 그대로 복붙해야 화면 정상 나옴

                list.add(dto);
            }

        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            DBManager_new.close(con, pstmt, rs);
        }

        return list;
    }


}