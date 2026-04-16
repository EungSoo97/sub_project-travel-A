package com.es.ta.common;

import javax.servlet.ServletContext;
import javax.servlet.http.HttpServletRequest;
import java.io.IOException;
import java.io.InputStream;
import java.util.Properties;

public final class GoogleMapsConfig {
    private static final String PROPERTIES_PATH = "/WEB-INF/application.properties";
    private static final String API_KEY_PROPERTY = "GOOGLE_API_KEY";
    private static final String MAP_ID_PROPERTY = "GOOGLE_MAP_ID";
    private static final String API_KEY_ATTRIBUTE = "googleMapsApiKey";
    private static final String MAP_ID_ATTRIBUTE = "googleMapsMapId";

    private GoogleMapsConfig() {
    }

    public static void attach(HttpServletRequest request) {
        Properties props = loadApplicationProperties(request.getServletContext());
        request.setAttribute(API_KEY_ATTRIBUTE, props.getProperty(API_KEY_PROPERTY, ""));
        request.setAttribute(MAP_ID_ATTRIBUTE, props.getProperty(MAP_ID_PROPERTY, ""));
    }

    private static Properties loadApplicationProperties(ServletContext context) {
        Properties props = new Properties();

        try (InputStream in = context.getResourceAsStream(PROPERTIES_PATH)) {
            if (in != null) {
                props.load(in);
            }
        } catch (IOException e) {
            System.out.println("[GoogleMapsConfig] application.properties load failed: " + e.getMessage());
        }

        return props;
    }
}
