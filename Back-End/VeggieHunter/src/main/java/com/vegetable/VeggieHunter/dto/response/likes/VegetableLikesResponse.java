package com.vegetable.veggiehunter.dto.response.likes;

import com.vegetable.veggiehunter.domain.Price;
import lombok.AllArgsConstructor;
import lombok.NoArgsConstructor;

import java.util.List;

@AllArgsConstructor
@NoArgsConstructor
public class VegetableLikesResponse {
    private String name;

    private String image;

    private String storageMethod;

    private List<Price> priceList;

}
