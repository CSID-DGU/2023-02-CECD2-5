package com.vegetable.veggiehunter.dto.response.recipe;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import org.joda.time.DateTime;

import java.time.LocalDate;

@Getter
@AllArgsConstructor
@NoArgsConstructor
public class RecipeListResponse {
    private Long id;
    private String title;
    private String image;
    private String writer;
    private LocalDate createdDate;
}
