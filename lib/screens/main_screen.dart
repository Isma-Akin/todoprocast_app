import 'package:flutter/material.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Main Screen'),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [SizedBox(height: 30,),SizedBox(height: 30,),
            SizedBox(width: 500,
              height: 50,
              child: InkWell(onTap: () {},
                focusColor: Colors.blue,
                child: Card(
                  child: FittedBox(alignment: Alignment.centerLeft,
                      child: Text('Day Planner')),
                ),
              ),
            ),
            SizedBox(
              width: 500,
              height: 50,
              child: Card(
                child: FittedBox(alignment: Alignment.centerLeft,
                    child: Text('Important tasks')),
              ),
            ),
            SizedBox(
              width: 500,
              height: 50,
              child: Card(
                child: FittedBox(alignment: Alignment.centerLeft,
                    child: Text('Planned tasks')),
              ),
            ),
          ],
        )
      ),
    );
  }
}
