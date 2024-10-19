import 'dart:io';
import 'package:ditto_live/ditto_live.dart';
import 'package:permission_handler/permission_handler.dart';
import '../model/item_model.dart';
import 'package:path_provider/path_provider.dart';

class DittoManager {
  late Ditto ditto;
  StoreObserver? storeObserver;
  List<Item> items = [];

  final collectionName = "items";

  DittoManager() {
    _initialize();
  }

  Future<void> _initialize() async {
    await _setupPermissions();
    await _setupDitto();
  }

  _setupPermissions() async {
	  await [
      Permission.bluetoothConnect,
      Permission.bluetoothAdvertise,
      Permission.nearbyWifiDevices,
      Permission.bluetoothScan
    ].request();
  }

  _setupDitto() async {
    //// ⚠️ You can get your own App ID and Token from https://portal.ditto.live
    const appID = "<Your_Ditto_App_ID>";
    const token = "<Your_Ditto_Token>";

    final identity = await OnlinePlaygroundIdentity.create(appID: appID, token: token);
    final directory = await getApplicationDocumentsDirectory();
    final dittoDirectory = Directory('${directory.path}/ditto');
    if (!dittoDirectory.existsSync()) {
      dittoDirectory.createSync(recursive: true);
    }
    ditto = await Ditto.open(identity: identity, persistenceDirectory: directory);

    // Sync with other peers
    await ditto.startSync();
    _subscribe();
  }

  _subscribe() {
    final query = "SELECT * FROM COLLECTION $collectionName";
    ditto.sync.registerSubscription(query);
  }

  Stream<List<Item>> watchItems() {
    final query = "SELECT * FROM COLLECTION $collectionName";
    return Stream.fromFuture(ditto.store.registerObserver(query)).asyncExpand((observer) {
      storeObserver?.cancel();
      storeObserver = observer;
      return observer.changes.map((result) {
        items = result.items.map((item) => Item.fromDitto(item)).toList();
        return items;
      });
    });
  }

  addItem(Item item) {
    final query = """
      INSERT INTO COLLECTION $collectionName
      DOCUMENTS (:newItem)
      ON ID CONFLICT DO UPDATE
    """;
    ditto.store.execute(query, arguments: {"newItem": item.value()});
  }
}
