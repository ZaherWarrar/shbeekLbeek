import 'package:app/view/favorets/widget/favorates_tabs/favorates_tabs_model.dart';
import 'package:get/get.dart';

class FavoritesController extends GetxController {
  var restaurants = <RestaurantModel>[
    RestaurantModel(
      id: 1,
      name: "برجر كنج",
      image: "https://images.unsplash.com/photo-1550547660-d9450f859349",
      rating: 4.5,
      category: "برجر",
      isFavorite: true,
    ),
    RestaurantModel(
      id: 2,
      name: "بيت الشاورما",
      image: "https://images.unsplash.com/photo-1600891964599-f61ba0e24092",
      rating: 4.7,
      category: "شاورما",
      isFavorite: true,
    ),
    RestaurantModel(
      id: 3,
      name: "ماكدونالدز",
      image: "https://images.unsplash.com/photo-1618213837799-25d5552820d3",
      rating: 4.4,
      category: "وجبات سريعة",
      isFavorite: true,
    ),
    RestaurantModel(
      id: 4,
      name: "كودو",
      image: "https://images.unsplash.com/photo-1551218808-94e220e084d2",
      rating: 4.6,
      category: "ساندويتشات",
      isFavorite: true,
    ),
  ].obs;

  var currentIndex = 1.obs;

  void changeTab(int index) {
    currentIndex.value = index;
  }

 void toggleFavorite(int index) {
  restaurants[index].isFavorite.toggle();
}

}