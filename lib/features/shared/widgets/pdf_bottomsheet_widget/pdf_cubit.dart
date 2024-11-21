import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:injectable/injectable.dart';
import 'package:path_provider/path_provider.dart';

@injectable
class PDFCubit extends Cubit<PDFState> {
  PDFCubit() : super(PDFInitial());

  // Load PDF based on path (URL or Asset)
  Future<void> loadPDF(String pdfPath) async {
    emit(PDFLoading());

    try {
      if (pdfPath.startsWith('http')) {
        await loadPDFfromURL(pdfPath);
      } else {
        await loadPDFfromAssets(pdfPath);
      }
    } catch (e) {
      emit(PDFError(e.toString()));
    }
  }

  // Load PDF from assets
  Future<void> loadPDFfromAssets(String assetPath) async {
    final ByteData bytes = await rootBundle.load(assetPath);
    final String dir = (await getApplicationDocumentsDirectory()).path;
    final String path = '$dir/temp_asset.pdf';
    final File file = File(path);
    await file.writeAsBytes(bytes.buffer.asUint8List(), flush: true);

    emit(PDFLoaded(path));
  }

  // Load PDF from a URL
  Future<void> loadPDFfromURL(String url) async {
    final http.Response response = await http.get(Uri.parse(url));
    final String dir = (await getApplicationDocumentsDirectory()).path;
    final String path = '$dir/temp_url.pdf';
    final File file = File(path);
    await file.writeAsBytes(response.bodyBytes, flush: true);

    emit(PDFLoaded(path));
  }
}

class PDFError extends PDFState {
  final String errorMessage;
  PDFError(this.errorMessage);
}

class PDFInitial extends PDFState {}

class PDFLoaded extends PDFState {
  final String filePath;
  PDFLoaded(this.filePath);
}

class PDFLoading extends PDFState {}

// Define States
abstract class PDFState {}
