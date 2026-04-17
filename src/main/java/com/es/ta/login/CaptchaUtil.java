package com.es.ta.login;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.net.HttpURLConnection;
import java.net.URL;

public class CaptchaUtil {

    // 👉 static + public으로 변경
    public static boolean verifyCaptcha(String captchaResponse) {
        try {
            String secretKey = "여기에_SECRET_KEY";

            URL url = new URL("https://www.google.com/recaptcha/api/siteverify");
            HttpURLConnection conn = (HttpURLConnection) url.openConnection();

            conn.setRequestMethod("POST");
            conn.setDoOutput(true);

            String params = "secret=" + secretKey + "&response=" + captchaResponse;

            OutputStream os = conn.getOutputStream();
            os.write(params.getBytes());
            os.flush();
            os.close();

            BufferedReader in = new BufferedReader(
                    new InputStreamReader(conn.getInputStream())
            );

            String inputLine;
            StringBuilder responseStr = new StringBuilder();

            while ((inputLine = in.readLine()) != null) {
                responseStr.append(inputLine);
            }
            in.close();

            return responseStr.toString().contains("\"success\": true");

        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
}