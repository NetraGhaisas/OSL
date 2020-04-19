import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hello_world/Pages/auth.dart';
import 'product_view_details.dart';

class ProductList extends StatefulWidget {
  @override
  _ProductListState createState() => _ProductListState();
}

class _ProductListState extends State<ProductList> {
  TextEditingController _searchTextController = TextEditingController();
  String uid;
  Future _data;

  Future getCat() async {
    uid = await Auth.getUID();
    var firestore = Firestore.instance;

    QuerySnapshot qn =
        await firestore.collection('users/' + uid + '/products').getDocuments();
    return qn.documents;
  }

  @override
  void initState() {
    super.initState();

    _data = getCat();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        //  appBar: AppBar(

        //     title:  Material(
        //       borderRadius: BorderRadius.circular(10.0),
        //       color: Colors.black.withOpacity(0.2),
        //       elevation: 0.0,
        //       child:  TextFormField(
        //         controller: _searchTextController,
        //         decoration: InputDecoration(
        //           hintText: "  Search...",

        //           border: InputBorder.none,
        //         ),
        //         validator: (value) {
        //           if (value.isEmpty) {
        //              return "The search field cannot be empty";
        //           }
        //           return null;
        //         },
        //       ),
        //     ),
        //     actions: <Widget>[
        //       new IconButton(icon: Icon(Icons.search,color: Colors.black),onPressed: (){},),
        //     ],
        //   ),
        body: FutureBuilder(
            future: _data,
            builder: (_, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else {
                return ListView.builder(
                    itemCount: snapshot.data.length,
                    shrinkWrap: true,
                    itemBuilder: (_, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10.0, vertical: 10.0),
                        child: InkWell(
                            onTap: () =>
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => new ProductViewDetail(
                                          //passing the values of product grid view to product view details
                                          product_detail_id:
                                              snapshot.data[index].data['id'],
                                          product_detail_name:
                                              snapshot.data[index].data['name'],
                                          product_detail_price: snapshot
                                              .data[index].data['price'],
                                          product_detail_picture: snapshot
                                              .data[index].data['picture'],
                                          product_detail_quantity: snapshot
                                              .data[index].data['quantity'],
                                          product_detail_date:
                                              snapshot.data[index].data['date'],
                                          product_detail_category: snapshot
                                              .data[index].data['category'],
                                          product_detail_threshold: snapshot
                                              .data[index].data['threshold'],
                                        ))),
                            child: Container(
                              height: 150.0,
                              child: GridTile(
                                child: Container(
                                  padding: EdgeInsets.all(10.0),
                                  color: Colors.orange[50],
                                  //child: Image.asset('images/c3.jpg'),
                                  child: Image.network(
                                      snapshot.data[index].data['picture']),
                                ),
                                footer: Container(
                                    color: Colors.orange[50],
                                    child: ListTile(
                                      title: Text(
                                          snapshot.data[index].data['name'],
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold)),
                                      trailing: Text(
                                        ((snapshot.data[index]
                                                    .data['refillNeeded'] ==
                                                true)
                                            ? 'Refill needed! '
                                            : '') +
                                                snapshot.data[index]
                                                    .data['quantity']
                                                    .toString() +
                                                ' units left',
                                        style: TextStyle(
                                          color: Colors.red,
                                          fontWeight: FontWeight.w800,
                                        ),
                                      ),
                                    )),
                              ),
                            )),
                      );
                    });
              }
            }));
  }
}
