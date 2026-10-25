package com.crickethub.dao.impl;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import com.crickethub.dao.MatchDAO;
import com.crickethub.dto.Match;
import com.crickethub.util.ConnectionFactory;

public class MatchDAOImpl implements MatchDAO {
	
	private Connection con;
	
	public MatchDAOImpl() {
		this.con=ConnectionFactory.getCon();
		}

	@Override
	public boolean addMatch(Match match) {
		 String query = "INSERT INTO matches "
	                + "(tournament_id, team1_id, team2_id, match_date, status) "
	                + "VALUES (?, ?, ?, ?, ?)";

	        try {
	            PreparedStatement ps = con.prepareStatement(query);

	            ps.setInt(1, match.getTournamentId());
	            ps.setInt(2, match.getTeam1Id());
	            ps.setInt(3, match.getTeam2Id());

	            ps.setTimestamp(4,
	                    java.sql.Timestamp.valueOf(match.getMatchDate()));

	            ps.setString(5, match.getStatus());

	            int rows = ps.executeUpdate();

	            return rows > 0;

	        } catch (SQLException e) {
	            e.printStackTrace();
	        }

	        return false;
	}

	@Override
	public List<Match> getAllMatches() {
		List<Match> matchList = new ArrayList<>();

		String query = "SELECT m.*, "
		        + "t1.team_name AS team1_name, "
		        + "t2.team_name AS team2_name, "
		        + "t3.team_name AS winner_team_name "
		        + "FROM matches m "
		        + "JOIN teams t1 ON m.team1_id = t1.id "
		        + "JOIN teams t2 ON m.team2_id = t2.id "
		        + "LEFT JOIN teams t3 ON m.winner_team_id = t3.id";

        try {
            PreparedStatement ps = con.prepareStatement(query);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {

                Match m = new Match();

                m.setId(rs.getInt("id"));
                m.setTournamentId(rs.getInt("tournament_id"));
                m.setTeam1Id(rs.getInt("team1_id"));
                m.setTeam2Id(rs.getInt("team2_id"));

                m.setMatchDate(
                        rs.getTimestamp("match_date").toLocalDateTime());

                m.setTeam1Runs((Integer) rs.getObject("team1_runs"));
                m.setTeam2Runs((Integer) rs.getObject("team2_runs"));
                m.setWinnerTeamId((Integer) rs.getObject("winner_team_id"));
                m.setStatus(rs.getString("status"));
                m.setTeam1Name(rs.getString("team1_name"));
                m.setTeam2Name(rs.getString("team2_name"));
                m.setWinnerTeamName(rs.getString("winner_team_name"));
                matchList.add(m);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return matchList;
	}

	@Override
	public Match getMatchById(int id) {
		Match m = null;

        String query = "SELECT * FROM matches WHERE id = ?";

        try {
            PreparedStatement ps = con.prepareStatement(query);
            ps.setInt(1, id);

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {

                m = new Match();

                m.setId(rs.getInt("id"));
                m.setTournamentId(rs.getInt("tournament_id"));
                m.setTeam1Id(rs.getInt("team1_id"));
                m.setTeam2Id(rs.getInt("team2_id"));

                m.setMatchDate(
                        rs.getTimestamp("match_date").toLocalDateTime());

                m.setTeam1Runs((Integer) rs.getObject("team1_runs"));
                m.setTeam2Runs((Integer) rs.getObject("team2_runs"));
                m.setWinnerTeamId((Integer) rs.getObject("winner_team_id"));
                m.setStatus(rs.getString("status"));
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return m;

	}

	@Override
	public boolean updateMatch(Match match) {
		String query = "UPDATE matches SET "
                + "team1_runs = ?, team2_runs = ?, "
                + "winner_team_id = ?, status = ? WHERE id = ?";

        try {
            PreparedStatement ps = con.prepareStatement(query);

            if (match.getTeam1Runs() == null) {
                ps.setNull(1, java.sql.Types.INTEGER);
            } else {
                ps.setInt(1, match.getTeam1Runs());
            }

            if (match.getTeam2Runs() == null) {
                ps.setNull(2, java.sql.Types.INTEGER);
            } else {
                ps.setInt(2, match.getTeam2Runs());
            }

            if (match.getWinnerTeamId() == null) {
                ps.setNull(3, java.sql.Types.INTEGER);
            } else {
                ps.setInt(3, match.getWinnerTeamId());
            }

            ps.setString(4, match.getStatus());
            ps.setInt(5, match.getId());

            int rows = ps.executeUpdate();

            return rows > 0;

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return false;
	}

	@Override
	public boolean deleteMatch(int id) {
		 String query = "DELETE FROM matches WHERE id = ?";

	        try {
	            PreparedStatement ps = con.prepareStatement(query);
	            ps.setInt(1, id);
	            
	            int rows = ps.executeUpdate();

	            return rows > 0;

	        } catch (SQLException e) {
	            e.printStackTrace();
	        }

	        return false;
	}
	
	public boolean isDuplicateMatch(Match match) {

	    String query = "SELECT id FROM matches "
	            + "WHERE tournament_id = ? "
	            + "AND team1_id = ? "
	            + "AND team2_id = ? "
	            + "AND match_date = ?";

	    try {
	        PreparedStatement ps = con.prepareStatement(query);

	        ps.setInt(1, match.getTournamentId());
	        ps.setInt(2, match.getTeam1Id());
	        ps.setInt(3, match.getTeam2Id());
	        ps.setTimestamp(4,
	                java.sql.Timestamp.valueOf(match.getMatchDate()));

	        ResultSet rs = ps.executeQuery();

	        return rs.next();

	    } catch (SQLException e) {
	        e.printStackTrace();
	    }

	    return false;
	}

}
