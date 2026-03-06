import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:url_launcher/url_launcher.dart';

class ViewProductsPage extends StatefulWidget {
  const ViewProductsPage({super.key});

  @override
  State<ViewProductsPage> createState() => _ViewProductsPageState();
}

class _ViewProductsPageState extends State<ViewProductsPage> {

  List<String> title_ = [];
  List<String> desc_ = [];
  List<String> image_ = [];
  List<String> url_ = [];
  List<String> category_ = [];

  bool isLoading = true;

  // -------- LOAD PRODUCTS --------
  Future<void> loadProducts() async {

    try {
      SharedPreferences sh = await SharedPreferences.getInstance();
      String baseUrl = sh.getString('url') ?? '';

      final response = await http.post(
        Uri.parse('$baseUrl/user_view_products/'),
      );

      var jsondata = jsonDecode(response.body);

      if (jsondata['status'] == 'ok') {

        var arr = jsondata['data'];

        title_.clear();
        desc_.clear();
        image_.clear();
        url_.clear();
        category_.clear();

        for (var p in arr) {
          title_.add(p['title']);
          desc_.add(p['description']);
          category_.add(p['category']);
          url_.add(p['url']);

          if (p['image'] != null && p['image'] != '') {
            image_.add(baseUrl + p['image']);
          } else {
            image_.add('');
          }
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
    loadProducts();
  }

  Future<void> openLink(String link) async {
    if (link.isEmpty) {
      Fluttertoast.showToast(msg: "No link available");
      return;
    }

    Uri uri = Uri.parse(link.startsWith('http') ? link : 'https://$link');

    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      Fluttertoast.showToast(msg: "Cannot open link");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text("Products"),
        backgroundColor: const Color.fromARGB(255, 18, 82, 98),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : title_.isEmpty
          ? const Center(child: Text("No products available"))
          : ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: title_.length,
        itemBuilder: (context, index) {

          return Container(
            margin: const EdgeInsets.only(bottom: 18),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
              boxShadow: [
                BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 12)
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                // IMAGE
                if (image_[index].isNotEmpty)
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(18)),
                    child: Image.network(
                      image_[index],
                      height: 200,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),

                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      // TITLE
                      Text(title_[index],
                          style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold)),

                      const SizedBox(height: 4),

                      // CATEGORY
                      Text(category_[index],
                          style: const TextStyle(
                              color: Colors.green,
                              fontWeight: FontWeight.w600)),

                      const SizedBox(height: 10),

                      // DESCRIPTION
                      Text(desc_[index]),

                      const SizedBox(height: 16),

                      // BUTTON
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: () => openLink(url_[index]),
                          icon: const Icon(Icons.shopping_cart),
                          label: const Text("Buy Now"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                            const Color.fromARGB(255, 18, 82, 98),
                            padding:
                            const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                                borderRadius:
                                BorderRadius.circular(12)),
                          ),
                        ),
                      ),

                    ],
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
