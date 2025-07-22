import 'dart:developer';

import 'package:hive/hive.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pos/models/sale.dart';

class DatabaseService {
  final Box<Sale> _saleBox = Hive.box<Sale>('sales');
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  //! Add a sale to Hive database
  Future<void> addSale(Sale sale) async {
    log(
      'Adding sale to Hive: ${sale.id}, ${sale.itemName}, ${sale.amount}, ${sale.timestamp}',
    );
    await _saleBox.put(sale.id, sale);
  }

  //! Synchronizes unsynced sales from Hive database to Firebase Firestore.
  Future<void> syncSales() async {
    log('Syncing sales to Firebase');
    for (var sale in _saleBox.values.where((sale) => !sale.isSynced)) {
      log(
        'Syncing sale: ${sale.id}, ${sale.itemName}, ${sale.amount}, ${sale.timestamp}',
      );
      await _firestore.collection('sales').doc(sale.id).set({
        'itemName': sale.itemName,
        'amount': sale.amount,
        'timestamp': sale.timestamp,
      });
      await _saleBox.put(
        sale.id,
        Sale(
          id: sale.id,
          itemName: sale.itemName,
          amount: sale.amount,
          timestamp: sale.timestamp,
          isSynced: true,
        ),
      );
      log('Synced sale: ${sale.id}');
    }
    log('Sync completed');
  }

  //!Fetching datas from firebase
  Future<List<Sale>> getSales() async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection('sales')
          .orderBy('timestamp', descending: false)
          .get();
      List<Sale> remoteSales = snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        log(
          'Fetched sale: ${doc.id}, ${data['itemName']}, ${data['amount']}, ${data['timestamp']}',
        );
        return Sale(
          id: doc.id,
          itemName: data['itemName'],
          amount: data['amount'],
          timestamp: (data['timestamp'] as Timestamp).toDate(),
          isSynced: true,
        );
      }).toList();
      log('Fetched ${remoteSales.length} sales from Firebase');
      return remoteSales;
    } catch (e) {
      log('Error fetching sales from Firebase: $e');
      return [];
    }
  }

  Future<void> markAttendance(DateTime timestamp) async {
    log('Marking attendance: $timestamp');
    await _firestore.collection('attendance').add({'timestamp': timestamp});
  }
}
