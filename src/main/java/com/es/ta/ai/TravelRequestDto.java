package com.es.ta.ai;

import lombok.Builder;
import lombok.Data;

import java.util.List;

/**
 * FastAPI {@code TravelRequest}와 필드명을 맞춤. JSON 직렬화 시 그대로 전달됨.
 */
@Data
@Builder
public class TravelRequestDto {
    private String destination;
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
}