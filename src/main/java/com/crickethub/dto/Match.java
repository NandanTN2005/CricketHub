
package com.crickethub.dto;

import java.time.LocalDateTime;

public class Match {

    private int id;
    private int tournamentId;
    private int team1Id;
    private int team2Id;
    private LocalDateTime matchDate;
    private Integer team1Runs;
    private Integer team2Runs;
    private Integer winnerTeamId;
    private String status;
    private String team1Name;
    private String team2Name;
    private String winnerTeamName;

    public Match() {
    }
    //We'll use the parameterized constructor when we have all the details needed to schedule a match,
    //and the no-argument constructor when we need to create an object 
    //and populate it using setters.

    
    public Match(int tournamentId, int team1Id, int team2Id,
                 LocalDateTime matchDate) {
        this.tournamentId = tournamentId;
        this.team1Id = team1Id;
        this.team2Id = team2Id;
        this.matchDate = matchDate;
        this.status = "SCHEDULED";
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

    public int getTeam1Id() {
        return team1Id;
    }

    public void setTeam1Id(int team1Id) {
        this.team1Id = team1Id;
    }

    public int getTeam2Id() {
        return team2Id;
    }

    public void setTeam2Id(int team2Id) {
        this.team2Id = team2Id;
    }

    public LocalDateTime getMatchDate() {
        return matchDate;
    }

    public void setMatchDate(LocalDateTime matchDate) {
        this.matchDate = matchDate;
    }

    public Integer getTeam1Runs() {
        return team1Runs;
    }

    public void setTeam1Runs(Integer team1Runs) {
        this.team1Runs = team1Runs;
    }

    public Integer getTeam2Runs() {
        return team2Runs;
    }

    public void setTeam2Runs(Integer team2Runs) {
        this.team2Runs = team2Runs;
    }

    public Integer getWinnerTeamId() {
        return winnerTeamId;
    }

    public void setWinnerTeamId(Integer winnerTeamId) {
        this.winnerTeamId = winnerTeamId;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }
    public String getTeam1Name() {
        return team1Name;
    }

    public void setTeam1Name(String team1Name) {
        this.team1Name = team1Name;
    }

    public String getTeam2Name() {
        return team2Name;
    }

    public void setTeam2Name(String team2Name) {
        this.team2Name = team2Name;
    }
    public String getWinnerTeamName() {
        return winnerTeamName;
    }

    public void setWinnerTeamName(String winnerTeamName) {
        this.winnerTeamName = winnerTeamName;
    }
}
