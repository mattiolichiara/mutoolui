import 'package:desktop_drop/desktop_drop.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mutoolui/widgets/general_button.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../utils/constants.dart';
import '../widgets/general_dialog.dart';
import '../widgets/pdf_preview_dialog.dart';

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
  String? _pdfPath;
  bool _isDragging = false;

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

  void errorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.error_rounded, color: Colors.white),
            const SizedBox(width: 8),
            Expanded(child: Text(message, style: TextStyle(color: Colors.white, fontWeight: FontWeight.w300, fontSize: MediaQuery.of(context).size.width*Constants.fontSize),)),
          ],
        ),
        backgroundColor: Color(0xff19283b),
        duration: const Duration(seconds: 4),
      ),
    );
  }

  void handleFileLoaded(String path) {
    if (!path.toLowerCase().endsWith('.pdf')) {
      //debugPrint('File Not Supported. Load .pfd Files Only.');
      errorSnackBar('File Not Supported. Load PDF Files Only.');
      return;
    }

    setState(() {
      _pdfPath = path;
    });
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

  void showPreviewDialog(BuildContext context, String value) {
    showDialog(
      context: context,
      builder: (context) => PdfPreviewDialog(
        pdfPath: _pdfPath,
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
          return FadeTransition(
            opacity: animation,
            child: child,
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

  void pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
      allowMultiple: false,
    );

    if (result != null) {
      String? path = result.files.single.path;

      if (path != null) {
        handleFileLoaded(path);
      }
    } else {
      debugPrint('No file selected');
      //errorSnackBar('No File Selected.');
    }
  }

  Widget loadedText(Size size) {
    return Row(
      children: [
        Text("File Loaded: ", style: TextStyle(fontSize: size.width * Constants.fontSize, fontWeight: FontWeight.w300,),),

        Tooltip(
          message: _pdfPath!,
          decoration: BoxDecoration(
            color: const Color(0xff19283b),
            borderRadius: BorderRadius.circular(5),
          ),
          textStyle: TextStyle(fontSize: size.width * Constants.fontSize/1.3, fontWeight: FontWeight.w300, color: Colors.white),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: size.width * 0.15,
              minWidth: 0,
            ),
            child: Text(_pdfPath!, overflow: TextOverflow.ellipsis, maxLines: 1,
              style: TextStyle(fontStyle: FontStyle.italic,
                  fontSize: size.width * Constants.fontSize,
                  fontWeight: FontWeight.w300),),
          ),
        ),
      ],
    );
  }

  Widget loadFile(Size size) {
    return (_pdfPath == null) ?
    Column(
      children: [
        Center(child: Text("Load a pdf", style: TextStyle(
            fontWeight: FontWeight.w300,
            fontSize: size.width * (Constants.fontSize * 1.2)),),),
        SizedBox(height: size.width * Constants.spacing / 2,),
        Center(
          child: GeneralButton(value: "Upload",
            infoActive: false,
            hasIcon: Icons.cloud_upload_rounded,
            onPressed: pickFile,
          ),
        ),
      ],
    ) :
    Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(icon: SvgPicture.asset("assets/images/pdf-svgrepo-com.svg", width: size.width*Constants.iconsSize), onPressed: () {showPreviewDialog(context, _pdfPath!);},),
        loadedText(size),
        SizedBox(width: size.width*0.003,),
        IconButton(onPressed: () {
          setState(() {
            _pdfPath = null;
          });
        }, icon: Icon(Icons.close, color: Colors.red.shade400, size: size.width*Constants.iconsSize,),)
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

  Widget scaffoldBody(Size size) {
    return Padding(
      padding: EdgeInsets.all(size.width * Constants.spacing / 2),
      child: SingleChildScrollView(
        child: content(size),
      ),
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
              fontSize: size.width * Constants.fontSize * 1.5
          ),),
      ),
      body: DropTarget(
        onDragEntered: (drag) {
          setState(() {
            _isDragging = true;
          });
        },
        onDragExited: (drag) {
          setState(() {
            _isDragging = false;
          });
        },
        onDragDone: (drag) {
          setState(() {
            _isDragging = false;
            if (drag.files.isNotEmpty) {
              handleFileLoaded(drag.files.first.path);
            }
          });
        },
        child: Stack(
          children: [
            scaffoldBody(size),
            _isDragging ?
                Container(
                  width: size.width,
                  height: size.height,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.lightBlueAccent.withAlpha(50), width: 2),
                    color: Color(0xff263A50).withAlpha(170),
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                  ),
                  child: Row(
                    spacing: size.width*0.01,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.all_inbox_rounded, color: Colors.white, size: size.width*Constants.iconsSize*2.5,),
                      Text("Drag Here to Upload", style: TextStyle(color: Colors.white, fontSize: size.width*Constants.fontSize*3, fontWeight: FontWeight.w300),),
                    ],
                  ),
                )
                : Container(),
          ],
        ),
      ),
    );
  }
}