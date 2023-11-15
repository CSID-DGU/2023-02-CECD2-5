package com.vegetable.veggiehunter.domain;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;

import javax.persistence.*;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

@Entity
@Getter
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class Recipe {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "recipe_id")
    private Long id;

    @Column
    private String title;

    @Column
    private String writer;

    @Column
    private LocalDate createdDate;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "vegetable_id")
    private Vegetable vegetable;

    @OneToMany(mappedBy = "recipe")
    @Builder.Default
    private List<Ingredient> ingredientList = new ArrayList<>();

    @OneToMany(mappedBy = "recipe")
    @Builder.Default
    private List<RecipeSteps> recipeStepsList = new ArrayList<>();

    @OneToMany(mappedBy = "recipe")
    @Builder.Default
    private List<Photo> photoList = new ArrayList<>();
}
