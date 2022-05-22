import 'dart:io';

import 'package:flutter/material.dart';
import 'package:imgs_repository/imgs_repository.dart';
import 'package:tag_api/tag_api.dart';

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

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: EdgeInsets.only(bottom: 10),
          child: Text(
            'Lista delle immagini:',
            style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
          ),
        ),
        Wrap(
          spacing: 5,
          children: [
            for (final img in imgs)
              Column(
                children: [
                  Container(
                    width: size.width * 0.2,
                    height: size.height * 0.2,
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
                    width: size.width * 0.2,
                    height: size.height * 0.07,
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
                            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold,),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        InkWell(
                          child: Icon(Icons.cancel),
                          onTap: ()=>onDeleted(img),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
          ],
        )
      ],
    );
  }
}
