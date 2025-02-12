import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:guide_app_panel/Views/Main_page_home.dart';
import '../../main.dart';
import '../../utils/app_colors.dart';
import '../../widgets/Buttons/ls_button.dart';
import '../../widgets/TextFields/login/ls_textfield.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    mq = MediaQuery.of(context).size;
    final TextEditingController emailController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();
    return SafeArea(
      child: Scaffold(
        backgroundColor: MyColors.greyColor,
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Align(
                  alignment: Alignment.topCenter,
                  child: Container(
                    height: 70,
                    width: mq.width * 100,
                    color: MyColors.whiteColor,
                    child: const Center(
                      child: Text(
                        "Login",
                        style: TextStyle(
                            fontSize: 30, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: mq.height * 0.15,
                ),
                Container(
                  height: mq.height * 0.4,
                  width: mq.width * 0.9,
                  decoration: BoxDecoration(
                      color: MyColors.whiteColor,
                      borderRadius: BorderRadius.circular(12)),
                  child: Column(
                    children: [
                      SizedBox(
                        height: mq.height * 0.05,
                      ),
                      LsTextField(
                        hintText: "abc@example.com",
                        labelText: "Email",
                        secureText: false,
                        controller: emailController,
                      ),
                      LsTextField(
                        labelText: "Password",
                        controller: passwordController,
                        secureText: true,
                      ),
                      SizedBox(
                        height: mq.height * 0.02,
                      ),
                      LsButton(
                        ontap: () {
                          Get.to(() => const MainPageHome());
                        },
                        text: "Login",
                        // ontap: (dynamic ApisUtils) {
                        //   ApisUtils.auth
                        //       .signInWithEmailAndPassword(
                        //           email: emailController.text,
                        //           password: passwordController.text)
                        //       .then((onValue) {
                        //     Navigator.push(
                        //         context,
                        //         MaterialPageRoute(
                        //             builder: (context) => HomePage()));
                        //   }).onError(
                        //     (error, stackTrace) {
                        //       Get.snackbar("Error", error.toString());
                        //     },
                        //   );
                        // },
                      ),
                      SizedBox(
                        height: mq.height * 0.02,
                      ),
                      // Row(
                      //   mainAxisAlignment: MainAxisAlignment.center,
                      //   children: [
                      //     const Text("Not a member?"),
                      //     TextButton(
                      //         onPressed: () {
                      //           Navigator.push(
                      //               context,
                      //               MaterialPageRoute(
                      //                   builder: (context) =>
                      //                       const SignupPage()));
                      //         },
                      //         child: const Text(
                      //           "Create a free account",
                      //           style: TextStyle(color: Colors.blue),
                      //         ))
                      //   ],
                      // )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
