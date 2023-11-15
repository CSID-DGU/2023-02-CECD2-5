package com.vegetable.veggiehunter.dto.response.recipe;

import com.vegetable.veggiehunter.domain.Photo;
import com.vegetable.veggiehunter.domain.Recipe;
import com.vegetable.veggiehunter.domain.RecipeSteps;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;

import javax.persistence.Column;
import java.time.LocalDate;
import java.util.List;
import java.util.stream.Collectors;

@Getter
@AllArgsConstructor
@NoArgsConstructor
public class RecipeDetailResponse {
    private Long id;

    private String title;

    private String writer;

    private LocalDate createdDate;

    private List<String> photoList;

    public RecipeDetailResponse(Recipe recipe, List<Photo> photoList) {
        this.id = recipe.getId();
        this.title = recipe.getTitle();
        this.writer = recipe.getWriter();
        this.createdDate = recipe.getCreatedDate();
        this.photoList = photoList.stream()
                .map(photo -> photo.getSavedFile())
                .filter(fileUrl -> fileUrl != null)
                .collect(Collectors.toList());
    }

}
