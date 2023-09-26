package com.vegetable.VeggieHunter.security.oauth2.userinfo;

import java.util.Map;

//우리 앱에서는 Google 만 있기 때문에 필요없는데 확장성을 위해서 interface 로 구현
public abstract class OAuth2UserInfo {

    protected Map<String, Object> attributes;

    public OAuth2UserInfo(Map<String, Object> attributes) {
        this.attributes = attributes;
    }

    public abstract String getId();
    public abstract String getNickname();

    public abstract String getEmail();
}
