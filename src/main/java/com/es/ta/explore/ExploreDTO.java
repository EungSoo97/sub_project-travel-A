package com.es.ta.explore;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor

public class ExploreDTO {

    private int planId;
    private String destination;
    private String title;
    private String travelStyle;

}