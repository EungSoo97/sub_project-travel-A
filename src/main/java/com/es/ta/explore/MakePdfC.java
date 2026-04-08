package com.es.ta.explore;

import com.es.ta.resultpage.TravelResulVDTO;
import org.xhtmlrenderer.pdf.ITextRenderer;
import com.lowagie.text.pdf.BaseFont;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.OutputStream;
import java.util.StringJoiner;

@WebServlet(name = "MakePdfC", value = "/pdf")
public class MakePdfC extends HttpServlet {

    public void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {

        request.setCharacterEncoding("utf-8");

        TravelResulVDTO plan = (TravelResulVDTO) request.getSession().getAttribute("plan");

        StringBuilder html = new StringBuilder();

        html.append("""
        <html xmlns="http://www.w3.org/1999/xhtml">
        <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
        <style>
          body { font-family: 'Malgun Gothic'; }
        </style>
        </head>
        <body>
        """);

        // 제목
        html.append("<h1>")
                .append(plan.getSummary().getDestination())
                .append("</h1>");

        html.append("<p>")
                .append(plan.getSummary().getDestination())
                .append(" · ")
                .append(plan.getSummary().getDays())
                .append("일 여행</p>");

        // 일정 요약
        html.append("<h3>일정</h3>");

        for (TravelResulVDTO.Itinerary item : plan.getItinerary()) {

            html.append("<p>");
            html.append(item.getDay()).append("일차 - ");

            StringJoiner joiner = new StringJoiner(" - ");

            for (TravelResulVDTO.Activity act : item.getActivities()) {
                joiner.add(act.getName());
            }

            html.append(joiner.toString());
            html.append("</p>");
        }

        // 상세 일정
        html.append("<h3>상세 일정</h3>");

        for (TravelResulVDTO.Itinerary item : plan.getItinerary()) {

            html.append("<h4>")
                    .append(item.getDay()).append("일차 (")
                    .append(item.getDate())
                    .append(")</h4>");

            html.append("<ul>");

            for (TravelResulVDTO.Activity act : item.getActivities()) {

                html.append("<li>");

                // 이모지 제거 - ITextRenderer 오류 원인
                html.append("<p>[일정] ")
                        .append(act.getTime())
                        .append("</p>");

                html.append("<p>")
                        .append(act.getName())
                        .append("</p>");

                html.append("<p>")
                        .append(act.getDescription())
                        .append("</p>");

                html.append("<p>");

                if (act.getCost() == 0) {
                    html.append("무료");
                } else {
                    html.append(act.getCost())
                            .append(" ")
                            .append(plan.getSummary().getCurrency());
                }

                html.append("</p>");
                html.append("</li>");
            }

            html.append("</ul>");
        }

        html.append("</body></html>");

        // PDF 응답 설정
        response.reset();
        response.setContentType("application/pdf");
        response.setHeader("Content-Disposition", "attachment; filename=travel-plan.pdf");

        OutputStream os = response.getOutputStream();

        try {
            ITextRenderer renderer = new ITextRenderer();

            // OS에 따라 폰트 경로 자동 선택
            String os2 = System.getProperty("os.name").toLowerCase();
            String fontPath;

            if (os2.contains("win")) {
                fontPath = "C:/Windows/Fonts/malgun.ttf";  // Windows
            } else {
                fontPath = "/usr/share/fonts/truetype/nanum/NanumGothic.ttf";  // Linux
            }

            renderer.getFontResolver().addFont(
                    fontPath,
                    BaseFont.IDENTITY_H,
                    BaseFont.EMBEDDED
            );

            renderer.setDocumentFromString(html.toString());
            renderer.layout();
            renderer.createPDF(os);
            os.flush();

        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}