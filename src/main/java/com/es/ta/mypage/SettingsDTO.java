package com.es.ta.mypage;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor

public class SettingsDTO {
    private int us_id;
    private int user_id;
    private String theme;
    private String language;
    private int alarm;
}
