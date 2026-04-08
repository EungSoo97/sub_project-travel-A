package com.es.ta.resultpage;

import javax.servlet.ServletException;
import javax.servlet.ServletContext;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.InputStream;
import java.util.Properties;

@WebServlet(name = "ResultpageC", value = "/result-page")
public class ResultpageC extends HttpServlet {

    public void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {

        attachGoogleMapsConfig(request);
        request.setAttribute("content", "view/resultpage/resultpage.jsp");
        request.getRequestDispatcher("index.jsp").forward(request, response);

    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

//        int id = Integer.parseInt(request.getParameter("id"));
//
//        TravelRequestDto result = ResultpageDAO.detailpage(id);
//
//        request.setAttribute("result", result);
//        request.setAttribute("content", "view/detailpage/detailpage.jsp");
//        request.getRequestDispatcher("index.jsp").forward(request, response);
// detail page C로 get요청 할꺼임


    }

    public void destroy() {
    }

    private void attachGoogleMapsConfig(HttpServletRequest request) {
        Properties props = loadApplicationProperties(request.getServletContext());
        request.setAttribute("googleMapsApiKey", props.getProperty("GOOGLE_API_KEY", ""));
        request.setAttribute("googleMapsMapId", props.getProperty("GOOGLE_MAP_ID", ""));
    }

    private Properties loadApplicationProperties(ServletContext context) {
        Properties props = new Properties();

        try (InputStream in = context.getResourceAsStream("/WEB-INF/application.properties")) {
            if (in == null) {
                return props;
            }
            props.load(in);
        } catch (IOException e) {
            System.out.println("[ResultpageC] application.properties load failed: " + e.getMessage());
        }

        return props;
    }
}
