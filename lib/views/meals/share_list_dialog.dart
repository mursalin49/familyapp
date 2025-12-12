import 'package:flutter/material.dart';
import '../../utils/app_colors.dart';
import '../widgets/custom_dropdown.dart';
import '../../models/grocery_model.dart';
import '../../viewmodels/grocery_view_model.dart';

class ShareListDialog extends StatefulWidget {
  // ✅ Changed to accept GroceryItemModel
  final List<GroceryItemModel> itemsToShare;
  final GroceryViewModel groceryViewModel; // ✅ Added parameter

  // Family members list
  static const List<Map<String, String>> familyMembers = [
    {'id': 'emily_w', 'name': 'Emily Walton', 'role': 'parent'},
    {'id': 'ti_w', 'name': 'Ti Walton', 'role': 'parent'},
    {'id': 'adri_s', 'name': 'Adri Walton', 'role': 'sibling'},
    {'id': 'evie_c', 'name': 'Evie Walton', 'role': 'child'},
  ];

  const ShareListDialog({
    super.key,
    required this.itemsToShare,
    required this.groceryViewModel, // ✅ Required parameter
  });

  @override
  State<ShareListDialog> createState() => _ShareListDialogState();
}

class _ShareListDialogState extends State<ShareListDialog> {
  String? selectedMember;
  bool isSharing = false;

  @override
  Widget build(BuildContext context) {
    final bool canShare =
        selectedMember != null && widget.itemsToShare.isNotEmpty && !isSharing;

    return AlertDialog(
      backgroundColor: Colors.white,
      titlePadding: const EdgeInsets.only(top: 24, left: 24, right: 10),
      contentPadding: const EdgeInsets.fromLTRB(24.0, 10.0, 24.0, 0.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),

      // Title
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Share Grocery List',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: AppColors.textDark,
            ),
          ),
          IconButton(
            icon: const Icon(Icons.close, color: AppColors.textDark),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),

      // Content
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Send To Label
            const Text(
              'Send to:',
              style: TextStyle(
                color: AppColors.textDark,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),

            // Family Members Dropdown
            CustomDropdown<String>(
              items: ShareListDialog.familyMembers.map((member) {
                return DropdownItem(
                  value: member['id']!,
                  label: '${member['name']} (${member['role']})',
                );
              }).toList(),
              value: selectedMember,
              onChanged: (String? value) {
                setState(() {
                  selectedMember = value;
                });
              },
              hintText: 'Choose family member',
            ),
            const SizedBox(height: 24),

            // Items to Share Label
            Text(
              'Items to share (${widget.itemsToShare.length} items)',
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                color: AppColors.textDark,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 12),

            // Items Container
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppColors.grey.withOpacity(0.5)),
              ),
              padding: const EdgeInsets.all(12),
              constraints: const BoxConstraints(maxHeight: 250),
              child: widget.itemsToShare.isEmpty
                  ? const Center(
                      child: Text(
                        "No items to share",
                        style: TextStyle(color: AppColors.grey),
                      ),
                    )
                  : ListView.builder(
                      shrinkWrap: true,
                      itemCount: widget.itemsToShare.length,
                      itemBuilder: (context, index) {
                        final item = widget.itemsToShare[index];
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 6.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              // Item Name
                              Expanded(
                                child: Text(
                                  item.name,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: AppColors.textDark,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              const SizedBox(width: 8),

                              // Quantity Badge
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.primary.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  '${item.quantity}',
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.primary,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),

      // Action Buttons
      actionsPadding: const EdgeInsets.only(bottom: 24, left: 24, right: 24),
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Cancel Button
            Expanded(
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: AppColors.textDark,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                    side: const BorderSide(color: AppColors.grey, width: 0.5),
                  ),
                  elevation: 0,
                ),
                onPressed: () => Navigator.pop(context),
                child: const Text(
                  'Cancel',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
            ),
            const SizedBox(width: 16),

            // Share Button
            Expanded(
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: canShare
                      ? AppColors.primary
                      : AppColors.primary.withOpacity(0.5),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  elevation: 0,
                ),
                onPressed: canShare
                    ? () async {
                        setState(() {
                          isSharing = true;
                        });

                        // Call share method from ViewModel
                        final success = await widget.groceryViewModel
                            .shareGroceryList(selectedMember!);

                        if (mounted) {
                          if (success) {
                            Navigator.pop(context);
                          } else {
                            setState(() {
                              isSharing = false;
                            });
                          }
                        }
                      }
                    : null,
                icon: isSharing
                    ? SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Colors.white.withOpacity(0.7),
                          ),
                        ),
                      )
                    : const Icon(Icons.send, size: 20),
                label: Text(
                  isSharing ? 'Sharing...' : 'Share List',
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
