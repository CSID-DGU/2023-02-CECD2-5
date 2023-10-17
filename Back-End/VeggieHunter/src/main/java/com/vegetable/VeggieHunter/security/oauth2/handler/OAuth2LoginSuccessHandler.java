package com.vegetable.veggiehunter.security.oauth2.handler;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.vegetable.veggiehunter.constant.Role;
import com.vegetable.veggiehunter.domain.User;
import com.vegetable.veggiehunter.dto.response.CommonResponse;
import com.vegetable.veggiehunter.repository.user.UserRepository;
import com.vegetable.veggiehunter.security.jwt.service.JwtService;
import com.vegetable.veggiehunter.security.oauth2.CustomOAuth2User;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpStatus;
import org.springframework.security.core.Authentication;
import org.springframework.security.web.authentication.AuthenticationSuccessHandler;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

import java.io.IOException;
import java.util.NoSuchElementException;

@Slf4j
@Component
@RequiredArgsConstructor
public class OAuth2LoginSuccessHandler implements AuthenticationSuccessHandler {

    private final JwtService jwtService;
    private final UserRepository userRepository;
    private final ObjectMapper objectMapper;
    @Override
    @Transactional
    public void onAuthenticationSuccess(HttpServletRequest request, HttpServletResponse response, Authentication authentication) throws IOException, ServletException {
        log.info("OAuth2 login success");
        try {
            CustomOAuth2User oAuth2User = (CustomOAuth2User) authentication.getPrincipal();

            // 최초 로그인 요청 -> 회원가입
            if (oAuth2User.getRole() == Role.GUEST) {
                log.info("ROLE : GUEST");
                String accessToken = jwtService.createAccessToken(oAuth2User.getEmail());
                response.addHeader(jwtService.getAccessHeader(), "Bearer " + accessToken);

                log.info("Access Token : {}", accessToken);

                jwtService.sendAccessAndRefreshToken(response, accessToken, null);

            } else {
                log.info("ROLE : USER");
                loginSuccess(response, oAuth2User);
            }

            CommonResponse.GeneralResponse generalResponse = new CommonResponse.GeneralResponse(true, HttpStatus.OK.value(), "login success");
            String result = objectMapper.writeValueAsString(generalResponse);
            response.getWriter().write(result);
        }catch (Exception e) {
            log.error("occur error in process");
            throw e;
        }
    }

    private void loginSuccess(HttpServletResponse response, CustomOAuth2User oAuth2User) throws IOException {
        String accessToken = jwtService.createAccessToken(oAuth2User.getEmail());
        String refreshToken = jwtService.createRefreshToken();
        response.addHeader(jwtService.getAccessHeader(), "Bearer " + accessToken);
        response.addHeader(jwtService.getRefreshHeader(), "Bearer " + refreshToken);

        log.info("Access Token : {}", accessToken);

        jwtService.sendAccessAndRefreshToken(response, accessToken, refreshToken);
        jwtService.updateRefreshToken(oAuth2User.getEmail(), refreshToken);


        //login -> setting refreshToken
        User user = userRepository.findByEmail(oAuth2User.getEmail()).orElseThrow(
                () -> new NoSuchElementException("user not found"));
        user.updateRefreshToken(refreshToken);
    }
}
