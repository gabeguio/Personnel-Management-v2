package com.project2.personnel_management_v2.Models;

import java.util.List;

public class User
{
    private String userName;
    private Name name;
    private String displayName;
    private String userType;
    private boolean active;
    private String password;
    private List<Email> emails;

    public User()
    {
    }

    public User(String userName, Name name, String displayName, String userType, boolean active, String password, List<Email> emails)
    {
        this.userName = userName;
        this.name = name;
        this.displayName = displayName;
        this.userType = userType;
        this.active = active;
        this.password = password;
        this.emails = emails;
    }


    @Override
    public String toString() {
        return "User{" +
                "userName='" + userName + '\'' +
                ", name=" + name +
                ", displayName='" + displayName + '\'' +
                ", userType='" + userType + '\'' +
                ", active=" + active +
                ", password='" + password + '\'' +
                ", emails=" + emails +
                '}';
    }
}
