import 'package:hive_flutter/hive_flutter.dart';
part 'data.g.dart';

@HiveType(typeId: 0)
class Deposit extends HiveObject {
  @HiveField(0)
  String name = '';
  @HiveField(1)
  String category = '';
  @HiveField(2)
  double count = 0;
  @HiveField(3)
  bool isSelectedToDelete = false;
}
