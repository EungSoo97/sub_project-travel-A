package com.es.ta.explore;

import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.ArrayList;
import java.util.LinkedHashSet;
import java.util.List;
import java.util.Set;

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
        List<String> parts = new ArrayList<>();
        Set<String> seen = new LinkedHashSet<>();

        addPart(parts, seen, dto.getDestination());
        addPart(parts, seen, cleanTitle(dto.getTitle()));

        List<String> tags = new ArrayList<>();
        addCsvTags(tags, dto.getTravelStyle());
        addListTags(tags, dto.getCustomTags());

        int count = 0;
        for (String tag : tags) {
            if (addPart(parts, seen, "#" + tag)) {
                count++;
            }
            if (count == 3) {
                break;
            }
        }

        return String.join(" · ", parts);
    }

    private String cleanTitle(String title) {
        if (title == null || title.trim().isEmpty()) {
            return "";
        }

        String cleanTitle = title.trim();
        if (cleanTitle.contains(" ")) {
            int lastSpace = cleanTitle.lastIndexOf(" ");
            cleanTitle = cleanTitle.substring(0, lastSpace).trim();
        }
        return cleanTitle;
    }

    private boolean addPart(List<String> parts, Set<String> seen, String value) {
        if (value == null) {
            return false;
        }

        String display = value.trim();
        String normalized = normalize(value);
        if (display.isEmpty() || normalized.isEmpty() || "round_trip".equals(normalized)) {
            return false;
        }
        if (seen.contains(normalized)) {
            return false;
        }

        parts.add(display);
        seen.add(normalized);
        return true;
    }

    private void addCsvTags(List<String> tags, String value) {
        if (value == null || value.trim().isEmpty()) {
            return;
        }

        for (String part : value.split(",")) {
            addTag(tags, part);
        }
    }

    private void addListTags(List<String> tags, List<String> values) {
        if (values == null) {
            return;
        }

        for (String value : values) {
            addTag(tags, value);
        }
    }

    private void addTag(List<String> tags, String value) {
        if (value == null) {
            return;
        }

        String tag = value.trim().replace("#", "");
        String normalized = normalize(tag);
        if (tag.isEmpty() || normalized.isEmpty() || "round_trip".equals(normalized)) {
            return;
        }

        for (String existing : tags) {
            if (normalize(existing).equals(normalized)) {
                return;
            }
        }

        tags.add(tag);
    }

    private String normalize(String value) {
        if (value == null) {
            return "";
        }
        return value.trim()
                .replace("#", "")
                .replace("\"", "")
                .replace("'", "")
                .toLowerCase();
    }

    private String escapeJson(String s) {
        if (s == null) return "";
        return s.replace("\\", "\\\\")
                .replace("\"", "\\\"");
    }
}
