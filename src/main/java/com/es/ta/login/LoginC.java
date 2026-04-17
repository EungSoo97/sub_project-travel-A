package com.es.ta.login;

import com.es.ta.account.AccountDAO;

import javax.servlet.ServletContext;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.*;
import java.net.HttpURLConnection;
import java.net.URL;
import com.es.ta.util.ConfigLoader;

@WebServlet(name = "LoginC", value = "/login")
public class LoginC extends HttpServlet {

    public void doGet(HttpServletRequest request, HttpServletResponse response)
            throws IOException, ServletException {

        request.setAttribute("returnUrl", normalizeReturnUrl(request.getParameter("returnUrl")));
        request.setAttribute("content", "view/login/login.jsp");
        request.getRequestDispatcher("index.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        String returnUrl = normalizeReturnUrl(request.getParameter("returnUrl"));

        // ✅ 1. 로그인 실패 횟수 가져오기
        HttpSession session = request.getSession();
        Integer failCount = (Integer) session.getAttribute("loginFailCount");
        if (failCount == null) failCount = 0;

        // ✅ 2. 3회 이상 실패 시 캡챠 검증
        // ✅ 2. 캡챠 응답이 있으면 검증 (테스트용)
        // ✅ 2. 캡챠 검증 (테스트용 - 항상 검증)
        String captchaResponse = request.getParameter("g-recaptcha-response");

        if (captchaResponse == null || captchaResponse.isEmpty() || !verifyCaptcha(captchaResponse, getServletContext())) {
            request.setAttribute("loginError", "캡챠 인증이 필요합니다.");
            request.setAttribute("returnUrl", returnUrl);
            request.setAttribute("content", "view/login/login.jsp");
            request.getRequestDispatcher("index.jsp").forward(request, response);
            return;
        }

        // ✅ 3. 기존 로그인 로직
        boolean success = AccountDAO.loginProcess(request);

        if (success) {
            // 성공 시 실패 카운트 초기화
            session.removeAttribute("loginFailCount");
            response.sendRedirect(request.getContextPath() + returnUrl);
            return;
        }

        // 실패 시 카운트 증가
        session.setAttribute("loginFailCount", failCount + 1);

        request.setAttribute("loginError", "아이디 또는 비밀번호가 올바르지 않습니다.");
        request.setAttribute("returnUrl", returnUrl);
        request.setAttribute("content", "view/login/login.jsp");
        request.getRequestDispatcher("index.jsp").forward(request, response);
    }

    public void destroy() {}

    // ✅ returnUrl 보안 처리
    private String normalizeReturnUrl(String returnUrl) {
        if (returnUrl == null || returnUrl.trim().isEmpty()) {
            return "/";
        }

        String value = returnUrl.trim();
        if (!value.startsWith("/") || value.startsWith("//") || value.contains("://")) {
            return "/";
        }

        return value;
    }

    // ✅ 캡챠 검증
    private boolean verifyCaptcha(String captchaResponse, ServletContext servletContext) {
        try {
            String secretKey = null;

            // WEB-INF/application.properties에서 읽기
            try {
                java.io.InputStream input = servletContext.getResourceAsStream("/WEB-INF/application.properties");
                if (input != null) {
                    java.util.Properties prop = new java.util.Properties();
                    prop.load(input);
                    secretKey = prop.getProperty("recaptcha.secret");
                    input.close();
                }
            } catch (Exception e) {
                e.printStackTrace();
            }

            if (secretKey == null || secretKey.isEmpty()) {
                System.out.println("recaptcha.secret을 찾을 수 없습니다.");
                return false;
            }

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