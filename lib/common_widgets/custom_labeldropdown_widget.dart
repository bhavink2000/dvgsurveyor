import 'package:dvgsurveyor/common_widgets/common_textfield_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

abstract class DropdownItem {
  String get id;
  String get name;
}

class LabeledDropdownRow<T extends DropdownItem> extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final String? selectedId;
  final List<T> items;
  final Function(String?) onChanged;
  final bool isLoading;

  const LabeledDropdownRow({
    super.key,
    required this.label,
    required this.controller,
    required this.selectedId,
    required this.items,
    required this.onChanged,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Left: readonly text input
        Expanded(
            child: Padding(
          padding: const EdgeInsets.only(top: 12),
          child: CustomTextField(
            controller: controller,
            readOnly: true,
            contentPadding: EdgeInsets.only(left: 12),
            labelText: label.tr,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return '${label.tr} જરૂરી છે';
              }
              return null;
            },
          ),
        )),
        const SizedBox(width: 12),
        // Right: dropdown
        Padding(
          padding: const EdgeInsets.only(top: 20),
          child: SizedBox(
            width: 150,
            height: 60,
            child: DropdownButtonFormField<String>(
              isExpanded: true,
              value: items.any((e) => (e as dynamic).id == selectedId)
                  ? selectedId
                  : null,
              items: items.map((item) {
                final id = (item as dynamic).id as String;
                final name = (item as dynamic).name as String;
                return DropdownMenuItem<String>(
                  value: id,
                  child: Text(name),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  final item =
                      items.firstWhere((e) => (e as dynamic).id == value);
                  controller.text = (item as dynamic).name;
                  onChanged(value);
                }
              },
              decoration: InputDecoration(
                labelText: label,
                contentPadding: const EdgeInsets.symmetric(horizontal: 8),
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: Colors.teal),
                ),
              ),
              icon: isLoading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.arrow_drop_down),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'પસંદગી જરૂરી છે';
                }
                return null;
              },
            ),
          ),
        ),
      ],
    );
  }
}
