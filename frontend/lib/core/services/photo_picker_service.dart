import 'package:image_picker/image_picker.dart';

class PhotoSelectionResult {
  PhotoSelectionResult({
    required List<XFile> photos,
    required this.exceededLimit,
  }) : photos = List.unmodifiable(photos);

  final List<XFile> photos;
  final bool exceededLimit;
}

class PhotoPickerService {
  PhotoPickerService({ImagePicker? imagePicker})
    : _imagePicker = imagePicker ?? ImagePicker();

  static const maxPhotoCount = 10;

  final ImagePicker _imagePicker;

  Future<XFile?> pickSingleFromGallery() {
    return _imagePicker.pickImage(source: ImageSource.gallery);
  }

  Future<PhotoSelectionResult> pickFromGallery() async {
    final selectedPhotos = await _imagePicker.pickMultiImage();
    final exceededLimit = selectedPhotos.length > maxPhotoCount;

    final photos = selectedPhotos.take(maxPhotoCount).toList();

    return PhotoSelectionResult(photos: photos, exceededLimit: exceededLimit);
  }

  Future<List<XFile>> takePhoto() async {
    final photo = await _imagePicker.pickImage(source: ImageSource.camera);

    if (photo == null) {
      return [];
    }

    return [photo];
  }
}
