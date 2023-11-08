package com.vegetable.veggiehunter.controller.vegetable;

import com.vegetable.veggiehunter.dto.response.CommonResponse;
import com.vegetable.veggiehunter.dto.response.vegetable.VegetableGraphResponse;
import com.vegetable.veggiehunter.dto.response.vegetable.VegetableListResponse;
import com.vegetable.veggiehunter.dto.response.vegetable.VegetableResponse;
import com.vegetable.veggiehunter.service.vegetable.VegetableService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequiredArgsConstructor
@Slf4j
@RequestMapping("/vegetable")
public class VegetableController {
    private final VegetableService vegetableService;
    @GetMapping
    public ResponseEntity<CommonResponse.ListResponse<VegetableListResponse>> getVegetableList() {
        return ResponseEntity.ok().body(vegetableService.getVegetableList());
    }

    @GetMapping("/{vegetableId}")
    public ResponseEntity<CommonResponse.SingleResponse<VegetableResponse>> getVegetableDetail(@PathVariable Long vegetableId) {
        return ResponseEntity.ok().body(vegetableService.getVegetableDetail(vegetableId));
    }

    @GetMapping("/{vegetableId}/graph")
    public ResponseEntity<CommonResponse.ListResponse<VegetableGraphResponse>> getVegetableGraph(@PathVariable Long vegetableId){
        return ResponseEntity.ok().body(vegetableService.getVegetableGraph(vegetableId));

    }
}
