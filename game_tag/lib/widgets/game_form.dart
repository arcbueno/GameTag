import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:game_tag/models/game_state.dart';
import 'package:game_tag/models/platform.dart';
import 'package:game_tag/utils/game_utils.dart';
import 'package:game_tag/utils/sized_box_extension.dart';
import 'package:game_tag/widgets/custom_dropdown.dart';
import 'package:game_tag/widgets/custom_form_field.dart';

class GameForm extends StatelessWidget {
  final TextEditingController titleController;
  final TextEditingController publisherController;
  final double? currentRating;
  final Function(String?) onHoursPlayedChanged;
  final Function(double) onRatingChanged;
  final Function(Platform) onPlatformSelected;
  final Function(GameState) onGameStateSelected;
  final List<GameState> gameStates;
  final List<Platform> platforms;
  final Platform? platformSelected;
  final GameState? gameStateSelected;
  final String? error;
  final Function() onSave;
  final String saveButtonText;
  final int? hoursPlayed;

  const GameForm({
    super.key,
    required this.titleController,
    required this.publisherController,
    this.currentRating,
    required this.onHoursPlayedChanged,
    required this.onRatingChanged,
    required this.onPlatformSelected,
    required this.onGameStateSelected,
    required this.gameStates,
    required this.platforms,
    required this.platformSelected,
    required this.gameStateSelected,
    required this.onSave,
    required this.saveButtonText,
    this.error,
    this.hoursPlayed,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Column(
            children: [
              CustomFormField(
                label: 'Game title',
                controller: titleController,
              ),
              24.h,
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
                      controller:
                          TextEditingController(text: hoursPlayed?.toString()),
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                      label: 'Hours played',
                      keyboardType: TextInputType.number,
                      onChanged: onHoursPlayedChanged,
                    ),
                  ),
                ],
              ),
              24.h,
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('Rating: '),
                      Text(currentRating?.toStringAsFixed(2) ?? '0',
                          style: const TextStyle(fontSize: 24)),
                      const Icon(Icons.star_border),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 12, bottom: 8),
                    child: Theme(
                      // Removing the default padding
                      data: Theme.of(context).copyWith(
                        sliderTheme: SliderThemeData(
                          overlayShape: SliderComponentShape.noOverlay,
                        ),
                      ),
                      child: Slider(
                        value: currentRating ?? 0,
                        divisions: 10,
                        min: 0,
                        max: 5,
                        onChanged: onRatingChanged,
                        label: currentRating?.toStringAsFixed(2) ?? '0',
                      ),
                    ),
                  ),
                  Text(GameUtils.getRatingReaction(currentRating)),
                ],
              ),
              24.h,
              Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 52,
                      child: CustomDropdown(
                        label: 'Platform',
                        button: DropdownButton<Platform>(
                          value: platformSelected,
                          items: platforms
                              .map(
                                (e) => DropdownMenuItem(
                                  value: e,
                                  child: Text(e.name),
                                ),
                              )
                              .toList(),
                          onChanged: (val) {
                            if (val != null) {
                              onPlatformSelected(val);
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
                          value: gameStateSelected,
                          items: gameStates
                              .map(
                                (e) => DropdownMenuItem(
                                  value: e,
                                  child: Text(e.name),
                                ),
                              )
                              .toList(),
                          onChanged: (val) {
                            if (val != null) {
                              onGameStateSelected(val);
                            }
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              if (error != null) ...[
                24.h,
                SizedBox(
                  width: double.infinity,
                  child: Card(
                    color: Theme.of(context).colorScheme.error,
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Text(
                        error!,
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                              color: Theme.of(context).colorScheme.onError,
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
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            minimumSize: const Size(double.infinity, 52),
            backgroundColor: Theme.of(context).primaryColor,
          ),
          onPressed: onSave,
          child: Text(
            saveButtonText,
            style: Theme.of(context)
                .textTheme
                .titleLarge
                ?.copyWith(color: Colors.white),
          ),
        ),
      ],
    );
  }
}
