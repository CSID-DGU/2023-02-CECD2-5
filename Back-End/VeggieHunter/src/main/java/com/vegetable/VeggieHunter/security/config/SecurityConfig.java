package com.vegetable.VeggieHunter.security.config;

import com.vegetable.VeggieHunter.repository.user.UserRepository;
import com.vegetable.VeggieHunter.security.jwt.filter.JwtAuthenticationProcessingFilter;
import com.vegetable.VeggieHunter.security.jwt.service.JwtService;
import com.vegetable.VeggieHunter.security.oauth2.handler.OAuth2LoginFailureHandler;
import com.vegetable.VeggieHunter.security.oauth2.handler.OAuth2LoginSuccessHandler;
import com.vegetable.VeggieHunter.security.oauth2.service.CustomOAuth2UserService;
import com.vegetable.VeggieHunter.util.RedisUtil;
import lombok.RequiredArgsConstructor;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.config.annotation.web.configurers.AbstractHttpConfigurer;
import org.springframework.security.config.http.SessionCreationPolicy;
import org.springframework.security.web.SecurityFilterChain;
import org.springframework.security.web.authentication.logout.LogoutFilter;
import org.springframework.web.cors.CorsConfiguration;
import org.springframework.web.cors.CorsConfigurationSource;
import org.springframework.web.cors.UrlBasedCorsConfigurationSource;

import java.util.Arrays;

@Configuration
@EnableWebSecurity
@RequiredArgsConstructor
public class SecurityConfig {

    private final JwtService jwtService;
    private final UserRepository userRepository;
    private final OAuth2LoginSuccessHandler oAuth2LoginSuccessHandler;
    private final OAuth2LoginFailureHandler oAuth2LoginFailureHandler;
    private final CustomOAuth2UserService customOAuth2UserService;
    private final RedisUtil redisUtil;

    private static final String[] PERMIT_URL = {"/users/**, /oauth2/**", "/login/**", "/**"};

    @Bean
    public SecurityFilterChain filterChain(HttpSecurity http) throws Exception {
        http
                .formLogin().disable()
                .httpBasic().disable()
                .csrf(AbstractHttpConfigurer::disable)
                .cors().configurationSource(corsConfigurationSource())
                .and()
                .sessionManagement(configurer -> configurer.sessionCreationPolicy(SessionCreationPolicy.STATELESS))

                .authorizeHttpRequests(
                        authorize -> authorize
                                .requestMatchers(PERMIT_URL).permitAll()
                                .anyRequest().authenticated()
                .and()

                                .addFilterAfter(jwtAuthenticationProcessingFilter(), LogoutFilter.class))
                // 소셜 로그인 핸들러 등록
                .oauth2Login()
                .successHandler(oAuth2LoginSuccessHandler)
                .failureHandler(oAuth2LoginFailureHandler)
                .userInfoEndpoint().userService(customOAuth2UserService);


        return http.build();
    }

    @Bean
    public JwtAuthenticationProcessingFilter jwtAuthenticationProcessingFilter() {
        JwtAuthenticationProcessingFilter jwtAuthenticationProcessingFilter = new JwtAuthenticationProcessingFilter(jwtService, userRepository, redisUtil);
        return jwtAuthenticationProcessingFilter;
    }

    @Bean
    public CorsConfigurationSource corsConfigurationSource() {
        CorsConfiguration config = new CorsConfiguration();
        config.setAllowedOriginPatterns(Arrays.asList("*"));
        config.setAllowedMethods(Arrays.asList("GET", "POST", "PUT", "DELETE","PATCH","OPTIONS"));
        config.setAllowedHeaders(Arrays.asList("*"));
        config.setAllowCredentials(true);
        UrlBasedCorsConfigurationSource source = new UrlBasedCorsConfigurationSource();
        source.registerCorsConfiguration("/**", config);
        return source;
    }
}
