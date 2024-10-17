import 'package:realm/realm.dart';
import './item_realm.dart';
import '../model/item_model.dart';

class RealmManager {
  late final Realm _realm;

  RealmManager() {
    _realm = Realm(Configuration.local([ItemRealm.schema]));
  }

  List<Item> getAllItems() => _realm.all<ItemRealm>().map(_mapRealmToItem).toList();

  Stream<RealmResultsChanges<ItemRealm>> watchItems() => _realm.all<ItemRealm>().changes;

  void addItem(Item item) {
    _realm.write(() {
      _realm.add(ItemRealm(item.id.toString(), item.detail, subitems: item.subitems));
    });
  }

  Item _mapRealmToItem(ItemRealm realmItem) => Item(
    id: realmItem.id,
    detail: realmItem.detail,
    subitems: realmItem.subitems,
  );

  close() {
    _realm.close();
  }
}
