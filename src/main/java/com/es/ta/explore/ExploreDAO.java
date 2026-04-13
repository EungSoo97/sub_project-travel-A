package com.es.ta.explore;

import com.es.ta.main.DBManager_new;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class ExploreDAO {

    public static List<ExploreDTO> searchAutocomplete(String keyword) {
        List<ExploreDTO> result = new ArrayList<>();

        String sql =
                "SELECT plan_id, destination, title, travel_style " +
                        "FROM travel_plan " +
                        "WHERE destination LIKE ? " +
                        "   OR title LIKE ? " +
                        "   OR request_styles LIKE ? " +
                        "   OR request_themes LIKE ? " +
                        "ORDER BY " +
                        "   CASE " +
                        "       WHEN destination LIKE ? THEN 1 " +
                        "       WHEN title LIKE ? THEN 2 " +
                        "       ELSE 3 " +
                        "   END, " +
                        "   created_at DESC " +
                        "FETCH FIRST 5 ROWS ONLY";

        Connection con = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        try {
            con = DBManager_new.connect();
            pstmt = con.prepareStatement(sql);

            String q = "%" + keyword + "%";
            String startsQ = keyword + "%";

            pstmt.setString(1, q);
            pstmt.setString(2, q);
            pstmt.setString(3, q);
            pstmt.setString(4, q);
            pstmt.setString(5, startsQ);
            pstmt.setString(6, startsQ);

            rs = pstmt.executeQuery();

            while (rs.next()) {
                ExploreDTO dto = new ExploreDTO();

                dto.setPlanId(rs.getInt("plan_id"));
                dto.setDestination(rs.getString("destination"));
                dto.setTitle(rs.getString("title"));
                dto.setTravelStyle(rs.getString("travel_style"));

                result.add(dto);
            }

        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            DBManager_new.close(con, pstmt, rs);
        }

        return result;
    }
}