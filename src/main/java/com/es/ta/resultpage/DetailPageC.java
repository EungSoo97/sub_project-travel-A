package com.es.ta.resultpage;

import javax.servlet.ServletContext;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.InputStream;
import java.util.Properties;
import com.es.ta.userreaction.UserreactionDAO;
import com.es.ta.userreaction.UserreactionDTO;

import java.util.ArrayList;

@WebServlet(name = "DetailPageC", value = "/detail-page")
public class DetailPageC extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws IOException, ServletException {

        request.setCharacterEncoding("UTF-8");

        String idParam = request.getParameter("id");

        if (idParam == null || idParam.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/mypage");
            return;
        }

        try {
            int id = Integer.parseInt(idParam);

            TravelResultVDTO result = ResultpageDAO.detailpage(id);

            if (result == null) {
                request.setAttribute("errorMsg", "해당 여행 정보를 찾을 수 없습니다.");
            } else {
                ArrayList<UserreactionDTO> reviews = UserreactionDAO.getReviewsByPlanId(id);

                request.setAttribute("plan", result);
                request.setAttribute("reviews", reviews);

                request.getSession().setAttribute("plan", result);
                request.getSession().setAttribute("latestTravelResult", result);
            }

            attachGoogleMapsConfig(request);
            request.setAttribute("content", "view/detailpage/detailPage.jsp");
            request.getRequestDispatcher("index.jsp").forward(request, response);

            System.out.println("detail-page loaded");
            System.out.println("id = " + id);

        } catch (NumberFormatException e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/mypage");
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMsg", "상세 페이지를 불러오는 중 오류가 발생했습니다.");
            attachGoogleMapsConfig(request);
            request.setAttribute("content", "view/detailpage/detailPage.jsp");
            request.getRequestDispatcher("index.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
    }

    @Override
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
            System.out.println("[DetailPageC] application.properties load failed: " + e.getMessage());
        }

        return props;
    }
}
