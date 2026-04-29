// Shape B — per-option shipping price entry (v1.0.10).
//
// Mirrors the backend's `Product.deliveryOptions[]` array element
// (`waxxapp_admin/backend/server/product/product.model.js`). Used across
// every product-shaped Flutter model so the seller's Pricing page can
// hydrate the saved options on edit and the buyer's cart picker can show
// the offered prices side-by-side.
class DeliveryOption {
  String? type; // "local" | "nationwide" | "international"
  num? price;

  DeliveryOption({this.type, this.price});

  factory DeliveryOption.fromJson(Map<String, dynamic> json) => DeliveryOption(
        type: json["type"] as String?,
        price: json["price"] as num?,
      );

  Map<String, dynamic> toJson() => {
        "type": type,
        "price": price,
      };
}
