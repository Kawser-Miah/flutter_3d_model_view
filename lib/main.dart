import 'package:flutter/material.dart';
import 'package:flutter_3d_controller/flutter_3d_controller.dart';
import 'package:flutter_3d_model_view/bloc/category_bloc.dart';
import 'package:flutter_3d_model_view/utils/utils.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:audioplayers/audioplayers.dart';


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
      home: BlocProvider(
        create: (context) => CategoryBloc()
          ..add(CategoryEvent.started(category: Utils.category[0])),
        child: HomePage(),
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int selectedIndex = 0;
  Flutter3DController controller = Flutter3DController();
  String? chosenAnimation;
  String? chosenTexture;
  final player = AudioPlayer();

  @override
  void initState() {
    super.initState();
    player.setVolume(0.1);
    controller.onModelLoaded.addListener(() {
      debugPrint('model is loaded : ${controller.onModelLoaded.value}');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Flutter 3D Model View"),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            onPressed: () {
              player.play(AssetSource('audio/battle-of-fantasia.mp3'));
            },
            icon: const Icon(Icons.play_arrow),
          ),
          IconButton(
            onPressed: () {
              player.pause();
            },
            icon: const Icon(Icons.pause),
          ),
          IconButton(
            onPressed: () {
              player.stop();
            },
            icon: const Icon(Icons.stop),
          ),
          IconButton(
            onPressed: () {
              controller.playAnimation();
            },
            icon: const Icon(Icons.play_arrow),
          ),
          const SizedBox(
            height: 4,
          ),
          IconButton(
            onPressed: () {
              controller.pauseAnimation();
              //controller.stopAnimation();
            },
            icon: const Icon(Icons.pause),
          ),
          const SizedBox(
            height: 4,
          ),
          IconButton(
            onPressed: () {
              controller.resetAnimation();
            },
            icon: const Icon(Icons.replay_circle_filled),
          ),
          const SizedBox(
            height: 4,
          ),
          IconButton(
            onPressed: () async {
              List<String> availableAnimations =
                  await controller.getAvailableAnimations();
              debugPrint(
                  'Animations : $availableAnimations --- Length : ${availableAnimations.length}');
              chosenAnimation = await showPickerDialog(
                  'Animations', availableAnimations, chosenAnimation);
              controller.playAnimation(animationName: chosenAnimation);
            },
            icon: const Icon(Icons.format_list_bulleted_outlined),
          ),
          const SizedBox(
            height: 4,
          ),
          IconButton(
            onPressed: () async {
              List<String> availableTextures =
                  await controller.getAvailableTextures();
              debugPrint(
                  'Textures : $availableTextures --- Length : ${availableTextures.length}');
              chosenTexture = await showPickerDialog(
                  'Textures', availableTextures, chosenTexture);
              controller.setTexture(textureName: chosenTexture ?? '');
            },
            icon: const Icon(Icons.list_alt_rounded),
          ),
          const SizedBox(
            height: 4,
          ),
          IconButton(
            onPressed: () {
              controller.setCameraOrbit(20, 20, 5);
              //controller.setCameraTarget(0.3, 0.2, 0.4);
            },
            icon: const Icon(Icons.camera_alt),
          ),
          const SizedBox(
            height: 4,
          ),
          IconButton(
            onPressed: () {
              controller.resetCameraOrbit();
              //controller.resetCameraTarget();
            },
            icon: const Icon(Icons.cameraswitch_outlined),
          )
        ],
      ),
      body: BlocBuilder<CategoryBloc, CategoryState>(
        builder: (context, state) {
          return Column(
            children: [
              SizedBox(
                height: 80,
                child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: Utils.category.length,
                    itemBuilder: (context, index) {
                      final category = Utils.category;

                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            context.read<CategoryBloc>().add(
                                CategoryEvent.started(
                                    category: category[index]));
                            debugPrint(category[index].title);
                            selectedIndex = index;
                          });
                        },
                        child: Container(
                          margin: const EdgeInsets.all(10),
                          width: 150,
                          decoration: BoxDecoration(
                              color: (category[index].id == selectedIndex)
                                  ? Colors.deepPurple
                                  : Colors.grey,
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
              BlocBuilder<CategoryBloc, CategoryState>(
                builder: (context, state) {
                  if (state is CategoryLoadedState) {
                    return SizedBox(
                        height: MediaQuery.of(context).size.height * 0.6,
                        child: Flutter3DViewer(
                          controller: controller,
                          src: state.category.assets,
                          //     src: "https://models.readyplayer.me/670cd125aaa8b6f7ebb57da7.glb",
                          activeGestureInterceptor: false,
                        ));
                  } else {
                    return Container();
                  }
                },
              ),
            ],
          );
        },
      ),
    );
  }

  Future<String?> showPickerDialog(String title, List<String> inputList,
      [String? chosenItem]) async {
    return await showModalBottomSheet<String>(
        context: context,
        builder: (ctx) {
          return SizedBox(
            height: 250,
            child: inputList.isEmpty
                ? Center(
                    child: Text('$title list is empty'),
                  )
                : ListView.separated(
                    itemCount: inputList.length,
                    padding: const EdgeInsets.only(top: 16),
                    itemBuilder: (ctx, index) {
                      return InkWell(
                        onTap: () {
                          Navigator.pop(context, inputList[index]);
                        },
                        child: Container(
                          height: 50,
                          padding: const EdgeInsets.all(16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('${index + 1}'),
                              Text(inputList[index]),
                              Icon(
                                chosenItem == inputList[index]
                                    ? Icons.check_box
                                    : Icons.check_box_outline_blank,
                              )
                            ],
                          ),
                        ),
                      );
                    },
                    separatorBuilder: (ctx, index) {
                      return const Divider(
                        color: Colors.grey,
                        thickness: 0.6,
                        indent: 10,
                        endIndent: 10,
                      );
                    },
                  ),
          );
        });
  }
}
