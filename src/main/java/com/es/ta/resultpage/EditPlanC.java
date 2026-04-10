package com.es.ta.resultpage;

import com.es.ta.account.AccountDTO;
import com.es.ta.mypage.MyPlanPageDAO;
import com.es.ta.mypage.TravelPlanDTO;
import com.fasterxml.jackson.databind.ObjectMapper;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

@WebServlet(name = "EditPlanC", value = "/edit-plan")
public class EditPlanC extends HttpServlet {

    @Override
    public void doGet(HttpServletRequest request, HttpServletResponse response)
            throws IOException, ServletException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        AccountDTO loginUser = (AccountDTO) session.getAttribute("user");

        TravelResultVDTO result = (TravelResultVDTO) session.getAttribute("latestTravelResult");
        if (result == null) {
            response.sendRedirect(request.getContextPath() + "/mypage");
            return;
        }

        // ── planId 넘기기 위해 savedPlan도 함께 세팅 ──
        String idParam = request.getParameter("id");
        if (idParam != null) {
            try {
                int planId = Integer.parseInt(idParam);
                TravelPlanDTO savedPlan = MyPlanPageDAO.getPlanByPlanIdAndUserId(planId, loginUser.getUser_id());
                request.setAttribute("savedPlan", savedPlan);
            } catch (Exception e) {
                e.printStackTrace();
            }
        }

        request.setAttribute("result", result);
        request.setAttribute("content", "view/resultpage/scheduleEdit.jsp");
        request.getRequestDispatcher("index.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        response.setContentType("application/json; charset=UTF-8");

        HttpSession session = request.getSession(false);

        // ── 로그인 체크 ──
        if (session == null || session.getAttribute("user") == null) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            response.getWriter().write("{\"success\":false,\"message\":\"로그인이 필요합니다.\"}");
            return;
        }

        AccountDTO loginUser = (AccountDTO) session.getAttribute("user");

        // ── 요청 바디 읽기 ──
        StringBuilder sb = new StringBuilder();
        try (var reader = request.getReader()) {
            String line;
            while ((line = reader.readLine()) != null) sb.append(line);
        }

        String requestBody = sb.toString();

        // ── Jackson으로 파싱 ──
        ObjectMapper mapper = new ObjectMapper();
        EditPlanRequestDto editRequest;
        try {
            editRequest = mapper.readValue(requestBody, EditPlanRequestDto.class);
        } catch (Exception e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().write("{\"success\":false,\"message\":\"잘못된 요청입니다.\"}");
            return;
        }

        // ── 세션에서 기존 result 꺼내기 ──
        TravelResultVDTO result = (TravelResultVDTO) session.getAttribute("latestTravelResult");

        if (result == null) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().write("{\"success\":false,\"message\":\"세션이 만료되었습니다.\"}");
            return;
        }

        // ── 편집된 activities 순서/내용 반영 ──
        for (EditPlanRequestDto.DayEdit dayEdit : editRequest.getDays()) {
            result.getItinerary().stream()
                    .filter(it -> it.getDay() == dayEdit.getDay())
                    .findFirst()
                    .ifPresent(itinerary -> {
                        List<TravelResultVDTO.Activity> updated = dayEdit.getActivities().stream()
                                .map(a -> {
                                    // 기존 activity에서 일치하는 항목 찾아 시간/순서만 덮어쓰기
                                    TravelResultVDTO.Activity origin = itinerary.getActivities().stream()
                                            .filter(o -> o.getName().equals(a.getName()))
                                            .findFirst()
                                            .orElse(new TravelResultVDTO.Activity());
                                    origin.setTime(a.getTime());
                                    origin.setName(a.getName());
                                    origin.setDescription(a.getDescription());
                                    origin.setType(a.getType());
                                    origin.setDurationMinutes(a.getDurationMinutes());
                                    origin.setCost(a.getCost());
                                    origin.setCurrency(a.getCurrency());
                                    // durationMinutes: 0이면 기존 값 유지, 0이 아니면 새 값으로 업데이트
                                    if (a.getDurationMinutes() > 0) {
                                        origin.setDurationMinutes(a.getDurationMinutes());
                                    }
                                    // cost: 0이면 기존 값 유지, 0이 아니면 새 값으로 업데이트
                                    if (a.getCost() >= 0) {
                                        origin.setCost(a.getCost());
                                    }
                                    if (a.getCurrency() != null && !a.getCurrency().isEmpty()) {
                                        origin.setCurrency(a.getCurrency());
                                    }
                                    if (a.getLocation() != null && !a.getLocation().isEmpty()) {
                                        origin.setLocation(a.getLocation());
                                    }
                                    return origin;
                                })
                                .collect(java.util.stream.Collectors.toList());
                        itinerary.setActivities(updated);
                    });
        }

        // ── 수정된 result → JSON 직렬화 ──
        String updatedJson;
        try {
            updatedJson = mapper.writeValueAsString(result);

        } catch (Exception e) {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("{\"success\":false,\"message\":\"직렬화 오류\"}");
            return;
        }

        // ── DB 저장 ──
        boolean saved = MyPlanPageDAO.updateResponseJson(
                editRequest.getPlanId(),
                loginUser.getUser_id(),
                updatedJson
        );


        if (saved) {
            // ── 세션 최신 상태로 갱신 (myplan-page에서 세션 꺼내 쓸 경우 대비) ──
            session.setAttribute("latestTravelResult", result);
            response.setStatus(HttpServletResponse.SC_OK);
            response.getWriter().write("{\"success\":true}");
        } else {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("{\"success\":false,\"message\":\"DB 저장 실패\"}");
        }
    }
}