package com.vegetable.veggiehunter.dto.response.vegetable;

import com.vegetable.veggiehunter.domain.Vegetable;
import lombok.Getter;
import org.hibernate.annotations.ColumnDefault;

import javax.persistence.Column;
import javax.persistence.Lob;

@Getter
public class VegetableResponse {

    private String name; //채소 이름

    private String image; //채소 사진

    private String main_unit; //주 단위

    private String storageMethod; //보관 방법

}
