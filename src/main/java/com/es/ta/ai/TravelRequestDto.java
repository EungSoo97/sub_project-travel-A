package com.es.ta.ai;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.List;

@Builder
@Data
@NoArgsConstructor
@AllArgsConstructor
public class TravelRequestDto {
    private String destination;
    private String startDate;
    private String endDate;
    private int travelers;
    private int budget;
    private List<String> styles;
    private List<String> themes;
    private int minbudget;
    private int maxbudget;
    private List<String> customTag;
}