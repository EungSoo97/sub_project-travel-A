package com.es.ta.live;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class WeatherDTO {
    private String cityName;
    private String description;
    private double temp;
    private double feelsLike;
    private int humidity;
    private double windSpeed;
    private String iconUrl;

}