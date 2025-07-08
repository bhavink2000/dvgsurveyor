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
  final Function(String value) onChanged;
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
              value: selectedId,
              //value: items.any((e) => e.id == selectedId) ? selectedId : null,
              items: items
                  .toSet()
                  .map(
                    (item) => DropdownMenuItem(
                      value: item.id,
                      child: Text(item.name),
                    ),
                  )
                  .toList(),
              onChanged: (value) {
                if (value != null) {
                  onChanged(value);
                  controller.text = items.firstWhere((e) => e.id == value).name;
                }
              },
              isDense: true,
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.symmetric(horizontal: 8),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: Colors.grey),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: Colors.teal),
                ),
              ),
              // only loading the icon
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
