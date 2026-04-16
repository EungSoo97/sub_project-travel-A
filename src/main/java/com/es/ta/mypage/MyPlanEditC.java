package com.es.ta.mypage;

import com.es.ta.account.AccountDTO;
import com.es.ta.common.GoogleMapsConfig;
import com.es.ta.resultpage.TravelJsonParser;
import com.es.ta.resultpage.TravelResultVDTO;
import com.fasterxml.jackson.databind.DeserializationFeature;
import com.fasterxml.jackson.databind.ObjectMapper;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.Date;
import java.time.LocalDate;
import java.time.temporal.ChronoUnit;

@WebServlet(name = "MyPlanEditC", value = "/myplan-edit")
public class MyPlanEditC extends HttpServlet {

    private final ObjectMapper objectMapper = new ObjectMapper()
            .configure(DeserializationFeature.FAIL_ON_UNKNOWN_PROPERTIES, false);

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        AccountDTO loginUser = getLoginUser(request);
        if (loginUser == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        Integer planId = parsePlanId(request.getParameter("id"));
        if (planId == null) {
            response.sendRedirect(request.getContextPath() + "/mypage");
            return;
        }

        TravelPlanDTO savedPlan = MyPlanPageDAO.getPlanByPlanIdAndUserId(planId, loginUser.getUser_id());
        if (savedPlan == null) {
            response.sendRedirect(request.getContextPath() + "/mypage");
            return;
        }

        TravelResultVDTO result = TravelJsonParser.parse(savedPlan.getResponseJson());
        if (result == null) {
            result = new TravelResultVDTO();
            result.setSummary(new TravelResultVDTO.Summary());
        }

        attachEditAttributes(request, savedPlan, result, savedPlan.getResponseJson(), null);
        request.setAttribute("content", "view/mypage/myplanedit.jsp");
        request.getRequestDispatcher("index.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        AccountDTO loginUser = getLoginUser(request);
        if (loginUser == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        Integer planId = parsePlanId(request.getParameter("id"));
        if (planId == null) {
            response.sendRedirect(request.getContextPath() + "/mypage");
            return;
        }

        TravelPlanDTO savedPlan = MyPlanPageDAO.getPlanByPlanIdAndUserId(planId, loginUser.getUser_id());
        if (savedPlan == null) {
            response.sendRedirect(request.getContextPath() + "/mypage");
            return;
        }

        String title = safeTrim(request.getParameter("title"));
        String destination = safeTrim(request.getParameter("destination"));
        String travelStyle = safeTrim(request.getParameter("travelStyle"));
        String overview = safeTrim(request.getParameter("overview"));
        String startDateValue = safeTrim(request.getParameter("startDate"));
        String endDateValue = safeTrim(request.getParameter("endDate"));
        String travelersValue = safeTrim(request.getParameter("travelers"));
        String responseJsonText = request.getParameter("responseJson");

        if (title.isEmpty() || destination.isEmpty() || startDateValue.isEmpty() || endDateValue.isEmpty() || travelersValue.isEmpty()) {
            TravelResultVDTO result = buildEditableResult(savedPlan, responseJsonText, title, destination, travelStyle, overview, startDateValue, endDateValue, travelersValue);
            attachEditAttributes(request, savedPlan, result, responseJsonText, "제목, 목적지, 일정 기간, 인원은 필수입니다.");
            request.setAttribute("content", "view/mypage/myplanedit.jsp");
            request.getRequestDispatcher("index.jsp").forward(request, response);
            return;
        }

        LocalDate startDate;
        LocalDate endDate;
        int travelers;
        try {
            startDate = LocalDate.parse(startDateValue);
            endDate = LocalDate.parse(endDateValue);
            travelers = Integer.parseInt(travelersValue);
        } catch (Exception e) {
            TravelResultVDTO result = buildEditableResult(savedPlan, responseJsonText, title, destination, travelStyle, overview, startDateValue, endDateValue, travelersValue);
            attachEditAttributes(request, savedPlan, result, responseJsonText, "입력 형식을 다시 확인해 주세요.");
            request.setAttribute("content", "view/mypage/myplanedit.jsp");
            request.getRequestDispatcher("index.jsp").forward(request, response);
            return;
        }

        if (endDate.isBefore(startDate) || travelers < 1) {
            TravelResultVDTO result = buildEditableResult(savedPlan, responseJsonText, title, destination, travelStyle, overview, startDateValue, endDateValue, travelersValue);
            attachEditAttributes(request, savedPlan, result, responseJsonText, "도착일은 출발일 이후여야 하고 여행 인원은 1명 이상이어야 합니다.");
            request.setAttribute("content", "view/mypage/myplanedit.jsp");
            request.getRequestDispatcher("index.jsp").forward(request, response);
            return;
        }

        TravelResultVDTO result;
        try {
            String jsonSource = (responseJsonText == null || responseJsonText.trim().isEmpty()) ? savedPlan.getResponseJson() : responseJsonText.trim();
            result = objectMapper.readValue(jsonSource, TravelResultVDTO.class);
        } catch (Exception e) {
            TravelResultVDTO fallbackResult = buildEditableResult(savedPlan, responseJsonText, title, destination, travelStyle, overview, startDateValue, endDateValue, travelersValue);
            attachEditAttributes(request, savedPlan, fallbackResult, responseJsonText, "JSON 형식이 올바르지 않습니다.");
            request.setAttribute("content", "view/mypage/myplanedit.jsp");
            request.getRequestDispatcher("index.jsp").forward(request, response);
            return;
        }

        if (result.getSummary() == null) {
            result.setSummary(new TravelResultVDTO.Summary());
        }

        int days = (int) ChronoUnit.DAYS.between(startDate, endDate) + 1;
        result.getSummary().setTitle(title);
        result.getSummary().setDestination(destination);
        result.getSummary().setTravelStyle(travelStyle);
        result.getSummary().setOverview(overview);
        result.getSummary().setStartDate(startDate.toString());
        result.getSummary().setEndDate(endDate.toString());
        result.getSummary().setTravelers(travelers);
        result.getSummary().setDays(days);

        String updatedJson = objectMapper.writeValueAsString(result);

        TravelPlanDTO updateTarget = new TravelPlanDTO();
        updateTarget.setPlanId(savedPlan.getPlanId());
        updateTarget.setUserId(savedPlan.getUserId());
        updateTarget.setTitle(title);
        updateTarget.setDestination(destination);
        updateTarget.setStartDate(Date.valueOf(startDate));
        updateTarget.setEndDate(Date.valueOf(endDate));
        updateTarget.setDays(days);
        updateTarget.setTravelers(travelers);
        updateTarget.setTravelStyle(travelStyle);
        updateTarget.setTotalEstimatedCost(result.getSummary().getTotalEstimatedCost());
        updateTarget.setCurrency(result.getSummary().getCurrency());
        updateTarget.setOverview(overview);
        updateTarget.setResponseJson(updatedJson);

        boolean updated = MyPlanPageDAO.updatePlanByPlanIdAndUserId(updateTarget);
        if (!updated) {
            attachEditAttributes(request, savedPlan, result, updatedJson, "수정 저장에 실패했습니다. 다시 시도해 주세요.");
            request.setAttribute("content", "view/mypage/myplanedit.jsp");
            request.getRequestDispatcher("index.jsp").forward(request, response);
            return;
        }

        response.sendRedirect(request.getContextPath() + "/myplan-page?id=" + planId);
    }

    private AccountDTO getLoginUser(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session == null) {
            return null;
        }
        return (AccountDTO) session.getAttribute("user");
    }

    private Integer parsePlanId(String planIdValue) {
        try {
            return Integer.parseInt(planIdValue);
        } catch (Exception e) {
            return null;
        }
    }

    private void attachEditAttributes(HttpServletRequest request, TravelPlanDTO savedPlan, TravelResultVDTO result, String responseJsonText, String errorMessage) {
        GoogleMapsConfig.attach(request);
        request.setAttribute("savedPlan", savedPlan);
        request.setAttribute("result", result);
        request.setAttribute("responseJsonText", responseJsonText == null ? savedPlan.getResponseJson() : responseJsonText);
        if (errorMessage != null) {
            request.setAttribute("editError", errorMessage);
        }
    }

    private TravelResultVDTO buildEditableResult(TravelPlanDTO savedPlan, String responseJsonText, String title, String destination, String travelStyle, String overview, String startDate, String endDate, String travelersValue) {
        TravelResultVDTO result = TravelJsonParser.parse(savedPlan.getResponseJson());
        if (result == null) {
            result = new TravelResultVDTO();
        }
        if (result.getSummary() == null) {
            result.setSummary(new TravelResultVDTO.Summary());
        }

        result.getSummary().setTitle(title);
        result.getSummary().setDestination(destination);
        result.getSummary().setTravelStyle(travelStyle);
        result.getSummary().setOverview(overview);
        result.getSummary().setStartDate(startDate);
        result.getSummary().setEndDate(endDate);
        try {
            result.getSummary().setTravelers(Integer.parseInt(travelersValue));
        } catch (Exception ignored) {
        }

        return result;
    }

    private String safeTrim(String value) {
        return value == null ? "" : value.trim();
    }
}
