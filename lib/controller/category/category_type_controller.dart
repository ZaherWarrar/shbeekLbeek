import 'package:app/core/constant/app_images.dart';
import 'package:get/get_state_manager/get_state_manager.dart';

abstract class CategoryTypeController extends GetxController {
  // ignore: strict_top_level_inference
  selectType(int index);
}

class CategoryTypeControllerImb extends CategoryTypeController {
  List<Map<String, dynamic>> data = [
    {
      "id": 1,
      "category": "الأكثر طلبا",
      "data": [
        {
          "id": 1,
          "image": Assets.imagesCategory1,
          "title": "بيتزا مارغريتا",
          "dis": "بيتزا إيطالية بالجبن الطازج",
          "rate": 4.8,
          "count": 430,
        },
        {
          "id": 2,
          "image": Assets.imagesCategory2,
          "title": "برجر كلاسيك",
          "dis": "لحم بقري مشوي مع صوص خاص",
          "rate": 4.6,
          "count": 365,
        },
        {
          "id": 3,
          "image": Assets.imagesCategory3,
          "title": "شاورما عربي",
          "dis": "صدور دجاج متبلة على الطريقة الشامية",
          "rate": 4.7,
          "count": 510,
        },
        {
          "id": 4,
          "image": Assets.imagesCategory4,
          "title": "سوشي ميكس",
          "dis": "تشكيلة سوشي طازجة",
          "rate": 4.4,
          "count": 245,
        },
        {
          "id": 5,
          "image": Assets.imagesCategory1,
          "title": "باستا ألفريدو",
          "dis": "مكرونة بكريمة الفطر والبارميزان",
          "rate": 4.5,
          "count": 190,
        },
        {
          "id": 6,
          "image": Assets.imagesCategory2,
          "title": "كباب بالفرن",
          "dis": "كباب لحم مع خضار مشوية",
          "rate": 4.3,
          "count": 210,
        },
        {
          "id": 7,
          "image": Assets.imagesCategory3,
          "title": "سلطة سيزر",
          "dis": "خس طازج مع صوص السيزر",
          "rate": 4.2,
          "count": 320,
        },
        {
          "id": 8,
          "image": Assets.imagesCategory4,
          "title": "تشيكن وينجز",
          "dis": "أجنحة دجاج حارة بالعسل",
          "rate": 4.6,
          "count": 280,
        },
        {
          "id": 9,
          "image": Assets.imagesCategory1,
          "title": "كريب شوكولاتة",
          "dis": "كريب محشو بالنوتيلا والموز",
          "rate": 4.9,
          "count": 540,
        },
        {
          "id": 10,
          "image": Assets.imagesCategory2,
          "title": "سمك مقلي",
          "dis": "فيليه سمك مقرمش مع صوص الترتار",
          "rate": 4.5,
          "count": 150,
        },
      ],
    },
    {
      "id": 2,
      "category": "وصل حديثا",
      "data": [
        {
          "id": 11,
          "image": Assets.imagesCategory3,
          "title": "مندي دجاج",
          "dis": "أرز بسمتي مع دجاج متبل ومدخن",
          "rate": 4.4,
          "count": 60,
        },
        {
          "id": 12,
          "image": Assets.imagesCategory4,
          "title": "سلطة الكينوا",
          "dis": "كينوا مع خضار موسمية طازجة",
          "rate": 4.1,
          "count": 45,
        },
        {
          "id": 13,
          "image": Assets.imagesCategory1,
          "title": "تاكو مكسيكي",
          "dis": "تاكو باللحم المفروم والصوص الحار",
          "rate": 4.3,
          "count": 72,
        },
        {
          "id": 14,
          "image": Assets.imagesCategory2,
          "title": "سموزي التوت",
          "dis": "عصير توت طبيعي مع لبن يوناني",
          "rate": 4.6,
          "count": 55,
        },
        {
          "id": 15,
          "image": Assets.imagesCategory3,
          "title": "معجنات تركية",
          "dis": "بوريك بالجبنة والسبانخ",
          "rate": 4.2,
          "count": 68,
        },
        {
          "id": 16,
          "image": Assets.imagesCategory4,
          "title": "دجاج مقرمش",
          "dis": "قطع دجاج مغطاة بالبقسماط",
          "rate": 4.0,
          "count": 83,
        },
        {
          "id": 17,
          "image": Assets.imagesCategory1,
          "title": "تشيز كيك فراولة",
          "dis": "تشيز كيك بصوص الفراولة الطازج",
          "rate": 4.7,
          "count": 64,
        },
        {
          "id": 18,
          "image": Assets.imagesCategory2,
          "title": "برياني لحم",
          "dis": "لحم ببطء مع أرز بسمتي متبل",
          "rate": 4.5,
          "count": 70,
        },
        {
          "id": 19,
          "image": Assets.imagesCategory3,
          "title": "رز بسمك السلمون",
          "dis": "سلمون مشوي على طبقة من الأرز",
          "rate": 4.6,
          "count": 52,
        },
        {
          "id": 20,
          "image": Assets.imagesCategory4,
          "title": "بوكس فطور شرقي",
          "dis": "تشكيلة لبنة وزعتر وزيتون",
          "rate": 4.2,
          "count": 49,
        },
      ],
    },
    {
      "id": 3,
      "category": "الأكثر تقييما",
      "data": [
        {
          "id": 21,
          "image": Assets.imagesCategory1,
          "title": "فطور إنجليزي",
          "dis": "بيض، سجق، فاصوليا وصلصة خاصة",
          "rate": 4.9,
          "count": 610,
        },
        {
          "id": 22,
          "image": Assets.imagesCategory2,
          "title": "ستيك ريب آي",
          "dis": "شريحة لحم بقري مشوية على الفحم",
          "rate": 4.8,
          "count": 455,
        },
        {
          "id": 23,
          "image": Assets.imagesCategory3,
          "title": "مقبلات مشكّلة",
          "dis": "حمص، متبل، تبولة ومقبلات ساخنة",
          "rate": 4.7,
          "count": 380,
        },
        {
          "id": 24,
          "image": Assets.imagesCategory4,
          "title": "مندي لحم",
          "dis": "أرز بخاري مع لحم ضأن طري",
          "rate": 4.9,
          "count": 295,
        },
        {
          "id": 25,
          "image": Assets.imagesCategory1,
          "title": "فتوش لبناني",
          "dis": "سلطة فتوش مع سماق طازج",
          "rate": 4.6,
          "count": 330,
        },
        {
          "id": 26,
          "image": Assets.imagesCategory2,
          "title": "كنافة نابلسية",
          "dis": "كنافة بالقشطة مع شيرة خفيفة",
          "rate": 4.9,
          "count": 520,
        },
        {
          "id": 27,
          "image": Assets.imagesCategory3,
          "title": "سلطة الأفوكادو",
          "dis": "أفوكادو مع صوص ليمون ونعناع",
          "rate": 4.5,
          "count": 270,
        },
        {
          "id": 28,
          "image": Assets.imagesCategory4,
          "title": "جمبري غارليك",
          "dis": "جمبري بالثوم والزبدة",
          "rate": 4.8,
          "count": 410,
        },
        {
          "id": 29,
          "image": Assets.imagesCategory1,
          "title": "عصير ديتوكس",
          "dis": "تفاح، خيار، زنجبيل وليمون",
          "rate": 4.4,
          "count": 215,
        },
        {
          "id": 30,
          "image": Assets.imagesCategory2,
          "title": "مولتن كيك",
          "dis": "كيك شوكولاتة ساخن بقلب سائل",
          "rate": 4.9,
          "count": 560,
        },
      ],
    },
  ];

  int selectedType = 0;
  late List<Map<String, dynamic>> dataCategory = data[0]["data"];

  @override
  selectType(int index) {
    selectedType = index;
    dataCategory = data[index]["data"];
    update();
  }
}
