package com.project2.personnel_management_v2.Models.Accounts;

public class Identity
{
    private String value;

    public Identity()
    {
    }

    public Identity(String value)
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
        return "Identity{" +
                "value='" + value + '\'' +
                '}';
    }
}
