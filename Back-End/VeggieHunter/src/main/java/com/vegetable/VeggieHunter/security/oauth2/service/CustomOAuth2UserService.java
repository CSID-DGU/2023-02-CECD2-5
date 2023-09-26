package com.vegetable.VeggieHunter.security.oauth2.service;

import com.vegetable.VeggieHunter.domain.User;
import com.vegetable.VeggieHunter.repository.user.UserRepository;
import com.vegetable.VeggieHunter.security.oauth2.CustomOAuth2User;
import com.vegetable.VeggieHunter.security.oauth2.OAuthAttributes;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.oauth2.client.userinfo.DefaultOAuth2UserService;
import org.springframework.security.oauth2.client.userinfo.OAuth2UserRequest;
import org.springframework.security.oauth2.client.userinfo.OAuth2UserService;
import org.springframework.security.oauth2.core.OAuth2AuthenticationException;
import org.springframework.security.oauth2.core.user.OAuth2User;
import org.springframework.stereotype.Service;

import java.util.Collections;
import java.util.Map;

@Service
@Slf4j
@RequiredArgsConstructor
public class CustomOAuth2UserService implements OAuth2UserService<OAuth2UserRequest, OAuth2User> {

    private final UserRepository userRepository;

    @Override
    public OAuth2User loadUser(OAuth2UserRequest userRequest) throws OAuth2AuthenticationException {
        log.info("CustomOAuth2UserService.loadUser(), OAuth2 login request");

        OAuth2UserService<OAuth2UserRequest, OAuth2User> delegate = new DefaultOAuth2UserService();
        OAuth2User oAuth2User = delegate.loadUser(userRequest);


        String userNameAttributeName = userRequest.getClientRegistration()
                .getProviderDetails().getUserInfoEndpoint().getUserNameAttributeName();
        Map<String, Object> attributes = oAuth2User.getAttributes();

        OAuthAttributes extractAttributes = OAuthAttributes.of(userNameAttributeName, attributes);

        User createdUser = getUser(extractAttributes);

        return new CustomOAuth2User(
                Collections.singleton(new SimpleGrantedAuthority(createdUser.getRole().getKey())),
                attributes,
                extractAttributes.getNameAttributeKey(),
                createdUser.getEmail(),
                createdUser.getRole());
    }

    private User getUser(OAuthAttributes attributes) {
        User findUser = userRepository.findBySocialId(attributes.getOauth2UserInfo().getId()).orElse(null);

        if (findUser == null) {
            log.info("DB에 USER 없는 case");
            return saveUser(attributes);
        }
        log.info("DB에 USER EXIST");
        return findUser;
    }

    private User saveUser(OAuthAttributes attributes) {
        User createdUser = attributes.toEntity(attributes.getOauth2UserInfo());
        return userRepository.save(createdUser);
    }
}
