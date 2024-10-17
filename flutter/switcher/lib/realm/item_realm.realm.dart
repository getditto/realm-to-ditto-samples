// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'item_realm.dart';

// **************************************************************************
// RealmObjectGenerator
// **************************************************************************

// ignore_for_file: type=lint
class ItemRealm extends _ItemRealm
    with RealmEntity, RealmObjectBase, RealmObject {
  ItemRealm(
    String id,
    String detail, {
    Iterable<String> subitems = const [],
  }) {
    RealmObjectBase.set(this, 'id', id);
    RealmObjectBase.set(this, 'detail', detail);
    RealmObjectBase.set<RealmList<String>>(
        this, 'subitems', RealmList<String>(subitems));
  }

  ItemRealm._();

  @override
  String get id => RealmObjectBase.get<String>(this, 'id') as String;
  @override
  set id(String value) => RealmObjectBase.set(this, 'id', value);

  @override
  String get detail => RealmObjectBase.get<String>(this, 'detail') as String;
  @override
  set detail(String value) => RealmObjectBase.set(this, 'detail', value);

  @override
  RealmList<String> get subitems =>
      RealmObjectBase.get<String>(this, 'subitems') as RealmList<String>;
  @override
  set subitems(covariant RealmList<String> value) =>
      throw RealmUnsupportedSetError();

  @override
  Stream<RealmObjectChanges<ItemRealm>> get changes =>
      RealmObjectBase.getChanges<ItemRealm>(this);

  @override
  Stream<RealmObjectChanges<ItemRealm>> changesFor([List<String>? keyPaths]) =>
      RealmObjectBase.getChangesFor<ItemRealm>(this, keyPaths);

  @override
  ItemRealm freeze() => RealmObjectBase.freezeObject<ItemRealm>(this);

  EJsonValue toEJson() {
    return <String, dynamic>{
      'id': id.toEJson(),
      'detail': detail.toEJson(),
      'subitems': subitems.toEJson(),
    };
  }

  static EJsonValue _toEJson(ItemRealm value) => value.toEJson();
  static ItemRealm _fromEJson(EJsonValue ejson) {
    if (ejson is! Map<String, dynamic>) return raiseInvalidEJson(ejson);
    return switch (ejson) {
      {
        'id': EJsonValue id,
        'detail': EJsonValue detail,
      } =>
        ItemRealm(
          fromEJson(id),
          fromEJson(detail),
          subitems: fromEJson(ejson['subitems']),
        ),
      _ => raiseInvalidEJson(ejson),
    };
  }

  static final schema = () {
    RealmObjectBase.registerFactory(ItemRealm._);
    register(_toEJson, _fromEJson);
    return const SchemaObject(ObjectType.realmObject, ItemRealm, 'ItemRealm', [
      SchemaProperty('id', RealmPropertyType.string, primaryKey: true),
      SchemaProperty('detail', RealmPropertyType.string),
      SchemaProperty('subitems', RealmPropertyType.string,
          collectionType: RealmCollectionType.list),
    ]);
  }();

  @override
  SchemaObject get objectSchema => RealmObjectBase.getSchema(this) ?? schema;
}
