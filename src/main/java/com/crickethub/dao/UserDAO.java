package com.crickethub.dao;

import com.crickethub.dto.User;

public interface UserDAO {

    User login(User user);

    boolean register(User user);
}