import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:district_navigation_app/themes/atlas_colors.dart';
import 'package:district_navigation_app/themes/app_dimensions.dart';
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
    final d = AppDimensions(context);

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: d.paddingM),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // ── Search button ──────────────────────────────────────────────────
          _SearchButton(d: d, onSearch: onSearch),

          SizedBox(width: d.paddingS),

          // ── Building number input ──────────────────────────────────────────
          Expanded(
            child: TextField(
              controller: controller,
              textAlign: TextAlign.right,
              keyboardType: TextInputType.number,
              textDirection: TextDirection
                  .rtl, // Forces proper Arabic punctuation direction handling
              style: TextStyle(
                color: AtlasColors.textPrimary,
                fontSize: d.fontM,
              ),
              decoration: InputDecoration(
                hintText: 'رقم العمارة...',
                hintTextDirection: TextDirection.rtl,
                hintStyle: TextStyle(
                  color: AtlasColors.textSecondary,
                  fontSize: d.fontM,
                ),
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.symmetric(
                  horizontal: d.paddingM,
                  vertical: d.paddingS,
                ),
              ),
              onSubmitted: (_) => onSearch(),
            ),
          ),

          SizedBox(width: d.paddingS),

          // ── Project dropdown ───────────────────────────────────────────────
          _ProjectDropdown(d: d),
        ],
      ),
    );
  }
}

// ─── Search button ───────────────────────────────────────────────────────────

class _SearchButton extends StatelessWidget {
  final AppDimensions d;
  final VoidCallback onSearch;

  const _SearchButton({required this.d, required this.onSearch});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onSearch,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: d.paddingL,
          vertical: d.paddingS,
        ),
        decoration: BoxDecoration(
          color: AtlasColors.searchBtn,
          borderRadius: BorderRadius.circular(d.borderRadiusS),
        ),
        child: Text(
          'بحث',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: d.fontL,
          ),
        ),
      ),
    );
  }
}

// ─── Project dropdown trigger ────────────────────────────────────────────────

class _ProjectDropdown extends StatelessWidget {
  final AppDimensions d;

  const _ProjectDropdown({required this.d});

  @override
  Widget build(BuildContext context) {
    return Consumer<AtlasSearchProvider>(
      builder: (context, search, _) {
        final projects = search.projects;
        final selected = search.selectedProject;

        return GestureDetector(
          onTap: () => _showProjectPicker(context, search, projects, selected),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.30,
            ),
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: d.paddingM,
                vertical: d.paddingS,
              ),
              decoration: BoxDecoration(
                color: AtlasColors.surfaceLight,
                borderRadius: BorderRadius.circular(d.borderRadiusS),
                border: Border.all(color: AtlasColors.chipBorder),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment
                    .center, // Centers elements beautifully within the box bounds
                children: [
                  Icon(
                    Icons.keyboard_arrow_down,
                    color: AtlasColors.textSecondary,
                    size: d.iconS,
                  ),
                  SizedBox(width: d.paddingXS),
                  Flexible(
                    child: Text(
                      selected ?? 'مشروع...',
                      textDirection: TextDirection.rtl,
                      style: TextStyle(
                        color: AtlasColors.textSecondary,
                        fontSize: d.fontS,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ),
                ],
              ),
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
    final d = AppDimensions(context);
    showModalBottomSheet(
      context: context,
      backgroundColor: AtlasColors.surface,
      isScrollControlled: true,
      // ← Remove the fixed maxHeight constraint entirely
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(d.borderRadius),
        ),
      ),
      builder: (_) => SafeArea(
        child: Padding(
          padding: EdgeInsets.fromLTRB(
            d.paddingL,
            d.paddingL,
            d.paddingL,
            d.paddingM, // ← was paddingXL, reduced
          ),
          child: Column(
            mainAxisSize:
                MainAxisSize.min, // ← This is the key: shrink-wraps to content
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                'اختر المشروع',
                style: TextStyle(
                  color: AtlasColors.textPrimary,
                  fontSize: d.fontXL,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: d.paddingM), // ← was paddingL, tightened
              // No Flexible wrapper needed — ListView shrinks with NeverScrollableScrollPhysics
              ListView.builder(
                shrinkWrap:
                    true, // ← Makes ListView take only the space it needs
                physics: const NeverScrollableScrollPhysics(),
                itemCount: projects.length,
                itemBuilder: (context, index) {
                  final project = projects[index];
                  return ListTile(
                    contentPadding: EdgeInsets.zero,
                    trailing: Text(
                      project,
                      style: TextStyle(
                        color: AtlasColors.textPrimary,
                        fontSize: d.fontM,
                      ),
                    ),
                    leading: selected == project
                        ? const Icon(Icons.check, color: AtlasColors.primary)
                        : null,
                    onTap: () {
                      search.selectProject(project);
                      Navigator.pop(context);
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
