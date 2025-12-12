import 'package:flutter/material.dart';
import '../../../theme/app_colors.dart';

class VoiceNotesScreen extends StatefulWidget {
  const VoiceNotesScreen({super.key});

  @override
  State<VoiceNotesScreen> createState() => _VoiceNotesScreenState();
}

class _VoiceNotesScreenState extends State<VoiceNotesScreen> {
  bool isExpanded = true;

  final List<Map<String, String>> voiceNotes = List.generate(
    5,
        (i) => {
      "text": "just adding a text voice note as a reminder to buy new shoes",
      "author": "Emily Watson",
      "daysAgo": "25 days ago",
    },
  );

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      children: [
        ExpansionTile(
          initiallyExpanded: isExpanded,
          onExpansionChanged: (v) => setState(() => isExpanded = v),
          tilePadding: EdgeInsets.zero,
          title: const Text(
            "Wednesday, September 24, 2025 (5)",
            style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
          ),
          children: voiceNotes.map((note) {
            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.15),
                    spreadRadius: 1,
                    blurRadius: 3,
                    offset: const Offset(0, 1),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.format_quote_rounded,
                        color: Colors.pinkAccent, size: 26),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '"${note["text"]}"',
                            style: const TextStyle(
                              fontSize: 13.5,
                              fontStyle: FontStyle.italic,
                              height: 1.4,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '${note["daysAgo"]}  •  ${note["author"]}',
                                style: const TextStyle(
                                  color: Colors.black54,
                                  fontSize: 12,
                                ),
                              ),
                              TextButton(
                                onPressed: () {},
                                style: TextButton.styleFrom(
                                  padding: EdgeInsets.zero,
                                  minimumSize: const Size(0, 0),
                                ),
                                child: Text(
                                  "Create Tasks",
                                  style: TextStyle(
                                    color: AppColors.primary,
                                    fontSize: 12.5,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}