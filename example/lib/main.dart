import 'package:async_textformfield/async_textformfield.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Async Validated Text Form Field'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController controller = TextEditingController();

  Future<bool> isValidPasscode(String value) async {
    return await Future.delayed(Duration(seconds: 2), () => value.isNotEmpty && value.toLowerCase() == 'batman');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Center(
          child: Form(
              child: Center(
            child: AsyncTextFormField(
              controller: controller,
              validationDebounce: Duration(milliseconds: 500),
              validator: isValidPasscode,
              hintText: 'Enter the Passcode',
              isValidatingMessage: 'Comparing with the hash from a secure server..',
              valueIsInvalidMessage: 'Nope, Try harder..',
              valueIsEmptyMessage: 'No one sets an empty passcode!',
            ),
          )),
        ),
      ),
    );
  }
}
