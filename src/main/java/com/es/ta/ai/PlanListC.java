package com.es.ta.ai;

import com.fasterxml.jackson.databind.ObjectMapper;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;
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
        resp.setCharacterEncoding("UTF-8");

        try (PrintWriter out = resp.getWriter()) {
            String topRequestStyles = req.getParameter("topRequestStyles");
            String topDestinations = req.getParameter("topDestinations");
            String destination = req.getParameter("destination");
            String category = req.getParameter("category");

            if ("true".equalsIgnoreCase(topDestinations)) {
                List<Map<String, Object>> destinations = travelDao.getTopDestinations(3);
                out.write(objectMapper.writeValueAsString(destinations));
                out.flush();
                return;
            }

            if ("true".equalsIgnoreCase(topRequestStyles)) {
                List<Map<String, Object>> tags = travelDao.getTopRequestStyleTags(3);
                out.write(objectMapper.writeValueAsString(tags));
                out.flush();
                return;
            }

            if ((destination == null || destination.isBlank()) && (category == null || category.isBlank())) {
                resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                out.write("[]");
                return;
            }

            List<Map<String, Object>> plans = category != null && !category.isBlank()
                    ? travelDao.getPlansByRequestStyle(category.trim())
                    : travelDao.getPlansByDestination(destination.trim());

            out.write(objectMapper.writeValueAsString(plans));
            out.flush();
        } catch (Exception e) {
            e.printStackTrace();
            resp.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        }
    }
}
