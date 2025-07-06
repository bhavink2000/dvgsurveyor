import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController? controller;
  final String? labelText;
  final String? hintText;
  final String? errorText;
  final Function(String)? onChanged;
  final Function(String)? onSubmitted;
  final Function()? onTap;
  final TextInputType? keyboardType;
  final bool obscureText;
  final bool readOnly;
  final bool autofocus;
  final bool enabled;
  final int? maxLength;
  final int? maxLines;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final EdgeInsetsGeometry? contentPadding;
  final InputBorder? border;
  final InputBorder? focusedBorder;
  final InputBorder? errorBorder;
  final Color? fillColor;
  final bool filled;
  final TextStyle? textStyle;
  final TextStyle? errorStyle;
  final TextStyle? hintStyle;
  final List<TextInputFormatter>? inputFormatters;
  final FocusNode? focusNode;
  final TextCapitalization textCapitalization;
  final TextAlign textAlign;
  final TextAlignVertical? textAlignVertical;
  final TextInputAction? textInputAction;
  final String? Function(String?)? validator;
  final double borderRadius;
  final Color? cursorColor;
  final double cursorHeight;
  final double? cursorWidth;

  const CustomTextField({
    super.key,
    this.controller,
    this.labelText,
    this.hintText,
    this.errorText,
    this.onChanged,
    this.onSubmitted,
    this.onTap,
    this.keyboardType,
    this.obscureText = false,
    this.readOnly = false,
    this.autofocus = false,
    this.enabled = true,
    this.maxLength,
    this.maxLines = 1,
    this.prefixIcon,
    this.suffixIcon,
    this.contentPadding,
    this.border,
    this.focusedBorder,
    this.errorBorder,
    this.fillColor,
    this.filled = false,
    this.textStyle,
    this.errorStyle,
    this.hintStyle,
    this.inputFormatters,
    this.focusNode,
    this.textCapitalization = TextCapitalization.none,
    this.textAlign = TextAlign.start,
    this.textAlignVertical,
    this.textInputAction,
    this.validator,
    this.borderRadius = 8.0,
    this.cursorColor,
    this.cursorHeight = 24,
    this.cursorWidth = 2,
  });

  @override
  Widget build(BuildContext context) {
    final border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(borderRadius),
      borderSide: BorderSide(
        color: Colors.grey.shade400,
        width: 1.5,
      ),
    );

    return TextFormField(
      controller: controller,
      focusNode: focusNode,
      textCapitalization: textCapitalization,
      textAlign: textAlign,
      textAlignVertical: textAlignVertical,
      textInputAction: textInputAction,
      keyboardType: keyboardType,
      obscureText: obscureText,
      readOnly: readOnly,
      autofocus: autofocus,
      enabled: enabled,
      maxLength: maxLength,
      maxLines: obscureText ? 1 : maxLines,
      cursorColor: cursorColor ?? Theme.of(context).primaryColor,
      cursorHeight: cursorHeight,
      cursorWidth: cursorWidth ?? 2,
      style: textStyle ?? GoogleFonts.inter(fontSize: 16),
      decoration: InputDecoration(
        contentPadding: contentPadding ??
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        labelText: labelText,
        hintText: hintText,
        errorText: errorText,
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        filled: filled,
        fillColor: fillColor ?? Colors.grey.withValues(alpha: 0.05),
        border: border,
        enabledBorder: border,
        focusedBorder: focusedBorder ??
            OutlineInputBorder(
              borderRadius: BorderRadius.circular(borderRadius),
              borderSide: BorderSide(
                color: Theme.of(context).primaryColor,
                width: 1.5,
              ),
            ),
        errorBorder: errorBorder ??
            OutlineInputBorder(
              borderRadius: BorderRadius.circular(borderRadius),
              borderSide: BorderSide(
                color: Theme.of(context).colorScheme.error,
                width: 1.5,
              ),
            ),
        hintStyle: hintStyle ??
            GoogleFonts.inter(
              fontSize: 16,
              color: Colors.grey.shade500,
            ),
        labelStyle: GoogleFonts.inter(
          fontSize: 16,
          color: Colors.grey.shade600,
        ),
        errorStyle: errorStyle ?? GoogleFonts.inter(fontSize: 10),
      ),
      onChanged: onChanged,
      onFieldSubmitted: onSubmitted,
      onTap: onTap,
      inputFormatters: inputFormatters,
      validator: validator,
      autovalidateMode: AutovalidateMode.onUserInteraction,
    );
  }
}
