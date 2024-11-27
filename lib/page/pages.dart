import 'package:avatar_maker/page/auth/account_page.dart';
import 'package:avatar_maker/page/auth/login_page.dart';
import 'package:avatar_maker/page/auth/register_page.dart';
import 'package:avatar_maker/page/intro/splash_page.dart';
import 'package:avatar_maker/page/intro/wizard_page.dart';
import 'package:avatar_maker/page/maker/create_char_page.dart';
import 'package:avatar_maker/page/playground_page.dart';
import 'package:avatar_maker/page/viewcharacter/view_char_page.dart';
import 'package:get/get.dart';

class Pages {
  var initialRoute = SplashPage.routeName;

  var getPages = [
    GetPage(
      name: SplashPage.routeName.toString(),
      page: () => SplashPage(),
    ),
    GetPage(
      name: WizardPage.routeName.toString(),
      page: () => WizardPage(),
    ),
    GetPage(
      name: LoginPage.routeName.toString(),
      page: () => LoginPage(),
    ),
    GetPage(
      name: RegisterPage.routeName.toString(),
      page: () => RegisterPage(),
    ),
    GetPage(
      name: PlaygroundPage.routeName.toString(),
      page: () => PlaygroundPage(),
    ),
    GetPage(
      name: CreateCharacterPage.routeName.toString(),
      page: () => CreateCharacterPage(),
    ),
    GetPage(
      name: ViewCharacterPage.routeName.toString(),
      page: () => ViewCharacterPage(),
    ),
    GetPage(
      name: AccountPage.routeName.toString(),
      page: () => AccountPage(),
    ),
  ];
}
