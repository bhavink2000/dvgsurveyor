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
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 12),
      child: Row(
        children: [
          // Read-only field showing selected name
          Expanded(
            child: CustomTextField(
              controller: controller,
              readOnly: true,
              contentPadding: const EdgeInsets.only(left: 12),
              labelText: label.tr,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return '${label.tr} જરૂરી છે';
                }
                return null;
              },
            ),
          ),
          const SizedBox(width: 12),
          // Dropdown button
          SizedBox(
            width: 140,
            height: 58,
            child: DropdownButtonFormField<String>(
              isExpanded: true,
              value: items.any((e) => e.id == selectedId) ? selectedId : null,
              items: items.map((item) {
                return DropdownMenuItem(
                  value: item.id,
                  child: Text(item.name, overflow: TextOverflow.ellipsis),
                );
              }).toList(),
              onChanged: (value) {
                final selected = items.firstWhere(
                  (item) => item.id == value,
                  orElse: () => items.first,
                );
                controller.text = selected.name;
                onChanged(value);
              },
              decoration: InputDecoration(
                labelText: label,
                contentPadding: const EdgeInsets.symmetric(horizontal: 8),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
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
              validator: (value) =>
                  (value == null || value.isEmpty) ? 'પસંદગી જરૂરી છે' : null,
            ),
          ),
        ],
      ),
    );
  }
}
