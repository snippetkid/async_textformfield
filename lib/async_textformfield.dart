import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AsyncTextFormField extends StatefulWidget {
  final Future<String?> Function(String)? validator;
  final Duration? validationDebounce;
  final TextEditingController? controller;

  final String? initialValue;
  final FocusNode? focusNode;
  final TextInputType? keyboardType;
  final TextCapitalization textCapitalization;
  final TextInputAction? textInputAction;
  final TextStyle? style;
  final StrutStyle? strutStyle;
  final TextDirection? textDirection;
  final TextAlign textAlign;
  final TextAlignVertical? textAlignVertical;
  final bool autofocus;
  final bool readOnly;
  final ToolbarOptions? toolbarOptions;
  final bool? showCursor;
  final String obscuringCharacter;
  final bool obscureText;
  final bool autocorrect;
  final SmartDashesType? smartDashesType;
  final SmartQuotesType? smartQuotesType;
  final bool enableSuggestions;
  final MaxLengthEnforcement? maxLengthEnforcement;
  final int? maxLines;
  final int? minLines;
  final bool expands;
  final int? maxLength;
  final InputDecoration? decoration;
  final ValueChanged<String>? onChanged;
  final GestureTapCallback? onTap;
  final VoidCallback? onEditingComplete;
  final ValueChanged<String>? onFieldSubmitted;
  final FormFieldSetter<String>? onSaved;
  final List<TextInputFormatter>? inputFormatters;
  final bool? enabled;
  final double cursorWidth;
  final double? cursorHeight;
  final Radius? cursorRadius;
  final Color? cursorColor;
  final Brightness? keyboardAppearance;
  final EdgeInsets scrollPadding;
  final bool enableInteractiveSelection;
  final TextSelectionControls? selectionControls;
  final InputCounterWidgetBuilder? buildCounter;
  final ScrollPhysics? scrollPhysics;
  final Iterable<String>? autofillHints;
  final AutovalidateMode? autovalidateMode;

  const AsyncTextFormField({
    Key? key,
    this.validator,
    this.validationDebounce,
    this.controller,
    this.decoration,
    this.onChanged,
    this.onTap,
    this.onEditingComplete,
    this.onFieldSubmitted,
    this.onSaved,
    this.inputFormatters,
    this.enabled,
    this.cursorHeight,
    this.cursorRadius,
    this.cursorColor,
    this.keyboardAppearance,
    this.selectionControls,
    this.buildCounter,
    this.scrollPhysics,
    this.autofillHints,
    this.autovalidateMode = AutovalidateMode.onUserInteraction,
    this.initialValue,
    this.focusNode,
    this.keyboardType,
    this.textInputAction,
    this.style,
    this.strutStyle,
    this.textDirection,
    this.textAlignVertical,
    this.toolbarOptions,
    this.showCursor,
    this.smartDashesType,
    this.smartQuotesType,
    this.maxLengthEnforcement,
    this.minLines,
    this.maxLength,
    this.textCapitalization = TextCapitalization.none,
    this.scrollPadding = const EdgeInsets.all(20.0),
    this.textAlign = TextAlign.start,
    this.autofocus = false,
    this.readOnly = false,
    this.obscuringCharacter = '•',
    this.obscureText = false,
    this.autocorrect = true,
    this.enableSuggestions = true,
    this.maxLines = 1,
    this.expands = false,
    this.cursorWidth = 2.0,
    this.enableInteractiveSelection = true,
  }) : super(key: key);

  @override
  _AsyncTextFormFieldState createState() => _AsyncTextFormFieldState();
}

class _AsyncTextFormFieldState extends State<AsyncTextFormField> {
  Timer? debounce;
  String? validationMessage;
  bool isValidating = false;
  bool isValid = false;
  bool isDirty = false;
  bool isWaiting = false;
  late String originalValue;

  @override
  void initState() {
    originalValue = widget.initialValue ?? widget.controller?.text ?? '';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final decoration = widget.decoration?.copyWith(suffix: SizedBox(height: 20, width: 20, child: _getSuffixIcon())) ??
        InputDecoration(suffix: SizedBox(height: 20, width: 20, child: _getSuffixIcon()));
    return TextFormField(
      validator: (value) => validationMessage,
      onChanged: (text) async {
        setState(() => isDirty = true);
        if (text.isEmpty) {
          final msg = await widget.validator?.call(text);
          setState(() {
            isValid = msg == null;
            isValidating = false;
            validationMessage = msg;
          });
          cancelTimer();
          return;
        }
        if (text == originalValue) {
          // edited text is same as the original one, the value is valid, no need to validate it
          setState(() {
            isValid = true;
            isValidating = false;
            validationMessage = null;
          });
          cancelTimer();
          return;
        }
        setState(() => isWaiting = true);
        cancelTimer();
        debounce = Timer(widget.validationDebounce ?? Duration(milliseconds: 500), () async {
          setState(() {
            isWaiting = false;
            isValidating = true;
          });
          final msg = await widget.validator?.call(text);
          setState(() {
            isValid = msg == null;
            isValidating = false;
            validationMessage = msg;
          });
        });
        widget.onChanged?.call(text);
      },
      controller: widget.controller,
      decoration: decoration,
      onTap: widget.onTap,
      onEditingComplete: widget.onEditingComplete,
      onFieldSubmitted: widget.onFieldSubmitted,
      onSaved: widget.onSaved,
      inputFormatters: widget.inputFormatters,
      enabled: widget.enabled,
      cursorHeight: widget.cursorHeight,
      cursorRadius: widget.cursorRadius,
      cursorColor: widget.cursorColor,
      keyboardAppearance: widget.keyboardAppearance,
      selectionControls: widget.selectionControls,
      buildCounter: widget.buildCounter,
      scrollPhysics: widget.scrollPhysics,
      autofillHints: widget.autofillHints,
      autovalidateMode: widget.autovalidateMode,
      initialValue: widget.initialValue,
      focusNode: widget.focusNode,
      keyboardType: widget.keyboardType,
      textInputAction: widget.textInputAction,
      style: widget.style,
      strutStyle: widget.strutStyle,
      textDirection: widget.textDirection,
      textAlignVertical: widget.textAlignVertical,
      toolbarOptions: widget.toolbarOptions,
      showCursor: widget.showCursor,
      smartDashesType: widget.smartDashesType,
      smartQuotesType: widget.smartQuotesType,
      maxLengthEnforcement: widget.maxLengthEnforcement,
      minLines: widget.minLines,
      maxLength: widget.maxLength,
      textCapitalization: widget.textCapitalization,
      scrollPadding: widget.scrollPadding,
      textAlign: widget.textAlign,
      autofocus: widget.autofocus,
      readOnly: widget.readOnly,
      obscuringCharacter: widget.obscuringCharacter,
      obscureText: widget.obscureText,
      autocorrect: widget.autocorrect,
      enableSuggestions: widget.enableSuggestions,
      maxLines: widget.maxLines,
      expands: widget.expands,
      cursorWidth: widget.cursorWidth,
      enableInteractiveSelection: widget.enableInteractiveSelection,
    );
  }

  @override
  void dispose() {
    debounce?.cancel();
    super.dispose();
  }

  void cancelTimer() {
    if (debounce?.isActive ?? false) {
      debounce?.cancel();
    }
  }

  Widget _getSuffixIcon() {
    if (isValidating) {
      return CircularProgressIndicator(
        strokeWidth: 2.0,
        valueColor: AlwaysStoppedAnimation(Colors.blue),
      );
    } else {
      if (!isValid && isDirty) {
        return Icon(
          Icons.cancel,
          color: Colors.red,
          size: 20,
        );
      } else if (isValid) {
        return Icon(
          Icons.check_circle,
          color: Colors.green,
          size: 20,
        );
      } else {
        return Container();
      }
    }
  }
}
