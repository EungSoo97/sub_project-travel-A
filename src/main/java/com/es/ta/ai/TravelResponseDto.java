package com.es.ta.ai;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import lombok.*;

import java.util.List;
import java.util.Map;

/**
 * FastAPI {@code /api/v1/travel/plan} 성공 응답과 정렬한 DTO.
 * <ul>
 *   <li>{@code summary.travelStyle} — 표시용 단일 라벨(첫 스타일 또는 엔진 요약).</li>
 *   <li>{@code summary.requestStyles} / {@code requestThemes} — 클라이언트가 보낸 목록 그대로(echo, DB 저장용).</li>
 *   <li>{@code summary.travelStrategy} — 엔진이 해석한 주제/분위기/태그/바이어스(JSON 객체).</li>
 *   <li>{@code summary.costBreakdown} — 항공/숙소/액티비티 등 비용 구간.</li>
 * </ul>
 * 알 수 없는 필드는 {@link JsonIgnoreProperties#ignoreUnknown()} 로 무시해 하위 호환을 유지합니다.
 *
 * <p>숙소 신호: {@code primaryAccommodationTier}는 {@link PrimaryAccommodationTier} 문자열과 동일.
 * {@code accommodationDecisionReason}은 {@link AccommodationDecisionReasonCodes} 참고.
 */
@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
@JsonIgnoreProperties(ignoreUnknown = true)
public class TravelResponseDto {
    private boolean success;
    private String message;
    private Summary summary;
    private List<ItineraryItem> itinerary;
    private List<FlightOption> flights;
    private List<HotelOption> hotels;

    private String errorCode;
    private Boolean retryable;
    private Boolean partial;
    private List<String> processingLog;

    /** 품질 점수(있을 때만). */
    private Integer qualityScore;
    /** 검증·품질 메타(있을 때만). */
    private Map<String, Object> validation;
    private Map<String, Object> qualityBreakdown;

    /**
     * 아래 필드는 FastAPI {@code TravelSuccessResponse} 와 동일 키로 역직렬화된다.
     * 저장·캘리브레이션(analysis_ready) 시 {@code effectiveQualityScore} / {@code packageMode} /
     * {@code inventoryStatus} 가 비어 있으면 안 된다.
     * {@code routeQualityTrip} / {@code fullPackageGrade} 는 있을 때만 채워진다.
     */
    private HotelOption primaryAccommodation;
    /** {@link PrimaryAccommodationTier} API 문자열 — 없으면 null. */
    private String primaryAccommodationTier;
    /** 대표 숙소 {@code sourceType} 에코. */
    private String primaryAccommodationSource;
    /** 동선용 숙소 앵커 존재 — {@code completeness.hasAccommodationAnchor}와 동일. */
    private Boolean hasAccommodationAnchor;
    /** 표시 가능한 구체 숙소 메타 존재. */
    private Boolean hasDisplayableHotel;
    /** 검증 id 판매 상품급 숙소 존재 — {@code completeness.hasVerifiedHotelProduct}와 동일. */
    private Boolean hasSellableHotel;
    /** 운영용 판정 요약 토큰 — {@link AccommodationDecisionReasonCodes}. */
    private String accommodationDecisionReason;
    /** FULL_PACKAGE | GUIDED_PACKAGE | ASSISTED_PLANNING */
    private String packageMode;
    /** COMPLETE | REFERENCE_ONLY | PARTIAL | MISSING_* 등 */
    private String inventoryStatus;
    private String completenessLevel;
    private String decisionCategory;
    private String decisionReason;
    private List<String> decisionFlags;
    private String qualityTier;
    /** HIGH | MEDIUM | LOW */
    private String routeConfidence;
    private Map<String, Object> completeness;
    /** CORE | GENERAL | EDGE */
    private String destinationTier;
    /** 일정 품질(qualityScore) 대비 상품성 감점 반영 점수 */
    private Integer effectiveQualityScore;
    private Integer sellabilityPenalty;
    /**
     * FULL_PACKAGE 일 때만 — 체감 품질 등급(PREMIUM_FULL | STANDARD_FULL | WEAK_FULL).
     */
    private String fullPackageGrade;
    /**
     * Trip 단위 경로 품질 요약(dayRoute.routeQuality 집계). 없으면 null.
     * {@code decisionFlags} 에 ROUTE_QUALITY_TRIP_MEASURED / ROUTE_LOW_DIRECTIONS_RATIO 와 대응.
     */
    private RouteQualityTripSummary routeQualityTrip;

    /** {@link PrimaryAccommodationTier#fromApiValue(String)} 로 파싱. */
    public PrimaryAccommodationTier getPrimaryAccommodationTierEnum() {
        return PrimaryAccommodationTier.fromApiValue(primaryAccommodationTier);
    }

    @Data
    @NoArgsConstructor
    @AllArgsConstructor
    @Builder
    @JsonIgnoreProperties(ignoreUnknown = true)
    public static class Summary {
        private String destination;
        private String title;
        private String startDate;
        private String endDate;
        private int days;
        private int travelers;
        /** 단일 표시 문자열 — 전체 스타일 목록이 아님. */
        private String travelStyle;
        /** 요청 {@code styles[]} echo — DB/감사용. */
        private List<String> requestStyles;
        /** 요청 {@code themes[]} echo. */
        private List<String> requestThemes;
        /** 엔진 전략 객체(primarySubject, mood, poiQueryBoosters 등). */
        private Map<String, Object> travelStrategy;
        private int totalEstimatedCost;
        private String currency;
        private String overview;
        /** flights / hotels / activities / nights / total 등. */
        private Map<String, Object> costBreakdown;
    }

    @Data
    @NoArgsConstructor
    @AllArgsConstructor
    @Builder
    @JsonIgnoreProperties(ignoreUnknown = true)
    public static class ItineraryItem {
        private int day;
        private String date;
        private String dayLabel;
        private String transportation;
        private Double totalDistanceKm;
        private Integer totalTravelTimeMinutes;
        private Integer estimatedCost;
        private String currency;
        private String summary;
        private String metricSource;
        private Boolean metricIsEstimated;
        private List<RoutePoint> routePoints;
        private List<Activity> activities;
        /** FastAPI {@code dayRoute} — 구간별 이동수단·추천 경로 메타. */
        private DayRouteInsight dayRoute;
    }

    @Data
    @NoArgsConstructor
    @AllArgsConstructor
    @Builder
    @JsonIgnoreProperties(ignoreUnknown = true)
    public static class DayRouteInsight {
        private String routePreference;
        private String routePreferenceLabelKo;
        private String metricSource;
        private List<RouteLegInsight> legs;
        /** segmentCount, directionsSegmentCount, matrixSegmentCount, directionsRatio 등 */
        private Map<String, Object> routeQuality;
    }

    @Data
    @NoArgsConstructor
    @AllArgsConstructor
    @Builder
    @JsonIgnoreProperties(ignoreUnknown = true)
    public static class RouteLegInsight {
        private int segmentIndex;
        private int distanceMeters;
        private int durationMinutes;
        private List<String> travelModes;
        private String travelModesLabelKo;
        private String stepsSummary;
        private List<String> lineNames;
    }

    @Data
    @NoArgsConstructor
    @AllArgsConstructor
    @Builder
    @JsonIgnoreProperties(ignoreUnknown = true)
    public static class Activity {
        private String id;
        private String time;
        private String endTime;
        private Integer durationMinutes;
        private String category;
        private String categoryCode;
        private String type;
        private String activityType;
        private String entityType;
        private String slotType;
        private String qualityTier;
        private String name;
        private String description;
        private String location;
        private String address;
        private Double lat;
        private Double lng;
        private Integer cost;
        private String currency;
        private Double rating;
        private String googlePlaceId;
        private String googleMapsUrl;
        private String popularityTag;
        private String enrichmentStatus;
        private Integer qualityScore;
        private Map<String, Object> transport;
    }

    @Data
    @NoArgsConstructor
    @AllArgsConstructor
    @Builder
    @JsonIgnoreProperties(ignoreUnknown = true)
    public static class RoutePoint {
        private int order;
        private String name;
        private String type;
        private double lat;
        private double lng;
        private int day;
    }

    @Data
    @NoArgsConstructor
    @AllArgsConstructor
    @Builder
    @JsonIgnoreProperties(ignoreUnknown = true)
    public static class FlightOption {
        private String id;
        private String sourceType;
        private String status;
        private String airline;
        private String flightNumber;
        private String tripType;
        private Integer price;
        private String currency;
        private Boolean pricePerPerson;
        private String departureAirport;
        private String departureAirportCode;
        private String arrivalAirport;
        private String arrivalAirportCode;
        private String departureTime;
        private String arrivalTime;
        private Integer stops;
        private String bookingUrl;
    }

    @Data
    @NoArgsConstructor
    @AllArgsConstructor
    @Builder
    @JsonIgnoreProperties(ignoreUnknown = true)
    public static class HotelOption {
        private String id;
        private String name;
        private String sourceType;
        private String status;
        private Integer pricePerNight;
        private String currency;
        private Double rating;
        private Integer reviewCount;
        private String location;
        private String address;
        private Double lat;
        private Double lng;
        private Integer hotelClass;
        private String imageUrl;
        private String bookingUrl;
        /** {@link PrimaryAccommodationTier} 와 정렬 — 대표 숙소에만 필수는 아님. */
        private String inventoryTier;
    }

    /**
     * FastAPI {@code RouteQualityTripSummary} — JSON 키 camelCase와 동일.
     */
    @Data
    @NoArgsConstructor
    @AllArgsConstructor
    @Builder
    @JsonIgnoreProperties(ignoreUnknown = true)
    public static class RouteQualityTripSummary {
        private Double minDirectionsRatio;
        private Double avgDirectionsRatio;
        private Integer lowRatioDayCount;
        private Integer daysMeasured;
        private Boolean lowDirectionsSignal;
        /** STRONG | MIXED | WEAK | CRITICAL */
        private String routeTripGrade;
    }
}
