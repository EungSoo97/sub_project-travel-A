package com.es.ta.account;

import com.es.ta.main.DBManager_new;

import javax.servlet.http.HttpServletRequest;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

public class AccountDAO {
    public static void login(HttpServletRequest request) {
    }

    public static void newuser(HttpServletRequest request) {

        Connection con = null;
        PreparedStatement ps =null;
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

            int result =ps.executeUpdate();
            if (result == 1) {
                System.out.println("회원가입 성공");

            }

        }catch (Exception e){

        e.printStackTrace();
        }finally {
            DBManager_new.close(con,ps,rs);
        }


    }
}
