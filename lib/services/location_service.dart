import 'package:flutter/material.dart';

class UserLocation {
  final String area;
  final String city;
  final String state;
  final String pinCode;

  UserLocation({
    required this.area,
    required this.city,
    required this.state,
    required this.pinCode,
  });

  String get shortAddress => '$area, $city';
  String get fullAddress => '$area, $city, $state - $pinCode';
}

class LocationPickerSheet extends StatefulWidget {
  final UserLocation currentLocation;
  final Function(UserLocation) onLocationSelected;

  const LocationPickerSheet({
    super.key,
    required this.currentLocation,
    required this.onLocationSelected,
  });

  @override
  State<LocationPickerSheet> createState() => _LocationPickerSheetState();
}

class _LocationPickerSheetState extends State<LocationPickerSheet> {
  bool isDetecting = false;
  late UserLocation activeLocation;

  final List<UserLocation> savedAddresses = [
    UserLocation(
      area: 'Lalpur, Main Road',
      city: 'Ranchi',
      state: 'Jharkhand',
      pinCode: '834001',
    ),
    UserLocation(
      area: 'Kanke Road',
      city: 'Ranchi',
      state: 'Jharkhand',
      pinCode: '834008',
    ),
    UserLocation(
      area: 'Doranda, Hinoo',
      city: 'Ranchi',
      state: 'Jharkhand',
      pinCode: '834002',
    ),
  ];

  @override
  void initState() {
    super.initState();
    activeLocation = widget.currentLocation;
  }

  void _requestLocationPermissionAndDetect() async {
    setState(() {
      isDetecting = true;
    });

    // Show simulated permission dialog
    final bool? permissionGranted = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: Row(
          children: const [
            Icon(Icons.my_location, color: Color(0xFFB32424), size: 26),
            SizedBox(width: 10),
            Text('Location Access'),
          ],
        ),
        content: const Text(
          'Allow "Super Value Market" to access your location to detect area, city, state & pin code automatically for fast delivery?',
          style: TextStyle(fontSize: 14, height: 1.4),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('DENY', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFB32424),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: const Text('ALLOW LOCATION'),
          ),
        ],
      ),
    );

    if (permissionGranted == true) {
      await Future.delayed(const Duration(milliseconds: 1200));

      final detected = UserLocation(
        area: 'Lalpur Circle, Main Road',
        city: 'Ranchi',
        state: 'Jharkhand',
        pinCode: '834001',
      );

      if (!mounted) return;

      setState(() {
        isDetecting = false;
        activeLocation = detected;
      });

      widget.onLocationSelected(detected);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Location detected: ${detected.fullAddress}'),
          backgroundColor: const Color(0xFFB32424),
        ),
      );

      Navigator.pop(context);
    } else {
      if (!mounted) return;
      setState(() {
        isDetecting = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(24),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Drag handle
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),

          const SizedBox(height: 18),

          const Text(
            'Select Delivery Location',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),

          const SizedBox(height: 16),

          // Detect Live Location Button
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton.icon(
              onPressed: isDetecting ? null : _requestLocationPermissionAndDetect,
              icon: isDetecting
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Icon(Icons.my_location, size: 20),
              label: Text(
                isDetecting ? 'Detecting Location...' : 'Use Current Live Location',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFB32424),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
            ),
          ),

          const SizedBox(height: 20),

          const Text(
            'Saved Delivery Addresses',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),

          const SizedBox(height: 10),

          Column(
            children: savedAddresses.map((loc) {
              final isSelected = activeLocation.pinCode == loc.pinCode &&
                  activeLocation.area == loc.area;

              return Container(
                margin: const EdgeInsets.only(bottom: 10),
                decoration: BoxDecoration(
                  color: isSelected ? const Color(0xFFFFF0F0) : const Color(0xFFF8F8F8),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: isSelected ? const Color(0xFFB32424) : Colors.transparent,
                    width: 1.5,
                  ),
                ),
                child: ListTile(
                  leading: const Icon(
                    Icons.location_on,
                    color: Color(0xFFB32424),
                  ),
                  title: Text(
                    loc.area,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  subtitle: Text(
                    '${loc.city}, ${loc.state} - ${loc.pinCode}',
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                  ),
                  trailing: isSelected
                      ? const Icon(
                          Icons.check_circle,
                          color: Color(0xFFB32424),
                        )
                      : null,
                  onTap: () {
                    widget.onLocationSelected(loc);
                    Navigator.pop(context);
                  },
                ),
              );
            }).toList(),
          ),

          const SizedBox(height: 10),
        ],
      ),
    );
  }
}
