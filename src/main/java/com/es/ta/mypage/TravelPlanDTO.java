package com.es.ta.mypage;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.Date;
import java.util.List;

@Data
@NoArgsConstructor
@AllArgsConstructor

public class TravelPlanDTO {

    private int planId;
    private int userId;

    private String destination;
    private String title;

    private Date startDate;
    private Date endDate;

    private int days;
    private int travelers;

    private String travelStyle;
    private int totalEstimatedCost;
    private String currency;

    private String overview;

    private int success;
    private String message;

    private String responseJson;
    private int posted;
    private int likeCnt;
    private Date postDate;

    private Date createdAt;
    private Date updatedAt;

   
    // =========================
    // 💡 상태 계산 로직
    // =========================
    public String getStatus() {
        Date now = new Date();

        if (startDate == null) {
            return "작성 중";
        }
        if (endDate != null && endDate.before(now)) {
            return "완료";
        }
        if (startDate.after(now)) {
            return "예정됨";
        }
        return "여행 중";
    }

    public String getStatusClass() {
        switch (getStatus()) {
            case "작성 중":
                return "yellow";
            case "완료":
                return "green";
            case "예정됨":
            case "여행 중":
            default:
                return "blue";
        }
    }

    // =========================
    // 💡 제목 fallback 처리
    // =========================
    public String getDisplayTitle() {
        if (title != null && !title.trim().isEmpty()) {
            return title;
        }
        if (destination != null && !destination.trim().isEmpty()) {
            return destination + " 여행";
        }
        return "저장된 여행";
    }
}
