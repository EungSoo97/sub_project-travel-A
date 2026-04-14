package com.es.ta.resultpage;

import com.es.ta.ai.TravelResponseDto;
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

//        public static List<TravelResultVDTO> getPlanList() {
//            Connection con = null;
//            PreparedStatement ps = null;
//            ResultSet rs = null;
//    //        String sql = "SELECT plan_id, response_json FROM travel_plan";
//            String sql = "SELECT tp.plan_id, tp.response_json, tp.created_at, NVL(pl.like_cnt, 0) AS like_cnt " +
//                    "FROM travel_plan tp " +
//                    "LEFT JOIN ( " +
//                    "    SELECT plan_id, COUNT(*) AS like_cnt " +
//                    "    FROM plan_like " +
//                    "    GROUP BY plan_id " +
//                    ") pl ON tp.plan_id = pl.plan_id " +
//                    "ORDER BY tp.plan_id DESC";
//
//            List<TravelResultVDTO> list = new ArrayList<>();
//
//            try {
//                con = DBManager_new.connect();
//                ps = con.prepareStatement(sql);
//                rs = ps.executeQuery();
//
//                ObjectMapper mapper = new ObjectMapper();
//                mapper.configure(DeserializationFeature.FAIL_ON_UNKNOWN_PROPERTIES, false);
//
//                while (rs.next()) {
//                    String jsonString = rs.getString("response_json");
//                    TravelResultVDTO dto = mapper.readValue(jsonString, TravelResultVDTO.class);
//                    dto.setPlanId(rs.getInt("plan_id"));
//                    dto.setLikeCnt(rs.getInt("like_cnt"));
//                    String createdAt = rs.getString("created_at");
//                    dto.setCreatedAt(createdAt);
//                    list.add(dto);
//                }
//            } catch (Exception e) {
//                throw new RuntimeException(e);
//            } finally {
//                DBManager_new.close(con, ps, rs);
//            }
//            return list;
//        }

    public static List<TravelResultVDTO> getPlanListSorted(String sort, int startRow, int pageSize) {
        List<TravelResultVDTO> list = new ArrayList<>();
        Connection con =null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        ObjectMapper mapper = new ObjectMapper();

        String orderBy = "created_at DESC";
        if ("popular".equals(sort)){
orderBy = "like_cnt DESC, created_at DESC";
        }
        String sql = "SELECT * FROM (\n" +
                "    SELECT tp.plan_id, tp.response_json, tp.created_at, NVL(pl.like_cnt, 0) AS like_cnt,\n" +
                "           ROWNUM as rn\n" +
                "    FROM travel_plan tp\n" +
                "    LEFT JOIN (\n" +
                "        SELECT plan_id, COUNT(*) AS like_cnt\n" +
                "        FROM plan_like\n" +
                "        GROUP BY plan_id\n" +
                "    ) pl ON tp.plan_id = pl.plan_id\n" +
                "    ORDER BY " + orderBy + "\n" +
                ") WHERE rn BETWEEN ? AND ?";

        try {
        con = DBManager_new.connect();
        ps = con.prepareStatement(sql);
        ps.setInt(1, startRow+1);
        ps.setInt(2, startRow + pageSize);
        rs = ps.executeQuery();

        while (rs.next()){
            TravelResultVDTO dto = new TravelResultVDTO();
            dto.setPlanId(rs.getInt("plan_id"));
            dto.setLikeCnt(rs.getInt("like_cnt"));
            java.sql.Timestamp createdAt = rs.getTimestamp("created_at");
            if (createdAt != null) {
                dto.setCreatedAt(new java.text.SimpleDateFormat("yyyy.MM.dd").format(createdAt));
            }
            String jsonStr = rs.getString("response_json");
            if (jsonStr != null) {
                JsonNode root = mapper.readTree(jsonStr);
                JsonNode summaryNode = root.get("summary"); // JSON 내의 summary 부분만 추출

                // summaryNode를 바로 내 VDTO의 Summary 클래스로 변환
                TravelResultVDTO.Summary mySum = mapper.treeToValue(summaryNode, TravelResultVDTO.Summary.class);
                dto.setSummary(mySum);
            }
            list.add(dto);

        }

    } catch (Exception e) {
            e.printStackTrace();
        }finally {
            DBManager_new.close(con, ps, rs);
        }
        return list;
    }

    public static int getTotalPlanCount() {
        int total = 0;
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        String sql = "SELECT COUNT(*) FROM travel_plan";
        try {
        con =DBManager_new.connect();
        ps = con.prepareStatement(sql);
        rs = ps.executeQuery();
        if (rs.next()) {
            total = rs.getInt(1);
        }
        } catch (Exception e) {
            e.printStackTrace();
        }finally {
            DBManager_new.close(con, ps, rs);
        }
        return total;

    }

}