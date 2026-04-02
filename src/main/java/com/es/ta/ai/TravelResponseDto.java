package com.es.ta.ai;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import lombok.*;
import java.util.List;

/**
 * AI 여행 플래너 응답 데이터 전송 객체 (DTO) - Lombok 버전
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
        private String travelStyle;
        private int totalEstimatedCost;
        private String currency;
        private String overview;
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
        private double totalDistanceKm;
        private int totalTravelTimeMinutes;
        private int estimatedCost;
        private String currency;
        private String summary;
        private List<RoutePoint> routePoints;
        private List<Activity> activities;
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
        private int durationMinutes;
        private String category;
        private String categoryCode;
        private String type;
        private String name;
        private String description;
        private String location;
        private String address;
        private double lat;
        private double lng;
        private int cost;
        private String currency;
        private Double rating;
        private String googlePlaceId;
        private String googleMapsUrl;
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
        private String airline;
        private String flightNumber;
        private String tripType;
        private int price;
        private String currency;
        private boolean pricePerPerson;
        private String departureAirport;
        private String departureAirportCode;
        private String arrivalAirport;
        private String arrivalAirportCode;
        private String departureTime;
        private String arrivalTime;
        private int stops;
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
        private int pricePerNight;
        private String currency;
        private Double rating;
        private Integer reviewCount;
        private String location;
        private String address;
        private double lat;
        private double lng;
        private Integer hotelClass;
        private String imageUrl;
        private String bookingUrl;
    }
}
