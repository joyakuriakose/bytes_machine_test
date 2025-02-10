import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import '../../models/api_resp.dart';
import '../../presets/api_paths.dart';
import '../../utils/mydio.dart';

class HomeViewController extends GetxController {
  var categories = <Map<String, dynamic>>[].obs;
  var products = <Map<String, dynamic>>[].obs;
  var selectedCategory = ''.obs;
  int currentPage = 1;
  var isLoading = false.obs;
  var selectedIndex = 0.obs;

  @override
  void onInit() {
    super.onInit();
    fetchCategoriesAndProducts();
  }

  @override
  Future<void> refresh() async {
    return fetchCategoriesAndProducts();
  }

  void fetchCategoriesAndProducts([String? categoryId]) async {
    isLoading(true);
    try {
      String category = categoryId?.isNotEmpty == true ? categoryId! : "all";
      String endpoint = "/product/category-products/all/$category/$currentPage";
      String fullUrl = "${ApiPaths.baseUrl}$endpoint";

      print("API Request URL: $fullUrl");

      dynamic response = await MyDio().get(endpoint);

      if (response != null) {
        ApiResp apiResponse = ApiResp.fromJson(response);
        if (apiResponse.ok) {
          var data = apiResponse.rdata;
          // Debugging
          print("API Response Data: $data");

          if (data['categories'] != null) {
            categories.assignAll(List<Map<String, dynamic>>.from(data['categories']));
          }
          if (data['products'] != null) {
            products.assignAll(List<Map<String, dynamic>>.from(data['products']));
          }
          // Auto-select first category if no category is selected
          if (selectedCategory.value.isEmpty && categories.isNotEmpty) {
            selectedCategory.value = categories.first['id'];
          }
        } else {
          print("API Error: ${apiResponse.message}");
        }
      } else {
        print("Server Error: Response is null");
      }
    } catch (e) {
      print("Error fetching data: $e");
    } finally {
      isLoading(false);
    }
  }
}
