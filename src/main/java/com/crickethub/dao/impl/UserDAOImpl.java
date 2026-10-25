
package com.crickethub.dao.impl;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import com.crickethub.dao.UserDAO;
import com.crickethub.dto.User;
import com.crickethub.util.ConnectionFactory;

public class UserDAOImpl implements UserDAO {

    private Connection con;

    public UserDAOImpl() {
        this.con = ConnectionFactory.getCon();
    }

    @Override
    public User login(User user) {

        User u = null;

        String query = "SELECT id, username, role, team_id "
                     + "FROM users WHERE username=? AND password=?";

        try {
            PreparedStatement ps = con.prepareStatement(query);

            ps.setString(1, user.getUsername());
            ps.setString(2, user.getPassword());

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                u = new User();

                u.setId(rs.getInt("id"));
                u.setUsername(rs.getString("username"));
                u.setRole(rs.getString("role"));

                int teamId = rs.getInt("team_id");

                if (rs.wasNull()) {
                    u.setTeamId(null);
                } else {
                    u.setTeamId(teamId);
                }
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return u;
    }

    @Override
    public boolean register(User user) {

        String query = "INSERT INTO users "
                     + "(username, password, role, team_id, email) "
                     + "VALUES (?, ?, 'USER', NULL, ?)";

        try {
            PreparedStatement ps = con.prepareStatement(query);

            ps.setString(1, user.getUsername());
            ps.setString(2, user.getPassword());
            ps.setString(3, user.getEmail());

            int rows = ps.executeUpdate();

            return rows > 0;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
}
