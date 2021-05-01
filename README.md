# Async TextFormField

A text form field with an async validator support.

## Usage

```dart
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
            ),
          )),
        ),
      ),
    );
  }
}
```

## Contributing
Pull requests are welcome. For major changes, please open an issue first to discuss what you would like to change.
