import 'package:flutter/material.dart';
import 'package:flutter_3d_controller/flutter_3d_controller.dart';
import 'package:flutter_3d_model_view/utils/utils.dart';

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
      body: Column(
        children: [
          SizedBox(
            height: 80,
            child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: Utils.category.length,
                itemBuilder: (context, index) {
                  final category = Utils.category;
                  return GestureDetector(
                    onTap: (){debugPrint(category[index].title);},
                    child: Container(
                      margin: const EdgeInsets.all(10),
                      width: 150,
                      decoration: BoxDecoration(
                          color: Colors.grey,
                          borderRadius: BorderRadius.circular(8)),
                      child: Center(
                          child: Text(
                        category[index].title,
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w500),
                      )),
                    ),
                  );
                }),
          ),
          SizedBox(
              height: MediaQuery.of(context).size.height * 0.6,
              child: const Flutter3DViewer(
                src: Assets.threeDUn,
                //     src: "https://models.readyplayer.me/670cd125aaa8b6f7ebb57da7.glb",
                activeGestureInterceptor: false,
              )),
        ],
      ),
    );
  }
}
