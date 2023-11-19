package com.vegetable.veggiehunter.dto.response.vegetable;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;

@AllArgsConstructor
@NoArgsConstructor
@Getter
public class VegetableHighLikesListResponse {
    private Long id;
    private String name;
    private String image;
    private Long likeCount;
}
