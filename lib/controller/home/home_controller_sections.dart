import 'package:app/controller/home/home_controller.dart';
import 'package:app/core/class/statusrequest.dart';
import 'package:app/core/function/handling_data.dart';
import 'package:app/data/datasource/model/home_section_model.dart';
import 'package:app/data/datasource/model/section_model.dart';

extension HomeSectionsLogic on HomeControllerImp {
  Future<void> runFetchHomeSection() async {
    homeSectionState = StatusRequest.loading;
    homeSection = [];
    update();
    final response =
        await homeSectionData.homeSectionData() as Map<String, dynamic>;
    homeSectionState = handlingData(response);
    if (homeSectionState == StatusRequest.success) {
      final sectionList = response['sections'] as List<dynamic>;
      for (var item in sectionList) {
        homeSection.add(HomeSectionModel.fromJson(item));
      }
      for (var section in homeSection) {
        final sections = await runFetchSection(section.type!);
        finalSection[section.type!] = sections;
      }
      if (homeSection.isNotEmpty) {
        selectedType = 0;
        sectionName =
            homeSection.first.type ?? homeSection.first.name ?? '';
        finalSectionState = finalSection[sectionName]?.isNotEmpty == true
            ? StatusRequest.success
            : StatusRequest.failure;
      }
      update();
    } else {
      homeSectionState = StatusRequest.failure;
      update();
    }
  }

  Future<List<SectionModel>> runFetchSection(String sectionName) async {
    sectionState = StatusRequest.loading;
    update();

    final response = await homeSectionData.sectionData(
      cityId,
      sectionName,
      categoryId: selectedCategoryId,
    );
    sectionState = handlingData(response);

    if (sectionState == StatusRequest.success && response is List) {
      return response
          .map<SectionModel>((e) => SectionModel.fromJson(e))
          .toList();
    }

    return [];
  }

  void runUpdateSection(int id, String name) {
    selectedType = id;
    final sectionKey =
        id >= 0 && id < homeSection.length && homeSection[id].type != null
        ? homeSection[id].type!
        : name;
    sectionName = sectionKey;
    finalSectionState = StatusRequest.loading;
    update();

    if (finalSection.containsKey(sectionKey)) {
      finalSectionState = StatusRequest.success;
      update();
      return;
    }

    runFetchSection(sectionKey).then((sections) {
      finalSection[sectionKey] = sections;
      finalSectionState = sections.isNotEmpty
          ? StatusRequest.success
          : StatusRequest.failure;
      update();
    });
  }
}
