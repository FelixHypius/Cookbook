import 'dart:typed_data';
import 'package:image/image.dart' as img;

Future<Uint8List> compress(Uint8List orgImg, int fileSize) async {
  final int imgSize = orgImg.length;
  final int quality = ((fileSize / imgSize) * 100).round().clamp(0, 100);

  final decodedImage = img.decodeImage(orgImg);
  if (decodedImage == null) {
    throw Exception('Could not decode image.');
  }

  // Cropping
  int targetHeight = (decodedImage.width * (4/3)).round();
  int targetWidth = decodedImage.width;
  int cropWidth = targetWidth;
  int cropHeight = decodedImage.height < targetHeight ? decodedImage.height : targetHeight;
  int xOffset = (decodedImage.width - cropWidth) ~/ 2;
  int yOffset = (decodedImage.height - cropHeight) ~/ 2;
  img.Image croppedImage = img.copyCrop(decodedImage, x: xOffset, y: yOffset, width: cropWidth, height: cropHeight);

  // Compression
  return Uint8List.fromList(img.encodeJpg(croppedImage, quality: quality));
}
