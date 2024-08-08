package com.project2.personnel_management_v2.Services;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.*;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;
import java.util.Collections;

/**
 * Service class for managing Identities.
 * Provides methods to create, read, update, and delete identities by communicating with an Angular application.
 */
@Service
public class UserService
{
    private final RestTemplate template = new RestTemplate();

    @Value("${sp.url}")
    private String url;

    @Value("${sp.username}")
    private String username;

    @Value("${sp.password}")
    private String pass;

    /**
     * Method responsible for creating an HTTP entity with proper data to create an identity.
     *
     * @param user in JSON format as a String.
     * @return the response body from the SCIM API with the data of created identity.
     */
    public String createUser(String user)
    {
        HttpHeaders headers = new HttpHeaders();
        headers.setContentType(MediaType.APPLICATION_JSON);
        headers.setBasicAuth(username,pass);
        headers.setAccept(Collections.singletonList(MediaType.APPLICATION_JSON));
        HttpEntity<String> entity = new HttpEntity<>(user, headers);

        ResponseEntity<String> response = template
                .exchange(url + "Users",
                        HttpMethod.POST,
                        entity,
                        String.class);

        return response.getBody();

    }

    /**
     * Method responsible for creating an HTTP entity with proper data to delete an identity.
     *
     * @param userId String of an Identity ID.
     * @return the response body from the SCIM API with the data of deleted user
     */
    public String deleteUser(String userId)
    {
        HttpHeaders headers = new HttpHeaders();
        headers.setBasicAuth(username, pass);
        HttpEntity<String> entity = new HttpEntity<>(headers);
        ResponseEntity<String> response = template.
                exchange(url + "Users/" + userId,
                        HttpMethod.DELETE,
                        entity,
                        String.class);

        return response.getBody();
    }

    /**
     * Method responsible for returning all identities.
     *
     * @return the response body from the SCIM API with a list of all identities
     */
    public String getAllUsers()
    {
        HttpHeaders headers = new HttpHeaders();
        headers.setBasicAuth(username, pass);
        HttpEntity<String> entity = new HttpEntity<>(headers);
        ResponseEntity<String> response = template.
                exchange(url + "Users",
                        HttpMethod.GET,
                        entity,
                        String.class);

        return response.getBody();
    }

    /**
     * Method responsible for returning a single identity according to its ID
     *
     * @param userId String of the identity ID
     * @return the response body from the SCIM API with the requested Identity
     */
    public String getUserById(String userId)
    {
        HttpHeaders headers = new HttpHeaders();
        headers.setBasicAuth(username, pass);
        HttpEntity<String> entity = new HttpEntity<>(headers);
        ResponseEntity<String> response = template.
                exchange(url + "Users/" + userId,
                        HttpMethod.GET,
                        entity,
                        String.class);

        return response.getBody();
    }

    /**
     * Method responsible for creating an HTTP entity with proper data to update an identity.
     *
     * @param userId String of the identity ID
     * @param body in JSON format as a String.
     * @return the response body from the SCIM API with the data of updated identity
     */
    public String updateUser(String userId, String body)
    {
        HttpHeaders headers = new HttpHeaders();
        headers.setContentType(MediaType.APPLICATION_JSON);
        headers.setBasicAuth(username, pass);
        headers.setAccept(Collections.singletonList(MediaType.APPLICATION_JSON));
        HttpEntity<String> entity = new HttpEntity<>(body, headers);
        ResponseEntity<String> response = template.
                exchange(url + "Users/" + userId,
                        HttpMethod.PUT,
                        entity,
                        String.class);

        return response.getBody();

    }
}
