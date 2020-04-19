import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hello_world/Pages/auth.dart';
import 'package:hello_world/db/product.dart';
import 'package:hello_world/productlist.dart';
import 'db/category.dart';
import 'registerproduct.dart';
import 'product_categories.dart';
import 'db/category.dart';

enum Page { dashboard, manage }

class Admin extends StatefulWidget {
  @override
  _AdminState createState() => _AdminState();
}

class _AdminState extends State<Admin> {
  Page _selectedPage = Page.dashboard;
  MaterialColor active = Colors.orange;
  MaterialColor notActive = Colors.grey;
  TextEditingController categoryController = TextEditingController();
  // TextEditingController brandController = TextEditingController();
  GlobalKey<FormState> _categoryFormKey = GlobalKey();
  // GlobalKey<FormState> _brandFormKey = GlobalKey();
  // BrandService _brandService = BrandService();
  CategoryService _categoryService = CategoryService();
  ProductService _productService = ProductService();
  bool categoryReady = false, productReady = false;
  String categories, products;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getCategories();
    _getProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: <Widget>[
            Expanded(
                child: FlatButton.icon(
                    onPressed: () {
                      setState(() => _selectedPage = Page.dashboard);
                    },
                    icon: Icon(
                      Icons.dashboard,
                      color:
                          _selectedPage == Page.dashboard ? active : notActive,
                    ),
                    label: Text('Dashboard'))),
            Expanded(
                child: FlatButton.icon(
                    onPressed: () {
                      setState(() => _selectedPage = Page.manage);
                    },
                    icon: Icon(
                      Icons.sort,
                      color: _selectedPage == Page.manage ? active : notActive,
                    ),
                    label: Text('Manage items'))),
          ],
        ),
        elevation: 0.0,
        backgroundColor: Colors.white,
      ),
      body: _loadScreen(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).pushNamed('/addproduct');
        },
        child: Icon(Icons.add),
        foregroundColor: Colors.white,
        tooltip: "Add item",
        elevation: 10.0,
      ),
    );
  }

  Widget _loadScreen() {
    switch (_selectedPage) {
      case Page.dashboard:
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            // ListTile(
            //   subtitle: FlatButton.icon(
            //     onPressed: null,
            //     icon: Icon(
            //       Icons.attach_money,
            //       size: 30.0,
            //       color: Colors.green,
            //     ),
            //     label: Text('12,000',
            //         textAlign: TextAlign.center,
            //         style: TextStyle(fontSize: 30.0, color: Colors.green)),
            //   ),
            //   title: Text(
            //     'Hello',
            //     textAlign: TextAlign.center,
            //     style: TextStyle(fontSize: 24.0, color: Colors.grey),
            //   ),
            // ),
            Expanded(
              child: GridView(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2),
                children: <Widget>[
                  /*     Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: Card(
                      child: ListTile(
                          title: FlatButton.icon(
                              onPressed: null,
                              icon: Icon(Icons.people_outline),
                              label: Text("Users")),
                          subtitle: Text(
                            '7',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: active, fontSize: 60.0),
                          )),
                    ),
                  ),*/
                  Padding(
                    padding: const EdgeInsets.all(9.0),
                    child: Card(
                      child: Wrap(
                        children: <Widget>[
                          ListTile(
                              title: FlatButton.icon(
                                  onPressed: null,
                                  icon: Icon(Icons.category),
                                  label: Text("Categories")),
                              subtitle: categoryReady
                                  ? Text(
                                      categories,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          color: active, fontSize: 60.0),
                                    )
                                  : Padding(
                                      child: CircularProgressIndicator(),
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 40.0)),
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (_) => ProductCategories()));
                              }),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(9.0),
                    child: Card(
                      child: ListTile(
                          title: FlatButton.icon(
                              onPressed: null,
                              icon: Icon(Icons.track_changes),
                              label: Text("Products")),
                          subtitle: productReady
                              ? Text(
                                  products,
                                  textAlign: TextAlign.center,
                                  style:
                                      TextStyle(color: active, fontSize: 60.0),
                                )
                              : Padding(
                                  child: CircularProgressIndicator(),
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 40.0)),
                          onTap: () {
                            setState(() => _selectedPage = Page.manage);
                            // Navigator.push(
                            //     context,
                            //     MaterialPageRoute(
                            //         builder: (_) => ProductList()));
                          }),
                    ),
                  ),
                  // Padding(
                  //   padding: const EdgeInsets.all(9.0),
                  //   child: Card(
                  //     child: ListTile(
                  //         title: FlatButton.icon(
                  //             onPressed: null,
                  //             icon: Icon(Icons.tag_faces),
                  //             label: Text("Sold")),
                  //         subtitle: Text(
                  //           '13',
                  //           textAlign: TextAlign.center,
                  //           style: TextStyle(color: active, fontSize: 60.0),
                  //         )),
                  //   ),
                  // ),
                  // Padding(
                  //   padding: const EdgeInsets.all(9.0),
                  //   child: Card(
                  //     child: ListTile(
                  //         title: FlatButton.icon(
                  //             onPressed: null,
                  //             icon: Icon(Icons.shopping_cart),
                  //             label: Text("Orders")),
                  //         subtitle: Text(
                  //           '5',
                  //           textAlign: TextAlign.center,
                  //           style: TextStyle(color: active, fontSize: 60.0),
                  //         )),
                  //   ),
                  // ),
                  // Padding(
                  //   padding: const EdgeInsets.all(9.0),
                  //   child: Card(
                  //     child: ListTile(
                  //         title: FlatButton.icon(
                  //             onPressed: null,
                  //             icon: Icon(Icons.close),
                  //             label: Text("Return")),
                  //         subtitle: Text(
                  //           '0',
                  //           textAlign: TextAlign.center,
                  //           style: TextStyle(color: active, fontSize: 60.0),
                  //         )),
                  //   ),
                  // ),
                ],
              ),
            ),
            Expanded(
              child: Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Card(
                      child: ListTile(
                    title: Text('hello'),
                  ))),
            ),
            FlatButton.icon(
              onPressed: () => _logOut(context),
              icon: Icon(Icons.exit_to_app),
              label: Text('Log Out'),
              color: active,
              textColor: Colors.white,
            ),
          ],
        );
        break;
      case Page.manage:
        return ProductList();
        // return ListView(
        //   children: <Widget>[
        //     ListTile(
        //       leading: Icon(Icons.add),
        //       title: Text("Add product"),
        //       onTap: () {
        //         Navigator.push(
        //             context, MaterialPageRoute(builder: (_) => HomeMaterial()));
        //       },
        //     ),
        //     Divider(),
        //     ListTile(
        //         leading: Icon(Icons.change_history),
        //         title: Text("Products list"),
        //         onTap: () {
        //           Navigator.push(context,
        //               MaterialPageRoute(builder: (_) => ProductList()));
        //         }),
        //     Divider(),
        //     ListTile(
        //       leading: Icon(Icons.add_circle),
        //       title: Text("Add category"),
        //       onTap: () {
        //         _categoryAlert();
        //       },
        //     ),
        //     Divider(),
        //     ListTile(
        //         leading: Icon(Icons.category),
        //         title: Text("Category list"),
        //         onTap: () {
        //           Navigator.push(context,
        //               MaterialPageRoute(builder: (_) => ProductCategories()));
        //         }),
        //     Divider(),
        //   ],
        // );
        break;
      default:
        return Container();
    }
  }

  // void _categoryAlert() {
  //   var alert = new AlertDialog(
  //     content: Form(
  //       key: _categoryFormKey,
  //       child: TextFormField(
  //         controller: categoryController,
  //         validator: (value) {
  //           if (value.isEmpty) {
  //             return 'category cannot be empty';
  //           }
  //         },
  //         decoration: InputDecoration(hintText: "add category"),
  //       ),
  //     ),
  //     actions: <Widget>[
  //       FlatButton(
  //           onPressed: () {
  //             if (categoryController.text != null) {
  //               _categoryService.createCategory(categoryController.text);
  //               print('yay');
  //             }
  //             Fluttertoast.showToast(msg: 'category created');
  //             Navigator.pop(context);
  //           },
  //           child: Text('ADD')),
  //       FlatButton(
  //           onPressed: () {
  //             Navigator.pop(context);
  //           },
  //           child: Text('CANCEL')),
  //     ],
  //   );

  //   showDialog(context: context, builder: (_) => alert);
  // }

  _getCategories() async {
    List<DocumentSnapshot> catList = await _categoryService.getCategories();
    setState(() {
      categories = catList.length.toString();
      categoryReady = true;
    });
  }

  _getProducts() async {
    String uid = await Auth.getUID();
    if (uid != null) {
      List<DocumentSnapshot> productList =
          await _productService.getAllProducts(uid);
      setState(() {
        products = productList.length.toString();
        productReady = true;
      });
    }
  }

  void _logOut(context) async {
    Auth auth = new Auth();
    await auth.signOut();
    Navigator.of(context).pushReplacementNamed('/login');
  }

  // _getUID() async {
  //   var data = await Auth.getUID();
  //   print(data.toString());
  //   setState(() {
  //     uid = data.toString();
  //   });
  // }
}
