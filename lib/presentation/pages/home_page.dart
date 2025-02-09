import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rick_and_morty/core/usecases/shared_prefs_helper.dart';
import 'package:rick_and_morty/domain/entities/character_entity.dart';
import 'package:rick_and_morty/presentation/bloc/cubits/characters/search_characters_cubit.dart';
import 'package:rick_and_morty/presentation/pages/character/character_detail_page.dart';
import 'package:rick_and_morty/presentation/pages/character/character_list_page.dart';
import 'package:rick_and_morty/presentation/pages/episode/episode_list_page.dart';
import 'package:rick_and_morty/presentation/pages/favorites_page.dart';
import 'package:rick_and_morty/presentation/pages/location/location_list_page.dart';

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

  List<String> selectedStatus = []; // Estado global para filtros
  List<String> selectedGender = []; // Estado global para filtros

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

  void _selectSearchResult(String query) {
    _prefsHelper.saveLastSearch(query);
    _searchController.text = query;
    _performSearch(query);
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
          // Detecta toques fuera del overlay para cerrarlo
          Positioned.fill(
            child: GestureDetector(
              onTap: _removeOverlay, // Cierra el overlay al tocar fuera
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
                  maxHeight: 300, // Más espacio para sugerencias
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
                child:
                    BlocBuilder<SearchCharactersCubit, SearchCharactersState>(
                  builder: (context, state) {
                    List<CharacterEntity> suggestions = [];

                    if (state is SearchCharactersSuggested) {
                      suggestions = state.suggestions;
                    }

                    // Si no hay sugerencias y hay un historial de búsqueda, mostrarlo como historial
                    if (suggestions.isEmpty && _lastSearch.isNotEmpty) {
                      return ListView(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        shrinkWrap: true,
                        children: [
                          ListTile(
                            title: Text(
                              _lastSearch,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: Colors.grey,
                              ),
                            ),
                            leading:
                                const Icon(Icons.history, color: Colors.grey),
                            onTap: () {
                              _selectSearchResult(_lastSearch);
                            },
                          ),
                        ],
                      );
                    }

                    if (suggestions.isEmpty) {
                      return const Padding(
                        padding: EdgeInsets.all(16),
                        child: Center(
                          child: Text(
                            "No hay sugerencias",
                            style: TextStyle(color: Colors.grey),
                          ),
                        ),
                      );
                    }

                    return ListView.separated(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      shrinkWrap: true,
                      itemCount: suggestions.length,
                      separatorBuilder: (_, __) =>
                          const Divider(height: 1, thickness: 0.5),
                      itemBuilder: (context, index) {
                        final character = suggestions[index];
                        return ListTile(
                          title: Text(
                            character.name,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          subtitle: character.status.isNotEmpty
                              ? Text(
                                  character.status,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey,
                                  ),
                                )
                              : null,
                          leading: character.image.isNotEmpty
                              ? CircleAvatar(
                                  backgroundImage:
                                      NetworkImage(character.image),
                                )
                              : null,
                          onTap: () {
                            _selectSearchResult(character.name);
                          },
                        );
                      },
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
    Overlay.of(context).insert(_overlayEntry!);
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
      "Buscar personajes...",
      "Buscar ubicaciones...",
      "Buscar episodios..."
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
      _buildOption("Personajes", 0),
      _buildOption("Ubicaciones", 1),
      _buildOption("Episodios", 2),
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
      backgroundColor: isSelected ? Colors.blue : Colors.grey[300], // Color activo/inactivo
      foregroundColor: isSelected ? Colors.white : Colors.black, // Color del texto
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
    return Expanded(
      child: IndexedStack(
        index: _selectedIndex,
        children: _pages.map((page) {
          return BlocBuilder<SearchCharactersCubit, SearchCharactersState>(
            builder: (context, state) {
              if (state is SearchCharactersLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is SearchCharactersLoaded) {
                return ListView.builder(
                  itemCount: state.characters.length,
                  itemBuilder: (context, index) {
                    final character = state.characters[index];
                    return ListTile(
                      leading: Image.network(character.image),
                      title: Text(character.name),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(character.species),
                          Text(character.status),
                          Text(character.origin),
                        ],
                      ),
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
                );
              } else if (state is SearchCharactersEmpty) {
                return const Center(child: Text("No se encontraron resultados"));
              } else if (state is SearchCharactersError) {
                return Center(child: Text(state.message));
              }
              return page;
            },
          );
        }).toList(),
      ),
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
        context.read<SearchCharactersCubit>().searchCharacters(query,
            status: selectedStatus.isNotEmpty ? selectedStatus.join(',') : null,
            gender: selectedGender.isNotEmpty ? selectedGender.join(',') : null);
        break;
      case 1:
        // context.read<SearchLocationsCubit>().searchLocations(query);
        break;
      case 2:
        // context.read<SearchEpisodesCubit>().searchEpisodes(query);
        break;
    }
  }

  void _suggestSearch(String query) {
    switch (_selectedIndex) {
      case 0:
        context.read<SearchCharactersCubit>().suggestCharacters(query);
        break;
      case 1:
        // context.read<SearchLocationsCubit>().suggestLocations(query);
        break;
      case 2:
        // context.read<SearchEpisodesCubit>().suggestEpisodes(query);
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
                    "Filtrar Resultados",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Divider(thickness: 1.2),
                  const SizedBox(height: 10),

                  // Sección de Estado
                  const Text(
                    "Estado",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  _buildCheckboxRow(
                    ["Vivo", "Muerto", "Desconocido"],
                    selectedStatus,
                    setModalState,
                  ),
                  const SizedBox(height: 12),

                  // Sección de Género
                  const Text(
                    "Sexo",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  _buildCheckboxRow(
                    ["Hombre", "Mujer", "Sin género"],
                    selectedGender,
                    setModalState,
                  ),
                  const SizedBox(height: 12),

                  // Opciones en una sola fila
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildOptionButton("Limpiar", Colors.grey, () {
                        setModalState(() {
                          selectedStatus.clear();
                          selectedGender.clear();
                        });
                      }),
                      _buildOptionButton("Aplicar", Colors.green, () {
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
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: options.map((option) {
        final isSelected = selectedFilters.contains(option);
        return Row(
          children: [
            Checkbox(
              value: isSelected,
              activeColor: Colors.green, // Color cuando está seleccionado
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
    print("Filtros aplicados - Estado: $selectedStatus, Género: $selectedGender");
    context.read<SearchCharactersCubit>().searchCharacters(
          _searchController.text,
          status: selectedStatus.isNotEmpty ? selectedStatus.join(',') : null,
          gender: selectedGender.isNotEmpty ? selectedGender.join(',') : null,
        );
  }
}
