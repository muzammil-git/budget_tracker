import 'package:budget_tracker/model/transaction_item.dart';
import 'package:budget_tracker/view_models/budget_view_model.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);
  // List<TransactionItem> items = [];

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    // print("Home Page");
    
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context){
              return AddTransactionDialog(
                  itemToAdd: (transactionItem){
                    final budgetService = Provider.of<BudgetViewModel>(context, listen: false);
                    budgetService.addItem(transactionItem);
                    // setState(() {
                    // items.add(transactionItem);
                    // });
                  },
              );
            } 
          );
        },
        child: const Icon(Icons.add),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: SizedBox(
            width: screenSize.width,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Align(
                  alignment: Alignment.topCenter,
                  child: Consumer<BudgetViewModel>(                    
                    builder: ((context, value, child) {
                      final balance = value.getBalance();
                      final budget = value.getBudget();
                      double percentage = balance / budget;

                      if(percentage < 0){
                        percentage = 0;
                      }
                      if(percentage > 1){
                        percentage = 1;
                      }

                      return CircularPercentIndicator(
                        radius: screenSize.width / 2,
                        lineWidth: 10.0,
                        percent: percentage,
                        backgroundColor: Colors.white,
                        progressColor: Theme.of(context).colorScheme.primary,
                        center: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "\$" + balance.toString().split('.')[0],
                              style: const TextStyle(
                                fontSize: 48,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            
                            const Text("Balance", style: TextStyle(fontSize: 18)),
                  
                             Text(
                              "Budget: \$" + budget.toString().split('.')[0],
                              style: const TextStyle(
                                fontSize: 10,
                              ),
                            ),
                          ],
                        ),
                      );
                    })
                  ),
                ),
                const SizedBox(
                  height: 35,
                ),
                const Text(
                  "Items",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 10,
                ),
                
                Consumer<BudgetViewModel>(
                  builder: ((context, value, child) {
                    return ListView.builder(
                      shrinkWrap: true,
                      itemCount: value.items.length,
                      itemBuilder: (context, index){
                        return TransactionCard(
                          item: value.items[index],
                        );
                      },
                    );
                  })
                ),
    

                // TransactionCard(
                //   item: TransactionItem(
                //     itemTitle: "Apple Watch", amount: 105.99, isExpense: false
                //   ),
                // ),
    
                // TransactionCard(
                //   item: TransactionItem(
                //     itemTitle: "Apple iPhone", amount: 800,
                //   ),
                // ),
    
                // TransactionCard(
                //   item: TransactionItem(
                //     itemTitle: "Apple Earbuds", amount: 5.99, isExpense: false
                //   ),
                // ),
    
                // TransactionCard(
                //   item: TransactionItem(
                //     itemTitle: "Apple Charger", amount: 5.99, isExpense: true
                //   ),
                // ),
    
                // TransactionCard(
                //   item: TransactionItem(
                //     itemTitle: "Apple Shirt", amount: 5.99, isExpense: true
                //   ),
                // ),
    
                // TransactionCard(
                //   item: TransactionItem(
                //     itemTitle: "Apple Eyes", amount: 5.99, isExpense: true
                //   ),
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class AddTransactionDialog extends StatefulWidget {
  final Function(TransactionItem) itemToAdd;
  const AddTransactionDialog({required this.itemToAdd, Key? key }) : super(key: key);

  @override
  State<AddTransactionDialog> createState() => _AddTransactionDialogState();
}

class _AddTransactionDialogState extends State<AddTransactionDialog> {

  var itemTitleController = TextEditingController();
  var amountController = TextEditingController();

  bool isExpenseController = true;

  @override
  Widget build(BuildContext context) {

    var width = MediaQuery.of(context).size.width / 1.3;

    return Dialog(
      child: SizedBox(
        width: width,
        height: 300,
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            children: [
              Text(
                "Add an expense", 
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(height: 15,),

              TextField(
                controller: itemTitleController,
                decoration: InputDecoration(
                  hintText: 'Name of expense'
                ), 
              ),

               TextField(
                controller: amountController,
                decoration: InputDecoration(
                  hintText: 'Amount'
                ), 
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Is expense?"),
                  Switch.adaptive(
                    value: isExpenseController,
                    onChanged: (val){
                      setState(() {
                        isExpenseController = val;
                      });
                    },
                  )
                ],
              ),
              SizedBox(
                height: 15,
              ),

              ElevatedButton(
                onPressed: (){
                  if(itemTitleController.text.isNotEmpty &&
                    amountController.text.isNotEmpty){
                      widget.itemToAdd(
                        TransactionItem(
                          itemTitle: itemTitleController.text,
                          amount: double.parse(amountController.text),
                          isExpense: isExpenseController,
                        ));
                      Navigator.pop(context);

                  }
                }, 
                child: Text("Add"),
                
              )

            ],
          ),
        ),
      ),
    );
  }
}

class TransactionCard extends StatelessWidget {

  final TransactionItem item;

  const TransactionCard(
      {required this.item,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(15),
      margin: const EdgeInsets.symmetric(vertical: 05),
      decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.background,
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              offset: const Offset(0, 25),
              blurRadius: 50,
            )
          ]),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "${item.itemTitle}",
            style: const TextStyle(
              fontSize: 18,
            ),
          ),
          Text(
            (item.isExpense ? "-" : "+") + " ${item.amount}",
            style: const TextStyle(
              fontSize: 16,
            ),
          )
        ],
      ),
    );
  }
}
