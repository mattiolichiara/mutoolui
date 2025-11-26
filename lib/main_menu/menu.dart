import 'package:flutter/material.dart';
import 'package:mutoolui/widgets/general_button.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../utils/constants.dart';
import '../widgets/general_dialog.dart';

class MenuItem {
  final String value;
  final String? dialogOption;
  bool isFavourite;
  final bool infoActive;

  MenuItem({required this.value, this.dialogOption, this.isFavourite = false, this.infoActive = true,});
}

class Menu extends StatefulWidget {
  const Menu({super.key});

  @override
  State<Menu> createState() => _Menu();
}

class _Menu extends State<Menu> {
  late List<MenuItem> _allButtons;
  late List<MenuItem> _orderedButtons;
  static const String _favoriteKey = 'muToolFavorite';

  @override
  void initState() {
    super.initState();
    _allButtons = [
      MenuItem(value: "Clean - Rewrite PDF File", dialogOption: Constants.cleanOptions),
      MenuItem(value: "Convert - Convert Document", dialogOption: Constants.convertOptions),
      MenuItem(value: "Create - Create PDF Document", dialogOption: Constants.createOptions),
      MenuItem(value: "Draw - Convert Document", dialogOption: Constants.drawOptions),
      MenuItem(value: "Trace - Trace Device Calls", dialogOption: Constants.traceOptions),
      MenuItem(value: "Extract - Extract Font and Image Resources", dialogOption: Constants.extractOptions),
      MenuItem(value: "Info - Show Information About PDF Resources", dialogOption: Constants.infoOptions),
      MenuItem(value: "Merge - Merge Pages from Multiple PDF Sources", dialogOption: Constants.mergeOptions),
      MenuItem(value: "Pages - Show Information About PDF Pages", dialogOption: Constants.pagesOptions),
      MenuItem(value: "Poster - Split Large Page into Many Tiles", dialogOption: Constants.posterOptions),
      MenuItem(value: "Recolor - Change Colorspace of PDF Document", dialogOption: Constants.recolorOptions),
      MenuItem(value: "Sign - Manipulate PDF Digital Signatures", dialogOption: Constants.signOptions),
      MenuItem(value: "Trim - Trim PDF Page Contents", dialogOption: Constants.trimOptions),
      MenuItem(value: "Bake - Bake PDF Form into Static Content", dialogOption: Constants.bakeOptions),
      MenuItem(value: "Run - Run Javascript", dialogOption: null, infoActive: false), // Nessun dialogo info
      MenuItem(value: "Show - Show Internal PDF Objects", dialogOption: Constants.showOptions),
      MenuItem(value: "Audit - Produce Usage Stats from PDF Files", dialogOption: Constants.auditOptions),
      MenuItem(value: "Barcode - Encode/Decode Barcodes", dialogOption: Constants.barcodeOptions),
    ];
    _orderedButtons = List.from(_allButtons);
    _loadAndRestoreFavorite();
  }

  Future<void> _loadAndRestoreFavorite() async {
    final prefs = await SharedPreferences.getInstance();
    final favValue = prefs.getString(_favoriteKey);

    if (favValue == null) return;

    final index = _allButtons.indexWhere((item) => item.value == favValue);
    if(index!=-1) {
      final itemToFavourite = _allButtons[index];
      itemToFavourite.isFavourite = true;

      final nonFavourites = _allButtons.where((item) => !item.isFavourite).toList();
      setState(() {
        _orderedButtons = [itemToFavourite, ...nonFavourites];
      });
    }
  }

  void toggleFavourite(MenuItem tappedItem) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      final isCurrentlyFavourite = tappedItem.isFavourite;

      if (isCurrentlyFavourite) {
        tappedItem.isFavourite = false;
        prefs.remove(_favoriteKey);
        _orderedButtons = List.from(_allButtons);

      } else {
        final currentFavouriteIndex = _allButtons.indexWhere((item) => item.isFavourite);

        if (currentFavouriteIndex != -1) {
          _allButtons[currentFavouriteIndex].isFavourite = false;
        }
        tappedItem.isFavourite = true;
        prefs.setString(_favoriteKey, tappedItem.value);

        final favourite = tappedItem;
        final nonFavourites = _allButtons.where((item) => !item.isFavourite).toList();

        _orderedButtons = [favourite, ...nonFavourites];
      }
    });
  }

  void showGeneralDialog(BuildContext context, String value) {
    showDialog(
      context: context,
      builder: (context) => GeneralDialog(
        value: value,
      ),
      barrierDismissible: true,
    );
  }

  Widget buttonWrapper(Size size) {
    return Padding(
      padding: EdgeInsets.all(20.0),
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 550),

        transitionBuilder: (Widget child, Animation<double> animation) {
          final slideAnimation = Tween<Offset>(
            begin: const Offset(0.0, -0.2),
            end: Offset.zero,
          ).animate(animation);

          return FadeTransition(
            opacity: animation,
            child: SlideTransition(
              position: slideAnimation,
              child: child,
            ),
          );
        },

        child: Wrap(
          key: ValueKey(_orderedButtons.hashCode),
          spacing: size.width * 0.015,
          runSpacing: size.width * 0.015,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: _orderedButtons.map((item) {
            return GeneralButton(value: item.value,
              canBeFavourite: true,
              isFavourite: item.isFavourite,
              onPressed: () {

              },
              onPressedInfo: item.dialogOption != null ? () {
                showGeneralDialog(context, item.dialogOption!);
              } : null,
              onPressedFav: () => toggleFavourite(item),
              infoActive: item.infoActive,
              key: ValueKey(item.value),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget loadFile(Size size) {
    return Column(
      children: [
        Center(child: Text("Load a pdf", style: TextStyle(fontWeight: FontWeight.w300, fontSize: size.width*(Constants.fontSize*1.2)),),),
        SizedBox(height: size.width*Constants.spacing/2,),
        Center(
          child: GeneralButton(value: "Upload", infoActive: false, hasIcon: Icons.cloud_upload_rounded,),
        ),
      ],
    );
  }

  Widget content(Size size) {
    return Column(
      children: [
        SizedBox(height: size.width*Constants.spacing,),
        loadFile(size),
        SizedBox(height: size.width*Constants.spacing,),
        Center(
          child: buttonWrapper(size),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff19283b),
        title: Text("MuTool UI",
          style: TextStyle(
              color: Colors.white70,
              fontWeight: FontWeight.w300,
              fontSize: size.width*Constants.fontSize*1.5
          ),),
      ),
      body: Padding(
          padding: EdgeInsets.all(size.width*Constants.spacing/2),
          child: SingleChildScrollView(
            child: content(size),
          ),
      ),
    );
  }
}