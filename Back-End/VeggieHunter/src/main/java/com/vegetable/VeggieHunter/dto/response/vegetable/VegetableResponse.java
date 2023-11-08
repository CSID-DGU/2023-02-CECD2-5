package com.vegetable.veggiehunter.dto.response.vegetable;

import com.vegetable.veggiehunter.domain.Vegetable;
import lombok.Getter;
import org.hibernate.annotations.ColumnDefault;

import javax.persistence.Column;
import javax.persistence.Lob;
import java.util.Optional;

@Getter
public class VegetableResponse {

    private Long id;
    private String name; //채소 이름

    private String image; //채소 사진

    private String main_unit; //주 단위

    private String storageMethod; //보관 방법

    public VegetableResponse(Optional<Vegetable> vegetable) {
        this.id = vegetable.get().getId();;
        this.name = vegetable.get().getName();
        this.image = vegetable.get().getImage();
        this.main_unit = vegetable.get().getMain_unit();
        this.storageMethod = vegetable.get().getStorageMethod();
    }
}
