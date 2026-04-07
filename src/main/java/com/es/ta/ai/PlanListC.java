package com.es.ta.ai;

import com.fasterxml.jackson.databind.ObjectMapper;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.Collections;
import java.util.List;
import java.util.Map;

@WebServlet("/planner/plans")
public class PlanListC extends HttpServlet {

    private final TravelDao travelDao = new TravelDao();
    private final ObjectMapper objectMapper = new ObjectMapper();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        req.setCharacterEncoding("UTF-8");
        resp.setContentType("application/json; charset=UTF-8");
        // setCharacterEncoding은 contentType 설정 시 자동으로 잡히지만 명시해도 좋습니다.
        resp.setCharacterEncoding("UTF-8");

        // try-with-resources를 사용하면 자동으로 close() 되어 안전합니다.
        try (PrintWriter out = resp.getWriter()) {
            String destination = req.getParameter("destination");

            // 디버깅용 로그: 서버에 요청이 오는지 확인 필수!

            if (destination == null || destination.isBlank()) {
                resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                out.write("[]");
                return;
            }

            List<Map<String, Object>> plans = travelDao.getPlansByDestination(destination.trim());

            // 데이터 전송
            String jsonResponse = objectMapper.writeValueAsString(plans);

            out.write(jsonResponse);
            out.flush(); // 데이터를 확실히 밀어냄

        } catch (Exception e) {
            e.printStackTrace();
            resp.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            // 에러 시에도 빈 배열이라도 던져야 프론트 로딩이 멈춤
        }
    }


}