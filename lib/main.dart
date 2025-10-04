import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

// MyApp class extends StatelessWidget. Widgets are the elements from which you build every Flutter app.
// MyApp is the class declaration and const MyApp() is the constructor.
// const keyword means the object is created at compile time (instead of runtime)
class MyApp extends StatelessWidget {
  // Passes the key parameter up to the StatelessWidget constructor.
  const MyApp({super.key});

  // As you can see, even the app itself is a widget.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyAppState(), // app wide state
      child: MaterialApp(
        title: 'Namer App', // app name
        theme: ThemeData(
          //visual style
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
        ),
        home: MyHomePage(), // home widget, the starting point of the app
      ),
    );
  }
}

// MyAppState defines the data the app needs to function.
// The state class extends ChangeNotifier, which means that it can notify others about its own changes. For example, if the current word pair changes, some widgets in the app need to know.
// The state is created and provided to the whole app using a ChangeNotifierProvider (see code above in MyApp). This allows any widget in the app to get hold of the state.
class MyAppState extends ChangeNotifier {
  var current = WordPair.random();

  void getNext() {
    current = WordPair.random();
    notifyListeners(); // notify the widgets that depend on this state
  }

  // list of wordpair. WordPair is the data type here
  var favorites = <WordPair>[];

  void toggleFavorite() {
    if (favorites.contains(current)) {
      favorites.remove(current);
    } else {
      favorites.add(current);
    }
    notifyListeners();
  }
}

// Every widget defines a build() method that's automatically called every time the widget's circumstances change so that the widget is always up to date.
class MyHomePage extends StatelessWidget {
  // Every build method must return a widget or (more typically) a nested tree of widgets.
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    var pair = appState.current; // get the current state

    IconData icon;
    if (appState.favorites.contains(pair)) {
      icon = Icons.favorite;
    } else {
      icon = Icons.favorite_border;
    }

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            BigCard(pair: pair),
            SizedBox(height: 10), // create some space between the two cards
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    appState.toggleFavorite();
                  },
                  icon: Icon(icon),
                  label: Text('Like'),
                ),
                SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () {
                    appState.getNext();
                  },
                  child: Text('Next'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class BigCard extends StatelessWidget {
  const BigCard({super.key, required this.pair});

  // Once assigned, the value cannot be changed. (Immutable after construction)
  final WordPair pair;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(
      context,
    ); // get the current theme from the ThemeData in MyApp
    var style = theme.textTheme.displayMedium!.copyWith(
      color: theme.colorScheme.onPrimary,
      fontWeight: FontWeight.bold,
    );

    return Card(
      elevation: 5,
      color: theme.colorScheme.primary,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Text(pair.asLowerCase, style: style),
      ),
    );
  }
}
