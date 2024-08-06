package com.project2.personnel_management_v2.Services;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.project2.personnel_management_v2.Models.Accounts.Account;
import org.springframework.http.*;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;

import java.util.Collections;

@Service
public class AccountService
{
    private final RestTemplate template = new RestTemplate();

    public String createAccount(String account)
    {
        ObjectMapper objectMapper = new ObjectMapper();
        Account acc;

        // IGNORE LINE 23 THROUGH 28. IM TESTING HOW TO CREATE AN ACCOUNT OBJECT
        try {
            acc = objectMapper.readValue(account, Account.class);
        } catch (JsonProcessingException e) {
            throw new RuntimeException("Failed to convert JSON string to Account object", e);
        }
        // IGNORE LINE 23 THROUGH 28. IM TESTING HOW TO CREATE AN ACCOUNT OBJECT


        HttpHeaders headers = new HttpHeaders();
        headers.setContentType(MediaType.APPLICATION_JSON);
        headers.setBasicAuth("spadmin","admin");
        headers.setAccept(Collections.singletonList(MediaType.APPLICATION_JSON));
        HttpEntity<String> entity = new HttpEntity<>(account, headers);

        ResponseEntity<String> response = template
                .exchange("http://135.237.83.37:8080/identityiq/scim/v2/Accounts",
                        HttpMethod.POST,
                        entity,
                        String.class);

        return response.getBody();
    }

    public String getAllAccounts()
    {
        HttpHeaders headers = new HttpHeaders();
        headers.setBasicAuth("spadmin", "admin");
        HttpEntity<String> entity = new HttpEntity<>(headers);
        ResponseEntity<String> response = template.
                exchange("http://135.237.83.37:8080/identityiq/scim/v2/Accounts",
                        HttpMethod.GET,
                        entity,
                        String.class);

        return response.getBody();
    }

    public String getAccountById(String accountId)
    {
        HttpHeaders headers = new HttpHeaders();
        headers.setBasicAuth("spadmin", "admin");
        HttpEntity<String> entity = new HttpEntity<>(headers);
        ResponseEntity<String> response = template.
                exchange("http://135.237.83.37:8080/identityiq/scim/v2/Accounts/" + accountId,
                        HttpMethod.GET,
                        entity,
                        String.class);

        return response.getBody();
    }

    public String deleteAccount(String accountId)
    {
        HttpHeaders headers = new HttpHeaders();
        headers.setBasicAuth("spadmin", "admin");
        HttpEntity<String> entity = new HttpEntity<>(headers);
        ResponseEntity<String> response = template.
                exchange("http://135.237.83.37:8080/identityiq/scim/v2/Accounts/" + accountId,
                        HttpMethod.DELETE,
                        entity,
                        String.class);

        return response.getBody();
    }

    public String updateAccount(String accountId, String body)
    {
        HttpHeaders headers = new HttpHeaders();
        headers.setContentType(MediaType.APPLICATION_JSON);
        headers.setBasicAuth("spadmin", "admin");
        headers.setAccept(Collections.singletonList(MediaType.APPLICATION_JSON));
        HttpEntity<String> entity = new HttpEntity<>(body, headers);
        System.out.println(body);
        ResponseEntity<String> response = template.
                exchange("http://135.237.83.37:8080/identityiq/scim/v2/Accounts/" + accountId,
                        HttpMethod.PUT,
                        entity,
                        String.class);

        return response.getBody();

    }
}
