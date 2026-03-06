//
//
// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:http/http.dart' as http;
// import 'package:shared_preferences/shared_preferences.dart';
//
// class MyHealthReportsPage extends StatefulWidget {
//   const MyHealthReportsPage({super.key});
//
//   @override
//   State<MyHealthReportsPage> createState() => _MyHealthReportsPageState();
// }
//
// class _MyHealthReportsPageState extends State<MyHealthReportsPage> {
//
//   List reports = [];
//   bool isLoading = true;
//
//   @override
//   void initState() {
//     super.initState();
//     loadReports();
//   }
//
//   Future<void> loadReports() async {
//
//     SharedPreferences sh = await SharedPreferences.getInstance();
//     String url = sh.getString('url') ?? '';
//     String lid = sh.getString('lid') ?? '';
//
//     try {
//
//       var summaryRes = await http.post(Uri.parse("$url/user_view_ai_summary/"), body: {'lid': lid});
//       var dietRes = await http.post(Uri.parse("$url/user_view_dietplans/"), body: {'lid': lid});
//
//       var summaryJson = jsonDecode(summaryRes.body);
//       var dietJson = jsonDecode(dietRes.body);
//
//       Map<String, Map<String, String>> combined = {};
//
//       if (summaryJson['status'] == 'ok') {
//         for (var s in summaryJson['data']) {
//           combined[s['title']] = {
//             'summary': s['summary'],
//             'date': s['date'],
//             'diet': ''
//           };
//         }
//       }
//
//       if (dietJson['status'] == 'ok') {
//         for (var d in dietJson['data']) {
//           if (combined.containsKey(d['title'])) {
//             combined[d['title']]!['diet'] = d['dietplan'];
//           } else {
//             combined[d['title']] = {
//               'summary': '',
//               'date': d['date'],
//               'diet': d['dietplan']
//             };
//           }
//         }
//       }
//
//       setState(() {
//         reports = combined.entries.toList();
//         isLoading = false;
//       });
//
//     } catch (e) {
//       Fluttertoast.showToast(msg: "Error loading reports");
//       setState(() => isLoading = false);
//     }
//   }
//
//   // ---------- LABEL ----------
//   Widget label(String text) {
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 6),
//       child: Text(
//         text,
//         style: const TextStyle(
//           fontSize: 12,
//           fontWeight: FontWeight.bold,
//           color: Colors.black54,
//           letterSpacing: 0.5,
//         ),
//       ),
//     );
//   }
//
//   // ---------- BUTTON ----------
//   Widget actionButton(String text, VoidCallback? onTap, {bool dark = true}) {
//     return Expanded(
//       child: ElevatedButton(
//         onPressed: onTap,
//         style: ElevatedButton.styleFrom(
//           backgroundColor: dark ? Colors.black : Colors.grey.shade800,
//           padding: const EdgeInsets.symmetric(vertical: 14),
//           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//           elevation: 0,
//         ),
//         child: Text(text, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
//       ),
//     );
//   }
//
//   void showContent(String title, String content) {
//     showModalBottomSheet(
//       context: context,
//       isScrollControlled: true,
//       backgroundColor: const Color(0xfff2f2f2),
//       shape: const RoundedRectangleBorder(
//           borderRadius: BorderRadius.vertical(top: Radius.circular(25))),
//       builder: (_) => Padding(
//         padding: const EdgeInsets.all(20),
//         child: SingleChildScrollView(
//           child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
//
//             Text(title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
//             const SizedBox(height: 15),
//             Text(content, style: const TextStyle(height: 3,color: Colors.black)),
//
//             const SizedBox(height: 30),
//
//             SizedBox(
//               width: double.infinity,
//               child: ElevatedButton(
//                 style: ElevatedButton.styleFrom(
//                     backgroundColor: Colors.black,
//                     padding: const EdgeInsets.symmetric(vertical: 15),
//                     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
//                 onPressed: () => Navigator.pop(context),
//                 child: const Text("Close", style: TextStyle(color: Colors.white)),
//               ),
//             )
//
//           ]),
//         ),
//       ),
//     );
//   }
//
//   Widget reportCard(int index) {
//
//     var entry = reports[index];
//     String title = entry.key;
//     String summary = entry.value['summary'] ?? '';
//     String diet = entry.value['diet'] ?? '';
//     String date = entry.value['date'] ?? '';
//
//     return Container(
//       margin: const EdgeInsets.only(bottom: 20),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(20),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.08),
//             blurRadius: 20,
//             offset: const Offset(0, 10),
//           )
//         ],
//       ),
//       child: Column(
//         children: [
//
//           // HEADER
//           Container(
//             padding: const EdgeInsets.all(20),
//             decoration: BoxDecoration(
//               gradient: LinearGradient(
//                 colors: [Colors.black, Colors.grey.shade800],
//                 begin: Alignment.topLeft,
//                 end: Alignment.bottomRight,
//               ),
//               borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
//             ),
//             child: Row(
//               children: [
//                 Container(
//                   padding: const EdgeInsets.all(10),
//                   decoration: BoxDecoration(
//                     color: Colors.white.withOpacity(0.15),
//                     borderRadius: BorderRadius.circular(10),
//                   ),
//                   child: const Icon(Icons.description, color: Colors.white),
//                 ),
//                 const SizedBox(width: 12),
//                 Expanded(
//                   child: Text(title,
//                       style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
//                 ),
//               ],
//             ),
//           ),
//
//           // BODY
//           Padding(
//             padding: const EdgeInsets.all(20),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//
//                 label("DATE"),
//                 Text(date, style: const TextStyle(fontSize: 15)),
//
//                 const SizedBox(height: 20),
//
//                 label("ACTIONS"),
//                 Row(
//                   children: [
//                     actionButton("View Summary", summary.isEmpty ? null : () => showContent("AI Summary", summary)),
//                     const SizedBox(width: 12),
//                     actionButton("View Diet", diet.isEmpty ? null : () => showContent("Diet Plan", diet), dark: false),
//                   ],
//                 )
//
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//
//     return Scaffold(
//       backgroundColor: const Color(0xfff2f2f2),
//       appBar: AppBar(
//         backgroundColor: Colors.black,
//         iconTheme: const IconThemeData(color: Colors.white),
//         title: const Text("My AI Health Reports",
//             style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
//         elevation: 0,
//       ),
//
//       body: isLoading
//           ? const Center(child: CircularProgressIndicator(color: Colors.black))
//           : reports.isEmpty
//           ? Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Container(
//               padding: const EdgeInsets.all(30),
//               decoration: const BoxDecoration(color: Colors.black12, shape: BoxShape.circle),
//               child: const Icon(Icons.description_outlined, size: 80, color: Colors.black),
//             ),
//             const SizedBox(height: 25),
//             const Text("No Reports Found",
//                 style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
//             const SizedBox(height: 10),
//             const Padding(
//               padding: EdgeInsets.symmetric(horizontal: 40),
//               child: Text(
//                 "Upload a medical report to generate your AI health analysis",
//                 textAlign: TextAlign.center,
//                 style: TextStyle(color: Colors.black54),
//               ),
//             ),
//           ],
//         ),
//       )
//           : RefreshIndicator(
//         color: Colors.black,
//         onRefresh: loadReports,
//         child: ListView.builder(
//           padding: const EdgeInsets.all(20),
//           itemCount: reports.length,
//           itemBuilder: (context, index) => reportCard(index),
//         ),
//       ),
//     );
//   }
// }


import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

// ─── Data models ─────────────────────────────────────────────────────────────

class DietDay {
  final String title; // e.g. "Day 1"
  final List<MealRow> meals;
  DietDay({required this.title, required this.meals});
}

class MealRow {
  final String meal; // e.g. "Pre-Breakfast"
  final String time; // e.g. "6:00 AM"
  final String foods; // e.g. "Oats with banana"
  MealRow({required this.meal, required this.time, required this.foods});
}

class DietSection {
  final String heading; // non-day section like "Important Note"
  final List<String> bullets;
  DietSection({required this.heading, required this.bullets});
}

// ─── Parser ──────────────────────────────────────────────────────────────────

class DietParser {
  static String _clean(String s) {
    // Remove markdown bold (**text**), heading hashes, leading bullets/numbers
    return s
        .replaceAll(RegExp(r'\*\*'), '')
        .replaceAll(RegExp(r'^#+\s*'), '')
        .replaceAll(RegExp(r'^\*\s*'), '')
        .replaceAll(RegExp(r'^\d+\.\s*'), '')
        .replaceAll(RegExp(r'^-+\s*'), '')
        .trim();
  }

  /// Tries to extract meal name, time, and food from a line like:
  /// "* **Pre-Breakfast (6:00 AM):** Oats with milk"
  /// "* **Dinner (8:00 PM):** Fish Curry"
  static MealRow? tryParseMeal(String raw) {
    final clean = _clean(raw);
    // Match "MealName (Time): Foods" or "MealName (Time) Foods"
    final pattern = RegExp(
        r'^(Pre-Breakfast|Breakfast|Mid-Morning Snack|Lunch|Evening Snack|Dinner|Before Bed|Post-Workout|Pre-Workout|Snack|Morning)[:\s]*\(?([^)]*(?:AM|PM|am|pm)[^)]*)\)?[:\s]*(.*)',
        caseSensitive: false);
    final m = pattern.firstMatch(clean);
    if (m != null) {
      return MealRow(
        meal: m.group(1)!.trim(),
        time: m.group(2)!.trim(),
        foods: m.group(3)!.trim(),
      );
    }
    return null;
  }

  static List<dynamic> parse(String text) {
    // Returns a mixed list of DietDay and DietSection objects
    final lines = text.split('\n').map((l) => l.trim()).toList();

    List<dynamic> result = [];
    DietDay? currentDay;
    DietSection? currentSection;

    for (final line in lines) {
      if (line.isEmpty || line == '-') {
        continue;
      }

      final cleanLine = _clean(line);

      // ── Day header: #### **Day 1** ──────────────────────────────────────────
      if (RegExp(r'^#+\s*\*?\*?Day\s+\d+', caseSensitive: false)
          .hasMatch(line)) {
        if (currentDay != null) result.add(currentDay);
        if (currentSection != null) {
          result.add(currentSection);
          currentSection = null;
        }
        final dayTitle =
        cleanLine.replaceAll(RegExp(r'Day\s+', caseSensitive: false), '');
        currentDay = DietDay(title: 'Day $dayTitle'.trim(), meals: []);
        continue;
      }

      // ── Meal line under a day ────────────────────────────────────────────────
      if (currentDay != null) {
        final meal = tryParseMeal(line);
        if (meal != null) {
          currentDay.meals.add(meal);
          continue;
        }
      }

      // ── Section heading (bold line, not a day, not a meal bullet) ───────────
      if (RegExp(r'^\*\*[^*]+\*\*\s*$').hasMatch(line) ||
          RegExp(r'^#+').hasMatch(line)) {
        if (currentDay != null) {
          result.add(currentDay);
          currentDay = null;
        }
        if (currentSection != null) result.add(currentSection);
        currentSection = DietSection(heading: cleanLine, bullets: []);
        continue;
      }

      // ── Bullet / numbered line ───────────────────────────────────────────────
      if (line.startsWith('*') ||
          line.startsWith('-') ||
          RegExp(r'^\d+\.').hasMatch(line)) {
        if (currentSection != null) {
          currentSection.bullets.add(cleanLine);
        }
        // Ignore misc bullets outside a section when inside a day
        continue;
      }

      // ── Plain text ───────────────────────────────────────────────────────────
      if (currentSection != null && cleanLine.isNotEmpty) {
        currentSection.bullets.add(cleanLine);
      }
    }

    if (currentDay != null) result.add(currentDay);
    if (currentSection != null) result.add(currentSection);

    return result;
  }
}

// ─── Main Page ───────────────────────────────────────────────────────────────

class MyHealthReportsPage extends StatefulWidget {
  const MyHealthReportsPage({super.key});

  @override
  State<MyHealthReportsPage> createState() => _MyHealthReportsPageState();
}

class _MyHealthReportsPageState extends State<MyHealthReportsPage> {
  List reports = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadReports();
  }

  Future<void> loadReports() async {
    SharedPreferences sh = await SharedPreferences.getInstance();
    String url = sh.getString('url') ?? '';
    String lid = sh.getString('lid') ?? '';

    try {
      var summaryRes =
      await http.post(Uri.parse("$url/user_view_ai_summary/"), body: {'lid': lid});
      var dietRes =
      await http.post(Uri.parse("$url/user_view_dietplans/"), body: {'lid': lid});

      var summaryJson = jsonDecode(summaryRes.body);
      var dietJson = jsonDecode(dietRes.body);

      Map<String, Map<String, String>> combined = {};

      if (summaryJson['status'] == 'ok') {
        for (var s in summaryJson['data']) {
          combined[s['title']] = {
            'summary': s['summary'],
            'date': s['date'],
            'diet': ''
          };
        }
      }

      if (dietJson['status'] == 'ok') {
        for (var d in dietJson['data']) {
          if (combined.containsKey(d['title'])) {
            combined[d['title']]!['diet'] = d['dietplan'];
          } else {
            combined[d['title']] = {
              'summary': '',
              'date': d['date'],
              'diet': d['dietplan']
            };
          }
        }
      }

      setState(() {
        reports = combined.entries.toList();
        isLoading = false;
      });
    } catch (e) {
      Fluttertoast.showToast(msg: "Error loading reports");
      setState(() => isLoading = false);
    }
  }

  // ─── SUMMARY MODAL ──────────────────────────────────────────────────────────
  void showSummaryModal(String title, String content) {
    final lines = content
        .split('\n')
        .map((l) => l.trim())
        .where((l) => l.isNotEmpty)
        .toList();

    final items = lines.map((line) {
      final clean = line
          .replaceAll(RegExp(r'\*\*'), '')
          .replaceAll(RegExp(r'^[-•*]\s*'), '')
          .trim();
      final idx = clean.indexOf(':');
      if (idx > 0 && idx < 50) {
        return {'key': clean.substring(0, idx).trim(), 'val': clean.substring(idx + 1).trim()};
      }
      return {'key': '', 'val': clean};
    }).toList();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => DraggableScrollableSheet(
        initialChildSize: 0.6,
        maxChildSize: 0.92,
        minChildSize: 0.35,
        expand: false,
        builder: (_, sc) => Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            children: [
              const SizedBox(height: 12),
              Container(width: 36, height: 4,
                  decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(2))),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(color: Colors.black, borderRadius: BorderRadius.circular(10)),
                    child: const Icon(Icons.psychology_outlined, color: Colors.white, size: 18),
                  ),
                  const SizedBox(width: 12),
                  Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    const Text("AI SUMMARY", style: TextStyle(fontSize: 10, color: Colors.black45, fontWeight: FontWeight.w600, letterSpacing: 0.5)),
                    Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700), maxLines: 1, overflow: TextOverflow.ellipsis),
                  ])),
                ]),
              ),
              const SizedBox(height: 14),
              const Divider(height: 1, color: Color(0xfff0f0f0)),
              Expanded(
                child: ListView.separated(
                  controller: sc,
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  itemCount: items.length,
                  separatorBuilder: (_, __) => const Divider(height: 1, color: Color(0xfff2f2f2)),
                  itemBuilder: (_, i) {
                    final item = items[i];
                    final hasKey = item['key']!.isNotEmpty;
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 11),
                      child: hasKey
                          ? Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        SizedBox(width: 120,
                            child: Text(item['key']!, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.black45))),
                        const SizedBox(width: 8),
                        Expanded(child: Text(item['val']!, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: Colors.black87, height: 1.4))),
                      ])
                          : Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        const Text("• ", style: TextStyle(fontSize: 14, color: Colors.black38, height: 1.4)),
                        Expanded(child: Text(item['val']!, style: const TextStyle(fontSize: 13, color: Colors.black87, height: 1.5))),
                      ]),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
                child: SizedBox(width: double.infinity,
                    child: TextButton(
                      onPressed: () => Navigator.pop(context),
                      style: TextButton.styleFrom(backgroundColor: Colors.black,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                      child: const Text("Close", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
                    )),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ─── DIET MODAL ─────────────────────────────────────────────────────────────
  void showDietModal(String title, String content) {
    final parsed = DietParser.parse(content);
    final days = parsed.whereType<DietDay>().toList();
    final sections = parsed.whereType<DietSection>().toList();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        maxChildSize: 0.95,
        minChildSize: 0.4,
        expand: false,
        builder: (_, sc) => Container(
          decoration: const BoxDecoration(
            color: Color(0xfff7f7f7),
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            children: [
              const SizedBox(height: 12),
              Container(width: 36, height: 4,
                  decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(2))),
              const SizedBox(height: 16),

              // Header
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(color: Colors.green.shade700, borderRadius: BorderRadius.circular(10)),
                    child: const Icon(Icons.restaurant_menu, color: Colors.white, size: 18),
                  ),
                  const SizedBox(width: 12),
                  Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    const Text("DIET PLAN", style: TextStyle(fontSize: 10, color: Colors.black45, fontWeight: FontWeight.w600, letterSpacing: 0.5)),
                    Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700), maxLines: 1, overflow: TextOverflow.ellipsis),
                  ])),
                ]),
              ),
              const SizedBox(height: 16),

              // Content
              Expanded(
                child: ListView(
                  controller: sc,
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                  children: [

                    // ── Info sections (notes, principles, etc.) ───────────────
                    ...sections.map((sec) => _SectionCard(section: sec)),

                    // ── Day-by-day meal tables ────────────────────────────────
                    if (days.isEmpty && sections.isEmpty)
                    // Fallback: raw text
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14)),
                        child: Text(content, style: const TextStyle(fontSize: 13, height: 1.6, color: Colors.black87)),
                      )
                    else
                      ...days.map((day) => _DayTable(day: day)),
                  ],
                ),
              ),

              Padding(
                padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
                child: SizedBox(width: double.infinity,
                    child: TextButton(
                      onPressed: () => Navigator.pop(context),
                      style: TextButton.styleFrom(backgroundColor: Colors.black,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                      child: const Text("Close", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
                    )),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ─── BUILD ───────────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff7f7f7),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        title: const Text("Health Reports",
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600, fontSize: 17)),
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: Divider(height: 1, color: Color(0xffe0e0e0)),
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator(strokeWidth: 2, color: Colors.black))
          : reports.isEmpty
          ? Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: const [
          Icon(Icons.description_outlined, size: 48, color: Colors.black26),
          SizedBox(height: 12),
          Text("No Reports Found", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
          SizedBox(height: 6),
          Text("Upload a medical report to get started", style: TextStyle(fontSize: 13, color: Colors.black45)),
        ]),
      )
          : RefreshIndicator(
        color: Colors.black,
        onRefresh: loadReports,
        child: Column(children: [
          // Table header
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Row(children: const [
              Expanded(flex: 5, child: Text("REPORT",
                  style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Colors.black45, letterSpacing: 0.6))),
              Expanded(flex: 3, child: Text("DATE",
                  style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Colors.black45, letterSpacing: 0.6))),
              Expanded(flex: 4, child: Text("ACTIONS", textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Colors.black45, letterSpacing: 0.6))),
            ]),
          ),
          const Divider(height: 1, color: Color(0xffe0e0e0)),

          Expanded(
            child: ListView.separated(
              itemCount: reports.length,
              separatorBuilder: (_, __) => const Divider(height: 1, color: Color(0xffe8e8e8), indent: 16),
              itemBuilder: (context, index) {
                var entry = reports[index];
                String title = entry.key;
                String summary = entry.value['summary'] ?? '';
                String diet = entry.value['diet'] ?? '';
                String date = entry.value['date'] ?? '';

                return Container(
                  color: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  child: Row(children: [
                    Expanded(flex: 5, child: Row(children: [
                      Container(
                        width: 30, height: 30,
                        decoration: BoxDecoration(color: const Color(0xfff0f0f0), borderRadius: BorderRadius.circular(8)),
                        child: const Icon(Icons.description_outlined, size: 16, color: Colors.black54),
                      ),
                      const SizedBox(width: 10),
                      Expanded(child: Text(title,
                          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: Colors.black87),
                          maxLines: 2, overflow: TextOverflow.ellipsis)),
                    ])),
                    Expanded(flex: 3, child: Text(date,
                        style: const TextStyle(fontSize: 12, color: Colors.black45))),
                    Expanded(flex: 4, child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _ActionChip(label: "Summary", enabled: summary.isNotEmpty, color: Colors.black,
                            onTap: summary.isEmpty ? null : () => showSummaryModal(title, summary)),
                        const SizedBox(width: 6),
                        _ActionChip(label: "Diet", enabled: diet.isNotEmpty, color: Colors.green.shade700,
                            onTap: diet.isEmpty ? null : () => showDietModal(title, diet)),
                      ],
                    )),
                  ]),
                );
              },
            ),
          ),
        ]),
      ),
    );
  }
}

// ─── Day meal table widget ────────────────────────────────────────────────────
class _DayTable extends StatelessWidget {
  final DietDay day;
  const _DayTable({required this.day});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8, offset: const Offset(0, 2))],
      ),
      child: Column(
        children: [
          // Day header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: const BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.vertical(top: Radius.circular(14)),
            ),
            child: Row(children: [
              const Icon(Icons.calendar_today, color: Colors.white, size: 14),
              const SizedBox(width: 8),
              Text(day.title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 14)),
            ]),
          ),

          // Column headers
          Container(
            color: const Color(0xfff5f5f5),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            child: Row(children: const [
              SizedBox(width: 110, child: Text("MEAL / TIME",
                  style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: Colors.black45, letterSpacing: 0.4))),
              SizedBox(width: 8),
              Expanded(child: Text("FOOD ITEMS",
                  style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: Colors.black45, letterSpacing: 0.4))),
            ]),
          ),
          const Divider(height: 1, color: Color(0xfff0f0f0)),

          // Meal rows
          if (day.meals.isEmpty)
            const Padding(
              padding: EdgeInsets.all(16),
              child: Text("No meal details available", style: TextStyle(fontSize: 13, color: Colors.black38)),
            )
          else
            ...day.meals.asMap().entries.map((e) {
              final i = e.key;
              final meal = e.value;
              final isEven = i % 2 == 0;
              return Container(
                color: isEven ? Colors.white : const Color(0xfff9f9f9),
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
                child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  // Meal + time column
                  SizedBox(
                    width: 110,
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text(meal.meal,
                          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: Colors.black87)),
                      if (meal.time.isNotEmpty)
                        Text(meal.time,
                            style: const TextStyle(fontSize: 11, color: Colors.black38, fontWeight: FontWeight.w500)),
                    ]),
                  ),
                  const SizedBox(width: 8),
                  // Food column
                  Expanded(
                    child: Text(meal.foods.isEmpty ? '-' : meal.foods,
                        style: const TextStyle(fontSize: 13, color: Colors.black54, height: 1.4)),
                  ),
                ]),
              );
            }),

          const SizedBox(height: 4),
        ],
      ),
    );
  }
}

// ─── Info section card widget ─────────────────────────────────────────────────
class _SectionCard extends StatelessWidget {
  final DietSection section;
  const _SectionCard({required this.section});

  @override
  Widget build(BuildContext context) {
    if (section.bullets.isEmpty) return const SizedBox.shrink();
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8, offset: const Offset(0, 2))],
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        // Section heading
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(14)),
          ),
          child: Text(section.heading,
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: Colors.black87)),
        ),
        // Bullets
        ...section.bullets.asMap().entries.map((e) {
          final isLast = e.key == section.bullets.length - 1;
          return Column(children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                const Text("• ", style: TextStyle(fontSize: 13, color: Colors.black38, height: 1.5)),
                Expanded(child: Text(e.value,
                    style: const TextStyle(fontSize: 13, color: Colors.black54, height: 1.5))),
              ]),
            ),
            if (!isLast) const Divider(height: 1, indent: 14, color: Color(0xfff2f2f2)),
          ]);
        }),
        const SizedBox(height: 4),
      ]),
    );
  }
}

// ─── Action chip ─────────────────────────────────────────────────────────────
class _ActionChip extends StatelessWidget {
  final String label;
  final bool enabled;
  final Color color;
  final VoidCallback? onTap;

  const _ActionChip({required this.label, required this.enabled, required this.color, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
        decoration: BoxDecoration(
          color: enabled ? color : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Text(label,
            style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600,
                color: enabled ? Colors.white : Colors.black26)),
      ),
    );
  }
}