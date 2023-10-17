package com.vegetable.veggiehunter.controller.home;

import com.vegetable.veggiehunter.dto.response.CommonResponse;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RestController;

@Controller
@RequiredArgsConstructor
@Slf4j
@RequestMapping("/home")
public class HomeController {
    @GetMapping
    @ResponseBody
    public String helloString() {
        return "hello";
    }
}
