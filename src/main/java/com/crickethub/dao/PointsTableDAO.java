package com.crickethub.dao;

import java.util.List;
import com.crickethub.dto.PointsTable;

public interface PointsTableDAO {

    List<PointsTable> getPointsTableByTournament(int tournamentId);

}
