

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'GymPaymentPage.dart';

class ViewGymPage extends StatefulWidget {
  const ViewGymPage({super.key, required this.title});
  final String title;

  @override
  State<ViewGymPage> createState() => _ViewGymPageState();
}

class _ViewGymPageState extends State<ViewGymPage> {
  List<String> id_ = [];
  List<String> name_ = [];
  List<String> email_ = [];
  List<String> phone_ = [];
  List<String> address_ = [];
  List<String> request_status_ = [];
  List<String> fees_ = [];
  List<String> payment_status_ = [];
  List<String> image_ = [];
  List<String> description_ = [];
  List<bool> isExpanded_ = [];

  bool isLoading = true;

  // ---------------- FETCH GYMS ----------------
  Future<void> _send_data() async {
    try {
      SharedPreferences sh = await SharedPreferences.getInstance();
      String url = sh.getString('url') ?? '';
      String lid = sh.getString('lid') ?? '';

      final response = await http.post(
        Uri.parse('$url/user_view_gym/'),
        body: {'lid': lid},
      );

      if (response.statusCode == 200) {
        var jsondata = jsonDecode(response.body);

        if (jsondata['status'] == 'ok') {
          var arr = jsondata['data'];

          id_.clear();
          name_.clear();
          email_.clear();
          phone_.clear();
          address_.clear();
          request_status_.clear();
          fees_.clear();
          payment_status_.clear();
          description_.clear();
          isExpanded_.clear();
          image_.clear();   // ← NEW

          for (var item in arr) {
            id_.add(item['id'].toString());
            name_.add(item['name'] ?? '');
            email_.add(item['email'] ?? '');
            phone_.add(item['phone'] ?? '');
            address_.add(item['address'] ?? '');
            request_status_.add(item['request_status'] ?? 'none');
            fees_.add(item['fees'] ?? '0');
            payment_status_.add(item['payment_status'] ?? 'unpaid');
            description_.add(item['description'] ?? '');
            isExpanded_.add(false);
            image_.add(item['image'] ?? '');   // ← NEW
          }
        }
      }
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());
    }

    setState(() {
      isLoading = false;
    });
  }

  // ---------------- SEND JOIN REQUEST ----------------
  Future<void> sendRequest(String gymId, int index) async {
    SharedPreferences sh = await SharedPreferences.getInstance();
    String url = sh.getString('url') ?? '';
    String lid = sh.getString('lid') ?? '';

    final response = await http.post(
      Uri.parse('$url/send_gym_request/'),
      body: {
        'lid': lid,
        'gym_id': gymId,
        'description': 'Join gym request',
      },
    );

    var jsondata = jsonDecode(response.body);

    if (jsondata['status'] == 'ok') {
      Fluttertoast.showToast(msg: "Request Sent");
      setState(() => request_status_[index] = "pending");
    }
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
                    // Close button row
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

                    // Image card (Instagram pop-up style)
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

  // ---------------- BUTTON UI ----------------
  Widget buildActionButton(int index) {
    String req = request_status_[index];
    String pay = payment_status_[index];

    if (req == "none") {
      return fullButton(
        "JOIN NOW",
        Colors.black,
        Icons.send,
            () => sendRequest(id_[index], index),
      );
    }

    if (req == "pending") {
      return disabledButton(
          "WAITING FOR APPROVAL", Colors.orange.shade700, Icons.hourglass_top);
    }

    if (req == "approved" && pay == "unpaid") {
      return fullButton(
        "PAY NOW  ₹${fees_[index]}",
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
          if (paid == true) _send_data();
        },
      );
    }

    if (req == "approved" && pay == "paid") {
      return disabledButton(
          "ACTIVE MEMBER", Colors.green.shade700, Icons.verified);
    }

    return const SizedBox();
  }

  // ---------------- BUTTON STYLES ----------------
  Widget fullButton(
      String text, Color color, IconData icon, VoidCallback onTap) {
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
          shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
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
            style: TextStyle(fontWeight: FontWeight.bold, color: color),
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _send_data();
  }

  // ---------------- UI ----------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff2f2f2),
      appBar: AppBar(
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(
          widget.title,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        elevation: 0,
      ),
      body: isLoading
          ? const Center(
          child: CircularProgressIndicator(color: Colors.black))
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
              "No Gyms Available",
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
                "Check back later for fitness centers in your area",
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
                      // Gym icon
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

                      // Gym name
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
                        child: Hero(
                          tag: 'gym_image_${id_[index]}',
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
                                  color:
                                  Colors.black.withOpacity(0.25),
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
                                errorBuilder:
                                    (_, __, ___) =>
                                    _fallbackAvatar(),
                              )
                                  : _fallbackAvatar(),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // ── BODY ──
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      info(Icons.email_outlined, email_[index]),
                      info(Icons.phone_outlined, phone_[index]),
                      info(Icons.location_on_outlined,
                          address_[index]),
                      if (description_[index].isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Padding(
                                padding: EdgeInsets.only(top: 2),
                                child: Icon(Icons.description_outlined,
                                    color: Colors.black54, size: 20),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      description_[index],
                                      maxLines: isExpanded_[index] ? null : 2,
                                      overflow: isExpanded_[index]
                                          ? TextOverflow.visible
                                          : TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        color: Colors.black87,
                                        fontSize: 15,
                                      ),
                                    ),
                                    if (description_[index].length > 80)
                                      GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            isExpanded_[index] = !isExpanded_[index];
                                          });
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.only(top: 4),
                                          child: Text(
                                            isExpanded_[index]
                                                ? "Show Less"
                                                : "Read More",
                                            style: const TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 13,
                                            ),
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),

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
                          mainAxisAlignment:
                          MainAxisAlignment.center,
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

                      const SizedBox(height: 20),

                      // ACTION BUTTON
                      buildActionButton(index),
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

  /// Fallback avatar shown when no image / image fails to load
  Widget _fallbackAvatar() {
    return Container(
      color: Colors.grey.shade700,
      child: const Icon(Icons.fitness_center, color: Colors.white, size: 26),
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
}