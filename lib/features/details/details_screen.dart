import 'package:flutter/material.dart';

// Typed args used when navigating to the details page
class DetailsArgs {
  final String title;
  final int id;

  DetailsArgs({required this.title, required this.id});
}

class DetailsScreen extends StatelessWidget {
  final DetailsArgs args;
  const DetailsScreen({Key? key, required this.args}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(args.title)),
      body: Center(
        child: Text('Detail page for id: ${args.id}', style: const TextStyle(fontSize: 18)),
      ),
    );
  }
}

