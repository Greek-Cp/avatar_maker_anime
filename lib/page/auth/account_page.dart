import 'package:avatar_maker/component/button.dart';
import 'package:avatar_maker/service/authentication.dart';
import 'package:avatar_maker/util/color_app.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class AccountPage extends StatefulWidget {
  static String? routeName = "/AccountPage";

  const AccountPage({super.key});

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  final AuthService _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: ColorApp.primaryColor,
        systemNavigationBarColor: ColorApp.backgroundNavigationBottomColor,
      ),
    );

    return Scaffold(
      body: ScreenUtilInit(
        builder: (context, child) {
          return Padding(
            padding:
                EdgeInsets.symmetric(horizontal: 24.w), // Horizontal padding
            child: FutureBuilder(
              future: _authService
                  .isLoggedIn(), // Mengecek apakah pengguna sudah login
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData || snapshot.data == false) {
                  // Jika belum login, arahkan kembali ke halaman login
                  Future.delayed(
                      Duration.zero, () => Get.offAllNamed('/LoginPage'));
                  return const Center(child: Text('You are not logged in.'));
                }

                // Ambil user data
                return FutureBuilder(
                  future: _authService
                      .getUser(), // Mendapatkan user dari UserPreferences
                  builder: (context, userSnapshot) {
                    if (userSnapshot.connectionState ==
                        ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (userSnapshot.hasError) {
                      return const Center(
                          child: Text('Error loading user data.'));
                    }

                    final user = userSnapshot.data;

                    if (user == null) {
                      return const Center(child: Text('User not found.'));
                    }

                    return Center(
                      // Membungkus seluruh konten dengan Center
                      child: Column(
                        mainAxisAlignment:
                            MainAxisAlignment.center, // Vertikal di tengah
                        crossAxisAlignment:
                            CrossAxisAlignment.center, // Horizontal di tengah
                        children: [
                          // Foto Profil
                          CircleAvatar(
                            radius: 80.r,
                            backgroundImage: NetworkImage(user.photoURL),
                          ),
                          SizedBox(
                            height: 20.h,
                          ),
                          // Nama Pengguna
                          Text(
                            user.username,
                            style: TextStyle(
                              fontSize: 24.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 2.h),
                          // Email Pengguna
                          Text(
                            user.email,
                            style: TextStyle(
                              fontSize: 16.sp,
                              color: Colors.grey,
                            ),
                          ),
                          SizedBox(height: 12.h),
                          // Tombol Logout
                          GradientCustomWidgetText("Setting", () {}),
                          GradientCustomWidgetText("Logout", () => _logout()),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          );
        },
      ),
    );
  }

  // Fungsi logout
  Future<void> _logout() async {
    await _authService.logout();
    Get.offAllNamed('/LoginPage'); // Arahkan kembali ke halaman login
  }
}
