package com.es.ta.resultpage;

import com.es.ta.resultpage.TravelResponseDTO;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet(name = "DetailPageC", value = "/detail-page")
public class DetailPageC extends HttpServlet {

    public void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {

        int id = Integer.parseInt(request.getParameter("id"));

        TravelResponseDTO result = ResultpageDAO.detailpage(id);

        request.setAttribute("plan", result);
        request.getSession().setAttribute("plan", result);

        request.setAttribute("content", "view/detailpage/detailPage.jsp");
        request.getRequestDispatcher("index.jsp").forward(request, response);
        System.out.println("detail-page 들어옴");
        System.out.println("id = " + request.getParameter("id"));

    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {


    }

    public void destroy() {
    }
}

