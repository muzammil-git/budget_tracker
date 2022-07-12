import 'dart:ffi';

import 'package:budget_tracker/model/transaction_item.dart';
import 'package:hive_flutter/hive_flutter.dart';

class LocalStorageService {

  static final LocalStorageService _instance = LocalStorageService._internal();

  // Factory method lets the class instantiate only once
  // If you tried to instantiate the class again it will assign the first instantiation.
  factory LocalStorageService(){
    return _instance;
  }

  LocalStorageService._internal();

  static const String transactionBoxKey = "transactionBoxKey";
  static const String balanceBoxKey = "balanceBox";
  static const String budgetBoxKey = "budgetBoxKey";


  Future<void> initializeHive() async{
    await Hive.initFlutter();

    if (!Hive.isAdapterRegistered(1)) { // Just to make sure it doesn't initialize twice, it was causing some minor issues without this check
      Hive.registerAdapter(TransactionItemAdapter());
    }

    await Hive.openBox<double>(budgetBoxKey);
    await Hive.openBox<TransactionItem>(transactionBoxKey);
    await Hive.openBox<double>(balanceBoxKey);

  }

  void saveTransactionItem(TransactionItem transaction){
    Hive.box<TransactionItem>(transactionBoxKey).add(transaction);
    saveBalance(transaction); 
  }

  List<TransactionItem> getAllTransactions() {
    return Hive.box<TransactionItem>(transactionBoxKey).values.toList();
  }
  
  Future<void> saveBalance(TransactionItem item) async {

    final balanceBox = Hive.box<double>(balanceBoxKey);
    final currentBalance = balanceBox.get("balance") ?? 0.0;
  
    if(item.isExpense == true){
      balanceBox.put("balance", currentBalance + item.amount);
    } else{
      balanceBox.put("balance", currentBalance - item.amount);
    }

    // balanceBox.put("balance", 0.0);

  }

  double getBalance() {
    final balanceBox = Hive.box<double>(balanceBoxKey).get("balance") ?? 0.0;
    return balanceBox;
  }

  double getBudget() {
    final getBudget = Hive.box<double>(budgetBoxKey).get("budget") ?? 2000.0;
    return getBudget;
  }

  Future<void> saveBudget(double budget){
    return Hive.box<double>(budgetBoxKey).put("budget", budget);
  }

  void deleteTransactionItem(TransactionItem item){
    final transactions = Hive.box<TransactionItem>(transactionBoxKey);

    final map = transactions.toMap();
    // print(map);

    map.forEach((key, value) {
      if (value.itemTitle == item.itemTitle) {
        transactions.delete(key);
        saveBalanceOnDelete(item);
      }
    });
  }

  Future<void> saveBalanceOnDelete(TransactionItem item){
    final balanceBox = Hive.box<double>(balanceBoxKey);
    
    double itemAmount = item.amount;
    double currentBalance = balanceBox.get("balance") ?? 0.0;

    if(item.isExpense == true){
      return balanceBox.put("balance", currentBalance - item.amount);
    } else{
      return balanceBox.put("balance", currentBalance + item.amount);
    }
  }

}