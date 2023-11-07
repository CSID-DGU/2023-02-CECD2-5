package com.vegetable.veggiehunter.service.user;

import com.vegetable.veggiehunter.domain.User;
import com.vegetable.veggiehunter.dto.response.ResponseService;
import com.vegetable.veggiehunter.repository.user.UserRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import javax.servlet.http.HttpServletResponse;
import java.util.Optional;

@Service
@RequiredArgsConstructor
@Transactional
public class UserService {
    private final ResponseService responseService;
    private final UserRepository userRepository;

    @Transactional
    public void signUp(User user, HttpServletResponse response) {
        Optional<Object> findUser = userRepository.findByUserId(user.getUserId());
        if (findUser.isEmpty()) {
            userRepository.save(user);
        }
    }
}
