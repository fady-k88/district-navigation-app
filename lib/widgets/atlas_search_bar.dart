import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:district_navigation_app/themes/atlas_colors.dart';
import 'package:district_navigation_app/providers/atlas_search_provider.dart';

class AtlasSearchBar extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onSearch;

  const AtlasSearchBar({
    super.key,
    required this.controller,
    required this.onSearch,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        children: [
          // Search button
          GestureDetector(
            onTap: onSearch,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              decoration: BoxDecoration(
                color: AtlasColors.searchBtn,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Text(
                'بحث',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),

          // Building number input
          Expanded(
            child: TextField(
              controller: controller,
              textAlign: TextAlign.right,
              keyboardType: TextInputType.number,
              style: const TextStyle(color: AtlasColors.textPrimary),
              decoration: const InputDecoration(
                hintText: 'رقم العمارة...',
                hintStyle: TextStyle(color: AtlasColors.textSecondary),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 12,
                ),
              ),
              onSubmitted: (_) => onSearch(),
            ),
          ),
          const SizedBox(width: 8),

          // Project dropdown
          _ProjectDropdown(),
        ],
      ),
    );
  }
}

class _ProjectDropdown extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<AtlasSearchProvider>(
      builder: (context, search, _) {
        final projects = search.projects;
        final selected = search.selectedProject;

        return GestureDetector(
          onTap: () => _showProjectPicker(context, search, projects, selected),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
            decoration: BoxDecoration(
              color: AtlasColors.surfaceLight,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AtlasColors.chipBorder),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.keyboard_arrow_down,
                  color: AtlasColors.textSecondary,
                  size: 16,
                ),
                const SizedBox(width: 4),
                Text(
                  selected ?? 'مشروع...',
                  style: const TextStyle(
                    color: AtlasColors.textSecondary,
                    fontSize: 12,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showProjectPicker(
    BuildContext context,
    AtlasSearchProvider search,
    List<String> projects,
    String? selected,
  ) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AtlasColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            const Text(
              'اختر المشروع',
              style: TextStyle(
                color: AtlasColors.textPrimary,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            ...projects.map(
              (project) => ListTile(
                contentPadding: EdgeInsets.zero,
                trailing: Text(
                  project,
                  style: const TextStyle(color: AtlasColors.textPrimary),
                ),
                leading: selected == project
                    ? const Icon(Icons.check, color: AtlasColors.primary)
                    : null,
                onTap: () {
                  search.selectProject(project);
                  Navigator.pop(context);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
