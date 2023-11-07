package com.vegetable.veggiehunter.repository.vegetable;

import com.querydsl.core.types.Projections;
import com.querydsl.core.types.dsl.Expressions;
import com.querydsl.core.types.dsl.PathBuilder;
import com.querydsl.jpa.JPAExpressions;
import com.querydsl.jpa.impl.JPAQueryFactory;
import com.vegetable.veggiehunter.domain.Price;
import com.vegetable.veggiehunter.domain.Vegetable;
import com.vegetable.veggiehunter.dto.response.vegetable.VegetableListResponse;

import javax.persistence.EntityManager;
import java.time.LocalDate;
import java.util.List;

import static com.vegetable.veggiehunter.domain.QPrice.price1;
import static com.vegetable.veggiehunter.domain.QVegetable.vegetable;

public class VegetableRepositoryImpl implements VegetableRepositoryCustom {

    private JPAQueryFactory queryFactory;

    public VegetableRepositoryImpl(EntityManager em) {
        this.queryFactory = new JPAQueryFactory(em);
    }

    @Override
    public List<VegetableListResponse> getVegetableList() {
        // 데이터 중 가장 최근 날짜 조회
        LocalDate mostRecentDate = queryFactory
                .select(price1.createdDate.max())
                .from(price1)
                .fetchOne();

        // 가장 최근 날짜의 어제 날짜 계산
        LocalDate yesterdayOfMostRecentDate = mostRecentDate.minusDays(1);
        System.out.println(mostRecentDate);
        System.out.println(yesterdayOfMostRecentDate);

        return queryFactory
                .select(
                        Projections.constructor(
                                VegetableListResponse.class,
                                vegetable.name,
                                vegetable.image,
                                vegetable.main_unit,
                                price1.price.avg(),
                                Expressions.numberTemplate(Double.class,
                                        "({0} - coalesce({1}, 0)) / coalesce({1}, 1)",
                                        price1.price.avg(),
                                        JPAExpressions
                                                .select(price1.price.avg())
                                                .from(price1)
                                                .where(price1.unit.eq(vegetable.main_unit)
                                                        .and(price1.createdDate.eq(yesterdayOfMostRecentDate))
                                                        .and(price1.name.eq(vegetable.name)))
                                )
                        )
                )
                .from(vegetable)
                .leftJoin(price1).on(price1.unit.eq(vegetable.main_unit)
                        .and(price1.createdDate.eq(mostRecentDate))
                        .and(price1.name.eq(vegetable.name)))
                .groupBy(vegetable.name, vegetable.image, vegetable.main_unit)
                .fetch();
    }
}
