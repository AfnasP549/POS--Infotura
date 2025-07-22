import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pos/models/sale.dart';
import 'package:pos/utils/date_formatter.dart';
import '../viewmodels/sale_bloc/sale_bloc.dart';

class SalesListScreen extends StatelessWidget {
  const SalesListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    context.read<SaleBloc>().add(FetchSales());
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sales List'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              context.read<SaleBloc>().add(FetchSales());
            },
            tooltip: 'Refresh Sales',
          ),
        ],
      ),
      body: BlocBuilder<SaleBloc, SaleState>(
        builder: (context, state) {
          if (state is SaleLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is SalesLoaded) {
            if (state.sales.isEmpty) {
              return const Center(child: Text('No sales available'));
            }
            return ListView.builder(
              physics: const AlwaysScrollableScrollPhysics(),
              itemCount: state.sales.length,
              itemBuilder: (context, index) {
                Sale sale = state.sales[index];
                String formattedDate = sale.timestamp != null
                    ? DateFormatter.formatDateTime(sale.timestamp)
                    : 'Invalid Date';
                return Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 4.0,
                  ),
                  //card shows the sales details
                  child: Card(
                    child: ListTile(
                      title: Text(sale.itemName),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Amount: ${sale.amount}'),
                          Text('Date and Time:  | $formattedDate'),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          } else if (state is SaleError) {
            return Center(child: Text(state.message));
          }
          return const Center(child: Text('No sales available'));
        },
      ),
    );
  }
}
