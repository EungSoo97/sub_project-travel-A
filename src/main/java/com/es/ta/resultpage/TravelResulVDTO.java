package com.es.ta.resultpage;

import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.AllArgsConstructor;
import java.util.List;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class TravelResulVDTO {
    private int planId;
    private boolean success;
    private String message;
    private Summary summary;
    private List<Itinerary> itinerary;
    private List<Flight> flights;
    private List<Hotel> hotels;

    @Data
    @NoArgsConstructor
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
    public static class Itinerary {
        private int day;
        private String date;
        private String dayLabel;
        private int estimatedCost;
        private List<Activity> activities;
    }

    @Data
    @NoArgsConstructor
    public static class Activity {
        private String id;
        private String time;
        private String name;
        private String description;
        private String type;
        private String category;
        private double lat;
        private double lng;
        private int cost;
    }

    @Data
    @NoArgsConstructor
    public static class Flight {
        private String id;
        private String airline;
        private String tripType;
        private int price;
        private String departureAirport;
        private String arrivalAirport;
    }

    @Data
    @NoArgsConstructor
    public static class Hotel {
        private String id;
        private String name;
        private int pricePerNight;
        private double rating;
        private String address;
        private double lat;
        private double lng;
    }
}