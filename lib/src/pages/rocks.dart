import "package:flutter/material.dart";
import "package:rover_dashboard/widgets.dart";

/// A view model to control which rocks are shown on screen.
class RockModel with ChangeNotifier {
  /// All rocks that can be shown.
  final rocks = <Rock>[
    const Rock(
      "Shale",
      "assets/Rocks_Minerals_Images/Shale.jpg",
      "Has to be a carbonate-rich environment to cause dark coloring",
    ),
    const Rock(
      "Mudstone",
      "assets/Rocks_Minerals_Images/mudstone1.jpg",
      "Clastic fine-grained, generally soft, variable color, clay silt",
    ),
     const Rock(
      "Limestone",
      "assets/Rocks_Minerals_Images/Limestone.jpg",
      "Off white-gray, shallow marine environments, could contain fossils, chalky \n   \u2022 oolite, Chalk, Dense Limestone, Crystalline Limestone, Coquina, Micrite, Tavertine",
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
