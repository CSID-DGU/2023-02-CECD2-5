package com.vegetable.veggiehunter.service.vegetable;

import com.vegetable.veggiehunter.dto.response.CommonResponse;
import com.vegetable.veggiehunter.dto.response.ResponseService;
import com.vegetable.veggiehunter.dto.response.vegetable.VegetableListResponse;
import com.vegetable.veggiehunter.repository.vegetable.VegetableRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
@RequiredArgsConstructor
@Transactional
public class VegetableService {
    private final VegetableRepository vegetableRepository;
    private final ResponseService responseService;

    public CommonResponse.ListResponse<VegetableListResponse> getVegetableList() {
        List<VegetableListResponse> result = vegetableRepository.getVegetableList();
        return responseService.getListResponse(HttpStatus.OK.value(), result);
    }

}