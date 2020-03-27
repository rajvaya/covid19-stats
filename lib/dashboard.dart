import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class DashBoard extends StatefulWidget {
  @override
  _DashBoardState createState() => _DashBoardState();
}

class _DashBoardState extends State<DashBoard> {
  String url =
      "https://wuhan-coronavirus-api.laeyoung.endpoint.ainize.ai/jhu-edu/latest";
  String urlmain =
      "https://wuhan-coronavirus-api.laeyoung.endpoint.ainize.ai/jhu-edu/brief";

  Dio _dio = Dio();
  bool isLoading = true;
  List _list = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getdata();
    controller.addListener(() {
      setState(() {
        filter = controller.text;
      });
    });
  }

  TextEditingController controller = new TextEditingController();
  String filter;
  var maindata;
  getdata() async {
    try {
      Response responsemain = await _dio.get(urlmain);
      Response response = await _dio.get(url);
      print(response.statusCode);
      print(responsemain.data.toString());
      maindata = responsemain.data;
      var l = jsonDecode(response.data);
      print(l.runtimeType);
      setState(() {
        _list = l;
        isLoading = false;
      });
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
  TextStyle title = TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.w500
  );
  TextStyle sub = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w500
  );


  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Scaffold(
            body: Center(
                child: Container(
            child: Text("LOADING..."),
          )))
        : Scaffold(
            appBar: AppBar(
              elevation: 0,
              centerTitle: true,
              title: Text("COVID-19 Dashboard",textAlign: TextAlign.center),
            ),
            body: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
//            Image.network("https://image.flaticon.com/icons/svg/2585/2585191.svg",height: 100,),
                  Text("Latest Global Stats",style: TextStyle(fontSize: 24),textAlign: TextAlign.center),
                 Row(
                   mainAxisSize: MainAxisSize.min,
                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                   children: <Widget>[
                     Expanded(
                       child: Container(
                         height: 50,
                         child: ListTile(
                           subtitle: Text(maindata["confirmed"].toString(),style: sub,textAlign: TextAlign.center),
                           title: Text("Confirmed",style: title,textAlign: TextAlign.center,),
                         ),
                       ),
                     ),
                     Expanded(
                       child: Container(
                         height: 50,
                         child: ListTile(
                             subtitle: Text(maindata["deaths"].toString(),style: sub,textAlign: TextAlign.center),
                             title: Text("Deaths",style: title,textAlign: TextAlign.center)),
                       ),
                     ),
                     Expanded(
                       child: Container(
                         height: 50,
                         child: ListTile(
                             subtitle: Text(maindata["recovered"].toString(),style: sub,textAlign: TextAlign.center),
                             title: Text("Recovered",style: title,textAlign: TextAlign.center)),
                       ),
                     ),
                   ],
                 ),
                  Padding(
                    padding: const EdgeInsets.only(top: 20,),
                    child: Text("Countrywise Global Stats",style: TextStyle(fontSize: 24),textAlign: TextAlign.center),
                  ),
                  TextField(
                    decoration:
                        new InputDecoration(labelText: "Search Country"),
                    controller: controller,
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: _list.length,
                      itemBuilder: (context, index) {
                        return filter == null || filter == ""
                            ? Container(
                              child: ListTile(
                                  title: Text(_list[index]["provincestate"]
                                          .toString() +
                                      "  " +
                                      _list[index]["countryregion"].toString(),style: title,),
                                  subtitle  : Text("Confirmed " +
                                      _list[index]["confirmed"].toString() +
                                      "  " +
                                      "Deaths " +
                                      _list[index]["deaths"].toString() +
                                      "  " +
                                      "Recovered " +
                                      _list[index]["recovered"].toString(),style: sub,),

                                ),
                            )
                            : _list[index]["countryregion"]
                                    .toLowerCase()
                                    .contains(filter.toLowerCase())
                                ? ListTile(
                                    title: Text(_list[index]["provincestate"]
                                            .toString() +
                                        " " +
                                        _list[index]["countryregion"]
                                            .toString(),style: title,),
                                    subtitle: Text("Confirmed " +
                                        _list[index]["confirmed"].toString() +
                                        "  " +
                                        "Deaths " +
                                        _list[index]["deaths"].toString() +
                                        "  " +
                                        "Recovered " +
                                        _list[index]["recovered"].toString(),style: sub,),
                                    isThreeLine: true,
                                  )
                                : new Container();
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top:8.0),
                    child: Text("Data source : Novel Coronavirus (COVID-19) Cases, provided by JHU CSSEC",style: TextStyle(fontSize: 14),textAlign: TextAlign.center),
                  ),

                ],
              ),
            ),
//      floatingActionButton: FloatingActionButton.extended(
//          onPressed: () async {
//            try {
//              Response response = await _dio.get(url);
//              print(response.statusCode);
//              print(response.data.toString());
//              var l = jsonDecode(response.data);
//              print(l.runtimeType);
//              setState(() {
//                _list = l;
//              });
//            } catch (e) {
//              print(e.toString());
//            }
//          },
//          label: Text("get data")),
          );
  }
}
