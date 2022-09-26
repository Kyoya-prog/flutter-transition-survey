import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Modal Sheet Transition Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Center(
        child: ElevatedButton(
          onPressed: () => showAppModalBottomSheet(
            context: context,
            builder: (context) => const AppDraggableScrollableNavigatorSheet(
                child: const ModalPage()),
          ),
          child: const Text('Show modal'),
        ),
      ),
    );
  }
}

class ModalPage extends StatelessWidget {
  const ModalPage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.of(context, rootNavigator: true).pop(),
          icon: const Icon(Icons.close),
        ),
        title: const Text('Modal'),
      ),
      body: Container(
          color: Colors.red,
          child: Center(
            child: ElevatedButton(
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const ModalDetailPage(),
                ),
              ),
              child: const Text('Go to Detail'),
            ),
          )),
    );
  }
}

class ModalDetailPage extends StatelessWidget {
  const ModalDetailPage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Modal Detail'),
        actions: [
          IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(Icons.close),
          ),
        ],
      ),
      body: Container(
        color: Colors.green,
        child: const Center(
          child: Text(
            'Detail Page',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}

Future<T?> showAppModalBottomSheet<T>({
  required BuildContext context,
  required WidgetBuilder builder,
}) =>
    showModalBottomSheet(
        backgroundColor: Theme.of(context).backgroundColor,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16.0),
            topRight: Radius.circular(16.0),
          ),
        ),
        context: context,
        isScrollControlled: true,
        useRootNavigator: true,
        builder: builder);

class AppDraggableScrollableNavigatorSheet extends StatelessWidget {
  const AppDraggableScrollableNavigatorSheet({required this.child, Key? key})
      : super(key: key);

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
        initialChildSize:
            (MediaQuery.of(context).size.height - kToolbarHeight) /
                MediaQuery.of(context).size.height,
        maxChildSize: (MediaQuery.of(context).size.height - kToolbarHeight) /
            MediaQuery.of(context).size.height,
        expand: false,
        builder: (context, scrollController) {
          return ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16.0),
                topRight: Radius.circular(16.0),
              ),
              child: NavigatorPage(navigatorKey: GlobalKey(), child: child));
        });
  }
}

class NavigatorPage extends HookConsumerWidget {
  const NavigatorPage({
    Key? key,
    required this.child,
    required this.navigatorKey,
  }) : super(key: key);

  final Widget child;
  final GlobalKey navigatorKey;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Navigator(
      key: navigatorKey,
      onGenerateRoute: (RouteSettings settings) {
        return MaterialPageRoute(
          settings: settings,
          builder: (context) => child,
        );
      },
    );
  }
}
