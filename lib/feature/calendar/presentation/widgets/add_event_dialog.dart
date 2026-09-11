import 'package:calendar_app/feature/calendar/application/calendar_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

Future<void> showAddEventDialog(
  BuildContext context,
  WidgetRef ref, {
  required DateTime forDay,
}) async {
  final controller = TextEditingController();
  bool setReminder = false;
  TimeOfDay? reminderTimeOfDay;

  await showDialog(
    context: context,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setDialogState) {
          return AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            title: const Text('Add Event'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: controller,
                  autofocus: true,
                  decoration: InputDecoration(
                    hintText: 'Event title',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                ),
                const SizedBox(height: 16),
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('Set Reminder'),
                  value: setReminder,
                  onChanged: (value) {
                    setDialogState(() => setReminder = value);
                  },
                ),
                if (setReminder)
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            reminderTimeOfDay != null
                                ? 'Reminder at ${reminderTimeOfDay!.format(context)}'
                                : 'No time selected',
                            style: TextStyle(color: Colors.grey[700]),
                          ),
                        ),
                        TextButton.icon(
                          icon: const Icon(Icons.access_time, size: 18),
                          label: const Text('Pick Time'),
                          onPressed: () async {
                            final picked = await showTimePicker(
                              context: context,
                              initialTime: reminderTimeOfDay ?? TimeOfDay.now(),
                            );
                            if (picked != null) {
                              setDialogState(() => reminderTimeOfDay = picked);
                            }
                          },
                        ),
                      ],
                    ),
                  ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () async {
                  DateTime? reminderDateTime;
                  if (setReminder && reminderTimeOfDay != null) {
                    reminderDateTime = DateTime(
                      forDay.year,
                      forDay.month,
                      forDay.day,
                      reminderTimeOfDay!.hour,
                      reminderTimeOfDay!.minute,
                    );
                  }

                  await ref.read(eventActionsProvider).addEvent(
                        controller.text,
                        forDay,
                        reminderTime: reminderDateTime,
                      );

                  if (context.mounted) Navigator.pop(context);
                },
                child: const Text('Add'),
              ),
            ],
          );
        },
      );
    },
  );
}