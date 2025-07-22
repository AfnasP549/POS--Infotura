import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pos/views/attendance_screen.dart';
import 'package:pos/views/sales_list_screen.dart';
import '../viewmodels/sale_bloc/sale_bloc.dart';

class BillingScreen extends StatefulWidget {
  const BillingScreen({super.key});

  @override
  _BillingScreenState createState() => _BillingScreenState();
}

class _BillingScreenState extends State<BillingScreen> {
  final _itemController = TextEditingController();
  final _amountController = TextEditingController();

  @override
  void dispose() {
    _itemController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Billing Entry'), centerTitle: true),
      body: BlocListener<SaleBloc, SaleState>(
        listener: (context, state) {
          if (state is SalesSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Sale added successfully')),
            );
            _itemController.clear();
            _amountController.clear();
          } else if (state is SaleError) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message)));
          }
        },
        child: SafeArea(
          child: GestureDetector(
            onTap: () {
              FocusScope.of(context).unfocus();
            },
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 40),
                      Image.asset('assets/home_image.png'),
                      const SizedBox(height: 20),
                      //field for item
                      TextFormField(
                        decoration: const InputDecoration(
                          labelText: 'Item Name',
                        ),
                        controller: _itemController,
                      ),
                      const SizedBox(height: 16),
                      //field for the amount
                      TextFormField(
                        decoration: const InputDecoration(labelText: 'Amount'),
                        controller: _amountController,
                        keyboardType: TextInputType.number,
                      ),
                      const SizedBox(height: 20),
                      //Button for the add sale
                      ElevatedButton(
                        onPressed: () {
                          if (_itemController.text.isNotEmpty &&
                              _amountController.text.isNotEmpty) {
                            context.read<SaleBloc>().add(
                              AddSale(
                                _itemController.text,
                                double.parse(_amountController.text),
                              ),
                            );
                            _itemController.clear();
                            _amountController.clear();
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Sale added successfully'),
                              ),
                            );
                          }
                        },
                        child: const Text('Add Sale'),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          //button for the sales list
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const SalesListScreen(),
                                  ),
                                );
                              },
                              child: const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.list),
                                  Text('Sales List'),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            //Button for the attendance
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const AttendanceScreen(),
                                  ),
                                );
                              },
                              child: const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.person),
                                  Text('Attendance'),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
