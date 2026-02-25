import 'package:era_shop/utils/CoustomWidget/App_theme_services/primary_buttons.dart';
import 'package:era_shop/utils/CoustomWidget/App_theme_services/text_titles.dart';
import 'package:era_shop/utils/all_images.dart';
import 'package:era_shop/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

/// THIS PAGE IS NOT USABLE \\\

class Message extends StatelessWidget {
  const Message({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.black,
      body: SafeArea(
          child: SizedBox(
        height: Get.height,
        width: Get.width,
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              const SizedBox(
                height: 15,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Row(
                  children: [
                    PrimaryRoundButton(
                        onTaped: () {
                          Get.back();
                        },
                        icon: Icons.arrow_back_rounded),
                    Padding(padding: EdgeInsets.only(left: Get.width / 4.7), child: const GeneralTitle(title: "Message")),
                  ],
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                // child: searchTextField(),
              ),
              Dismissible(
                background: Container(
                  color: const Color(0xffFFF5F5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Image(
                        image: AssetImage(AppImage.borderDelete),
                        height: 23,
                      ),
                      SizedBox(
                        width: Get.width / 7,
                      ),
                    ],
                  ),
                ),
                confirmDismiss: (DismissDirection direction) async {
                  return await showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text("Confirm"),
                        content: const Text("Are you sure you wish to delete this chat?"),
                        actions: <Widget>[
                          ElevatedButton(onPressed: () => Navigator.of(context).pop(true), child: const Text("DELETE")),
                          ElevatedButton(
                            onPressed: () => Navigator.of(context).pop(false),
                            child: const Text("CANCEL"),
                          ),
                        ],
                      );
                    },
                  );
                },
                key: UniqueKey(),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 13, horizontal: 15),
                  child: GestureDetector(
                    onTap: () {
                      Get.toNamed("/ChatPage");
                    },
                    child: SizedBox(
                      height: 55,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Stack(
                            children: [
                              Container(
                                width: 70,
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  image: DecorationImage(image: AssetImage("assets/product_review/Image.png"), fit: BoxFit.cover),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(left: Get.width / 8),
                                child: Align(
                                  alignment: Alignment.bottomRight,
                                  child: CircleAvatar(
                                    radius: 8,
                                    backgroundColor: AppColors.white,
                                    child: const CircleAvatar(
                                      radius: 7,
                                      backgroundColor: Colors.lightGreen,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.only(),
                            child: SizedBox(
                              width: Get.width / 1.5,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        "Jhone Shop",
                                        style: GoogleFonts.plusJakartaSans(fontSize: 18, fontWeight: FontWeight.bold),
                                      ),
                                      const Spacer(),
                                      Text(
                                        "10:20",
                                        style: GoogleFonts.plusJakartaSans(fontSize: 13, color: Colors.grey.shade600),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        "Lorem ipsum dolor sit amet...",
                                        style: GoogleFonts.plusJakartaSans(fontSize: 14, color: Colors.grey.shade600),
                                      ),
                                      const Spacer(),
                                      Container(
                                        height: 22,
                                        width: 22,
                                        decoration: BoxDecoration(shape: BoxShape.circle, color: AppColors.primaryPink),
                                        child: Center(
                                          child: Text(
                                            "2",
                                            style: GoogleFonts.plusJakartaSans(fontSize: 9.4, fontWeight: FontWeight.w600, color: AppColors.white),
                                          ),
                                        ),
                                      ),
                                    ],
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
              ),
              Dismissible(
                background: Container(
                  color: const Color(0xffFFF5F5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Image(
                        image: AssetImage(AppImage.borderDelete),
                        height: 23,
                      ),
                      SizedBox(
                        width: Get.width / 7,
                      ),
                    ],
                  ),
                ),
                confirmDismiss: (DismissDirection direction) async {
                  return await showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text("Confirm"),
                        content: const Text("Are you sure you wish to delete this chat?"),
                        actions: <Widget>[
                          ElevatedButton(onPressed: () => Navigator.of(context).pop(true), child: const Text("DELETE")),
                          ElevatedButton(
                            onPressed: () => Navigator.of(context).pop(false),
                            child: const Text("CANCEL"),
                          ),
                        ],
                      );
                    },
                  );
                },
                key: UniqueKey(),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 13, horizontal: 15),
                  child: SizedBox(
                    height: 55,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          width: 70,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(image: AssetImage("assets/product_review/Image (1).png"), fit: BoxFit.cover),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(),
                          child: SizedBox(
                            width: Get.width / 1.5,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      "Andrew Kanlan",
                                      style: GoogleFonts.plusJakartaSans(fontSize: 18, fontWeight: FontWeight.bold),
                                    ),
                                    const Spacer(),
                                    Text(
                                      "10:20",
                                      style: GoogleFonts.plusJakartaSans(fontSize: 13, color: Colors.grey.shade600),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Text(
                                      "Lorem ipsum dolor sit amet...",
                                      style: GoogleFonts.plusJakartaSans(fontSize: 14, color: Colors.grey.shade600),
                                    ),
                                    const Spacer(),
                                    Container(
                                      height: 22,
                                      width: 22,
                                      decoration: BoxDecoration(shape: BoxShape.circle, color: AppColors.primaryPink),
                                      child: Center(
                                        child: Text(
                                          "2",
                                          style: GoogleFonts.plusJakartaSans(fontSize: 9.4, fontWeight: FontWeight.w600, color: AppColors.white),
                                        ),
                                      ),
                                    ),
                                  ],
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
              Dismissible(
                background: Container(
                  color: const Color(0xffFFF5F5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Image(
                        image: AssetImage(AppImage.borderDelete),
                        height: 23,
                      ),
                      SizedBox(
                        width: Get.width / 7,
                      ),
                    ],
                  ),
                ),
                confirmDismiss: (DismissDirection direction) async {
                  return await showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text("Confirm"),
                        content: const Text("Are you sure you wish to delete this chat?"),
                        actions: <Widget>[
                          ElevatedButton(onPressed: () => Navigator.of(context).pop(true), child: const Text("DELETE")),
                          ElevatedButton(
                            onPressed: () => Navigator.of(context).pop(false),
                            child: const Text("CANCEL"),
                          ),
                        ],
                      );
                    },
                  );
                },
                key: UniqueKey(),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 13, horizontal: 15),
                  child: SizedBox(
                    height: 55,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          width: 70,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(image: AssetImage("assets/product_review/Image (2).png"), fit: BoxFit.cover),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(),
                          child: SizedBox(
                            width: Get.width / 1.5,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      "Endies Shop",
                                      style: GoogleFonts.plusJakartaSans(fontSize: 18, fontWeight: FontWeight.bold),
                                    ),
                                    const Spacer(),
                                    Text(
                                      "10:20",
                                      style: GoogleFonts.plusJakartaSans(fontSize: 13, color: Colors.grey.shade600),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Text(
                                      "Lorem ipsum dolor sit amet...",
                                      style: GoogleFonts.plusJakartaSans(fontSize: 14, color: Colors.grey.shade600),
                                    ),
                                  ],
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
              Dismissible(
                background: Container(
                  color: const Color(0xffFFF5F5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Image(
                        image: AssetImage(AppImage.borderDelete),
                        height: 23,
                      ),
                      SizedBox(
                        width: Get.width / 7,
                      ),
                    ],
                  ),
                ),
                confirmDismiss: (DismissDirection direction) async {
                  return await showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text("Confirm"),
                        content: const Text("Are you sure you wish to delete this chat?"),
                        actions: <Widget>[
                          ElevatedButton(onPressed: () => Navigator.of(context).pop(true), child: const Text("DELETE")),
                          ElevatedButton(
                            onPressed: () => Navigator.of(context).pop(false),
                            child: const Text("CANCEL"),
                          ),
                        ],
                      );
                    },
                  );
                },
                key: UniqueKey(),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 13, horizontal: 15),
                  child: SizedBox(
                    height: 55,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          width: 70,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(image: AssetImage("assets/product_review/Image (3).png"), fit: BoxFit.cover),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(),
                          child: SizedBox(
                            width: Get.width / 1.5,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      "Endy Cornor",
                                      style: GoogleFonts.plusJakartaSans(fontSize: 18, fontWeight: FontWeight.bold),
                                    ),
                                    const Spacer(),
                                    Text(
                                      "10:20",
                                      style: GoogleFonts.plusJakartaSans(fontSize: 13, color: Colors.grey.shade600),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Text(
                                      "Lorem ipsum dolor sit amet...",
                                      style: GoogleFonts.plusJakartaSans(fontSize: 14, color: Colors.grey.shade600),
                                    ),
                                  ],
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
            ],
          ),
        ),
      )),
    );
  }
}
