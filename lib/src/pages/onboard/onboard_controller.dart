import 'package:flutter/material.dart';
import 'package:liquid_swipe/liquid_swipe.dart';
import 'package:reciclon_client/src/models/user.dart';
import 'package:reciclon_client/src/providers/push_notification_provider.dart';
import 'package:reciclon_client/src/utils/shared_preferences.dart';

class OnboardController {
  int currentPage = 0;
  late BuildContext context;
  late Function refresh;
  final _pushNotificationProvider = PushNotificationProvider();

  final List<OnboardItem> items = [
    OnboardItem(
      descripcion:
          'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry\'s standard dummy text ever since the 1500s',
      imagen: 'assets/page/onboard/reciclaje1.svg',
      titulo: 'Pagina 1',
    ),
    OnboardItem(
      descripcion:
          'Contrary to popular belief, Lorem Ipsum is not simply random text. It has roots in a piece of classical Latin literature from 45 BC',
      imagen: 'assets/page/onboard/reciclaje2.svg',
      titulo: 'Pagina 2',
    ),
    OnboardItem(
      descripcion:
          'The standard chunk of Lorem Ipsum used since the 1500s is reproduced below for those interested.',
      imagen: 'assets/page/onboard/reciclaje3.svg',
      titulo: 'Pagina 3',
    ),
  ];

  final dotController = LiquidController();
  final _preferencias = SharedPref();

  void init(BuildContext context, Function refresh) async {
    this.context = context;
    this.refresh = refresh;
    bool usuarioExiste = await _preferencias.tiene('user');
    if (usuarioExiste) {
      final user = User.fromJson(await _preferencias.leer('user'));
      if (user.sessionToken != null) {
        _pushNotificationProvider.saveToken(user, this.context);
        if (user.roles!.length > 1) {
          Navigator.pushNamedAndRemoveUntil(context, 'roles', (route) => false);
        } else {
          Navigator.pushNamedAndRemoveUntil(
              context, user.roles![0].route, (route) => false);
        }
      }
    }
  }

  void goToNextOnboardPage() {
    if (currentPage == 2) {
      currentPage = 0;
    }
    // currentPage += 1;
    dotController.jumpToPage(page: currentPage + 1);
    // refresh();
  }

  void goBackOnboardPage() {
    if (currentPage == 0) {
      currentPage = 2;
    }
    // currentPage -= 1;
    dotController.jumpToPage(page: currentPage - 1);
    // refresh();
  }

  void goToLoginScreen() {
    Navigator.pushNamed(context, 'login');
  }
}

class OnboardItem {
  final String imagen, titulo, descripcion;
  OnboardItem({
    required this.imagen,
    required this.titulo,
    required this.descripcion,
  });
}
