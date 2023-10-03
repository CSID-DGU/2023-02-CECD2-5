package com.vegetable.VeggieHunter.repository.vegetable;

import com.vegetable.VeggieHunter.dto.response.vegetable.VegetableListResponse;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.SliceImpl;

import java.util.List;

public interface VegetableRepositoryCustom {
    List<VegetableListResponse> getVegetableList();
}
