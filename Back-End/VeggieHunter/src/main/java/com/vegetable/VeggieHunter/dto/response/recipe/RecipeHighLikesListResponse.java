package com.vegetable.veggiehunter.dto.response.recipe;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;

@AllArgsConstructor
@NoArgsConstructor
@Getter
public class RecipeHighLikesListResponse {
    private Long id;
    private String title;
    private String image;
    private Long likeCount;
}
