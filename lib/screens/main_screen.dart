import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:district_navigation_app/models/building.dart';
import 'package:district_navigation_app/widgets/atlas_map.dart';
import 'package:district_navigation_app/themes/atlas_colors.dart';
import 'package:district_navigation_app/widgets/map_controls.dart';
import 'package:district_navigation_app/widgets/atlas_footer.dart';
import 'package:district_navigation_app/widgets/atlas_app_bar.dart';
import 'package:district_navigation_app/widgets/atlas_search_bar.dart';
import 'package:district_navigation_app/widgets/featured_buildings.dart';
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

  static const LatLng _districtCenter = LatLng(29.9117, 30.9696);
  final List<String> _featuredBuildings = ['45', '104', '5'];

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
          content: Text('لم يتم العثور على العمارة'),
          backgroundColor: AtlasColors.danger,
        ),
      );
    }
  }

  Future<void> _startNavigation(Building building) async {
    final url = Uri.parse(
      'https://www.google.com/maps/dir/?api=1&destination=${building.latitude},${building.longitude}&travelmode=driving',
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
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AtlasSearchProvider>(
      builder: (context, search, _) {
        return Scaffold(
          backgroundColor: AtlasColors.background,
          body: Stack(
            children: [
              // Map
              Positioned.fill(
                child: AtlasMap(
                  buildings: search.results,
                  selected: _selectedBuilding,
                  center: _districtCenter,
                  mapController: _mapController,
                  onTap: _onBuildingTapped,
                ),
              ),

              // Control panel
              SafeArea(
                child: Column(
                  children: [
                    Container(
                      margin: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AtlasColors.surface,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.3),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          const AtlasAppBar(),
                          const SizedBox(height: 12),
                          AtlasSearchBar(
                            controller: _searchController,
                            onSearch: _onSearch,
                          ),
                          const SizedBox(height: 10),
                          FeaturedBuildings(
                            buildings: _featuredBuildings,
                            onTap: (number) {
                              _searchController.text = number;
                              _onSearch();
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Map controls
              Positioned(
                right: 12,
                bottom: 60,
                child: MapControls(
                  onMyLocation: () {},
                  onCenter: () => _mapController.move(_districtCenter, 15),
                  onZoomIn: () => _mapController.move(
                    _mapController.camera.center,
                    _mapController.camera.zoom + 1,
                  ),
                  onZoomOut: () => _mapController.move(
                    _mapController.camera.center,
                    _mapController.camera.zoom - 1,
                  ),
                ),
              ),

              // Footer
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

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    // Schedule a callback after the frame builds to safely update the provider state
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final searchProvider = context.read<AtlasSearchProvider>();
      searchProvider.selectDefaultProjectIfNone();

      // Optional: If you want to populate your featured buildings or map
      // immediately based on that default project, you can trigger it here:
      if (searchProvider.selectedProject != null) {
        setState(() {
          // e.g., update map position or local screen states if necessary
        });
      }
    });
  }
}
