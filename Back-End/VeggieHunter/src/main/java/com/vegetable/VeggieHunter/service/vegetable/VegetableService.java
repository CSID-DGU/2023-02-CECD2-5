package com.vegetable.veggiehunter.service.vegetable;

import com.vegetable.veggiehunter.dto.response.vegetable.VegetableGraphResponse;
import com.vegetable.veggiehunter.domain.Vegetable;
import com.vegetable.veggiehunter.dto.response.CommonResponse;
import com.vegetable.veggiehunter.dto.response.ResponseService;
import com.vegetable.veggiehunter.dto.response.vegetable.VegetableListResponse;
import com.vegetable.veggiehunter.dto.response.vegetable.VegetableResponse;
import com.vegetable.veggiehunter.repository.vegetable.VegetableRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Optional;

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

    public CommonResponse.SingleResponse<VegetableResponse> getVegetableDetail(Long vegetableId) {
        Optional<Vegetable> vegetable = vegetableRepository.findById(vegetableId);
        VegetableResponse vegetableResponse = new VegetableResponse(vegetable);

        return responseService.getSingleResponse(HttpStatus.OK.value(), vegetableResponse);
    }

    public CommonResponse.ListResponse<VegetableGraphResponse> getVegetableGraph(Long vegetableId) {
        List<VegetableGraphResponse> result = vegetableRepository.getVegetableGraphList(vegetableId);
        return responseService.getListResponse(HttpStatus.OK.value(), result);
    }
}
