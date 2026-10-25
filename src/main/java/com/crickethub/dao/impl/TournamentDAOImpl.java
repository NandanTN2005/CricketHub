package com.crickethub.dao.impl;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import com.crickethub.dao.TournamentDAO;
import com.crickethub.dto.Tournament;
import com.crickethub.util.ConnectionFactory;

public class TournamentDAOImpl implements TournamentDAO {

	private Connection con;

	public TournamentDAOImpl() {
		this.con = ConnectionFactory.getCon();
	}

	@Override
	public boolean addTournament(Tournament tournament) {
		String query = "INSERT INTO tournaments (name, venue, start_date) VALUES (?, ?, ?)";

		try {
			PreparedStatement ps = con.prepareStatement(query);

			ps.setString(1, tournament.getName());
			ps.setString(2, tournament.getVenue());
			ps.setDate(3, java.sql.Date.valueOf(tournament.getStartDate()));

			int rows = ps.executeUpdate();

			return rows > 0;

		} catch (SQLException e) {
			e.printStackTrace();
		}

		return false;
	}

	@Override
	public List<Tournament> getAllTournaments() {
		List<Tournament> tournaments = new ArrayList<>();

		String query = "SELECT * FROM tournaments";

		try {
			PreparedStatement ps = con.prepareStatement(query);
			ResultSet rs = ps.executeQuery();

			while (rs.next()) {
				Tournament tournament = new Tournament();

				tournament.setId(rs.getInt("id"));
				tournament.setName(rs.getString("name"));
				tournament.setVenue(rs.getString("venue"));
				tournament.setStartDate(rs.getDate("start_date").toLocalDate());

				tournaments.add(tournament);
			}

		} catch (SQLException e) {
			e.printStackTrace();
		}

		return tournaments;
	}

	@Override
	public Tournament getTournamentById(int id) {
		Tournament tournament = null;

		String query = "SELECT * FROM tournaments WHERE id = ?";

		try {
			PreparedStatement ps = con.prepareStatement(query);
			ps.setInt(1, id);

			ResultSet rs = ps.executeQuery();

			if (rs.next()) {
				tournament = new Tournament();

				tournament.setId(rs.getInt("id"));
				tournament.setName(rs.getString("name"));
				tournament.setVenue(rs.getString("venue"));
				tournament.setStartDate(rs.getDate("start_date").toLocalDate());
			}

		} catch (SQLException e) {
			e.printStackTrace();
		}

		return tournament;
	}

	@Override
	public boolean updateTournament(Tournament tournament) {
		String query = "UPDATE tournaments SET name = ?, venue = ?, start_date = ? WHERE id = ?";

		try {
			PreparedStatement ps = con.prepareStatement(query);

			ps.setString(1, tournament.getName());
			ps.setString(2, tournament.getVenue());
			ps.setDate(3, java.sql.Date.valueOf(tournament.getStartDate()));
			ps.setInt(4, tournament.getId());

			int rows = ps.executeUpdate();

			return rows > 0;

		} catch (SQLException e) {
			e.printStackTrace();
		}

		return false;
	}

	@Override
	public boolean deleteTournament(int id) {
		String query = "DELETE FROM tournaments WHERE id = ?";

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