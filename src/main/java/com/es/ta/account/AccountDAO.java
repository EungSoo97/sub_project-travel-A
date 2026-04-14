package com.es.ta.account;

import com.es.ta.main.DBManager_new;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

public class AccountDAO {
    public static void login(HttpServletRequest request) {
    }

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
            DBManager_new.close(con, ps, rs);
        }
        return false;
    }

    public static boolean newuser(HttpServletRequest request) {
        Connection con = null;
        PreparedStatement ps = null;
        String sql = "INSERT INTO user_info (u_user_id, u_login_id, u_password, u_name, u_gender, u_birth_date, u_email) " +
                "VALUES (user_info_seq.nextval, ?, ?, ?, ?, ?, ?)";

        try {
            con = DBManager_new.connect();
            ps = con.prepareStatement(sql);
            ps.setString(1, request.getParameter("login_id"));
            ps.setString(2, request.getParameter("password"));
            ps.setString(3, request.getParameter("name"));
            ps.setString(4, request.getParameter("gender"));
            ps.setDate(5, Date.valueOf(request.getParameter("birth_date")));
            ps.setString(6, request.getParameter("email"));

            boolean created = ps.executeUpdate() == 1;
            if (created) {
                System.out.println("회원가입 성공");
            }
            return created;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        } finally {
            DBManager_new.close(con, ps, null);
        }
    }

    public static int idcheck(String loginId) {
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        String sql = "SELECT COUNT(*) FROM user_info WHERE u_login_id = ?";

        try {
            con = DBManager_new.connect();
            ps = con.prepareStatement(sql);
            ps.setString(1, loginId);
            rs = ps.executeQuery();

            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (Exception e) {
            throw new RuntimeException(e);
        } finally {
            DBManager_new.close(con, ps, rs);
        }

        return 0;
    }
}
