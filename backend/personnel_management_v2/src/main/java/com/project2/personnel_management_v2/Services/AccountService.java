package com.project2.personnel_management_v2.Services;


import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.*;
import org.springframework.stereotype.Service;
import org.springframework.web.client.HttpServerErrorException;
import org.springframework.web.client.RestTemplate;

import java.util.Collections;

@Service
public class AccountService
{
    private final RestTemplate template = new RestTemplate();

    @Value("${sp.url}")
    private String url;

    @Value("${sp.username}")
    private String username;

    @Value("${sp.password}")
    private String pass;

    public ResponseEntity<String> createAccount(String account)
    {

       try
       {
           HttpHeaders headers = new HttpHeaders();
           headers.setContentType(MediaType.APPLICATION_JSON);
           headers.setBasicAuth(username,pass);
           headers.setAccept(Collections.singletonList(MediaType.APPLICATION_JSON));
           HttpEntity<String> entity = new HttpEntity<>(account, headers);

           ResponseEntity<String> response = template
                   .exchange(url + "Accounts",
                           HttpMethod.POST,
                           entity,
                           String.class);

           return response;

       }catch (HttpServerErrorException e)
       {
           if(!e.getResponseBodyAsString().contains("detail"))
           {
                return new ResponseEntity<String>(HttpStatus.CREATED);
           }
           throw e;
       }
    }

    public String getAllAccounts()
    {
        HttpHeaders headers = new HttpHeaders();
        headers.setBasicAuth(username, pass);
        HttpEntity<String> entity = new HttpEntity<>(headers);
        ResponseEntity<String> response = template.
                exchange(url + "Accounts",
                        HttpMethod.GET,
                        entity,
                        String.class);

        return response.getBody();
    }

    public String getAccountById(String accountId)
    {
        HttpHeaders headers = new HttpHeaders();
        headers.setBasicAuth(username, pass);
        HttpEntity<String> entity = new HttpEntity<>(headers);
        ResponseEntity<String> response = template.
                exchange(url + "Accounts/"+ accountId,
                        HttpMethod.GET,
                        entity,
                        String.class);

        return response.getBody();
    }

    public String deleteAccount(String accountId)
    {
        HttpHeaders headers = new HttpHeaders();
        headers.setBasicAuth(username, pass);
        HttpEntity<String> entity = new HttpEntity<>(headers);
        ResponseEntity<String> response = template.
                exchange(url + "Accounts/" + accountId,
                        HttpMethod.DELETE,
                        entity,
                        String.class);

        return response.getBody();
    }

    public String updateAccount(String accountId, String body)
    {
        HttpHeaders headers = new HttpHeaders();
        headers.setContentType(MediaType.APPLICATION_JSON);
        headers.setBasicAuth(username, pass);
        headers.setAccept(Collections.singletonList(MediaType.APPLICATION_JSON));
        HttpEntity<String> entity = new HttpEntity<>(body, headers);
        System.out.println(body);
        ResponseEntity<String> response = template.
                exchange(url + "Accounts/" + accountId,
                        HttpMethod.PUT,
                        entity,
                        String.class);

        return response.getBody();

    }
}
