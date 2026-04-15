package com.es.ta.live;

import com.es.ta.account.AccountDTO;
import com.es.ta.mypage.TravelPlanDAO;
import com.es.ta.mypage.TravelPlanDTO;
import com.google.gson.Gson;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;

@WebServlet(name = "LiveSearchSuggestC", value = "/live-search-suggest")
public class LiveSearchSuggestC extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        response.setContentType("application/json; charset=UTF-8");

        HttpSession session = request.getSession();
        AccountDTO loginUser = (AccountDTO) session.getAttribute("user");

        Map<String, Object> result = new HashMap<>();

        if (loginUser == null) {
            result.put("success", false);
            result.put("suggestions", new ArrayList<>());
            response.getWriter().write(new Gson().toJson(result));
            return;
        }

        String keyword = request.getParameter("keyword");

        if (keyword == null || keyword.trim().isEmpty()) {
            result.put("success", true);
            result.put("suggestions", new ArrayList<>());
            response.getWriter().write(new Gson().toJson(result));
            return;
        }

        ArrayList<TravelPlanDTO> suggestions =
                TravelPlanDAO.searchPlanSuggestionsByUserId(loginUser.getUser_id(), keyword.trim());

        result.put("success", true);
        result.put("suggestions", suggestions);

        response.getWriter().write(new Gson().toJson(result));
    }
}