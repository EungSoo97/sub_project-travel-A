package com.es.ta.explore;

import com.es.ta.resultpage.ResultpageDAO;
import com.es.ta.resultpage.TravelResultVDTO;
import com.lowagie.text.pdf.BaseFont;
import org.xhtmlrenderer.pdf.ITextRenderer;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.io.OutputStream;
import java.util.Collections;
import java.util.List;
import java.util.StringJoiner;

@WebServlet(name = "MakePdfC", value = "/pdf")
public class MakePdfC extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
        request.setCharacterEncoding("UTF-8");

        TravelResultVDTO plan = resolvePlan(request);
        if (plan == null || plan.getSummary() == null) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "PDF로 변환할 일정이 없습니다.");
            return;
        }

        try {
            byte[] pdfBytes = renderPdf(buildHtml(plan));

            response.reset();
            response.setContentType("application/pdf");
            response.setHeader("Content-Disposition", "attachment; filename=travel-plan.pdf");
            response.setContentLength(pdfBytes.length);

            try (OutputStream os = response.getOutputStream()) {
                os.write(pdfBytes);
                os.flush();
            }
        } catch (Exception e) {
            throw new ServletException("PDF 생성 중 오류가 발생했습니다.", e);
        }
    }

    private TravelResultVDTO resolvePlan(HttpServletRequest request) {
        String planIdParam = request.getParameter("planId");
        if (planIdParam != null && !planIdParam.trim().isEmpty()) {
            try {
                int planId = Integer.parseInt(planIdParam.trim());
                TravelResultVDTO plan = ResultpageDAO.detailpage(planId);
                if (plan != null) {
                    request.getSession().setAttribute("plan", plan);
                    return plan;
                }
            } catch (NumberFormatException e) {
                return null;
            }
        }

        return (TravelResultVDTO) request.getSession().getAttribute("plan");
    }

    private byte[] renderPdf(String html) throws Exception {
        ITextRenderer renderer = new ITextRenderer();
        renderer.getFontResolver().addFont(resolveFontPath(), BaseFont.IDENTITY_H, BaseFont.EMBEDDED);
        renderer.setDocumentFromString(html);
        renderer.layout();

        ByteArrayOutputStream buffer = new ByteArrayOutputStream();
        renderer.createPDF(buffer);
        return buffer.toByteArray();
    }

    private String resolveFontPath() {
        String os = System.getProperty("os.name", "").toLowerCase();
        if (os.contains("win")) {
            return "C:/Windows/Fonts/malgun.ttf";
        }
        return "/usr/share/fonts/truetype/nanum/NanumGothic.ttf";
    }

    private String buildHtml(TravelResultVDTO plan) {
        String destination = valueOrDefault(plan.getSummary().getDestination(), "여행지 미정");
        String title = valueOrDefault(plan.getSummary().getTitle(), destination);
        int days = plan.getSummary().getDays();
        String currency = valueOrDefault(plan.getSummary().getCurrency(), "KRW");
        List<TravelResultVDTO.Itinerary> itinerary = safeList(plan.getItinerary());

        StringBuilder html = new StringBuilder();
        html.append("""
                <html xmlns="http://www.w3.org/1999/xhtml">
                <head>
                  <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
                  <style>
                    body { font-family: 'Malgun Gothic'; color: #111827; font-size: 12px; line-height: 1.5; padding: 28px; }
                    h1 { font-size: 24px; margin: 0 0 8px; }
                    h3 { margin: 24px 0 10px; font-size: 16px; }
                    h4 { margin: 18px 0 8px; font-size: 14px; }
                    p { margin: 0 0 8px; }
                    ul { margin: 8px 0 0 18px; padding: 0; }
                    li { margin-bottom: 10px; }
                    .summary { color: #4b5563; margin-bottom: 18px; }
                    .activity-time { font-weight: 700; }
                    .activity-name { font-weight: 700; }
                    .cost { color: #2563eb; }
                  </style>
                </head>
                <body>
                """);

        html.append("<h1>").append(escapeHtml(title)).append("</h1>");
        html.append("<p class=\"summary\">")
                .append(escapeHtml(destination))
                .append(" · ")
                .append(days)
                .append("일 여행")
                .append("</p>");

        html.append("<h3>일정 요약</h3>");
        for (TravelResultVDTO.Itinerary item : itinerary) {
            StringJoiner joiner = new StringJoiner(" - ");
            for (TravelResultVDTO.Activity act : safeList(item.getActivities())) {
                joiner.add(valueOrDefault(act.getName(), "일정"));
            }

            html.append("<p>")
                    .append(item.getDay())
                    .append("일차 - ")
                    .append(escapeHtml(joiner.toString()))
                    .append("</p>");
        }

        html.append("<h3>상세 일정</h3>");
        for (TravelResultVDTO.Itinerary item : itinerary) {
            html.append("<h4>")
                    .append(item.getDay())
                    .append("일차 (")
                    .append(escapeHtml(valueOrDefault(item.getDate(), "날짜 미정")))
                    .append(")")
                    .append("</h4>");

            html.append("<ul>");
            for (TravelResultVDTO.Activity act : safeList(item.getActivities())) {
                html.append("<li>")
                        .append("<p class=\"activity-time\">[일정] ")
                        .append(escapeHtml(valueOrDefault(act.getTime(), "시간 미정")))
                        .append("</p>")
                        .append("<p class=\"activity-name\">")
                        .append(escapeHtml(valueOrDefault(act.getName(), "이름 없음")))
                        .append("</p>")
                        .append("<p>")
                        .append(escapeHtml(valueOrDefault(act.getDescription(), "설명 없음")))
                        .append("</p>")
                        .append("<p class=\"cost\">")
                        .append(formatCost(act, currency))
                        .append("</p>")
                        .append("</li>");
            }
            html.append("</ul>");
        }

        html.append("</body></html>");
        return html.toString();
    }

    private String formatCost(TravelResultVDTO.Activity act, String defaultCurrency) {
        Integer cost = act.getCost();
        if (cost == null || cost == 0) {
            return "무료";
        }
        return cost + " " + escapeHtml(valueOrDefault(act.getCurrency(), defaultCurrency));
    }

    private String valueOrDefault(String value, String fallback) {
        return value == null || value.trim().isEmpty() ? fallback : value;
    }

    private String escapeHtml(String value) {
        return value
                .replace("&", "&amp;")
                .replace("<", "&lt;")
                .replace(">", "&gt;")
                .replace("\"", "&quot;")
                .replace("'", "&#39;");
    }

    private <T> List<T> safeList(List<T> list) {
        return list == null ? Collections.emptyList() : list;
    }
}
