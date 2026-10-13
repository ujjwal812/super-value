import 'package:flutter/material.dart';
import 'package:learning_project/routes/app_routes.dart';
import 'package:learning_project/services/cart_service.dart';

class AddressModel {
  final String id;
  final String name;
  final String phone;
  final String houseNo;
  final String area;
  final String city;
  final String state;
  final String pinCode;
  final String type; // Home, Work, Other
  final bool isDefault;

  AddressModel({
    required this.id,
    required this.name,
    required this.phone,
    required this.houseNo,
    required this.area,
    required this.city,
    required this.state,
    required this.pinCode,
    required this.type,
    this.isDefault = false,
  });

  String get fullAddress => '$houseNo, $area, $city, $state - $pinCode';

  AddressModel copyWith({
    String? id,
    String? name,
    String? phone,
    String? houseNo,
    String? area,
    String? city,
    String? state,
    String? pinCode,
    String? type,
    bool? isDefault,
  }) {
    return AddressModel(
      id: id ?? this.id,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      houseNo: houseNo ?? this.houseNo,
      area: area ?? this.area,
      city: city ?? this.city,
      state: state ?? this.state,
      pinCode: pinCode ?? this.pinCode,
      type: type ?? this.type,
      isDefault: isDefault ?? this.isDefault,
    );
  }
}

class DeliveryAddressScreen extends StatefulWidget {
  final Map<String, dynamic>? checkoutData;

  const DeliveryAddressScreen({
    super.key,
    this.checkoutData,
  });

  @override
  State<DeliveryAddressScreen> createState() => _DeliveryAddressScreenState();
}

class _DeliveryAddressScreenState extends State<DeliveryAddressScreen> {
  static const Color primaryColor = Color(0xFFB32424);
  static const Color backgroundColor = Color(0xFFF8F9FC);

  final List<AddressModel> _addresses = [
    AddressModel(
      id: 'addr_1',
      name: 'Ujjwal Kumar',
      phone: '+91 98765 43210',
      houseNo: 'House No. 12, Main Road',
      area: 'Lalpur Circle',
      city: 'Ranchi',
      state: 'Jharkhand',
      pinCode: '834001',
      type: 'Home',
      isDefault: true,
    ),
    AddressModel(
      id: 'addr_2',
      name: 'Ujjwal Kumar',
      phone: '+91 98765 43210',
      houseNo: 'Plot 45, Tech Park',
      area: 'Kanke Road',
      city: 'Ranchi',
      state: 'Jharkhand',
      pinCode: '834008',
      type: 'Work',
      isDefault: false,
    ),
  ];

  late String _selectedAddressId;

  @override
  void initState() {
    super.initState();
    _selectedAddressId = _addresses.firstWhere(
      (a) => a.isDefault,
      orElse: () => _addresses.first,
    ).id;
  }

  AddressModel get _selectedAddress =>
      _addresses.firstWhere((a) => a.id == _selectedAddressId, orElse: () => _addresses.first);

  void _setDefaultAddress(String id) {
    setState(() {
      for (int i = 0; i < _addresses.length; i++) {
        final isMatch = _addresses[i].id == id;
        _addresses[i] = _addresses[i].copyWith(isDefault: isMatch);
      }
      _selectedAddressId = id;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Default delivery address updated'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _deleteAddress(String id) {
    if (_addresses.length <= 1) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('At least one delivery address is required'),
        ),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Delete Address'),
        content: const Text('Are you sure you want to delete this address?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                _addresses.removeWhere((a) => a.id == id);
                if (_selectedAddressId == id) {
                  _selectedAddressId = _addresses.first.id;
                }
              });
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Address deleted successfully')),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryColor,
              foregroundColor: Colors.white,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _showAddEditAddressBottomSheet({AddressModel? addressToEdit}) {
    final isEditing = addressToEdit != null;

    final nameCtrl = TextEditingController(text: addressToEdit?.name ?? 'Ujjwal Kumar');
    final phoneCtrl = TextEditingController(text: addressToEdit?.phone ?? '+91 98765 43210');
    final houseCtrl = TextEditingController(text: addressToEdit?.houseNo ?? '');
    final areaCtrl = TextEditingController(text: addressToEdit?.area ?? '');
    final cityCtrl = TextEditingController(text: addressToEdit?.city ?? 'Ranchi');
    final stateCtrl = TextEditingController(text: addressToEdit?.state ?? 'Jharkhand');
    final pinCtrl = TextEditingController(text: addressToEdit?.pinCode ?? '834001');

    String selectedType = addressToEdit?.type ?? 'Home';
    bool makeDefault = addressToEdit?.isDefault ?? (_addresses.isEmpty);

    final formKey = GlobalKey<FormState>();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Container(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom + 20,
                top: 20,
                left: 20,
                right: 20,
              ),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
              ),
              child: SingleChildScrollView(
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Container(
                          width: 40,
                          height: 4.5,
                          margin: const EdgeInsets.only(bottom: 16),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade300,
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            isEditing ? 'Edit Delivery Address' : 'Add New Address',
                            style: const TextStyle(
                              fontSize: 19,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF172033),
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.close_rounded),
                            onPressed: () => Navigator.pop(context),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Address Type Chips
                      const Text(
                        'Save Address As',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: ['Home', 'Work', 'Other'].map((type) {
                          final isSel = selectedType == type;
                          IconData typeIcon = Icons.home_outlined;
                          if (type == 'Work') typeIcon = Icons.work_outline;
                          if (type == 'Other') typeIcon = Icons.location_on_outlined;

                          return GestureDetector(
                            onTap: () {
                              setModalState(() {
                                selectedType = type;
                              });
                            },
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              margin: const EdgeInsets.only(right: 10),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 14, vertical: 8),
                              decoration: BoxDecoration(
                                color: isSel ? const Color(0xFFFFF0F0) : const Color(0xFFF6F7F9),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: isSel ? primaryColor : const Color(0xFFE2E4E8),
                                  width: isSel ? 1.5 : 1,
                                ),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    typeIcon,
                                    size: 16,
                                    color: isSel ? primaryColor : Colors.grey,
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    type,
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: isSel ? FontWeight.bold : FontWeight.w500,
                                      color: isSel ? primaryColor : Colors.black87,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }).toList(),
                      ),

                      const SizedBox(height: 18),

                      _buildTextField(
                        controller: nameCtrl,
                        label: 'Full Name',
                        hint: 'e.g. Ujjwal Kumar',
                        icon: Icons.person_outline,
                        validator: (v) => v == null || v.trim().isEmpty ? 'Enter name' : null,
                      ),
                      const SizedBox(height: 12),

                      _buildTextField(
                        controller: phoneCtrl,
                        label: 'Mobile Number',
                        hint: 'e.g. +91 98765 43210',
                        icon: Icons.phone_outlined,
                        keyboardType: TextInputType.phone,
                        validator: (v) => v == null || v.trim().isEmpty ? 'Enter mobile' : null,
                      ),
                      const SizedBox(height: 12),

                      _buildTextField(
                        controller: houseCtrl,
                        label: 'Flat / House No. / Building',
                        hint: 'e.g. House No. 12, Tower A',
                        icon: Icons.apartment_outlined,
                        validator: (v) => v == null || v.trim().isEmpty ? 'Enter house details' : null,
                      ),
                      const SizedBox(height: 12),

                      _buildTextField(
                        controller: areaCtrl,
                        label: 'Street / Locality / Area',
                        hint: 'e.g. Lalpur Main Road, Near Plaza',
                        icon: Icons.location_on_outlined,
                        validator: (v) => v == null || v.trim().isEmpty ? 'Enter area' : null,
                      ),
                      const SizedBox(height: 12),

                      Row(
                        children: [
                          Expanded(
                            child: _buildTextField(
                              controller: cityCtrl,
                              label: 'City',
                              hint: 'Ranchi',
                              icon: Icons.location_city_outlined,
                              validator: (v) => v == null || v.trim().isEmpty ? 'Enter city' : null,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: _buildTextField(
                              controller: pinCtrl,
                              label: 'Pin Code',
                              hint: '834001',
                              icon: Icons.pin_drop_outlined,
                              keyboardType: TextInputType.number,
                              validator: (v) => v == null || v.trim().isEmpty ? 'Enter pincode' : null,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),

                      _buildTextField(
                        controller: stateCtrl,
                        label: 'State',
                        hint: 'Jharkhand',
                        icon: Icons.map_outlined,
                        validator: (v) => v == null || v.trim().isEmpty ? 'Enter state' : null,
                      ),

                      const SizedBox(height: 14),

                      // Set as Default Switch
                      SwitchListTile(
                        value: makeDefault,
                        contentPadding: EdgeInsets.zero,
                        activeTrackColor: primaryColor,
                        title: const Text(
                          'Set as Default Address',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        onChanged: (val) {
                          setModalState(() {
                            makeDefault = val;
                          });
                        },
                      ),

                      const SizedBox(height: 20),

                      // Save Button
                      SizedBox(
                        width: double.infinity,
                        height: 52,
                        child: ElevatedButton(
                          onPressed: () {
                            if (formKey.currentState?.validate() ?? false) {
                              final newAddress = AddressModel(
                                id: isEditing ? addressToEdit.id : 'addr_${DateTime.now().millisecondsSinceEpoch}',
                                name: nameCtrl.text.trim(),
                                phone: phoneCtrl.text.trim(),
                                houseNo: houseCtrl.text.trim(),
                                area: areaCtrl.text.trim(),
                                city: cityCtrl.text.trim(),
                                state: stateCtrl.text.trim(),
                                pinCode: pinCtrl.text.trim(),
                                type: selectedType,
                                isDefault: makeDefault,
                              );

                              setState(() {
                                if (isEditing) {
                                  final idx = _addresses.indexWhere((a) => a.id == addressToEdit.id);
                                  if (idx != -1) _addresses[idx] = newAddress;
                                } else {
                                  _addresses.add(newAddress);
                                }

                                if (makeDefault) {
                                  for (int i = 0; i < _addresses.length; i++) {
                                    final isMatch = _addresses[i].id == newAddress.id;
                                    _addresses[i] = _addresses[i].copyWith(isDefault: isMatch);
                                  }
                                }

                                _selectedAddressId = newAddress.id;
                              });

                              Navigator.pop(context);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(isEditing
                                      ? 'Address updated successfully'
                                      : 'New address saved!'),
                                  backgroundColor: primaryColor,
                                ),
                              );
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primaryColor,
                            foregroundColor: Colors.white,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                          child: Text(
                            isEditing ? 'UPDATE ADDRESS' : 'SAVE ADDRESS',
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.8,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 12.5,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 5),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          validator: validator,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(fontSize: 13, color: Colors.grey.shade400),
            prefixIcon: Icon(icon, size: 20, color: primaryColor),
            filled: true,
            fillColor: const Color(0xFFF8F9FC),
            contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: primaryColor, width: 1.5),
            ),
          ),
        ),
      ],
    );
  }

  void _proceedToPayment() {
    final Map<String, dynamic> checkoutBundle = Map<String, dynamic>.from(widget.checkoutData ?? {});

    final subtotal = (checkoutBundle['subtotal'] as num?)?.toDouble() ?? CartService.instance.subtotal;
    final discountAmount = (checkoutBundle['discountAmount'] as num?)?.toDouble() ?? 0.0;
    final deliveryFee = (checkoutBundle['deliveryFee'] as num?)?.toDouble() ?? (subtotal > 200 ? 0.0 : 30.0);
    final total = (checkoutBundle['total'] as num?)?.toDouble() ?? (subtotal - discountAmount + deliveryFee);

    final finalBundle = {
      'subtotal': subtotal,
      'discountAmount': discountAmount,
      'deliveryFee': deliveryFee,
      'totalAmount': total,
      'deliveryAddress': _selectedAddress.fullAddress,
      'recipientName': _selectedAddress.name,
      'recipientPhone': _selectedAddress.phone,
      'addressType': _selectedAddress.type,
      'items': checkoutBundle['items'] ?? CartService.instance.items,
    };

    Navigator.pushNamed(
      context,
      AppRoutes.paymentMethod,
      arguments: finalBundle,
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isCheckoutFlow = widget.checkoutData != null ||
        (ModalRoute.of(context)?.settings.arguments != null);

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: Color(0xFF172033)),
          onPressed: () => Navigator.maybePop(context),
        ),
        title: Text(
          isCheckoutFlow ? 'Select Delivery Address' : 'Saved Addresses',
          style: const TextStyle(
            color: Color(0xFF172033),
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 120),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Banner Alert
            if (isCheckoutFlow)
              Container(
                margin: const EdgeInsets.only(bottom: 16),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF0F0),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: primaryColor.withValues(alpha: 0.2)),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.verified_user_outlined,
                        color: primaryColor,
                        size: 22,
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Step 2 of 3: Address Verification',
                            style: TextStyle(
                              fontSize: 13.5,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF172033),
                            ),
                          ),
                          SizedBox(height: 2),
                          Text(
                            'Verify or select your address to proceed to payment',
                            style: TextStyle(
                              fontSize: 11.5,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

            // Add New Address Button
            InkWell(
              onTap: () => _showAddEditAddressBottomSheet(),
              borderRadius: BorderRadius.circular(16),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: primaryColor, width: 1.2),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.add_circle_outline_rounded, color: primaryColor, size: 22),
                    SizedBox(width: 8),
                    Text(
                      'ADD NEW ADDRESS',
                      style: TextStyle(
                        color: primaryColor,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            const Text(
              'Your Saved Addresses',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: Color(0xFF172033),
              ),
            ),

            const SizedBox(height: 12),

            // Address Cards
            Column(
              children: _addresses.map((address) {
                final isSelected = address.id == _selectedAddressId;

                IconData typeIcon = Icons.home_rounded;
                if (address.type == 'Work') typeIcon = Icons.work_rounded;
                if (address.type == 'Other') typeIcon = Icons.location_on_rounded;

                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedAddressId = address.id;
                    });
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 220),
                    margin: const EdgeInsets.only(bottom: 14),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: isSelected ? primaryColor : const Color(0xFFEFEFEF),
                        width: isSelected ? 2.0 : 1.0,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: isSelected
                              ? primaryColor.withValues(alpha: 0.08)
                              : Colors.black.withValues(alpha: 0.03),
                          blurRadius: 10,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: isSelected
                                        ? const Color(0xFFFFF0F0)
                                        : const Color(0xFFF6F7F9),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Icon(
                                    typeIcon,
                                    color: primaryColor,
                                    size: 18,
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Text(
                                  address.type.toUpperCase(),
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF172033),
                                    letterSpacing: 0.8,
                                  ),
                                ),
                                if (address.isDefault) ...[
                                  const SizedBox(width: 8),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8, vertical: 3),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFEAF7EF),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: const Text(
                                      'DEFAULT',
                                      style: TextStyle(
                                        color: Color(0xFF2E7D32),
                                        fontSize: 9.5,
                                        fontWeight: FontWeight.w900,
                                      ),
                                    ),
                                  ),
                                ],
                              ],
                            ),

                            // Selection Indicator
                            Icon(
                              isSelected
                                  ? Icons.radio_button_checked_rounded
                                  : Icons.radio_button_unchecked_rounded,
                              color: isSelected ? primaryColor : Colors.grey.shade400,
                              size: 22,
                            ),
                          ],
                        ),

                        const SizedBox(height: 12),

                        Text(
                          '${address.name} • ${address.phone}',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF172033),
                          ),
                        ),

                        const SizedBox(height: 4),

                        Text(
                          address.fullAddress,
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey.shade700,
                            height: 1.35,
                          ),
                        ),

                        const Divider(height: 24, color: Color(0xFFEEEEEE)),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            if (!address.isDefault)
                              GestureDetector(
                                onTap: () => _setDefaultAddress(address.id),
                                child: const Text(
                                  'Set as Default',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF2E7D32),
                                  ),
                                ),
                              )
                            else
                              const SizedBox.shrink(),

                            Row(
                              children: [
                                TextButton.icon(
                                  onPressed: () => _showAddEditAddressBottomSheet(
                                      addressToEdit: address),
                                  icon: const Icon(Icons.edit_outlined,
                                      size: 16, color: Colors.grey),
                                  label: const Text(
                                    'Edit',
                                    style: TextStyle(
                                        fontSize: 12, color: Colors.grey),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                TextButton.icon(
                                  onPressed: () => _deleteAddress(address.id),
                                  icon: const Icon(Icons.delete_outline_rounded,
                                      size: 16, color: primaryColor),
                                  label: const Text(
                                    'Delete',
                                    style: TextStyle(
                                        fontSize: 12, color: primaryColor),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),

      // Bottom Action Bar for Verification / Payment Navigation
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 12,
              offset: const Offset(0, -3),
            ),
          ],
        ),
        child: SafeArea(
          top: false,
          child: Row(
            children: [
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'DELIVERING TO',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                        letterSpacing: 0.8,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${_selectedAddress.type} (${_selectedAddress.pinCode})',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF172033),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 14),
              SizedBox(
                height: 52,
                child: ElevatedButton(
                  onPressed: _proceedToPayment,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: Row(
                    children: [
                      Text(
                        isCheckoutFlow ? 'PROCEED TO PAY' : 'DELIVER HERE',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Icon(Icons.arrow_forward_rounded, size: 18),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
