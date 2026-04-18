import 'package:diary_app/models/diary_entry.dart';
import 'package:diary_app/utils/diary_entry_utils.dart';
import 'package:diary_app/widgets/diary_list_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarTab extends StatefulWidget {
  const CalendarTab({
    super.key,
    required this.entriesAsync,
    required this.onOpenEntry,
  });

  final AsyncValue<List<DiaryEntry>> entriesAsync;
  final void Function(DiaryEntry) onOpenEntry;

  @override
  State<CalendarTab> createState() => _CalendarTabState();
}

class _CalendarTabState extends State<CalendarTab> {
  late DateTime _focusedDay;
  late DateTime _selectedDay;

  @override
  void initState() {
    super.initState();
    final n = DateTime.now();
    _focusedDay = DateTime(n.year, n.month, n.day);
    _selectedDay = _focusedDay;
  }

  @override
  Widget build(BuildContext context) {
    final headerStyle = TextStyle(
      fontFamily: 'DancingScript',
      fontSize: 22,
      color: Colors.grey.shade900,
    );
    final dowStyle = TextStyle(
      fontFamily: 'DancingScript',
      fontSize: 13,
      color: Colors.grey.shade600,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TableCalendar(
          firstDay: DateTime.utc(2018, 1, 1),
          lastDay: DateTime.utc(2035, 12, 31),
          focusedDay: _focusedDay,
          selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
          calendarFormat: CalendarFormat.month,
          startingDayOfWeek: StartingDayOfWeek.sunday,
          onDaySelected: (selectedDay, focusedDay) {
            setState(() {
              _selectedDay = selectedDay;
              _focusedDay = focusedDay;
            });
          },
          onPageChanged: (focusedDay) {
            setState(() => _focusedDay = focusedDay);
          },
          calendarStyle: CalendarStyle(
            outsideDaysVisible: true,
            weekendTextStyle: TextStyle(color: Colors.grey.shade700),
            defaultTextStyle: TextStyle(color: Colors.grey.shade800),
            outsideTextStyle: TextStyle(color: Colors.grey.shade400),
            selectedDecoration: BoxDecoration(
              color: Colors.indigo.shade200,
              shape: BoxShape.circle,
            ),
            selectedTextStyle: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
            todayDecoration: BoxDecoration(
              color: Colors.grey.shade300,
              shape: BoxShape.circle,
            ),
            todayTextStyle: TextStyle(color: Colors.grey.shade900),
          ),
          headerStyle: HeaderStyle(
            formatButtonVisible: false,
            titleCentered: true,
            titleTextStyle: headerStyle,
            leftChevronIcon: Icon(
              Icons.chevron_left,
              color: Colors.grey.shade800,
            ),
            rightChevronIcon: Icon(
              Icons.chevron_right,
              color: Colors.grey.shade800,
            ),
          ),
          daysOfWeekStyle: DaysOfWeekStyle(
            weekdayStyle: dowStyle,
            weekendStyle: dowStyle,
          ),
        ),
        const Divider(height: 1),
        Expanded(
          child: widget.entriesAsync.when(
            data: (entries) {
              final dayEntries = entriesOnCalendarDay(entries, _selectedDay);
              if (dayEntries.isEmpty) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Text(
                      'No entries for this day.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'DancingScript',
                        fontSize: 18,
                        color: Colors.grey.shade700,
                      ),
                    ),
                  ),
                );
              }
              return ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: dayEntries.length,
                separatorBuilder: (_, _) => const SizedBox(height: 12),
                itemBuilder: (context, i) {
                  final e = dayEntries[i];
                  return DiaryListTile(
                    entry: e,
                    onTap: () => widget.onOpenEntry(e),
                  );
                },
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (err, _) => Center(child: Text('Error: $err')),
          ),
        ),
      ],
    );
  }
}
