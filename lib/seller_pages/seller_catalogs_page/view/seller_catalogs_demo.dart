import 'package:era_shop/utils/app_colors.dart';
import 'package:flutter/material.dart';

class SellerCatalogsDemo extends StatelessWidget {
  const SellerCatalogsDemo({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    // Demo data
    final demoCatalogItems = [
      DemoCatalogItem(
        id: "1",
        productName: "Tunic",
        description: "Tunic",
        price: 288,
        mainImage: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTusZwBSkd2g1qpLah143BQKjEFJEHencW0kQ&s",
        createStatus: "Approved",
      ),
      DemoCatalogItem(
        id: "2",
        productName: "Gown long",
        description: "School and college student favorite",
        price: 2560,
        mainImage: "https://cdn.shopify.com/s/files/1/0049/3649/9315/files/GNRM0043430_NAVY_BLUE_7_large.jpg?v=1742543644",
        createStatus: "Pending",
      ),
      DemoCatalogItem(
        id: "3",
        productName: "Pink Shirt",
        description: "Elegant summer collection",
        price: 1899,
        mainImage:
            "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTnuKMsDxWIWEzcwlFU7rlVbEGrFP9j7tsUlR1xQycd3u9TcfJ0j6hFjbyguqnk9OWW-ks&usqp=CAU",
        createStatus: "Approved",
      ),
      // DemoCatalogItem(
      //   id: "4",
      //   productName: "Denim Jacket",
      //   description: "Classic vintage style",
      //   price: 3499,
      //   mainImage: "https://images.unsplash.com/photo-1591047139829-d91aecb6caea?w=500&auto=format&fit=crop",
      //   createStatus: "Rejected",
      // ),
    ];

    return GridView.builder(
      padding: const EdgeInsets.only(top: 20, left: 15, right: 15),
      physics: const BouncingScrollPhysics(),
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      itemCount: demoCatalogItems.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        crossAxisCount: 2,
        childAspectRatio: 0.73,
      ),
      itemBuilder: (context, index) {
        final item = demoCatalogItems[index];

        return Container(
          decoration: BoxDecoration(
            color: AppColors.tabBackground,
            borderRadius: BorderRadius.circular(15),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                alignment: Alignment.topRight,
                children: [
                  Container(
                    height: 160,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.only(topLeft: Radius.circular(15), topRight: Radius.circular(15)),
                      image: DecorationImage(
                        image: NetworkImage(item.mainImage),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(6),
                        color: _getStatusColor(item.createStatus),
                      ),
                      child: Text(
                        item.createStatus,
                        style: TextStyle(
                          color: _getStatusTextColor(item.createStatus),
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              // Product details
              Padding(
                padding: const EdgeInsets.only(left: 10, right: 8, top: 8, bottom: 4),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.productName,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 14,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      item.description,
                      style: const TextStyle(
                        fontWeight: FontWeight.w500,
                        color: Colors.grey,
                        fontSize: 12,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "\$${item.price}",
                      style: TextStyle(
                        fontWeight: FontWeight.w900,
                        color: AppColors.primary, // Your primary color
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case "Approved":
        return Colors.green.withValues(alpha: 0.2);
      case "Pending":
        return Colors.orange.withValues(alpha: 0.2);
      case "Rejected":
        return Colors.red.withValues(alpha: 0.2);
      default:
        return Colors.grey.withValues(alpha: 0.2);
    }
  }

  Color _getStatusTextColor(String status) {
    switch (status) {
      case "Approved":
        return Colors.green;
      case "Pending":
        return Colors.orange;
      case "Rejected":
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}

class DemoCatalogItem {
  final String id;
  final String productName;
  final String description;
  final double price;
  final String mainImage;
  final String createStatus;

  DemoCatalogItem({
    required this.id,
    required this.productName,
    required this.description,
    required this.price,
    required this.mainImage,
    required this.createStatus,
  });
}
