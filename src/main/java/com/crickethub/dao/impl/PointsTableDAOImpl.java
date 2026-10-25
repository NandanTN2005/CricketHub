
package com.crickethub.dao.impl;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import com.crickethub.dao.PointsTableDAO;
import com.crickethub.dto.PointsTable;
import com.crickethub.util.ConnectionFactory;

public class PointsTableDAOImpl implements PointsTableDAO {

    @Override
    public List<PointsTable> getPointsTableByTournament(int tournamentId) {

        List<PointsTable> pointsTable = new ArrayList<>();

        String query =
                "SELECT t.id, t.team_name, "

                + "COALESCE(SUM(CASE "
                + "WHEN m.status IN ('COMPLETED', 'TIED', 'NO_RESULT') "
                + "THEN 1 ELSE 0 END), 0) AS played, "

                + "COALESCE(SUM(CASE "
                + "WHEN m.status = 'COMPLETED' "
                + "AND m.winner_team_id = t.id "
                + "THEN 1 ELSE 0 END), 0) AS won, "

                + "COALESCE(SUM(CASE "
                + "WHEN m.status = 'COMPLETED' "
                + "AND m.winner_team_id IS NOT NULL "
                + "AND m.winner_team_id <> t.id "
                + "THEN 1 ELSE 0 END), 0) AS lost, "

                + "COALESCE(SUM(CASE "
                + "WHEN m.status = 'TIED' "
                + "THEN 1 ELSE 0 END), 0) AS tied, "

                + "COALESCE(SUM(CASE "
                + "WHEN m.status = 'COMPLETED' "
                + "AND m.winner_team_id = t.id "
                + "THEN 2 "
                + "WHEN m.status = 'TIED' THEN 1 "
                + "WHEN m.status = 'NO_RESULT' THEN 1 "
                + "ELSE 0 END), 0) AS points "

                + "FROM teams t "

                + "LEFT JOIN matches m "
                + "ON (t.id = m.team1_id OR t.id = m.team2_id) "
                + "AND m.tournament_id = t.tournament_id "
                + "AND m.status IN ('COMPLETED', 'TIED', 'NO_RESULT') "

                + "WHERE t.tournament_id = ? "

                + "GROUP BY t.id, t.team_name "

                + "ORDER BY points DESC, won DESC, team_name ASC";

        try (Connection con = ConnectionFactory.getCon()) {

            if (con == null) {
                System.out.println(
                        "PointsTable: Database connection is null.");
                return pointsTable;
            }

            try (PreparedStatement ps = con.prepareStatement(query)) {

                ps.setInt(1, tournamentId);

                try (ResultSet rs = ps.executeQuery()) {

                    while (rs.next()) {

                        PointsTable pt = new PointsTable();

                        pt.setTeamId(rs.getInt("id"));
                        pt.setTeamName(rs.getString("team_name"));
                        pt.setMatchesPlayed(rs.getInt("played"));
                        pt.setMatchesWon(rs.getInt("won"));
                        pt.setMatchesLost(rs.getInt("lost"));
                        pt.setMatchesTied(rs.getInt("tied"));
                        pt.setPoints(rs.getInt("points"));

                        pointsTable.add(pt);
                    }
                }
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return pointsTable;
    }
}
