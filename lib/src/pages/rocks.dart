import "package:flutter/material.dart";
import "package:rover_dashboard/models.dart";
import "package:rover_dashboard/widgets.dart";
///Search Bar and Rock Database class
class RockModel with ChangeNotifier {
  ///Where all the rocks and minerals are located.
  final rocks = <Rock>[
    const Rock(
      "Shale",
      "assets/Rocks_Minerals_Images/Shale.jpg",
      "Has to be a carbonate-rich enviroment to cause dark coloring",
    ),
    const Rock(
      "Mudstone",
      "assets/Rocks_Minerals_Images/mudstone1.jpg",
      "Clastic fine-grained, generally soft, variable color, clay silt",
    ),
     const Rock(
      "Limestone",
      "assets/Rocks_Minerals_Images/Limestone.jpg",
      "Off white-gray, shallow marine enviroments, could contain fossils, chalky \n   \u2022 oolite, Chalk, Dense Limestone, Crystalline Limestone, Coquina, Micrite, Tavertine",
    ),
    const Rock(
      "Dolomites/Dolostones",
      "assets/Rocks_Minerals_Images/Dolomite1.jpg",
      "Carbonate sedimentary rock",
    ),
    const Rock(
      "Conglomerates",
      "assets/Rocks_Minerals_Images/Conglomerate.jpg",
      "Visible, rounded clasts within the matrix",
    ),
   const Rock(
      "Basalt",
      "assets/Rocks_Minerals_Images/Basalt.jpg",
      "Fine-grained, dark coloring, no visible crystals",
    ),
     const Rock(
      "Sandstone",
      "assets/Rocks_Minerals_Images/Sandstone.jpg",
      "Grainy appearance",
    ),
    const Rock(
      "Phyllosilicates",
      "assets/Rocks_Minerals_Images/Phyllosilicates.jpg",
      "Clay \n   \u2022 Layers of tetrahedral and octahedral sheets",
    ),
    const Rock(
      "Carbonates",
      "assets/Rocks_Minerals_Images/Carbonate.jpg",
      "Precipitate from water \n   \u2022 Fizzies when hydrochloric acid is placed on it",
    ),
    const Rock(
      "Hematite",
      "assets/Rocks_Minerals_Images/Hematite.jpg",
      "Precipitate from water \n   \u2022 Deep red or brownish red streak",
    ),   
    const Rock(
      "Olivine",
      "assets/Rocks_Minerals_Images/Olivine.jpg",
      "Weathers in the presence of water \n   \u2022 Green or pale green, lack of cleavage, in rocks it's usually rounded",
    ), 
     const Rock(
      "Pyroxene",
      "assets/Rocks_Minerals_Images/Pyroxene.jpg",
      "Weathers in the presence of water \n   \u2022 Has cleavage, dark green to black",
    ), 
       const Rock(
      "Pigeonite",
      "assets/Rocks_Minerals_Images/Pigeonite.jpg",
      "Found on meteors",
    ),
    const Rock(
      "Augite",
      "assets/Rocks_Minerals_Images/Pyroxene.jpg",
      "Found on meteors \n   \u2022 Greenish white streak",
    ),       
  ];
  ///Sets up filtered list of rocks and minerals from above
  List<Rock> get filteredRocks => rocks.where(filter).toList();
  ///Creates empty string for users Query
  String query = "";
  ///The filter for search bar
  bool filter(Rock rock) => rock.name.toLowerCase().contains(query) ||  rock.description.toLowerCase().contains(query);
  ///Controller for search bar
  SearchController controller = SearchController();
  ///search method that isolates a row if it matches the query
  void search(String input){
    query = input.toLowerCase();
    notifyListeners();
  }

}

///Rock Class and Constructor
class Rock{
  ///Rock Name
  final String name;
  ///Rock Image
  final String image;
  ///Rock description
  final String description;
  ///Rock constructor
  const Rock(this.name, this.image, this.description);
   
}

///Reactive Widget class
class RocksPage extends ReactiveWidget<RockModel> {
  @override
  RockModel createModel() => RockModel();
  ///Index of the rock page for view widget
  final int index;
  ///Sets up the view widget
  const RocksPage({required this.index});

  @override
  Widget build(BuildContext context, RockModel model) => ListView(
        shrinkWrap: true,
        ///Contains Search bar widgets and format for each row
        children: [
          Row(
            children: [
              Text("Rocks & Minerals",
                  style: context
                      .textTheme.headlineMedium,), /// The header at the top
              const Spacer(),
              ViewsSelector(index: index),
            ],
          ),
          SearchBar(
            controller: model.controller,
            onChanged: model.search,
          ),
          ...model.filteredRocks.map((rock) => /// Method to create new rows for each Rock
          Row(
            children: <Widget>[
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                        color: const Color.fromARGB(255, 212, 218, 228),),
                  ),
                  padding: const EdgeInsets.all(40),
                  child: Text(rock.name),
                ),
              ),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                        color: const Color.fromARGB(255, 212, 218, 228),),
                    image:  DecorationImage(
                      image: AssetImage(rock.image),
                      fit: BoxFit.cover,
                    ),
                  ),
                  padding: const EdgeInsets.all(50),
                ),
              ),
              Expanded(
                flex: 3,
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                        color: const Color.fromARGB(255, 212, 218, 228),),
                  ),
                  padding: const EdgeInsets.all(40),
                  child: Text(rock.description),
                ),
              ),
            ],
          ),          ),
          
        ],
      );
}
