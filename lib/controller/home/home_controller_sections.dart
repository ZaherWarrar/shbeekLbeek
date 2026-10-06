import 'package:app/controller/home/home_controller.dart';
import 'package:app/core/class/statusrequest.dart';
import 'package:app/core/function/handling_data.dart';
import 'package:app/data/datasource/model/home_section_model.dart';
import 'package:app/data/datasource/model/section_model.dart';

extension HomeSectionsLogic on HomeControllerImp {
  Future<void> runFetchHomeSection() async {
    final keepTabs = homeSection.isNotEmpty;
    if (!keepTabs) {
      homeSectionState = StatusRequest.loading;
      finalSectionState = StatusRequest.loading;
      update();
    }

    final response = await homeSectionData.homeSectionData();
    final status = handlingData(response);
    if (status != StatusRequest.success || response is! Map<String, dynamic>) {
      if (homeSection.isEmpty) {
        homeSectionState = status == StatusRequest.success
            ? StatusRequest.failure
            : status;
        finalSectionState = StatusRequest.failure;
        update();
      }
      return;
    }
    homeSectionState = StatusRequest.success;

    final sectionList = response['sections'];
    if (sectionList is! List) {
      if (homeSection.isEmpty) {
        homeSectionState = StatusRequest.failure;
        finalSectionState = StatusRequest.failure;
        update();
      }
      return;
    }

    homeSection = [
      for (final item in sectionList) HomeSectionModel.fromJson(item),
    ];

    final selectedStillExists = homeSection.any(
      (section) => (section.type ?? section.name) == sectionName,
    );
    if (homeSection.isNotEmpty &&
        (sectionName.isEmpty || !selectedStillExists)) {
      selectedType = 0;
      sectionName = homeSection.first.type ?? homeSection.first.name ?? '';
    }
    if ((finalSection[sectionName] ?? const <SectionModel>[]).isEmpty) {
      finalSectionState = StatusRequest.loading;
    }
    update();

    final types = <String>[
      for (final section in homeSection)
        if (section.type != null && section.type!.isNotEmpty) section.type!,
    ];
    if (types.isEmpty) {
      finalSectionState = StatusRequest.failure;
      update();
      return;
    }

    await Future.wait(
      types.map((type) async {
        final sections = await _loadSectionProducts(type);
        finalSection[type] = sections;
        if (type == sectionName) {
          finalSectionState = sections.isNotEmpty
              ? StatusRequest.success
              : StatusRequest.failure;
          update();
        }
      }),
    );

    final visible = finalSection[sectionName];
    finalSectionState = visible != null && visible.isNotEmpty
        ? StatusRequest.success
        : StatusRequest.failure;
    update();
  }

  Future<List<SectionModel>> _loadSectionProducts(String name) async {
    final response = await homeSectionData.sectionData(
      cityId,
      name,
      categoryId: selectedCategoryId,
    );
    if (handlingData(response) != StatusRequest.success || response is! List) {
      return [];
    }
    return response
        .map<SectionModel>((e) => SectionModel.fromJson(e))
        .toList();
  }

  Future<List<SectionModel>> runFetchSection(String sectionName) async {
    sectionState = StatusRequest.loading;
    update();

    final sections = await _loadSectionProducts(sectionName);
    sectionState = sections.isEmpty
        ? StatusRequest.failure
        : StatusRequest.success;
    return sections;
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
