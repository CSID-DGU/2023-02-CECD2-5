package com.vegetable.veggiehunter.controller.user;

import com.vegetable.veggiehunter.dto.response.CommonResponse;
import com.vegetable.veggiehunter.dto.response.ResponseService;
import com.vegetable.veggiehunter.security.jwt.service.JwtService;
import com.vegetable.veggiehunter.service.user.UserService;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.NoSuchElementException;

@RestController
@RequiredArgsConstructor
@Slf4j
@RequestMapping("/users")
public class UserController {
    private final UserService userService;
    private final JwtService jwtService;
    private final ResponseService responseService;

    @PostMapping("/sign-up")
    public CommonResponse.GeneralResponse signUp(@Valid @RequestBody String nickname,
                                                 HttpServletResponse response) {
        userService.signUp(nickname, response);
        return responseService.getGeneralResponse(HttpStatus.OK.value(), "User request completed");
    }

    @PostMapping("/logout")
    public CommonResponse.GeneralResponse logout(HttpServletRequest request) {
        String accessToken = jwtService.extractAccessToken(request).orElseThrow(
                () -> new NoSuchElementException("access Token is not exist"));
        userService.logout(accessToken);
        return responseService.getGeneralResponse(HttpStatus.OK.value(), "logout success");
    }
}
