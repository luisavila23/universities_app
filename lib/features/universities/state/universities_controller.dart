import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/university_repository.dart';
import '../domain/university.dart';
import '../domain/university_edits.dart';

enum LayoutMode { list, grid }

class UniversitiesState {
  final bool isLoading;
  final String? error;
  final LayoutMode layoutMode;
  final List<University> all;
  final List<University> visible;
  final bool hasMore;
  final Map<String, UniversityEdits> editsById;

  const UniversitiesState({
    required this.isLoading,
    required this.error,
    required this.layoutMode,
    required this.all,
    required this.visible,
    required this.hasMore,
    required this.editsById,
  });

  factory UniversitiesState.initial() => const UniversitiesState(
        isLoading: true,
        error: null,
        layoutMode: LayoutMode.list,
        all: [],
        visible: [],
        hasMore: true,
        editsById: {},
      );

  UniversitiesState copyWith({
    bool? isLoading,
    String? error,
    LayoutMode? layoutMode,
    List<University>? all,
    List<University>? visible,
    bool? hasMore,
    Map<String, UniversityEdits>? editsById,
  }) {
    return UniversitiesState(
      isLoading: isLoading ?? this.isLoading,
      error: error,
      layoutMode: layoutMode ?? this.layoutMode,
      all: all ?? this.all,
      visible: visible ?? this.visible,
      hasMore: hasMore ?? this.hasMore,
      editsById: editsById ?? this.editsById,
    );
  }
}

final dioProvider = Provider((ref) => Dio());
final repoProvider = Provider((ref) => UniversityRepository(ref.read(dioProvider)));

final universitiesControllerProvider =
    StateNotifierProvider<UniversitiesController, UniversitiesState>((ref) {
  return UniversitiesController(ref.read(repoProvider))..init();
});

class UniversitiesController extends StateNotifier<UniversitiesState> {
  UniversitiesController(this._repo) : super(UniversitiesState.initial());
  final UniversityRepository _repo;

  static const int _pageSize = 20;

  Future<void> init() async {
    try {
      state = state.copyWith(isLoading: true, error: null);
      final all = await _repo.fetchAll();
      final first = all.take(_pageSize).toList();

      state = state.copyWith(
        isLoading: false,
        all: all,
        visible: first,
        hasMore: all.length > first.length,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  void toggleLayout() {
    final next = state.layoutMode == LayoutMode.list ? LayoutMode.grid : LayoutMode.list;
    state = state.copyWith(layoutMode: next);
  }

  void loadMore() {
    if (state.isLoading || !state.hasMore) return;
    final nextCount = state.visible.length + _pageSize;
    final nextVisible = state.all.take(nextCount).toList();
    state = state.copyWith(
      visible: nextVisible,
      hasMore: state.all.length > nextVisible.length,
    );
  }

  void setStudents(String id, int students) {
    final current = state.editsById[id] ?? const UniversityEdits();
    state = state.copyWith(editsById: {...state.editsById, id: current.copyWith(students: students)});
  }

  void setImage(String id, File file) {
    final current = state.editsById[id] ?? const UniversityEdits();
    state = state.copyWith(editsById: {...state.editsById, id: current.copyWith(imageFile: file)});
  }
}
