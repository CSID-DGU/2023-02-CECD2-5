package com.vegetable.veggiehunter.repository.vegetable;

import com.vegetable.veggiehunter.domain.Vegetable;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.Optional;

public interface VegetableRepository extends JpaRepository<Vegetable, Long>, VegetableRepositoryCustom{

}
