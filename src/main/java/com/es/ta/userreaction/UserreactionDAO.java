package com.es.ta.userreaction;

import com.es.ta.account.AccountDTO;
import com.es.ta.ai.TravelResponseDto;
import com.es.ta.main.DBManager_new;
import com.es.ta.mypage.StyleStatDTO;
import com.es.ta.mypage.TravelPlanDTO;
import com.fasterxml.jackson.databind.ObjectMapper;

import javax.servlet.http.HttpServletRequest;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Timestamp;
import java.time.LocalDateTime;
import java.time.ZoneId;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class UserreactionDAO {

    /* =========================
       review
       ========================= */

    public static ArrayList<UserreactionDTO> getReviewsByPlanId(int planId) {
        ArrayList<UserreactionDTO> reviews = new ArrayList<>();

        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        String sql = "SELECT r.review_id, r.plan_id, r.user_id, r.content, r.created_at, " +
                "NVL(u.u_name, '알 수 없음') AS u_name, u.u_profile_img " +
                "FROM review r " +
                "LEFT JOIN user_info u ON r.user_id = u.u_user_id " +
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
                        rs.getTimestamp("created_at"),
                        rs.getString("u_name"),
                        rs.getString("u_profile_img")
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
                "VALUES (review_seq.NEXTVAL, ?, ?, ?, ?)";

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
            ps.setTimestamp(4, Timestamp.valueOf(LocalDateTime.now(ZoneId.of("Asia/Seoul"))));

            ps.executeUpdate();

        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            DBManager_new.close(con, ps, null);
        }
    }

    public static boolean deleteReviewByOwner(int reviewId, int planId, int userId) {
        Connection con = null;
        PreparedStatement ps = null;

        String sql = "DELETE FROM review WHERE review_id = ? AND plan_id = ? AND user_id = ?";

        try {
            con = DBManager_new.connect();
            ps = con.prepareStatement(sql);
            ps.setInt(1, reviewId);
            ps.setInt(2, planId);
            ps.setInt(3, userId);

            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            DBManager_new.close(con, ps, null);
        }

        return false;
    }

    public  static int getlike(int userId) {

        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
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
        } finally {
            DBManager_new.close(con, ps, rs);
        }
        return 0;


    }

    public static int[] getMonthlyPlanCount(int userId) {
        int[] monthly = new int[12];
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        String sql = "SELECT TO_CHAR(start_date, 'MM') AS month, COUNT(*) AS cnt " +
                "FROM travel_plan " +
                "WHERE user_id = ? " +
                "AND TO_CHAR(start_date, 'YYYY') = TO_CHAR(SYSDATE, 'YYYY') " +
                "AND start_date IS NOT NULL " +
                "GROUP BY TO_CHAR(start_date, 'MM') " +
                "ORDER BY month";
        try {
            con = DBManager_new.connect();
            ps = con.prepareStatement(sql);
            ps.setInt(1, userId);
            rs = ps.executeQuery();

            while (rs.next()) {
                int month = Integer.parseInt(rs.getString("month"));
                monthly[month - 1] = rs.getInt("cnt");
            }
        } catch (Exception e) {
            e.printStackTrace();

        } finally {
            DBManager_new.close(con, ps, rs);
        }
        return monthly;
    }

    public static List<StyleStatDTO> getStyleStats(int userId) {
        Map<String, Integer> countMap = new HashMap<>();
        ObjectMapper mapper = new ObjectMapper();
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        String sql = "SELECT RESPONSE_JSON FROM travel_plan WHERE user_id = ?";
        try {
            con = DBManager_new.connect();
            ps = con.prepareStatement(sql);
            ps.setInt(1, userId);
            rs = ps.executeQuery();

            while (rs.next()){
                String jsonStr = rs.getString("RESPONSE_JSON");
                if (jsonStr == null ) continue;
                TravelResponseDto response = mapper.readValue(jsonStr, TravelResponseDto.class);
                TravelResponseDto.Summary summary =response.getSummary();

                if(summary != null){
                    processList(summary.getRequestStyles(),countMap);
                    processList(summary.getRequestThemes(),countMap);
                    Map<String, Object> strategy = summary.getTravelStrategy();
                    if (strategy != null && strategy.containsKey("customTags")){
                        Object tagsObj = strategy.get("customTags");
                        if (tagsObj instanceof List) {
                            processList((List<String>)tagsObj,countMap);
                        }
                    }
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            DBManager_new.close(con, ps, rs);
        }

        return convertMapToDtoList(countMap);
    }



    private static void processList(List<String> items, Map<String, Integer> map) {
        if (items != null) {
            for (String item : items) {
                map.put(item, map.getOrDefault(item, 0) + 1);
            }
        }
    }
    private static List<StyleStatDTO> convertMapToDtoList(Map<String, Integer> countMap) {
        List<StyleStatDTO> list = new ArrayList<>();
        int total = 0;
        for (int count : countMap.values()) {
            total += count;
        }
        for (Map.Entry<String, Integer> entry : countMap.entrySet()) {
            String name = entry.getKey();   // 예: "액티브"
            int cnt = entry.getValue();     // 예: 5

            // 백분율 계산 (0으로 나누기 방지)
            int pct = (total > 0) ? (cnt * 100 / total) : 0;

            // 우리가 만든 DTO에 담아서 리스트에 추가
            list.add(new StyleStatDTO(name, cnt, pct));
        }
        list.sort((a, b) -> b.getCount() - a.getCount());
        return list;
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
                "tp.travel_style, tp.total_estimated_cost, tp.currency, tp.overview, tp.posted, " +
                "NVL(tp.original_user_id, 0) AS original_user_id, NVL(tp.copied_modified, 1) AS copied_modified, " +
                "NVL(like_counts.like_cnt, 0) AS like_cnt, " +
                "NVL(creator.u_name, '') AS creator_name, NVL(editor.u_name, '') AS editor_name " +
                "FROM travel_plan tp " +
                "JOIN plan_like pl ON tp.plan_id = pl.plan_id " +
                "LEFT JOIN ( " +
                "    SELECT plan_id, COUNT(*) AS like_cnt " +
                "    FROM plan_like " +
                "    GROUP BY plan_id " +
                ") like_counts ON tp.plan_id = like_counts.plan_id " +
                "LEFT JOIN user_info creator ON NVL(tp.original_user_id, tp.user_id) = creator.u_user_id " +
                "LEFT JOIN user_info editor ON tp.user_id = editor.u_user_id " +
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
                dto.setPosted(rs.getInt("posted"));
                dto.setOriginalUserId(rs.getInt("original_user_id"));
                dto.setCopiedModified(rs.getInt("copied_modified"));
                dto.setLikeCnt(rs.getInt("like_cnt"));
                dto.setCreatorName(rs.getString("creator_name"));
                dto.setEditorName(rs.getString("editor_name"));
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
                "t.destination, t.days, t.title as plan_title, " +
                "NVL(plan_like_counts.like_cnt, 0) AS like_cnt, " +
                "NVL(creator.u_name, '여행자') AS creator_name " +
                "FROM review r " +
                "JOIN user_info u ON r.user_id = u.u_user_id " +
                "LEFT JOIN travel_plan t ON r.plan_id = t.plan_id " + // LEFT JOIN으로 변경
                "LEFT JOIN ( " +
                "    SELECT plan_id, COUNT(*) AS like_cnt " +
                "    FROM plan_like " +
                "    GROUP BY plan_id " +
                ") plan_like_counts ON r.plan_id = plan_like_counts.plan_id " +
                "LEFT JOIN user_info creator ON NVL(t.original_user_id, t.user_id) = creator.u_user_id " +
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
                        rs.getTimestamp("created_at"),
                        rs.getString("u_name")

                );
                System.out.println("리뷰 발견: " + dto.getContent());
                // 가져온 추가 정보들 세팅
                dto.setCity(rs.getString("destination"));
                dto.setDuration(rs.getInt("days"));
                dto.setPlanTitle(rs.getString("plan_title"));
                dto.setPlanCreatorName(rs.getString("creator_name"));
                dto.setLikeCnt(rs.getInt("like_cnt"));

                reviews.add(dto);
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            DBManager_new.close(con, ps, rs);
        }
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
