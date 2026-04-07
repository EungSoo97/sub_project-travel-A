package com.es.ta.live;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;

import javax.servlet.ServletContext;
import java.io.InputStream;
import java.net.HttpURLConnection;
import java.net.URLEncoder;
import java.net.URL;
import java.nio.charset.StandardCharsets;
import java.util.Properties;

public class WeatherService {

    private final String apiKey;
    private final ObjectMapper mapper = new ObjectMapper();

    public WeatherService(ServletContext context) throws Exception {
        Properties props = new Properties();

        try (InputStream in = context.getResourceAsStream("/WEB-INF/application.properties")) {
            if (in == null) {
                throw new IllegalStateException("WEB-INF/application.properties 파일을 찾을 수 없습니다.");
            }
            props.load(in);
        }

        this.apiKey = props.getProperty("OPENWEATHER_API_KEY");
        if (apiKey == null || apiKey.trim().isEmpty()) {
            throw new IllegalStateException("openweather.api.key 값이 비어 있습니다.");
        }
    }

    public WeatherDTO getTodayWeather(String cityName) throws Exception {
        String query = mapCityName(cityName);
        String encodedCity = URLEncoder.encode(query, StandardCharsets.UTF_8);

        String urlStr =
                "https://api.openweathermap.org/data/2.5/weather?q="
                        + encodedCity
                        + "&appid=" + apiKey
                        + "&units=metric"
                        + "&lang=kr";

        URL url = new URL(urlStr);
        HttpURLConnection conn = (HttpURLConnection) url.openConnection();
        conn.setRequestMethod("GET");
        conn.setConnectTimeout(5000);
        conn.setReadTimeout(5000);

        int status = conn.getResponseCode();
        if (status != 200) {
            throw new RuntimeException("OpenWeather 호출 실패. HTTP status = " + status);
        }

        JsonNode root;
        try (InputStream in = conn.getInputStream()) {
            root = mapper.readTree(in);
        } finally {
            conn.disconnect();
        }

        WeatherDTO dto = new WeatherDTO();
        dto.setCityName(root.path("name").asText());
        dto.setDescription(root.path("weather").get(0).path("description").asText());
        dto.setTemp(root.path("main").path("temp").asDouble());
        dto.setFeelsLike(root.path("main").path("feels_like").asDouble());
        dto.setHumidity(root.path("main").path("humidity").asInt());
        dto.setWindSpeed(root.path("wind").path("speed").asDouble());

        String icon = root.path("weather").get(0).path("icon").asText();
        dto.setIconUrl("https://openweathermap.org/img/wn/" + icon + "@2x.png");

        return dto;
    }

    private String mapCityName(String cityName) {
        if (cityName == null) return "Tokyo";

        String c = cityName.trim();

        switch (c) {
            case "도쿄":
            case "도쿄도":
                return "Tokyo";
            case "오사카":
            case "오사카시":
                return "Osaka";
            case "교토":
            case "교토시":
                return "Kyoto";
            case "삿포로":
            case "삿포로시":
                return "Sapporo";
            case "후쿠오카":
            case "후쿠오카시":
                return "Fukuoka";
            case "요코하마":
            case "요코하마시":
                return "Yokohama";
            case "가마쿠라":
                return "Kamakura";
            case "니가타":
            case "니가타시":
                return "Niigata";
            default:
                return c;
        }
    }
}