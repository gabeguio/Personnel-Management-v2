package com.project2.personnel_management_v2.Config;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.http.HttpMethod;
import org.springframework.security.config.Customizer;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.web.SecurityFilterChain;

/**
 * Security Configuration Class:
 * - This class sets up the security filter chain to enforce authentication
 *   for all API endpoints and configures HTTP Basic Auth
 */

@Configuration
public class SecurityConfig
{
    /**
     * Configures the security filter chain.
     *
     * This method sets up HTTP Basic Authentication and ensures that all HTTP methods
     * (GET, POST, PUT, DELETE) for endpoints under '/api/**' require authentication.
     *
     */
    @Bean
    SecurityFilterChain securityFilterChain(HttpSecurity http) throws Exception
    {
        http.httpBasic(Customizer.withDefaults());
        http.authorizeHttpRequests(reqs ->{

            reqs.requestMatchers(HttpMethod.GET, "/api/**").authenticated()
                    .requestMatchers(HttpMethod.POST, "/api/**").authenticated()
                    .requestMatchers(HttpMethod.PUT, "/api/**").authenticated()
                    .requestMatchers(HttpMethod.DELETE, "/api/**").authenticated()
                    .anyRequest().authenticated();
        }).csrf().disable();

        return http.build();
    }

}
