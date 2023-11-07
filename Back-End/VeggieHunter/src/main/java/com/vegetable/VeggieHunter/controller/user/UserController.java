package com.vegetable.veggiehunter.controller.user;

import com.vegetable.veggiehunter.domain.User;
import com.vegetable.veggiehunter.dto.response.CommonResponse;
import com.vegetable.veggiehunter.dto.response.ResponseService;
import com.vegetable.veggiehunter.dto.response.vegetable.VegetableListResponse;
import com.vegetable.veggiehunter.repository.user.UserRepository;
import com.vegetable.veggiehunter.service.user.UserService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpServletResponse;

@RestController
@RequiredArgsConstructor
@Slf4j
@RequestMapping("/user")
public class UserController {
    private final UserService userService;
    private final ResponseService responseService;

    // 사용자 정보 저장 API
    @PostMapping
    public CommonResponse.GeneralResponse signUp(@RequestBody User user, HttpServletResponse response) {
        userService.signUp(user, response);

        return responseService.getGeneralResponse(HttpStatus.OK.value(), "User request completed");
    }
}
