import 'package:calendar_app/feature/calendar/application/calendar_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

Future<void> showMonthYearPickerSheet(BuildContext context, WidgetRef ref) {
  final currentFocused = ref.read(calendarNotifierProvider).focusedDay;
  int selectedYear = currentFocused.year;
  int selectedMonth = currentFocused.month;

  return showModalBottomSheet(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setSheetState) {
          return Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Jump to Month', style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: DropdownButtonFormField<int>(
                        isExpanded: true,
                        initialValue: selectedMonth,
                        decoration: InputDecoration(
                          labelText: 'Month',
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                        items: List.generate(12, (i) => i + 1)
                            .map((m) => DropdownMenuItem(value: m, child: Text(_monthName(m))))
                            .toList(),
                        onChanged: (value) {
                          if (value != null) setSheetState(() => selectedMonth = value);
                        },
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: DropdownButtonFormField<int>(
                        initialValue: selectedYear,
                        isExpanded: true,
                        decoration: InputDecoration(
                          labelText: 'Year',
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                        items: List.generate(51, (i) => 1990 + i)
                            .map((y) => DropdownMenuItem(value: y, child: Text(y.toString())))
                            .toList(),
                        onChanged: (value) {
                          if (value != null) setSheetState(() => selectedYear = value);
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    onPressed: () {
                      ref
                          .read(calendarNotifierProvider.notifier)
                          .jumpToMonthYear(selectedYear, selectedMonth);
                      Navigator.pop(context);
                    },
                    child: const Text('Go'),
                  ),
                ),
              ],
            ),
          );
        },
      );
    },
  );
}

String _monthName(int month) {
  const names = [
    'January', 'February', 'March', 'April', 'May', 'June',
    'July', 'August', 'September', 'October', 'November', 'December',
  ];
  return names[month - 1];
}