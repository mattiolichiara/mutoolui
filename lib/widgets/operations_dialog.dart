import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:mutoolui/widgets/operation_text_box.dart';

import '../utils/constants.dart';
import '../utils/mu_tool_processor.dart';

class OperationsDialog extends StatefulWidget {
  final String value;
  final String filePath;
  final String operationName;
  const OperationsDialog({super.key, required this.value, required this.filePath, required this.operationName});

  @override
  State<OperationsDialog> createState() => _OperationsDialog();
}

class _OperationsDialog extends State<OperationsDialog> {
  TextEditingController operationController = TextEditingController();
  TextEditingController outputController = TextEditingController();
  String operations = "";
  String outputPathName = "output.pdf";
  String? _commandOutput;

  @override
  void initState() {
    outputPathName = generateOutputPath(widget.filePath);
    super.initState();
  }

  @override
  void dispose() {
    operationController.dispose();
    outputController.dispose();
    super.dispose();
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
    return "mutool ${widget.operationName} $operations ${widget.filePath} $outputPathName";
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
                  OperationTextBox(
                    width: size.width*0.4,
                    height: size.height*0.055,
                    hintText: "[Options] Additional Commands",
                    onChanged: (value) {
                      setState(() {
                        operations = value;
                      });
                    },
                    operationController: operationController,
                  ),
                  SizedBox(
                    height: size.height*0.01,
                  ),
                  OperationTextBox(
                    width: size.width*0.4,
                    height: size.height*0.055,
                    hintText: "Output File Path and Filename + [Pages] " r"(e.g. C:\Users\users\Desktop\output.pdf 5)",
                    suffixIcon: openExplorer(),
                    operationController: outputController,
                    onChanged: (value) {
                      setState(() {
                        outputPathName = value;
                      });
                    },
                  ),
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
                  Expanded(
                    child: Center(
                      child: SingleChildScrollView(
                        child: Text(widget.value, style: TextStyle(color: Colors.white, fontSize: size.width*Constants.fontSize, fontWeight: FontWeight.w300)),
                      ),
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