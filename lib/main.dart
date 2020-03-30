import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gastoscontrol/widgets/graph_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
 
void main() => runApp(MyApp());
 
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Material App',
      theme: ThemeData(
        primaryColor: Colors.blue,
      ),
      home:HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {

  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  PageController _controlador;
  int currentPage = 9;

@override
  void initState() {
    super.initState();

    Firestore.instance
    .collection('expenses')
    .where("moth", isEqualTo: currentPage + 1)
    .snapshots()
    .listen((data) =>
        data.documents.forEach((doc) => print(doc["expenses"])));

    _controlador = PageController(
      initialPage: currentPage,
      viewportFraction: 0.45,
      
    );
  }

  @override
  Widget build(BuildContext context) {

   Widget _bottomAction (IconData icon) {
    return InkWell(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Icon(icon),
      ),
      onTap: (){},
    );
   }

    return Scaffold(
       bottomNavigationBar: BottomAppBar(
         notchMargin: 8.0,
         shape: CircularNotchedRectangle(),
         child: Row(
           mainAxisSize: MainAxisSize.max,
           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
           children: <Widget>[
            _bottomAction(FontAwesomeIcons.history),
            _bottomAction(FontAwesomeIcons.chartPie),
            SizedBox(width: 32,),
            _bottomAction(FontAwesomeIcons.wallet),
            _bottomAction(Icons.settings),
           ],
         ),
       ),
       floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
       floatingActionButton: FloatingActionButton(
         child: Icon(Icons.add),
         onPressed: (){},
       ),
      body: _body(),
    );
  }
  Widget _body(){
return SafeArea(
           child: Column(
             children: <Widget>[
               _selector(),
               _expenses(),
               _graph(),
               Container( color: Colors.lightBlueAccent.withOpacity(0.15), height: 24.0, ),
               _list(),
             ],
           ),
         );
       }
 Widget _pageItem (String nombre, int position){
   final selected = TextStyle(
     fontSize: 20,
     fontWeight: FontWeight.bold,
     color: Colors.blueGrey,
   );
   final unSelected = TextStyle(
     fontSize: 20,
     fontWeight: FontWeight.normal,
     color: Colors.blueGrey.withOpacity(0.4),
   );

   return Container(
     padding: EdgeInsets.all(20.0),
     child: Text(nombre,
     textAlign: TextAlign.center,
     style: position == currentPage ? selected : unSelected,
   ),
   );
 }
 

 Widget _selector (){
   return SizedBox.fromSize(
       size: Size.fromHeight(70.0),
      child: PageView(
        // pageSnapping: false,
        controller: _controlador,
        onPageChanged: (newPage){
          setState(() {
            currentPage = newPage;
          });
        },
        children: <Widget>[
_pageItem("Enero",0),
_pageItem("Febrero",1),
_pageItem("Marzo",2),
_pageItem("Abril",3),
_pageItem("Mayo",4),
_pageItem("Junio",5),
_pageItem("Julio",6),
_pageItem("Agosto",7),
_pageItem("Septiembre",8),
_pageItem("Octubre",9),
_pageItem("Noviembre",10),
_pageItem("Diciembre",11), 
       ],
     ),
   );
 }

 Widget _expenses (){
   return Column(
     children: <Widget>[
       Text('\$2361,41',
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
   child: GraphWidget()
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