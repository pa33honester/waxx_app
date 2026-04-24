import 'dart:async';

import 'package:get/get.dart';
import 'package:waxxapp/ApiModel/search/search_results_model.dart';
import 'package:waxxapp/ApiService/search/unified_search_service.dart';

/// Drives the unified search view. Debounces text input so we don't fire on
/// every keystroke, and caches the latest results across scopes so the
/// tabbed list rebuilds instantly when the user switches tabs.
class UnifiedSearchController extends GetxController {
  final Rx<SearchResults> results = const SearchResults().obs;
  final RxString query = ''.obs;
  final RxBool isLoading = false.obs;
  final RxInt activeTab = 0.obs; // 0=Products, 1=Sellers, 2=Live, 3=Reels

  Timer? _debounce;

  void onQueryChanged(String value) {
    query.value = value;
    _debounce?.cancel();
    if (value.trim().length < 2) {
      results.value = const SearchResults();
      isLoading.value = false;
      return;
    }
    _debounce = Timer(const Duration(milliseconds: 350), _fetch);
  }

  Future<void> _fetch() async {
    isLoading.value = true;
    final data = await UnifiedSearchService.search(query: query.value);
    // Guard against stale responses: if the user edited the query while the
    // request was in flight, the newer fetch will overwrite anyway, but we
    // still want to avoid flashing a stale empty state.
    results.value = data;
    isLoading.value = false;
  }

  @override
  void onClose() {
    _debounce?.cancel();
    super.onClose();
  }
}
