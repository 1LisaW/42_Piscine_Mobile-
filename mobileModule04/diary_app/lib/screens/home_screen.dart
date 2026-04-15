import 'package:diary_app/features/auth/auth_controller.dart';
import 'package:diary_app/models/diary_entry.dart';
import 'package:diary_app/providers/diary_providers.dart';
import 'package:diary_app/widgets/profile_info.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

const List<String> kMoodEmojis = ['😊', '😢', '😀', '😐', '🤒', '😠'];

const Color _kMintHeader = Color(0xFFB2DFDB);
const Color _kGreenButton = Color(0xFF2E7D32);
const Color _kCardBorder = Color(0xFF81C784);

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
          _ProfileTab(
            entriesAsync: entriesAsync,
            onOpenEntry: (entry) => _showReadEntryDialog(context, entry),
            user: user,
          ),
          const _CalendarPlaceholder(),
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
                      backgroundColor: _kGreenButton,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () => _showAddEntryDialog(context),
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

  Future<void> _showAddEntryDialog(BuildContext context) async {
    final email = ref.read(authStateProvider).value?.email;
    if (email == null || email.isEmpty) return;

    final titleCtrl = TextEditingController();
    final bodyCtrl = TextEditingController();
    var moodIndex = 0;

    await showDialog<void>(
      context: context,
      barrierColor: Colors.black54,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setLocal) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              title: const Text(
                'Add an entry',
                style: TextStyle(
                  fontFamily: 'DancingScript',
                  fontSize: 22,
                  fontWeight: FontWeight.w500,
                ),
              ),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextField(
                      controller: titleCtrl,
                      decoration: const InputDecoration(
                        labelText: 'Title',
                        border: OutlineInputBorder(),
                        labelStyle: TextStyle(fontFamily: 'DancingScript'),
                      ),
                      style: const TextStyle(fontFamily: 'DancingScript'),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        const Text('Mood: '),
                        Expanded(
                          child: DropdownButton<int>(
                            isExpanded: true,
                            value: moodIndex,
                            items: List.generate(
                              kMoodEmojis.length,
                              (i) => DropdownMenuItem(
                                value: i,
                                child: Text(
                                  kMoodEmojis[i],
                                  style: const TextStyle(fontSize: 24),
                                ),
                              ),
                            ),
                            onChanged: (v) {
                              if (v != null) {
                                setLocal(() => moodIndex = v);
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: bodyCtrl,
                      minLines: 4,
                      maxLines: 10,
                      decoration: const InputDecoration(
                        labelText: 'Text',
                        alignLabelWithHint: true,
                        border: OutlineInputBorder(),
                        labelStyle: TextStyle(fontFamily: 'DancingScript'),
                      ),
                      style: const TextStyle(fontFamily: 'DancingScript'),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(ctx).pop(),
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () async {
                    final title = titleCtrl.text.trim();
                    if (title.isEmpty) return;
                    await ref
                        .read(diaryServiceProvider)
                        .addEntry(
                          email: email,
                          title: title,
                          body: bodyCtrl.text.trim(),
                          moodIndex: moodIndex,
                        );
                    if (ctx.mounted) Navigator.of(ctx).pop();
                  },
                  child: const Text(
                    'Add',
                    style: TextStyle(
                      color: Colors.lightBlue,
                      fontFamily: 'DancingScript',
                      fontSize: 18,
                    ),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future<void> _showReadEntryDialog(
    BuildContext context,
    DiaryEntry entry,
  ) async {
    final email = ref.read(authStateProvider).value?.email;
    if (email == null || email.isEmpty) return;

    final dateStr = DateFormat('EEEE, MMMM d, y').format(entry.createdAt);
    final mood = kMoodEmojis[entry.moodIndex.clamp(0, kMoodEmojis.length - 1)];

    await showDialog<void>(
      context: context,
      barrierColor: Colors.black54,
      builder: (ctx) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Text(
            dateStr,
            style: const TextStyle(fontFamily: 'DancingScript', fontSize: 20),
          ),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  entry.title,
                  style: const TextStyle(
                    fontFamily: 'DancingScript',
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 12),
                const Divider(),
                const SizedBox(height: 8),
                Text(
                  'My feeling : $mood',
                  style: const TextStyle(fontFamily: 'DancingScript'),
                ),
                const SizedBox(height: 12),
                const Divider(),
                const SizedBox(height: 8),
                Text(
                  entry.body,
                  style: const TextStyle(fontFamily: 'DancingScript'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () async {
                await ref
                    .read(diaryServiceProvider)
                    .deleteEntry(email, entry.id);
                if (ctx.mounted) Navigator.of(ctx).pop();
              },
              child: const Text(
                'Delete this entry',
                style: TextStyle(
                  color: Colors.red,
                  fontFamily: 'DancingScript',
                  fontSize: 16,
                ),
              ),
            ),
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }
}

class _ProfileTab extends StatelessWidget {
  const _ProfileTab({
    required this.entriesAsync,
    required this.onOpenEntry,
    this.user,
  });

  final AsyncValue<List<DiaryEntry>> entriesAsync;
  final void Function(DiaryEntry) onOpenEntry;
  final User? user;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (user != null) Profile_Info(user: user),
        Container(
          margin: EdgeInsetsGeometry.symmetric(horizontal: 10),
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 20),

          color: _kMintHeader,
          child: SafeArea(
            bottom: false,
            child: Text(
              'Your last diary entries',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'DancingScript',
                fontSize: 26,
                color: Colors.grey.shade900,
              ),
            ),
          ),
        ),
        Expanded(
          child: entriesAsync.when(
            data: (entries) {
              if (entries.isEmpty) {
                return Center(
                  child: Text(
                    'No entries yet.\nTap “New diary entry”.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'DancingScript',
                      fontSize: 18,
                      color: Colors.grey.shade700,
                    ),
                  ),
                );
              }
              return ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: entries.length < 2 ? entries.length : 2,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, i) {
                  final e = entries[i];
                  return _DiaryListTile(entry: e, onTap: () => onOpenEntry(e));
                },
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (err, _) => Center(child: Text('Error: $err')),
          ),
        ),
        // Expanded(
        //   child: Column(
        //     children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 10),
          margin: EdgeInsetsGeometry.symmetric(horizontal: 10),
          color: const Color.fromARGB(255, 134, 245, 60),
          child: SafeArea(
            bottom: false,
            child: Text(
              'Your feel for your 7 entries',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'DancingScript',
                fontSize: 26,
                color: Colors.grey.shade900,
              ),
            ),
          ),
        ),
        // ],
        // ),
        // ),
        Expanded(
          child: entriesAsync.when(
            data: (entries) {
              if (entries.isEmpty) {
                return Center(
                  child: Text(
                    'No entries yet.\nTap “New diary entry”.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'DancingScript',
                      fontSize: 18,
                      color: Colors.grey.shade700,
                    ),
                  ),
                );
              }
              return ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: entries.length < 7 ? entries.length : 7,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, i) {
                  final e = entries[i];
                  final filteredEntr = entries.where(
                    (element) => element.moodIndex == e.moodIndex,
                  );
                  final int percent = (filteredEntr.length * 100 / entries.length)
                      .truncate();
                  return _FeelTile(moodIndex: e.moodIndex, percent: percent);

                  //_DiaryListTile(entry: e, onTap: () => onOpenEntry(e));
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

class _FeelTile extends StatelessWidget {
  const _FeelTile({required this.moodIndex, required this.percent});

  final int moodIndex;
  final int percent;

  @override
  Widget build(BuildContext context) {
    final mood = kMoodEmojis[moodIndex.clamp(0, kMoodEmojis.length - 1)];
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(mood, style: const TextStyle(fontSize: 28)),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 10),
            width: 1,
            height: 52,
            color: Colors.grey.shade400,
          ),
          Expanded(
            child: Text(
              '${percent} %',
              style: TextStyle(
                fontFamily: 'DancingScript',
                fontSize: 20,
                color: Colors.grey.shade900,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}

class _DiaryListTile extends StatelessWidget {
  const _DiaryListTile({required this.entry, required this.onTap});

  final DiaryEntry entry;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final day = DateFormat('d').format(entry.createdAt);
    final month = DateFormat('MMMM').format(entry.createdAt);
    final year = DateFormat('y').format(entry.createdAt);
    final mood = kMoodEmojis[entry.moodIndex.clamp(0, kMoodEmojis.length - 1)];

    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: _kCardBorder, width: 1.2),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: 56,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      day,
                      style: TextStyle(
                        fontFamily: 'DancingScript',
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey.shade900,
                      ),
                    ),
                    Text(
                      month,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontFamily: 'DancingScript',
                        fontSize: 12,
                      ),
                    ),
                    Text(
                      year,
                      style: TextStyle(
                        fontFamily: 'DancingScript',
                        fontSize: 11,
                        color: Colors.grey.shade700,
                      ),
                    ),
                  ],
                ),
              ),
              Text(mood, style: const TextStyle(fontSize: 28)),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 10),
                width: 1,
                height: 52,
                color: Colors.grey.shade400,
              ),
              Expanded(
                child: Text(
                  entry.title,
                  style: TextStyle(
                    fontFamily: 'DancingScript',
                    fontSize: 20,
                    color: Colors.grey.shade900,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CalendarPlaceholder extends StatelessWidget {
  const _CalendarPlaceholder();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Calendar',
        style: TextStyle(
          fontFamily: 'DancingScript',
          fontSize: 28,
          color: Colors.grey.shade700,
        ),
      ),
    );
  }
}
