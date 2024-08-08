package com.project2.personnel_management_v2.Services;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.*;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;
import java.util.Collections;


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
