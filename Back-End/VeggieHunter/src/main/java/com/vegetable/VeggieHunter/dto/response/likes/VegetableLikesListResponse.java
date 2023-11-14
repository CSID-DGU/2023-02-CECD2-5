package com.vegetable.veggiehunter.dto.response.likes;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;

@AllArgsConstructor
@NoArgsConstructor
@Getter
public class VegetableLikesListResponse {
    private Long id;
    private String name;
    private String image;
    private String unit;
    private Double price;
    private Double rate;
    private Boolean isLikes;
}
