
package com.crickethub.dao.impl;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Types;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

import com.crickethub.dao.PlayerDAO;
import com.crickethub.dto.Player;
import com.crickethub.util.ConnectionFactory;

public class PlayerDAOImpl implements PlayerDAO {

    private static final Logger LOGGER =
            Logger.getLogger(PlayerDAOImpl.class.getName());

    @Override
    public boolean addPlayer(Player player) {

        String query = "INSERT INTO players "
                + "(team_id, player_name, jersey_number, playing_role) "
                + "VALUES (?, ?, ?, ?)";

        try (Connection con = ConnectionFactory.getCon()) {

            if (con == null) {
                throw new SQLException("Database connection unavailable.");
            }

            try (PreparedStatement ps = con.prepareStatement(query)) {

                ps.setInt(1, player.getTeamId());
                ps.setString(2, player.getPlayerName());
                setJerseyNumber(ps, 3, player.getJerseyNumber());
                ps.setString(4, player.getPlayingRole());

                return ps.executeUpdate() == 1;
            }

        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Unable to add player.", e);
            return false;
        }
    }

    @Override
    public List<Player> getPlayersByTeam(int teamId) {

        List<Player> players = new ArrayList<>();

        String query = "SELECT id, team_id, player_name, "
                + "jersey_number, playing_role "
                + "FROM players WHERE team_id = ? ORDER BY id";

        try (Connection con = ConnectionFactory.getCon()) {

            if (con == null) {
                throw new SQLException("Database connection unavailable.");
            }

            try (PreparedStatement ps = con.prepareStatement(query)) {

                ps.setInt(1, teamId);

                try (ResultSet rs = ps.executeQuery()) {

                    while (rs.next()) {

                        Player player = new Player();

                        player.setId(rs.getInt("id"));
                        player.setTeamId(rs.getInt("team_id"));
                        player.setPlayerName(rs.getString("player_name"));

                        int jerseyNumber = rs.getInt("jersey_number");

                        if (rs.wasNull()) {
                            player.setJerseyNumber(null);
                        } else {
                            player.setJerseyNumber(jerseyNumber);
                        }

                        player.setPlayingRole(rs.getString("playing_role"));

                        players.add(player);
                    }
                }
            }

        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Unable to retrieve players.", e);
        }

        return players;
    }

    @Override
    public boolean updatePlayer(Player player) {

        String query = "UPDATE players SET player_name = ?, "
                + "jersey_number = ?, playing_role = ? "
                + "WHERE id = ? AND team_id = ?";

        try (Connection con = ConnectionFactory.getCon()) {

            if (con == null) {
                throw new SQLException("Database connection unavailable.");
            }

            try (PreparedStatement ps = con.prepareStatement(query)) {

                ps.setString(1, player.getPlayerName());
                setJerseyNumber(ps, 2, player.getJerseyNumber());
                ps.setString(3, player.getPlayingRole());
                ps.setInt(4, player.getId());
                ps.setInt(5, player.getTeamId());

                return ps.executeUpdate() == 1;
            }

        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Unable to update player.", e);
            return false;
        }
    }

    @Override
    public boolean deletePlayer(int id) {

        String query = "DELETE FROM players WHERE id = ?";

        try (Connection con = ConnectionFactory.getCon()) {

            if (con == null) {
                throw new SQLException("Database connection unavailable.");
            }

            try (PreparedStatement ps = con.prepareStatement(query)) {

                ps.setInt(1, id);
                return ps.executeUpdate() == 1;
            }

        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Unable to delete player.", e);
            return false;
        }
    }
    @Override
    public boolean deletePlayer(int id, int teamId) {

        String query = "DELETE FROM players WHERE id = ? AND team_id = ?";

        try (Connection con = ConnectionFactory.getCon()) {

            if (con == null) {
                return false;
            }

            try (PreparedStatement ps = con.prepareStatement(query)) {

                ps.setInt(1, id);
                ps.setInt(2, teamId);

                return ps.executeUpdate() == 1;
            }

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    private void setJerseyNumber(
            PreparedStatement ps, int index, Integer jerseyNumber)
            throws SQLException {

        if (jerseyNumber == null) {
            ps.setNull(index, Types.INTEGER);
        } else {
            ps.setInt(index, jerseyNumber);
        }
    }
    @Override
    public int getPlayerCountByTeam(int teamId) {

        String query = "SELECT COUNT(*) FROM players WHERE team_id = ?";

        try (Connection con = ConnectionFactory.getCon()) {

            if (con == null) {
                return -1;
            }

            try (PreparedStatement ps = con.prepareStatement(query)) {

                ps.setInt(1, teamId);

                try (ResultSet rs = ps.executeQuery()) {

                    if (rs.next()) {
                        return rs.getInt(1);
                    }
                }
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return -1;
    }
}
