import 'dart:convert';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
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
  bool isLoading = true;
  List<RecipeModel> recipeList = <RecipeModel>[];
  List recipeCatList = [{
    "imgUrl":"https://i.imgur.com/dZzXWFQ.jpeg","heading":"Spicy"
  },
    {
      "imgUrl":"https://i.imgur.com/CUG0Aof.jpeg","heading":"Chinese"
    },
    {
      "imgUrl":"https://i.imgur.com/Vc00NPQ.png","heading":"Sweets"
    },
    {
      "imgUrl":"https://i.imgur.com/XoEzX0V.jpeg","heading":"Non-Veg"
    },
    {
      "imgUrl":"https://i.imgur.com/hxfIrTG.jpeg","heading":"Veg"
    },
    ];
  TextEditingController searchcontroller = new TextEditingController();

  getRecipe(String query) async {
    String url =
        "https://api.edamam.com/search?q=$query&app_id=eb6b4f9b&app_key=3df5dff34252d03384ba1322c66773b9&from=0&to=3&calories=591-722&health=alcohol-free";
    http.Response response = await http.get(Uri.parse(url));
    Map data = jsonDecode(response.body);
    log(data.toString());
    print(response.body);
    data["hits"].forEach((element) {
      RecipeModel recipeModel = new RecipeModel();
      recipeModel = RecipeModel.fromMap(element['recipe']);
      recipeList.add(recipeModel);
      setState(() {
        isLoading = false;
      });
      log(recipeList[0].appimgurl);
    });
    recipeList.forEach((Recipe) {
      print(Recipe.applabel);
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getRecipe("gulab jamun");
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
              // color: Colors.orange
            )),
        //Searchbar
        SingleChildScrollView(
          child: Column(
            children: [
              SafeArea(
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
                          // Container(
                          //   child: GestureDetector(onTap: (){
                          //     if((searchcontroller.text).replaceAll(" ", "")==""){
                          //       print("blank");
                          //     }
                          //     else{
                          //       getRecipe(searchcontroller.text);
                          //     }
                          //   },child: Icon(Icons.search)),
                          //   margin: EdgeInsets.fromLTRB(8, 0, 5, 0),
                          // ),
                          Expanded(
                              child: TextField(
                            controller: searchcontroller,
                            onChanged: (value) {
                              recipeList.clear();
                              setState(() {});
                              getRecipe(value);
                              setState(() {});
                            },
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              prefixIcon: Icon(Icons.search),
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
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                        alignment: Alignment.topLeft,
                        child: Text("WHAT DO YOU WANT",
                            style: GoogleFonts.poppins(
                                fontSize: 35,
                                fontWeight: FontWeight.bold,
                                color: Colors.white))),
                    Container(
                        alignment: Alignment.topLeft,
                        child: Text("TO COOK TODAY? ",
                            style: GoogleFonts.poppins(
                                fontSize: 35,
                                color: Colors.white,
                                fontWeight: FontWeight.bold))),
                  ],
                ),
              ),
              Container(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: isLoading? CircularProgressIndicator(): ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: recipeList.length,
                      itemBuilder: (context, index) {
                        print(recipeList[index].appimgurl);
                        return InkWell(
                          onTap: () {},
                          child: Card(
                            margin: EdgeInsets.all(20),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20)),
                            elevation: 0.0,
                            child: Stack(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(20),
                                  child: Image.network(
                                    recipeList[index].appimgurl,
                                    fit: BoxFit.cover,
                                    width: double.infinity,
                                    height: 200,
                                  ),
                                ),
                                Positioned(
                                    left: 0,
                                    bottom: 0,
                                    right: 0,
                                    child: Container(
                                        padding: EdgeInsets.symmetric(
                                            vertical: 10, horizontal: 10),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.only(
                                              bottomLeft: Radius.circular(20),
                                              bottomRight: Radius.circular(20)),
                                          color: Colors.black26,
                                        ),
                                        child: Text(
                                          recipeList[index].applabel,
                                          style: GoogleFonts.roboto(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18),
                                        ))),
                                Positioned(
                                    right: 0,


                                    child: Container(
                                      width: 100,
                                      height: 40,

                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.only(
                                          topRight: Radius.circular(20),
                                          bottomLeft: Radius.circular(20)
                                        )
                                      ),
                                      child: Center(
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                          children: [
                                            FaIcon(FontAwesomeIcons.fire,color: Colors.deepOrange,),
                                            Text(recipeList[index].appcolories.toString().substring(0,3)+" kcal",
                                                style: GoogleFonts.roboto(fontWeight: FontWeight.bold,
                                                fontSize: 12)
                                            ),
                                          ],
                                        ),
                                      ),
                                    ))
                                //Text in the
                              ],
                            ),
                          ),
                        );
                      })),
              //listcate
              Container(
                height: 150,
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: recipeCatList.length,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index){
                    return Container(
                      child: InkWell(
                        onTap: (){},
                        child: Card(
                          margin: EdgeInsets.all(20),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18)
                          ),
                          child: Stack(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(18.8),
                                child: Image.network(recipeCatList[index]["imgUrl"],
                                fit: BoxFit.cover,
                                  width: 200,

                                ),
                              ),
                              Positioned(
                                left: 0,
                                bottom: 0,
                                top: 70,
                                right: 0,
                                child: Container(
                                  height: 30,
                                  width: 200,
                                  padding: EdgeInsets.symmetric(vertical: 5,horizontal: 10),
                                  decoration: BoxDecoration(
                                    color: Colors.black26,
                                    borderRadius: BorderRadius.only(
                                      bottomLeft: Radius.circular(20),
                                      bottomRight: Radius.circular(20)

                                    )
                                  ),
                                  child: Center(
                                    child: Text(
                                      recipeCatList[index]["heading"],
                                      style: TextStyle(color: Colors.white,fontSize:20,fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                              )

                            ],
                          ),
                        ),
                      ),
                    );
                  }
                ),

              )
            ],
          ),
        ),
        //text
      ],
    ));
  }
}
