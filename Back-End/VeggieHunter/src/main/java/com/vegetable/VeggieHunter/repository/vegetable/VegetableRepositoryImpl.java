package com.vegetable.VeggieHunter.repository.vegetable;

import com.querydsl.core.types.Projections;
import com.querydsl.core.types.dsl.Expressions;
import com.querydsl.jpa.JPAExpressions;
import com.querydsl.jpa.impl.JPAQueryFactory;
import com.vegetable.VeggieHunter.dto.response.vegetable.VegetableListResponse;
import jakarta.persistence.EntityManager;
import static com.vegetable.VeggieHunter.domain.QVegetable.vegetable;
import static com.vegetable.VeggieHunter.domain.QPrice.price1;

import java.time.LocalDateTime;
import java.util.List;

public class VegetableRepositoryImpl implements VegetableRepositoryCustom{
    private JPAQueryFactory queryFactory;

    public VegetableRepositoryImpl(EntityManager em) {
        this.queryFactory = new JPAQueryFactory(em);
    }

    @Override
    public List<VegetableListResponse> getVegetableList() {
        return queryFactory
                .select(
                        Projections.constructor(
                                VegetableListResponse.class,
                                vegetable.name,
                                vegetable.image,
                                JPAExpressions
                                        .select(price1.price.min())
                                        .from(price1)
                                        .where(
                                                price1.vegetable.eq(vegetable)
                                                        .and(price1.createdDate.eq(LocalDateTime.now()))
                                        ),
                                //(오늘날짜의 price 평균값 - 오늘을 제외한 price 평균값) / 오늘날짜의 price 평균값
                                Expressions.numberTemplate(Double.class,
                                        "({0} - {1}) / {0}",
                                        JPAExpressions
                                                .select(price1.price.avg())
                                                .from(price1)
                                                .where(price1.vegetable.eq(vegetable)
                                                        .and(price1.createdDate.eq(LocalDateTime.now()))),
                                        JPAExpressions
                                                .select(price1.price.avg())
                                                .from(price1)
                                                .where(price1.vegetable.eq(vegetable)
                                                        .and(price1.createdDate.ne(LocalDateTime.now())))
                                )
                        )
                )
                .from(vegetable)
                .leftJoin(price1).on(vegetable.id.eq(price1.id))
                .groupBy(vegetable.id)
                .fetch();
    }
}
