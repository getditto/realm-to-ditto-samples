import 'package:realm/realm.dart';

part 'item_realm.realm.dart';

@RealmModel()
class _ItemRealm {
  @PrimaryKey()
  late String id;

  late String detail;
  late List<String> subitems;
}