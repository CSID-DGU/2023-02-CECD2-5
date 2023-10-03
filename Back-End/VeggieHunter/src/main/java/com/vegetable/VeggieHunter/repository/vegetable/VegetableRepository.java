package com.vegetable.VeggieHunter.repository.vegetable;

import com.vegetable.VeggieHunter.domain.Vegetable;
import org.springframework.data.jpa.repository.JpaRepository;

public interface VegetableRepository extends JpaRepository<Vegetable, Long>, VegetableRepositoryCustom {
}
