
package com.crickethub.dao;

import java.util.List;
import com.crickethub.dto.Player;

public interface PlayerDAO {

    boolean addPlayer(Player player);

    List<Player> getPlayersByTeam(int teamId);

    boolean updatePlayer(Player player);

    boolean deletePlayer(int id);

    // Delete a player only if they belong to the specified team
    boolean deletePlayer(int id, int teamId);
    
    int getPlayerCountByTeam(int teamId);
}
