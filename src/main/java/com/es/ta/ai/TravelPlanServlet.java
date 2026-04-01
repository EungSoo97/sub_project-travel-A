package com.es.ta.ai;


import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.Arrays;

@WebServlet("/planner/result")
public class TravelPlanServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        try {
            String destination = req.getParameter("destination");
            String startDate = req.getParameter("startDate");
            String endDate = req.getParameter("endDate");
            int travelers = Integer.parseInt(req.getParameter("travelers"));

            TravelRequestDto dto = new TravelRequestDto();
            dto.setDestination(destination);
            dto.setStartDate(startDate);
            dto.setEndDate(endDate);
            dto.setTravelers(travelers);
            dto.setStyles(Arrays.asList("healing", "food"));
            dto.setThemes(Arrays.asList("shopping", "cafe"));

            TravelResponseDto result = FastApiService.callFastApi(dto);

            if (result == null) {
                req.setAttribute("error", "FastAPI 응답 실패 또는 JSON 형식 오류");
                req.getRequestDispatcher("/result.jsp").forward(req, resp);
                return;
            }

            req.setAttribute("result", result);
            req.getRequestDispatcher("/result.jsp").forward(req, resp);

        } catch (Exception e) {
            e.printStackTrace();
            req.setAttribute("error", "서버 처리 중 오류 발생: " + e.getMessage());
            req.getRequestDispatcher("/result.jsp").forward(req, resp);
        }
    }
}