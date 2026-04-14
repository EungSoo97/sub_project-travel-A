package com.es.ta.explore;

import com.es.ta.resultpage.ResultpageDAO;
import com.es.ta.resultpage.TravelResultVDTO;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet(name = "ExploreC", value = "/explore")
public class ExploreC extends HttpServlet {

    public void doGet(HttpServletRequest request, HttpServletResponse response)
            throws IOException, ServletException {
//        List<TravelResultVDTO> planList = ResultpageDAO.getPlanList();
//        request.setAttribute("planList", planList);

        // 1. 정렬 기준 파라미터 받기 (기본값: popular)
        String sort = request.getParameter("sort");
        if (sort == null || sort.isEmpty()) {
            sort = "popular";
        }

        // 2. 페이징 처리
        int page = 1; // 기본 페이지
        String pageStr = request.getParameter("page");
        if (pageStr != null && !pageStr.isEmpty()) {
            try {
                page = Integer.parseInt(pageStr);
            } catch (NumberFormatException e) {
                page = 1;
            }
        }

        int pageSize = 9; // 한 페이지에 보여줄 카드 개수
        int startRow = (page - 1) * pageSize;

        // 3. DAO 호출 (정렬 방식과 시작 행, 가져올 개수를 넘김)
        List<TravelResultVDTO> planList = ResultpageDAO.getPlanListSorted(sort, startRow, pageSize);

        // 전체 페이지 수 계산을 위한 총 게시글 수 (페이징 UI용)
        int totalCount = ResultpageDAO.getTotalPlanCount();
        int totalPage = (int) Math.ceil((double) totalCount / pageSize);

        // 4. JSP로 보낼 데이터 바인딩
        request.setAttribute("planList", planList);
        request.setAttribute("sort", sort);       // 현재 정렬 상태 유지용
        request.setAttribute("page", page);       // 현재 페이지 번호
        request.setAttribute("totalPage", totalPage); // 전체 페이지 수

        // 5. 페이지 이동 (레이아웃 구조에 맞춤)
        request.setAttribute("content", "view/explore/explore.jsp");
        request.getRequestDispatcher("index.jsp").forward(request, response);
    }
}