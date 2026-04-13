package com.es.ta.mypage;


import com.es.ta.account.AccountDTO;
import com.es.ta.mypage.TravelPlanDAO;
import com.es.ta.mypage.TravelPlanDTO;
import com.es.ta.userreaction.UserreactionDAO;
import com.es.ta.userreaction.UserreactionDTO;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

@WebServlet(name = "MypageC", value = "/mypage")
public class MypageC extends HttpServlet {
    private UserreactionDAO userreactionDAO = new UserreactionDAO();
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws IOException, ServletException {
        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html; charset=UTF-8");
        HttpSession session = request.getSession();
        AccountDTO loginUser = (AccountDTO) session.getAttribute("user");

        if (loginUser == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        int userId = loginUser.getUser_id();
        // 저장된 여행

        ArrayList<TravelPlanDTO> plans = TravelPlanDAO.getPlansByUserId(userId);
        System.out.println("로그인 userId = " + userId);
        System.out.println("조회된 plan 개수 = " + plans.size());
        request.setAttribute("savedTrips", plans);

        // 좋아요한 플랜
        List<TravelPlanDTO> likedPlans = userreactionDAO.getLikedPlans(userId);
        System.out.println("좋아요한 플랜 개수 = " + likedPlans.size());
        request.setAttribute("likedPlans", likedPlans);
        //  내가 쓴 후기

        ArrayList<UserreactionDTO> reviews = UserreactionDAO.getReviewsByUserId(userId);
        request.setAttribute("reviewList", reviews);

        // 내가 받은 좋아요 수
        int receivedLikes = UserreactionDAO.getlike(userId);
        request.setAttribute("receivedLikes", UserreactionDAO.getlike(userId));

        // 플랜 월별 조회
        int[] monthlyData = UserreactionDAO.getMonthlyPlanCount(userId);
        request.setAttribute("monthlyData",monthlyData);

        // 여행 트랜드 (지역 랭킹 순위 매기는 메서드)
        ArrayList<TravelPlanDTO> trendList = TravelPlanDAO.getTrendList(userId);
        request.setAttribute("trendList",trendList);
        int maxCount = trendList.isEmpty() ? 0 : trendList.get(0).getPlanId();
        request.setAttribute("maxCount", maxCount);

//        // 여행 선호 스타일
//        List<StyleStatDTO> styleStats = UserreactionDAO.getStyleStats(userId);
//        request.setAttribute("styleStats",styleStats);

        // 어디로?
        request.setAttribute("content", "view/mypage/mypage.jsp");
        request.getRequestDispatcher("index.jsp").forward(request, response);

    }


    @Override
    public void destroy() {
    }
}