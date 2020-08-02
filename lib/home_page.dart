import 'dart:convert';
import 'package:flutter/material.dart';
//import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:lista_de_compras/functionsJson/functions.dart';
import 'package:lista_de_compras/widgets/emptyList.dart';
import 'package:flutter/services.dart';
import 'package:lista_de_compras/widgets/productName.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  //final _productController = TextEditingController();
  //MoneyMaskedTextController _priceController = MoneyMaskedTextController();
  List _shoppingCart = List();
  //GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();

    changeStatusBar();

    readData().then((data) {
      setState(() {
        _shoppingCart = json.decode(data);
      });
    });
  }

  void changeStatusBar() {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light.copyWith(
      statusBarColor: Colors.transparent,
      systemNavigationBarColor: Colors.pink[300],
    ));
  }

  // void _addProduct() {
  //   Map<String, dynamic> product = {};
  //   product["product"] = _productController.text;
  //   product["checked"] = false;
  //   _shoppingCart.add(product);
  //   saveData(_shoppingCart);
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.pink[600],
        elevation: 0,
        title: Text(
          "Lista de Compras",
          style: TextStyle(
            fontSize: 23,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.remove_shopping_cart,
              color: Colors.white,
            ),
            onPressed: _shoppingCart.isEmpty
                ? null
                : () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Center(
                            child: Text(
                              "Compra realizada!",
                              style: TextStyle(
                                color: Colors.pink[400],
                              ),
                            ),
                          ),
                          content: Text(
                              "Tem certeza que deseja limpar a Lista de Compras?"),
                          actions: <Widget>[
                            FlatButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text("Cancelar"),
                            ),
                            FlatButton(
                              onPressed: () {
                                setState(() {
                                  _shoppingCart.clear();
                                  saveData(_shoppingCart);
                                });
                                Navigator.pop(context);
                              },
                              child: Text("Sim"),
                            )
                          ],
                        );
                      },
                    );
                    _focusNode.unfocus();
                  },
          )
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.pink[600],
              Colors.pink[500],
              Colors.pink[300],
            ],
          ),
        ),
        child: _shoppingCart.isEmpty
            ? EmptyList()
            : Column(
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 30),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(32),
                      color: Colors.pink[300],
                    ),
                    child: FlatButton(
                      child: Text(
                        "Adicionar Produto",
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      onPressed: () {},
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      padding:
                          EdgeInsets.only(bottom: 100, left: 20, right: 20),
                      itemBuilder: buildItem,
                      itemCount: _shoppingCart.length,
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  Widget buildItem(context, int index) {
    return Theme(
      data: Theme.of(context).copyWith(
        unselectedWidgetColor: Colors.white,
      ),
      child: CheckboxListTile(
        activeColor: Colors.lightGreen,
        checkColor: Colors.white,
        dense: true,
        controlAffinity: ListTileControlAffinity.leading,
        value: _shoppingCart[index]["checked"],
        onChanged: (_) {
          setState(() {
            _shoppingCart[index]["checked"] = !_shoppingCart[index]["checked"];
            saveData(_shoppingCart);
          });
        },
        title: SizedBox(
            width: 80,
            child: ProductName(product: _shoppingCart[index]["product"])),
        subtitle: Text(
          "R\$ 0.00",
          style: TextStyle(
            color: Colors.white70,
            fontSize: 16,
          ),
        ),
        secondary: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.edit),
              color: Colors.white,
              onPressed: () {},
            ),
            IconButton(
              icon: Icon(Icons.remove_circle_outline),
              color: Colors.white,
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: Center(
                        child: Text(
                          "Remover Produto!",
                          style: TextStyle(
                            color: Colors.pink[400],
                          ),
                        ),
                      ),
                      content: Text(
                        "Tem certeza que deseja remover o produto \"${_shoppingCart[index]["product"]}\"?",
                      ),
                      actions: <Widget>[
                        FlatButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text("Cancelar"),
                        ),
                        FlatButton(
                          onPressed: () {
                            setState(() {
                              _shoppingCart.removeAt(index);
                              saveData(_shoppingCart);
                            });
                            Navigator.pop(context);
                          },
                          child: Text("Sim"),
                        )
                      ],
                    );
                  },
                );
                _focusNode.unfocus();
              },
            ),
          ],
        ),
      ),
    );
  }
}
