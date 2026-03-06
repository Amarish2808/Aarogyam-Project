//
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:fluttertoast/fluttertoast.dart';
//
// import 'view_workout_routine.dart';
// import 'view_daily_plan.dart';
//
// class ViewWorkoutLevelsPage extends StatefulWidget {
//   final String trainerId;
//
//   const ViewWorkoutLevelsPage({super.key, required this.trainerId});
//
//   @override
//   State<ViewWorkoutLevelsPage> createState() => _ViewWorkoutLevelsPageState();
// }
//
// class _ViewWorkoutLevelsPageState extends State<ViewWorkoutLevelsPage> {
//
//   List<String> level_id_ = [];
//   List<String> title_ = [];
//   List<String> desc_ = [];
//
//   bool isLoading = true;
//
//   Future<void> loadLevels() async {
//
//     try {
//
//       SharedPreferences sh = await SharedPreferences.getInstance();
//       String url = sh.getString('url') ?? '';
//
//       final response = await http.post(
//         Uri.parse('$url/user_view_trainer_levels/'),
//         body: {
//           'trainer_id': widget.trainerId
//         },
//       );
//
//       var jsondata = jsonDecode(response.body);
//
//       if (jsondata['status'] == 'ok') {
//
//         var arr = jsondata['data'];
//
//         level_id_.clear();
//         title_.clear();
//         desc_.clear();
//
//         for (var l in arr) {
//
//           level_id_.add(l['level_id'].toString());
//           title_.add(l['title']);
//           desc_.add(l['description']);
//
//         }
//
//       }
//
//     } catch (e) {
//
//       Fluttertoast.showToast(msg: e.toString());
//
//     }
//
//     setState(() {
//       isLoading = false;
//     });
//
//   }
//
//   @override
//   void initState() {
//     super.initState();
//     loadLevels();
//   }
//
//
//   /// DAYS POPUP
//   void showDayPopup(String levelId,String levelName){
//
//     List<String> days = [
//       "Monday",
//       "Tuesday",
//       "Wednesday",
//       "Thursday",
//       "Friday",
//       "Saturday"
//     ];
//
//     showModalBottomSheet(
//
//       context: context,
//
//       shape: const RoundedRectangleBorder(
//         borderRadius: BorderRadius.vertical(
//             top: Radius.circular(20)),
//       ),
//
//       builder: (_) {
//
//         return Padding(
//
//           padding: const EdgeInsets.all(20),
//
//           child: Column(
//
//             mainAxisSize: MainAxisSize.min,
//
//             children: days.map((day){
//
//               return ListTile(
//
//                 title: Text(day),
//
//                 trailing: const Icon(
//                     Icons.arrow_forward_ios,
//                     size: 16),
//
//                 onTap: () {
//
//                   /// KEEP DAY POPUP
//                   /// OPEN ACTION POPUP
//
//                   showActionPopup(levelId,levelName,day);
//
//                 },
//
//               );
//
//             }).toList(),
//
//           ),
//
//         );
//
//       },
//
//     );
//
//   }
//
//
//
//   /// ACTION POPUP
//   void showActionPopup(
//       String levelId,
//       String levelName,
//       String day){
//
//     showModalBottomSheet(
//
//       context: context,
//
//       shape: const RoundedRectangleBorder(
//         borderRadius: BorderRadius.vertical(
//             top: Radius.circular(20)),
//       ),
//
//       builder: (_) {
//
//         return Padding(
//
//           padding: const EdgeInsets.all(20),
//
//           child: Column(
//
//             mainAxisSize: MainAxisSize.min,
//
//             children: [
//
//               ListTile(
//
//                 leading: const Icon(
//                     Icons.fitness_center),
//
//                 title: const Text(
//                     "Workout Routine"),
//
//                 onTap: () {
//
//                   Navigator.push(
//
//                     context,
//
//                     MaterialPageRoute(
//
//                       builder: (_) =>
//                           ViewWorkoutRoutinePage(
//
//                             trainerId:
//                             widget.trainerId,
//
//                             levelId:
//                             levelId,
//
//                             levelName:
//                             levelName,
//
//                             day:
//                             day,
//
//                           ),
//
//                     ),
//
//                   );
//
//                 },
//
//               ),
//
//
//               ListTile(
//
//                 leading: const Icon(
//                     Icons.calendar_today),
//
//                 title: const Text(
//                     "Daily Exercise Plan"),
//
//                 onTap: () {
//
//                   Navigator.push(
//
//                     context,
//
//                     MaterialPageRoute(
//
//                       builder: (_) =>
//                           ViewDailyPlanPage(
//
//                             trainerId:
//                             widget.trainerId,
//
//                             levelId:
//                             levelId,
//
//                             levelName:
//                             levelName,
//
//                             day:
//                             day,
//
//                           ),
//
//                     ),
//
//                   );
//
//                 },
//
//               ),
//
//             ],
//
//           ),
//
//         );
//
//       },
//
//     );
//
//   }
//
//
//
//
//   /// UI
//   @override
//   Widget build(BuildContext context) {
//
//     return Scaffold(
//
//       backgroundColor: const Color(0xfff2f2f2),
//
//       appBar: AppBar(
//
//         backgroundColor: Colors.black,
//
//         iconTheme:
//         const IconThemeData(
//             color: Colors.white),
//
//         title: const Text(
//
//           "Workout Levels",
//
//           style: TextStyle(
//               color: Colors.white,
//               fontWeight: FontWeight.bold),
//
//         ),
//
//         elevation: 0,
//
//       ),
//
//       body: isLoading ?
//
//       const Center(
//           child:
//           CircularProgressIndicator(
//               color: Colors.black))
//
//           :
//
//       ListView.builder(
//
//         padding: const EdgeInsets.all(20),
//
//         itemCount: title_.length,
//
//         itemBuilder: (context,index){
//
//           return GestureDetector(
//
//             onTap: (){
//
//               showDayPopup(
//                   level_id_[index],
//                   title_[index]);
//
//             },
//
//             child: Container(
//
//               margin:
//               const EdgeInsets.only(
//                   bottom: 20),
//
//               decoration: BoxDecoration(
//
//                 color: Colors.white,
//
//                 borderRadius:
//                 BorderRadius.circular(20),
//
//                 boxShadow: [
//
//                   BoxShadow(
//
//                     color: Colors.black
//                         .withOpacity(0.08),
//
//                     blurRadius: 20,
//
//                     offset:
//                     const Offset(0,10),
//
//                   )
//
//                 ],
//
//               ),
//
//               child: Column(
//
//                 children: [
//
//                   /// HEADER
//
//                   Container(
//
//                     padding:
//                     const EdgeInsets.all(20),
//
//                     decoration: BoxDecoration(
//
//                       gradient: LinearGradient(
//
//                         begin:
//                         Alignment.topLeft,
//
//                         end:
//                         Alignment.bottomRight,
//
//                         colors: [
//
//                           Colors.black,
//
//                           Colors.grey.shade800,
//
//                         ],
//
//                       ),
//
//                       borderRadius:
//                       const BorderRadius.vertical(
//                         top: Radius.circular(20),
//                       ),
//
//                     ),
//
//                     child: Row(
//
//                       children: [
//
//                         Container(
//
//                           padding:
//                           const EdgeInsets.all(10),
//
//                           decoration:
//                           BoxDecoration(
//
//                             color: Colors.white
//                                 .withOpacity(0.15),
//
//                             borderRadius:
//                             BorderRadius.circular(10),
//
//                           ),
//
//                           child: const Icon(
//
//                             Icons.layers,
//
//                             color: Colors.white,
//
//                             size: 24,
//
//                           ),
//
//                         ),
//
//                         const SizedBox(width: 12),
//
//                         Expanded(
//
//                           child: Text(
//
//                             title_[index],
//
//                             style: const TextStyle(
//
//                               color: Colors.white,
//
//                               fontSize: 20,
//
//                               fontWeight: FontWeight.bold,
//
//                             ),
//
//                           ),
//
//                         ),
//
//                       ],
//
//                     ),
//
//                   ),
//
//
//                   /// BODY
//
//                   Padding(
//
//                     padding:
//                     const EdgeInsets.all(20),
//
//                     child: Container(
//
//                       width: double.infinity,
//
//                       padding:
//                       const EdgeInsets.all(16),
//
//                       decoration:
//                       BoxDecoration(
//
//                         color:
//                         Colors.black.withOpacity(0.03),
//
//                         borderRadius:
//                         BorderRadius.circular(12),
//
//                         border: Border.all(
//
//                           color:
//                           Colors.black.withOpacity(0.08),
//
//                         ),
//
//                       ),
//
//                       child: Text(
//
//                         desc_[index],
//
//                         style: const TextStyle(
//
//                           fontSize: 15,
//
//                           color: Colors.black87,
//
//                           height: 1.4,
//
//                         ),
//
//                       ),
//
//                     ),
//
//                   ),
//
//                 ],
//
//               ),
//
//             ),
//
//           );
//
//         },
//
//       ),
//
//     );
//
//   }
//
// }


import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'view_workout_routine.dart';
import 'view_daily_plan.dart';

class ViewWorkoutLevelsPage extends StatefulWidget {
  final String trainerId;

  const ViewWorkoutLevelsPage({super.key, required this.trainerId});

  @override
  State<ViewWorkoutLevelsPage> createState() => _ViewWorkoutLevelsPageState();
}

class _ViewWorkoutLevelsPageState extends State<ViewWorkoutLevelsPage> {
  List<String> level_id_ = [];
  List<String> title_ = [];
  List<String> desc_ = [];

  bool isLoading = true;

  Future<void> loadLevels() async {
    try {
      SharedPreferences sh = await SharedPreferences.getInstance();
      String url = sh.getString('url') ?? '';

      final response = await http.post(
        Uri.parse('$url/user_view_trainer_levels/'),
        body: {'trainer_id': widget.trainerId},
      );

      var jsondata = jsonDecode(response.body);

      if (jsondata['status'] == 'ok') {
        var arr = jsondata['data'];

        level_id_.clear();
        title_.clear();
        desc_.clear();

        for (var l in arr) {
          level_id_.add(l['level_id'].toString());
          title_.add(l['title']);
          desc_.add(l['description']);
        }
      }
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());
    }

    setState(() => isLoading = false);
  }

  @override
  void initState() {
    super.initState();
    loadLevels();
  }

  // ── DAYS POPUP ──
  void showDayPopup(String levelId, String levelName) {
    final List<Map<String, dynamic>> days = [
      {'name': 'Monday',    'icon': Icons.looks_one_outlined},
      {'name': 'Tuesday',   'icon': Icons.looks_two_outlined},
      {'name': 'Wednesday', 'icon': Icons.looks_3_outlined},
      {'name': 'Thursday',  'icon': Icons.looks_4_outlined},
      {'name': 'Friday',    'icon': Icons.looks_5_outlined},
      {'name': 'Saturday',  'icon': Icons.looks_6_outlined},
    ];

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Handle bar
              Container(
                margin: const EdgeInsets.only(top: 12, bottom: 4),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.black12,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),

              // Sheet header
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 16, 24, 8),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(Icons.calendar_month,
                          color: Colors.white, size: 18),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Select Day",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 17,
                            color: Colors.black87,
                          ),
                        ),
                        Text(
                          levelName,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.black45,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 24),
                child: Divider(height: 1),
              ),

              const SizedBox(height: 8),

              ...days.map((day) {
                return InkWell(
                  onTap: () => showActionPopup(levelId, levelName, day['name']),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 4),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 14),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade50,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: Colors.black.withOpacity(0.06)),
                      ),
                      child: Row(
                        children: [
                          Icon(day['icon'] as IconData,
                              color: Colors.black54, size: 20),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Text(
                              day['name'] as String,
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                color: Colors.black87,
                              ),
                            ),
                          ),
                          const Icon(Icons.arrow_forward_ios,
                              size: 14, color: Colors.black38),
                        ],
                      ),
                    ),
                  ),
                );
              }),

              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  // ── ACTION POPUP ──
  void showActionPopup(String levelId, String levelName, String day) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Handle bar
              Container(
                margin: const EdgeInsets.only(top: 12, bottom: 4),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.black12,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),

              // Sheet header
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 16, 24, 8),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(Icons.bolt,
                          color: Colors.white, size: 18),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          day,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 17,
                            color: Colors.black87,
                          ),
                        ),
                        Text(
                          levelName,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.black45,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 24),
                child: Divider(height: 1),
              ),

              const SizedBox(height: 12),

              // Workout Routine tile
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                child: InkWell(
                  borderRadius: BorderRadius.circular(14),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ViewWorkoutRoutinePage(
                          trainerId: widget.trainerId,
                          levelId: levelId,
                          levelName: levelName,
                          day: day,
                        ),
                      ),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 16),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.black, Colors.grey.shade800],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.fitness_center,
                            color: Colors.white, size: 22),
                        SizedBox(width: 14),
                        Expanded(
                          child: Text(
                            "Workout Routine",
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        Icon(Icons.arrow_forward_ios,
                            size: 14, color: Colors.white54),
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 10),

              // Daily Exercise Plan tile
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                child: InkWell(
                  borderRadius: BorderRadius.circular(14),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ViewDailyPlanPage(
                          trainerId: widget.trainerId,
                          levelId: levelId,
                          levelName: levelName,
                          day: day,
                        ),
                      ),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 16),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade50,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                          color: Colors.black.withOpacity(0.1)),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.calendar_today,
                            color: Colors.grey.shade700, size: 22),
                        const SizedBox(width: 14),
                        const Expanded(
                          child: Text(
                            "Daily Exercise Plan",
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                        Icon(Icons.arrow_forward_ios,
                            size: 14, color: Colors.grey.shade400),
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 24),
            ],
          ),
        );
      },
    );
  }

  // ── UI ──
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff2f2f2),
      appBar: AppBar(
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          "Workout Levels",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        elevation: 0,
      ),
      body: isLoading
          ? const Center(
          child: CircularProgressIndicator(color: Colors.black))
          : title_.isEmpty
          ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(30),
              decoration: const BoxDecoration(
                color: Colors.black12,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.layers_outlined,
                  size: 80, color: Colors.black),
            ),
            const SizedBox(height: 30),
            const Text(
              "No Levels Available",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 10),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 40),
              child: Text(
                "This trainer hasn't added any workout levels yet",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.black54, fontSize: 15),
              ),
            ),
          ],
        ),
      )
          : ListView.builder(
        padding: const EdgeInsets.all(20),
        itemCount: title_.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () =>
                showDayPopup(level_id_[index], title_[index]),
            child: Container(
              margin: const EdgeInsets.only(bottom: 20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  )
                ],
              ),
              child: Column(
                children: [
                  // ── HEADER ──
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Colors.black,
                          Colors.grey.shade800,
                        ],
                      ),
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(20),
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(Icons.layers,
                              color: Colors.white, size: 24),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            title_[index],
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        // Tap hint badge
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                                color:
                                Colors.white.withOpacity(0.25)),
                          ),
                          child: const Row(
                            children: [
                              Icon(Icons.touch_app,
                                  color: Colors.white70, size: 14),
                              SizedBox(width: 4),
                              Text(
                                "Start",
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  // ── BODY ──
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Description
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.03),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: Colors.black.withOpacity(0.08),
                            ),
                          ),
                          child: Text(
                            desc_[index],
                            style: const TextStyle(
                              fontSize: 15,
                              color: Colors.black87,
                              height: 1.5,
                            ),
                          ),
                        ),

                        const SizedBox(height: 16),

                        // Days quick-view row
                        Row(
                          children: [
                            const Icon(Icons.calendar_month_outlined,
                                size: 15, color: Colors.black45),
                            const SizedBox(width: 6),
                            const Text(
                              "Mon – Sat",
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.black45,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const Spacer(),
                            // Arrow hint
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: Colors.black,
                                borderRadius:
                                BorderRadius.circular(20),
                              ),
                              child: const Row(
                                children: [
                                  Text(
                                    "Select Day",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  SizedBox(width: 4),
                                  Icon(Icons.arrow_forward,
                                      color: Colors.white, size: 14),
                                ],
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
        },
      ),
    );
  }
}