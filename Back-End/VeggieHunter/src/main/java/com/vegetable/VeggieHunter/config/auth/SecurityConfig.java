package com.vegetable.veggiehunter.config.auth;

import com.vegetable.veggiehunter.constant.Role;
import lombok.RequiredArgsConstructor;
import org.springframework.boot.autoconfigure.security.reactive.PathRequest;
import org.springframework.context.annotation.Bean;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.web.SecurityFilterChain;
import org.springframework.security.web.authentication.logout.LogoutFilter;

@RequiredArgsConstructor
@EnableWebSecurity
public class SecurityConfig {

    private final CustomOAuth2UserService customOAuth2UserService;
    private static final String[] PERMIT_URL = {"/users/**", "/oauth2/**", "/login/**", "/**"};
    @Bean
    public SecurityFilterChain filterChain(HttpSecurity http) throws Exception {
        http
                .authorizeHttpRequests(
                        authorize -> authorize
                                .antMatchers(PERMIT_URL).permitAll()
                                .antMatchers("/api/v1/**").hasRole(Role.USER.name())
                                .anyRequest().authenticated()
                )
                .csrf().disable()
                .headers().frameOptions().disable()
                .and()
                .logout(logout ->
                        logout.logoutSuccessUrl("/")
                )
                .oauth2Login(oauth2Login ->
                        oauth2Login.userInfoEndpoint(userInfoEndpoint ->
                                userInfoEndpoint.userService(customOAuth2UserService)
                        )
                );

        return http.build();
    }
}