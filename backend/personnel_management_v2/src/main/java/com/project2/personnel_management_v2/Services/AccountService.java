package com.project2.personnel_management_v2.Services;


import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.*;
import org.springframework.stereotype.Service;
import org.springframework.web.client.HttpServerErrorException;
import org.springframework.web.client.RestTemplate;
import java.util.Collections;

/**
 * Service class for managing Salesforce Accounts.
 * Provides methods to create, read and delete Salesforce accounts by communicating with an Angular application.
 */
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

    /**
     * Method responsible for creating an HTTP entity with proper data to create a Salesforce account.
     *
     * @param account in JSON format as a String
     * @return Empty HTTP response object with created HTTP status code.
     */
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
                return new ResponseEntity<String>("success", HttpStatus.CREATED);
           }
           throw e;
       }
    }

    /**
     * Method responsible for returning all salesforce Accounts.
     *
     * @return the response body from the SCIM API with a list of all Salesforce Accounts
     */
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

    /**
     * Method responsible for returning a single Salesforce account according to the ID of the Identity
     *
     * @param accountId String of the identity account ID
     * @return the response body from the SCIM API with the requested account
     */
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

    /**
     * Method responsible for creating an HTTP entity with proper data to delete Salesforce account.
     *
     * @param accountId String of an Identity account ID.
     * @return the response body from the SCIM API with the data of deleted account
     */
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
}
