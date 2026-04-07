package com.es.ta.resultpage;
import com.es.ta.resultpage.TravelResponseDTO;
import com.es.ta.main.DBManager_new;
import com.fasterxml.jackson.databind.DeserializationFeature;
import com.fasterxml.jackson.databind.ObjectMapper;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class ResultpageDAO {




        public static TravelResponseDTO detailpage(int id) {  // ← 반환타입 변경


            Connection con = null;
            PreparedStatement ps = null;
            ResultSet rs = null;
            String sql = "SELECT * FROM travel_plan WHERE PLAN_ID = ?";
            try {
                con = DBManager_new.connect();
                ps = con.prepareStatement(sql);
                ps.setInt(1, id);
                rs = ps.executeQuery();

                if (rs.next()) {
                    String jsonString = rs.getString("response_json");
                    ObjectMapper mapper = new ObjectMapper();
                    mapper.configure(com.fasterxml.jackson.databind.DeserializationFeature.FAIL_ON_UNKNOWN_PROPERTIES, false);  // ← 이거 추가!
                    return mapper.readValue(jsonString, TravelResponseDTO.class);  // ← 변경
                }

            } catch (Exception e) {
                throw new RuntimeException(e);
            } finally {
                DBManager_new.close(con, ps, rs);
            }
            return null;
        }
    public static List<TravelResponseDTO> getPlanList() {
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        String sql = "SELECT plan_id, response_json FROM travel_plan";
        List<TravelResponseDTO> list = new ArrayList<>();

        try {
            con = DBManager_new.connect();
            ps = con.prepareStatement(sql);
            rs = ps.executeQuery();

            ObjectMapper mapper = new ObjectMapper();
            mapper.configure(DeserializationFeature.FAIL_ON_UNKNOWN_PROPERTIES, false);

            while (rs.next()) {
                String jsonString = rs.getString("response_json");
                TravelResponseDTO dto = mapper.readValue(jsonString, TravelResponseDTO.class);
                dto.setPlanId(rs.getInt("plan_id")); // ← PK 세팅
                list.add(dto);
            }
        } catch (Exception e) {
            throw new RuntimeException(e);
        } finally {
            DBManager_new.close(con, ps, rs);
        }
        return list;
    }
    }