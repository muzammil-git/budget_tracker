import 'package:budget_tracker/screens/home.dart';
import 'package:budget_tracker/services/budget_service.dart';
import 'package:budget_tracker/services/theme_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers:[
        ChangeNotifierProvider<ThemeService>(create: (_) => ThemeService()),
        ChangeNotifierProvider<BudgetService>(create: (_) => BudgetService()),
      ],
      child: Builder(
        builder:(BuildContext context ){
          final themeService = Provider.of<ThemeService>(context);
          return MaterialApp(
            title: 'Fludtter Demo', 
            theme: ThemeData(
              // primarySwatch: Colors.red,
              colorScheme: ColorScheme.fromSeed(
                brightness: themeService.darkTheme
                    ? Brightness.dark 
                    : Brightness.light,
                seedColor: Colors.indigo ,
              )
            ), //
            home: Home(),
          ); 
        }
      )
      ,
    );
  }
}

