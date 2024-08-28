import 'package:game_tag/models/game.dart';
import 'package:game_tag/service_locator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';
import 'package:uuid/uuid.dart';

class FileService {
  final ImagePicker _picker;

  FileService([ImagePicker? picker])
      : _picker = picker ?? getIt.get<ImagePicker>();

  Future<List<XFile>> getImages() async {
    return _picker.pickMultiImage();
  }

  Future<List<String>> uploadImages(List<XFile> tempImages, Game game) async {
    List<String> urls = [];
    for (var image in tempImages) {
      // Removing the dashes  in the UUID to avoid Parse errors
      var uuid = const Uuid().v1().replaceAll('-', '');

      // Reading bytes of image to avoid issues with the file name
      var imageBytes = await image.readAsBytes();

      var fileName = '$uuid${game.id}';
      var parseFile = ParseWebFile(imageBytes, name: fileName);
      var result = await parseFile.save();
      if (!result.success) {
        throw Exception(result.error!.message);
      }
      urls.add(result.results![0].url!);
    }
    return urls;
  }
}
