
package com.crickethub.dao;

import java.util.List;
import com.crickethub.dto.Team;

public interface TeamDAO {

    boolean addTeam(Team team);

    List<Team> getAllTeams();

    Team getTeamById(int id);

    boolean updateTeam(Team team);

    boolean deleteTeam(int id);
}
