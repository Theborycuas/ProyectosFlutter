import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AlitasKfc extends StatelessWidget {
  final double height;
  final double width;
  final bool isLargeImg;

  const AlitasKfc(
      {Key key, this.width, this.height, this.isLargeImg = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      child: Column(
        children: <Widget>[
          SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(
                "Alitas de KFC",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 10),
                child: Icon(
                  Icons.arrow_forward,
                  size: 28,
                ),
              ),
            ],
          ),
          SizedBox(height: 15),
          Expanded(
            child: LayoutBuilder(
              builder: (BuildContext c, BoxConstraints constr) {
                return new StreamBuilder<QuerySnapshot>(
                  stream: Firestore.instance.collection('ciudad').document("ORYrQioVN7Pny0KZ6Mg7").collection('proveedor').document("27xbICfN52yat7hdcokl").collection('categoria').document("oXFXAEsAXyNHQx71rOmR").collection('producto').snapshots(),      
                  builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                    
                      if (!snapshot.hasData || snapshot.data == null) {
                        //print(logger);
                        return Center(
                          child: Column(
                            children: <Widget>[
                              SizedBox(height: 285.0,),
                              Text('Cargando CATEGORIAS...'),
                              SizedBox(height: 15.0,),
                              CupertinoActivityIndicator(            
                                    ),
                            ],
                          ),
                            
                        );
                      }
                      return Container(
                      width: constr.maxWidth,
                      height: constr.maxHeight,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount:  snapshot.data.documents.length,
                        itemBuilder: (context, index){
                        final catGenDoc = snapshot.data.documents[index];
                            return Padding(
                              padding: const EdgeInsets.only(right: 15),
                              child: Container(
                                width: isLargeImg
                                    ? constr.maxWidth * .8
                                    : constr.maxWidth * .6,
                                height: constr.maxHeight,
                                color: Colors.white,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: <Widget>[
                                    Container(
                                      height: constr.maxHeight * .65,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(5),
                                        image: DecorationImage(
                                          fit: BoxFit.cover,
                                          image: NetworkImage("${catGenDoc.data["imagen_pro"]}"),
                                          colorFilter: ColorFilter.mode(
                                            Colors.black.withOpacity(0.2),
                                            BlendMode.hardLight,
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 10),
                                    Text(
                                      "${catGenDoc.data["nombre_pro"]}",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                      ),
                                    ),
                                    Text(
                                      "${catGenDoc.data["nombre_pro"]}",
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.grey,
                                      ),
                                    ),
                                    Row(
                                      children: <Widget>[
                                        Text(
                                          "\$${catGenDoc.data["precio_pro"]}",
                                          style: TextStyle(
                                            color: Colors.grey,
                                            decoration: TextDecoration.lineThrough,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        SizedBox(width: 10),
                                        Text(
                                          "\$${catGenDoc.data["precio_pro"]}",
                                          style: TextStyle(
                                            color: Colors.red,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 19,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            );
                        }
                      ),
                    );
                  }
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
