package com.es.ta.explore;

import java.io.InputStream;
import java.util.Properties;

public class ConfigLoader {

    private static final Properties props = new Properties();

    static {
        try {
            InputStream is = ConfigLoader.class
                    .getClassLoader()
                    .getResourceAsStream("application.properties");

            if (is != null) {
                props.load(is);
            } else {
                System.out.println("application.properties not found");
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public static String get(String key) {
        return props.getProperty(key);
    }
}