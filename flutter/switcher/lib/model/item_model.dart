import 'package:ditto_live/ditto_live.dart';

class Item {
  final String id;
  final String detail;
  final List<String> subitems;

  Item({required this.id, required this.detail, required this.subitems});

  static Item fromDitto(QueryResultItem item) {
    return Item(
      id: item.value['_id'],
      detail: item.value['detail'],
      subitems: List<String>.from(item.value['subitems']),
    );
  }

  //// For Ditto Document
  Map<String, dynamic> value() {
    return {
      '_id': id, // Ditto Document ID requires the underscore prefix (`_`).
      'detail': detail,
      'subitems': subitems,
    };
  }
}
