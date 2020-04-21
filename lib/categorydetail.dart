import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pantryio/Pages/auth.dart';
import 'product_view_details.dart';

class NextPage extends StatefulWidget {
  final String value;

  NextPage({Key key, this.value}) : super(key: key);
  @override
  _NextPageState createState() => _NextPageState();
}

class _NextPageState extends State<NextPage> {
  Future _data;
  String uid;
  Future getCat() async {
    uid = await Auth.getUID();
    var firestore = Firestore.instance;

    QuerySnapshot qn = await firestore
        .collection('users/' + uid + '/products')
        .where('category', isEqualTo: "${widget.value}")
        .getDocuments();
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
        appBar: AppBar(
            title:
                Text("${widget.value}", style: TextStyle(color: Colors.black)),
            backgroundColor: Colors.white,
            leading: IconButton(
              icon: Icon(Icons.close, color: Colors.black),
              onPressed: () {
                Navigator.pop(context);
              },
            )
            //  onPressed: Navigator.pop(),
            ),
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
                                          product_detail_refill: snapshot
                                              .data[index].data['refillNeeded'],
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
                                        snapshot.data[index].data['quantity']
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
