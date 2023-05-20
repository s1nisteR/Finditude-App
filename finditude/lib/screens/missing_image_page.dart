import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:finditude/screens/home_page.dart';

class MissingImagePage extends StatefulWidget {
  final int id;
  final String token;

  const MissingImagePage({super.key, required this.id, required this.token});

  @override
  State<MissingImagePage> createState() => _MissingImagePageState();
}

class _MissingImagePageState extends State<MissingImagePage> {
  final List<File> _selectedImages = [];

  Future<void> _uploadImages() async {
    // Replace with your Django REST API endpoint URL
    const String apiUrl = 'http://192.168.1.168:8000/api/missingimageupload';

    for (int i = 0; i < _selectedImages.length; i++) {
      final File imageFile = _selectedImages[i];
      String idNumber =
          widget.id.toString(); // Replace with the specific ID number

      final uri = Uri.parse(apiUrl);
      final request = http.MultipartRequest('POST', uri);

      request.fields['id'] = idNumber;
      request.fields['jwt'] = widget.token;
      request.files
          .add(await http.MultipartFile.fromPath('photo', imageFile.path));

      await request.send();
    }
  }

  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: source);

    if (pickedImage != null) {
      setState(() {
        _selectedImages.add(File(pickedImage.path));
      });
    }
  }

  Widget _buildSelectedImagesPreview() {
    return Row(
      children: _selectedImages.map((image) {
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 8),
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: FileImage(image),
              fit: BoxFit.cover,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
        );
      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text(
          "Image Upload",
          style: GoogleFonts.dmSans(
              color: const Color(0xff1cb439),
              textStyle: Theme.of(context).textTheme.headlineSmall,
              fontWeight: FontWeight.bold),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildSelectedImagesPreview(),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => _pickImage(ImageSource.camera),
              child: const Text('Take Photo'),
            ),
            ElevatedButton(
              onPressed: () => _pickImage(ImageSource.gallery),
              child: const Text('Choose from Gallery'),
            ),
            ElevatedButton(
              onPressed: () async {
                await _uploadImages();
                if (context.mounted) {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => const HomePage()),
                    (Route<dynamic> route) => false,
                  );
                }
              },
              child: const Text('Upload Images'),
            ),
          ],
        ),
      ),
    );
  }
}
