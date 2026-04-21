package com.es.ta.util;

import javax.servlet.ServletContext;
import java.io.FileInputStream;
import java.io.InputStream;
import java.util.Properties;

public class ConfigLoader {

    private static final Properties prop = new Properties();
    private static volatile boolean initialized = false;

    private ConfigLoader() {
    }

    public static synchronized void init(ServletContext context) {
        if (initialized) {
            return;
        }

        if (loadFromServletContext(context)) {
            initialized = true;
            return;
        }

        if (loadFromFileSystem("src/main/webapp/WEB-INF/application.properties")) {
            initialized = true;
            return;
        }

        if (loadFromFileSystem("build/libs/exploded/ta-1.0-SNAPSHOT.war/WEB-INF/application.properties")) {
            initialized = true;
            return;
        }

        initialized = true;
    }

    public static String get(String key) {
        return prop.getProperty(key);
    }

    private static boolean loadFromServletContext(ServletContext context) {
        if (context == null) {
            return false;
        }

        try (InputStream input = context.getResourceAsStream("/WEB-INF/application.properties")) {
            if (input == null) {
                return false;
            }
            prop.clear();
            prop.load(input);
            return true;
        } catch (Exception e) {
            return false;
        }
    }

    private static boolean loadFromFileSystem(String path) {
        try (InputStream input = new FileInputStream(path)) {
            prop.clear();
            prop.load(input);
            return true;
        } catch (Exception e) {
            return false;
        }
    }
}
