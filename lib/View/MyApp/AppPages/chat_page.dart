import 'package:era_shop/utils/CoustomWidget/App_theme_services/primary_buttons.dart';
import 'package:era_shop/utils/CoustomWidget/App_theme_services/text_titles.dart';
import 'package:era_shop/utils/Strings/strings.dart';
import 'package:era_shop/utils/all_images.dart';
import 'package:era_shop/utils/app_colors.dart';
import 'package:era_shop/utils/globle_veriables.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _textEditingController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  final List<String> _messages = [];

  // void _sendMessage(String message) {
  //   setState(() {
  //     _messages.add(message);
  //   });
  //   _textEditingController.clear();
  //
  //   _textEditingController.scrollController.animateTo(
  //       messageShowController.scrollController.position.maxScrollExtent,
  //       duration: const Duration(milliseconds: 300),
  //       curve: Curves.easeOut);
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.black,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: AppBar(
          elevation: 0,
          automaticallyImplyLeading: false,
          actions: [
            SizedBox(
              width: Get.width,
              height: double.maxFinite,
              child: Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 15, top: 5),
                    child: PrimaryRoundButton(
                      onTaped: () {
                        Get.back();
                      },
                      icon: Icons.arrow_back_rounded,
                    ),
                  ),
                  const Align(
                    alignment: Alignment.center,
                    child: GeneralTitle(title: "Jhone Shop"),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: SizedBox(
          height: Get.height,
          width: Get.width,
          child: Stack(
            children: [
              SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  children: [
                    Row(
                      children: [
                        SizedBox(
                          height: Get.height / 8.5,
                          width: Get.width / 1.4,
                          child: Row(
                            children: [
                              Column(
                                children: [
                                  Stack(
                                    alignment: Alignment.bottomRight,
                                    children: [
                                      const CircleAvatar(
                                        backgroundColor: Colors.black54,
                                        radius: 18,
                                        backgroundImage: AssetImage("assets/product_review/Image.png"),
                                      ),
                                      CircleAvatar(
                                        backgroundColor: Colors.white,
                                        radius: 5,
                                        child: CircleAvatar(
                                          backgroundColor: AppColors.primaryPink,
                                          radius: 4.4,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 13),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(top: 8),
                                      child: Container(
                                        height: 67,
                                        width: Get.width / 1.8 - 0.474,
                                        decoration: const BoxDecoration(
                                            color: Color(0xffF6F6F6),
                                            borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(24),
                                              bottomRight: Radius.circular(24),
                                              topRight: Radius.circular(24),
                                            )),
                                        child: Center(
                                          child: Text(
                                            "Lorem ipsum dolor sit et,\n"
                                            "consectetur adipiscing.",
                                            textAlign: TextAlign.start,
                                            style: GoogleFonts.plusJakartaSans(fontSize: 14, color: Colors.grey.shade700),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Text(
                                      "15:42 PM",
                                      style: GoogleFonts.plusJakartaSans(fontSize: 11, color: Colors.grey.shade500),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      height: Get.height / 50,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        SizedBox(
                          height: Get.height / 10.2,
                          width: Get.width / 1.4,
                          // color: Colors.lightGreen,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Column(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(top: 8),
                                    child: Container(
                                      height: 48,
                                      width: Get.width / 1.8 - 0.474,
                                      decoration: BoxDecoration(
                                          color: AppColors.primaryPink,
                                          borderRadius: const BorderRadius.only(
                                            topLeft: Radius.circular(24),
                                            bottomLeft: Radius.circular(24),
                                            topRight: Radius.circular(24),
                                          )),
                                      child: Center(
                                        child: Text(
                                          "Lorem ipsum dolor sit et",
                                          textAlign: TextAlign.start,
                                          style: GoogleFonts.plusJakartaSans(fontSize: 14, color: AppColors.white),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Text(
                                    "15:42 PM",
                                    style: GoogleFonts.plusJakartaSans(fontSize: 11, color: AppColors.mediumGrey),
                                  )
                                ],
                              ),
                              const Padding(
                                padding: EdgeInsets.only(left: 13),
                                child: CircleAvatar(
                                  backgroundColor: Colors.black54,
                                  radius: 18,
                                  backgroundImage: AssetImage("assets/icons/Avatar.png"),
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      height: Get.height / 50,
                    ),
                    Row(
                      children: [
                        SizedBox(
                          height: Get.height / 8.5,
                          width: Get.width / 1.4,
                          // color: Colors.lightGreen,
                          child: Row(
                            children: [
                              Column(
                                children: [
                                  Stack(
                                    alignment: Alignment.bottomRight,
                                    children: [
                                      const CircleAvatar(
                                        backgroundColor: Colors.black54,
                                        radius: 18,
                                        backgroundImage: AssetImage("assets/product_review/Image.png"),
                                      ),
                                      CircleAvatar(
                                        backgroundColor: AppColors.white,
                                        radius: 5,
                                        child: CircleAvatar(
                                          backgroundColor: AppColors.primaryPink,
                                          radius: 4.4,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 13),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(top: 8),
                                      child: Container(
                                        height: 67,
                                        width: Get.width / 1.8 - 0.474,
                                        decoration: const BoxDecoration(
                                            color: Color(0xffF6F6F6),
                                            borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(24),
                                              bottomRight: Radius.circular(24),
                                              topRight: Radius.circular(24),
                                            )),
                                        child: Center(
                                          child: Text(
                                            "Lorem ipsum dolor sit et,\n"
                                            "consectetur adipiscing.",
                                            textAlign: TextAlign.start,
                                            style: GoogleFonts.plusJakartaSans(fontSize: 14, color: Colors.grey.shade700),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Text(
                                      "15:42 PM",
                                      style: GoogleFonts.plusJakartaSans(fontSize: 11, color: AppColors.mediumGrey),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      height: Get.height / 50,
                    ),
                    SizedBox(
                      child: ListView.builder(
                        controller: _scrollController,
                        shrinkWrap: true,
                        // physics: const NeverScrollableScrollPhysics(),
                        itemCount: _messages.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  SizedBox(
                                    height: Get.height / 10.2,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Column(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment: CrossAxisAlignment.end,
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(top: 8),
                                              child: Container(
                                                height: 48,
                                                decoration: BoxDecoration(
                                                    color: AppColors.primaryPink,
                                                    borderRadius: const BorderRadius.only(
                                                      topLeft: Radius.circular(24),
                                                      bottomLeft: Radius.circular(24),
                                                      topRight: Radius.circular(24),
                                                    )),
                                                child: Center(
                                                  child: Padding(
                                                    padding: const EdgeInsets.symmetric(horizontal: 20),
                                                    child: Text(
                                                      overflow: TextOverflow.clip,
                                                      _messages[index],
                                                      textAlign: TextAlign.start,
                                                      style: GoogleFonts.plusJakartaSans(fontSize: 14, color: AppColors.white),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Text(
                                              "15:42 PM",
                                              style: GoogleFonts.plusJakartaSans(fontSize: 11, color: AppColors.mediumGrey),
                                            )
                                          ],
                                        ),
                                        const Padding(
                                          padding: EdgeInsets.only(left: 13),
                                          child: CircleAvatar(
                                            backgroundColor: Colors.black54,
                                            radius: 18,
                                            backgroundImage: AssetImage("assets/icons/Avatar.png"),
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                              SizedBox(
                                height: Get.height / 50,
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                    SizedBox(
                      height: Get.height / 10,
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: Get.height / 1,
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: SizedBox(
                      height: 58,
                      child: Obx(
                        () => TextFormField(
                          cursorColor: AppColors.unselected,
                          controller: _textEditingController,
                          style: GoogleFonts.plusJakartaSans(
                            color: isDark.value ? AppColors.white : AppColors.black,
                          ),
                          decoration: InputDecoration(
                              filled: true,
                              fillColor: isDark.value ? AppColors.lightBlack : AppColors.dullWhite,
                              prefixIcon: Padding(
                                padding: const EdgeInsets.all(14),
                                child: Image(image: AssetImage(AppImage.pin)),
                              ),
                              suffixIcon: Padding(
                                padding: const EdgeInsets.all(8),
                                child: GestureDetector(
                                  onTap: () {
                                    if (_textEditingController.text.isNotEmpty) {
                                      setState(() {
                                        _messages.add(_textEditingController.text);
                                        _textEditingController.clear();
                                      });
                                      _scrollController.animateTo(
                                        _scrollController.position.maxScrollExtent,
                                        duration: const Duration(milliseconds: 300),
                                        curve: Curves.easeOut,
                                      );
                                    }
                                  },
                                  child: Image(image: AssetImage(AppImage.sendButton)),
                                ),
                              ),
                              hintText: St.message.tr,
                              hintStyle: const TextStyle(color: Color(0xff9CA4AB), fontSize: 13),
                              enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: isDark.value ? Colors.transparent : AppColors.lightGrey, width: 1.3), borderRadius: BorderRadius.circular(30)),
                              border: OutlineInputBorder(borderSide: BorderSide(color: AppColors.primaryPink), borderRadius: BorderRadius.circular(30))),
                        ),
                      ),
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
