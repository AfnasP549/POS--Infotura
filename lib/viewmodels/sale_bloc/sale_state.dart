part of 'sale_bloc.dart';

@immutable
sealed class SaleState {}

final class SaleInitial extends SaleState {}

class SaleLoading extends SaleState {}

class SalesSuccess extends SaleState{}

class SalesLoaded extends SaleState{
  final List<Sale> sales;
  SalesLoaded(this.sales);
} 

class SaleError extends SaleState{
  final String message;
  SaleError(this.message);
} 
