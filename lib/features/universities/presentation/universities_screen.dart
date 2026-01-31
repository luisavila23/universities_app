import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../state/universities_controller.dart';
import 'university_detail_screen.dart';
import 'widgets/university_tile.dart';

class UniversitiesScreen extends ConsumerStatefulWidget {
  const UniversitiesScreen({super.key});

  @override
  ConsumerState<UniversitiesScreen> createState() => _UniversitiesScreenState();
}

class _UniversitiesScreenState extends ConsumerState<UniversitiesScreen> {
  late final ScrollController _controller;

  @override
  void initState() {
    super.initState();
    _controller = ScrollController()
      ..addListener(() {
        final pos = _controller.position;
        if (pos.pixels >= pos.maxScrollExtent * 0.8) {
          ref.read(universitiesControllerProvider.notifier).loadMore();
        }
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(universitiesControllerProvider);
    final ctrl = ref.read(universitiesControllerProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Universities'),
        actions: [
          IconButton(
            onPressed: ctrl.toggleLayout,
            icon: Icon(state.layoutMode == LayoutMode.list ? Icons.grid_view : Icons.view_list),
          ),
        ],
      ),
      body: Builder(builder: (_) {
        if (state.isLoading) return const Center(child: CircularProgressIndicator());
        if (state.error != null) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Error: ${state.error}'),
                  const SizedBox(height: 12),
                  ElevatedButton(onPressed: ctrl.init, child: const Text('Retry')),
                ],
              ),
            ),
          );
        }

        if (state.layoutMode == LayoutMode.list) {
          return ListView.builder(
            controller: _controller,
            itemCount: state.visible.length + (state.hasMore ? 1 : 0),
            itemBuilder: (context, index) {
              if (index >= state.visible.length) {
                return const Padding(
                  padding: EdgeInsets.symmetric(vertical: 24),
                  child: Center(child: CircularProgressIndicator()),
                );
              }
              final u = state.visible[index];
              return UniversityTile(
                university: u,
                edits: state.editsById[u.id],
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => UniversityDetailScreen(universityId: u.id)),
                ),
              );
            },
          );
        }

        return GridView.builder(
          controller: _controller,
          padding: const EdgeInsets.all(8),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 8,
            crossAxisSpacing: 8,
            childAspectRatio: 1.1,
          ),
          itemCount: state.visible.length + (state.hasMore ? 1 : 0),
          itemBuilder: (context, index) {
            if (index >= state.visible.length) {
              return const Center(child: CircularProgressIndicator());
            }
            final u = state.visible[index];
            return Card(
              child: UniversityTile(
                university: u,
                edits: state.editsById[u.id],
                isGrid: true,
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => UniversityDetailScreen(universityId: u.id)),
                ),
              ),
            );
          },
        );
      }),
    );
  }
}
