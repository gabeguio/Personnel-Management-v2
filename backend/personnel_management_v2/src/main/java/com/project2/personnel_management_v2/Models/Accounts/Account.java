package com.project2.personnel_management_v2.Models.Accounts;

import com.fasterxml.jackson.annotation.JsonProperty;



public class Account
{
    private Identity Identity;
    private Application Application;
    private String NativeIdentity;
    @JsonProperty("urn:ietf:params:scim:schemas:sailpoint:1.0:Application:Schema:Salesforce:account")
    private SalesforceAccount SalesforceAccount;


    public Account()
    {
    }

    public Account(com.project2.personnel_management_v2.Models.Accounts.Identity identity, com.project2.personnel_management_v2.Models.Accounts.Application application, String nativeIdentity, com.project2.personnel_management_v2.Models.Accounts.SalesforceAccount salesforceAccount) {
        Identity = identity;
        Application = application;
        NativeIdentity = nativeIdentity;
        SalesforceAccount = salesforceAccount;
    }

    public com.project2.personnel_management_v2.Models.Accounts.Identity getIdentity() {
        return Identity;
    }

    public void setIdentity(com.project2.personnel_management_v2.Models.Accounts.Identity identity) {
        Identity = identity;
    }

    public com.project2.personnel_management_v2.Models.Accounts.Application getApplication() {
        return Application;
    }

    public void setApplication(com.project2.personnel_management_v2.Models.Accounts.Application application) {
        Application = application;
    }

    public String getNativeIdentity() {
        return NativeIdentity;
    }

    public void setNativeIdentity(String nativeIdentity) {
        NativeIdentity = nativeIdentity;
    }

    public com.project2.personnel_management_v2.Models.Accounts.SalesforceAccount getSalesforceAccount() {
        return SalesforceAccount;
    }

    public void setSalesforceAccount(com.project2.personnel_management_v2.Models.Accounts.SalesforceAccount salesforceAccount) {
        SalesforceAccount = salesforceAccount;
    }

    @Override
    public String toString() {
        return "Account{" +
                "Identity=" + Identity +
                ", Application=" + Application +
                ", NativeIdentity='" + NativeIdentity + '\'' +
                ", SalesforceAccount=" + SalesforceAccount +
                '}';
    }
}
