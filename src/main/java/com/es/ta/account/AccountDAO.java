package com.es.ta.account;

import com.es.ta.main.DBManager_new;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

public class AccountDAO {
    public static void login(HttpServletRequest request) {
    }

    /**
     * 로그인 처리: DB에서 loginId/password 확인 후 세션에 AccountDTO 저장
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
            String sql = "SELECT u_user_id, u_login_id, u_name, u_gender, u_birth_date, u_email FROM user_info WHERE u_login_id = ? AND u_password = ?";
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

    public boolean loginCheck(HttpServletRequest request) {
        AccountDTO user = (AccountDTO) request.getSession().getAttribute("user");
        if(user != null){
            request.setAttribute("loginPage", "view/login/login_ok.jsp");
            return true;
        }else{
            request.setAttribute("loginPage", "view/login/not_login.jsp");
            return false;
        }
    }

}
