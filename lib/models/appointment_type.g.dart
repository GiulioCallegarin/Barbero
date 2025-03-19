// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'appointment_type.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetAppointmentTypeCollection on Isar {
  IsarCollection<AppointmentType> get appointmentTypes => this.collection();
}

const AppointmentTypeSchema = CollectionSchema(
  name: r'AppointmentType',
  id: 3160690230052170441,
  properties: {
    r'defaultDuration': PropertySchema(
      id: 0,
      name: r'defaultDuration',
      type: IsarType.long,
    ),
    r'defaultPrice': PropertySchema(
      id: 1,
      name: r'defaultPrice',
      type: IsarType.double,
    ),
    r'name': PropertySchema(
      id: 2,
      name: r'name',
      type: IsarType.string,
    )
  },
  estimateSize: _appointmentTypeEstimateSize,
  serialize: _appointmentTypeSerialize,
  deserialize: _appointmentTypeDeserialize,
  deserializeProp: _appointmentTypeDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {},
  getId: _appointmentTypeGetId,
  getLinks: _appointmentTypeGetLinks,
  attach: _appointmentTypeAttach,
  version: '3.1.0+1',
);

int _appointmentTypeEstimateSize(
  AppointmentType object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.name.length * 3;
  return bytesCount;
}

void _appointmentTypeSerialize(
  AppointmentType object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeLong(offsets[0], object.defaultDuration);
  writer.writeDouble(offsets[1], object.defaultPrice);
  writer.writeString(offsets[2], object.name);
}

AppointmentType _appointmentTypeDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = AppointmentType();
  object.defaultDuration = reader.readLong(offsets[0]);
  object.defaultPrice = reader.readDouble(offsets[1]);
  object.id = id;
  object.name = reader.readString(offsets[2]);
  return object;
}

P _appointmentTypeDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readLong(offset)) as P;
    case 1:
      return (reader.readDouble(offset)) as P;
    case 2:
      return (reader.readString(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _appointmentTypeGetId(AppointmentType object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _appointmentTypeGetLinks(AppointmentType object) {
  return [];
}

void _appointmentTypeAttach(
    IsarCollection<dynamic> col, Id id, AppointmentType object) {
  object.id = id;
}

extension AppointmentTypeQueryWhereSort
    on QueryBuilder<AppointmentType, AppointmentType, QWhere> {
  QueryBuilder<AppointmentType, AppointmentType, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension AppointmentTypeQueryWhere
    on QueryBuilder<AppointmentType, AppointmentType, QWhereClause> {
  QueryBuilder<AppointmentType, AppointmentType, QAfterWhereClause> idEqualTo(
      Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<AppointmentType, AppointmentType, QAfterWhereClause>
      idNotEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<AppointmentType, AppointmentType, QAfterWhereClause>
      idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<AppointmentType, AppointmentType, QAfterWhereClause> idLessThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<AppointmentType, AppointmentType, QAfterWhereClause> idBetween(
    Id lowerId,
    Id upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: lowerId,
        includeLower: includeLower,
        upper: upperId,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension AppointmentTypeQueryFilter
    on QueryBuilder<AppointmentType, AppointmentType, QFilterCondition> {
  QueryBuilder<AppointmentType, AppointmentType, QAfterFilterCondition>
      defaultDurationEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'defaultDuration',
        value: value,
      ));
    });
  }

  QueryBuilder<AppointmentType, AppointmentType, QAfterFilterCondition>
      defaultDurationGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'defaultDuration',
        value: value,
      ));
    });
  }

  QueryBuilder<AppointmentType, AppointmentType, QAfterFilterCondition>
      defaultDurationLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'defaultDuration',
        value: value,
      ));
    });
  }

  QueryBuilder<AppointmentType, AppointmentType, QAfterFilterCondition>
      defaultDurationBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'defaultDuration',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<AppointmentType, AppointmentType, QAfterFilterCondition>
      defaultPriceEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'defaultPrice',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<AppointmentType, AppointmentType, QAfterFilterCondition>
      defaultPriceGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'defaultPrice',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<AppointmentType, AppointmentType, QAfterFilterCondition>
      defaultPriceLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'defaultPrice',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<AppointmentType, AppointmentType, QAfterFilterCondition>
      defaultPriceBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'defaultPrice',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<AppointmentType, AppointmentType, QAfterFilterCondition>
      idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<AppointmentType, AppointmentType, QAfterFilterCondition>
      idGreaterThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<AppointmentType, AppointmentType, QAfterFilterCondition>
      idLessThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<AppointmentType, AppointmentType, QAfterFilterCondition>
      idBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'id',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<AppointmentType, AppointmentType, QAfterFilterCondition>
      nameEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AppointmentType, AppointmentType, QAfterFilterCondition>
      nameGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AppointmentType, AppointmentType, QAfterFilterCondition>
      nameLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AppointmentType, AppointmentType, QAfterFilterCondition>
      nameBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'name',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AppointmentType, AppointmentType, QAfterFilterCondition>
      nameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AppointmentType, AppointmentType, QAfterFilterCondition>
      nameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AppointmentType, AppointmentType, QAfterFilterCondition>
      nameContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AppointmentType, AppointmentType, QAfterFilterCondition>
      nameMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'name',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AppointmentType, AppointmentType, QAfterFilterCondition>
      nameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'name',
        value: '',
      ));
    });
  }

  QueryBuilder<AppointmentType, AppointmentType, QAfterFilterCondition>
      nameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'name',
        value: '',
      ));
    });
  }
}

extension AppointmentTypeQueryObject
    on QueryBuilder<AppointmentType, AppointmentType, QFilterCondition> {}

extension AppointmentTypeQueryLinks
    on QueryBuilder<AppointmentType, AppointmentType, QFilterCondition> {}

extension AppointmentTypeQuerySortBy
    on QueryBuilder<AppointmentType, AppointmentType, QSortBy> {
  QueryBuilder<AppointmentType, AppointmentType, QAfterSortBy>
      sortByDefaultDuration() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'defaultDuration', Sort.asc);
    });
  }

  QueryBuilder<AppointmentType, AppointmentType, QAfterSortBy>
      sortByDefaultDurationDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'defaultDuration', Sort.desc);
    });
  }

  QueryBuilder<AppointmentType, AppointmentType, QAfterSortBy>
      sortByDefaultPrice() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'defaultPrice', Sort.asc);
    });
  }

  QueryBuilder<AppointmentType, AppointmentType, QAfterSortBy>
      sortByDefaultPriceDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'defaultPrice', Sort.desc);
    });
  }

  QueryBuilder<AppointmentType, AppointmentType, QAfterSortBy> sortByName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.asc);
    });
  }

  QueryBuilder<AppointmentType, AppointmentType, QAfterSortBy>
      sortByNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.desc);
    });
  }
}

extension AppointmentTypeQuerySortThenBy
    on QueryBuilder<AppointmentType, AppointmentType, QSortThenBy> {
  QueryBuilder<AppointmentType, AppointmentType, QAfterSortBy>
      thenByDefaultDuration() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'defaultDuration', Sort.asc);
    });
  }

  QueryBuilder<AppointmentType, AppointmentType, QAfterSortBy>
      thenByDefaultDurationDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'defaultDuration', Sort.desc);
    });
  }

  QueryBuilder<AppointmentType, AppointmentType, QAfterSortBy>
      thenByDefaultPrice() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'defaultPrice', Sort.asc);
    });
  }

  QueryBuilder<AppointmentType, AppointmentType, QAfterSortBy>
      thenByDefaultPriceDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'defaultPrice', Sort.desc);
    });
  }

  QueryBuilder<AppointmentType, AppointmentType, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<AppointmentType, AppointmentType, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<AppointmentType, AppointmentType, QAfterSortBy> thenByName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.asc);
    });
  }

  QueryBuilder<AppointmentType, AppointmentType, QAfterSortBy>
      thenByNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.desc);
    });
  }
}

extension AppointmentTypeQueryWhereDistinct
    on QueryBuilder<AppointmentType, AppointmentType, QDistinct> {
  QueryBuilder<AppointmentType, AppointmentType, QDistinct>
      distinctByDefaultDuration() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'defaultDuration');
    });
  }

  QueryBuilder<AppointmentType, AppointmentType, QDistinct>
      distinctByDefaultPrice() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'defaultPrice');
    });
  }

  QueryBuilder<AppointmentType, AppointmentType, QDistinct> distinctByName(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'name', caseSensitive: caseSensitive);
    });
  }
}

extension AppointmentTypeQueryProperty
    on QueryBuilder<AppointmentType, AppointmentType, QQueryProperty> {
  QueryBuilder<AppointmentType, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<AppointmentType, int, QQueryOperations>
      defaultDurationProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'defaultDuration');
    });
  }

  QueryBuilder<AppointmentType, double, QQueryOperations>
      defaultPriceProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'defaultPrice');
    });
  }

  QueryBuilder<AppointmentType, String, QQueryOperations> nameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'name');
    });
  }
}
