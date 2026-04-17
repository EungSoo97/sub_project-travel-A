package com.es.ta.mypage;

import com.cloudinary.Cloudinary;
import com.cloudinary.utils.ObjectUtils;
import com.es.ta.account.AccountDTO;
import com.es.ta.image.CloudinaryUtil;
import com.es.ta.main.DBManager_new;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import javax.servlet.http.Part;
import java.io.InputStream;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.Map;

public class SettingsDAO {

    public static AccountDTO getUserInfo(HttpServletRequest request) {
        HttpSession session = request.getSession();
        AccountDTO loginUser = (AccountDTO) session.getAttribute("user");

        if (loginUser == null) return null;

        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            con = DBManager_new.connect();

            String sql = "SELECT u_user_id, u_login_id, u_password, u_name, u_gender, u_birth_date, u_email, u_profile_img " +
                    "FROM user_info WHERE u_user_id = ?";
            ps = con.prepareStatement(sql);
            ps.setInt(1, loginUser.getUser_id());
            rs = ps.executeQuery();

            if (rs.next()) {
                AccountDTO user = new AccountDTO();
                user.setUser_id(rs.getInt("u_user_id"));
                user.setLoginId(rs.getString("u_login_id"));
                user.setPassword(rs.getString("u_password"));
                user.setName(rs.getString("u_name"));
                user.setGender(rs.getString("u_gender"));
                user.setBirthDate(rs.getDate("u_birth_date"));
                user.setEmail(rs.getString("u_email"));
                user.setProfileImg(rs.getString("u_profile_img"));
                return user;
            }

        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            DBManager_new.close(con, ps, rs);
        }

        return null;
    }
    public static boolean updateUserInfo(HttpServletRequest request) {
        HttpSession session = request.getSession();
        AccountDTO loginUser = (AccountDTO) session.getAttribute("user");

        if (loginUser == null) return false;

        String password = request.getParameter("password");
        String name = request.getParameter("name");
        String gender = request.getParameter("gender");
        String email = request.getParameter("email");

        if (password == null || password.trim().isEmpty()) {
            password = loginUser.getPassword();
        }

        String profileImgPath = loginUser.getProfileImg();

        Connection con = null;
        PreparedStatement ps = null;

        try {
            Part filePart = request.getPart("profileFile");

            if (filePart != null && filePart.getSize() > 0) {
                String contentType = filePart.getContentType();
                if (contentType == null || !contentType.startsWith("image/")) {
                    return false;
                }

                Cloudinary cloudinary = CloudinaryUtil.getInstance(request.getServletContext());
                Map<?, ?> uploadResult;
                try (InputStream inputStream = filePart.getInputStream()) {
                    byte[] imageBytes = inputStream.readAllBytes();
                    uploadResult = cloudinary.uploader().upload(
                            imageBytes,
                            ObjectUtils.asMap(
                                    "folder", "profile_images",
                                    "public_id", "user_" + loginUser.getUser_id(),
                                    "overwrite", true,
                                    "invalidate", true,
                                    "resource_type", "image"
                            )
                    );
                }

                String cloudinaryUrl = (String) uploadResult.get("secure_url");
                if (cloudinaryUrl == null || cloudinaryUrl.isBlank()) {
                    cloudinaryUrl = (String) uploadResult.get("url");
                }
                if (cloudinaryUrl == null || cloudinaryUrl.isBlank()) {
                    return false;
                }

                profileImgPath = cloudinaryUrl;
            }

            con = DBManager_new.connect();

            String sql = "UPDATE user_info " +
                    "SET u_password = ?, u_name = ?, u_gender = ?, u_email = ?, u_profile_img = ? " +
                    "WHERE u_user_id = ?";

            ps = con.prepareStatement(sql);
            ps.setString(1, password);
            ps.setString(2, name);
            ps.setString(3, gender);
            ps.setString(4, email);
            ps.setString(5, profileImgPath);
            ps.setInt(6, loginUser.getUser_id());

            int result = ps.executeUpdate();

            if (result == 1) {
                loginUser.setPassword(password);
                loginUser.setName(name);
                loginUser.setGender(gender);
                loginUser.setEmail(email);
                loginUser.setProfileImg(profileImgPath);
                session.setAttribute("user", loginUser);
                return true;
            }

        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            DBManager_new.close(con, ps, null);
        }

        return false;
    }
    public static boolean deleteUser(HttpServletRequest request) {
        HttpSession session = request.getSession();
        AccountDTO loginUser = (AccountDTO) session.getAttribute("user");

        if (loginUser == null) return false;

        Connection con = null;
        PreparedStatement ps = null;

        try {
            con = DBManager_new.connect();

            String sql = "DELETE FROM user_info WHERE u_user_id = ?";
            ps = con.prepareStatement(sql);
            ps.setInt(1, loginUser.getUser_id());

            int result = ps.executeUpdate();

            if (result == 1) {
                session.invalidate();
                return true;
            }

        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            DBManager_new.close(con, ps, null);
        }

        return false;
    }
}
