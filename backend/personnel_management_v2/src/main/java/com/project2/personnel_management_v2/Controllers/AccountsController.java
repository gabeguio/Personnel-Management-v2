package com.project2.personnel_management_v2.Controllers;

import com.project2.personnel_management_v2.Services.AccountService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;


/**
 * REST controller for managing accounts.
 * Provides endpoints for creating, reading, updating, and deleting accounts.
 */
@RestController
@CrossOrigin(origins = "http://localhost:4200")
@RequestMapping("api/accounts")
public class AccountsController
{
    @Autowired
    AccountService service;

    String response;

    /**
     * Endpoint for creating a new Salesforce account
     *
     * @param account in JSON format as a String
     * @return a ResponseEntity containing the response from the service and the HTTP status code
     */
    @PostMapping
    public ResponseEntity<String> createAccount(@RequestBody String account)
    {
        ResponseEntity<String> resp = service.createAccount(account);
        return resp;
    }

    /**
     * Endpoint to get all accounts from Salesforce.
     *
     * @return a ResponseEntity containing all Salesfroce accounts and the HTTP status code
     */
    @GetMapping
    public ResponseEntity<String> getAllAccounts()
    {
        response = service.getAllAccounts();
        return new ResponseEntity<>(response, HttpStatus.OK);
    }

    /**
     * Endpoint to get a single account from Salesforce according to its ID.
     *
     * @return a ResponseEntity containing a Salesforce account and the HTTP status code
     */
    @GetMapping("/{accountId}")
    public ResponseEntity<String> getUserById(@PathVariable String accountId)
    {
        response = service.getAccountById(accountId);
        return new ResponseEntity<>(response, HttpStatus.OK);
    }

    /**
     * Endpoint to delete a single Salesforce account according to its ID
     *
     * @return a ResponseEntity containing HTTP message status
     */
    @DeleteMapping("/{accountId}")
    public ResponseEntity<String> deleteAccount(@PathVariable String accountId)
    {
        response = service.deleteAccount(accountId);
        return new ResponseEntity<>(response, HttpStatus.NO_CONTENT);
    }
}
