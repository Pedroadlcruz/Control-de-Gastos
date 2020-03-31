import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gastoscontrol/widgets/graph_widget.dart';

class MonthWidget extends StatefulWidget {
  final List<DocumentSnapshot> documents;
  final double total;
  final List<double> perDay;

 MonthWidget({Key key, this.documents}) : 
total = documents.map((doc)=> doc['value']).fold(0.0, (a, b) => a + b),
perDay = List.generate(30, (int index){
  return documents.where((doc) => doc['day'] == (index + 1)).map((doc)=> doc['value'])
  .fold(0.0, (a, b) => a + b);
}),
super (key : key);

  @override
  _MonthWidgetState createState() => _MonthWidgetState();
}

class _MonthWidgetState extends State<MonthWidget> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
          child: Column(
        children: <Widget>[
                _expenses(),
                 _graph(),
                 Container( color: Colors.lightBlueAccent.withOpacity(0.15), height: 24.0, ),
                 _list(),
        ],
      ),
    );
  }
  Widget _expenses (){
   return Column(
     children: <Widget>[
       Text('\$${widget.total.toStringAsFixed(2)}',
       style: TextStyle(
         fontWeight: FontWeight.bold,
         fontSize: 40.0,
       ),
       ),
       Text('Total expenses',
         style: TextStyle(
         fontWeight: FontWeight.bold,
         fontSize: 16.0,
         color: Colors.blueGrey,
       ),
       ),
     ],
   );
   } 

 Widget _graph (){
 return Container(
   height: 250.0,
   child: GraphWidget(
     data: widget.perDay,
     ),
   );
 }

 Widget _list (){
   return Expanded(
        child: ListView.separated(
          itemCount: 15,
          itemBuilder: (BuildContext context, int index) =>_item(FontAwesomeIcons.shoppingCart, "Shopping", 14, 145.12),
          separatorBuilder: (BuildContext context, int index){
            return Container(
              color: Colors.lightBlueAccent.withOpacity(0.15),
              height: 8.0,
            );
          },
      
            ),
   );
        }
       
 Widget _item(IconData icon, String nombre, int percent, double value) {
 return ListTile(
   leading: Icon(icon, size: 32.0,),
   title: Text(nombre,
   style: TextStyle(
     fontWeight: FontWeight.bold,
     fontSize: 20.0,
   ),
   ),
   subtitle: Text("$percent% of expenses",
   style: TextStyle(
     fontSize: 16.0,
     color: Colors.blueGrey,
   ),
   ),
   trailing: Container(
     decoration: BoxDecoration(
       color: Colors.blueAccent.withOpacity(0.2),
       borderRadius: BorderRadius.circular(5.0),
     ),
     child: Padding(
       padding: const EdgeInsets.all(8.0),
       child: Text("\$$value",
       style: TextStyle(
         color: Colors.lightBlue,
         fontWeight: FontWeight.w500,
         fontSize: 16.0
       ),
       ),
     ),
   ),
   onTap: (){},
 );
}
}