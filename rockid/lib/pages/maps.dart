import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// import 'other_user_profile_page.dart'; in my branch now

const LatLng currentLocation = LatLng(42.3314, -83.0458);

class MapsPage extends StatefulWidget {
  @override
  _MapsPageState createState() => _MapsPageState();
}

class _MapsPageState extends State<MapsPage> {
  late GoogleMapController mapController;
  Set<Marker> markers = {};
  String _searchText = ''; //search text for hamburger menu
  TextEditingController _searchController = TextEditingController();

//variables - polished
  bool _filterAlexandrite = false;
  bool _filterAlmandine = false;
  bool _filterAmazonite = false;
  bool _filterAmber = false;
  bool _filterAmethyst = false;
  bool _filterAmetrine = false;
  bool _filterAndalusite = false;
  bool _filterAndradite = false;
  bool _filterAquamarine = false;
  bool _filterAventurineGreen = false;
  bool _filterAventurineYellow = false;
  bool _filterBenitoite = false;
  bool _filterBerylGolden = false;
  bool _filterBixbite = false;
  bool _filterBloodstone = false;
  bool _filterCatsEye = false;
  bool _filterChalcedonyBlue = false;
  bool _filterChromeDiopside = false;
  bool _filterChrysoberyl = false;
  bool _filterChrysocolla = false;
  bool _filterChrysoprase = false;
  bool _filterCitrine = false;
  bool _filterCoral = false;
  bool _filterDanburite = false;
  bool _filterDiamond = false;
  bool _filterDiaspore = false;
  bool _filterDumortierite = false;
  bool _filterEmerald = false;
  bool _filterFluorite = false;
  bool _filterGarnetRed = false;
  bool _filterGoshenite = false;
  bool _filterGrossular = false;
  bool _filterHessonite = false;
  bool _filterHiddenite = false;
  bool _filterIolite = false;
  bool _filterJade = false;
  bool _filterKunzite = false;
  bool _filterKyanite = false;
  bool _filterLabradorite = false;
  bool _filterLapisLazuli = false;
  bool _filterLarimar = false;
  bool _filterMalachite = false;
  bool _filterMoonstone = false;
  bool _filterMorganite = false;
  bool _filterOnyxBlack = false;
  bool _filterOpal = false;
  bool _filterPearl = false;
  bool _filterPeridot = false;
  bool _filterPyrite = false;
  bool _filterPyrope = false;
  bool _filterQuartzSmoky = false;
  bool _filterRhodochrosite = false;
  bool _filterRhodolite = false;
  bool _filterRhodonite = false;
  bool _filterRuby = false;
  bool _filterSapphire = false;
  bool _filterSerpentine = false;
  bool _filterSodalite = false;
  bool _filterSpessartite = false;
  bool _filterSphene = false;
  bool _filterSunstone = false;
  bool _filterTanzanite = false;
  bool _filterTigersEye = false;
  bool _filterTopaz = false;
  bool _filterTourmaline = false;
  bool _filterTsavorite = false;
  bool _filterTurquoise = false;
  bool _filterVariscite = false;
  bool _filterZircon = false;
  bool _filterZoisite = false;

  bool _filteragate = false;
  bool _filterbasalt = false;
  bool _filtercoal = false;
  bool _filtergarnet = false;
  bool _filtergranite = false;
  bool _filterlimestone = false;
  bool _filtersandstone = false;

  Future<void> createMarkers(QuerySnapshot snapshot) async {
    markers.clear(); //Clear previous markers to avoid duplication
    for (int i = 0; i < snapshot.docs.length; i++) {
      var doc = snapshot.docs[i];
      var data = doc.data() as Map<String, dynamic>;
      print("test:" + _searchController.text.trim());
      //Filter the data based on the user's search input and filter selections
      bool shouldAddMarker = (_searchController.text.trim() == "" ||
          ((data['CITY'].contains(_searchController.text.trim())) &&
              (!_filterAlexandrite ||
                  data['ROCK_CLASSIFICATION'] == 'Alexandrite' ||
                  data['ROCK_CLASSIFICATION'] == 'alexandrite') &&
              (!_filterAlmandine ||
                  data['ROCK_CLASSIFICATION'] == 'Almandine' ||
                  data['ROCK_CLASSIFICATION'] == 'almandine') &&
              (!_filterAmazonite ||
                  data['ROCK_CLASSIFICATION'] == 'Amazonite' ||
                  data['ROCK_CLASSIFICATION'] == 'amazonite') &&
              (!_filterAmber ||
                  data['ROCK_CLASSIFICATION'] == 'Amber' ||
                  data['ROCK_CLASSIFICATION'] == 'amber') &&
              (!_filterAmethyst ||
                  data['ROCK_CLASSIFICATION'] == 'Amethyst' ||
                  data['ROCK_CLASSIFICATION'] == 'amethyst') &&
              (!_filterAmetrine ||
                  data['ROCK_CLASSIFICATION'] == 'Ametrine' ||
                  data['ROCK_CLASSIFICATION'] == 'ametrine') &&
              (!_filterAndalusite ||
                  data['ROCK_CLASSIFICATION'] == 'Andalusite' ||
                  data['ROCK_CLASSIFICATION'] == 'andalusite') &&
              (!_filterAndradite ||
                  data['ROCK_CLASSIFICATION'] == 'Andradite' ||
                  data['ROCK_CLASSIFICATION'] == 'andradite') &&
              (!_filterAquamarine ||
                  data['ROCK_CLASSIFICATION'] == 'Aquamarine' ||
                  data['ROCK_CLASSIFICATION'] == 'aquamarine') &&
              (!_filterAventurineGreen ||
                  data['ROCK_CLASSIFICATION'] == 'Aventurine Green' ||
                  data['ROCK_CLASSIFICATION'] == 'aventurine green') &&
              (!_filterAventurineYellow ||
                  data['ROCK_CLASSIFICATION'] == 'Aventurine Yellow' ||
                  data['ROCK_CLASSIFICATION'] == 'aventurine yellow') &&
              (!_filterBenitoite ||
                  data['ROCK_CLASSIFICATION'] == 'Benitoite' ||
                  data['ROCK_CLASSIFICATION'] == 'benitoite') &&
              (!_filterBerylGolden ||
                  data['ROCK_CLASSIFICATION'] == 'Beryl Golden' ||
                  data['ROCK_CLASSIFICATION'] == 'beryl golden') &&
              (!_filterBixbite ||
                  data['ROCK_CLASSIFICATION'] == 'Bixbite' ||
                  data['ROCK_CLASSIFICATION'] == 'bixbite') &&
              (!_filterBloodstone ||
                  data['ROCK_CLASSIFICATION'] == 'Bloodstone' ||
                  data['ROCK_CLASSIFICATION'] == 'bloodstone') &&
              (!_filterCatsEye ||
                  data['ROCK_CLASSIFICATION'] == 'Cats Eye' ||
                  data['ROCK_CLASSIFICATION'] == 'cats eye') &&
              (!_filterChalcedonyBlue ||
                  data['ROCK_CLASSIFICATION'] == 'Chalcedony Blue' ||
                  data['ROCK_CLASSIFICATION'] == 'chalcedony blue') &&
              (!_filterChromeDiopside ||
                  data['ROCK_CLASSIFICATION'] == 'Chrome Diopside' ||
                  data['ROCK_CLASSIFICATION'] == 'chalcedony diopside') &&
              (!_filterChrysoberyl ||
                  data['ROCK_CLASSIFICATION'] == 'Chrysoberyl' ||
                  data['ROCK_CLASSIFICATION'] == 'chrysoberyl') &&
              (!_filterChrysocolla ||
                  data['ROCK_CLASSIFICATION'] == 'Chrysocolla' ||
                  data['ROCK_CLASSIFICATION'] == 'chrysocolla') &&
              (!_filterChrysoprase ||
                  data['ROCK_CLASSIFICATION'] == 'Chrysoprase' ||
                  data['ROCK_CLASSIFICATION'] == 'chrysoprase') &&
              (!_filterCitrine ||
                  data['ROCK_CLASSIFICATION'] == 'Citrine' ||
                  data['ROCK_CLASSIFICATION'] == 'citrine') &&
              (!_filterCoral ||
                  data['ROCK_CLASSIFICATION'] == 'Coral' ||
                  data['ROCK_CLASSIFICATION'] == 'coral') &&
              (!_filterDanburite ||
                  data['ROCK_CLASSIFICATION'] == 'Danburite' ||
                  data['ROCK_CLASSIFICATION'] == 'danburite') &&
              (!_filterDiamond ||
                  data['ROCK_CLASSIFICATION'] == 'Diamond' ||
                  data['ROCK_CLASSIFICATION'] == 'diamond') &&
              (!_filterDiaspore ||
                  data['ROCK_CLASSIFICATION'] == 'Diaspore' ||
                  data['ROCK_CLASSIFICATION'] == 'diaspore') &&
              (!_filterDumortierite ||
                  data['ROCK_CLASSIFICATION'] == 'Dumortierite' ||
                  data['ROCK_CLASSIFICATION'] == 'dumortierite') &&
              (!_filterEmerald ||
                  data['ROCK_CLASSIFICATION'] == 'Emerald' ||
                  data['ROCK_CLASSIFICATION'] == 'emerald') &&
              (!_filterFluorite ||
                  data['ROCK_CLASSIFICATION'] == 'Fluorite' ||
                  data['ROCK_CLASSIFICATION'] == 'fluorite') &&
              (!_filterGarnetRed ||
                  data['ROCK_CLASSIFICATION'] == 'Garnet Red' ||
                  data['ROCK_CLASSIFICATION'] == 'garnet red') &&
              (!_filterGoshenite ||
                  data['ROCK_CLASSIFICATION'] == 'Goshenite' ||
                  data['ROCK_CLASSIFICATION'] == 'goshenite') &&
              (!_filterGrossular ||
                  data['ROCK_CLASSIFICATION'] == 'Grossular' ||
                  data['ROCK_CLASSIFICATION'] == 'grossular') &&
              (!_filterHessonite ||
                  data['ROCK_CLASSIFICATION'] == 'Hessonite' ||
                  data['ROCK_CLASSIFICATION'] == 'hessonite') &&
              (!_filterHiddenite ||
                  data['ROCK_CLASSIFICATION'] == 'Hiddenite' ||
                  data['ROCK_CLASSIFICATION'] == 'hiddenite') &&
              (!_filterIolite ||
                  data['ROCK_CLASSIFICATION'] == 'Iolite' ||
                  data['ROCK_CLASSIFICATION'] == 'iolite') &&
              (!_filterJade ||
                  data['ROCK_CLASSIFICATION'] == 'Jade' ||
                  data['ROCK_CLASSIFICATION'] == 'jade') &&
              (!_filterKunzite ||
                  data['ROCK_CLASSIFICATION'] == 'Kunzite' ||
                  data['ROCK_CLASSIFICATION'] == 'kunzite') &&
              (!_filterKyanite ||
                  data['ROCK_CLASSIFICATION'] == 'Kyanite' ||
                  data['ROCK_CLASSIFICATION'] == 'kyanite') &&
              (!_filterLabradorite ||
                  data['ROCK_CLASSIFICATION'] == 'Labradorite' ||
                  data['ROCK_CLASSIFICATION'] == 'labradorite') &&
              (!_filterLapisLazuli ||
                  data['ROCK_CLASSIFICATION'] == 'Lapis Lazuli' ||
                  data['ROCK_CLASSIFICATION'] == 'lapis Lazuli') &&
              (!_filterLarimar ||
                  data['ROCK_CLASSIFICATION'] == 'Larimar' ||
                  data['ROCK_CLASSIFICATION'] == 'larimar') &&
              (!_filterMalachite ||
                  data['ROCK_CLASSIFICATION'] == 'Malachite' ||
                  data['ROCK_CLASSIFICATION'] == 'malachite') &&
              (!_filterMoonstone ||
                  data['ROCK_CLASSIFICATION'] == 'Moonstone' ||
                  data['ROCK_CLASSIFICATION'] == 'moonstone') &&
              (!_filterMorganite ||
                  data['ROCK_CLASSIFICATION'] == 'Morganite' ||
                  data['ROCK_CLASSIFICATION'] == 'morganite') &&
              (!_filterOnyxBlack ||
                  data['ROCK_CLASSIFICATION'] == 'Onyx Black' ||
                  data['ROCK_CLASSIFICATION'] == 'onyx black') &&
              (!_filterOpal ||
                  data['ROCK_CLASSIFICATION'] == 'Opal' ||
                  data['ROCK_CLASSIFICATION'] == 'opal') &&
              (!_filterPearl ||
                  data['ROCK_CLASSIFICATION'] == 'Pearl' ||
                  data['ROCK_CLASSIFICATION'] == 'pearl') &&
              (!_filterPeridot ||
                  data['ROCK_CLASSIFICATION'] == 'Peridot' ||
                  data['ROCK_CLASSIFICATION'] == 'peridot') &&
              (!_filterPyrite ||
                  data['ROCK_CLASSIFICATION'] == 'Pyrite' ||
                  data['ROCK_CLASSIFICATION'] == 'pyrite') &&
              (!_filterPyrope ||
                  data['ROCK_CLASSIFICATION'] == 'Pyrope' ||
                  data['ROCK_CLASSIFICATION'] == 'pyrope') &&
              (!_filterQuartzSmoky ||
                  data['ROCK_CLASSIFICATION'] == 'Quartz Smoky' ||
                  data['ROCK_CLASSIFICATION'] == 'quartz smoky') &&
              (!_filterRhodochrosite ||
                  data['ROCK_CLASSIFICATION'] == 'Rhodochrosite' ||
                  data['ROCK_CLASSIFICATION'] == 'rhodochrosite') &&
              (!_filterRhodolite ||
                  data['ROCK_CLASSIFICATION'] == 'Rhodolite' ||
                  data['ROCK_CLASSIFICATION'] == 'rhodolite') &&
              (!_filterRhodonite ||
                  data['ROCK_CLASSIFICATION'] == 'Rhodonite' ||
                  data['ROCK_CLASSIFICATION'] == 'rhodonite') &&
              (!_filterRuby ||
                  data['ROCK_CLASSIFICATION'] == 'Ruby' ||
                  data['ROCK_CLASSIFICATION'] == 'ruby') &&
              (!_filterSapphire ||
                  data['ROCK_CLASSIFICATION'] == 'Sapphire' ||
                  data['ROCK_CLASSIFICATION'] == 'sapphire') &&
              (!_filterSerpentine ||
                  data['ROCK_CLASSIFICATION'] == 'Serpentine' ||
                  data['ROCK_CLASSIFICATION'] == 'serpentine') &&
              (!_filterSodalite || data['ROCK_CLASSIFICATION'] == 'Sodalite') &&
              (!_filterSpessartite ||
                  data['ROCK_CLASSIFICATION'] == 'Spessartite' ||
                  data['ROCK_CLASSIFICATION'] == 'spessartite') &&
              (!_filterSphene ||
                  data['ROCK_CLASSIFICATION'] == 'Sphene' ||
                  data['ROCK_CLASSIFICATION'] == 'sphene') &&
              (!_filterSunstone ||
                  data['ROCK_CLASSIFICATION'] == 'Sunstone' ||
                  data['ROCK_CLASSIFICATION'] == 'sunstone') &&
              (!_filterTanzanite ||
                  data['ROCK_CLASSIFICATION'] == 'Tanzanite' ||
                  data['ROCK_CLASSIFICATION'] == 'tanzanite') &&
              (!_filterTigersEye ||
                  data['ROCK_CLASSIFICATION'] == 'Tigers Eye' ||
                  data['ROCK_CLASSIFICATION'] == 'tigers eye') &&
              (!_filterTopaz ||
                  data['ROCK_CLASSIFICATION'] == 'Topaz' ||
                  data['ROCK_CLASSIFICATION'] == 'topaz') &&
              (!_filterTourmaline ||
                  data['ROCK_CLASSIFICATION'] == 'Tourmaline' ||
                  data['ROCK_CLASSIFICATION'] == 'tourmaline') &&
              (!_filterTsavorite ||
                  data['ROCK_CLASSIFICATION'] == 'Tsavorite' ||
                  data['ROCK_CLASSIFICATION'] == 'tsavorite') &&
              (!_filterTurquoise ||
                  data['ROCK_CLASSIFICATION'] == 'Turquoise' ||
                  data['ROCK_CLASSIFICATION'] == 'turquoise') &&
              (!_filterVariscite ||
                  data['ROCK_CLASSIFICATION'] == 'Variscite' ||
                  data['ROCK_CLASSIFICATION'] == 'variscite') &&
              (!_filterZircon ||
                  data['ROCK_CLASSIFICATION'] == 'Zircon' ||
                  data['ROCK_CLASSIFICATION'] == 'zircon') &&
              (!_filterZoisite ||
                  data['ROCK_CLASSIFICATION'] == 'Zoisite' ||
                  data['ROCK_CLASSIFICATION'] == 'zoisite') &&
              (!_filteragate || data['ROCK_CLASSIFICATION'] == 'agate') &&
              (!_filterbasalt || data['ROCK_CLASSIFICATION'] == 'basalt') &&
              (!_filtercoal || data['ROCK_CLASSIFICATION'] == 'coal') &&
              (!_filtergarnet || data['ROCK_CLASSIFICATION'] == 'garnet') &&
              (!_filtergranite || data['ROCK_CLASSIFICATION'] == 'granite') &&
              (!_filterlimestone ||
                  data['ROCK_CLASSIFICATION'] == 'limestone') &&
              (!_filtersandstone ||
                  data['ROCK_CLASSIFICATION'] == 'sandstone')));

      if (shouldAddMarker) {
        var markerIdVal = doc.id;
        var markerId = MarkerId(markerIdVal);
        var marker = Marker(
          markerId: markerId,
          position: LatLng(data['LATTITUDE'], data['LONGITUDE']),
          infoWindow: InfoWindow(
            title: data['ROCK_CLASSIFICATION'],
            snippet: data['CITY'],
          ),
        );
        setState(() {
          markers.add(marker);
        });
      }
    }
  }

  getMarkerData() async {
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('rocks_found')
        .where('VIEWABLE', isEqualTo: true)
        .where('CAN_BE_VIEWED', isEqualTo: true)
        .get();
    createMarkers(snapshot);
  }

  @override
  void initState() {
    super.initState();
    getMarkerData();
  }

  // Variable to hold the selected value from the drop-down menu
  String _selectedValue = 'All';

//header
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Rocks Found Around the World'),
        backgroundColor: Colors.brown,
      ),

      //drawer
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.brown,
              ),
              child: Text(
                'Filters',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            //apply button
            ListTile(
              leading: Icon(Icons.check),
              title: Text('Apply'),
              onTap: () {
                getMarkerData(); //updates
              },
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 5.0, horizontal: 15),
              child: Text(
                'Show Only This City:',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.search),
              title: TextField(
                controller: _searchController,
                onChanged: (value) {
                  setState(() {
                    _searchText = value;
                  });
                },
                decoration: InputDecoration(
                  hintText: 'Search by city',
                ),
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 25.0, horizontal: 15),
              child: Text(
                'Show Only This Rock:',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
            ),
            // Add the checkbox list for filter selections
            //
            //
            //
            CheckboxListTile(
              title: Text('Agate'),
              value: _filteragate,
              onChanged: (value) {
                setState(() {
                  _filteragate = value!;
                });
              },
            ),
            CheckboxListTile(
              title: Text('Alexandrite'),
              value: _filterAlexandrite,
              onChanged: (value) {
                setState(() {
                  _filterAlexandrite = value!;
                });
              },
            ),
            CheckboxListTile(
              title: Text('Almandine'),
              value: _filterAlmandine,
              onChanged: (value) {
                setState(() {
                  _filterAlmandine = value!;
                });
              },
            ),
            CheckboxListTile(
              title: Text('Amazonite'),
              value: _filterAmazonite,
              onChanged: (value) {
                setState(() {
                  _filterAmazonite = value!;
                });
              },
            ),
            CheckboxListTile(
              title: Text('Amber'),
              value: _filterAmber,
              onChanged: (value) {
                setState(() {
                  _filterAmber = value!;
                });
              },
            ),
            CheckboxListTile(
              title: Text('Amethyst'),
              value: _filterAmethyst,
              onChanged: (value) {
                setState(() {
                  _filterAmethyst = value!;
                });
              },
            ),
            CheckboxListTile(
              title: Text('Ametrine'),
              value: _filterAmetrine,
              onChanged: (value) {
                setState(() {
                  _filterAmetrine = value!;
                });
              },
            ),
            CheckboxListTile(
              title: Text('Andalusite'),
              value: _filterAndalusite,
              onChanged: (value) {
                setState(() {
                  _filterAndalusite = value!;
                });
              },
            ),
            CheckboxListTile(
              title: Text('Andradite'),
              value: _filterAndradite,
              onChanged: (value) {
                setState(() {
                  _filterAndradite = value!;
                });
              },
            ),
            CheckboxListTile(
              title: Text('Aquamarine'),
              value: _filterAquamarine,
              onChanged: (value) {
                setState(() {
                  _filterAquamarine = value!;
                });
              },
            ),
            CheckboxListTile(
              title: Text('Aventurine Green'),
              value: _filterAventurineGreen,
              onChanged: (value) {
                setState(() {
                  _filterAventurineGreen = value!;
                });
              },
            ),
            CheckboxListTile(
              title: Text('Aventurine Yellow'),
              value: _filterAventurineYellow,
              onChanged: (value) {
                setState(() {
                  _filterAventurineYellow = value!;
                });
              },
            ),
            CheckboxListTile(
              title: Text('Basalt'),
              value: _filterbasalt,
              onChanged: (value) {
                setState(() {
                  _filterbasalt = value!;
                });
              },
            ),
            CheckboxListTile(
              title: Text('Benitoite'),
              value: _filterBenitoite,
              onChanged: (value) {
                setState(() {
                  _filterBenitoite = value!;
                });
              },
            ),
            CheckboxListTile(
              title: Text('Beryl Golden'),
              value: _filterBerylGolden,
              onChanged: (value) {
                setState(() {
                  _filterBerylGolden = value!;
                });
              },
            ),
            CheckboxListTile(
              title: Text('Bixbite'),
              value: _filterBixbite,
              onChanged: (value) {
                setState(() {
                  _filterBixbite = value!;
                });
              },
            ),
            CheckboxListTile(
              title: Text('Bloodstone'),
              value: _filterBloodstone,
              onChanged: (value) {
                setState(() {
                  _filterBloodstone = value!;
                });
              },
            ),
            CheckboxListTile(
              title: Text('Cats Eye'),
              value: _filterCatsEye,
              onChanged: (value) {
                setState(() {
                  _filterCatsEye = value!;
                });
              },
            ),
            CheckboxListTile(
              title: Text('Chalcedony Blue'),
              value: _filterChalcedonyBlue,
              onChanged: (value) {
                setState(() {
                  _filterChalcedonyBlue = value!;
                });
              },
            ),
            CheckboxListTile(
              title: Text('Chrome Diopside'),
              value: _filterChromeDiopside,
              onChanged: (value) {
                setState(() {
                  _filterChromeDiopside = value!;
                });
              },
            ),
            CheckboxListTile(
              title: Text('Chrysoberyl'),
              value: _filterChrysoberyl,
              onChanged: (value) {
                setState(() {
                  _filterChrysoberyl = value!;
                });
              },
            ),
            CheckboxListTile(
              title: Text('Chrysocolla'),
              value: _filterChrysocolla,
              onChanged: (value) {
                setState(() {
                  _filterChrysocolla = value!;
                });
              },
            ),
            CheckboxListTile(
              title: Text('Chrysoprase'),
              value: _filterChrysoprase,
              onChanged: (value) {
                setState(() {
                  _filterChrysoprase = value!;
                });
              },
            ),
            CheckboxListTile(
              title: Text('Citrine'),
              value: _filterCitrine,
              onChanged: (value) {
                setState(() {
                  _filterCitrine = value!;
                });
              },
            ),
            CheckboxListTile(
              title: Text('Coral'),
              value: _filterCoral,
              onChanged: (value) {
                setState(() {
                  _filterCoral = value!;
                });
              },
            ),
            CheckboxListTile(
              title: Text('Coal'),
              value: _filtercoal,
              onChanged: (value) {
                setState(() {
                  _filtercoal = value!;
                });
              },
            ),
            CheckboxListTile(
              title: Text('Danburite'),
              value: _filterDanburite,
              onChanged: (value) {
                setState(() {
                  _filterDanburite = value!;
                });
              },
            ),
            CheckboxListTile(
              title: Text('Diamond'),
              value: _filterDiamond,
              onChanged: (value) {
                setState(() {
                  _filterDiamond = value!;
                });
              },
            ),
            CheckboxListTile(
              title: Text('Diaspore'),
              value: _filterDiaspore,
              onChanged: (value) {
                setState(() {
                  _filterDiaspore = value!;
                });
              },
            ),
            CheckboxListTile(
              title: Text('Dumortierite'),
              value: _filterDumortierite,
              onChanged: (value) {
                setState(() {
                  _filterDumortierite = value!;
                });
              },
            ),
            CheckboxListTile(
              title: Text('Emerald'),
              value: _filterEmerald,
              onChanged: (value) {
                setState(() {
                  _filterEmerald = value!;
                });
              },
            ),
            CheckboxListTile(
              title: Text('Fluorite'),
              value: _filterFluorite,
              onChanged: (value) {
                setState(() {
                  _filterFluorite = value!;
                });
              },
            ),
            CheckboxListTile(
              title: Text('Garnet'),
              value: _filtergarnet,
              onChanged: (value) {
                setState(() {
                  _filtergarnet = value!;
                });
              },
            ),
            CheckboxListTile(
              title: Text('Garnet Red'),
              value: _filterGarnetRed,
              onChanged: (value) {
                setState(() {
                  _filterGarnetRed = value!;
                });
              },
            ),
            CheckboxListTile(
              title: Text('granite'),
              value: _filtergranite,
              onChanged: (value) {
                setState(() {
                  _filtergranite = value!;
                });
              },
            ),
            CheckboxListTile(
              title: Text('Goshenite'),
              value: _filterGoshenite,
              onChanged: (value) {
                setState(() {
                  _filterGoshenite = value!;
                });
              },
            ),
            CheckboxListTile(
              title: Text('Grossular'),
              value: _filterGrossular,
              onChanged: (value) {
                setState(() {
                  _filterGrossular = value!;
                });
              },
            ),
            CheckboxListTile(
              title: Text('Hessonite'),
              value: _filterHessonite,
              onChanged: (value) {
                setState(() {
                  _filterHessonite = value!;
                });
              },
            ),
            CheckboxListTile(
              title: Text('Hiddenite'),
              value: _filterHiddenite,
              onChanged: (value) {
                setState(() {
                  _filterHiddenite = value!;
                });
              },
            ),
            CheckboxListTile(
              title: Text('Iolite'),
              value: _filterIolite,
              onChanged: (value) {
                setState(() {
                  _filterIolite = value!;
                });
              },
            ),
            CheckboxListTile(
              title: Text('Jade'),
              value: _filterJade,
              onChanged: (value) {
                setState(() {
                  _filterJade = value!;
                });
              },
            ),
            CheckboxListTile(
              title: Text('Kunzite'),
              value: _filterKunzite,
              onChanged: (value) {
                setState(() {
                  _filterKunzite = value!;
                });
              },
            ),
            CheckboxListTile(
              title: Text('Kyanite'),
              value: _filterKyanite,
              onChanged: (value) {
                setState(() {
                  _filterKyanite = value!;
                });
              },
            ),
            CheckboxListTile(
              title: Text('Labradorite'),
              value: _filterLabradorite,
              onChanged: (value) {
                setState(() {
                  _filterLabradorite = value!;
                });
              },
            ),
            CheckboxListTile(
              title: Text('Lapis Lazuli'),
              value: _filterLapisLazuli,
              onChanged: (value) {
                setState(() {
                  _filterLapisLazuli = value!;
                });
              },
            ),
            CheckboxListTile(
              title: Text('Larimar'),
              value: _filterLarimar,
              onChanged: (value) {
                setState(() {
                  _filterLarimar = value!;
                });
              },
            ),
            CheckboxListTile(
              title: Text('LimeStone'),
              value: _filterlimestone,
              onChanged: (value) {
                setState(() {
                  _filterlimestone = value!;
                });
              },
            ),
            CheckboxListTile(
              title: Text('Malachite'),
              value: _filterMalachite,
              onChanged: (value) {
                setState(() {
                  _filterMalachite = value!;
                });
              },
            ),
            CheckboxListTile(
              title: Text('Moonstone'),
              value: _filterMoonstone,
              onChanged: (value) {
                setState(() {
                  _filterMoonstone = value!;
                });
              },
            ),
            CheckboxListTile(
              title: Text('Morganite'),
              value: _filterMorganite,
              onChanged: (value) {
                setState(() {
                  _filterMorganite = value!;
                });
              },
            ),
            CheckboxListTile(
              title: Text('Onyx Black'),
              value: _filterOnyxBlack,
              onChanged: (value) {
                setState(() {
                  _filterOnyxBlack = value!;
                });
              },
            ),
            CheckboxListTile(
              title: Text('Opal'),
              value: _filterOpal,
              onChanged: (value) {
                setState(() {
                  _filterOpal = value!;
                });
              },
            ),
            CheckboxListTile(
              title: Text('Pearl'),
              value: _filterPearl,
              onChanged: (value) {
                setState(() {
                  _filterPearl = value!;
                });
              },
            ),
            CheckboxListTile(
              title: Text('Peridot'),
              value: _filterPeridot,
              onChanged: (value) {
                setState(() {
                  _filterPeridot = value!;
                });
              },
            ),
            CheckboxListTile(
              title: Text('Pyrite'),
              value: _filterPyrite,
              onChanged: (value) {
                setState(() {
                  _filterPyrite = value!;
                });
              },
            ),
            CheckboxListTile(
              title: Text('Pyrope'),
              value: _filterPyrope,
              onChanged: (value) {
                setState(() {
                  _filterPyrope = value!;
                });
              },
            ),
            CheckboxListTile(
              title: Text('Quartz Smoky'),
              value: _filterQuartzSmoky,
              onChanged: (value) {
                setState(() {
                  _filterQuartzSmoky = value!;
                });
              },
            ),
            CheckboxListTile(
              title: Text('Rhodochrosite'),
              value: _filterRhodochrosite,
              onChanged: (value) {
                setState(() {
                  _filterRhodochrosite = value!;
                });
              },
            ),
            CheckboxListTile(
              title: Text('Rhodolite'),
              value: _filterRhodolite,
              onChanged: (value) {
                setState(() {
                  _filterRhodolite = value!;
                });
              },
            ),
            CheckboxListTile(
              title: Text('Rhodonite'),
              value: _filterRhodonite,
              onChanged: (value) {
                setState(() {
                  _filterRhodonite = value!;
                });
              },
            ),
            CheckboxListTile(
              title: Text('Ruby'),
              value: _filterRuby,
              onChanged: (value) {
                setState(() {
                  _filterRuby = value!;
                });
              },
            ),
            CheckboxListTile(
              title: Text('Sapphire'),
              value: _filterSapphire,
              onChanged: (value) {
                setState(() {
                  _filterSapphire = value!;
                });
              },
            ),
            CheckboxListTile(
              title: Text('SandStone'),
              value: _filtersandstone,
              onChanged: (value) {
                setState(() {
                  _filtersandstone = value!;
                });
              },
            ),
            CheckboxListTile(
              title: Text('Serpentine'),
              value: _filterSerpentine,
              onChanged: (value) {
                setState(() {
                  _filterSerpentine = value!;
                });
              },
            ),
            CheckboxListTile(
              title: Text('Sodalite'),
              value: _filterSodalite,
              onChanged: (value) {
                setState(() {
                  _filterSodalite = value!;
                });
              },
            ),
            CheckboxListTile(
              title: Text('Spessartite'),
              value: _filterSpessartite,
              onChanged: (value) {
                setState(() {
                  _filterSpessartite = value!;
                });
              },
            ),
            CheckboxListTile(
              title: Text('Sphene'),
              value: _filterSphene,
              onChanged: (value) {
                setState(() {
                  _filterSphene = value!;
                });
              },
            ),
            CheckboxListTile(
              title: Text('Sunstone'),
              value: _filterSunstone,
              onChanged: (value) {
                setState(() {
                  _filterSunstone = value!;
                });
              },
            ),
            CheckboxListTile(
              title: Text('Tanzanite'),
              value: _filterTanzanite,
              onChanged: (value) {
                setState(() {
                  _filterTanzanite = value!;
                });
              },
            ),
            CheckboxListTile(
              title: Text('Tigers Eye'),
              value: _filterTigersEye,
              onChanged: (value) {
                setState(() {
                  _filterTigersEye = value!;
                });
              },
            ),
            CheckboxListTile(
              title: Text('Topaz'),
              value: _filterTopaz,
              onChanged: (value) {
                setState(() {
                  _filterTopaz = value!;
                });
              },
            ),
            CheckboxListTile(
              title: Text('Tourmaline'),
              value: _filterTourmaline,
              onChanged: (value) {
                setState(() {
                  _filterTourmaline = value!;
                });
              },
            ),
            CheckboxListTile(
              title: Text('Tsavorite'),
              value: _filterTsavorite,
              onChanged: (value) {
                setState(() {
                  _filterTsavorite = value!;
                });
              },
            ),
            CheckboxListTile(
              title: Text('Turquoise'),
              value: _filterTurquoise,
              onChanged: (value) {
                setState(() {
                  _filterTurquoise = value!;
                });
              },
            ),
            CheckboxListTile(
              title: Text('Variscite'),
              value: _filterVariscite,
              onChanged: (value) {
                setState(() {
                  _filterVariscite = value!;
                });
              },
            ),
            CheckboxListTile(
              title: Text('Zircon'),
              value: _filterZircon,
              onChanged: (value) {
                setState(() {
                  _filterZircon = value!;
                });
              },
            ),
            CheckboxListTile(
              title: Text('Zoisite'),
              value: _filterZoisite,
              onChanged: (value) {
                setState(() {
                  _filterZoisite = value!;
                });
              },
            ),

//
//
//
//
          ],
        ),
      ),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: currentLocation,
          zoom: 10,
        ),
        markers: markers,
        onMapCreated: (controller) {
          mapController = controller;
        },
      ),
    );
  }
}
