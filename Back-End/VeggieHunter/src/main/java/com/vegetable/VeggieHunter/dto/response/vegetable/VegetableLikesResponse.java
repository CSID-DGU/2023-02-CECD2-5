package com.vegetable.VeggieHunter.dto.response.vegetable;

import com.vegetable.VeggieHunter.domain.Price;
import com.vegetable.VeggieHunter.domain.Vegetable;

import java.util.List;

public class VegetableLikesResponse {
    private String name;

    private String image;

    private String storageMethod;

    private List<Price> priceList;

    public VegetableLikesResponse(Vegetable vegetable) {
        this.name = vegetable.getName();
        this.image = vegetable.getImage();
        this.storageMethod = vegetable.getStorageMethod();
        this.priceList = vegetable.getPriceList();
    }
}
