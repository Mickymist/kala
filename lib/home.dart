import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:developer';

import 'package:recipewallah/model.dart';
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<RecipeModel> recipeList = <RecipeModel>[];
  TextEditingController searchcontroller = new TextEditingController();

  getRecipe (String query) async
  {
    String url = "https://api.edamam.com/search?q=$query&app_id=eb6b4f9b&app_key=3df5dff34252d03384ba1322c66773b9&from=0&to=3&calories=591-722&health=alcohol-free";
    http.Response response = await http.get(Uri.parse(url));
    Map data = jsonDecode(response.body);
    log(data.toString());
    print(response.body);
    data["hits"].forEach((element){
      RecipeModel recipeModel = new RecipeModel();
      recipeModel = RecipeModel.fromMap(element['recipe']);
      recipeList.add(recipeModel);
     log(recipeList.toString());
    });
    recipeList.forEach((Recipe) {
      print(Recipe.applabel);

    });
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getRecipe("Ladoo");
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          //background
          Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment(0.8, 1),
                colors: <Color>[
                  Color(0xff1f005c),
                  Color(0xff5b0060),
                  Color(0xff870160),
                  Color(0xffac255e),
                  Color(0xffca485c),
                  Color(0xffe16b5c),
                  Color(0xfff39060),
                  Color(0xffffb56b),
                ], // Gradient from https://learnui.design/tools/gradient-generator.html
                tileMode: TileMode.mirror,
              ),

            )
        ),
          //Searchbar
          SingleChildScrollView(
            child: Column(
              children: [SafeArea(
                child: Column(
                  children: [
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      //search container

                      padding: EdgeInsets.all(5),
                      margin: EdgeInsets.symmetric(horizontal: 24),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          color: Colors.white),

                      child: Row(
                        children: [
                          Container(
                            child: GestureDetector(onTap: (){
                              if((searchcontroller.text).replaceAll(" ", "")==""){
                                print("blank");
                              }
                              else{
                                getRecipe(searchcontroller.text);
                              }
                            },child: Icon(Icons.search)),
                            margin: EdgeInsets.fromLTRB(8, 0, 5, 0),
                          ),
                          Expanded(
                              child: TextField(
                                controller: searchcontroller,
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: "Let's cook something new!",
                                ),
                              ))
                        ],
                      ),
                    ),
                  ],
                ),
              ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      Container(
                          alignment: Alignment.topLeft,
                          child: Text("WHAT DO YOU WANT",style: GoogleFonts.poppins(fontSize: 35,fontWeight:FontWeight.bold,color: Colors.white))),
                      Container(
                          alignment: Alignment.topLeft,
                          child: Text("TO COOK TODAY? ",style: GoogleFonts.poppins(fontSize: 35,color: Colors.white,fontWeight: FontWeight.bold))),


                    ],
                  ),
                ),
                Container(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: ListView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: recipeList.length,
                        itemBuilder: (context,index){
                      return InkWell(
                        onTap: (){
                        },
                        child: Card(
                          child: Stack(
                            children: [
                              ClipRRect(
                                child: Image.network(recipeList[index].appimgurl),
                              ),


                            ],
                          ),
                        ),
                      );
                    })
                ),

              ],
            ),
          ),
          //text


        ],
      )
    );
  }
}
