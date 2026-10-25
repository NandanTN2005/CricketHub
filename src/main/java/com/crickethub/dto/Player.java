
package com.crickethub.dto;

public class Player {

    private int id;
    private int teamId;
    private String playerName;
    private Integer jerseyNumber;
    private String playingRole;

    public Player() {
    }

    public Player(int teamId, String playerName,
                  Integer jerseyNumber, String playingRole) {
        this.teamId = teamId;
        this.playerName = playerName;
        this.jerseyNumber = jerseyNumber;
        this.playingRole = playingRole;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getTeamId() {
        return teamId;
    }

    public void setTeamId(int teamId) {
        this.teamId = teamId;
    }

    public String getPlayerName() {
        return playerName;
    }

    public void setPlayerName(String playerName) {
        this.playerName = playerName;
    }

    public Integer getJerseyNumber() {
        return jerseyNumber;
    }

    public void setJerseyNumber(Integer jerseyNumber) {
        this.jerseyNumber = jerseyNumber;
    }

    public String getPlayingRole() {
        return playingRole;
    }

    public void setPlayingRole(String playingRole) {
        this.playingRole = playingRole;
    }
}
