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
  bool _filterall = true;
  bool _filterAlexandrite = true;
  bool _filterAlmandine = true;
  bool _filterAmazonite = true;
  bool _filterAmber = true;
  bool _filterAmethyst = true;
  bool _filterAmetrine = true;
  bool _filterAndalusite = true;
  bool _filterAndradite = true;
  bool _filterAquamarine = true;
  bool _filterAventurineGreen = true;
  bool _filterAventurineYellow = true;
  bool _filterBenitoite = true;
  bool _filterBerylGolden = true;
  bool _filterBixbite = true;
  bool _filterBloodstone = true;
  bool _filterCatsEye = true;
  bool _filterChalcedonyBlue = true;
  bool _filterChromeDiopside = true;
  bool _filterChrysoberyl = true;
  bool _filterChrysocolla = true;
  bool _filterChrysoprase = true;
  bool _filterCitrine = true;
  bool _filterCoral = true;
  bool _filterDanburite = true;
  bool _filterDiamond = true;
  bool _filterDiaspore = true;
  bool _filterDumortierite = true;
  bool _filterEmerald = true;
  bool _filterFluorite = true;
  bool _filterGarnetRed = true;
  bool _filterGoshenite = true;
  bool _filterGrossular = true;
  bool _filterHessonite = true;
  bool _filterHiddenite = true;
  bool _filterIolite = true;
  bool _filterJade = true;
  bool _filterKunzite = true;
  bool _filterKyanite = true;
  bool _filterLabradorite = true;
  bool _filterLapisLazuli = true;
  bool _filterLarimar = true;
  bool _filterMalachite = true;
  bool _filterMoonstone = true;
  bool _filterMorganite = true;
  bool _filterOnyxBlack = true;
  bool _filterOpal = true;
  bool _filterPearl = true;
  bool _filterPeridot = true;
  bool _filterPyrite = true;
  bool _filterPyrope = true;
  bool _filterQuartzSmoky = true;
  bool _filterRhodochrosite = true;
  bool _filterRhodolite = true;
  bool _filterRhodonite = true;
  bool _filterRuby = true;
  bool _filterSapphire = true;
  bool _filterSerpentine = true;
  bool _filterSodalite = true;
  bool _filterSpessartite = true;
  bool _filterSphene = true;
  bool _filterSunstone = true;
  bool _filterTanzanite = true;
  bool _filterTigersEye = true;
  bool _filterTopaz = true;
  bool _filterTourmaline = true;
  bool _filterTsavorite = true;
  bool _filterTurquoise = true;
  bool _filterVariscite = true;
  bool _filterZircon = true;
  bool _filterZoisite = true;
  bool _filteragate = true;
  bool _filterbasalt = true;
  bool _filtercoal = true;
  bool _filtergarnet = true;
  bool _filtergranite = true;
  bool _filterlimestone = true;
  bool _filtersandstone = true;

  
  void setAllFiltersFalse(){
  _filterAlexandrite = false;
  _filterAlmandine = false;
  _filterAmazonite = false;
  _filterAmber = false;
  _filterAmethyst = false;
  _filterAmetrine = false;
  _filterAndalusite = false;
  _filterAndradite = false;
  _filterAquamarine = false;
  _filterAventurineGreen = false;
  _filterAventurineYellow = false;
  _filterBenitoite = false;
  _filterBerylGolden = false;
  _filterBixbite = false;
  _filterBloodstone = false;
  _filterCatsEye = false;
  _filterChalcedonyBlue = false;
  _filterChromeDiopside = false;
  _filterChrysoberyl = false;
  _filterChrysocolla = false;
  _filterChrysoprase = false;
  _filterCitrine = false;
  _filterCoral = false;
  _filterDanburite = false;
  _filterDiamond = false;
  _filterDiaspore = false;
  _filterDumortierite = false;
  _filterEmerald = false;
  _filterFluorite = false;
  _filterGarnetRed = false;
  _filterGoshenite = false;
  _filterGrossular = false;
  _filterHessonite = false;
  _filterHiddenite = false;
  _filterIolite = false;
  _filterJade = false;
  _filterKunzite = false;
  _filterKyanite = false;
  _filterLabradorite = false;
  _filterLapisLazuli = false;
  _filterLarimar = false;
  _filterMalachite = false;
  _filterMoonstone = false;
  _filterMorganite = false;
  _filterOnyxBlack = false;
  _filterOpal = false;
  _filterPearl = false;
  _filterPeridot = false;
  _filterPyrite = false;
  _filterPyrope = false;
  _filterQuartzSmoky = false;
  _filterRhodochrosite = false;
  _filterRhodolite = false;
  _filterRhodonite = false;
  _filterRuby = false;
  _filterSapphire = false;
  _filterSerpentine = false;
  _filterSodalite = false;
  _filterSpessartite = false;
  _filterSphene = false;
  _filterSunstone = false;
  _filterTanzanite = false;
  _filterTigersEye = false;
  _filterTopaz = false;
  _filterTourmaline = false;
  _filterTsavorite = false;
  _filterTurquoise = false;
  _filterVariscite = false;
  _filterZircon = false;
  _filterZoisite = false;
  _filteragate = false;
  _filterbasalt = false;
  _filtercoal = false;
  _filtergarnet = false;
  _filtergranite = false;
  _filterlimestone = false;
  _filtersandstone = false;
  }

  void setAllFiltersTrue(){
    _filterAlexandrite = true;
  _filterAlmandine = true;
  _filterAmazonite = true;
  _filterAmber = true;
  _filterAmethyst = true;
  _filterAmetrine = true;
  _filterAndalusite = true;
  _filterAndradite = true;
  _filterAquamarine = true;
  _filterAventurineGreen = true;
  _filterAventurineYellow = true;
  _filterBenitoite = true;
  _filterBerylGolden = true;
  _filterBixbite = true;
  _filterBloodstone = true;
  _filterCatsEye = true;
  _filterChalcedonyBlue = true;
  _filterChromeDiopside = true;
  _filterChrysoberyl = true;
  _filterChrysocolla = true;
  _filterChrysoprase = true;
  _filterCitrine = true;
  _filterCoral = true;
  _filterDanburite = true;
  _filterDiamond = true;
  _filterDiaspore = true;
  _filterDumortierite = true;
  _filterEmerald = true;
  _filterFluorite = true;
  _filterGarnetRed = true;
  _filterGoshenite = true;
  _filterGrossular = true;
  _filterHessonite = true;
  _filterHiddenite = true;
  _filterIolite = true;
  _filterJade = true;
  _filterKunzite = true;
  _filterKyanite = true;
  _filterLabradorite = true;
  _filterLapisLazuli = true;
  _filterLarimar = true;
  _filterMalachite = true;
  _filterMoonstone = true;
  _filterMorganite = true;
  _filterOnyxBlack = true;
  _filterOpal = true;
  _filterPearl = true;
  _filterPeridot = true;
  _filterPyrite = true;
  _filterPyrope = true;
  _filterQuartzSmoky = true;
  _filterRhodochrosite = true;
  _filterRhodolite = true;
  _filterRhodonite = true;
  _filterRuby = true;
  _filterSapphire = true;
  _filterSerpentine = true;
  _filterSodalite = true;
  _filterSpessartite = true;
  _filterSphene = true;
  _filterSunstone = true;
  _filterTanzanite = true;
  _filterTigersEye = true;
  _filterTopaz = true;
  _filterTourmaline = true;
  _filterTsavorite = true;
  _filterTurquoise = true;
  _filterVariscite = true;
  _filterZircon = true;
  _filterZoisite = true;
  _filteragate = true;
  _filterbasalt = true;
  _filtercoal = true;
  _filtergarnet = true;
  _filtergranite = true;
  _filterlimestone = true;
  _filtersandstone = true;
  }


  Future<void> createMarkers(QuerySnapshot snapshot) async {
    setState(() {
       markers.clear();//Clear previous markers to avoid duplication
      });

    Map<String, bool> filterMap = {
    'alexandrite': _filterAlexandrite,
    'almandine': _filterAlmandine,
    'amazonite': _filterAmazonite,
    'amber': _filterAmber,
    'amethyst': _filterAmethyst,
    'ametrine': _filterAmetrine,
    'andalusite': _filterAndalusite,
    'andradite': _filterAndradite,
    'aquamarine': _filterAquamarine,
    'aventurine green': _filterAventurineGreen,
    'aventurine yellow': _filterAventurineYellow,
    'benitoite': _filterBenitoite,
    'beryl golden': _filterBerylGolden,
    'bixbite': _filterBixbite,
    'bloodstone': _filterBloodstone,
    'cats eye': _filterCatsEye,
    'chalcedony blue': _filterChalcedonyBlue,
    'chrome diopside': _filterChromeDiopside,
    'chrysoberyl': _filterChrysoberyl,
    'chrysocolla': _filterChrysocolla,
    'chrysoprase': _filterChrysoprase,
    'citrine': _filterCitrine,
    'coral': _filterCoral,
    'danburite': _filterDanburite,
    'diamond': _filterDiamond,
    'diaspore': _filterDiaspore,
    'dumortierite': _filterDumortierite,
    'emerald': _filterEmerald,
    'fluorite': _filterFluorite,
    'garnet red': _filterGarnetRed,
    'goshenite': _filterGoshenite,
    'grossular': _filterGrossular,
    'hessonite': _filterHessonite,
    'hiddenite': _filterHiddenite,
    'iolite': _filterIolite,
    'jade': _filterJade,
    'kunzite': _filterKunzite,
    'kyanite': _filterKyanite,
    'labradorite': _filterLabradorite,
    'lapis lazuli': _filterLapisLazuli,
    'larimar': _filterLarimar,
    'malachite': _filterMalachite,
    'moonstone': _filterMoonstone,
    'morganite': _filterMorganite,
    'onyx black': _filterOnyxBlack,
    'opal': _filterOpal,
    'pearl': _filterPearl,
    'peridot': _filterPeridot,
    'pyrite': _filterPyrite,
    'pyrope': _filterPyrope,
    'quartz smoky': _filterQuartzSmoky,
    'rhodochrosite': _filterRhodochrosite,
    'rhodolite': _filterRhodolite,
    'rhodonite': _filterRhodonite,
    'ruby': _filterRuby,
    'sapphire': _filterSapphire,
    'serpentine': _filterSerpentine,
    'sodalite': _filterSodalite,
    'spessartite': _filterSpessartite,
    'sphene': _filterSphene,
    'sunstone': _filterSunstone,
    'tanzanite': _filterTanzanite,
    'tigers eye': _filterTigersEye,
    'topaz': _filterTopaz,
    'tourmaline': _filterTourmaline,
    'tsavorite': _filterTsavorite,
    'turquoise': _filterTurquoise,
    'variscite': _filterVariscite,
    'zircon': _filterZircon,
    'zoisite': _filterZoisite,
    'agate': _filteragate,
    'basalt': _filterbasalt,
    'coal': _filtercoal,
    'garnet': _filtergarnet,
    'granite': _filtergranite,
    'limestone': _filterlimestone,
    'sandstone': _filtersandstone,
  };

  for (int i = 0; i < snapshot.docs.length; i++) {
    var doc = snapshot.docs[i];
    var data = doc.data() as Map<String, dynamic>;
    String rockClassification = data['ROCK_CLASSIFICATION'].toLowerCase();

    bool shouldAddMarker =
        (_searchText.isEmpty || data['CITY'].toLowerCase().contains(_searchText.toLowerCase().trim())) &&
        filterMap[rockClassification] != false;

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
                    print(value);
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
            CheckboxListTile(
              title: Text('All Rock Types'),
              value: _filterall,
              onChanged: (value) {
                setState(() {
                  _filterall = value!;
                  if(_filterall == true){
                    setAllFiltersTrue();
                  }else{
                    setAllFiltersFalse();
                  }
                });
              },
            ),
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
