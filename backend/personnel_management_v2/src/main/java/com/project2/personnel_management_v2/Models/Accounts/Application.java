package com.project2.personnel_management_v2.Models.Accounts;

public class Application
{
    private String value;

    public Application()
    {
    }


    public Application(String value)
    {
        this.value = value;
    }

    public String getValue() {
        return value;
    }

    public void setValue(String value) {
        this.value = value;
    }

    @Override
    public String toString() {
        return "Application{" +
                "value='" + value + '\'' +
                '}';
    }
}
