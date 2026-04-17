package com.es.ta.image;

import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.Part;
import java.io.File;
import java.io.IOException;
import java.nio.file.Paths;

@WebServlet("/aiimage-upload")
@MultipartConfig(
        fileSizeThreshold = 1024 * 1024,      // 1MB
        maxFileSize = 10 * 1024 * 1024,       // 10MB
        maxRequestSize = 20 * 1024 * 1024     // 20MB
)
public class AiimageC extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        response.setContentType("application/json; charset=UTF-8");

        Part filePart = request.getPart("imageFile");

        if (filePart == null || filePart.getSize() == 0) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().write("{\"success\":false,\"message\":\"파일이 없습니다.\"}");
            return;
        }

        String originalFileName = Paths.get(filePart.getSubmittedFileName())
                .getFileName()
                .toString();

        String lowerName = originalFileName.toLowerCase();
        if (!(lowerName.endsWith(".jpg") || lowerName.endsWith(".jpeg")
                || lowerName.endsWith(".png") || lowerName.endsWith(".gif")
                || lowerName.endsWith(".webp"))) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().write("{\"success\":false,\"message\":\"이미지 파일만 업로드 가능합니다.\"}");
            return;
        }

        // /img/aiimg 폴더에 저장
        String uploadPath = getServletContext().getRealPath("/img/aiimg");
        File uploadDir = new File(uploadPath);

        if (!uploadDir.exists()) {
            uploadDir.mkdirs();
        }

        String savedFileName = System.currentTimeMillis() + "_" + originalFileName;
        String fullPath = uploadPath + File.separator + savedFileName;

        filePart.write(fullPath);

        String imageUrl = request.getContextPath() + "/img/aiimg/" + savedFileName;

        response.getWriter().write(
                "{"
                        + "\"success\":true,"
                        + "\"fileName\":\"" + escapeJson(savedFileName) + "\","
                        + "\"imageUrl\":\"" + escapeJson(imageUrl) + "\""
                        + "}"

        );
    }

    private String escapeJson(String value) {
        if (value == null) return "";
        return value.replace("\\", "\\\\").replace("\"", "\\\"");
    }
}