import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import '../state/universities_controller.dart';

class UniversityDetailScreen extends ConsumerStatefulWidget {
  const UniversityDetailScreen({super.key, required this.universityId});
  final String universityId;

  @override
  ConsumerState<UniversityDetailScreen> createState() => _UniversityDetailScreenState();
}

class _UniversityDetailScreenState extends ConsumerState<UniversityDetailScreen> {
  final _formKey = GlobalKey<FormState>();
  final _studentsCtrl = TextEditingController();
  final _picker = ImagePicker();

  @override
  void dispose() {
    _studentsCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickImage(ImageSource source) async {
    final picked = await _picker.pickImage(source: source, imageQuality: 80);
    if (picked == null) return;
    ref.read(universitiesControllerProvider.notifier).setImage(widget.universityId, File(picked.path));
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(universitiesControllerProvider);
    final ctrl = ref.read(universitiesControllerProvider.notifier);

    final uni = state.all.firstWhere((u) => u.id == widget.universityId);
    final edits = state.editsById[widget.universityId];
    final img = edits?.imageFile;

    return Scaffold(
      appBar: AppBar(title: Text(uni.name)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          SizedBox(
            height: 220,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: Container(
                color: Colors.black12,
                child: img != null ? Image.file(img, fit: BoxFit.cover) : const Center(child: Icon(Icons.photo, size: 48)),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            children: [
              ElevatedButton.icon(
                onPressed: () => _pickImage(ImageSource.gallery),
                icon: const Icon(Icons.photo_library),
                label: const Text('Gallery'),
              ),
              ElevatedButton.icon(
                onPressed: () => _pickImage(ImageSource.camera),
                icon: const Icon(Icons.photo_camera),
                label: const Text('Camera'),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text('Country: ${uni.country}'),
          if (uni.stateProvince != null) Text('State/Province: ${uni.stateProvince}'),
          const SizedBox(height: 8),
          if (uni.webPages.isNotEmpty) Text('Website: ${uni.webPages.first}'),
          const Divider(height: 32),
          Form(
            key: _formKey,
            child: TextFormField(
              controller: _studentsCtrl,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              decoration: const InputDecoration(
                labelText: 'Number of students',
                border: OutlineInputBorder(),
              ),
              validator: (v) {
                final text = (v ?? '').trim();
                if (text.isEmpty) return 'Required';
                final n = int.tryParse(text);
                if (n == null) return 'Must be a number';
                if (n <= 0) return 'Must be greater than 0';
                return null;
              },
            ),
          ),
          const SizedBox(height: 12),
          ElevatedButton(
            onPressed: () {
              if (!_formKey.currentState!.validate()) return;
              final n = int.parse(_studentsCtrl.text.trim());
              ctrl.setStudents(widget.universityId, n);
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Saved')));
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }
}
