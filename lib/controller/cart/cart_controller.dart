import 'package:app/core/services/shaerd_preferances.dart';
import 'package:app/data/datasorce/model/item_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CartController extends GetxController {
  // قائمة المنتجات في السلة
  List<Map<String, dynamic>> cartItems = [];

  // كود الخصم
  TextEditingController discountCodeController = TextEditingController();
  String? discountCode;
  double discountAmount = 0.0;
  double discountPercentage = 0.0;

  // الملاحظات
  TextEditingController notesController = TextEditingController();
  String? notes;

  // رسوم التوصيل
  double deliveryFee = 10.0; // قيمة افتراضية

  // UserPreferences للحفظ
  final UserPreferences _prefs = UserPreferences();

  @override
  void onInit() {
    super.onInit();
    // تحميل السلة من SharedPreferences
    _loadCart();
  }

  void _loadCart() {
    cartItems = _prefs.getCart();
    discountCode = _prefs.getDiscountCode();
    if (discountCode != null) {
      discountCodeController.text = discountCode!;
    }
    notes = _prefs.getNotes();
    if (notes != null) {
      notesController.text = notes!;
    }
    update();
  }

  Future<void> _saveCart() async {
    await _prefs.saveCart(cartItems);
    if (discountCode != null) {
      await _prefs.saveDiscountCode(discountCode!);
    }
    if (notesController.text.isNotEmpty) {
      notes = notesController.text;
      await _prefs.saveNotes(notesController.text);
    } else {
      notes = null;
      await _prefs.removeNotes();
    }
  }

  // Method عام لحفظ السلة (يمكن استدعاؤه من الخارج)
  Future<void> saveCart() async {
    await _saveCart();
  }

  // التحقق من وجود طلب نشط
  bool hasActiveOrder() {
    return _prefs.hasActiveOrder();
  }

  // إضافة منتج للسلة
  void addItem(Products product, ItemModel shop, {int quantity = 1}) {
    // التحقق من وجود طلب نشط
    if (hasActiveOrder()) {
      Get.snackbar(
        "تنبيه",
        "يوجد طلب قيد المعالجة. لا يمكن إضافة منتجات جديدة",
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    // التحقق من null safety
    if (product.id == null) {
      Get.snackbar("خطأ", "معرّف المنتج غير صحيح");
      return;
    }
    if (shop.id == null) {
      Get.snackbar("خطأ", "معرّف المتجر غير صحيح");
      return;
    }

    // التحقق من وجود المنتج في السلة
    int existingIndex = cartItems.indexWhere(
      (item) => item['productId'] == product.id,
    );

    if (existingIndex != -1) {
      // إذا كان موجوداً، نزيد الكمية
      cartItems[existingIndex]['quantity'] =
          (cartItems[existingIndex]['quantity'] as int) + quantity;
      cartItems[existingIndex]['subtotal'] =
          (cartItems[existingIndex]['price'] as int) *
          (cartItems[existingIndex]['quantity'] as int);
    } else {
      // إذا لم يكن موجوداً، نضيفه
      final price = product.salePrice ?? product.regularPrice ?? 0;
      cartItems.add({
        'productId': product.id!,
        'shopId': shop.id!,
        'shopName': shop.name ?? '',
        'productName': product.name ?? '',
        'productDescription': product.description ?? '',
        'productImage': product.imageUrl ?? '',
        'price': price,
        'quantity': quantity,
        'subtotal': price * quantity,
      });
    }

    _saveCart();
    update();
    Get.snackbar(
      "تم الإضافة",
      "تم إضافة ${product.name ?? 'المنتج'} للسلة",
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 2),
    );
  }

  // حذف منتج من السلة
  void removeItem(int productId) {
    cartItems.removeWhere((item) => item['productId'] == productId);
    _saveCart();
    update();
    Get.snackbar(
      "تم الحذف",
      "تم حذف المنتج من السلة",
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 2),
    );
  }

  // زيادة كمية منتج
  void increaseQuantity(int productId) {
    int index = cartItems.indexWhere((item) => item['productId'] == productId);
    if (index != -1) {
      cartItems[index]['quantity'] = (cartItems[index]['quantity'] as int) + 1;
      cartItems[index]['subtotal'] =
          (cartItems[index]['price'] as int) *
          (cartItems[index]['quantity'] as int);
      _saveCart();
      update();
    }
  }

  // تقليل كمية منتج
  void decreaseQuantity(int productId) {
    int index = cartItems.indexWhere((item) => item['productId'] == productId);
    if (index != -1) {
      int currentQuantity = cartItems[index]['quantity'] as int;
      if (currentQuantity > 1) {
        cartItems[index]['quantity'] = currentQuantity - 1;
        cartItems[index]['subtotal'] =
            (cartItems[index]['price'] as int) *
            (cartItems[index]['quantity'] as int);
        _saveCart();
        update();
      } else {
        // إذا كانت الكمية 1، نحذف المنتج
        removeItem(productId);
      }
    }
  }

  // حساب المجموع الفرعي
  double get subtotal {
    double total = 0.0;
    for (var item in cartItems) {
      // التعامل مع int و double بشكل آمن
      final subtotalValue = item['subtotal'];
      if (subtotalValue is int) {
        total += subtotalValue.toDouble();
      } else if (subtotalValue is double) {
        total += subtotalValue;
      }
    }
    return total;
  }

  // حساب رسوم التوصيل
  double get calculatedDeliveryFee {
    // يمكن إضافة منطق للتحقق من minTotalForFreeDeliver
    // حالياً نرجع قيمة ثابتة
    if (subtotal >= 100) {
      // إذا كان المجموع >= 100، التوصيل مجاني
      return 0.0;
    }
    return deliveryFee;
  }

  // حساب الخصم
  double get calculatedDiscount {
    if (discountCode == null || discountCode!.isEmpty) {
      return 0.0;
    }
    // يمكن إضافة منطق للتحقق من كود الخصم من API
    // حالياً نستخدم نسبة مئوية ثابتة (10%)
    if (discountPercentage > 0) {
      return subtotal * (discountPercentage / 100);
    }
    return discountAmount;
  }

  // حساب المجموع الإجمالي
  double get total {
    return subtotal + calculatedDeliveryFee - calculatedDiscount;
  }

  // تطبيق كود الخصم
  void applyDiscount() async {
    String code = discountCodeController.text.trim();
    if (code.isEmpty) {
      Get.snackbar("تنبيه", "الرجاء إدخال كود الخصم");
      return;
    }

    // TODO: التحقق من كود الخصم من API
    // حالياً نستخدم كود وهمي للاختبار
    if (code.toLowerCase() == 'discount10' || code == 'خصم10') {
      discountCode = code;
      discountPercentage = 10.0;
      discountAmount = 0.0;
      await _prefs.saveDiscountCode(code);
      Get.snackbar("نجاح", "تم تطبيق كود الخصم بنجاح");
    } else {
      Get.snackbar("خطأ", "كود الخصم غير صحيح");
      discountCode = null;
      discountPercentage = 0.0;
      discountAmount = 0.0;
    }
    update();
  }

  // إزالة كود الخصم
  void removeDiscount() async {
    discountCode = null;
    discountCodeController.clear();
    discountPercentage = 0.0;
    discountAmount = 0.0;
    await _prefs.removeDiscountCode();
    update();
  }

  // مسح السلة بالكامل
  void clearCart() async {
    cartItems.clear();
    discountCode = null;
    discountCodeController.clear();
    discountPercentage = 0.0;
    discountAmount = 0.0;
    notes = null;
    notesController.clear();
    await _prefs.clearCart();
    update();
    Get.snackbar("تم المسح", "تم مسح السلة بالكامل");
  }

  // الحصول على عدد المنتجات في السلة
  int get itemCount {
    return cartItems.fold(0, (sum, item) {
      final quantity = item['quantity'];
      if (quantity is int) {
        return sum + quantity;
      } else if (quantity is double) {
        return sum + quantity.toInt();
      }
      return sum;
    });
  }

  // التحقق من وجود منتجات في السلة
  bool get isEmpty => cartItems.isEmpty;

  @override
  void onClose() {
    discountCodeController.dispose();
    notesController.dispose();
    super.onClose();
  }
}
