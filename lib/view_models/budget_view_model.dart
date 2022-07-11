
import 'package:budget_tracker/model/transaction_item.dart';
import 'package:budget_tracker/services/Local_storage_service.dart';
import 'package:flutter/foundation.dart';

class BudgetViewModel extends ChangeNotifier {

  double getBudget() => LocalStorageService().getBudget();

  double getBalance() => LocalStorageService().getBalance();

  List<TransactionItem> get items => LocalStorageService().getAllTransactions();

  set budget(double value){
    LocalStorageService().saveBudget(value);
    notifyListeners();
  }

  void addItem(TransactionItem item){
    LocalStorageService().saveTransactionItem(item);
    notifyListeners();
  }

  
  

}