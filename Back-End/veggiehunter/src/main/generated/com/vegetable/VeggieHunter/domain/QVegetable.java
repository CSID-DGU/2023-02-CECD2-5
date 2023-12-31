package com.vegetable.veggiehunter.domain;

import static com.querydsl.core.types.PathMetadataFactory.*;

import com.querydsl.core.types.dsl.*;

import com.querydsl.core.types.PathMetadata;
import javax.annotation.processing.Generated;
import com.querydsl.core.types.Path;


/**
 * QVegetable is a Querydsl query type for Vegetable
 */
@Generated("com.querydsl.codegen.DefaultEntitySerializer")
public class QVegetable extends EntityPathBase<Vegetable> {

    private static final long serialVersionUID = 252166656L;

    public static final QVegetable vegetable = new QVegetable("vegetable");

    public final NumberPath<Long> id = createNumber("id", Long.class);

    public final StringPath image = createString("image");

    public final StringPath name = createString("name");

    public final StringPath storageMethod = createString("storageMethod");

    public QVegetable(String variable) {
        super(Vegetable.class, forVariable(variable));
    }

    public QVegetable(Path<? extends Vegetable> path) {
        super(path.getType(), path.getMetadata());
    }

    public QVegetable(PathMetadata metadata) {
        super(Vegetable.class, metadata);
    }

}

