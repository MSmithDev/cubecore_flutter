import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:cubecore_flutter/cubecore.dart';

void main() => runApp(App());

class App extends StatelessWidget {
  App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routeInformationProvider: _router.routeInformationProvider,
      routeInformationParser: _router.routeInformationParser,
      routerDelegate: _router.routerDelegate,
      title: 'GoRouter Example',
    );
  }

  final GoRouter _router = GoRouter(
    routes: <GoRoute>[
      GoRoute(
        path: '/',
        builder: (BuildContext context, GoRouterState state) {
          return ScreenA();
        },
      ),
      GoRoute(
        path: '/b',
        builder: (BuildContext context, GoRouterState state) {
          return ScreenB();
        },
      ),
    ],
  );
}

class ScreenA extends StatefulWidget {
  const ScreenA({super.key});

  @override
  State<ScreenA> createState() => _ScreenA();
}

class _ScreenA extends State<ScreenA> {
  int _counter = 0;
  bool isReady = false;
  CubeCore? cubecore;
  Future<String> getData() {
    return Future.delayed(Duration(seconds: 2), () {
      return "I am data";
      // throw Exception("Custom Error");
    });
  }

  @override
  void initState() {
    super.initState();
    initCube();
  }

  initCube() async {
    cubecore = await CubeCore.getInstance();
  }

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  var ledRange = RangeValues(0, 900);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Screen A"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            FutureBuilder(
                future: getData(),
                builder: (ctx, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    // If we got an error
                    if (snapshot.hasError) {
                      return Center(
                        child: Text(
                          '${snapshot.error} occurred',
                          style: TextStyle(fontSize: 18),
                        ),
                      );

                      // if we got our data
                    } else if (snapshot.hasData) {
                      // Extracting data from snapshot object
                      final data = snapshot.data as String;
                      return Center(
                        child: Text(
                          '$data',
                          style: TextStyle(fontSize: 18),
                        ),
                      );
                    }
                  }
                  return Center(child: CircularProgressIndicator());
                }),
            Text("Start: " +
                ledRange.start.round().toString() +
                " Stop: " +
                ledRange.end.round().toString()),
            RangeSlider(
                values: ledRange,
                min: 0,
                max: 900,
                onChanged: (RangeValues newRange) {
                  if (cubecore != null && cubecore?.isReady == true) {
                    print("IsTrue");
                    cubecore?.sendRange(newRange);
                  }
                  setState(() {
                    ledRange = newRange;
                  });
                }),
            ElevatedButton(
                onPressed: () => GoRouter.of(context).go('/b'),
                child: Text("Goto B")),
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

class ScreenB extends StatefulWidget {
  const ScreenB({super.key});

  @override
  State<ScreenB> createState() => _ScreenB();
}

class _ScreenB extends State<ScreenB> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Screen B"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
                onPressed: () => GoRouter.of(context).go('/'),
                child: Text("Goto A")),
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
