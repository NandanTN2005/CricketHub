package com.crickethub.dao;

import java.util.List;

import com.crickethub.dto.Match;

public interface MatchDAO {
	boolean addMatch(Match match);
	//This accepts a Match object and returns true if the match is saved successfully, 
	//otherwise false.
	
	
	List<Match> getAllMatches();//Retrieve all scheduled and completed matches
	
	Match getMatchById(int id);//Find one match using its ID
	
	boolean updateMatch(Match match);
	
	boolean deleteMatch(int id);

}
