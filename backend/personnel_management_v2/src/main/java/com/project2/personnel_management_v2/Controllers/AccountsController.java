package com.project2.personnel_management_v2.Controllers;

import com.project2.personnel_management_v2.Models.Accounts.Account;
import com.project2.personnel_management_v2.Services.AccountService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@CrossOrigin("*")
@RequestMapping("api/accounts")
public class AccountsController
{
    @Autowired
    AccountService service;

    String response;

    @PostMapping
    public ResponseEntity<String> createAccount(@RequestBody String account)
    {
         response = service.createAccount(account);
         return new ResponseEntity<>(response, HttpStatus.CREATED);
    }

    @GetMapping
    public ResponseEntity<String> getAllAccounts()
    {
        response = service.getAllAccounts();
        return new ResponseEntity<>(response, HttpStatus.OK);
    }

    @GetMapping("/{accountId}")
    public ResponseEntity<String> getUserById(@PathVariable String accountId)
    {
        response = service.getAccountById(accountId);
        return new ResponseEntity<>(response, HttpStatus.OK);
    }

    @DeleteMapping("/{accountId}")
    public ResponseEntity<String> deleteAccount(@PathVariable String accountId)
    {
        response = service.deleteAccount(accountId);
        return new ResponseEntity<>(response, HttpStatus.NO_CONTENT);
    }

    @PutMapping("/{accountId}")
    public ResponseEntity<String> updateAccount(@PathVariable String accountId, @RequestBody String body)
    {
        response = service.updateAccount(accountId, body);
        return new ResponseEntity<>(response, HttpStatus.NO_CONTENT);
    }
}
