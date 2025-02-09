import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rick_and_morty/core/usecases/shared_prefs_helper.dart';
import 'package:rick_and_morty/domain/entities/character_entity.dart';
import 'package:rick_and_morty/domain/entities/episode_entity.dart';
import 'package:rick_and_morty/domain/entities/location_entity.dart';
import 'package:rick_and_morty/presentation/bloc/cubits/characters/search_characters_cubit.dart';
import 'package:rick_and_morty/presentation/bloc/cubits/episodes/search_episode_cubit.dart';
import 'package:rick_and_morty/presentation/bloc/cubits/episodes/search_episode_state.dart';
import 'package:rick_and_morty/presentation/bloc/cubits/locations/search_locations_cubit.dart';
import 'package:rick_and_morty/presentation/pages/character/character_detail_page.dart';
import 'package:rick_and_morty/presentation/pages/character/character_list_page.dart';
import 'package:rick_and_morty/presentation/pages/episode/episode_detail_page.dart';
import 'package:rick_and_morty/presentation/pages/episode/episode_list_page.dart';
import 'package:rick_and_morty/presentation/pages/favorites_page.dart';
import 'package:rick_and_morty/presentation/pages/location/location_detail_page.dart';
import 'package:rick_and_morty/presentation/pages/location/location_list_page.dart';
import 'package:rick_and_morty/presentation/widgets/custom_card.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  final TextEditingController _searchController = TextEditingController();
  final SharedPrefsHelper _prefsHelper = SharedPrefsHelper();
  OverlayEntry? _overlayEntry;
  String _lastSearch = "";
  bool _isSearching = false;

  List<String> selectedStatus = [];
  List<String> selectedGender = [];
  List<String> selectedType = [];
  List<String> selectedDimension = [];

  final List<Widget> _pages = [
    const CharacterListPage(),
    const LocationListPage(),
    const EpisodeListPage(),
  ];

  @override
  void initState() {
    super.initState();
    _loadLastSearch();
  }

  Future<void> _loadLastSearch() async {
    final lastSearch = await _prefsHelper.getLastSearch();
    if (lastSearch != null) {
      setState(() {
        _lastSearch = lastSearch;
      });
    }
  }

  void _onPageChanged(int index) {
    setState(() {
      _selectedIndex = index;

      // Restablecer los filtros al cambiar de página
      if (_selectedIndex == 0) {
        // Personajes
        selectedStatus.clear();
        selectedGender.clear();
      } else if (_selectedIndex == 1) {
        // Ubicaciones
        selectedType.clear();
        selectedDimension.clear();
      }
    });
  }

  void _selectSearchResult(String query) {
    _prefsHelper.saveLastSearch(query);
    setState(() {
      _searchController.text = query;
      _lastSearch = query;
    });
    _performSearch(query); // Realiza la búsqueda con el query seleccionado
    _removeOverlay();
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
    setState(() {
      _isSearching = false;
    });
  }

  void _showOverlay(BuildContext context) {
    _overlayEntry = OverlayEntry(
      builder: (context) => Stack(
        children: [
          Positioned.fill(
            child: GestureDetector(
              onTap: _removeOverlay,
              behavior: HitTestBehavior.translucent,
            ),
          ),
          Positioned(
            top: kToolbarHeight + 120,
            left: 10,
            right: 30,
            child: Material(
              elevation: 8.0,
              borderRadius: BorderRadius.circular(20),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                constraints: const BoxConstraints(
                  minHeight: 60,
                  maxHeight: 300,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 10,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: _selectedIndex == 0
                    ? _buildCharacterSuggestions()
                    : _selectedIndex == 1
                        ? _buildLocationSuggestions()
                        : _buildEpisodeSuggestions(),
              ),
            ),
          ),
        ],
      ),
    );
    Overlay.of(context).insert(_overlayEntry!);
  }

  Widget _buildCharacterSuggestions() {
    return BlocBuilder<SearchCharactersCubit, SearchCharactersState>(
      builder: (context, state) {
        List<CharacterEntity> suggestions = [];

        if (state is SearchCharactersSuggested) {
          suggestions = state.suggestions;
        }

        if (suggestions.isEmpty && _lastSearch.isNotEmpty) {
          return _buildLastSearchTile(_lastSearch);
        }

        if (suggestions.isEmpty) {
          return _buildNoSuggestionsMessage();
        }

        return ListView.separated(
          padding: const EdgeInsets.symmetric(vertical: 8),
          shrinkWrap: true,
          itemCount: suggestions.length,
          separatorBuilder: (_, __) => const Divider(height: 1, thickness: 0.5),
          itemBuilder: (context, index) {
            final character = suggestions[index];
            return ListTile(
              leading: Image.network(character.image),
              title: Text(character.name),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(character.species),
                  Text(character.status),
                ],
              ),
              onTap: () => _selectSearchResult(character.name),
            );
          },
        );
      },
    );
  }

  Widget _buildLocationSuggestions() {
    return BlocBuilder<SearchLocationsCubit, SearchLocationsState>(
      builder: (context, state) {
        List<LocationEntity> suggestions = [];

        if (state is SearchLocationsSuggested) {
          suggestions = state.suggestions;
        }

        if (suggestions.isEmpty && _lastSearch.isNotEmpty) {
          return _buildLastSearchTile(_lastSearch);
        }

        if (suggestions.isEmpty) {
          return _buildNoSuggestionsMessage();
        }

        return ListView.separated(
          padding: const EdgeInsets.symmetric(vertical: 8),
          shrinkWrap: true,
          itemCount: suggestions.length,
          separatorBuilder: (_, __) => const Divider(height: 1, thickness: 0.5),
          itemBuilder: (context, index) {
            final location = suggestions[index];
            return ListTile(
              leading: const Icon(Icons.location_on),
              title: Text(location.name),
              subtitle: Text("${location.type} - ${location.dimension}"),
              onTap: () => _selectSearchResult(location.name),
            );
          },
        );
      },
    );
  }

  Widget _buildEpisodeSuggestions() {
    return BlocBuilder<SearchEpisodeCubit, SearchEpisodeState>(
      builder: (context, state) {
        List<EpisodeEntity> suggestions = [];

        if (state is SearchEpisodeSuggested) {
          suggestions = state.suggestions;
        }

        if (suggestions.isEmpty && _lastSearch.isNotEmpty) {
          return _buildLastSearchTile(_lastSearch);
        }

        if (suggestions.isEmpty) {
          return _buildNoSuggestionsMessage();
        }

        return ListView.separated(
          padding: const EdgeInsets.symmetric(vertical: 8),
          shrinkWrap: true,
          itemCount: suggestions.length,
          separatorBuilder: (_, __) => const Divider(height: 1, thickness: 0.5),
          itemBuilder: (context, index) {
            final episode = suggestions[index];
            return ListTile(
              title: Text(episode.name),
              subtitle: Text("Season: ${episode.episode}"),
              onTap: () => _selectSearchResult(episode.name),
            );
          },
        );
      },
    );
  }

  Widget _buildLastSearchTile(String query) {
    return ListView(
      padding: const EdgeInsets.symmetric(vertical: 8),
      shrinkWrap: true,
      children: [
        ListTile(
          title: Text(
            query,
            style: const TextStyle(
                fontSize: 16, fontWeight: FontWeight.w500, color: Colors.grey),
          ),
          leading: const Icon(Icons.history, color: Colors.grey),
          onTap: () => _selectSearchResult(query),
        ),
      ],
    );
  }

  Widget _buildNoSuggestionsMessage() {
    return const Padding(
      padding: EdgeInsets.all(16),
      child: Center(
        child: Text("There is no suggestion",
            style: TextStyle(color: Colors.grey)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Quita el foco del TextField y cierra el teclado
        FocusScope.of(context).unfocus();
      },
      behavior: HitTestBehavior.opaque, // Captura toques en toda la pantalla
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Rick and Morty Explorer"),
          actions: [
            IconButton(
              icon: const Icon(Icons.favorite, color: Colors.red),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const FavoritesPage()),
                );
              },
            ),
          ],
        ),
        body: Column(
          children: [
            _buildSearchAndFilter(),
            _buildMenuButtons(),
            Expanded(child: _buildContent()),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchAndFilter() {
    String placeholder = [
      "Search characters...",
      "Search locations...",
      "Search for episodes..."
    ][_selectedIndex];

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: placeholder,
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: _searchController.text.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              _searchController.clear(); // Borra el texto
                              FocusScope.of(context)
                                  .unfocus(); // Inactiva el campo
                              setState(() {}); // Actualiza la UI
                              _performSearch(
                                  ""); // Vuelve a mostrar todos los personajes
                            },
                          )
                        : null,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 10,
                      horizontal: 15,
                    ),
                  ),
                  onChanged: (value) {
                    setState(() {}); // Para mostrar/ocultar el botón "X"
                    _suggestSearch(value);
                    if (_overlayEntry == null) _showOverlay(context);
                  },
                  onTap: () {
                    setState(() {
                      _isSearching = true;
                    });
                    _showOverlay(context);
                  },
                ),
              ),
              const SizedBox(width: 8),
              IconButton(
                icon: const Icon(Icons.filter_list, size: 28),
                onPressed: _showFilterModal,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMenuButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _buildOption("Characters", 0),
        _buildOption("Locations", 1),
        _buildOption("Episodes", 2),
      ],
    );
  }

  Widget _buildOption(String title, int index) {
    bool isSelected = _selectedIndex == index;

    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        backgroundColor: isSelected ? Colors.blue : Colors.grey[300],
        foregroundColor: isSelected ? Colors.white : Colors.black,
      ),
      onPressed: () {
        setState(() {
          _selectedIndex = index;
        });
      },
      child: Text(title),
    );
  }

  Widget _buildContent() {
    return IndexedStack(
      index: _selectedIndex,
      children: _pages.map((page) {
        if (_selectedIndex == 0) {
          return BlocBuilder<SearchCharactersCubit, SearchCharactersState>(
            builder: (context, state) {
              if (state is SearchCharactersLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is SearchCharactersLoaded) {
                return Padding(
                  padding: const EdgeInsets.all(10),
                  child: GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      childAspectRatio: 0.8,
                    ),
                    itemCount: state.characters.length,
                    itemBuilder: (context, index) {
                      final character = state.characters[index];
                      return CustomCard(
                        title: character.name,
                        subtitle: "${character.species} - ${character.status}",
                        imageUrl: character.image,
                        extraInfo: [
                          "Origin: ${character.origin}",
                          "Gender: ${character.gender}"
                        ],
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  CharacterDetailPage(character: character),
                            ),
                          );
                        },
                      );
                    },
                  ),
                );
              }
              return page;
            },
          );
        } else if (_selectedIndex == 1) {
          return BlocBuilder<SearchLocationsCubit, SearchLocationsState>(
            builder: (context, state) {
              if (state is SearchLocationsLoaded) {
                return Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  child: ListView.separated(
                    itemCount: state.locations.length,
                    separatorBuilder: (_, __) =>
                        const Divider(height: 1, thickness: 0.8),
                    itemBuilder: (context, index) {
                      final location = state.locations[index];
                      return ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 8),
                        leading: const Icon(Icons.location_on,
                            size: 30, color: Colors.blue),
                        title: Text(
                          location.name,
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(
                          "${location.type} - ${location.dimension}",
                          style: const TextStyle(
                              fontSize: 14, color: Colors.black54),
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  LocationDetailPage(location: location),
                            ),
                          );
                        },
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                      );
                    },
                  ),
                );
              }
              return page;
            },
          );
        }
        if (_selectedIndex == 2) {
          return BlocBuilder<SearchEpisodeCubit, SearchEpisodeState>(
            builder: (context, state) {
              if (state is SearchEpisodeLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is SearchEpisodeLoaded) {
                return Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  child: ListView.separated(
                    itemCount: state.episodes.length,
                    separatorBuilder: (_, __) =>
                        const Divider(height: 1, thickness: 0.8),
                    itemBuilder: (context, index) {
                      final episode = state.episodes[index];
                      return ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 8),
                        leading: const Icon(Icons.tv,
                            size: 30, color: Colors.blueAccent),
                        title: Text(
                          "${episode.episode} - ${episode.name}",
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(
                          "Air date: ${episode.airDate}",
                          style: const TextStyle(
                              fontSize: 14, color: Colors.black54),
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  EpisodeDetailPage(episode: episode),
                            ),
                          );
                        },
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                      );
                    },
                  ),
                );
              }
              return page;
            },
          );
        }
        return page;
      }).toList(),
    );
  }

  void _performSearch(String query) {
    if (query.isNotEmpty) {
      _prefsHelper.saveLastSearch(query);
      setState(() {
        _lastSearch = query;
      });
    }
    switch (_selectedIndex) {
      case 0:
        context.read<SearchCharactersCubit>().searchCharacters(
              query,
              status:
                  selectedStatus.isNotEmpty ? selectedStatus.join(',') : null,
              gender:
                  selectedGender.isNotEmpty ? selectedGender.join(',') : null,
            );
        break;
      case 1:
        context.read<SearchLocationsCubit>().searchLocations(
              query,
              type: selectedType.isNotEmpty ? selectedType.join(',') : null,
              dimension: selectedDimension.isNotEmpty
                  ? selectedDimension.join(',')
                  : null,
            );
        break;
      case 2:
        context.read<SearchEpisodeCubit>().searchEpisodes(
              name: query.isNotEmpty ? query : null,
              episodes: selectedType.isNotEmpty ? selectedType : null,
            );

        break;
    }
  }

  void _suggestSearch(String query) {
    switch (_selectedIndex) {
      case 0:
        context.read<SearchCharactersCubit>().suggestCharacters(query);
        break;
      case 1:
        context.read<SearchLocationsCubit>().suggestLocations(query);
        break;
      case 2:
        context.read<SearchEpisodeCubit>().suggestEpisodes(query);
        break;
    }
  }

  void _showFilterModal() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
                left: 16,
                right: 16,
                top: 20,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Filter Results",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const Divider(thickness: 1.2),
                  const SizedBox(height: 10),
                  if (_selectedIndex == 0) ...[
                    const Text(
                      "Status",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    _buildCheckboxRow(["Alive", "Dead", "Unknown"],
                        selectedStatus, setModalState),
                    const SizedBox(height: 12),
                    const Text(
                      "Gender",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    _buildCheckboxRow(["Male", "Female", "Genderless"],
                        selectedGender, setModalState),
                  ],
                  if (_selectedIndex == 1) ...[
                    const Text(
                      "Type",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    _buildCheckboxRow(["Planet", "Space Station", "Microverse"],
                        selectedType, setModalState),
                    const SizedBox(height: 12),
                    const Text(
                      "Dimension",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    _buildCheckboxRow(["C-137", "Cronenberg", "Unknown"],
                        selectedDimension, setModalState),
                  ],
                  if (_selectedIndex == 2) ...[
                    const Text(
                      "Season",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    _buildCheckboxRow(
                        ["S1", "S2"], selectedType, setModalState),
                  ],
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildOptionButton("Clean", Colors.grey, () {
                        setModalState(() {
                          if (_selectedIndex == 0) {
                            selectedStatus.clear();
                            selectedGender.clear();
                          } else {
                            selectedType.clear();
                            selectedDimension.clear();
                          }
                        });
                      }),
                      _buildOptionButton("Apply", Colors.blue, () {
                        Navigator.pop(context);
                        _applyFilters();
                      }),
                    ],
                  ),
                  const SizedBox(height: 45),
                ],
              ),
            );
          },
        );
      },
    );
  }

  // Widget para mostrar checkboxes en una sola fila
  Widget _buildCheckboxRow(
    List<String> options,
    List<String> selectedFilters,
    Function(Function()) setModalState,
  ) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: options.map((option) {
          final isSelected = selectedFilters.contains(option);
          return Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Checkbox(
                value: isSelected,
                activeColor: Colors.blue,
                onChanged: (bool? value) {
                  setModalState(() {
                    if (value == true) {
                      selectedFilters.add(option);
                    } else {
                      selectedFilters.remove(option);
                    }
                  });
                },
              ),
              Text(option, style: const TextStyle(fontSize: 16)),
            ],
          );
        }).toList(),
      ),
    );
  }

  // Botón de opciones (Limpiar / Aplicar)
  Widget _buildOptionButton(String title, Color color, VoidCallback onPressed) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            backgroundColor: color,
          ),
          onPressed: onPressed,
          child: Text(
            title,
            style: const TextStyle(fontSize: 16, color: Colors.white),
          ),
        ),
      ),
    );
  }

  void _applyFilters() {
    switch (_selectedIndex) {
      case 0: // Personajes
        context.read<SearchCharactersCubit>().searchCharacters(
              _searchController.text,
              status:
                  selectedStatus.isNotEmpty ? selectedStatus.join(',') : null,
              gender:
                  selectedGender.isNotEmpty ? selectedGender.join(',') : null,
            );
        break;
      case 1: // Ubicaciones
        context.read<SearchLocationsCubit>().searchLocations(
              _searchController.text,
              type: selectedType.isNotEmpty ? selectedType.join(',') : null,
              dimension: selectedDimension.isNotEmpty
                  ? selectedDimension.join(',')
                  : null,
            );
        break;
      case 2: // Episodios
        List<String> seasonFilters = selectedType.map((season) {
          return "S${season.substring(1).padLeft(2, '0')}"; // Convierte "S1" en "S01"
        }).toList();

        context.read<SearchEpisodeCubit>().searchEpisodes(
              name: _searchController.text.isNotEmpty
                  ? _searchController.text
                  : null,
              episodes: seasonFilters.isNotEmpty
                  ? seasonFilters
                  : null, // Ahora acepta múltiples temporadas
            );
        break;
    }
  }
}
