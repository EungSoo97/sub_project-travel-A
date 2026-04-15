package com.es.ta.explore;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import java.util.List;

@NoArgsConstructor
@AllArgsConstructor
@Data
public class ExploreDTO {
    private int planId;
    private String destination;
    private String title;
    private String travelStyle;
    private List<String> customTags;
}