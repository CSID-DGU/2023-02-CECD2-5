package com.vegetable.veggiehunter.repository.vegetable;

import com.vegetable.veggiehunter.dto.response.vegetable.VegetableListResponse;

import java.util.List;

public interface VegetableRepositoryCustom {
    List<VegetableListResponse> getVegetableList();
}
