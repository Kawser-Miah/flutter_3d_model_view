import 'package:flutter/material.dart';
import 'package:flutter_3d_controller/flutter_3d_controller.dart';
import 'package:flutter_3d_model_view/bloc/category_bloc.dart';
import 'package:flutter_3d_model_view/utils/utils.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Flutter 3D Model View"),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
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
}
