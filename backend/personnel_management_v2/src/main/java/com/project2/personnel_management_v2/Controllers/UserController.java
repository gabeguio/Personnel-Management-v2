package com.project2.personnel_management_v2.Controllers;

import com.project2.personnel_management_v2.Services.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;


/**
 * REST controller for managing Sailpoint Identities.
 * Provides endpoints for creating, reading, updating, and deleting Sailpoint Identities.
 */
@RestController
@RequestMapping("/api/users")
@CrossOrigin(origins = "http://localhost:4200")
public class UserController
{
    @Autowired
    UserService service;

    /**
     * Endpoint for creating a new Salesforce account
     *
     * @param user in JSON format as a String
     * @return a ResponseEntity containing the response with the new  Sailpoint identity and response code
     */
    @PostMapping
    public ResponseEntity<String> createUser(@RequestBody String user)
    {
        String response = service.createUser(user);
        return new ResponseEntity<>(response, HttpStatus.CREATED);
    }

    /**
     * Endpoint to delete a single Identity from IdentityIQ
     *
     * @param userId IdentityIQ ID as a String
     * @return a ResponseEntity containing the data of the identity that has been removed with the response code
     */
    @DeleteMapping("/{userId}")
    public ResponseEntity<String> deleteUser(@PathVariable String userId)
    {
        String response = service.deleteUser(userId);
        return new ResponseEntity<>(response, HttpStatus.NO_CONTENT);
    }

    /**
     * Endpoint to get a single Identity from IdentityIQ
     *
     * @param userId IdentityIQ ID as a String
     * @return a ResponseEntity containing the data of the identity that has been requested with the response code
     */
    @GetMapping("/{userId}")
    public ResponseEntity<String> getUserById(@PathVariable String userId)
    {
        String response = service.getUserById(userId);
        return new ResponseEntity<>(response, HttpStatus.OK);
    }

    /**
     * Endpoint to access all Identities from IdentityIQ
     *
     * @return a ResponseEntity containing the data of all identities that have been requested with the response code
     */
    @GetMapping
    public ResponseEntity<String> getAllUsers()
    {
        String response = service.getAllUsers();
        return new ResponseEntity<>(response, HttpStatus.OK);
    }

    /**
     *  Endpoint to update a spicific Identity in IdentityIQ
     *
     * @param userId Identity ID as a String
     * @param user Identity as a JSON format
     * @return a ResponseEntity containing the data of the updated Identity
     */
    @PutMapping("/{userId}")
    public ResponseEntity<String> createUser(@PathVariable String userId, @RequestBody String user)
    {
        String response = service.updateUser(userId, user);
        return new ResponseEntity<>(response, HttpStatus.CREATED);
    }
}

