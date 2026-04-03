package com.es.ta.ai;

import com.es.ta.main.DBManager_new;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.Types;
import java.time.LocalDate;
import java.time.temporal.ChronoUnit;

public class TravelDao {

    public static final TravelDao MDAO = new TravelDao();

    public TravelResponseDto fetchTravelPlan(TravelRequestDto dto) {
        return FastApiService.callFastApi(dto);
    }

    public void insertTravelPlan(TravelRequestDto requestDto,
                                 TravelResponseDto responseDto,
                                 String responseJson) {

        Connection con = null;
        PreparedStatement ps = null;

        String sql =
                "INSERT INTO travel_plan ( " +
                        "plan_id, user_id, destination, title, start_date, end_date, days, travelers, " +
                        "travel_style, total_estimated_cost, currency, overview, success, message, response_json " +
                        ") VALUES ( " +
                        "travel_plan_seq.NEXTVAL, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ? " +
                        ")";

        try {
            con = DBManager_new.connect();
            ps = con.prepareStatement(sql);

            TravelResponseDto.Summary summary =
                    (responseDto != null) ? responseDto.getSummary() : null;

            ps.setNull(1, Types.NUMERIC); // user_id

            ps.setString(2, getDestination(requestDto, summary));
            ps.setString(3, getSafeString(summary != null ? summary.getTitle() : null));

            setDateOrNull(ps, 4, getStartDate(requestDto, summary));
            setDateOrNull(ps, 5, getEndDate(requestDto, summary));

            ps.setInt(6, getDays(requestDto, summary));
            ps.setInt(7, getTravelers(requestDto, summary));
            ps.setString(8, getTravelStyle(requestDto, summary));

            ps.setInt(9, summary != null ? summary.getTotalEstimatedCost() : 0);
            ps.setString(10, getSafeString(summary != null ? summary.getCurrency() : null, "KRW"));
            ps.setString(11, getSafeString(summary != null ? summary.getOverview() : null));

            ps.setInt(12, (responseDto != null && responseDto.isSuccess()) ? 1 : 0);
            ps.setString(13, getSafeString(responseDto != null ? responseDto.getMessage() : null));
            ps.setString(14, getSafeString(responseJson, "{}"));

            ps.executeUpdate();
            System.out.println("travel_plan 저장 성공");

        } catch (Exception e) {
            throw new RuntimeException("travel_plan 저장 실패", e);
        } finally {
            DBManager_new.close(con, ps, null);
        }
    }

    public void saveRequestLog(TravelRequestDto dto, String logPath) {
        // 기존 요청 로그 저장 로직
    }

    private void setDateOrNull(PreparedStatement ps, int index, String dateStr) throws Exception {
        if (dateStr != null && !dateStr.isBlank()) {
            ps.setDate(index, java.sql.Date.valueOf(dateStr));
        } else {
            ps.setNull(index, Types.DATE);
        }
    }

    private String getDestination(TravelRequestDto requestDto, TravelResponseDto.Summary summary) {
        if (summary != null && summary.getDestination() != null && !summary.getDestination().isBlank()) {
            return summary.getDestination();
        }
        return getSafeString(requestDto != null ? requestDto.getDestination() : null);
    }

    private String getStartDate(TravelRequestDto requestDto, TravelResponseDto.Summary summary) {
        if (summary != null && summary.getStartDate() != null && !summary.getStartDate().isBlank()) {
            return summary.getStartDate();
        }
        return requestDto != null ? requestDto.getStartDate() : null;
    }

    private String getEndDate(TravelRequestDto requestDto, TravelResponseDto.Summary summary) {
        if (summary != null && summary.getEndDate() != null && !summary.getEndDate().isBlank()) {
            return summary.getEndDate();
        }
        return requestDto != null ? requestDto.getEndDate() : null;
    }

    private int getDays(TravelRequestDto requestDto, TravelResponseDto.Summary summary) {
        if (summary != null && summary.getDays() > 0) {
            return summary.getDays();
        }

        try {
            LocalDate start = LocalDate.parse(requestDto.getStartDate());
            LocalDate end = LocalDate.parse(requestDto.getEndDate());
            return (int) ChronoUnit.DAYS.between(start, end) + 1;
        } catch (Exception e) {
            return 0;
        }
    }

    private int getTravelers(TravelRequestDto requestDto, TravelResponseDto.Summary summary) {
        if (summary != null && summary.getTravelers() > 0) {
            return summary.getTravelers();
        }
        return requestDto != null ? requestDto.getTravelers() : 0;
    }

    private String getTravelStyle(TravelRequestDto requestDto, TravelResponseDto.Summary summary) {
        if (summary != null && summary.getTravelStyle() != null && !summary.getTravelStyle().isBlank()) {
            return summary.getTravelStyle();
        }
        if (requestDto != null && requestDto.getStyles() != null && !requestDto.getStyles().isEmpty()) {
            return String.join(", ", requestDto.getStyles());
        }
        return "";
    }

    private String getSafeString(String value) {
        return value == null ? "" : value;
    }

    private String getSafeString(String value, String defaultValue) {
        return (value == null || value.isBlank()) ? defaultValue : value;
    }
}
