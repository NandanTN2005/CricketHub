package com.crickethub.dao;

import java.util.List;

import com.crickethub.dto.Tournament;

public interface TournamentDAO {
	boolean addTournament(Tournament tournament);//Add a new tournament to MySQL
	
	List<Tournament> getAllTournaments();//Retrieve all tournaments

    Tournament getTournamentById(int id);//Retrieve one tournament using its ID
    boolean updateTournament(Tournament tournament);//Edit tournament details
    
    boolean deleteTournament(int id);//Delete a tournament

}
