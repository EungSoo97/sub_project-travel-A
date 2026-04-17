package com.es.ta.explore;

import com.es.ta.resultpage.ResultpageDAO;
import com.es.ta.resultpage.TravelResultVDTO;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.InputStream;
import java.util.Comparator;
import java.util.List;
import java.util.Properties;

@WebServlet(name = "ExploreC", value = "/explore")
public class ExploreC extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws IOException, ServletException {

        request.setCharacterEncoding("UTF-8");

        String q = request.getParameter("q");
        String selectedTags = request.getParameter("selectedTags");
        boolean hasQ = q != null && !q.trim().isEmpty();
        boolean hasSelectedTags = selectedTags != null && !selectedTags.trim().isEmpty();

        String sort = request.getParameter("sort");
        if (sort == null || sort.isEmpty()) {
            sort = "popular";
        }

        int page = 1;
        String pageStr = request.getParameter("page");
        if (pageStr != null && !pageStr.isEmpty()) {
            try {
                page = Integer.parseInt(pageStr);
            } catch (NumberFormatException e) {
                page = 1;
            }
        }

        int pageSize = 9;
        int startRow = (page - 1) * pageSize;

        List<TravelResultVDTO> planList;
        int totalCount;

        String googleApiKey = getGoogleApiKey();

        if (hasQ || hasSelectedTags) {
            List<TravelResultVDTO> allResults = ExploreDAO.searchPlans(q, selectedTags, googleApiKey);
            totalCount = allResults.size();

            Comparator<TravelResultVDTO> comparator = "latest".equals(sort)
                    ? Comparator.comparing(ExploreC::safePostDate).reversed()
                    .thenComparing(Comparator.comparingInt(TravelResultVDTO::getPlanId).reversed())
                    : Comparator.comparingInt(TravelResultVDTO::getLikeCnt).reversed();
            allResults.sort(comparator);

            int fromIndex = Math.min(startRow, allResults.size());
            int toIndex = Math.min(startRow + pageSize, allResults.size());
            planList = allResults.subList(fromIndex, toIndex);
        } else {
            planList = ResultpageDAO.getPlanListSorted(sort, startRow, pageSize, googleApiKey);
            totalCount = ResultpageDAO.getTotalPlanCount();
        }

        int totalPage = (int) Math.ceil((double) totalCount / pageSize);
        if (totalPage < 1) totalPage = 1;

        request.setAttribute("planList", planList);
        request.setAttribute("tagList", ExploreDAO.getPopularTags());
        request.setAttribute("sort", sort);
        request.setAttribute("page", page);
        request.setAttribute("totalPage", totalPage);
        request.setAttribute("q", q != null ? q : "");
        request.setAttribute("selectedTags", selectedTags != null ? selectedTags : "");

        request.setAttribute("content", "view/explore/explore.jsp");
        request.getRequestDispatcher("index.jsp").forward(request, response);
    }

    private static String safePostDate(TravelResultVDTO plan) {
        return plan == null || plan.getPostDate() == null ? "" : plan.getPostDate();
    }

    private String getGoogleApiKey() {
        Properties props = new Properties();

        try (InputStream in = getServletContext().getResourceAsStream("/WEB-INF/application.properties")) {
            if (in == null) {
                System.out.println("application.properties 못찾음");
                return "";
            }

            props.load(in);

            return props.getProperty("GOOGLE_API_KEY", "");
        } catch (Exception e) {
            e.printStackTrace();
        }

        return "";
    }
}