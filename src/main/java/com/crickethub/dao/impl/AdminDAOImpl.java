package com.crickethub.dao.impl;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import com.crickethub.dao.AdminDAO;
import com.crickethub.dto.Admin;
import com.crickethub.util.ConnectionFactory;

public class AdminDAOImpl implements AdminDAO{
	
	private Connection con;
	
	public AdminDAOImpl() {
		this.con=ConnectionFactory.getCon();
	}

	@Override
	public Admin login(Admin admin) {
		Admin a=null;
		String query ="SELECT id, username FROM admins WHERE username=? AND password=?";
		try {
			PreparedStatement ps=con.prepareStatement(query);
			ps.setString(1, admin.getUsername());
			ps.setString(2, admin.getPassword());
			ResultSet rs=ps.executeQuery();
			
			if(rs.next()) {
				a=new Admin();
				a.setId(rs.getInt("id"));
				a.setUsername(rs.getString("username"));
			}
		}catch(SQLException e) {
			e.printStackTrace();
		}
		return a;
		
		
	}

}
