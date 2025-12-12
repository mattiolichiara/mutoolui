import 'dart:async';
import 'dart:io';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pdfrx/pdfrx.dart';

import '../utils/constants.dart';

class PdfPreviewDialog extends StatefulWidget {
  final String? pdfPath;
  const PdfPreviewDialog({super.key, required this.pdfPath});

  @override
  State<PdfPreviewDialog> createState() => _PdfPreviewDialog();
}

class _PdfPreviewDialog extends State<PdfPreviewDialog> {
  final PdfViewerController _pdfController = PdfViewerController();
  final TextEditingController _passwordController = TextEditingController();
  double _currentZoom = 1;
  bool _isZooming = false;
  Timer? _zoomTimer;
  bool _isScrolling = false;
  int _currentPage = 1;
  Timer? _scrollTimer;
  double? _pageWidth;
  double? _pageHeight;
  static const pageErrorHeight = 0.12;
  static const pageErrorWidth = 0.16;
  bool obscureText = true;
  Completer<String?>? _passwordCompleter;
  bool _showPasswordInput = false;
  bool _passwordAttempted = false;
  String? _errorMessage;
  double? _targetPageWidth;
  double? _targetPageHeight;

  // @override
  // void initState() {
  //   super.initState();
  //   //_loadPdfSize();
  // }@TODO ridimensionare il dialog dopo l'inserimento della password corretta + loading per evitare che si veda la finestra di fallback
  //@TODO gestire la password in modifica
  //@TODO gestire la porcodio di responsiveness di TUTTO
  //@TODO fixare il layout della madonna di cristo di password

  @override
  void dispose() {
    _zoomTimer?.cancel();
    _scrollTimer?.cancel();
    if (_passwordCompleter != null && !_passwordCompleter!.isCompleted) {
      _passwordCompleter!.complete(null);
    }
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadPdfSize();
  }

  Widget eyecon(Size size) {
    return IconButton(
        onPressed: () {
            setState(() {
              obscureText = !obscureText;
            });
        },
        icon: Icon(obscureText ? Icons.visibility : Icons.visibility_off, color: Colors.white, size: size.width*Constants.iconsSize/1.8));
  }

  Future<String?> _requestPasswordProvider() {
    Size size = MediaQuery.of(context).size;
    final completer = Completer<String?>();

    setState(() {
      _passwordCompleter = completer;
      _showPasswordInput = true;
      _errorMessage = _passwordAttempted ? "Incorrect Password." : null;

      _pageWidth = size.width * pageErrorWidth;
      _pageHeight = size.width * pageErrorHeight;
    });

    return completer.future;
  }

  void _submitPassword() {
    final String password = _passwordController.text;

    if (_passwordCompleter != null && !_passwordCompleter!.isCompleted) {

      _passwordCompleter!.complete(password);

      setState(() {
        _showPasswordInput = false;
        _passwordController.clear();
        _passwordAttempted = true;
      });
    }
  }

  Widget _passwordOverlay() {
    Size size = MediaQuery.of(context).size;

    return Center(
      child: SizedBox(
        width: size.width*0.11,
        height: size.height*0.25,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Enter Password:", style: TextStyle(color: Colors.white,
                fontWeight: FontWeight.w300,
                fontSize: size.width * Constants.fontSize)),
            TextFormField(
              enabled: true,
              controller: _passwordController,
              obscureText: obscureText,
              decoration: InputDecoration(
                border: UnderlineInputBorder(
                ),
                suffixIcon: eyecon(size),
                hintStyle: TextStyle(color: Colors.white, fontWeight: FontWeight.w300, fontSize: size.width * Constants.fontSize)),
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.w300, fontSize: size.width * Constants.fontSize),
            ),

            if (_passwordAttempted)
              Padding(padding: const EdgeInsets.only(top: 5.0),
                child: Text(_errorMessage!, style: TextStyle(color: Colors.red, fontWeight: FontWeight.w300, fontSize: size.width * Constants.fontSize*0.8,),
                  textAlign: TextAlign.center,
                ),
              ),

            SizedBox(height: size.height*0.02,),
            Container(
              width: size.width*0.05,
              height: size.height*0.04,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(5)),
                border: BoxBorder.all(
                  color: Colors.white,
                )
              ),
              child: TextButton(
                style: ButtonStyle(
                  shape: WidgetStatePropertyAll(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    )
                  )
                ),
                onPressed: _submitPassword,
                child: Text("Submit", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w300, fontSize: size.width * Constants.fontSize)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _loadPdfSize() async {
    Size size = MediaQuery.of(context).size;

    if (widget.pdfPath == null) return;
    try {
      final doc = await PdfDocument.openFile(widget.pdfPath!);
      final page = doc.pages.first;
      await page.ensureLoaded();

      final calculatedWidth = page.width;
      final calculatedHeight = page.height;
      setState(() {
        // _pageWidth = /*(page.width >= size.width*0.36) ? size.width*0.36 : page.width;*/page.width;
        // _pageHeight = /*(page.height >= size.height*0.95) ? size.height*0.95 : page.height;*/page.height;
        // debugPrint("Page Width: ${page.width}");
        // debugPrint("Page Height: ${page.width}");
        // debugPrint("My Width: ${size.width*0.36}");
        // debugPrint("My Height: ${size.height*0.95}");

        _pageWidth = calculatedWidth;
        _pageHeight = calculatedHeight;

        _targetPageWidth = calculatedWidth;
        _targetPageHeight = calculatedHeight;
      });
    } catch (e) {
      setState(() {
        _pageWidth = null;
        _pageHeight = null;
        _targetPageWidth = size.width * 0.36;
        _targetPageHeight = size.height * 0.95;
      });
    }
  }

  void _handlePointerSignal(PointerSignalEvent event) {
    if (event is PointerScrollEvent) {
      if (event.kind == PointerDeviceKind.mouse &&
          HardwareKeyboard.instance.isControlPressed) {

        if (_pdfController.pageCount == 0) return;

        double zoomDelta = event.scrollDelta.dy < 0 ? 0.1 : -0.1;

        _zoomTimer?.cancel();

        setState(() {
          double newZoom = _currentZoom + zoomDelta;
          newZoom = (newZoom * 100).round() / 100;
          _currentZoom = newZoom.clamp(0.5, 3.0);
          _isZooming = true;
          //debugPrint("Is Zooming: $_isZooming");
        });

        _zoomTimer = Timer(const Duration(milliseconds: 1000), () {
          setState(() {
            _isZooming = false;
            //debugPrint("Is Zooming: $_isZooming");
          });
        });

        _pdfController.setZoom(_pdfController.centerPosition, _currentZoom);
      }
    }
  }

  void _handlePageScroll(int pageNumber) {
    if(pageNumber == -1) {
      _isScrolling = false;
      return;
    }

    _scrollTimer?.cancel();

    setState(() {
      _currentPage = pageNumber;
      _isScrolling = true;
      //debugPrint("Is Scrolling: $_isScrolling");
    });

    _scrollTimer = Timer(const Duration(milliseconds: 1000), () {
      setState(() {
        _isScrolling = false;
        //debugPrint("Is Scrolling: $_isScrolling");
      });
    });
  }

  Widget zoomOverlay(Size size) {
    return _isZooming ?
    Positioned(
      right: 20,
      top: 20,
      child: Container(
          decoration: BoxDecoration(
            color: const Color(0xff19283b).withAlpha(200),
            borderRadius: BorderRadius.circular(5),
          ),
          child: Padding(
            padding: EdgeInsetsGeometry.all(10),
            child: Text("${(_currentZoom*100).toInt()}%", style: TextStyle(color: Colors.white, fontSize: size.width*Constants.fontSize, fontWeight: FontWeight.w300),),
          )
      ),
    )
    :
    SizedBox.shrink();
  }

  Widget pageOverlay(Size size) {
    return _isScrolling ?
    Positioned(
      right: 20,
      top: 20,
      child: Container(
          decoration: BoxDecoration(
            color: const Color(0xff19283b).withAlpha(200),
            borderRadius: BorderRadius.circular(5),
          ),
          child: Padding(
            padding: EdgeInsetsGeometry.all(10),
            child: Text("$_currentPage", style: TextStyle(color: Colors.white, fontSize: size.width*Constants.fontSize, fontWeight: FontWeight.w300),),
          )
      ),
    )
        :
    SizedBox.shrink();
  }

  Widget pdfError(Size size) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(Icons.error_outline, color: Colors.white, size: size.width*Constants.fontSize*4,),
        SizedBox(height: size.width*0.01,),
        Text("Failed to Load PDF Document.", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w300, fontSize: size.width*Constants.fontSize*1.2)),
      ],
    );
  }

  // Widget pdfError(Size size) {
  //   return Center(
  //     child: Text("Preview Error", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w300, fontSize: size.width*Constants.fontSize),),
  //   );
  // }

  Widget pfdViewer(Size size) {
    return Listener(
      onPointerSignal: _handlePointerSignal,
      child: Center(
        child: PdfViewer.file(
          widget.pdfPath!, useProgressiveLoading: true, initialPageNumber: 0, controller: _pdfController,
          passwordProvider: _requestPasswordProvider,
          params: PdfViewerParams(
            onDocumentChanged: (doc) {
              if (doc != null && mounted) {
                setState(() {
                  _pageWidth = _targetPageWidth;
                  _pageHeight = _targetPageHeight;
                });
              }
            },
            backgroundColor: const Color(0xff19283b),
            maxScale: 200,
            minScale: 1,
            scrollByMouseWheel: 2,
            enableKeyboardNavigation: true,
            errorBannerBuilder: (context, error, stackTrace, docRef) {
              if(error is PdfPasswordException) {

                setState(() {
                  _pageHeight = size.width*pageErrorHeight;
                  _pageWidth = size.width*pageErrorWidth;
                });
              }
              return pdfError(size);
            },
            calculateInitialZoom: (PdfDocument doc, PdfViewerController controller, double viewerWidth, double viewerHeight) {
              return 1.0;
            },
            scrollByArrowKey: 250,
            textSelectionParams: PdfTextSelectionParams(
              enabled: false,
            ),
            onPageChanged: (page) {
              _handlePageScroll(page ?? -1);
            },
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Dialog(
      child: Container(
        width: _pageWidth ?? size.width*0.36,
        height: _pageHeight ?? size.height*0.95,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: const Color(0xff19283b),
        ),
        child: Padding(
            padding: EdgeInsets.all(15),
            child: Stack(
              children: [
                pfdViewer(size),
                if(_showPasswordInput) _passwordOverlay(),
                zoomOverlay(size),
                pageOverlay(size),
              ],
            )
        ),
      ),
    );
  }
}