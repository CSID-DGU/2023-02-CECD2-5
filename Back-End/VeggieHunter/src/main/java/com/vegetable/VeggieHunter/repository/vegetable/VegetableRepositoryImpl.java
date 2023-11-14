package com.vegetable.veggiehunter.repository.vegetable;

import com.querydsl.core.types.Expression;
import com.querydsl.core.types.Projections;
import com.querydsl.core.types.dsl.Expressions;
import com.querydsl.core.types.dsl.PathBuilder;
import com.querydsl.jpa.JPAExpressions;
import com.querydsl.jpa.impl.JPAQueryFactory;
import com.vegetable.veggiehunter.domain.Price;
import com.vegetable.veggiehunter.domain.Vegetable;
import com.vegetable.veggiehunter.dto.response.likes.VegetableLikesListResponse;
import com.vegetable.veggiehunter.dto.response.vegetable.VegetableGraphResponse;
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
                                vegetable.id,
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

    @Override
    public List<VegetableListResponse> getVegetableList(List<Long> vegetableIdList) {
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
                                vegetable.id,
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
                .where(vegetable.id.in(vegetableIdList))
                .leftJoin(price1).on(price1.unit.eq(vegetable.main_unit)
                        .and(price1.createdDate.eq(mostRecentDate))
                        .and(price1.name.eq(vegetable.name)))
                .groupBy(vegetable.name, vegetable.image, vegetable.main_unit)
                .fetch();
    }

    @Override
    public List<VegetableLikesListResponse> getVegetableLikesList(List<Long> vegetableIdList) {
        LocalDate mostRecentDate = queryFactory
                .select(price1.createdDate.max())
                .from(price1)
                .fetchOne();

        // 가장 최근 날짜의 어제 날짜 계산
        LocalDate yesterdayOfMostRecentDate = mostRecentDate.minusDays(1);
        Boolean isLikes = true;

        return queryFactory
                .select(
                        Projections.constructor(
                                VegetableLikesListResponse.class,
                                vegetable.id,
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
                                ),
                                Expressions.constant(isLikes)
                        )
                )
                .from(vegetable)
                .where(vegetable.id.in(vegetableIdList))
                .leftJoin(price1).on(price1.unit.eq(vegetable.main_unit)
                        .and(price1.createdDate.eq(mostRecentDate))
                        .and(price1.name.eq(vegetable.name)))
                .groupBy(vegetable.name, vegetable.image, vegetable.main_unit)
                .fetch();
    }

    @Override
    public List<VegetableGraphResponse> getVegetableGraphList(Long vegetableId) {
        String vegetableName = queryFactory
                .select(vegetable.name)
                .from(vegetable)
                .where(vegetable.id.eq(vegetableId))
                .fetchOne();

        LocalDate recentDate = queryFactory
                .select(price1.createdDate.max())
                .from(price1)
                .fetchOne();

        return queryFactory
                .select(Projections.constructor(
                        VegetableGraphResponse.class,
                        price1.unit,
                        price1.createdDate,
                        price1.price.avg()
                ))
                .from(price1)
                .where(price1.name.eq(vegetableName)
                        .and(price1.createdDate.between(recentDate.minusDays(6), recentDate)))
                .groupBy(price1.name, price1.unit, price1.createdDate)
                .fetch();
    }
}
