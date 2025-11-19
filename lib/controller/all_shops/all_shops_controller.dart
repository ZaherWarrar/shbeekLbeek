import 'package:app/data/datasorce/model/shops_card_model.dart';
import 'package:get/get.dart';

class AllShopsController extends GetxController {
  var shops = <ShopsCardModel>[].obs;

  @override
  void onInit() {
    fetchShops();
    super.onInit();
  }

  void fetchShops() {
    shops.value = [
      ShopsCardModel(
        id: 1,
        name: "alo checken",
        describtion: "resturant , fast food",
        image:
            "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTMwPzpA_T0qpo5IHi5LM-Us80mnjcNrr5G5Q&s",
        rating: 4.8,
        minDeliveryTime: 23,
        maxDeliveryTime: 25,
      ),
      ShopsCardModel(
        id: 1,
        name: "alo checken",
        describtion: "resturant , fast food",
        image:
            "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTMwPzpA_T0qpo5IHi5LM-Us80mnjcNrr5G5Q&s",
        rating: 4.8,
        minDeliveryTime: 23,
        maxDeliveryTime: 25,
      ),
      ShopsCardModel(
        id: 1,
        name: "alo checken",
        describtion: "resturant , fast food",
        image:
            "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTMwPzpA_T0qpo5IHi5LM-Us80mnjcNrr5G5Q&s",
        rating: 4.8,
        minDeliveryTime: 23,
        maxDeliveryTime: 25,
      ),
    ];
  }
}
