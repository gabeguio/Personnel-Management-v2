package com.project2.personnel_management_v2.Services;

import com.fasterxml.jackson.databind.ObjectMapper;
import org.springframework.http.*;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;
import java.util.Collections;
import java.util.Map;

@Service
public class UserService
{
    private final RestTemplate template = new RestTemplate();

    public String createUser(String user)
    {
        HttpHeaders headers = new HttpHeaders();
        headers.setContentType(MediaType.APPLICATION_JSON);
        headers.setBasicAuth("spadmin","admin");
        headers.setAccept(Collections.singletonList(MediaType.APPLICATION_JSON));
        HttpEntity<String> entity = new HttpEntity<>(user, headers);

        ResponseEntity<String> response = template
                .exchange("http://135.237.83.37:8080/identityiq/scim/v2" + "/Users",
                        HttpMethod.POST,
                        entity,
                        String.class);

        return response.getBody();

    }

    public String deleteUser(String userId)
    {
        HttpHeaders headers = new HttpHeaders();
        headers.setBasicAuth("spadmin", "admin");
        HttpEntity<String> entity = new HttpEntity<>(headers);
        ResponseEntity<String> response = template.
                exchange("http://135.237.83.37:8080/identityiq/scim/v2/Users/" + userId,
                        HttpMethod.DELETE,
                        entity,
                        String.class);

        return response.getBody();
    }

    public String getAllUsers()
    {
        HttpHeaders headers = new HttpHeaders();
        headers.setBasicAuth("spadmin", "admin");
        HttpEntity<String> entity = new HttpEntity<>(headers);
        ResponseEntity<String> response = template.
                exchange("http://135.237.83.37:8080/identityiq/scim/v2/Users",
                        HttpMethod.GET,
                        entity,
                        String.class);

        return response.getBody();
    }

    public String getUserById(String userId)
    {
        HttpHeaders headers = new HttpHeaders();
        headers.setBasicAuth("spadmin", "admin");
        HttpEntity<String> entity = new HttpEntity<>(headers);
        ResponseEntity<String> response = template.
                exchange("http://135.237.83.37:8080/identityiq/scim/v2/Users/" + userId,
                        HttpMethod.GET,
                        entity,
                        String.class);

        return response.getBody();
    }

    public String updateUser(String userId, String body)
    {
        HttpHeaders headers = new HttpHeaders();
        headers.setContentType(MediaType.APPLICATION_JSON);
        headers.setBasicAuth("spadmin", "admin");
        headers.setAccept(Collections.singletonList(MediaType.APPLICATION_JSON));
        HttpEntity<String> entity = new HttpEntity<>(body, headers);
        ResponseEntity<String> response = template.
                exchange("http://135.237.83.37:8080/identityiq/scim/v2/Users/" + userId,
                        HttpMethod.PUT,
                        entity,
                        String.class);

        return response.getBody();

    }
}
