package com.ngo.service;

import com.ngo.dao.UserDAO;
import com.ngo.model.User;

public class AuthService {

    public User login(String username, String password) {
        return new UserDAO().validateUser(username, password);
    }
}
