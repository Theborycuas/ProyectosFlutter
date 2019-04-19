import 'package:bring2me/loginPage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:circle_wheel_scroll/circle_wheel_scroll_view.dart' as wheel;
import 'package:bring2me/ui/categoriasCircleScroll.dart';

class HomePageUsu extends StatefulWidget {
  @override
  _HomePageUsuState createState() => _HomePageUsuState();
}

class _HomePageUsuState extends State<HomePageUsu> {
  wheel.FixedExtentScrollController _controller;

  _listListener() {
    setState(() {});
  }

  @override
  void initState() {
    _controller = wheel.FixedExtentScrollController();
    _controller.addListener(_listListener);
    super.initState();
  }

  @override
  void dispose() {
    _controller.removeListener(_listListener);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    int i;
    return StreamBuilder(
          stream: Firestore.instance.collection('categoria').snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {

                return   Scaffold(
                  
                backgroundColor: Color(0xFF2F6FE0),
                appBar: AppBar(
                  title: Text("HOME"),
                  backgroundColor: Colors.black,
                ),
                body: wheel.CircleListScrollView.useDelegate(
                  onSelectedItemChanged:  (i) => i==1?print('uno'):print('2'),
                  childDelegate: wheel.CircleListChildBuilderDelegate(
                    builder: (context, index) {
                   //   categoriaDoc = snapshot.data.documents[index];

                      int currentIndex = 0;
                      DocumentSnapshot document;

                      try {
                        currentIndex = _controller.selectedItem;
                      } catch (_) {}
                      final resizeFactor =
                          (1 - (((currentIndex - index).abs() * 0.3).clamp(0.0, 1.0)));
                      return new  CircleListItem(
                            resizeFactor: resizeFactor,
                            categoriaDoc: snapshot.data.documents[index],
                            //character: characters[index],   
                          );
                    },
                    
                    childCount: snapshot.data.documents.length,
                  ),
                  physics: wheel.CircleFixedExtentScrollPhysics(),
                  controller: _controller,
                  axis: Axis.vertical,
                  itemExtent: 120,
                  radius: MediaQuery.of(context).size.width * 1.0,
                  
                ),
              );
          }
    );
  }
  
}

class CircleListItem extends StatelessWidget {
  final double resizeFactor;/* 
  final Character character; */
  const CircleListItem({Key key, this.resizeFactor, this.categoriaDoc})
      : super(key: key);
  final DocumentSnapshot categoriaDoc;
  @override
  Widget build(BuildContext context) {
    return  Center(
                  child: Row(mainAxisSize: MainAxisSize.min, children: [
                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Text(
                        categoriaDoc['nombre_cat'],
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22 * resizeFactor,
                        ),
                      ),
                    ),
                    Container(
                      width: 120 * resizeFactor,
                      height: 120 * resizeFactor,
                      
                      child: Align(
                        child: Container(
                          child: Image.network('${categoriaDoc['imagen_cat']}', width: 40),
                          decoration: BoxDecoration(
                            
                            borderRadius: BorderRadius.circular(60),
                            color: Colors.blue,
                          ),
                          height: 110 * resizeFactor,
                          width: 110 * resizeFactor,
                        ),
                      ),
                    ),
                  ]),
                );        
   
  }
}