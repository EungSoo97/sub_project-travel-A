package com.es.ta.ai;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.List;

/**
 * FastAPI {@code TravelRequest}와 필드명을 맞춤. JSON 직렬화 시 그대로 전달됨.
 */
@Data
@Builder
public class TravelRequestDto {
    private String destination;
    private String departureAirportCode;
    private String departureAirportName;
    private String departureAirportAddress;
    private String departureAirportRoutes;
    private String startDate;
    private String endDate;
    private int travelers;
    /** FastAPI 필수 — 보통 max 예산 또는 (min+max)/2 */
    private int budget;
    private String tripType;
    private List<String> styles;
    private List<String> themes;
    private int minbudget;
    private int maxbudget;
    private List<String> customTag;
    /**
     * 직전 응답의 CDI policyMode(SPARSE|NORMAL|DENSE) — 재시도·수정 요청 시 히스테리시스.
     * FastAPI {@code TravelRequest.prevPolicyMode} 와 동일. 미사용 시 생략(null).
     */
    private String prevPolicyMode;
}
