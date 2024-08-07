package com.project2.personnel_management_v2.Services;

import org.springframework.http.*;
import org.springframework.stereotype.Service;
import org.springframework.web.client.HttpServerErrorException;
import org.springframework.web.client.RestTemplate;

import java.util.Collections;

@Service
public class AccountService
{
    private final RestTemplate template = new RestTemplate();

    public String createAccount(String account)
    {

       try
       {
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

       }catch (HttpServerErrorException e)
       {
           if(!e.getResponseBodyAsString().contains("detail"))
           {
                return "Account has been created successfully";
           }
           throw e;
       }


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
