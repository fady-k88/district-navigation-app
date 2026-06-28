// widgets/building_bottom_sheet.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:district_navigation_app/models/building.dart';
import 'package:district_navigation_app/themes/atlas_colors.dart';
import 'package:district_navigation_app/themes/app_dimensions.dart';
import 'package:district_navigation_app/providers/settings_provider.dart';

class BuildingBottomSheet extends StatefulWidget {
  final Building building;
  final VoidCallback onNavigate;
  final VoidCallback onClose;

  const BuildingBottomSheet({
    super.key,
    required this.building,
    required this.onNavigate,
    required this.onClose,
  });

  @override
  State<BuildingBottomSheet> createState() => _BuildingBottomSheetState();
}

class _BuildingBottomSheetState extends State<BuildingBottomSheet> {
  bool _navigating = false;

  @override
  Widget build(BuildContext context) {
    final d = AppDimensions(context);
    final b = widget.building;
    final settings = context.watch<SettingsProvider>();

    return SafeArea(
      bottom: false,
      child: Container(
        margin: EdgeInsets.fromLTRB(d.paddingM, 0, d.paddingM, d.paddingM),
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.85,
        ),
        decoration: BoxDecoration(
          color: AtlasColors.surface,
          borderRadius: BorderRadius.circular(d.borderRadius),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: d.paddingM),

              // ── Drag handle ───────────────────────────────────────────────
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AtlasColors.chipBorder,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              SizedBox(height: d.paddingL),

              // ── Header row ────────────────────────────────────────────────
              Padding(
                padding: EdgeInsets.symmetric(horizontal: d.paddingL),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    _CloseButton(d: d, onClose: widget.onClose),
                    SizedBox(width: d.paddingM),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'عمارة رقم ${b.number}',
                            textAlign: TextAlign.right,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style: TextStyle(
                              color: AtlasColors.textPrimary,
                              fontSize: d.fontXL,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            b.project,
                            textAlign: TextAlign.right,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style: TextStyle(
                              color: settings.accentColor,
                              fontSize: d.fontM,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: d.paddingL),

              // ── Coordinates card ──────────────────────────────────────────
              Padding(
                padding: EdgeInsets.symmetric(horizontal: d.paddingL),
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(d.paddingM),
                  decoration: BoxDecoration(
                    color: AtlasColors.surfaceLight,
                    borderRadius: BorderRadius.circular(d.borderRadiusS),
                  ),
                  child: Column(
                    children: [
                      _CoordRow(
                        label: ':خط الطول',
                        value: b.longitude.toStringAsFixed(7),
                        d: d,
                      ),
                      SizedBox(height: d.paddingS),
                      _CoordRow(
                        label: ':دائرة العرض',
                        value: b.latitude.toStringAsFixed(7),
                        d: d,
                      ),
                      SizedBox(height: d.paddingS),
                      _CoordRow(label: ':الارتفاع', value: 'غير متوفر', d: d),
                    ],
                  ),
                ),
              ),
              SizedBox(height: d.paddingL),

              // ── Navigation button ─────────────────────────────────────────
              Padding(
                padding: EdgeInsets.symmetric(horizontal: d.paddingL),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _navigating
                          ? AtlasColors.danger
                          : settings.accentColor,
                      padding: EdgeInsets.symmetric(vertical: d.paddingM),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(d.borderRadiusS),
                      ),
                    ),
                    onPressed: () {
                      if (_navigating) {
                        setState(() => _navigating = false);
                      } else {
                        setState(() => _navigating = true);
                        widget.onNavigate();
                      }
                    },
                    icon: Icon(
                      _navigating ? Icons.close : Icons.navigation,
                      color: Colors.white,
                      size: d.iconS,
                    ),
                    label: Text(
                      _navigating
                          ? 'إنهاء الملاحة الفورية'
                          : 'ابدأ الملاحة الفورية',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: d.fontM,
                      ),
                    ),
                  ),
                ),
              ),

              SizedBox(height: d.paddingM),

              // ── Ad placeholder ────────────────────────────────────────────
              Padding(
                padding: EdgeInsets.symmetric(horizontal: d.paddingL),
                child: Container(
                  width: double.infinity,
                  height: 56,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(d.borderRadiusS),
                    border: Border.all(color: AtlasColors.chipBorder),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    'مساحة إعلانية',
                    style: TextStyle(
                      color: AtlasColors.textSecondary,
                      fontSize: d.fontM,
                    ),
                  ),
                ),
              ),

              SizedBox(
                height: d.paddingXL + MediaQuery.of(context).padding.bottom,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Close button ─────────────────────────────────────────────────────────────

class _CloseButton extends StatelessWidget {
  final AppDimensions d;
  final VoidCallback onClose;
  const _CloseButton({required this.d, required this.onClose});

  @override
  Widget build(BuildContext context) {
    const double size = 36;
    return GestureDetector(
      onTap: onClose,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: AtlasColors.surfaceLight,
          borderRadius: BorderRadius.circular(d.borderRadiusS * 0.8),
          border: Border.all(color: AtlasColors.chipBorder),
        ),
        child: Icon(
          Icons.close,
          color: AtlasColors.textSecondary,
          size: d.iconS,
        ),
      ),
    );
  }
}

// ─── Coordinate row ───────────────────────────────────────────────────────────

class _CoordRow extends StatelessWidget {
  final String label;
  final String value;
  final AppDimensions d;
  const _CoordRow({required this.label, required this.value, required this.d});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          child: Text(
            value,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(color: AtlasColors.textPrimary, fontSize: d.fontS),
          ),
        ),
        SizedBox(width: d.paddingS),
        Text(
          label,
          style: TextStyle(color: AtlasColors.textSecondary, fontSize: d.fontS),
        ),
      ],
    );
  }
}
