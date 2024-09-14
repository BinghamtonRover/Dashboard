import "package:flutter/material.dart";
import "package:rover_dashboard/models.dart";
import "package:rover_dashboard/widgets.dart";

class RockModel with ChangeNotifier {
  
  final rocks = <Rock>[
    const Rock(
      "Shale",
      "assets/Rocks & Minerals/Shale.jpg",
      "Has to be a carbonate-rich enviroment to cause dark coloring",
    ),
    const Rock(
      "Mudstone",
      "assets/Rocks & Minerals/mudstone1.jpg",
      "Clastic fine-grained, generally soft, variable color, clay silt",
    ),
     const Rock(
      "Limestone",
      "assets/Rocks & Minerals/Limestone.jpg",
      "Off white-gray, shallow marine enviroments, could contain fossils, chalky \n   \u2022 oolite, Chalk, Dense Limestone, Crystalline Limestone, Coquina, Micrite, Tavertine",
    ),
    const Rock(
      "Dolomites/Dolostones",
      "assets/Rocks & Minerals/Dolomite1.jpg",
      "Carbonate sedimentary rock",
    ),
    const Rock(
      "Conglomerates",
      "assets/Rocks & Minerals/Conglomerate.jpg",
      "Visible, rounded clasts within the matrix",
    ),
   const Rock(
      "Basalt",
      "assets/Rocks & Minerals/Basalt.jpg",
      "Fine-grained, dark coloring, no visible crystals",
    ),
     const Rock(
      "Sandstone",
      "assets/Rocks & Minerals/Sandstone.jpg",
      "Grainy appearance",
    ),
    const Rock(
      "Phyllosilicates",
      "assets/Rocks & Minerals/Phyllosilicates.jpg",
      "Clay \n   \u2022 Layers of tetrahedral and octahedral sheets",
    ),
    const Rock(
      "Carbonates",
      "assets/Rocks & Minerals/Carbonate.jpg",
      "Precipitate from water \n   \u2022 Fizzies when hydrochloric acid is placed on it",
    ),
    const Rock(
      "Hematite",
      "assets/Rocks & Minerals/Hematite.jpg",
      "Precipitate from water \n   \u2022 Deep red or brownish red streak",
    ),   
    const Rock(
      "Olivine",
      "assets/Rocks & Minerals/Olivine.jpg",
      "Weathers in the presence of water \n   \u2022 Green or pale green, lack of cleavage, in rocks it's usually rounded",
    ), 
     const Rock(
      "Pyroxene",
      "assets/Rocks & Minerals/Pyroxene.jpg",
      "Weathers in the presence of water \n   \u2022 Has cleavage, dark green to black",
    ), 
       const Rock(
      "Pigeonite",
      "assets/Rocks & Minerals/Pigeonite.jpg",
      "Found on meteors",
    ),
    const Rock(
      "Augite",
      "assets/Rocks & Minerals/Pyroxene.jpg",
      "Found on meteors \n   \u2022 Greenish white streak",
    ),       
  ];
  List<Rock> get filteredRocks => rocks.where(filter).toList();
  String query = "";

  bool filter(Rock rock) => rock.name.toLowerCase().contains(query) ||  rock.description.toLowerCase().contains(query);

  SearchController controller = SearchController();

  void search(String input){
    query = input.toLowerCase();
    notifyListeners();
  }

}


class Rock{
  final String name;
  final String image;
  final String description;

  const Rock(this.name, this.image, this.description);
   
}


class RocksPage extends ReactiveWidget<RockModel> {
  RockModel createModel() => RockModel();
  final int index;
  const RocksPage({required this.index});

  @override
  Widget build(BuildContext context, RockModel model) => ListView(
        shrinkWrap: true,
        children: [
          Row(
            children: [
              Text("Rocks & Minerals",
                  style: context
                      .textTheme.headlineMedium,), // The header at the top
              const Spacer(),
              ViewsSelector(index: index),
            ],
          ),
          SearchBar(
            controller: model.controller,
            onChanged: model.search,
          ),
          ...model.filteredRocks.map((rock) =>
          Row(
            children: <Widget>[
              Container(
                decoration: BoxDecoration(
                  border: Border.all(
                      color: const Color.fromARGB(255, 212, 218, 228),),
                ),
                padding: const EdgeInsets.all(40),
                child: Text(rock.name),
              ),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(
                      color: const Color.fromARGB(255, 212, 218, 228)),
                  image:  DecorationImage(
                    image: AssetImage(rock.image),
                    fit: BoxFit.cover,
                  ),
                ),
                padding: const EdgeInsets.all(50),
              ),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(
                      color: const Color.fromARGB(255, 212, 218, 228)),
                ),
                padding: const EdgeInsets.all(40),
                child: Text(rock.description),
              ),
            ],
          ),          )
          
        ],
      );
}


