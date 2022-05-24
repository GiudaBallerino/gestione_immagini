import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:imgs_repository/imgs_repository.dart';
import 'package:path_provider/path_provider.dart';

class ImgListSection extends StatelessWidget {
  const ImgListSection(
      {Key? key,
      required this.imgs,
      required this.onDeleted,
      required this.onSubmit})
      : super(key: key);

  final List<Img> imgs;
  final Function(Img) onDeleted;
  final Function(String) onSubmit;

  void _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      dialogTitle: 'Seleziona una o più immagini',
      type: FileType.image,
    );

    if (result == null) return;

    String destPath = await getDestPath();
    final Directory _appDocDirFolder =
        Directory('$destPath\\gestione_immagini\\');

    if (!(await Directory('$destPath\\gestione_immagini\\').exists())) {
      final Directory _appDocDirNewFolder =
          await _appDocDirFolder.create(recursive: true);
    }

    for (PlatformFile img in result.files) {
      File imgFile = File(img.path!);
      String basename = img.path!.split("\\").last;

      imgFile.copy('${_appDocDirFolder.path}$basename').then((file) {
        onSubmit(file.path);
      });
    }
  }

  Future<String> getDestPath() async {
    Directory appDocumentsDirectory =
        await getApplicationDocumentsDirectory(); // 1
    String appDocumentsPath = appDocumentsDirectory.path; // 2

    return appDocumentsPath;
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Wrap(
        spacing: 10,
        runSpacing: 10,
        children: [
          for (final img in imgs)
            Column(
              children: [
                Container(
                  width: size.width * 0.15,
                  height: size.width * 0.12,
                  decoration: BoxDecoration(
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(20)),
                    image: DecorationImage(
                      image: FileImage(
                        File(img.path),
                      ),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Container(
                  width: size.width * 0.15,
                  height: size.width * 0.03,
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                    color: Colors.grey[400],
                    borderRadius:
                        BorderRadius.vertical(bottom: Radius.circular(20)),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          img.path.split('\\').last,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      InkWell(
                        child: Icon(Icons.cancel),
                        onTap: () => onDeleted(img),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          InkWell(
            child: Container(
              width: size.width * 0.15,
              height: size.width * 0.15,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.grey, width: 1),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.upload_file,
                    size: 45,
                  ),
                  Text(
                    "Carica immagine",
                    style: TextStyle(fontSize: 20),
                  ),
                ],
              ),
            ),
            onTap: () {
              _pickFile();
            },
          ),
        ],
    );
  }
}
