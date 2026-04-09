package com.es.ta.resultpage;

import lombok.Data;
import lombok.NoArgsConstructor;
import java.util.List;

@Data
@NoArgsConstructor
public class EditPlanRequestDto {

    private int planId;
    private List<DayEdit> days;

    @Data
    @NoArgsConstructor
    public static class DayEdit {
        private int day;
        private List<ActivityEdit> activities;
    }

    @Data
    @NoArgsConstructor
    public static class ActivityEdit {
        private int order;
        private String time;
        private String name;
        private String description;
        private String type;
    }
}