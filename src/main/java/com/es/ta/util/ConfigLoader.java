package com.es.ta.util;

import java.io.InputStream;
import java.util.Properties;

public class ConfigLoader {

    private static Properties prop = new Properties();

    static {
        try {
            // 👉 application.properties 읽기
            InputStream input = ConfigLoader.class
                    .getClassLoader()
                    .getResourceAsStream("application.properties");

            if (input == null) {
                throw new RuntimeException("application.properties 파일을 찾을 수 없습니다.");
            }

            prop.load(input);

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public static String get(String key) {
        return prop.getProperty(key);
    }
}