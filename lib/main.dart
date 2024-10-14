import 'package:flutter/material.dart';
import 'package:flutter_3d_controller/flutter_3d_controller.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';

import 'generated/assets.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: false,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Flutter 3D Model View"),
        centerTitle: true,
      ),
      body: SizedBox(
          height: MediaQuery.of(context).size.height * 0.8,
          child: const Flutter3DViewer(
            src: Assets.threeDUn,
            //     src: "https://models.readyplayer.me/670cd125aaa8b6f7ebb57da7.glb",
            activeGestureInterceptor: false,

          )),
    );
  }
}
