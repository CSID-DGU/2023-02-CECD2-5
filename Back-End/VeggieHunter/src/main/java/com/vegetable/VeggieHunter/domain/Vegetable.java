package com.vegetable.veggiehunter.domain;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import org.hibernate.annotations.ColumnDefault;

import javax.persistence.*;
import java.util.List;

@Entity
@Getter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class Vegetable {
    @Id
    @GeneratedValue
    private Long id;

    @Column
    private String name; //채소 이름

    @Column
    private String image; //채소 사진

    @Column
    private String main_unit; //주 단위
    @Lob
    @Column
    private String storageMethod; //보관 방법

}
