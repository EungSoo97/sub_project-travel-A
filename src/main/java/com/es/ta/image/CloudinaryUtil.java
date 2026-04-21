package com.es.ta.image;

import com.cloudinary.Cloudinary;
import com.cloudinary.utils.ObjectUtils;

import javax.servlet.ServletContext;
import java.io.IOException;
import java.io.InputStream;
import java.util.Properties;

import com.es.ta.util.ConfigLoader;

public class CloudinaryUtil {

    public static Cloudinary getInstance() {
        String cloudName = ConfigLoader.get("cloudinary.cloud_name");
        String apiKey = ConfigLoader.get("cloudinary.api_key");
        String apiSecret = ConfigLoader.get("cloudinary.api_secret");

        if (isBlank(cloudName) || isBlank(apiKey) || isBlank(apiSecret)) {
            throw new IllegalStateException("Cloudinary 설정값이 비어 있습니다.");
        }

        return new Cloudinary(ObjectUtils.asMap(
                "cloud_name", cloudName,
                "api_key", apiKey,
                "api_secret", apiSecret,
                "secure", true
        ));
    }

    public static Cloudinary getInstance(ServletContext context) {
        Properties props = loadApplicationProperties(context);

        String cloudName = props.getProperty("cloudinary.cloud_name", "");
        String apiKey = props.getProperty("cloudinary.api_key", "");
        String apiSecret = props.getProperty("cloudinary.api_secret", "");

        if (cloudName.isBlank() || apiKey.isBlank() || apiSecret.isBlank()) {
            throw new IllegalStateException("Cloudinary 설정값이 비어 있습니다.");
        }

        return new Cloudinary(ObjectUtils.asMap(
                "cloud_name", cloudName,
                "api_key", apiKey,
                "api_secret", apiSecret,
                "secure", true
        ));
    }

    private static boolean isBlank(String value) {
        return value == null || value.isBlank();
    }

    private static Properties loadApplicationProperties(ServletContext context) {
        Properties props = new Properties();

        try (InputStream in = context.getResourceAsStream("/WEB-INF/application.properties")) {
            if (in == null) {
                return props;
            }
            props.load(in);
        } catch (IOException e) {
            System.out.println("[CloudinaryUtil] application.properties load failed: " + e.getMessage());
        }

        return props;
    }
}
