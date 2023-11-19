package com.vegetable.veggiehunter.dto.response.likes;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;

import java.time.LocalDate;

@AllArgsConstructor
@NoArgsConstructor
@Getter
public class RecipeLikesListResponse {
    private Long id;
    private String title;
    private String image;
    private Boolean isLikes;
}
