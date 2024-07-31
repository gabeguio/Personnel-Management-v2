package com.project2.personnel_management_v2.Models;

public class Email
{
    private String type;
    private String value;
    private boolean primary;

    public Email()
    {

    }

    public Email(String type, String value, boolean primary)
    {
        this.type = type;
        this.value = value;
        this.primary = primary;
    }

    @Override
    public String toString() {
        return "Email{" +
                "type='" + type + '\'' +
                ", value='" + value + '\'' +
                ", primary=" + primary +
                '}';
    }
}
