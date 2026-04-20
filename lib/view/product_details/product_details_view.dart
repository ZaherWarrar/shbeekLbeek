import 'package:app/controller/product_details/product_details_controller.dart';
import 'package:app/controller/cart/cart_controller.dart';
import 'package:app/core/class/statusrequest.dart';
import 'package:app/core/constant/app_color.dart';
import 'package:app/core/constant/app_images.dart';
import 'package:app/core/shared/custom_refresh.dart';
import 'package:app/core/constant/routes/app_routes.dart';
import 'package:app/data/datasorce/model/item_model.dart';
import 'package:app/data/datasorce/model/store_model.dart';
import 'package:app/view/shopDetails/widgets/cart_floating_button.dart';
import 'package:app/view/favorets/widget/favorates_tabs/favorate_tabs_controller.dart';
import 'package:app/view/favorets/widget/favorates_tabs/favorates_tabs_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProductDetailsView extends StatelessWidget {
  const ProductDetailsView({super.key});

  String _formatPrice(int price) => '$price ل.س';

  @override
  Widget build(BuildContext context) {
    final arg = Get.arguments;
    int? productId;
    int? argStoreId;
    String? argStoreName;
    String? argStoreImageUrl;
    String? argStoreDeliveryFee;

    if (arg is int) {
      productId = arg;
    } else if (arg is Map) {
      final map = Map<String, dynamic>.from(arg);
      final pid = map['productId'] ?? map['id'];
      productId = pid is int ? pid : int.tryParse(pid?.toString() ?? '');

      final sid = map['storeId'] ?? map['store_id'];
      argStoreId = sid is int ? sid : int.tryParse(sid?.toString() ?? '');
      argStoreName = map['storeName']?.toString();
      argStoreImageUrl = map['storeImageUrl']?.toString();
      argStoreDeliveryFee = map['storeDeliveryFee']?.toString();
    } else {
      productId = int.tryParse(arg?.toString() ?? '');
    }
    if (productId == null || productId <= 0) {
      return Scaffold(
        backgroundColor: AppColor().backgroundColor,
        body: Center(
          child: Text(
            'معرّف المنتج غير صحيح',
            style: TextStyle(color: AppColor().titleColor),
          ),
        ),
      );
    }
    final int pid = productId;

    return GetBuilder<ProductDetailsController>(
      init: ProductDetailsController(productId: pid),
      builder: (controller) {
        final product = controller.product;
        final effectiveStoreId = product?.storeId ?? argStoreId;
        final effectiveStoreName = product?.storeName ?? argStoreName;
        final effectiveStoreImage = product?.storeImageUrl ?? argStoreImageUrl;
        final effectiveStoreDeliveryFee =
            product?.storeDeliveryFee ?? argStoreDeliveryFee;
        return SafeArea(
          child: Scaffold(
            backgroundColor: AppColor().backgroundColor,
            floatingActionButton: const CartFloatingButton(),
            appBar: AppBar(
              backgroundColor: AppColor().backgroundColor,
              surfaceTintColor: AppColor().backgroundColor,
              elevation: 0,
              centerTitle: true,
              foregroundColor: AppColor().titleColor,
              title: Text(
                'تفاصيل المنتج',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  color: AppColor().primaryColor,
                ),
              ),
            ),
            body: CustomRefresh(
              statusRequest: controller.statusRequest,
              preferBodyWhenLoading: true,
              fun: () => controller.fetchAll(),
              body: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 8),
                      // صورة المنتج
                      ClipRRect(
                        borderRadius: BorderRadius.circular(28),
                        child: Container(
                          height: 330,
                          width: double.infinity,
                          color: Colors.black12,
                          child: Image.network(
                            product?.imageUrl ?? '',
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Image.asset(
                                Assets.imagesLogo,
                                fit: BoxFit.cover,
                              );
                            },
                          ),
                        ),
                      ),
                      const SizedBox(height: 14),
                      // السعر + الاسم
                      Row(
                        children: [
                          Text(
                            _formatPrice(product?.priceInt ?? 0),
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: AppColor().primaryColor,
                            ),
                          ),
                          const Spacer(),
                          Expanded(
                            flex: 3,
                            child: Text(
                              product?.name ?? 'منتج',
                              textAlign: TextAlign.end,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                                color: AppColor().titleColor,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),

                      // شارة تقييم + وقت توصيل (ثابت مثل التصميم)
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(18),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.04),
                                  blurRadius: 10,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Row(
                              children: [
                                Text(
                                  (product?.rating ?? 0).toStringAsFixed(1),
                                  style: TextStyle(
                                    color: AppColor().titleColor,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                const SizedBox(width: 4),
                                Icon(
                                  Icons.star,
                                  size: 16,
                                  color: AppColor().primaryColor,
                                ),
                              ],
                            ),
                          ),
                          const Spacer(),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(22),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  height: 28,
                                  width: 28,
                                  decoration: BoxDecoration(
                                    color: AppColor().primaryColor.withValues(
                                      alpha: 0.15,
                                    ),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    Icons.motorcycle_rounded,
                                    size: 16,
                                    color: AppColor().primaryColor,
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Text(
                                  'وقت توصيل مقدّر',
                                  style: TextStyle(
                                    color: AppColor().descriptionColor,
                                    fontSize: 12,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  '15-25 دقيقة',
                                  style: TextStyle(
                                    color: AppColor().titleColor,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 18),
                      // الوصف
                      Text(
                        'الوصف',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          color: AppColor().titleColor,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        product?.description ?? '',
                        style: TextStyle(
                          fontSize: 13,
                          height: 1.6,
                          color: AppColor().descriptionColor,
                        ),
                      ),
                      const SizedBox(height: 18),

                      // منتجات مقترحة
                      Row(
                        children: [
                          Text(
                            'منتجات مقترحة',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                              color: AppColor().titleColor,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      if (controller.statusRequest == StatusRequest.success &&
                          controller.recommended.isEmpty)
                        Text(
                          'لا يوجد اقتراحات حالياً',
                          style: TextStyle(color: AppColor().descriptionColor),
                        )
                      else
                        SizedBox(
                          height: 230,
                          child: ListView.separated(
                            scrollDirection: Axis.horizontal,
                            itemCount: controller.recommended.length,
                            separatorBuilder: (_, i) =>
                                const SizedBox(width: 12),
                            itemBuilder: (context, index) {
                              final rec = controller.recommended[index];
                              return _RecommendedCard(
                                name: rec.name ?? 'منتج',
                                price: _formatPrice(rec.priceInt),
                                imageUrl: rec.imageUrl ?? '',
                                onTap: () {
                                  final recId = rec.id;
                                  if (recId != null && recId > 0) {
                                    Get.toNamed(
                                      AppRoutes.productDetails,
                                      arguments: {
                                        'productId': recId,
                                        'storeId': rec.storeId ?? effectiveStoreId,
                                        'storeName': rec.storeName ?? effectiveStoreName,
                                        'storeImageUrl':
                                            rec.storeImageUrl ?? effectiveStoreImage,
                                        'storeDeliveryFee': rec.storeDeliveryFee ??
                                            effectiveStoreDeliveryFee,
                                      },
                                    );
                                  }
                                },
                              );
                            },
                          ),
                        ),

                      const SizedBox(height: 90),
                    ],
                  ),
                ),
              ),
            ),
            bottomNavigationBar: GetBuilder<CartController>(
              builder: (cart) {
                final id = product?.id ?? pid;
                final safeId = id;
                final qty = cart.getQuantity(safeId);
                return GetBuilder<FavoritesController>(
                  builder: (fav) {
                    final isFav = fav.isFavorite('product', safeId);
                    return _BottomBar(
                      quantity: qty,
                      isFavorite: isFav,
                      onToggleFavorite: () {
                        final favItem = RestaurantModel(
                          id: safeId,
                          name: product?.name ?? '',
                          image: product?.imageUrl ?? '',
                          rating: product?.rating ?? 0,
                          category: (product?.priceInt ?? 0).toString(),
                          favoriteType: 'product',
                          isFavorite: isFav,
                        );
                        fav.toggleFavoriteById(
                          type: 'product',
                          id: safeId,
                          item: favItem,
                        );
                      },
                      onAdd: () {
                        if (product == null) return;
                        final storeId = effectiveStoreId;
                        if (storeId == null || storeId <= 0) {
                          Get.snackbar(
                            'خطأ',
                            'لا يمكن إضافة المنتج بدون معرّف المتجر',
                          );
                          return;
                        }
                        final shop = StoreModel(
                          id: storeId,
                          name: effectiveStoreName ?? 'متجر',
                          imageUrl: effectiveStoreImage,
                          deliveryFee: effectiveStoreDeliveryFee,
                        );
                        final p = Products(
                          id: product.id,
                          name: product.name,
                          imageUrl: product.imageUrl,
                          regularPrice: product.priceInt,
                        );
                        cart.addItem(p, shop, quantity: 1);
                      },
                      onIncrease: () {
                        cart.increaseQuantity(safeId);
                      },
                      onDecrease: () {
                        cart.decreaseQuantity(safeId);
                      },
                    );
                  },
                );
              },
            ),
          ),
        );
      },
    );
  }
}

class _BottomBar extends StatelessWidget {
  const _BottomBar({
    required this.onAdd,
    required this.onIncrease,
    required this.onDecrease,
    required this.quantity,
    required this.isFavorite,
    required this.onToggleFavorite,
  });
  final VoidCallback onAdd;
  final VoidCallback onIncrease;
  final VoidCallback onDecrease;
  final int quantity;
  final bool isFavorite;
  final VoidCallback onToggleFavorite;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 10, 16, 14),
        child: Row(
          children: [
            Container(
              height: 52,
              width: 52,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 12,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: IconButton(
                onPressed: onToggleFavorite,
                icon: Icon(
                  isFavorite ? Icons.favorite : Icons.favorite_border,
                  color: isFavorite
                      ? AppColor().primaryColor
                      : AppColor().titleColor,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: SizedBox(
                height: 52,
                child: quantity <= 0
                    ? ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColor().primaryColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(28),
                          ),
                        ),
                        onPressed: onAdd,
                        icon: const Icon(
                          Icons.shopping_cart,
                          color: Colors.white,
                        ),
                        label: const Text(
                          'أضف إلى السلة',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                      )
                    : Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(28),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.05),
                              blurRadius: 12,
                              offset: const Offset(0, 6),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            IconButton(
                              onPressed: onDecrease,
                              icon: Icon(
                                Icons.remove,
                                color: AppColor().primaryColor,
                              ),
                            ),
                            Text(
                              '$quantity',
                              style: TextStyle(
                                color: AppColor().titleColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            IconButton(
                              onPressed: onIncrease,
                              icon: Icon(
                                Icons.add,
                                color: AppColor().primaryColor,
                              ),
                            ),
                          ],
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RecommendedCard extends StatelessWidget {
  const _RecommendedCard({
    required this.name,
    required this.price,
    required this.imageUrl,
    required this.onTap,
  });

  final String name;
  final String price;
  final String imageUrl;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          width: 170,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 10,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Container(
                    height: 120,
                    width: double.infinity,
                    color: Colors.black12,
                    child: (imageUrl.isEmpty)
                        ? Image.asset(Assets.imagesLogo, fit: BoxFit.cover)
                        : Image.network(
                            imageUrl,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Image.asset(
                                Assets.imagesLogo,
                                fit: BoxFit.cover,
                              );
                            },
                          ),
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: AppColor().titleColor,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  price,
                  style: TextStyle(
                    color: AppColor().primaryColor,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const Spacer(),
                Align(
                  alignment: Alignment.centerLeft,
                  child: GestureDetector(
                    onTap: onTap,
                    child: Container(
                      height: 32,
                      width: 32,
                      decoration: BoxDecoration(
                        color: AppColor().primaryColor.withValues(alpha: 0.15),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.add,
                        color: AppColor().primaryColor,
                        size: 18,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
