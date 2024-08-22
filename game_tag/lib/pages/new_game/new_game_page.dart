import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:game_tag/models/game_state.dart';
import 'package:game_tag/models/platform.dart';
import 'package:game_tag/pages/new_game/new_game_state.dart';
import 'package:game_tag/pages/new_game/new_game_viewmodel.dart';
import 'package:game_tag/utils/sized_box_extension.dart';
import 'package:game_tag/widgets/custom_dropdown.dart';
import 'package:game_tag/widgets/custom_form_field.dart';

class NewGamePage extends StatefulWidget {
  const NewGamePage({super.key});

  @override
  State<NewGamePage> createState() => _NewGamePageState();
}

class _NewGamePageState extends State<NewGamePage> {
  final _viewModel = NewGameViewModel();
  final _formKey = GlobalKey<FormState>();

  final TextEditingController titleController = TextEditingController();
  final TextEditingController publisherController = TextEditingController();
  int? hoursPlayed = 0;
  double? rating;
  Platform? platform;
  GameState? state;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New Game'),
      ),
      body: ValueListenableBuilder(
        valueListenable: _viewModel.state,
        builder: (context, state, _) {
          if (state is! FillingState) {
            return const Center(child: CircularProgressIndicator());
          }
          return Padding(
            padding: const EdgeInsets.all(12.0),
            child: Stack(
              children: [
                Column(
                  children: [
                    Expanded(
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            CustomFormField(
                              label: 'Game title',
                              controller: titleController,
                            ),
                            12.h,
                            Row(
                              children: [
                                Expanded(
                                  flex: 2,
                                  child: CustomFormField(
                                    label: 'Publisher',
                                    controller: publisherController,
                                  ),
                                ),
                                12.w,
                                Expanded(
                                  child: CustomFormField(
                                    inputFormatters: [
                                      FilteringTextInputFormatter.digitsOnly,
                                    ],
                                    label: 'Hours played',
                                    keyboardType: TextInputType.number,
                                    onChanged: (value) {
                                      hoursPlayed = int.tryParse(value ?? '');
                                    },
                                  ),
                                ),
                              ],
                            ),
                            12.h,
                            Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Text('Rating: '),
                                    Text(
                                        state.rating?.toStringAsFixed(2) ?? '0',
                                        style: const TextStyle(fontSize: 24)),
                                    const Icon(Icons.star_border),
                                  ],
                                ),
                                Slider(
                                  value: state.rating ?? 0,
                                  divisions: 10,
                                  min: 0,
                                  max: 5,
                                  onChanged: _viewModel.selectRating,
                                  label:
                                      state.rating?.toStringAsFixed(2) ?? '0',
                                ),
                              ],
                            ),
                            12.h,
                            Row(
                              children: [
                                Expanded(
                                  child: SizedBox(
                                    height: 52,
                                    child: CustomDropdown(
                                      label: 'Platform',
                                      button: DropdownButton<Platform>(
                                        value: state.platformSelected,
                                        items: state.platforms
                                            .map(
                                              (e) => DropdownMenuItem(
                                                value: e,
                                                child: Text(e.name),
                                              ),
                                            )
                                            .toList(),
                                        onChanged: (val) {
                                          if (val != null) {
                                            _viewModel.selectPlatform(val);
                                          }
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                                12.w,
                                Expanded(
                                  child: SizedBox(
                                    height: 52,
                                    child: CustomDropdown(
                                      label: 'Current state',
                                      button: DropdownButton<GameState>(
                                        value: state.gameStateSelected,
                                        items: state.gameStates
                                            .map(
                                              (e) => DropdownMenuItem(
                                                value: e,
                                                child: Text(e.name),
                                              ),
                                            )
                                            .toList(),
                                        onChanged: (val) {
                                          if (val != null) {
                                            _viewModel.selectGameState(val);
                                          }
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            if (state.error != null) ...[
                              24.h,
                              SizedBox(
                                width: double.infinity,
                                child: Card(
                                  color: Theme.of(context).colorScheme.error,
                                  child: Padding(
                                    padding: const EdgeInsets.all(12.0),
                                    child: Text(
                                      state.error!,
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleSmall
                                          ?.copyWith(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onError,
                                          ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 52),
                        backgroundColor: Theme.of(context).primaryColor,
                      ),
                      onPressed: () async {
                        var error = _viewModel.validate(
                            titleController.text,
                            publisherController.text.isEmpty
                                ? null
                                : publisherController.text,
                            hoursPlayed?.toDouble() ?? 0,
                            state.rating,
                            state.gameStateSelected,
                            state.platformSelected);
                        if (error != null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(error),
                            ),
                          );
                          return;
                        }

                        var success = await _viewModel.createGame(
                          titleController.text,
                          publisherController.text.isEmpty
                              ? null
                              : publisherController.text,
                          hoursPlayed?.toDouble() ?? 0,
                          state.rating,
                          state.gameStateSelected!,
                          state.platformSelected!,
                        );
                        if (success && context.mounted) {
                          Navigator.pop(context);
                        }
                      },
                      child: Text(
                        'Create new game',
                        style: Theme.of(context)
                            .textTheme
                            .titleLarge
                            ?.copyWith(color: Colors.white),
                      ),
                    )
                  ],
                ),
                if (state.isLoading)
                  const Center(
                    child: CircularProgressIndicator(),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}
