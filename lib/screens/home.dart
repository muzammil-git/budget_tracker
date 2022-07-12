import 'package:budget_tracker/pages/home_page.dart';
import 'package:budget_tracker/pages/profile_page.dart';
import 'package:budget_tracker/view_models/budget_view_model.dart';
import 'package:budget_tracker/services/theme_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<BottomNavigationBarItem> bottomNavItems = const [
    BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
    BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
  ];

  int _currentPageIndex = 0; //Current page

  @override
  Widget build(BuildContext context) {
    final themeService = Provider.of<ThemeService>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text("Budget Tracker"),
        centerTitle: true,
        leading: IconButton(
          onPressed: (){
            themeService.darkTheme = !themeService.darkTheme;
          },
          icon: themeService.darkTheme ? Icon(Icons.dark_mode) : Icon(Icons.sunny,),
        ),
        actions: [
          IconButton(
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (context) {
                    return AddBudgetDialog(
                      budgetToadd: (budget){
                        final budgetService = Provider.of<BudgetViewModel>(
                          context,
                          listen: false
                        );
                        budgetService.budget = budget;

                        // print(budget);
                      },
                    );
                  },
              );
            },
            icon: const Icon(Icons.attach_money),
          )
        ],
      ),
      body: pages[_currentPageIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentPageIndex,
        items: bottomNavItems,
        onTap: (index) {
          setState(() {
            _currentPageIndex = index;
          });
        },
      ),
    );
  }

  List<Widget> pages = const [HomePage(), ProfilePage()];
}


class AddBudgetDialog extends StatefulWidget {

  final Function(double) budgetToadd;
  AddBudgetDialog({required this.budgetToadd, Key? key}) : super(key: key);

  @override
  State<AddBudgetDialog> createState() => _AddBudgetDialogState();
}

class _AddBudgetDialogState extends State<AddBudgetDialog> {

  final TextEditingController amountController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: SizedBox(
        width: MediaQuery.of(context).size.width/1.3,
        height: 200,
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            children: [
              const Text("Add a budget", style: TextStyle(fontSize: 18),),
              const SizedBox(height: 15,),
              TextField(
                controller: amountController,
                decoration: const InputDecoration(
                  hintText: "Budget in \$",
                ),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'[0-9]'))            
                ],
              ),

              const SizedBox(height: 20,),

              ElevatedButton(
                onPressed: (){
                  if(amountController.text.isNotEmpty){
                    widget.budgetToadd(double.parse(amountController.text));
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
