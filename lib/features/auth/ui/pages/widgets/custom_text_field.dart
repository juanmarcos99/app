import 'package:flutter/material.dart';
import 'package:app/core/core.dart';

class CustomTextField extends StatefulWidget {
  final String label;
  final String? hint;
  final IconData icon;
  final bool obscure;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final VoidCallback? onFieldSubmitted;

  const CustomTextField({
    super.key,
    required this.label,
    this.hint,
    required this.icon,
    this.obscure = false,
    this.controller,
    this.focusNode,
    this.onFieldSubmitted,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  late bool _obscureText;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.obscure;
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      focusNode: widget.focusNode,
      obscureText: _obscureText,
      onFieldSubmitted: (_) => widget.onFieldSubmitted?.call(),
      style: AppTypography.inputLight,
      decoration: InputDecoration(
        labelText: widget.label,
        hintText: widget.hint,
        labelStyle: AppTypography.captionLight,
        hintStyle: AppTypography.captionLight.copyWith(
          color: AppColors.textDisabled,
        ),
        enabledBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: AppColors.gray300, width: 1),
        ),
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: AppColors.primary, width: 2),
        ),
        border: const UnderlineInputBorder(),
        filled: true,
        fillColor: AppColors.white,
        prefixIcon: Icon(widget.icon, color: AppColors.primary),
        suffixIcon: widget.obscure
            ? IconButton(
                icon: Icon(
                  _obscureText ? Icons.visibility_off : Icons.visibility,
                  color: AppColors.gray300,
                ),
                onPressed: () {
                  setState(() {
                    _obscureText = !_obscureText;
                  });
                },
              )
            : null,
      ),
    );
  }
}
