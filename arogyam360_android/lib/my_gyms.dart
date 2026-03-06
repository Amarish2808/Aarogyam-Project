//
//
// import 'package:arogyam360_android/view_trainers.dart';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'GymPaymentPage.dart';
//
// class MyGymsPage extends StatefulWidget {
//   const MyGymsPage({super.key});
//
//   @override
//   State<MyGymsPage> createState() => _MyGymsPageState();
// }
//
// class _MyGymsPageState extends State<MyGymsPage> {
//   List<String> id_ = [];
//   List<String> name_ = [];
//   List<String> email_ = [];
//   List<String> phone_ = [];
//   List<String> address_ = [];
//   List<String> fees_ = [];
//   List<String> payment_status_ = [];
//
//   bool isLoading = true;
//
//   Future<void> loadGyms() async {
//     SharedPreferences sh = await SharedPreferences.getInstance();
//     String url = sh.getString('url') ?? '';
//     String lid = sh.getString('lid') ?? '';
//
//     final response = await http.post(
//       Uri.parse('$url/user_view_joined_gyms/'),
//       body: {'lid': lid},
//     );
//
//     var jsondata = jsonDecode(response.body);
//
//     if (jsondata['status'] == 'ok') {
//       var arr = jsondata['data'];
//
//       id_.clear();
//       name_.clear();
//       email_.clear();
//       phone_.clear();
//       address_.clear();
//       fees_.clear();
//       payment_status_.clear();
//
//       for (var i in arr) {
//         id_.add(i['gym_id'].toString());
//         name_.add(i['name']);
//         email_.add(i['email']);
//         phone_.add(i['phone']);
//         address_.add(i['address']);
//         fees_.add(i['fees']);
//         payment_status_.add(i['payment_status']);
//       }
//     }
//
//     setState(() => isLoading = false);
//   }
//
//   @override
//   void initState() {
//     super.initState();
//     loadGyms();
//   }
//
//   Widget actionButton(int index) {
//     if (payment_status_[index] == "paid") {
//       return disabledButton("ACTIVE MEMBER", Colors.green.shade700, Icons.verified);
//     }
//
//     if (payment_status_[index] == "expired") {
//       return fullButton(
//         "RENEW MEMBERSHIP ₹${fees_[index]}",
//         Colors.orange.shade700,
//         Icons.refresh,
//             () async {
//           bool? paid = await Navigator.push(
//             context,
//             MaterialPageRoute(
//               builder: (_) => GymPaymentPage(
//                 gymId: id_[index],
//                 amount: fees_[index],
//               ),
//             ),
//           );
//
//           if (paid == true) loadGyms();
//         },
//       );
//     }
//
//     return fullButton(
//       "PAY NOW ₹${fees_[index]}",
//       Colors.grey.shade800,
//       Icons.payment,
//           () async {
//         bool? paid = await Navigator.push(
//           context,
//           MaterialPageRoute(
//             builder: (_) => GymPaymentPage(
//               gymId: id_[index],
//               amount: fees_[index],
//             ),
//           ),
//         );
//
//         if (paid == true) loadGyms();
//       },
//     );
//   }
//
//   Widget fullButton(String text, Color color, IconData icon, VoidCallback onTap) {
//     return SizedBox(
//       width: double.infinity,
//       child: ElevatedButton.icon(
//         onPressed: onTap,
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
//           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//           elevation: 0,
//         ),
//       ),
//     );
//   }
//
//   Widget disabledButton(String text, Color color, IconData icon) {
//     return Container(
//       width: double.infinity,
//       padding: const EdgeInsets.symmetric(vertical: 15),
//       decoration: BoxDecoration(
//         color: color.withOpacity(0.15),
//         borderRadius: BorderRadius.circular(12),
//         border: Border.all(color: color.withOpacity(0.3)),
//       ),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Icon(icon, color: color),
//           const SizedBox(width: 8),
//           Text(
//             text,
//             style: TextStyle(
//               fontWeight: FontWeight.bold,
//               color: color,
//             ),
//           ),
//         ],
//       ),
//     );
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
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xfff2f2f2),
//       appBar: AppBar(
//         backgroundColor: Colors.black,
//         iconTheme: const IconThemeData(color: Colors.white),
//         title: const Text(
//           "My Gyms",
//           style: TextStyle(
//             color: Colors.white,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//         elevation: 0,
//       ),
//       body: isLoading
//           ? const Center(child: CircularProgressIndicator(color: Colors.black))
//
//       // -------- EMPTY STATE --------
//           : id_.isEmpty
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
//                 Icons.fitness_center,
//                 size: 80,
//                 color: Colors.black,
//               ),
//             ),
//             const SizedBox(height: 30),
//             const Text(
//               "No Gym Memberships Yet",
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
//                 "Join a gym to start your workout and track your progress",
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
//
//       // -------- LIST --------
//           : ListView.builder(
//         padding: const EdgeInsets.all(20),
//         itemCount: id_.length,
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
//                           Icons.fitness_center,
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
//                       info(Icons.location_on_outlined, address_[index]),
//
//                       const SizedBox(height: 16),
//
//                       // FEES BADGE
//                       Container(
//                         width: double.infinity,
//                         padding: const EdgeInsets.all(14),
//                         decoration: BoxDecoration(
//                           color: Colors.black12,
//                           borderRadius: BorderRadius.circular(12),
//                         ),
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             const Icon(
//                               Icons.currency_rupee,
//                               color: Colors.black,
//                               size: 20,
//                             ),
//                             const SizedBox(width: 6),
//                             Text(
//                               "Monthly Fee: ₹${fees_[index]}",
//                               style: const TextStyle(
//                                 fontWeight: FontWeight.bold,
//                                 color: Colors.black87,
//                                 fontSize: 16,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//
//                       const SizedBox(height: 16),
//
//                       // PAYMENT STATUS
//                       actionButton(index),
//
//                       const SizedBox(height: 12),
//
//                       // VIEW TRAINERS BUTTON
//                       fullButton(
//                         "VIEW TRAINERS",
//                         Colors.black,
//                         Icons.people_outline,
//                             () {
//                           Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                               builder: (_) => ViewTrainersPage(
//                                 gymId: id_[index],
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

import 'package:arogyam360_android/view_trainers.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'GymPaymentPage.dart';

class MyGymsPage extends StatefulWidget {
  const MyGymsPage({super.key});

  @override
  State<MyGymsPage> createState() => _MyGymsPageState();
}

class _MyGymsPageState extends State<MyGymsPage> {
  List<String> id_ = [];
  List<String> name_ = [];
  List<String> email_ = [];
  List<String> phone_ = [];
  List<String> address_ = [];
  List<String> fees_ = [];
  List<String> payment_status_ = [];
  List<String> image_ = [];   // ← NEW

  bool isLoading = true;

  Future<void> loadGyms() async {
    SharedPreferences sh = await SharedPreferences.getInstance();
    String url = sh.getString('url') ?? '';
    String lid = sh.getString('lid') ?? '';

    final response = await http.post(
      Uri.parse('$url/user_view_joined_gyms/'),
      body: {'lid': lid},
    );

    var jsondata = jsonDecode(response.body);

    if (jsondata['status'] == 'ok') {
      var arr = jsondata['data'];

      id_.clear();
      name_.clear();
      email_.clear();
      phone_.clear();
      address_.clear();
      fees_.clear();
      payment_status_.clear();
      image_.clear();   // ← NEW

      for (var i in arr) {
        id_.add(i['gym_id'].toString());
        name_.add(i['name']);
        email_.add(i['email']);
        phone_.add(i['phone']);
        address_.add(i['address']);
        fees_.add(i['fees']);
        payment_status_.add(i['payment_status']);
        image_.add(i['image'] ?? '');   // ← NEW
      }
    }

    setState(() => isLoading = false);
  }

  // ---------------- INSTAGRAM-STYLE IMAGE POPUP ----------------
  void _showImagePopup(BuildContext context, String imageUrl, String gymName) {
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

                            // Gym name footer
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
                                      Icons.fitness_center,
                                      color: Colors.white,
                                      size: 18,
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Text(
                                      gymName,
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
        child: Icon(Icons.fitness_center, size: 48, color: Colors.black38),
      ),
    );
  }

  Widget _fallbackAvatar() {
    return Container(
      color: Colors.grey.shade700,
      child: const Icon(Icons.fitness_center, color: Colors.white, size: 26),
    );
  }

  @override
  void initState() {
    super.initState();
    loadGyms();
  }

  Widget actionButton(int index) {
    if (payment_status_[index] == "paid") {
      return disabledButton("ACTIVE MEMBER", Colors.green.shade700, Icons.verified);
    }

    if (payment_status_[index] == "expired") {
      return fullButton(
        "RENEW MEMBERSHIP ₹${fees_[index]}",
        Colors.orange.shade700,
        Icons.refresh,
            () async {
          bool? paid = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => GymPaymentPage(
                gymId: id_[index],
                amount: fees_[index],
              ),
            ),
          );
          if (paid == true) loadGyms();
        },
      );
    }

    return fullButton(
      "PAY NOW ₹${fees_[index]}",
      Colors.grey.shade800,
      Icons.payment,
          () async {
        bool? paid = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => GymPaymentPage(
              gymId: id_[index],
              amount: fees_[index],
            ),
          ),
        );
        if (paid == true) loadGyms();
      },
    );
  }

  Widget fullButton(String text, Color color, IconData icon, VoidCallback onTap) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: onTap,
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
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          elevation: 0,
        ),
      ),
    );
  }

  Widget disabledButton(String text, Color color, IconData icon) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 15),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color),
          const SizedBox(width: 8),
          Text(
            text,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff2f2f2),
      appBar: AppBar(
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          "My Gyms",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        elevation: 0,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.black))

      // -------- EMPTY STATE --------
          : id_.isEmpty
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
                Icons.fitness_center,
                size: 80,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 30),
            const Text(
              "No Gym Memberships Yet",
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
                "Join a gym to start your workout and track your progress",
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

      // -------- LIST --------
          : ListView.builder(
        padding: const EdgeInsets.all(20),
        itemCount: id_.length,
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
                          Icons.fitness_center,
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

                      // ── GYM PROFILE PIC (right side) ──
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
                      info(Icons.location_on_outlined, address_[index]),

                      const SizedBox(height: 16),

                      // FEES BADGE
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: Colors.black12,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.currency_rupee,
                              color: Colors.black,
                              size: 20,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              "Monthly Fee: ₹${fees_[index]}",
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 16),

                      // PAYMENT STATUS
                      actionButton(index),

                      const SizedBox(height: 12),

                      // VIEW TRAINERS BUTTON
                      fullButton(
                        "VIEW TRAINERS",
                        Colors.black,
                        Icons.people_outline,
                            () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => ViewTrainersPage(
                                gymId: id_[index],
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