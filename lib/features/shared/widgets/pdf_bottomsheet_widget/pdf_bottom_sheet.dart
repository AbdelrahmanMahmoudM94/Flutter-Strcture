import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../common/helper/view_toolbox.dart';
import 'pdf_cubit.dart'; // Import your cubit

// USAGE EXAMPLE:
/*
ElevatedButton(
  onPressed: () {
    showPDFBottomSheet(
      context,
      'assets/sample.pdf',
      bottomSheetHeight: 0.85,
    );
  },
  child: const Text("Show Local PDF"),
)
*/
void showPDFBottomSheet(BuildContext context, String pdfPath,
    {bool isScrollable = true, double bottomSheetHeight = 300}) {
  ViewsToolbox.showBottomSheet(
      context: context,
      customWidget: Container(
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        height: 600.h,
        child: BlocProvider(
          create: (BuildContext context) => PDFCubit()..loadPDF(pdfPath),
          child: BlocBuilder<PDFCubit, PDFState>(
            builder: (BuildContext context, PDFState state) {
              if (state is PDFLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is PDFLoaded) {
                return PDFView(
                  gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>{},
                  filePath: state.filePath,
                  enableSwipe: true,
                  swipeHorizontal: true,
                  autoSpacing: false,
                  pageFling: true,
                );
              } else if (state is PDFError) {
                return Center(child: Text('Error: ${state.errorMessage}'));
              } else {
                return const Center(child: Text('No PDF loaded'));
              }
            },
          ),
        ),
      ));
}
