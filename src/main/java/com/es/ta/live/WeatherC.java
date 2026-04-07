package com.es.ta.live;

import com.fasterxml.jackson.databind.ObjectMapper;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet(name = "WeatherC", value = "/weather")
public class WeatherC extends HttpServlet {

    public void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
        response.setContentType("application/json;charset=UTF-8");

        String destination = request.getParameter("destination");

        try {
            if (destination != null && !destination.isEmpty()) {
                WeatherService weatherService = new WeatherService(getServletContext());
                WeatherDTO weather = weatherService.getTodayWeather(destination);

                ObjectMapper mapper = new ObjectMapper();
                String json = mapper.writeValueAsString(weather);

                response.getWriter().write(json);
                return;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        // 에러 JSON
        response.getWriter().write("{\"error\":\"날씨 정보를 불러오지 못했습니다.\"}");
    }


    public void destroy() {
    }
}