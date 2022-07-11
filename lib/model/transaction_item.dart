import 'package:hive/hive.dart';


part 'package:budget_tracker/model/transaction_item.g.dart'; // Make sure to include this

@HiveType(typeId: 1)
class TransactionItem{
        // text: "Apple Watch", amount: 105.99, isExpense: false),

    @HiveField(0)
    late String itemTitle;
    @HiveField(1)
    late double amount;
    @HiveField(2)
    late bool isExpense;

    TransactionItem(
      {required this.itemTitle, required this.amount, this.isExpense=true}
    );




}