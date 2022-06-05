import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:reciclon_client/src/pages/admin/empresas/admin_empresas_page.dart';
import 'package:reciclon_client/src/pages/admin/home/admin_home_page.dart';
import 'package:reciclon_client/src/pages/cliente/address/lista/cliente_address_lista_page.dart';
import 'package:reciclon_client/src/pages/cliente/home/cliente_home_page.dart';
import 'package:reciclon_client/src/pages/cliente/ordenes/lista/cliente_ordenes_lista_page.dart';
import 'package:reciclon_client/src/pages/cliente/update/cliente_update_page.dart';
import 'package:reciclon_client/src/pages/empresa/crear/empresa_crear_page.dart';
// import 'package:reciclon_client/src/pages/empresa/home/empresa_home_page.dart';
import 'package:reciclon_client/src/pages/empresa/ordenes/lista/empresa_ordenes_lista_page.dart';
import 'package:reciclon_client/src/pages/empresa/productos/crear/empresa_productos_crear_page.dart';
import 'package:reciclon_client/src/pages/empresa/recolector/crear/empresa_recolector_crear_page.dart';
import 'package:reciclon_client/src/pages/login/login_page.dart';
import 'package:reciclon_client/src/pages/onboard/onboard_page.dart';
import 'package:reciclon_client/src/pages/recolector/ordenes/lista/recolector_ordenes_lista_page.dart';
import 'package:reciclon_client/src/pages/registro/registro_page.dart';
import 'package:reciclon_client/src/pages/roles/roles_page.dart';
import 'package:reciclon_client/src/providers/push_notification_provider.dart';

final pushNotificationProvider = PushNotificationProvider();

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print('Handling a background message ${message.messageId}');
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // stripe
  // Stripe.publishableKey = ''; //clave publica
  // await Stripe.instance.applySettings();
  // push notification
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  pushNotificationProvider.init();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    pushNotificationProvider.onMessageListener();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Reciclon',
      initialRoute: 'onboard',
      routes: {
        'onboard': (_) => OnboardPage(),
        'login': (_) => LoginPage(),
        'registro': (_) => RegistroPage(),
        'roles': (_) => RolesPage(),
        "cliente/home": (_) => ClienteHomePage(),
        'cliente/update': (_) => ClienteUpdatePage(),
        'cliente/address/list': (_) => ClienteAddressListaPage(),
        'cliente/ordenes/lista': (_) => ClienteOrdenesListaPage(),
        'empresa/crear': (_) => EmpresaCrearPage(),
        'empresa/productos/crear': (_) => EmpresaProductosCrearPage(),
        'admin/home': (_) => AdminHomePage(),
        'admin/empresas': (_) => AdminEmpresasPage(),
        'recicladora/home': (_) => EmpresaOrdenesListaPage(),
        'empresa/recolector/crear': (_) => EmpresaRecolectorCrearPage(),
        'recolector/home': (_) => RecolectorOrdenesListaPage(),
      },
    );
  }
}
