package com.es.ta.account;

import com.es.ta.main.DBManager_new;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;

public class AccountDAO {
    public static void login(HttpServletRequest request) {
    }

    /**
     * 로그인 처리: DB에서 loginId/password 확인 후 세션에 AccountDTO 저장
     *
     * @return 로그인 성공 여부
     */
    public static boolean loginProcess(HttpServletRequest request) {

        String loginId = request.getParameter("loginId");
        String password = request.getParameter("password");

        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            con = DBManager_new.connect();
            String sql = "SELECT u_user_id, u_login_id, u_name, u_gender, u_birth_date, u_email, u_profile_img " +
                    "FROM user_info WHERE u_login_id = ? AND u_password = ?";
            ps = con.prepareStatement(sql);
            ps.setString(1, loginId);
            ps.setString(2, password);
            rs = ps.executeQuery();

            if (rs.next()) {
                AccountDTO user = new AccountDTO();
                user.setUser_id(rs.getInt("u_user_id"));
                user.setLoginId(rs.getString("u_login_id"));
                user.setName(rs.getString("u_name"));
                user.setGender(rs.getString("u_gender"));
                user.setEmail(rs.getString("u_email"));
                user.setProfileImg(rs.getString("u_profile_img"));
                HttpSession session = request.getSession();
                session.setAttribute("user", user);
                return true;
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {

        }
        return false;
    }

    public static void newuser(HttpServletRequest request) {

        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        String sql = "INSERT INTO user_info ( u_user_id, u_login_id, u_password, u_name, u_gender, u_birth_date, u_email) values(user_info_seq.nextval,?,?,?,?,?,?)";


        try {
            con = DBManager_new.connect();
            ps = con.prepareStatement(sql);
            ps.setString(1, request.getParameter("login_id"));
            ps.setString(2, request.getParameter("password"));
            ps.setString(3, request.getParameter("name"));
            ps.setString(4, request.getParameter("gender"));
            ps.setString(5, request.getParameter("birth_date"));
            ps.setString(6, request.getParameter("email"));

            int result = ps.executeUpdate();
            if (result == 1) {
                System.out.println("회원가입 성공");

            }

        } catch (Exception e) {

            e.printStackTrace();
        } finally {
            DBManager_new.close(con, ps, rs);
        }


    }

    public static int idcheck(String loginId) {  // loginId를 파라미터로 받기
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        String sql = "SELECT u_login_id FROM user_info WHERE u_login_id = ?";
        int count = 0;

        try {
            con = DBManager_new.connect();
            ps = con.prepareStatement(sql);
            ps.setString(1, loginId);       // 값 세팅 후
            rs = ps.executeQuery();         // 실행

            if (rs.next()) {
                count = rs.getInt(1);       // 0 or 1
            }

        } catch (Exception e) {
            throw new RuntimeException(e);
        } finally {
            DBManager_new.close(con, ps, rs);
        }

        return count;
    }


}
