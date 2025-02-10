import 'package:bytes_machine_test/utils/my_theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';
import '../../components/app_refresh.dart';
import '../../components/rounded_loader.dart';
import '../../utils/my_utils.dart';
import 'home_controller.dart';

class HomeView extends GetView<HomeViewController> {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<String> staticProductTypes = [
      "Milk",
      "Cheese",
      "Butter",
      "Yogurt",
    ];

    return GestureDetector(
        onTap: () {
          MyUtils.hideKeyboard();
        },
        child: Scaffold(
            appBar: AppBar(
              title: Text(
                "Vegitables & Fruits",
                style: MyTheme.regularTextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 18,
                  color: Colors.black,
                ),
              ),
              centerTitle: true,
              backgroundColor: Colors.yellow[100],
              leading: IconButton(
                icon: Icon(Icons.arrow_back_ios_new_outlined,
                    color: Colors.black),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              actions: [
                IconButton(
                  icon: Icon(Icons.search, color: Colors.black),
                  onPressed: () {},
                ),
              ],
            ),
            body: Padding(
              padding: EdgeInsets.all(8.0),
              child: AppRefresh(
                refreshFunction: () => controller.refresh(),
                child: Obx(() {
                  if (controller.isLoading.value) {
                    return Center(child: RoundedLoader());
                  }
                  // Extract dynamic types from API and merge with static types
                  List<String> dynamicProductTypes = controller.products
                      .map<String>((product) => product['type'].toString())
                      .toSet()
                      .toList();

                  List<String> allProductTypes = [
                    ...dynamicProductTypes,
                    ...staticProductTypes
                  ];

                  if (allProductTypes.isEmpty) {
                    return Center(child: Text("No categories available"));
                  }
                  return Row(
                    children: [
                      SizedBox(
                        width: Get.width * 0.2,
                        child: SingleChildScrollView(
                          child: Column(
                            children:
                                List.generate(allProductTypes.length, (index) {
                              bool isSelected =
                                  controller.selectedIndex.value == index;
                              return GestureDetector(
                                onTap: () =>
                                    controller.selectedIndex.value = index,
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(
                                            vertical: Get.height * 0.02),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            ClipOval(
                                              child: Image.asset(
                                                "assets/images/strawberry.jpg",
                                                width: Get.width * 0.185,
                                                height: Get.height * 0.097,
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                            SizedBox(height: Get.height * 0.01),
                                            Text(
                                              allProductTypes[index][0]
                                                      .toUpperCase() +
                                                  allProductTypes[index]
                                                      .substring(1),
                                              // Capitalized
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w600,
                                                color: isSelected
                                                    ? Colors.blue
                                                    : Colors.grey,
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                    AnimatedContainer(
                                        duration: Duration(milliseconds: 300),
                                        width: isSelected ? 3 : 0,
                                        height: Get.height * 0.1,
                                        color: Colors.green),
                                  ],
                                ),
                              );
                            }),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Obx(() {
                          if (controller.isLoading.value) {
                            return Center(child: RoundedLoader());
                          }

                          if (controller.products.isEmpty) {
                            return Center(child: Text("No products available"));
                          }

                          var selectedType = allProductTypes.isNotEmpty
                              ? allProductTypes[controller.selectedIndex.value]
                              : "";
                          // Show products if selected type exists in API data
                          var filteredProducts = controller.products
                              .where(
                                  (product) => product['type'] == selectedType)
                              .toList();

                          return filteredProducts.isNotEmpty
                              ? GridView.builder(
                                  gridDelegate:
                                      SliverGridDelegateWithMaxCrossAxisExtent(
                                    maxCrossAxisExtent: 200,
                                    crossAxisSpacing: 10,
                                    mainAxisSpacing: 10,
                                    childAspectRatio: 0.55,
                                  ),
                                  itemCount: filteredProducts.length,
                                  itemBuilder: (context, index) {
                                    var product = filteredProducts[index];
                                    return Card(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            height: Get.height * 0.15,
                                            // Increased image height
                                            width: double.infinity,
                                            child: Stack(
                                              clipBehavior: Clip.none,
                                              children: [
                                                Positioned.fill(
                                                  child: ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.vertical(
                                                            top:
                                                                Radius.circular(
                                                                    10)),
                                                    child: Image.network(
                                                      product['image'][0]
                                                          ['url'],
                                                      width: double.infinity,
                                                      fit: BoxFit.cover,
                                                    ),
                                                  ),
                                                ),
                                                Positioned(
                                                  bottom: -10,
                                                  right: 0,
                                                  child: Container(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            horizontal:
                                                                Get.width *
                                                                    0.02,
                                                            vertical:
                                                                Get.height *
                                                                    0.01),
                                                    decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              5),
                                                      border: Border.all(
                                                          color: Colors.green,
                                                          width: 2),
                                                      boxShadow: [
                                                        BoxShadow(
                                                          color: Colors.black26,
                                                          blurRadius: 4,
                                                          offset: Offset(0, 2),
                                                        ),
                                                      ],
                                                    ),
                                                    child: Text(
                                                      "ADD",
                                                      style: TextStyle(
                                                        color: Colors.green,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.only(
                                                top: Get.height * 0.02,
                                                left: 8,
                                                right: 8),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Container(
                                                      decoration: BoxDecoration(
                                                        color: Colors.grey[300],
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(5),
                                                      ),
                                                      child: Center(
                                                        child: Padding(
                                                          padding:
                                                              EdgeInsets.only(
                                                                  left: 5.0,
                                                                  right: 5.0,
                                                                  top: 3.0,
                                                                  bottom: 3.0),
                                                          child: Text(
                                                            "500 g",
                                                            style: TextStyle(
                                                              color: Colors
                                                                  .blue[800],
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 12,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    Container(
                                                      decoration: BoxDecoration(
                                                        color: Colors.grey[300],
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(5),
                                                      ),
                                                      child: Center(
                                                        child: Padding(
                                                          padding:
                                                              EdgeInsets.only(
                                                                  left: 5.0,
                                                                  top: 3.0,
                                                                  bottom: 3.0,
                                                                  right: 3),
                                                          child: Text(
                                                            "Energy Booster",
                                                            style: TextStyle(
                                                              color: Colors
                                                                  .blue[800],
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 10,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(height: 5),
                                                Text(
                                                  product['title'],
                                                  style: MyTheme.labelTextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black,
                                                  ),
                                                ),
                                                SizedBox(height: 5),
                                                Row(
                                                  children: [
                                                    Icon(
                                                        Icons
                                                            .timelapse_outlined,
                                                        color: Colors.green,
                                                        size: 15),
                                                    SizedBox(width: 4),
                                                    Text(
                                                      "8 mins".toUpperCase(),
                                                      style: TextStyle(
                                                        fontSize: 10,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.black,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(
                                                    height: Get.height * 0.001),
                                                Text(
                                                  "24% off".toUpperCase(),
                                                  style: TextStyle(
                                                    fontSize: 10,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.blue[800],
                                                  ),
                                                ),
                                                SizedBox(height: 5),
                                                Row(
                                                  children: [
                                                    Row(
                                                      children: [
                                                        Icon(
                                                            Icons
                                                                .currency_rupee_outlined,
                                                            size: 12),
                                                        Text(
                                                          product['discountPrice']
                                                              .toString(),
                                                          style: TextStyle(
                                                            fontSize: 12,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color: Colors
                                                                .blue[800],
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    SizedBox(
                                                        width:
                                                            Get.width * 0.015),
                                                    Row(
                                                      children: [
                                                        Text(
                                                          "MRP".toUpperCase(),
                                                          style: TextStyle(
                                                            fontSize: 12,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color: Colors
                                                                .blue[800],
                                                          ),
                                                        ),
                                                        Icon(
                                                            Icons
                                                                .currency_rupee_outlined,
                                                            size: 14),
                                                        Text(
                                                          product['price']
                                                              .toString(),
                                                          style: TextStyle(
                                                            fontSize: 12,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color: Colors
                                                                .blue[800],
                                                            decoration:
                                                                TextDecoration
                                                                    .lineThrough,
                                                            decorationColor:
                                                                Colors.black,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(height: 5),
                                                Container(
                                                  width: Get.width * 0.4,
                                                  height: Get.height * 0.03,
                                                  decoration: BoxDecoration(
                                                    color: Colors.green[100],
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5),
                                                  ),
                                                  child: Padding(
                                                    padding:
                                                        EdgeInsets.all(0.0),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Row(
                                                          children: [
                                                            Text(
                                                              "See 19 receipes",
                                                              style: TextStyle(
                                                                color: Colors
                                                                    .green[900],
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontSize: 12,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        Row(
                                                          children: [
                                                            Container(
                                                              width: 3,
                                                              height: 20,
                                                              color:
                                                                  Colors.green,
                                                            ),
                                                            Icon(Icons
                                                                .arrow_right_outlined)
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                )
                              : Center(
                                  child: Text(
                                      "No products available in $selectedType"));
                        }),
                      ),
                    ],
                  );
                }),
              ),
            )));
  }
}
