package com.es.ta.resultpage;

import com.es.ta.account.AccountDTO;
import com.es.ta.mypage.MyPlanPageDAO;
import com.es.ta.mypage.TravelPlanDTO;
import com.es.ta.userreaction.UserreactionDAO;

import javax.servlet.ServletContext;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.InputStream;
import java.util.Properties;

@WebServlet(name = "DetailPageC", value = "/detail-page")
public class DetailPageC extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws IOException, ServletException {

        request.setCharacterEncoding("UTF-8");

        String idParam = request.getParameter("id");

        if (idParam == null || idParam.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/mypage");
            return;
        }

        try {
            int id = Integer.parseInt(idParam);

            TravelResultVDTO result = ResultpageDAO.detailpage(id);

            if (result == null) {
                request.setAttribute("errorMsg", "해당 여행 정보를 찾을 수 없습니다.");
            } else {
                request.setAttribute("plan", result);
                request.setAttribute("reviews", UserreactionDAO.getReviewsByPlanId(id));

                AccountDTO user = (AccountDTO) request.getSession().getAttribute("user");
                TravelPlanDTO sourcePlan = MyPlanPageDAO.getPlanByPlanId(id);
                if (sourcePlan != null) {
                    result.setLikeCnt(sourcePlan.getLikeCnt());
                    result.setUserName(sourcePlan.getCreatorName());
                }
                boolean isPostedPlan = sourcePlan != null && sourcePlan.getPosted() == 1;
                boolean isOwnPlan = user != null && sourcePlan != null && sourcePlan.getUserId() == user.getUser_id();
                boolean alreadySavedPlan = user != null && !isOwnPlan &&
                        MyPlanPageDAO.existsCopiedPlanByResponseJson(id, user.getUser_id());
                boolean canSavePlan = user != null && isPostedPlan && !isOwnPlan && !alreadySavedPlan;

                request.setAttribute("sourcePlan", sourcePlan);
                request.setAttribute("isPostedPlan", isPostedPlan);
                request.setAttribute("isOwnPlan", isOwnPlan);
                request.setAttribute("alreadySavedPlan", alreadySavedPlan);
                request.setAttribute("canSavePlan", canSavePlan);

                boolean liked = user != null && new UserreactionDAO().existsLike(id, user.getUser_id());
                request.setAttribute("liked", liked);

                request.getSession().setAttribute("plan", result);
            }
            
            attachGoogleMapsConfig(request);
            request.setAttribute("content", "view/detailpage/detailPage.jsp");
            request.getRequestDispatcher("index.jsp").forward(request, response);

            System.out.println("detail-page 들어옴");
            System.out.println("id = " + id);

        } catch (NumberFormatException e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/mypage");
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMsg", "상세 페이지를 불러오는 중 오류가 발생했습니다.");
            request.setAttribute("content", "view/detailpage/detailPage.jsp");
            request.getRequestDispatcher("index.jsp").forward(request, response);
        }

    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
    }

    @Override
    public void destroy() {
    }

    private void attachGoogleMapsConfig(HttpServletRequest request) {
        Properties props = loadApplicationProperties(request.getServletContext());
        request.setAttribute("googleMapsApiKey", props.getProperty("GOOGLE_API_KEY", ""));
        request.setAttribute("googleMapsMapId", props.getProperty("GOOGLE_MAP_ID", ""));
    }

    private Properties loadApplicationProperties(ServletContext context) {
        Properties props = new Properties();

        try (InputStream in = context.getResourceAsStream("/WEB-INF/application.properties")) {
            if (in == null) {
                return props;
            }
            props.load(in);
        } catch (IOException e) {
        }

        return props;
    }
}
