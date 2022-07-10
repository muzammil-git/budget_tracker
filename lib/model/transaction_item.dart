class TransactionItem{
        // text: "Apple Watch", amount: 105.99, isExpense: false),

    late String itemTitle;
    late double amount;
    late bool isExpense;

    TransactionItem(
      {required this.itemTitle, required this.amount, this.isExpense=true}
    );




}