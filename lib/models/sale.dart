import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

part 'sale.g.dart';
@HiveType(typeId: 0)
class Sale {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String itemName;
  @HiveField(2)
  final double amount;
  @HiveField(3)
  final DateTime timestamp;
  @HiveField(4)
  final bool isSynced;

  Sale({
    String? id,
    required this.itemName,
    required this.amount,
    required this.timestamp,
    this.isSynced = false,
  }) : id = id ?? const Uuid().v4();
}
