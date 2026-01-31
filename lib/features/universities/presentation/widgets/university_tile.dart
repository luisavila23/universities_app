import 'package:flutter/material.dart';
import '../../domain/university.dart';
import '../../domain/university_edits.dart';

class UniversityTile extends StatelessWidget {
  const UniversityTile({
    super.key,
    required this.university,
    required this.edits,
    required this.onTap,
    this.isGrid = false,
  });

  final University university;
  final UniversityEdits? edits;
  final VoidCallback onTap;
  final bool isGrid;

  @override
  Widget build(BuildContext context) {
    final img = edits?.imageFile;
    final students = edits?.students;

    final imageWidget = ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Container(
        color: Colors.black12,
        child: img != null
            ? Image.file(img, fit: BoxFit.cover, width: double.infinity, height: double.infinity)
            : const Center(child: Icon(Icons.school)),
      ),
    );

    final info = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(university.name, maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.w600)),
        const SizedBox(height: 4),
        Text(university.country, maxLines: 1, overflow: TextOverflow.ellipsis),
        if (students != null) ...[
          const SizedBox(height: 4),
          Text('Students: $students'),
        ],
      ],
    );

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: isGrid
            ? Column(children: [Expanded(child: imageWidget), const SizedBox(height: 8), info])
            : Row(children: [SizedBox(width: 72, height: 72, child: imageWidget), const SizedBox(width: 12), Expanded(child: info)]),
      ),
    );
  }
}
