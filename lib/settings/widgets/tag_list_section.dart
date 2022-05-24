import 'package:flutter/material.dart';
import 'package:tag_api/tag_api.dart';

class TagListSection extends StatelessWidget {
  const TagListSection(
      {Key? key,
      required this.tags,
      required this.onDeleted,
      required this.onSubmit})
      : super(key: key);

  final List<Tag> tags;
  final Function(Tag) onDeleted;
  final Function(String) onSubmit;

  @override
  Widget build(BuildContext context) {
    TextEditingController _controller = TextEditingController();
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: [
        for (final tag in tags)
          InputChip(
            label: Text(tag.name),
            onDeleted: () => onDeleted(tag),
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 13),
          ),
        IntrinsicWidth(
          child: TextField(
            controller: _controller,
            style: TextStyle(fontSize: 14),
            decoration: InputDecoration(
              hintText: 'tag name',
              isDense: true,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
              suffixIcon: InkWell(
                onTap: () {
                  if (!_controller.text.isEmpty) onSubmit(_controller.text);
                },
                child: Icon(
                  Icons.add_circle,
                ),
              ),
            ),
            onSubmitted: (text) {
              if (!_controller.text.isEmpty) onSubmit(_controller.text);
            },
          ),
        ),
      ],
    );
  }
}
