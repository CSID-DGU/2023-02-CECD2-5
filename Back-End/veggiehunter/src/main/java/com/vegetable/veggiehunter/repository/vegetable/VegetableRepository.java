package com.vegetable.veggiehunter.repository.vegetable;

import com.vegetable.veggiehunter.domain.Vegetable;
import org.springframework.data.jpa.repository.JpaRepository;

public interface VegetableRepository extends JpaRepository<Vegetable, Long>, VegetableRepositoryCustom{
}
