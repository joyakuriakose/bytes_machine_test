import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

import '../../models/api_resp.dart';
import '../../presets/api_paths.dart';
import '../../utils/mydio.dart';

class HomeViewController extends GetxController {
  var categories = <Map<String, dynamic>>[].obs; // Ensure proper type
  var products = <Map<String, dynamic>>[].obs;
  var selectedCategory = ''.obs;
  int currentPage = 1;
  var isLoading = false.obs;
  var selectedIndex = 0.obs; // Track selected tab index

  List<Map<String, dynamic>> productss = [
    {"type": "Veg", "title": "Carrot", "image": [{"url": "https://via.placeholder.com/150"}]},
    {"type": "Fruits", "title": "Apple", "image": [{"url": "https://via.placeholder.com/150"}]},
    {"type": "Dairy", "title": "Milk", "image": [{"url": "https://via.placeholder.com/150"}]},
    {"type": "Meat", "title": "Chicken", "image": [{"url": "https://via.placeholder.com/150"}]},
  ];
  @override
  void onInit() {
    super.onInit();
    fetchCategoriesAndProducts(); // Initial fetch
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




// class HomeViewController extends GetxController {
//   var categories = <dynamic>[].obs;
//   var products = <dynamic>[].obs;
//   var selectedCategory = ''.obs;
//   var isLoading = false.obs;
//   int currentPage = 1;
//
//   @override
//   void onInit() {
//     super.onInit();
//     fetchCategoriesAndProducts('');
//   }
//
//   void fetchCategoriesAndProducts(String? categoryId) async {
//     isLoading(true);
//     try {
//       int page = currentPage;
//
//       // Ensure categoryId is provided, otherwise use 'all'
//       String category = categoryId?.isNotEmpty == true ? categoryId! : "all";
//       print("$category");
//       // Properly format API endpoint
//       String endpoint = "/product/category-products/all/$category/$page";
//
//       // Ensure baseUrl and endpoint are concatenated correctly
//       String fullUrl = "${ApiPaths.baseUrl}$endpoint";
//
//       print("API Request URL: $fullUrl"); // Debugging
//
//       dynamic response = await MyDio().get(endpoint);
//       print("$response");
//       if (response != null) {
//         ApiResp apiResponse = ApiResp.fromJson(response);
//
//         if (apiResponse.ok) {
//           var data = apiResponse.rdata;
//           categories.assignAll(data['categories'] ?? []);
//           products.assignAll(data['products'] ?? []);
//
//           if (categoryId == null && categories.isNotEmpty) {
//             selectedCategory.value = categories.first['id'];
//           }
//         } else {
//           print("API Error: ${apiResponse.message}");
//         }
//       } else {
//         print("Server Error: Response is null");
//       }
//     } catch (e) {
//       print("Error fetching data: $e");
//     } finally {
//       isLoading(false);
//     }
//   }
// }
