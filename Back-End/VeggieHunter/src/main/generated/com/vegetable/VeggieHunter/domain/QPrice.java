package com.vegetable.VeggieHunter.domain;

import static com.querydsl.core.types.PathMetadataFactory.*;

import com.querydsl.core.types.dsl.*;

import com.querydsl.core.types.PathMetadata;
import javax.annotation.processing.Generated;
import com.querydsl.core.types.Path;
import com.querydsl.core.types.dsl.PathInits;


/**
 * QPrice is a Querydsl query type for Price
 */
@Generated("com.querydsl.codegen.DefaultEntitySerializer")
public class QPrice extends EntityPathBase<Price> {

    private static final long serialVersionUID = 1625422440L;

    private static final PathInits INITS = PathInits.DIRECT2;

    public static final QPrice price1 = new QPrice("price1");

    public final QBaseTime _super = new QBaseTime(this);

    //inherited
    public final DateTimePath<java.time.LocalDateTime> createdDate = _super.createdDate;

    public final NumberPath<Long> id = createNumber("id", Long.class);

    public final NumberPath<Double> price = createNumber("price", Double.class);

    public final StringPath unit = createString("unit");

    //inherited
    public final DateTimePath<java.time.LocalDateTime> updatedDate = _super.updatedDate;

    public final QVegetable vegetable;

    public QPrice(String variable) {
        this(Price.class, forVariable(variable), INITS);
    }

    public QPrice(Path<? extends Price> path) {
        this(path.getType(), path.getMetadata(), PathInits.getFor(path.getMetadata(), INITS));
    }

    public QPrice(PathMetadata metadata) {
        this(metadata, PathInits.getFor(metadata, INITS));
    }

    public QPrice(PathMetadata metadata, PathInits inits) {
        this(Price.class, metadata, inits);
    }

    public QPrice(Class<? extends Price> type, PathMetadata metadata, PathInits inits) {
        super(type, metadata, inits);
        this.vegetable = inits.isInitialized("vegetable") ? new QVegetable(forProperty("vegetable")) : null;
    }

}

