package com.es.ta.ai;
import lombok.Data;
import java.util.List;

@Data
public class TravelRequestDto {
    private String destination;
    private String startDate;
    private String endDate;
    private int travelers;
    private int budget;
    private List<String> styles;
    private List<String> themes;
}