import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Map> _list = List();
  final _productController = TextEditingController();
  final _seachController = TextEditingController();
  bool _isSearching = false;

  Map<String, dynamic> _lastRemoved;
  int _lastRemovedPos;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        initialIndex: 1,
        child: Scaffold(
          body: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                colors: [
                  Colors.pink[400],
                  Colors.pink[300],
                  Colors.pink[200],
                ],
              ),
            ),
            child: Column(
              children: <Widget>[
                !_isSearching
                    ? Padding(
                        padding: EdgeInsets.only(top: 30, left: 30, bottom: 30),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: <Widget>[
                            Text(
                              "Lista de Compras",
                              style: TextStyle(
                                fontSize: 26,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            Icon(
                              Icons.add_shopping_cart,
                              color: Colors.white,
                            ),
                            IconButton(
                              icon: Icon(Icons.search),
                              color: Colors.white,
                              onPressed: () {
                                setState(() {
                                  _isSearching = !_isSearching;
                                });
                              },
                            )
                          ],
                        ),
                      )
                    : Padding(
                        padding: EdgeInsets.only(top: 30, left: 10, bottom: 30),
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              child: TextField(
                                controller: _seachController,
                                autofocus: true,
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: Colors.white,
                                  border: InputBorder.none,
                                  hintText: "Insira o nome da Lista",
                                  hintStyle: TextStyle(color: Colors.grey),
                                  prefixIcon:
                                      Icon(Icons.search, color: Colors.grey),
                                ),
                                style: TextStyle(fontSize: 18),
                              ),
                            ),
                            IconButton(
                              icon: Icon(Icons.cancel),
                              color: Colors.white,
                              onPressed: () {
                                setState(
                                  () {
                                    _isSearching = !_isSearching;
                                  },
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                TabBar(
                  isScrollable: true,
                  labelPadding: EdgeInsets.symmetric(horizontal: 50.0),
                  tabs: <Widget>[
                    Tab(
                      child: Text(
                        "Nova Lista",
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                    Tab(
                      child: Text(
                        "Listas",
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.only(top: 50, left: 20, right: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.rectangle,
                            borderRadius: BorderRadius.circular(32),
                            color: Colors.white,
                          ),
                          child: TextField(
                            controller: _productController,
                            decoration: InputDecoration(
                              hintText: "Insira um produto",
                              hintStyle: TextStyle(),
                              border: InputBorder.none,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.add_circle,
                          color: Colors.white,
                          size: 35,
                        ),
                        onPressed: () {
                          setState(() {
                            _addProduct();
                            _productController.text = "";
                          });
                        },
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: SizedBox(
                    height: 100,
                    child: Padding(
                      padding: EdgeInsets.only(top: 20, left: 60, right: 60),
                      child: ListView.builder(
                        itemBuilder: buildItem,
                        itemCount: _list.length,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
  }

  void _addProduct() {
    Map product = {};
    product["product"] = _productController.text;
    product["checked"] = false;
    _list.add(product);
  }

  Widget buildItem(context, index) {
    return Dismissible(
      key: Key(DateTime.now().millisecondsSinceEpoch.toString()),
      background: Container(
        color: Colors.transparent,
        child: Align(
          alignment: Alignment(-0.9, 0.0),
          child: Icon(Icons.delete, color: Colors.white),
        ),
      ),
      secondaryBackground: Container(
        color: Colors.transparent,
        child: Align(
          alignment: Alignment(0.9, 0.0),
          child: Icon(Icons.delete, color: Colors.white),
        ),
      ),
      onDismissed: (_) {
        setState(() {
          _lastRemoved = Map.from(_list[index]);
          _lastRemovedPos = index;
          _list.removeAt(index);

          final snack = SnackBar(
            content: Text("Produto \"${_lastRemoved['product']}\" removido!"),
            action: SnackBarAction(
              label: "Desfazer",
              textColor: Colors.pink,
              onPressed: () {
                setState(() {
                  _list.insert(_lastRemovedPos, _lastRemoved);
                });
              },
            ),
            duration: Duration(seconds: 2),
          );

          Scaffold.of(context).removeCurrentSnackBar();
          Scaffold.of(context).showSnackBar(snack);
        });
      },
      child: Theme(
        data: Theme.of(context).copyWith(
          unselectedWidgetColor: Colors.white,
        ),
        child: CheckboxListTile(
          checkColor: Colors.lightGreen,
          activeColor: Colors.white,
          dense: true,
          controlAffinity: ListTileControlAffinity.leading,
          value: _list[index]["checked"],
          onChanged: (_) {
            setState(() {
              _list[index]["checked"] = !_list[index]["checked"];
            });
          },
          title: Container(
            width: 100,
            child: Text(
              _list[index]["product"],
              style: TextStyle(fontSize: 20, color: Colors.white),
            ),
          ),
          subtitle: TextField(
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: "Preço",
              labelStyle: TextStyle(
                color: Colors.white,
              ),
              border: InputBorder.none,
            ),
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
