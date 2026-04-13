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

@WebServlet(name = "SavePlanC", value = "/save-plan")
public class SavePlanC extends HttpServlet {

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

        // ── 요청 바디에서 planId 읽기 ──
        StringBuilder sb = new StringBuilder();
        try (var reader = request.getReader()) {
            String line;
            while ((line = reader.readLine()) != null) sb.append(line);
        }

        String requestBody = sb.toString();
        ObjectMapper mapper = new ObjectMapper();

        Integer planId = null;
        try {
            var jsonNode = mapper.readTree(requestBody);
            if (jsonNode.has("planId")) {
                if (jsonNode.get("planId").isInt()) {
                    planId = jsonNode.get("planId").asInt();
                } else if (jsonNode.get("planId").isTextual()) {
                    planId = Integer.parseInt(jsonNode.get("planId").asText());
                }
                System.out.println("[SavePlanC] Parsed planId: " + planId);
            } else {
                System.out.println("[SavePlanC] planId not found in request body");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().write("{\"success\":false,\"message\":\"planId 파싱 오류: " + e.getMessage() + "\"}");
            return;
        }

        if (planId == null) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().write("{\"success\":false,\"message\":\"planId가 필요합니다.\"}");
            return;
        }

        // ── 세션에서 최신 결과 가져오기 ──
        TravelResultVDTO result = (TravelResultVDTO) session.getAttribute("latestTravelResult");

        if (result == null) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().write("{\"success\":false,\"message\":\"세션이 만료되었습니다.\"}");
            return;
        }

        // ── 결과를 JSON으로 직렬화 ──
        String updatedJson;
        try {
            updatedJson = mapper.writeValueAsString(result);
        } catch (Exception e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("{\"success\":false,\"message\":\"직렬화 오류\"}");
            return;
        }

        // ── DB에 저장 ──
        System.out.println("[SavePlanC] Starting save - planId: " + planId + ", userId: " + loginUser.getUser_id());

        // 먼저 해당 플랜이 존재하는지 확인
        TravelPlanDTO existingPlan = MyPlanPageDAO.getPlanByPlanIdAndUserId(planId, loginUser.getUser_id());
        if (existingPlan == null) {
            System.out.println("[SavePlanC] Plan not found - planId: " + planId + ", userId: " + loginUser.getUser_id());
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().write("{\"success\":false,\"message\":\"플랜을 찾을 수 없습니다.\"}");
            return;
        }

        boolean saved = MyPlanPageDAO.updateResponseJson(
                planId,
                loginUser.getUser_id(),
                updatedJson
        );
        System.out.println("[SavePlanC] Save result: " + saved);

        if (saved) {
            response.setStatus(HttpServletResponse.SC_OK);
            response.getWriter().write("{\"success\":true,\"message\":\"저장 완료!\"}");
        } else {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("{\"success\":false,\"message\":\"DB 저장 실패\"}");
        }
    }
}
