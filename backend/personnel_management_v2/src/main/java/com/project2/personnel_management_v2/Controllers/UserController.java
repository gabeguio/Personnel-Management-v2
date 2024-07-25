package com.project2.personnel_management_v2.Controllers;

import com.project2.personnel_management_v2.Services.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/users")
public class UserController
{
    @Autowired
    UserService service;

    @PostMapping
    public ResponseEntity<String> createUser(@RequestBody String user)
    {
        String response = service.createUser(user);
        return new ResponseEntity<>(response, HttpStatus.CREATED);
    }

    @DeleteMapping("/{userId}")
    public ResponseEntity<String> deleteUser(@PathVariable String userId)
    {
        System.out.println(userId);
        String response = service.deleteUser(userId);
        return new ResponseEntity<>(response, HttpStatus.NO_CONTENT);
    }
}

