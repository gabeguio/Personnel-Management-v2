package com.project2.personnel_management_v2.Models;

public class Name
{
    private String formatted;
    private String familyName;
    private String givenName;

    public Name()
    {
    }

    public Name(String formatted, String familyName, String givenName) {
        this.formatted = formatted;
        this.familyName = familyName;
        this.givenName = givenName;
    }

    @Override
    public String toString() {
        return "Name{" +
                "formatted='" + formatted + '\'' +
                ", familyName='" + familyName + '\'' +
                ", givenName='" + givenName + '\'' +
                '}';
    }
}
