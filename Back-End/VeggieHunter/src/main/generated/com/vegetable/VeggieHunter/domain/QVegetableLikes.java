package com.vegetable.VeggieHunter.domain;

import static com.querydsl.core.types.PathMetadataFactory.*;

import com.querydsl.core.types.dsl.*;

import com.querydsl.core.types.PathMetadata;
import javax.annotation.processing.Generated;
import com.querydsl.core.types.Path;
import com.querydsl.core.types.dsl.PathInits;


/**
 * QVegetableLikes is a Querydsl query type for VegetableLikes
 */
@Generated("com.querydsl.codegen.DefaultEntitySerializer")
public class QVegetableLikes extends EntityPathBase<VegetableLikes> {

    private static final long serialVersionUID = -1882693156L;

    private static final PathInits INITS = PathInits.DIRECT2;

    public static final QVegetableLikes vegetableLikes = new QVegetableLikes("vegetableLikes");

    public final NumberPath<Long> id = createNumber("id", Long.class);

    public final QUser user;

    public final QVegetable vegetable;

    public QVegetableLikes(String variable) {
        this(VegetableLikes.class, forVariable(variable), INITS);
    }

    public QVegetableLikes(Path<? extends VegetableLikes> path) {
        this(path.getType(), path.getMetadata(), PathInits.getFor(path.getMetadata(), INITS));
    }

    public QVegetableLikes(PathMetadata metadata) {
        this(metadata, PathInits.getFor(metadata, INITS));
    }

    public QVegetableLikes(PathMetadata metadata, PathInits inits) {
        this(VegetableLikes.class, metadata, inits);
    }

    public QVegetableLikes(Class<? extends VegetableLikes> type, PathMetadata metadata, PathInits inits) {
        super(type, metadata, inits);
        this.user = inits.isInitialized("user") ? new QUser(forProperty("user")) : null;
        this.vegetable = inits.isInitialized("vegetable") ? new QVegetable(forProperty("vegetable")) : null;
    }

}

