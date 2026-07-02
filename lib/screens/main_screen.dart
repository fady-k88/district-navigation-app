import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:district_navigation_app/models/building.dart';
import 'package:district_navigation_app/widgets/atlas_map.dart';
import 'package:district_navigation_app/themes/atlas_colors.dart';
import 'package:district_navigation_app/widgets/map_controls.dart';
import 'package:district_navigation_app/widgets/atlas_footer.dart';
import 'package:district_navigation_app/widgets/atlas_app_bar.dart';
import 'package:district_navigation_app/providers/ad_provider.dart';
import 'package:district_navigation_app/themes/app_dimensions.dart';
import 'package:district_navigation_app/widgets/atlas_search_bar.dart';
import 'package:district_navigation_app/widgets/featured_buildings.dart';
import 'package:district_navigation_app/providers/settings_provider.dart';
import 'package:district_navigation_app/widgets/building_bottom_sheet.dart';
import 'package:district_navigation_app/providers/atlas_search_provider.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final MapController _mapController = MapController();
  final TextEditingController _searchController = TextEditingController();
  Building? _selectedBuilding;
  LatLng? _userLocation;
  bool _isLocating = false;

  static const LatLng _districtCenter = LatLng(29.9117, 30.9696);

  // ── Navigation ────────────────────────────────────────────────────────────

  void _onBuildingTapped(Building building) {
    setState(() => _selectedBuilding = building);
    _mapController.move(LatLng(building.latitude, building.longitude), 17);
    _showBuildingSheet(building);
  }

  void _onSearch() {
    final search = context.read<AtlasSearchProvider>();
    final query = _searchController.text.trim();
    if (query.isEmpty) return;

    final building = search.findBuilding(query);
    if (building != null) {
      _onBuildingTapped(building);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'لم يتم العثور على العمارة',
            textDirection: TextDirection.rtl,
          ),
          backgroundColor: AtlasColors.danger,
          duration: Duration(milliseconds: 1000),
        ),
      );
    }
  }

  Future<void> _startNavigation(Building building) async {
    final url = Uri.parse(
      'https://www.google.com/maps/dir/?api=1'
      '&destination=${building.latitude},${building.longitude}'
      '&travelmode=driving',
    );
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    }
  }

  void _showBuildingSheet(Building building) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => BuildingBottomSheet(
        building: building,
        onNavigate: () => _startNavigation(building),
        onClose: () {
          Navigator.pop(context);
          setState(() => _selectedBuilding = null);
        },
      ),
    ).whenComplete(() {
      // Sheet closed — reload ad for next building tap
      if (!mounted) return;
      context.read<AdProvider>().reloadSlot(AdSlot.buildingSheet);
    });
  }
  // ── Build ─────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final d = AppDimensions(context);

    return Consumer2<AtlasSearchProvider, SettingsProvider>(
      builder: (context, search, settings, _) {
        // Featured buildings are now pulled live from SettingsProvider
        final featuredBuildings = settings.featuredBuildings;

        return Scaffold(
          backgroundColor: AtlasColors.background,
          body: Stack(
            children: [
              // ── Full-screen map ───────────────────────────────────────────
              Positioned.fill(
                child: AtlasMap(
                  buildings: search.results,
                  selected: _selectedBuilding,
                  userLocation: _userLocation,
                  center: _districtCenter,
                  mapController: _mapController,
                  onTap: _onBuildingTapped,
                ),
              ),

              // ── Control panel (top) ───────────────────────────────────────
              SafeArea(
                bottom: false,
                child: Align(
                  alignment: Alignment.topCenter,
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 480),
                    child: Container(
                      margin: EdgeInsets.all(d.paddingM),
                      decoration: BoxDecoration(
                        color: AtlasColors.surface,
                        borderRadius: BorderRadius.circular(d.borderRadius),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.3),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          AtlasAppBar(onCompassTap: _onResetNorth),
                          SizedBox(height: d.paddingM),
                          AtlasSearchBar(
                            controller: _searchController,
                            onSearch: _onSearch,
                          ),
                          SizedBox(height: d.paddingS),
                          FeaturedBuildings(
                            buildings: featuredBuildings,
                            onTap: (number) {
                              _searchController.text = number;
                              _onSearch();
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              // ── Map control buttons (right edge) ──────────────────────────
              Positioned(
                right: d.paddingM,
                bottom: 48 + d.paddingM,
                child: MapControls(
                  onMyLocation: _onMyLocation,
                  onCenter: () async =>
                      _mapController.move(_districtCenter, 15),
                  onZoomIn: () async => _mapController.move(
                    _mapController.camera.center,
                    _mapController.camera.zoom + 1,
                  ),
                  onZoomOut: () async => _mapController.move(
                    _mapController.camera.center,
                    _mapController.camera.zoom - 1,
                  ),
                ),
              ),

              // ── Location loading overlay ──────────────────────────────────
              if (_isLocating)
                Positioned.fill(
                  child: ColoredBox(
                    color: Colors.black.withValues(alpha: 0.4),
                    child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CircularProgressIndicator(
                            color: settings.accentColor,
                          ),
                          SizedBox(height: d.paddingL),
                          Text(
                            'جارٍ تحديد موقعك...',
                            textDirection: TextDirection.rtl,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: d.fontM,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

              // ── Footer (bottom) ───────────────────────────────────────────
              const Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: AtlasFooter(),
              ),
            ],
          ),
        );
      },
    );
  }

  // ── Lifecycle ─────────────────────────────────────────────────────────────

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final searchProvider = context.read<AtlasSearchProvider>();
      searchProvider.selectDefaultProjectIfNone();
      if (searchProvider.selectedProject != null) setState(() {});
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // ── Location ──────────────────────────────────────────────────────────────

  Future<void> _onMyLocation() async {
    setState(() => _isLocating = true);

    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) return;
      }
      if (permission == LocationPermission.deniedForever) return;

      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
        ),
      );

      setState(() {
        _userLocation = LatLng(position.latitude, position.longitude);
      });
      _mapController.move(_userLocation!, 17);
    } finally {
      setState(() => _isLocating = false);
    }
  }

  void _onResetNorth() {
    _mapController.rotate(0);
  }
}
