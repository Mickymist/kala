class RecipeModel{
  late String applabel;
  late String appimgurl;
  late double appcolories;
  late String url;
  RecipeModel({this.applabel = "LABEL",this.appimgurl="image",this.appcolories=8.0,this.url="sd"});
  factory RecipeModel.fromMap(Map recipe){
    return RecipeModel(
      applabel: recipe["label"],
      appcolories: recipe["calories"],
      appimgurl: recipe["image"],
      url: recipe["url"]
    );
  }
}