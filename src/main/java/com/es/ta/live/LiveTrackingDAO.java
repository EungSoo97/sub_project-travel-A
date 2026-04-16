package com.es.ta.live;

import com.es.ta.main.DBManager_new;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

public class LiveTrackingDAO {

    public static boolean startTracking(int userId, int planId) {
        Connection con = null;
        PreparedStatement clearPs = null;
        PreparedStatement setPs = null;

        try {
            con = DBManager_new.connect();
            con.setAutoCommit(false);

            clearPs = con.prepareStatement(
                    "UPDATE travel_plan SET live_tracking = 0, updated_at = SYSDATE WHERE user_id = ?"
            );
            clearPs.setInt(1, userId);
            clearPs.executeUpdate();

            setPs = con.prepareStatement(
                    "UPDATE travel_plan SET live_tracking = 1, updated_at = SYSDATE WHERE plan_id = ? AND user_id = ?"
            );
            setPs.setInt(1, planId);
            setPs.setInt(2, userId);
            boolean updated = setPs.executeUpdate() == 1;

            if (updated) {
                con.commit();
            } else {
                con.rollback();
            }
            return updated;
        } catch (Exception e) {
            e.printStackTrace();
            try {
                if (con != null) {
                    con.rollback();
                }
            } catch (Exception rollbackError) {
                rollbackError.printStackTrace();
            }
            return false;
        } finally {
            closeQuietly(setPs);
            closeQuietly(clearPs);
            closeConnection(con);
        }
    }

    public static boolean stopTracking(int userId, int planId) {
        Connection con = null;
        PreparedStatement ps = null;

        try {
            con = DBManager_new.connect();
            ps = con.prepareStatement(
                    "UPDATE travel_plan SET live_tracking = 0, updated_at = SYSDATE " +
                            "WHERE plan_id = ? AND user_id = ? AND live_tracking = 1"
            );
            ps.setInt(1, planId);
            ps.setInt(2, userId);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        } finally {
            DBManager_new.close(con, ps, null);
        }
    }

    public static boolean stopAllTracking(int userId) {
        Connection con = null;
        PreparedStatement ps = null;

        try {
            con = DBManager_new.connect();
            ps = con.prepareStatement(
                    "UPDATE travel_plan SET live_tracking = 0, updated_at = SYSDATE WHERE user_id = ? AND live_tracking = 1"
            );
            ps.setInt(1, userId);
            ps.executeUpdate();
            return true;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        } finally {
            DBManager_new.close(con, ps, null);
        }
    }

    public static Integer getActivePlanId(int userId) {
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            con = DBManager_new.connect();
            ps = con.prepareStatement(
                    "SELECT plan_id FROM travel_plan WHERE user_id = ? AND live_tracking = 1 " +
                            "ORDER BY updated_at DESC FETCH FIRST 1 ROW ONLY"
            );
            ps.setInt(1, userId);
            rs = ps.executeQuery();
            return rs.next() ? rs.getInt("plan_id") : null;
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        } finally {
            DBManager_new.close(con, ps, rs);
        }
    }

    private static void closeQuietly(AutoCloseable closeable) {
        try {
            if (closeable != null) {
                closeable.close();
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    private static void closeConnection(Connection con) {
        try {
            if (con != null) {
                con.setAutoCommit(true);
                con.close();
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
