import 'package:flutter/material.dart';
import 'package:game_tag/pages/game_detail/game_detail_page.dart';
import 'package:game_tag/pages/home/home_state.dart';
import 'package:game_tag/pages/home/home_viewmodel.dart';
import 'package:game_tag/pages/login/login_page.dart';
import 'package:game_tag/pages/new_game/new_game_page.dart';
import 'package:game_tag/utils/sized_box_extension.dart';
import 'package:icons_plus/icons_plus.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final HomeViewModel _viewModel = HomeViewModel();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('GameTag'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              bool success = await _viewModel.loggoffUser();
              if (success && context.mounted) {
                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => const LoginPage()));
              }
            },
          ),
        ],
      ),
      body: ValueListenableBuilder(
        valueListenable: _viewModel.state,
        builder: (context, state, _) {
          if (state is ErrorHomeState) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    const Icon(
                      Bootstrap.joystick,
                      size: 128,
                    ),
                    12.h,
                    Text(
                      state.errorMessage,
                      style: const TextStyle(fontSize: 24),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            );
          }
          if (state is SuccessHomeState) {
            return ListView.builder(
              itemCount: state.items.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(state.items[index].title),
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => GameDetailPage(
                          game: state.items[index],
                        ),
                      ),
                    );
                  },
                );
              },
            );
          }

          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                CircularProgressIndicator(),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context)
              .push(
                  MaterialPageRoute(builder: (context) => const NewGamePage()))
              .then(
                (_) => _viewModel.getMyGames(),
              );
        },
        tooltip: 'Create new game',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
