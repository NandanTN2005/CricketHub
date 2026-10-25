package com.crickethub.dao.impl;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import com.crickethub.dao.TeamDAO;
import com.crickethub.dto.Team;
import com.crickethub.util.ConnectionFactory;

public class TeamDAOImpl implements TeamDAO{
	private Connection con;

    public TeamDAOImpl() {
        this.con = ConnectionFactory.getCon();
    }

	@Override
	public boolean addTeam(Team team) {

        String query = "INSERT INTO teams (tournament_id, team_name, captain) VALUES (?, ?, ?)";

        try {
            PreparedStatement ps = con.prepareStatement(query);

            ps.setInt(1, team.getTournamentId());
            ps.setString(2, team.getTeamName());
            ps.setString(3, team.getCaptain());

            int rows = ps.executeUpdate();

            return rows > 0;

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return false;
    }
	

	@Override
	public List<Team> getAllTeams() {
		 List<Team> teams = new ArrayList<>();

	        String query = "SELECT * FROM teams";

	        try {
	            PreparedStatement ps = con.prepareStatement(query);
	            ResultSet rs = ps.executeQuery();

	            while (rs.next()) {

	                Team team = new Team();

	                team.setId(rs.getInt("id"));
	                team.setTournamentId(rs.getInt("tournament_id"));
	                team.setTeamName(rs.getString("team_name"));
	                team.setCaptain(rs.getString("captain"));

	                teams.add(team);
	            }

	        } catch (SQLException e) {
	            e.printStackTrace();
	        }

	        return teams;
	    }
	

	@Override
	public Team getTeamById(int id) {
		Team team = null;

        String query = "SELECT * FROM teams WHERE id = ?";

        try {
            PreparedStatement ps = con.prepareStatement(query);
            ps.setInt(1, id);

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {

                team = new Team();

                team.setId(rs.getInt("id"));
                team.setTournamentId(rs.getInt("tournament_id"));
                team.setTeamName(rs.getString("team_name"));
                team.setCaptain(rs.getString("captain"));
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return team;
	}

	@Override
	public boolean updateTeam(Team team) {
		String query = "UPDATE teams SET tournament_id = ?, team_name = ?, captain = ? WHERE id = ?";

        try {
            PreparedStatement ps = con.prepareStatement(query);

            ps.setInt(1, team.getTournamentId());
            ps.setString(2, team.getTeamName());
            ps.setString(3, team.getCaptain());
            ps.setInt(4, team.getId());

            int rows = ps.executeUpdate();

            return rows > 0;

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return false;
	}

	@Override
	public boolean deleteTeam(int id) {
		 String query = "DELETE FROM teams WHERE id = ?";

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
	}
/*
My teams table has a foreign key named tournament_id. 
That means the tournament ID I will pass to addTeam() must already exist in the tournaments table.

For ex, if my Cricket Premier League has ID 1, 
use 1 as its tournament ID when adding a team.*/
