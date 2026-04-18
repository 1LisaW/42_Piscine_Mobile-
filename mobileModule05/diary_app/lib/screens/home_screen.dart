import 'package:diary_app/constants/diary_ui_constants.dart';
import 'package:diary_app/dialogs/diary_entry_dialogs.dart';
import 'package:diary_app/features/auth/auth_controller.dart';
import 'package:diary_app/providers/diary_providers.dart';
import 'package:diary_app/widgets/calendar_tab.dart';
import 'package:diary_app/widgets/profile_tab.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  int _navIndex = 0;

  @override
  Widget build(BuildContext context) {
    final entriesAsync = ref.watch(diaryEntriesProvider);
    final User? user = ref.read(authStateProvider).value;

    return Scaffold(
      body: IndexedStack(
        index: _navIndex,
        children: [
          ProfileTab(
            entriesAsync: entriesAsync,
            onOpenEntry: (entry) =>
                showReadDiaryEntryDialog(context, ref, entry),
            user: user,
          ),
          CalendarTab(
            entriesAsync: entriesAsync,
            onOpenEntry: (entry) =>
                showReadDiaryEntryDialog(context, ref, entry),
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (_navIndex == 0)
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: kGreenButton,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () => showAddDiaryEntryDialog(context, ref),
                    child: const Text(
                      'New diary entry',
                      style: TextStyle(
                        fontFamily: 'DancingScript',
                        fontSize: 20,
                      ),
                    ),
                  ),
                ),
              ),
            BottomNavigationBar(
              currentIndex: _navIndex,
              onTap: (i) => setState(() => _navIndex = i),
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.person),
                  label: 'Profile',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.calendar_month_outlined),
                  label: 'Calendar',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
