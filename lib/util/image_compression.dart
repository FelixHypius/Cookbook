import 'dart:io';
import 'dart:typed_data';
import 'package:image/image.dart' as img;

Future<File> compress(File orgImg, int fileSize) async {
  final imgSize = await orgImg.length();
  final int quality = ((fileSize / imgSize) * 100).round().clamp(0, 100);

  // Create a temporary file to store the compressed image
  final Directory tempDir = Directory.systemTemp;
  final String tempPath = '${tempDir.path}/compressed_${orgImg.uri.pathSegments.last}';
  final File compressedFile = File(tempPath);

  // Reading image for compression and cropping
  final imageBytes = await orgImg.readAsBytes();
  final decodedImage = img.decodeImage(imageBytes);
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
  final Uint8List compressedBytes = Uint8List.fromList(img.encodeJpg(croppedImage, quality: quality));
  await compressedFile.writeAsBytes(compressedBytes);

  // Return the path to the compressed image
  return compressedFile;
}
