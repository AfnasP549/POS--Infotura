part of 'sale_bloc.dart';

@immutable
sealed class SaleEvent {}

class AddSale extends SaleEvent {
  final String itemName;
  final double amount;

  AddSale(this.itemName, this.amount);
}

class FetchSales extends SaleEvent {}

class SyncSales extends SaleEvent {}
