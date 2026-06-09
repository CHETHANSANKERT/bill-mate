import 'package:bill_mate/components/ui/text_input_field.dart';
import 'package:flutter/material.dart';

import 'app_colors.dart';

class DropDownTextField extends StatefulWidget {
  final String label;
  final String name;
  final String hintText;
  final Future<List<String>> Function(String query) suggestionsCallback;
  final FormFieldSetter<String>? onSaved;
  final FormFieldValidator<String>? validator;
  final TextEditingController? controller;
  final VoidCallback? onTap;

  const DropDownTextField({
    super.key,
    required this.label,
    required this.name,
    required this.hintText,
    required this.suggestionsCallback,
    this.onSaved,
    this.validator,
    this.controller,
    this.onTap,
  });

  @override
  _DropDownTextFieldState createState() => _DropDownTextFieldState();
}

class _DropDownTextFieldState extends State<DropDownTextField> {
  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;
  List<String> _suggestions = [];
  final FocusNode _focusNode = FocusNode();
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? TextEditingController();

    _focusNode.addListener(() {
      if (_focusNode.hasFocus) {
        _updateSuggestions();
        _showOverlay();
      } else {
        _removeOverlay();
      }
    });

    _controller.addListener(() {
      _updateSuggestions();
    });
  }

  void _updateSuggestions() async {
    final query = _controller.text.trim();
    final results = await widget.suggestionsCallback(query);
    setState(() {
      _suggestions = results;
    });
    _overlayEntry?.markNeedsBuild();
  }

  void _showOverlay() {
    if (_overlayEntry != null) return;
    _overlayEntry = _createOverlayEntry();
    Overlay.of(context).insert(_overlayEntry!);
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  OverlayEntry _createOverlayEntry() {
    RenderBox renderBox = context.findRenderObject() as RenderBox;
    final size = renderBox.size;

    return OverlayEntry(
      builder: (context) => Positioned(
        width: size.width,
        child: CompositedTransformFollower(
          link: _layerLink,
          offset: Offset(0, size.height + 4),
          showWhenUnlinked: false,
          child: Material(
            elevation: 4,
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxHeight: 400, // Adjust this value as needed
              ),
              child: ListView(
                shrinkWrap: true,
                padding: EdgeInsets.zero,
                children: _suggestions
                    .map(
                      (suggestion) => Column(
                    children: [
                      ListTile(
                        title: Text(suggestion),
                        onTap: () {
                          _controller
                            ..text = suggestion
                            ..selection = TextSelection.fromPosition(
                              TextPosition(offset: suggestion.length),
                            );
                          _removeOverlay();
                          if (widget.onTap != null) widget.onTap!();
                        },
                      ),
                      const Divider(
                        color: AppColors.kOutline,
                        thickness: 1,
                        height: 1,
                      ),
                    ],
                  ),
                )
                    .toList(),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _controller.dispose();
    _removeOverlay();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _layerLink,
      child: TextInputField(
        focusNode: _focusNode,
        controller: _controller,
        label: widget.label,
        hintText: widget.hintText,
        name: widget.name,
        validator: widget.validator,
        onSaved: widget.onSaved,
      ),
    );
  }
}
