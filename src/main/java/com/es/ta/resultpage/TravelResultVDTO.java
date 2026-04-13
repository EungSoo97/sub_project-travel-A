package com.es.ta.resultpage;

import com.fasterxml.jackson.annotation.JsonIgnore;
import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.AllArgsConstructor;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;



@Data
@NoArgsConstructor
@AllArgsConstructor
@JsonIgnoreProperties(ignoreUnknown = true)
public class TravelResultVDTO {
    @JsonIgnore
    private int planId;

    private boolean success;
    private String message;
    private Summary summary;
    private List<Itinerary> itinerary;
    private List<Flight> flights;
    private List<Hotel> hotels;
    private int likeCnt;

    @Data
    @NoArgsConstructor
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
        private List<String> requestStyles;
        private List<String> requestThemes;
        private List<String> customTags;
        private Map<String, Object> travelStrategy;

        // ✅ customTags getter 추가
        public List<String> getCustomTags() {
            if (travelStrategy == null) return new ArrayList<>();
            Object tags = travelStrategy.get("customTags");
            if (tags instanceof List) {
                return (List<String>) tags;
            }
            return new ArrayList<>();
        }
    }



    @Data
    @NoArgsConstructor
    @JsonIgnoreProperties(ignoreUnknown = true)
    public static class Itinerary {
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
        private DayRouteInsight dayRoute;
        private List<Activity> activities;
    }

    @Data
    @NoArgsConstructor
    @JsonIgnoreProperties(ignoreUnknown = true)
    public static class Activity {
        private String id;
        private String time;
        private String endTime;
        private Integer durationMinutes;
        private String name;
        private String description;
        private String type;
        private String activityType;
        private String entityType;
        private String slotType;
        private String category;
        private String categoryCode;
        private Double lat;
        private Double lng;
        private Integer cost;
        private String currency;
        private String location;
        private String address;
        private Double rating;
        private String googlePlaceId;
        private String googleMapsUrl;
        private Map<String, Object> transport;
    }

    @Data
    @NoArgsConstructor
    @JsonIgnoreProperties(ignoreUnknown = true)
    public static class Flight {
        private String id;
        private String airline;
        private String flightNumber;
        private String tripType;
        private Integer price;
        private String currency;
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
    @JsonIgnoreProperties(ignoreUnknown = true)
    public static class Hotel {
        private String id;
        private String name;
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
    }

    @Data
    @NoArgsConstructor
    @JsonIgnoreProperties(ignoreUnknown = true)
    public static class RoutePoint {
        private Integer order;
        private String name;
        private String type;
        private Double lat;
        private Double lng;
        private Integer day;
    }

    @Data
    @NoArgsConstructor
    @JsonIgnoreProperties(ignoreUnknown = true)
    public static class DayRouteInsight {
        private String routePreference;
        private String routePreferenceLabelKo;
        private String metricSource;
        private List<RouteLegInsight> legs;
    }

    @Data
    @NoArgsConstructor
    @JsonIgnoreProperties(ignoreUnknown = true)
    public static class RouteLegInsight {
        private Integer segmentIndex;
        private Integer distanceMeters;
        private Integer durationMinutes;
        private List<String> travelModes;
        private String travelModesLabelKo;
        private String stepsSummary;
        private List<String> lineNames;

    }


}
