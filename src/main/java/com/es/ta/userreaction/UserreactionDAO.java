package com.es.ta.userreaction;

import com.es.ta.account.AccountDTO;
import com.es.ta.main.DBManager_new;
import com.es.ta.mypage.TravelPlanDTO;
import com.es.ta.resultpage.ResultpageDAO;
import com.es.ta.resultpage.TravelResultVDTO;

import javax.servlet.http.HttpServletRequest;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class UserreactionDAO {


    public static void userreview(HttpServletRequest request) {

        Connection con = null;
        PreparedStatement ps = null;
       String sql = "INSERT INTO review (review_id, plan_id, user_id, content, created_at)" +
                "values (review_seq.NEXTVAL, ?, ?, ?, SYSDATE)";
        try {

            con=DBManager_new.connect();
            ps =con.prepareStatement(sql);
            // 1. 값 가져오기
System.out.println("=== Debug Parameters ===");
            String planIdStr = request.getParameter("planId");
            String content = request.getParameter("content");
            System.out.println("planId parameter: " + planIdStr);
            System.out.println("content parameter: '" + content + "'");
            System.out.println("content length: " + (content != null ? content.length() : "null"));
            
            // 내용이 비어있으면 처리하지 않음
            if (content == null || content.trim().isEmpty()) {
                System.out.println("Content is empty - skipping insert");
                return;
            }
            
            AccountDTO user = (AccountDTO) request.getSession().getAttribute("user");
            System.out.println("user from session: " + user);
            
            if (user == null) {
                System.out.println("User is null - not logged in!");
                return;
            }
            
            int planId = Integer.parseInt(planIdStr);
            int userId = user.getUser_id();
            System.out.println("parsed planId: " + planId);
            System.out.println("userId: " + userId);

            // 2. 바인딩
            ps.setInt(1, planId);
            ps.setInt(2, userId);
            ps.setString(3, content);

            // 3. 실행
            int result = ps.executeUpdate();
System.out.println("executeUpdate result: " + result);
            if (result == 1) {
                System.out.println("add review success");
            } else {
                System.out.println("add review failed - affected rows: " + result);
            }



        } catch (Exception e) {
//            System.out.println("에러 발생!");

            e.printStackTrace();
        }finally {
            DBManager_new.close(con, ps, null);
        }



    }


    public boolean exists(int planId, int userId) {

        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        String sql = "SELECT COUNT(*) FROM plan_like WHERE plan_id = ? AND user_id = ?";

        try {
            con = DBManager_new.connect();
            ps = con.prepareStatement(sql);

            // 1. 값 세팅
            ps.setInt(1, planId);
            ps.setInt(2, userId);

            // 2. 실행
            rs = ps.executeQuery();

            // 3. 결과 확인
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }

        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            DBManager_new.close(con, ps, rs);
        }

        return false;
    }



    public void insert(int planId, int userId) {

        Connection con = null;
        PreparedStatement ps = null;

        String sql = "INSERT INTO plan_like (like_id, plan_id, user_id) VALUES (plan_like_seq.NEXTVAL, ?, ?)";

        try {
            con = DBManager_new.connect();
            ps = con.prepareStatement(sql);

            // 1. 값 세팅
            ps.setInt(1, planId);
            ps.setInt(2, userId);

            // 2. 실행
            if (ps.executeUpdate()==1){
                System.out.println("insert success");
            }
            ;

        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            DBManager_new.close(con, ps, null);
        }
    }


    public void delete(int planId, int userId) {

        Connection con = null;
        PreparedStatement ps = null;

        String sql = "DELETE FROM plan_like WHERE plan_id = ? AND user_id = ?";

        try {
            con = DBManager_new.connect();
            ps = con.prepareStatement(sql);

            // 1. 값 세팅
            ps.setInt(1, planId);
            ps.setInt(2, userId);

            // 2. 실행
            if (ps.executeUpdate() == 1 ){
                System.out.println("delete success");
            }

        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            DBManager_new.close(con, ps, null);
        }
    }

    public int countByPlan(int planId) {
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        String sql = "SELECT COUNT(*) FROM plan_like WHERE plan_id = ?";

        try {
            con = DBManager_new.connect();
            ps = con.prepareStatement(sql);

            ps.setInt(1, planId);

            rs = ps.executeQuery();

            if (rs.next()) {
                return rs.getInt(1);
            }

        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            DBManager_new.close(con, ps, rs);
        }

        return 0;
    }

    public List<TravelPlanDTO> getLikedPlans(int userId) {

        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        List<TravelPlanDTO> list = new ArrayList<>();

        String sql = "SELECT tp.plan_id, tp.user_id, tp.destination, tp.title, " +
                "tp.start_date, tp.end_date, tp.days, tp.travelers, " +
                "tp.travel_style, tp.total_estimated_cost, tp.currency, tp.overview " +
                "FROM travel_plan tp " +
                "JOIN plan_like pl ON tp.plan_id = pl.plan_id " +
                "WHERE pl.user_id = ? " +
                "ORDER BY pl.created_at DESC";

        try {
            con = DBManager_new.connect();
            ps = con.prepareStatement(sql);
            ps.setInt(1, userId);

            rs = ps.executeQuery();

            while (rs.next()) {
                TravelPlanDTO dto = new TravelPlanDTO();
                dto.setPlanId(rs.getInt("plan_id"));
                dto.setUserId(rs.getInt("user_id"));
                dto.setDestination(rs.getString("destination"));
                dto.setTitle(rs.getString("title"));
                dto.setStartDate(rs.getDate("start_date"));
                dto.setEndDate(rs.getDate("end_date"));
                dto.setDays(rs.getInt("days"));
                dto.setTravelers(rs.getInt("travelers"));
                dto.setTravelStyle(rs.getString("travel_style"));
                dto.setTotalEstimatedCost(rs.getInt("total_estimated_cost"));
                dto.setCurrency(rs.getString("currency"));
                dto.setOverview(rs.getString("overview"));
                list.add(dto);
            }

        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            DBManager_new.close(con, ps, rs);
        }

        return list;
    }







}

