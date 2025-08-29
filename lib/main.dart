import 'dart:async';
import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get/get.dart';
import 'package:st_01/screens/commets_screen.dart';
import 'package:st_01/screens/loginScreen.dart';
import 'screens/mainScreen.dart';
import 'screens/new_post_screen.dart';
import 'screens/registerScreen.dart';
import 'package:get_storage/get_storage.dart';
void main() async {
  await GetStorage.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
   MyApp({super.key});
  final storage = GetStorage();
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Connectivity Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      initialRoute:storage.read('token') != null ? '/main' : '/login',
      getPages: [
        GetPage(name: '/', page: () => RegisterScreen()),
        GetPage(name: '/register', page: () => RegisterScreen()),
        GetPage(name: '/login', page: () => Loginscreen()),
        GetPage(name: '/main', page: () => Mainscreen()),
        GetPage(name: '/comment', page: ()=>CommentsScreen()),
        GetPage(name: '/newpost', page: () => CreatePostScreen()),
      ],
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final StreamController<ConnectivityResult> _connectivityStream =
  StreamController<ConnectivityResult>.broadcast();


  @override
  void initState() {
    super.initState();

    // Listen to connectivity changes
    Connectivity().onConnectivityChanged.listen((List<ConnectivityResult> event) {
     _connectivityStream.add(event.first);
    });
  }

  @override
  void dispose() {     // close the stream
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Connectivity Demo'),
      ),
      body: Center(
        child: StreamBuilder<ConnectivityResult>(
          stream: _connectivityStream.stream,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final connectivityResult = snapshot.data!;
              if (connectivityResult == ConnectivityResult.mobile) {
                return Mainscreen();
              } else if(connectivityResult == ConnectivityResult.wifi) {
                return Mainscreen();
              }else  {
                return  Image.asset('assets/images/1_No_Connection.png',
                    height: Get.height,
                    fit: BoxFit.cover,);
              }
            } else {
              return const CircularProgressIndicator();
            }
          },
        ),
      )
    );
  }
}
