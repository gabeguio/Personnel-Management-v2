package com.project2.personnel_management_v2.Models.Accounts;

import com.fasterxml.jackson.annotation.JsonProperty;

public class SalesforceAccount
{
    @JsonProperty("ProfileName")
    private String profileName;

    @JsonProperty("Username")
    private String username;

    @JsonProperty("LastName")
    private String lastName;

    @JsonProperty("Alias")
    private String alias;

    @JsonProperty("Email")
    private String email;

    @JsonProperty("TimeZoneSidKey")
    private String timeZoneSidKey;

    @JsonProperty("LocaleSidKey")
    private String localeSidKey;

    @JsonProperty("EmailEncodingKey")
    private String emailEncodingKey;

    @JsonProperty("LanguageLocaleKey")
    private String languageLocaleKey;


    public SalesforceAccount()
    {
    }

    public SalesforceAccount(String profileName, String username, String lastName, String alias, String email, String timeZoneSidKey, String localeSidKey, String emailEncodingKey, String languageLocaleKey)
    {
        this.profileName = profileName;
        this.username = username;
        this.lastName = lastName;
        this.alias = alias;
        this.email = email;
        this.timeZoneSidKey = timeZoneSidKey;
        this.localeSidKey = localeSidKey;
        this.emailEncodingKey = emailEncodingKey;
        this.languageLocaleKey = languageLocaleKey;
    }

    public String getProfileName() {
        return profileName;
    }

    public void setProfileName(String profileName) {
        this.profileName = profileName;
    }

    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public String getLastName() {
        return lastName;
    }

    public void setLastName(String lastName) {
        this.lastName = lastName;
    }

    public String getAlias() {
        return alias;
    }

    public void setAlias(String alias) {
        this.alias = alias;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getTimeZoneSidKey() {
        return timeZoneSidKey;
    }

    public void setTimeZoneSidKey(String timeZoneSidKey) {
        this.timeZoneSidKey = timeZoneSidKey;
    }

    public String getLocaleSidKey() {
        return localeSidKey;
    }

    public void setLocaleSidKey(String localeSidKey) {
        this.localeSidKey = localeSidKey;
    }

    public String getEmailEncodingKey() {
        return emailEncodingKey;
    }

    public void setEmailEncodingKey(String emailEncodingKey) {
        this.emailEncodingKey = emailEncodingKey;
    }

    public String getLanguageLocaleKey() {
        return languageLocaleKey;
    }

    public void setLanguageLocaleKey(String languageLocaleKey) {
        this.languageLocaleKey = languageLocaleKey;
    }

    @Override
    public String toString() {
        return "SalesforceAccount{" +
                "profileName='" + profileName + '\'' +
                ", username='" + username + '\'' +
                ", lastName='" + lastName + '\'' +
                ", alias='" + alias + '\'' +
                ", email='" + email + '\'' +
                ", timeZoneSidKey='" + timeZoneSidKey + '\'' +
                ", localeSidKey='" + localeSidKey + '\'' +
                ", emailEncodingKey='" + emailEncodingKey + '\'' +
                ", languageLocaleKey='" + languageLocaleKey + '\'' +
                '}';
    }
}
