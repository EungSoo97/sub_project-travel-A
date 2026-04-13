package com.es.ta.explore;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet("/search-autocomplete")
public class SearchAutocompleteC extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        request.setCharacterEncoding("UTF-8");
        response.setContentType("application/json; charset=UTF-8");

        String q = request.getParameter("q");

        if (q == null || q.trim().isEmpty()) {
            response.getWriter().write("[]");
            return;
        }

        List<ExploreDTO> list = ExploreDAO.searchAutocomplete(q.trim());

        StringBuilder sb = new StringBuilder();
        sb.append("[");

        for (int i = 0; i < list.size(); i++) {
            ExploreDTO dto = list.get(i);

            String text = buildText(dto);

            sb.append("{")
                    .append("\"id\":").append(dto.getPlanId()).append(",")
                    .append("\"text\":\"").append(escapeJson(text)).append("\"")
                    .append("}");

            if (i < list.size() - 1) {
                sb.append(",");
            }
        }

        sb.append("]");

        response.getWriter().write(sb.toString());
    }

    private String buildText(ExploreDTO dto) {
        StringBuilder text = new StringBuilder();

        if (dto.getDestination() != null) {
            text.append(dto.getDestination());
        }

        if (dto.getTitle() != null && !dto.getTitle().isEmpty()) {

            String cleanTitle = dto.getTitle();

            // 🔥 마지막 단어 제거 (작성자 제거)
            if (cleanTitle.contains(" ")) {
                int lastSpace = cleanTitle.lastIndexOf(" ");
                cleanTitle = cleanTitle.substring(0, lastSpace);
            }

            if (text.length() > 0) text.append(" · ");
            text.append(cleanTitle.trim());
        }

        if (dto.getTravelStyle() != null && !dto.getTravelStyle().isEmpty()) {
            if (text.length() > 0) text.append(" · ");
            text.append(dto.getTravelStyle());
        }

        return text.toString();
    }
    private String escapeJson(String s) {
        if (s == null) return "";
        return s.replace("\\", "\\\\")
                .replace("\"", "\\\"");
    }
}