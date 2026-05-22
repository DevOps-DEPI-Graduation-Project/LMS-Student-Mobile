import 'package:flutter/material.dart';
import 'package:lms_student/features/explore/presentation/screens/explore_screen.dart';
import 'package:lms_student/features/home/presentation/screens/home_screen_before_login.dart';
import 'package:lms_student/root/custom_nav_bar.dart';
import 'package:lms_student/features/widgets/login_dialog.dart';

class RootBeforeLogin extends StatefulWidget {
  const RootBeforeLogin({super.key});

  @override
  State<RootBeforeLogin> createState() => _RootBeforeLoginState();
}

class _RootBeforeLoginState extends State<RootBeforeLogin> {
  PageController controller = PageController();
  int currentIndex = 0;

  List<Widget> screens = [
    HomeScreenBeforeLogin(),
    ExploreScreen(),
    const SizedBox(), //MyCoursesScreenBeforeLogin(),
    const SizedBox(), //ProfileScreenBeforeLogin(),
  ];

  void changePage(int index) {
    if (index == 2 || index == 3) {
      showDialog(
        context: context,
        builder: (dialogContext) => const LoginDialog(),
      );
      return;
    }
    setState(() {
      currentIndex = index;
    });

    controller.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: controller,
        physics: const NeverScrollableScrollPhysics(),
        children: screens,
      ),
      bottomNavigationBar: CustomNavBar(
        currentIndex: currentIndex,
        onTap: changePage,
      ),
    );
  }
}
