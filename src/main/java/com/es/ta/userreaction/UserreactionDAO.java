package com.es.ta.userreaction;

import com.es.ta.account.AccountDTO;
import com.es.ta.main.DBManager_new;
import com.es.ta.mypage.TravelPlanDTO;

import javax.servlet.http.HttpServletRequest;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class UserreactionDAO {

    /* =========================
       review
       ========================= */

    public static ArrayList<UserreactionDTO> getReviewsByPlanId(int planId) {
        ArrayList<UserreactionDTO> reviews = new ArrayList<>();

        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        String sql = "SELECT r.review_id, r.plan_id, r.user_id, r.content, r.created_at, u.u_name " +
                "FROM review r " +
                "JOIN user_info u ON r.user_id = u.u_user_id " +
                "WHERE r.plan_id = ? " +
                "ORDER BY r.created_at DESC";

        try {
            con = DBManager_new.connect();
            ps = con.prepareStatement(sql);
            ps.setInt(1, planId);
            rs = ps.executeQuery();

            while (rs.next()) {
                reviews.add(new UserreactionDTO(
                        rs.getInt("review_id"),
                        rs.getInt("plan_id"),
                        rs.getInt("user_id"),
                        rs.getString("content"),
                        rs.getDate("created_at"),
                        rs.getString("u_name")
                ));
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            DBManager_new.close(con, ps, rs);
        }

        return reviews;
    }

    public static void userreview(HttpServletRequest request) {
        Connection con = null;
        PreparedStatement ps = null;

        String sql = "INSERT INTO review (review_id, plan_id, user_id, content, created_at) " +
                "VALUES (review_seq.NEXTVAL, ?, ?, ?, SYSDATE)";

        try {
            con = DBManager_new.connect();
            ps = con.prepareStatement(sql);

            String planIdStr = request.getParameter("planId");
            String content = request.getParameter("content");
            System.out.println("planId parameter: " + planIdStr);
            System.out.println("content parameter: '" + content + "'");
            System.out.println("content length: " + (content != null ? content.length() : "null"));

            // 내용이 비어있으면 처리하지 않음
            if (content == null || content.trim().isEmpty()) {
                return;
            }

            AccountDTO user = (AccountDTO) request.getSession().getAttribute("user");
            System.out.println("user from session: " + user);

            if (user == null) {
                return;
            }

            int planId = Integer.parseInt(planIdStr);
            int userId = user.getUser_id();

            ps.setInt(1, planId);
            ps.setInt(2, userId);
            ps.setString(3, content);

            ps.executeUpdate();

        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            DBManager_new.close(con, ps, null);
        }
    }

    public  static int getlike(int userId) {

        Connection con = null;
        PreparedStatement ps= null;
        ResultSet rs =null;
        String sql = "SELECT COUNT(*) AS total_likes\n" +
                "FROM plan_like pl\n" +
                "    JOIN travel_plan tp ON pl.plan_id = tp.plan_id\n" +
                "WHERE tp.user_id =? ";

        try {
            con = DBManager_new.connect();
            ps = con.prepareStatement(sql);
            ps.setInt(1, userId);
            rs = ps.executeQuery();
            if (rs.next()) return rs.getInt(1);

        } catch (Exception e) {
            e.printStackTrace();
        }finally {
            DBManager_new.close(con,ps,rs);
        }
        return 0;


    }

    /* =========================
       like (plan_like)
       ========================= */

    public boolean existsLike(int planId, int userId) {
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        String sql = "SELECT COUNT(*) FROM plan_like WHERE plan_id = ? AND user_id = ?";

        try {
            con = DBManager_new.connect();
            ps = con.prepareStatement(sql);
            ps.setInt(1, planId);
            ps.setInt(2, userId);
            rs = ps.executeQuery();

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

    public void insertLike(int planId, int userId) {
        Connection con = null;
        PreparedStatement ps = null;

        String sql = "INSERT INTO plan_like (like_id, plan_id, user_id, created_at) " +
                "VALUES (plan_like_seq.NEXTVAL, ?, ?, SYSDATE)";

        try {
            con = DBManager_new.connect();
            ps = con.prepareStatement(sql);
            ps.setInt(1, planId);
            ps.setInt(2, userId);
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            DBManager_new.close(con, ps, null);
        }
    }

    public void deleteLike(int planId, int userId) {
        Connection con = null;
        PreparedStatement ps = null;

        String sql = "DELETE FROM plan_like WHERE plan_id = ? AND user_id = ?";

        try {
            con = DBManager_new.connect();
            ps = con.prepareStatement(sql);
            ps.setInt(1, planId);
            ps.setInt(2, userId);
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            DBManager_new.close(con, ps, null);
        }
    }

    public int countLikeByPlan(int planId) {
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

    /* =========================
       star (plan_star)
       ========================= */

    public static ArrayList<UserreactionDTO> getReviewsByUserId(int userId) {
        ArrayList<UserreactionDTO> reviews = new ArrayList<>();
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        // travel_plan(t) 테이블에서 destination, days, title을 가져옵니다.
        String sql = "SELECT r.review_id, r.plan_id, r.user_id, r.content, r.created_at, u.u_name, " +
                "t.destination, t.days, t.title as plan_title " +
                "FROM review r " +
                "JOIN user_info u ON r.user_id = u.u_user_id " +
                "LEFT JOIN travel_plan t ON r.plan_id = t.plan_id " + // LEFT JOIN으로 변경
                "WHERE r.user_id = ? " +
                "ORDER BY r.created_at DESC";
        try {
            con = DBManager_new.connect();
            ps = con.prepareStatement(sql);
            ps.setInt(1, userId);
            rs = ps.executeQuery();

            while (rs.next()) {
                UserreactionDTO dto = new UserreactionDTO(
                        rs.getInt("review_id"),
                        rs.getInt("plan_id"),
                        rs.getInt("user_id"),
                        rs.getString("content"),
                        rs.getDate("created_at"),
                        rs.getString("u_name")

                );
                System.out.println("리뷰 발견: " + dto.getContent());
                // 가져온 추가 정보들 세팅
                dto.setCity(rs.getString("destination"));
                dto.setDuration(rs.getInt("days"));
                dto.setPlanTitle(rs.getString("plan_title"));

                reviews.add(dto);
            }
        } catch (Exception e) { e.printStackTrace(); }
        finally { DBManager_new.close(con, ps, rs); }
        return reviews;
    }

    public boolean existsStar(int planId, int userId) {
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        String sql = "SELECT COUNT(*) FROM plan_star WHERE plan_id = ? AND user_id = ?";

        try {
            con = DBManager_new.connect();
            ps = con.prepareStatement(sql);
            ps.setInt(1, planId);
            ps.setInt(2, userId);
            rs = ps.executeQuery();

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

    public void insertStar(int planId, int userId) {
        Connection con = null;
        PreparedStatement ps = null;

        String sql = "INSERT INTO plan_star (star_id, plan_id, user_id, created_at) " +
                "VALUES (plan_star_seq.NEXTVAL, ?, ?, SYSDATE)";

        try {
            con = DBManager_new.connect();
            ps = con.prepareStatement(sql);
            ps.setInt(1, planId);
            ps.setInt(2, userId);
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            DBManager_new.close(con, ps, null);
        }
    }

    public void deleteStar(int planId, int userId) {
        Connection con = null;
        PreparedStatement ps = null;

        String sql = "DELETE FROM plan_star WHERE plan_id = ? AND user_id = ?";

        try {
            con = DBManager_new.connect();
            ps = con.prepareStatement(sql);
            ps.setInt(1, planId);
            ps.setInt(2, userId);
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            DBManager_new.close(con, ps, null);
        }
    }

    public int countStarByPlan(int planId) {
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        String sql = "SELECT COUNT(*) FROM plan_star WHERE plan_id = ?";

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

    public List<TravelPlanDTO> getStarredPlans(int userId) {
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        List<TravelPlanDTO> list = new ArrayList<>();

        String sql = "SELECT tp.plan_id, tp.user_id, tp.destination, tp.title, " +
                "tp.start_date, tp.end_date, tp.days, tp.travelers, " +
                "tp.travel_style, tp.total_estimated_cost, tp.currency, tp.overview " +
                "FROM travel_plan tp " +
                "JOIN plan_star ps ON tp.plan_id = ps.plan_id " +
                "WHERE ps.user_id = ? " +
                "ORDER BY ps.created_at DESC";

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