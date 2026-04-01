package com.es.ta.ai;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import java.util.List;

@JsonIgnoreProperties(ignoreUnknown = true)
public class TravelResponseDto {
    private boolean success;
    private String message;
    private Summary summary;
    private List<ItineraryItem> itinerary;

    public boolean isSuccess() { return success; }
    public void setSuccess(boolean success) { this.success = success; }
    public String getMessage() { return message; }
    public void setMessage(String message) { this.message = message; }
    public Summary getSummary() { return summary; }
    public void setSummary(Summary summary) { this.summary = summary; }
    public List<ItineraryItem> getItinerary() { return itinerary; }
    public void setItinerary(List<ItineraryItem> itinerary) { this.itinerary = itinerary; }

    @JsonIgnoreProperties(ignoreUnknown = true)
    public static class Summary {
        private String destination;
        private int days;
        private String estimatedTotalCost;

        public String getDestination() { return destination; }
        public void setDestination(String destination) { this.destination = destination; }
        public int getDays() { return days; }
        public void setDays(int days) { this.days = days; }
        public String getEstimatedTotalCost() { return estimatedTotalCost; }
        public void setEstimatedTotalCost(String estimatedTotalCost) { this.estimatedTotalCost = estimatedTotalCost; }
    }

    @JsonIgnoreProperties(ignoreUnknown = true)
    public static class ItineraryItem {
        private int day;
        private String date;
        private String totalDistance;
        private String estimatedCost;
        private List<Activity> activities;

        public int getDay() { return day; }
        public void setDay(int day) { this.day = day; }
        public String getDate() { return date; }
        public void setDate(String date) { this.date = date; }
        public String getTotalDistance() { return totalDistance; }
        public void setTotalDistance(String totalDistance) { this.totalDistance = totalDistance; }
        public String getEstimatedCost() { return estimatedCost; }
        public void setEstimatedCost(String estimatedCost) { this.estimatedCost = estimatedCost; }
        public List<Activity> getActivities() { return activities; }
        public void setActivities(List<Activity> activities) { this.activities = activities; }
    }

    @JsonIgnoreProperties(ignoreUnknown = true)
    public static class Activity {
        private String time;
        private String type;
        private String name;
        private String description;
        private String location;
        private String cost;

        public String getTime() { return time; }
        public void setTime(String time) { this.time = time; }
        public String getType() { return type; }
        public void setType(String type) { this.type = type; }
        public String getName() { return name; }
        public void setName(String name) { this.name = name; }
        public String getDescription() { return description; }
        public void setDescription(String description) { this.description = description; }
        public String getLocation() { return location; }
        public void setLocation(String location) { this.location = location; }
        public String getCost() { return cost; }
        public void setCost(String cost) { this.cost = cost; }
    }
}