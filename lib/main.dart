
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gastoscontrol/widgets/month_wiget.dart';
 
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
  Stream<QuerySnapshot> _query;

@override
  void initState() {
    super.initState();
   
    
    // .listen((data) =>
    // data.documents.forEach((doc) => print(doc['category'])));


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
               StreamBuilder<QuerySnapshot>(
                 stream: _query,
                 builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> data) {
                   if (data.hasData){
                     return MonthWidget(
                       documents: data.data.documents,
                       );
                     }
                     return Center(
                       child: CircularProgressIndicator(),
                     );
                 },
               ),
               
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
            _query = Firestore.instance
            .collection('expenses')
            .where("month", isEqualTo: currentPage + 1)
            .snapshots();
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

 
}