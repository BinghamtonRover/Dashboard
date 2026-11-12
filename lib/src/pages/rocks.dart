import "package:flutter/material.dart";
import "package:rover_dashboard/widgets.dart";

/// A view model to control which rocks are shown on screen.
class RockModel with ChangeNotifier {
  /// All rocks that can be shown.
  final rocks = <Rock>[
    const Rock(
      "Shale",
      "assets/Rocks_Minerals_Images/Shale2026.jpg",
      "   \u2022 Very fine-grained"
      "\n   \u2022 Smooth, dusty appearance"
      "\n   \u2022 Often forms flat flakes"  
      "\n   \u2022 Dark gray, green, or dark red color"
      "\n Martian Relevance:"
      "\n   \u2022 Preserves organic molecules well "
      "\n   \u2022 Target for biosignatures ",
    ),
    const Rock(
      "Mudstone",
      "assets/Rocks_Minerals_Images/mudstone1.jpg",
      "Clastic fine-grained, generally soft, variable color, clay silt",
    ),
     const Rock(
      "Limestone",
      "assets/Rocks_Minerals_Images/Limestone2026.jpg",
      "   \u2022 Very fine to medium grain "
      "\n   \u2022 Forms blocky outcrops "
      "\n   \u2022 Smoother/less gritty than sandstone "
      "\n   \u2022 Sharper edges"
      "\n   \u2022 Light gray, cream, or tan color"

      "\n Martian Relevance:"
      "\n   \u2022 Carbonates are rare on Mars "
      "\n   \u2022 prove an ancient atmosphere rich in CO2 & neutral-pH water "

    ),
    const Rock(
      "Dolomites / Dolostones",
      "assets/Rocks_Minerals_Images/Dolomite1.jpg",
      "Carbonate sedimentary rock",

    ),
    const Rock(
      "Conglomerates",
      "assets/Rocks_Minerals_Images/Conglomerate2026.jpg",
      "   \u2022 natural concrete "
      "\n   \u2022 Smooth, rounded pebbles in a finer sandy matrix" 
      "\n   \u2022 Poorly sorted "

      "\n Martian Relevance:"
      "\n   \u2022 Discovered by Curiosity in Gale Crater "
      "\n   \u2022 proving vigorous ancient stream flows on Mars",
    ),
   const Rock(
      "Basalt",
      "assets/Rocks_Minerals_Images/Basalt2026.jpg",
      "   \u2022 Fine-grained, dull surface"
      "\n   \u2022 Sometimes feature small holes "
      "\n   \u2022 Vesicular texture for gas bubbles"
      "\n   \u2022 Dark gray to black color"
      "\n Martian Relevance:"
      "\n   \u2022 majority of the Martian crust",

    ),
     const Rock(
      "Sandstone",
      "assets/Rocks_Minerals_Images/Sandstone2026.jpg",
      "   \u2022 Gritty rounded, sand-paper texture "
      "\n   \u2022 Visible grains+ layered "
      "\n   \u2022 Crumbly edges "
      "\n   \u2022 Tan, red or light orange color "
      "\n Martian Relevance: "
      "\n   \u2022 Found widely on Mars (Gale Crater by Curiosity)"
      "\n   \u2022 History of moving water or wind dunes",

    ),
    const Rock(
      "Phyllosilicates",
      "assets/Rocks_Minerals_Images/Phyllosilicates.jpg",
      "Clay \n   \u2022 Layers of tetrahedral and octahedral sheets",
    ),
    const Rock(
      "Carbonates",
      "assets/Rocks_Minerals_Images/Carbonate.jpg",
      "Precipitate from water \n   \u2022 Fizzles when hydrochloric acid is placed on it",
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
      "assets/Rocks_Minerals_Images/Augite.jpg",
      "Found on meteors \n   \u2022 Greenish white streak",
    ),
    const Rock(
      "Gypsum / Alablaster",
      "assets/Rocks_Minerals_Images/Gypsum-Alablaster2026.jpg",
      "   \u2022Look scratched or fibrous "
      "\n   \u2022 Captures light differently (satiny luster)"
      "\n   \u2022 Crystalline cleavage" 
      "\n   \u2022 Milky white, pink or clear color"
      "\n Martian Relevance:"
      "\n   \u2022 highly common on Mars"
      "\n   \u2022 planet's transition from wet to dry ",
    ),
        
    const Rock(
      "Chert / Flint",
      "assets/Rocks_Minerals_Images/Chert-Flint2026.jpg",
      "   \u2022 Extremely smooth, glass-like texture "
      "\n   \u2022 Sharp, jagged edges where broken "
      "\n   \u2022 Glints strongly in the sun "
      "\n   \u2022 Red (Jasper), white, or gray color "
      "\n Martian Relevance:"
      "\n   \u2022 silica is incredible at preserving microscopic fossils ",

    ),
    const Rock(
      "Pumice / Scoria",
      "assets/Rocks_Minerals_Images/Pumice-Scoria2026.jpg",
      "   \u2022 Spongy, highly porous "
      "\n   \u2022 Very rough and lightweight "
      "\n   \u2022 Highly vesicular + surface roughness "
      "\n   \u2022 Pumice is light gray/tan color "
      "\n   \u2022 Scoria is dark red/black color "
      "\n Martian Relevance:"
      "\n   \u2022 explosive volcanic history vs quiet effusive lava flows ",
    ),



  ];

  /// A filtered view of [rocks] that matches the [query].
  List<Rock> get filteredRocks => rocks.where(filter).toList();

  /// The current search query from the search bar.
  String get query => controller.text;

  /// Whether the given rock matches the current [query].
  bool filter(Rock rock) => rock.name.toLowerCase().contains(query)
    || rock.description.toLowerCase().contains(query);

  /// The Flutter controller for the search bar.
  SearchController controller = SearchController();

  /// Filters the [rocks] by the [query] and saves it to [filteredRocks].
  void search(String input) => notifyListeners();

  /// Clears the search query.
  void clear() {
    controller.clear();
    search("");
  }
}

/// Contains data and knowledge about a specific rock type.
class Rock {
  /// The name of the rock.
  final String name;

  /// The path to the image of the rock.
  final String image;

  /// A description of the rock.
  final String description;

  /// A const constructor.
  const Rock(this.name, this.image, this.description);
}

/// A page to show a searchable list of rocks and information about them.
class RocksPage extends ReactiveWidget<RockModel> {
  @override
  RockModel createModel() => RockModel();

  /// Index of the rock page for view widget
  final int index;

  /// A const constructor.
  const RocksPage({required this.index});

  @override
  Widget build(BuildContext context, RockModel model) => Column(
    children: [
      PageHeader(
        pageIndex: index,
        children: [
          Padding(
            padding: const EdgeInsets.all(4),
            child: Text(
              "Rocks & Minerals",
              style: context.textTheme.headlineMedium,
            ),
          ),
          const Spacer(),
        ],
      ),
      Expanded(
        child: ListView(
          shrinkWrap: true,
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          children: [
            SearchBar(
              hintText: "Search for a rock or characteristic",
              hintStyle: WidgetStatePropertyAll(context.textTheme.bodyMedium),
              controller: model.controller,
              onChanged: model.search,
              backgroundColor: WidgetStatePropertyAll(context.colorScheme.surfaceBright),
              trailing: [
                IconButton(onPressed: model.clear, icon: const Icon(Icons.clear)),
              ],
            ),
            const SizedBox(height: 12),
            for (final rock in model.filteredRocks)
              RockWidget(rock),
          ],
        ),
      ),
    ],
  );
}

/// A widget to show a row with details about a specific kind of rock.
class RockWidget extends StatelessWidget {
  /// The rock to show.
  final Rock rock;
  /// A const constructor.
  const RockWidget(this.rock);

  @override
  Widget build(BuildContext context) => Container(
    decoration: BoxDecoration(
      border: Border.all(
        color: context.colorScheme.onSurface,
      ),
    ),
    child: Row(
      children: <Widget>[
        Expanded(
          child: Text(rock.name, textAlign: TextAlign.center,),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Image.asset(rock.image),
          ),
        ),
        Expanded(
          flex: 3,
          child: Text(rock.description),
        ),
      ],
    ),
  );
}
