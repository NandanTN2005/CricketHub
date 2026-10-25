package com.crickethub.dto;

public class Team {
	private int id;
	private int tournamentId;
	private String teamName;
	private String captain;
	
	public Team() {
		
	}
	public Team(int tournamentId, String teamName, String captain) {
		this.tournamentId=tournamentId;
		this.teamName=teamName;
		this.captain=captain;
	}
	public int getId() {
		return id;
	}
	public void setId(int id) {
		this.id = id;
	}
	public int getTournamentId() {
		return tournamentId;
	}
	public void setTournamentId(int tournamentId) {
		this.tournamentId = tournamentId;
	}
	public String getTeamName() {
		return teamName;
	}
	public void setTeamName(String teamName) {
		this.teamName = teamName;
	}
	public String getCaptain() {
		return captain;
	}
	public void setCaptain(String captain) {
		this.captain = captain;
	}

}
