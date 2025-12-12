import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:mutoolui/widgets/operation_text_box.dart';

import '../utils/constants.dart';
import '../utils/mu_tool_processor.dart';

class PosterDialog extends StatefulWidget {
  final String value;
  final String filePath;

  const PosterDialog({super.key, required this.value, required this.filePath});

  @override
  State<PosterDialog> createState() => _PosterDialog();
}

class _PosterDialog extends State<PosterDialog> {
  TextEditingController operationController = TextEditingController();
  TextEditingController xController = TextEditingController();
  TextEditingController yController = TextEditingController();
  TextEditingController outputController = TextEditingController();
  bool enabled = true;
  String operations = "";
  String outputPathName = "output.pdf";
  String? _commandOutput;

  @override
  void initState() {
    super.initState();
    xController.text = "0";
    yController.text = "0";
    outputPathName = generateOutputPath(widget.filePath);
  }

  @override
  void dispose() {
    operationController.dispose();
    outputController.dispose();
    xController.dispose();
    yController.dispose();
    super.dispose();
  }

  String generateOutputPath(String path) {
    String normalizedPath = path.replaceAll('\\', '/');
    int lastSeparatorIndex = normalizedPath.lastIndexOf('/');
    if (lastSeparatorIndex == -1) {
      return '.${Platform.pathSeparator}output.pdf';
    }

    String parentPath = normalizedPath.substring(0, lastSeparatorIndex);
    String separator;

    if (path.contains('\\')) {
      parentPath = parentPath.replaceAll('/', '\\');
      separator = '\\';
    } else {
      separator = '/';
    }

    if (parentPath.isEmpty && path.startsWith('/')) {
      parentPath = '/';
    } else if (parentPath.isEmpty) {
      parentPath = '.';
    }

    if (!parentPath.endsWith(separator)) {
      parentPath += separator;
    }

    return "${parentPath}output.pdf";
  }

  Future<void> _executeCommand() async {
    final fullCommandString = commandStringBuilder();
    final parts = fullCommandString.split(' ').where((s) => s.isNotEmpty).toList();

    if (parts.isEmpty ||
        (parts[0] != "mutool" && parts[0] != "mutool.exe")) {
      setState(() { _commandOutput = "Error: Command String must start with 'mutool'."; });
      return;
    }
    final List<String> arguments = parts.sublist(1);

    setState(() {
      _commandOutput = "Running: mutool ${arguments.join(' ')}...";
    });

    try {
      final ProcessResult result = await runExternalApp(arguments);

      if (result.exitCode == 0) {
        setState(() {
          _commandOutput = "Success (Exit Code 0).\n\n ${(result.stdout != null && result.stdout != "") ? "Output: ${result.stdout}" : ""} ${(result.stderr != null && result.stderr != "") ? "Error: ${result.stderr}" : ""}";
        });
      } else {
        final stdoutMessage = result.stdout.toString().isNotEmpty ? "Output: ${result.stdout}\n" : "";
        _commandOutput = "RUNTIME ERROR (Code ${result.exitCode}):\n${stdoutMessage}Error:\n${result.stderr}";
        debugPrint("Error: ${result.stderr}");
      }
    } catch (e) {
      setState(() {
        _commandOutput = "FATAL ERROR: Unable to start process.\n$e";
      });
    }
  }

  Widget addSubtractButtons(Size size, TextEditingController controller) {
    final iconColor = Colors.white;
    final iconSize = Constants.iconsSize*1200;
    final buttonHeight = size.height*0.03;
    final buttonWidth = size.width*0.025;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          height: buttonHeight,
          width: buttonWidth,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(5)),
            //color: Colors.grey.withAlpha(20),
          ),
          child: IconButton(
            icon: Icon(Icons.keyboard_arrow_up_rounded, color: iconColor,
              size: iconSize,),
            onPressed: () {
              final num = int.tryParse(controller.text);
              if(num == null) {
                setState(() {
                  controller.text = "0";
                });
              } else {
                setState(() {
                  controller.text = (num+1).toString();
                });
              }
            },
          ),
        ),
        Container(
          height: buttonHeight,
          width: buttonWidth,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(5)),
            //color: Colors.grey.withAlpha(20),
          ),
          child: IconButton(
            icon: Icon(Icons.keyboard_arrow_down_rounded, color: iconColor,
              size: iconSize),
            onPressed: () {
              final num = int.tryParse(controller.text);
              if(num == null) {
                setState(() {
                  controller.text = "0";
                });
              } else {
                if(num>0) {
                  setState(() {
                    controller.text = (num-1).toString();
                  });
                }
              }
            },
          ),
        ),
      ],
    );
  }

  Widget xBoxWinkWink(Size size, String text, TextEditingController controller) {
    return SizedBox(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(text, style: TextStyle(color: Colors.white, fontWeight: FontWeight.w300, fontSize: size.width * Constants.fontSize*1.1),),
          SizedBox(width: size.width*0.0061,),
          OperationTextBox(
            height: size.height*0.05,
            width: size.width*0.08,
            enabled: enabled,
            operationController: controller,
            onChanged: (value) {
              final num = int.tryParse(value);

              setState(() {
                if(num == null || value.isEmpty || num < 0) {
                  controller.text = "0";
                }
              });
            },
          ),
          //SizedBox(width: size.width*0.007,),
          addSubtractButtons(size, controller),
        ],
      ),
    );
  }

  Widget xBoxWrapper(Size size) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Transform.scale(
          scale: 0.8,
          child: Checkbox(value: enabled, onChanged: (value) {
            setState(() {
              enabled = value!;
            });
            // debugPrint("Enabled: $enabled + Value: $value");
          }),
        ),
        // SizedBox(width: size.width*0.005,),
        xBoxWinkWink(size, "X", xController),
        SizedBox(width: size.width*0.03,),
        xBoxWinkWink(size, "Y", yController),
      ],
    );
  }

  Widget submitButton(Size size) {
    return Container(
        width: size.width*0.06,
        height: size.height*0.05,
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
          onPressed: _executeCommand,
          child: Text("Submit", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w300, fontSize: size.width * Constants.fontSize)),
        ),
    );
  }

  String commandStringBuilder() {
    return "mutool poster${enabled ? " -x ${xController.text} -y ${yController.text}" : ""} $operations ${widget.filePath} $outputPathName";
  }

  Widget commandTextBuilder(String command, Size size) {
    final baseTextStyle = TextStyle(
      fontWeight: FontWeight.w300,
      fontSize: size.width * Constants.fontSize * 1.1,
    );

    return Align(
      alignment: Alignment.centerLeft,
      child: SizedBox(
        width: size.width * 0.38,
        child: Tooltip(
          message: commandStringBuilder(),
          decoration: BoxDecoration(
            color: const Color(0xff2A3D54),
            borderRadius: BorderRadius.circular(5),
          ),
          textStyle: TextStyle(fontSize: size.width * Constants.fontSize*1.03, fontWeight: FontWeight.w400, color: Colors.white, fontStyle: FontStyle.italic),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Text(
              command,
              style: baseTextStyle.copyWith(color: Colors.white70, fontStyle: FontStyle.italic),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ),
        ),
      ),
    );
  }

  Widget outputResponse(Size size) {
    return Align(
      alignment: Alignment.centerLeft,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          minHeight: 0,
          maxHeight: size.height*0.3,
        ),
        child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Text(_commandOutput!, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: size.width * Constants.fontSize*1.03, fontWeight: FontWeight.w400, color: Colors.purpleAccent, fontStyle: FontStyle.italic),),
            )
        ),
    );
  }

  Future<void> selectFolderAndGetPath() async {
    String? selectedDirectory = await FilePicker.platform.getDirectoryPath();

    if (selectedDirectory != null) {
      setState(() {
        outputPathName = selectedDirectory;
        outputController.text = outputPathName;
      });

      debugPrint('Percorso della cartella selezionato: $outputPathName');
    } else {
      debugPrint('Selezione cartella annullata.');
    }
  }

  Widget openExplorer() {
    return IconButton(
      icon: Icon(Icons.folder_open_rounded, color: Colors.white, size: Constants.iconsSize*2000,),
      onPressed: () {
        selectFolderAndGetPath();
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Dialog(
      child: IntrinsicWidth(
          child: IntrinsicHeight(
            child: Container(
              // width: size.width*0.5,
              // height: size.height*0.8,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: const Color(0xff19283b),
              ),
              child: Padding(
                padding: EdgeInsets.all(35),
                child: Column(
                  children: [
                    xBoxWrapper(size),
                    SizedBox(
                      height: size.height*0.06,
                    ),
                    OperationTextBox(
                      width: size.width*0.4,
                      height: size.height*0.055,
                      hintText: "[Options] Additional Commands",
                      operationController: operationController,
                      onChanged: (value) {
                        setState(() {
                          operations = value;
                        });
                      },),
                    SizedBox(
                      height: size.height*0.01,
                    ),
                    OperationTextBox(
                      width: size.width*0.4,
                      height: size.height*0.055,
                      hintText: "Output File Path and Filename " r"(e.g. C:\Users\users\Desktop\output.pdf)",
                      operationController: outputController,
                      suffixIcon: openExplorer(),
                      onChanged: (value) {
                        setState(() {
                          outputPathName = value;
                        });
                      },),
                    SizedBox(
                      height: size.height*0.015,
                    ),
                    commandTextBuilder(commandStringBuilder(), size),
                    SizedBox(
                      height: size.height*0.001,
                    ),
                    _commandOutput != null ? outputResponse(size) : Container(),
                    SizedBox(
                      height: size.height*0.04,
                    ),
                    submitButton(size),
                    SizedBox(
                      height: size.height*0.04,
                    ),
                    Center(
                      child: SingleChildScrollView(
                        child: Text(widget.value, style: TextStyle(color: Colors
                            .white, fontSize: size.width * Constants.fontSize, fontWeight: FontWeight.w300)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
      ),
    );
  }
}