//
//
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:shared_preferences/shared_preferences.dart';
//
// import 'feedback.dart';
// import 'view_workout_levels.dart';
//
// class ViewTrainersPage extends StatefulWidget {
//   final String gymId;
//
//   const ViewTrainersPage({super.key, required this.gymId});
//
//   @override
//   State<ViewTrainersPage> createState() => _ViewTrainersPageState();
// }
//
// class _ViewTrainersPageState extends State<ViewTrainersPage> {
//   List<String> trainer_id_ = [];
//   List<String> name_ = [];
//   List<String> email_ = [];
//   List<String> phone_ = [];
//   List<String> qualification_ = [];
//   List<String> experience_ = [];
//
//   bool isLoading = true;
//
//   Future<void> loadTrainers() async {
//     try {
//       SharedPreferences sh = await SharedPreferences.getInstance();
//       String url = sh.getString('url') ?? '';
//       String lid = sh.getString('lid') ?? '';
//
//       final response = await http.post(
//         Uri.parse('$url/user_view_gym_trainers/'),
//         body: {'gym_id': widget.gymId, 'lid': lid},
//       );
//
//       var jsondata = jsonDecode(response.body);
//
//       // 🔴 NEVER PAID
//       if (jsondata['status'] == 'not_paid') {
//         Fluttertoast.showToast(
//           msg: "Please purchase membership to access trainers.",
//           backgroundColor: Colors.red,
//         );
//         Navigator.pop(context);
//         return;
//       }
//
//       // 🔴 EXPIRED
//       if (jsondata['status'] == 'expired') {
//         Fluttertoast.showToast(
//           msg: "Membership expired. Please renew your plan.",
//           backgroundColor: Colors.red,
//         );
//         Navigator.pop(context);
//         return;
//       }
//
//       // 🟢 ACTIVE MEMBER
//       if (jsondata['status'] == 'ok') {
//         var arr = jsondata['data'];
//
//         trainer_id_.clear();
//         name_.clear();
//         email_.clear();
//         phone_.clear();
//         qualification_.clear();
//         experience_.clear();
//
//         for (var t in arr) {
//           trainer_id_.add(t['trainer_id'].toString());
//           name_.add(t['name']);
//           email_.add(t['email']);
//           phone_.add(t['phone']);
//           qualification_.add(t['qualification']);
//           experience_.add(t['experience']);
//         }
//       }
//     } catch (e) {
//       Fluttertoast.showToast(msg: e.toString());
//     }
//
//     setState(() => isLoading = false);
//   }
//
//   @override
//   void initState() {
//     super.initState();
//     loadTrainers();
//   }
//
//   Widget info(IconData icon, String text) {
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 12),
//       child: Row(
//         children: [
//           Icon(icon, color: Colors.black54, size: 20),
//           const SizedBox(width: 12),
//           Expanded(
//             child: Text(
//               text,
//               style: const TextStyle(
//                 color: Colors.black87,
//                 fontSize: 15,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget actionButton({
//     required String text,
//     required IconData icon,
//     required Color color,
//     required VoidCallback onPressed,
//   }) {
//     return SizedBox(
//       width: double.infinity,
//       child: ElevatedButton.icon(
//         onPressed: onPressed,
//         icon: Icon(icon, color: Colors.white),
//         label: Text(
//           text,
//           style: const TextStyle(
//             fontWeight: FontWeight.bold,
//             color: Colors.white,
//           ),
//         ),
//         style: ElevatedButton.styleFrom(
//           backgroundColor: color,
//           padding: const EdgeInsets.symmetric(vertical: 15),
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(12),
//           ),
//           elevation: 0,
//         ),
//       ),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xfff2f2f2),
//       appBar: AppBar(
//         backgroundColor: Colors.black,
//         iconTheme: const IconThemeData(color: Colors.white),
//         title: const Text(
//           "Gym Trainers",
//           style: TextStyle(
//             color: Colors.white,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//         elevation: 0,
//       ),
//       body: isLoading
//           ? const Center(child: CircularProgressIndicator(color: Colors.black))
//           : name_.isEmpty
//           ? Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Container(
//               padding: const EdgeInsets.all(30),
//               decoration: const BoxDecoration(
//                 color: Colors.black12,
//                 shape: BoxShape.circle,
//               ),
//               child: const Icon(
//                 Icons.person_outline,
//                 size: 80,
//                 color: Colors.black,
//               ),
//             ),
//             const SizedBox(height: 30),
//             const Text(
//               "No Trainers Available",
//               style: TextStyle(
//                 fontSize: 22,
//                 fontWeight: FontWeight.bold,
//                 color: Colors.black,
//               ),
//             ),
//             const SizedBox(height: 10),
//             const Padding(
//               padding: EdgeInsets.symmetric(horizontal: 40),
//               child: Text(
//                 "This gym hasn't added any trainers yet",
//                 textAlign: TextAlign.center,
//                 style: TextStyle(
//                   color: Colors.black54,
//                   fontSize: 15,
//                 ),
//               ),
//             ),
//           ],
//         ),
//       )
//           : ListView.builder(
//         padding: const EdgeInsets.all(20),
//         itemCount: name_.length,
//         itemBuilder: (context, index) {
//           return Container(
//             margin: const EdgeInsets.only(bottom: 20),
//             decoration: BoxDecoration(
//               color: Colors.white,
//               borderRadius: BorderRadius.circular(20),
//               boxShadow: [
//                 BoxShadow(
//                   color: Colors.black.withOpacity(0.08),
//                   blurRadius: 20,
//                   offset: const Offset(0, 10),
//                 )
//               ],
//             ),
//             child: Column(
//               children: [
//                 // HEADER
//                 Container(
//                   padding: const EdgeInsets.all(20),
//                   decoration: BoxDecoration(
//                     gradient: LinearGradient(
//                       begin: Alignment.topLeft,
//                       end: Alignment.bottomRight,
//                       colors: [
//                         Colors.black,
//                         Colors.grey.shade800,
//                       ],
//                     ),
//                     borderRadius: const BorderRadius.vertical(
//                       top: Radius.circular(20),
//                     ),
//                   ),
//                   child: Row(
//                     children: [
//                       Container(
//                         padding: const EdgeInsets.all(10),
//                         decoration: BoxDecoration(
//                           color: Colors.white.withOpacity(0.15),
//                           borderRadius: BorderRadius.circular(10),
//                         ),
//                         child: const Icon(
//                           Icons.person,
//                           color: Colors.white,
//                           size: 24,
//                         ),
//                       ),
//                       const SizedBox(width: 12),
//                       Expanded(
//                         child: Text(
//                           name_[index],
//                           style: const TextStyle(
//                             color: Colors.white,
//                             fontSize: 20,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//
//                 // BODY
//                 Padding(
//                   padding: const EdgeInsets.all(20),
//                   child: Column(
//                     children: [
//                       info(Icons.email_outlined, email_[index]),
//                       info(Icons.phone_outlined, phone_[index]),
//                       info(Icons.school_outlined, qualification_[index]),
//                       info(Icons.work_outline, "${experience_[index]} years experience"),
//
//                       const SizedBox(height: 20),
//
//                       // WORKOUT LEVELS BUTTON
//                       actionButton(
//                         text: "View Workout Levels",
//                         icon: Icons.fitness_center,
//                         color: Colors.black,
//                         onPressed: () {
//                           Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                               builder: (_) => ViewWorkoutLevelsPage(
//                                 trainerId: trainer_id_[index],
//                               ),
//                             ),
//                           );
//                         },
//                       ),
//
//                       const SizedBox(height: 12),
//
//                       // FEEDBACK BUTTON
//                       actionButton(
//                         text: "Give Feedback",
//                         icon: Icons.rate_review_outlined,
//                         color: Colors.grey.shade700,
//                         onPressed: () {
//                           Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                               builder: (_) => FeedbackPage(
//                                 trainerId: trainer_id_[index],
//                                 trainerName: name_[index],
//                               ),
//                             ),
//                           );
//                         },
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           );
//         },
//       ),
//     );
//   }
// }



import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'feedback.dart';
import 'view_workout_levels.dart';

class ViewTrainersPage extends StatefulWidget {
  final String gymId;

  const ViewTrainersPage({super.key, required this.gymId});

  @override
  State<ViewTrainersPage> createState() => _ViewTrainersPageState();
}

class _ViewTrainersPageState extends State<ViewTrainersPage> {
  List<String> trainer_id_ = [];
  List<String> name_ = [];
  List<String> email_ = [];
  List<String> phone_ = [];
  List<String> qualification_ = [];
  List<String> experience_ = [];
  List<String> image_ = [];   // ← NEW

  bool isLoading = true;

  Future<void> loadTrainers() async {
    try {
      SharedPreferences sh = await SharedPreferences.getInstance();
      String url = sh.getString('url') ?? '';
      String lid = sh.getString('lid') ?? '';

      final response = await http.post(
        Uri.parse('$url/user_view_gym_trainers/'),
        body: {'gym_id': widget.gymId, 'lid': lid},
      );

      var jsondata = jsonDecode(response.body);

      // 🔴 NEVER PAID
      if (jsondata['status'] == 'not_paid') {
        Fluttertoast.showToast(
          msg: "Please purchase membership to access trainers.",
          backgroundColor: Colors.red,
        );
        Navigator.pop(context);
        return;
      }

      // 🔴 EXPIRED
      if (jsondata['status'] == 'expired') {
        Fluttertoast.showToast(
          msg: "Membership expired. Please renew your plan.",
          backgroundColor: Colors.red,
        );
        Navigator.pop(context);
        return;
      }

      // 🟢 ACTIVE MEMBER
      if (jsondata['status'] == 'ok') {
        var arr = jsondata['data'];

        trainer_id_.clear();
        name_.clear();
        email_.clear();
        phone_.clear();
        qualification_.clear();
        experience_.clear();
        image_.clear();   // ← NEW

        for (var t in arr) {
          trainer_id_.add(t['trainer_id'].toString());
          name_.add(t['name']);
          email_.add(t['email']);
          phone_.add(t['phone']);
          qualification_.add(t['qualification']);
          experience_.add(t['experience']);
          image_.add(t['image'] ?? '');   // ← NEW
        }
      }
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());
    }

    setState(() => isLoading = false);
  }

  // ---------------- INSTAGRAM-STYLE IMAGE POPUP ----------------
  void _showImagePopup(BuildContext context, String imageUrl, String trainerName) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Close',
      barrierColor: Colors.black.withOpacity(0.85),
      transitionDuration: const Duration(milliseconds: 280),
      transitionBuilder: (context, anim, secondAnim, child) {
        return ScaleTransition(
          scale: CurvedAnimation(
            parent: anim,
            curve: Curves.easeOutBack,
          ),
          child: FadeTransition(
            opacity: anim,
            child: child,
          ),
        );
      },
      pageBuilder: (context, anim, secondAnim) {
        return GestureDetector(
          onTap: () => Navigator.of(context).pop(),
          child: Scaffold(
            backgroundColor: Colors.transparent,
            body: GestureDetector(
              onTap: () {}, // prevent dismiss when tapping image
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Close button
                    Padding(
                      padding: const EdgeInsets.only(right: 16, bottom: 12),
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: GestureDetector(
                          onTap: () => Navigator.of(context).pop(),
                          child: Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.15),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.close,
                              color: Colors.white,
                              size: 22,
                            ),
                          ),
                        ),
                      ),
                    ),

                    // Image card
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 24),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.4),
                            blurRadius: 40,
                            offset: const Offset(0, 16),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // Full image
                            imageUrl.isNotEmpty
                                ? Image.network(
                              imageUrl,
                              fit: BoxFit.cover,
                              width: double.infinity,
                              height: 320,
                              loadingBuilder: (ctx, child, prog) {
                                if (prog == null) return child;
                                return SizedBox(
                                  height: 320,
                                  child: Center(
                                    child: CircularProgressIndicator(
                                      value: prog.expectedTotalBytes != null
                                          ? prog.cumulativeBytesLoaded /
                                          prog.expectedTotalBytes!
                                          : null,
                                      color: Colors.black,
                                    ),
                                  ),
                                );
                              },
                              errorBuilder: (_, __, ___) =>
                                  _imagePlaceholder(height: 320),
                            )
                                : _imagePlaceholder(height: 320),

                            // Trainer name footer
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 18, vertical: 14),
                              child: Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(7),
                                    decoration: BoxDecoration(
                                      color: Colors.black,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: const Icon(
                                      Icons.person,
                                      color: Colors.white,
                                      size: 18,
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Text(
                                      trainerName,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                        color: Colors.black87,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _imagePlaceholder({double height = 80}) {
    return Container(
      height: height,
      width: double.infinity,
      color: Colors.grey.shade200,
      child: const Center(
        child: Icon(Icons.person, size: 48, color: Colors.black38),
      ),
    );
  }

  Widget _fallbackAvatar() {
    return Container(
      color: Colors.grey.shade700,
      child: const Icon(Icons.person, color: Colors.white, size: 26),
    );
  }

  @override
  void initState() {
    super.initState();
    loadTrainers();
  }

  Widget info(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(icon, color: Colors.black54, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                color: Colors.black87,
                fontSize: 15,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget actionButton({
    required String text,
    required IconData icon,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, color: Colors.white),
        label: Text(
          text,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          padding: const EdgeInsets.symmetric(vertical: 15),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 0,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff2f2f2),
      appBar: AppBar(
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          "Gym Trainers",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        elevation: 0,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.black))
          : name_.isEmpty
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
              child: const Icon(
                Icons.person_outline,
                size: 80,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 30),
            const Text(
              "No Trainers Available",
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
                "This gym hasn't added any trainers yet",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black54,
                  fontSize: 15,
                ),
              ),
            ),
          ],
        ),
      )
          : ListView.builder(
        padding: const EdgeInsets.all(20),
        itemCount: name_.length,
        itemBuilder: (context, index) {
          return Container(
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
                // HEADER
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
                        child: const Icon(
                          Icons.person,
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          name_[index],
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),

                      // ── TRAINER PROFILE PIC (right side) ──
                      GestureDetector(
                        onTap: () => _showImagePopup(
                          context,
                          image_[index],
                          name_[index],
                        ),
                        child: Container(
                          width: 52,
                          height: 52,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.white.withOpacity(0.5),
                              width: 2,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.25),
                                blurRadius: 8,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: ClipOval(
                            child: image_[index].isNotEmpty
                                ? Image.network(
                              image_[index],
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) =>
                                  _fallbackAvatar(),
                            )
                                : _fallbackAvatar(),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // BODY
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      info(Icons.email_outlined, email_[index]),
                      info(Icons.phone_outlined, phone_[index]),
                      info(Icons.school_outlined, qualification_[index]),
                      info(Icons.work_outline,
                          "${experience_[index]} years experience"),

                      const SizedBox(height: 20),

                      // WORKOUT LEVELS BUTTON
                      actionButton(
                        text: "View Workout Levels",
                        icon: Icons.fitness_center,
                        color: Colors.black,
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => ViewWorkoutLevelsPage(
                                trainerId: trainer_id_[index],
                              ),
                            ),
                          );
                        },
                      ),

                      const SizedBox(height: 12),

                      // FEEDBACK BUTTON
                      actionButton(
                        text: "Give Feedback",
                        icon: Icons.rate_review_outlined,
                        color: Colors.grey.shade700,
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => FeedbackPage(
                                trainerId: trainer_id_[index],
                                trainerName: name_[index],
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}