import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:pantryio/Pages/auth.dart';
// import 'package:pantryio/cart_product.dart';
import 'package:pantryio/db/cartproduct.dart';
import 'package:pantryio/db/product.dart';
import 'package:intl/intl.dart';
// import 'placeorder.dart';
// import 'cart.dart';
import 'db/cartproduct.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProductViewDetail extends StatefulWidget {
  final product_detail_id;
  final product_detail_name;
  final product_detail_price;
  final product_detail_picture;
  int product_detail_quantity;
  String product_detail_date;
  final product_detail_threshold;
  final product_detail_category;
  final bool product_detail_refill;
  final _quantityController = TextEditingController();

  ProductViewDetail({
    this.product_detail_id,
    this.product_detail_name,
    this.product_detail_price,
    this.product_detail_picture,
    this.product_detail_quantity,
    this.product_detail_date,
    this.product_detail_threshold,
    this.product_detail_category,
    this.product_detail_refill,
  });
  @override
  _ProductViewDetailState createState() => _ProductViewDetailState();
}

class _ProductViewDetailState extends State<ProductViewDetail> {
  TextEditingController _productNameController = TextEditingController();
  TextEditingController _productPriceController = TextEditingController();
  TextEditingController _quantityController = TextEditingController();
  ProductService _productService = ProductService();
  CartService _cartService = CartService();
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  GlobalKey<FormState> _quantityFormKey = GlobalKey();
  bool isLoading = false;
  String _currentItemSelected = '1';
  String quant = '0';
  String uid;
  var _numbers = ['0'];
  @override
  void initState() {
    _getQuantity();
  }

  void quantityD() {
    _numbers.removeLast();
    for (int i = 1; i <= int.parse(quant); i++) {
      _numbers.add(i.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Text('View item', style: TextStyle(color: Colors.orange)),
          // actions: <Widget>[
          //   new IconButton(
          //     icon: Icon(Icons.search, color: Colors.black),
          //     onPressed: () {},
          //   ),
          //   new IconButton(
          //     icon: Icon(Icons.shopping_basket, color: Colors.black),
          //     onPressed: () {
          //       Navigator.push(
          //           context,
          //           MaterialPageRoute(
          //               builder: (context) => new Single_cart_product()));
          //     },
          //   )
          // ],
        ),
        body: Container(
          padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
          child: Builder(
              builder: (context) => Form(
                    key: _formKey,
                    child: ListView(
                      children: <Widget>[
                        Container(
                          height: 300.0,
                          child: GridTile(
                            child: Container(
                              color: Colors.white,
                              child:
                                  Image.network(widget.product_detail_picture),
                            ),
                            footer: Container(
                                color: Colors.white70,
                                child: ListTile(
                                  leading: Text(
                                    widget.product_detail_name,
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20.0),
                                  ),
                                  title: Row(
                                    children: <Widget>[
                                      Expanded(
                                          child: Text(
                                        "\₹${widget.product_detail_price}",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.orange),
                                      ))
                                    ],
                                  ),
                                )),
                          ),
                        ),
                        Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 15.0, vertical: 10.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                if(widget.product_detail_refill) Text('Refill needed!',
                                        style: TextStyle(
                                            color: Colors.red,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18.0)),
                                Row(
                                  children: <Widget>[
                                    Text(
                                      'Category: ',
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18.0),
                                    ),
                                    Text(
                                      widget.product_detail_category,
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                          color: Colors.orange, fontSize: 18.0),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: <Widget>[
                                    Text(
                                      'Updated on: ',
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18.0),
                                    ),
                                    Text(
                                      widget.product_detail_date,
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                          color: Colors.orange, fontSize: 18.0),
                                    ),
                                  ],
                                ),
                                InkWell(
                                  onTap: () {
                                    _quantityAlert();
                                  },
                                  child: Row(
                                    children: <Widget>[
                                      Text(
                                        'Quantity: ',
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18.0),
                                      ),
                                      Text(
                                        widget.product_detail_quantity
                                            .toString(),
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                            color: Colors.orange,
                                            fontSize: 18.0),
                                      ),
                                      SizedBox(width: 5.0),
                                      Icon(Icons.edit,
                                          color: Colors.black45, size: 20.0),
                                    ],
                                  ),
                                ),
                                Row(
                                  children: <Widget>[
                                    Text(
                                      'Minimum requirement: ',
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18.0),
                                    ),
                                    Text(
                                      widget.product_detail_threshold
                                          .toString(),
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                          color: Colors.orange, fontSize: 18.0),
                                    ),
                                  ],
                                ),
                              ],
                            )),

                        Divider(),
                        FlatButton.icon(
                          onPressed: _deleteProduct,
                          icon: Icon(Icons.delete),
                          label: Text('Delete item'),
                          color: Colors.red,
                          textColor: Colors.white,
                        ),
                        
                      ],
                    ),
                  )),
        ));
  }

  _getQuantity() async {
    setState(() {
      quant = widget.product_detail_quantity.toString();
      quantityD();
      _currentItemSelected = '1';
    });
  }

  _updateProduct() async {
    uid = await Auth.getUID();

    _productService.updateProduct(
      uid: uid,
      productId: widget.product_detail_id,
      productName: widget.product_detail_name,
      price: widget.product_detail_price,
      category: widget.product_detail_category,
      image: widget.product_detail_picture,
      quantity: widget.product_detail_quantity,
      date: widget.product_detail_date,
      threshold: widget.product_detail_threshold,
    );
  }

  _deleteProduct() async {
    String productName = widget.product_detail_name;
    uid = await Auth.getUID();
    bool success = _productService.deleteProduct(uid, widget.product_detail_id);
    if (success) {
      Fluttertoast.showToast(msg: 'Deleted product ' + productName);
    } else {
      Fluttertoast.showToast(
          msg: 'Error deleting product ' + productName,
          backgroundColor: Colors.red);
    }
    Navigator.of(context).pop();
  }

  void _quantityAlert() {
    var alert = new AlertDialog(
      content: Form(
        key: _quantityFormKey,
        child: TextFormField(
          keyboardType: TextInputType.numberWithOptions(),
          controller: _quantityController,
          validator: (value) {
            if (value.isEmpty) {
              return 'Quantity field cannot be empty';
            }
          },
          decoration: InputDecoration(hintText: "Change quantity"),
        ),
      ),
      actions: <Widget>[
        FlatButton(
            onPressed: () {
              if (_quantityController.text != null) {
                setState(() {
                  widget.product_detail_quantity =
                      int.parse(_quantityController.text);
                  widget.product_detail_date =
                      DateFormat("dd-MM-yyyy hh:mm:ss").format(DateTime.now());
                });
                _updateProduct();
                // _categoryService.createCategory(categoryController.text);
                print('yay');
              }
              Fluttertoast.showToast(msg: 'Quantity updated');
              Navigator.pop(context);
            },
            child: Text('SAVE')),
        FlatButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text('CANCEL')),
      ],
    );

    showDialog(context: context, builder: (_) => alert);
  }

  void _dropDownItemSelected(String newValueSelected) {
    setState(() {
      _currentItemSelected = newValueSelected;
    });
  }

  void validateAndUpload() async {
    if (_formKey.currentState.validate()) {
      setState(() => isLoading = true);

      _cartService.uploadProduct(
          productName: widget.product_detail_name,
          price: widget.product_detail_price,
          quantity: int.parse(_currentItemSelected),
          image: widget.product_detail_picture);
      _formKey.currentState.reset();

      setState(() => isLoading = false);
      Fluttertoast.showToast(msg: 'Product added to the Cart');
      Navigator.pop(context);
    }
  }
}