package com.crickethub.dto;

import java.time.LocalDate;

public class Tournament {
	private int id;
	private String name;
	private String venue;
	private LocalDate startDate;
	public Tournament() {
//This no-argument constructor lets me create an empty object and fill it using setters.
		
	}
	
	public Tournament(String name, String venue, LocalDate startDate ) {
//The parameterized constructor lets me create an object with tournament details.
		this.name=name;
		this.venue=venue;
		this.startDate=startDate;
	}
//Getters and setters let our DAO and servlet access the object's data.	
	public int getId() {
		return id;
	}
	public void setId(int id) {
		this.id = id;
	}
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
	public String getVenue() {
		return venue;
	}
	public void setVenue(String venue) {
		this.venue = venue;
	}
	public LocalDate getStartDate() {
		return startDate;
	}
	public void setStartDate(LocalDate startDate) {
		this.startDate = startDate;
	}

}
