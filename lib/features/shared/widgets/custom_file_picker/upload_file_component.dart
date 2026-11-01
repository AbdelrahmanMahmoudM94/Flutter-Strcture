import 'dart:async';
import 'dart:io';
import 'dart:ui';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'custom_file_picker_cubit.dart';
import 'file_picker_config.dart';
import 'file_picker_converters.dart';
import 'package:dio/dio.dart' show FormData;
import 'file_picker_item.dart';

export 'file_picker_config.dart';
export 'file_picker_converters.dart';
export 'file_picker_item.dart';

/// Attachments form field: a card with a dashed "attach" zone that opens a
/// source sheet (camera, gallery, files), the allowed types and size, and a
/// card per picked file with its size, progress, image preview and remove
/// button. Works inside any [Form]; no app-specific dependencies.
///
/// [T] is the form value, produced by [converter]. Without one, `List<XFile>`
/// (and the types of [FilePickerConverters]) are handled automatically:
/// `List<ImageFileBase64>`, `ImageFileBase64`, `List<FormData>`, `FormData`.
///
/// Pass [filePickerCubit] to share the picker state; otherwise the field
/// creates and closes its own.
class UploadFileComponent<T> extends StatefulWidget {
  const UploadFileComponent({
    super.key,
    this.filePickerCubit,
    this.initialFiles,
    this.onFilesPicked,
    this.onChanged,
    this.onSaved,
    this.converter,
    this.formDataKey = 'file',
    this.isMultiple = true,
    this.isFromCamera = true,
    this.isFromGallery = true,
    this.isFromFile = true,
    this.allowedFileExtensions,
    this.fileSize,
    this.maximumFiles,
    this.isRequired = false,
    this.validator,
    this.autovalidateMode = AutovalidateMode.onUserInteraction,
    this.showOptionalLabel = true,
    this.showProgress = true,
    this.labels = const FilePickerLabels(),
    this.style = const FilePickerStyle(),
    this.onError,
  });

  final CustomFilePickerCubit? filePickerCubit;

  /// Files already on the record; shown as uploaded and never re-sent.
  final List<FilePickerItem>? initialFiles;
  final void Function(List<FilePickerItem> files)? onFilesPicked;

  /// Called with the converted form value whenever the files change.
  final ValueChanged<T?>? onChanged;
  final FormFieldSetter<T>? onSaved;

  /// Builds the form value from the picked files.
  final FilePickerConverter<T>? converter;

  /// Multipart field name used by the built-in `FormData` conversions.
  final String formDataKey;
  final bool isMultiple;
  final bool isFromCamera;
  final bool isFromGallery;
  final bool isFromFile;

  /// Extensions to accept, e.g. `['pdf', 'png']`. Null accepts anything.
  final List<String>? allowedFileExtensions;

  /// Per-file limit in megabytes. Defaults to 5.
  final num? fileSize;
  final int? maximumFiles;
  final bool isRequired;

  /// Extra validation, run after the built-in required check.
  final FormFieldValidator<T>? validator;
  final AutovalidateMode autovalidateMode;
  final bool showOptionalLabel;

  /// Animates a progress bar on newly picked files (cosmetic: the picker
  /// does not upload anything).
  final bool showProgress;
  final FilePickerLabels labels;
  final FilePickerStyle style;

  /// Handle a rejected pick yourself; by default a [SnackBar] is shown.
  final void Function(BuildContext context, FilePickerErrorType type)? onError;

  @override
  State<UploadFileComponent<T>> createState() => _UploadFileComponentState<T>();
}

class _UploadFileComponentState<T> extends State<UploadFileComponent<T>> {
  late final CustomFilePickerCubit _cubit;
  late final bool _ownsCubit;
  List<double> _progress = <double>[];
  Timer? _progressTimer;

  @override
  void initState() {
    super.initState();
    _ownsCubit = widget.filePickerCubit == null;
    _cubit = widget.filePickerCubit ?? CustomFilePickerCubit();
    if (widget.initialFiles != null) {
      _cubit.setFiles(widget.initialFiles);
      _progress = widget.initialFiles!.map((_) => 1.0).toList();
      WidgetsBinding.instance.addPostFrameCallback((_) {
        widget.onFilesPicked?.call(widget.initialFiles!);
      });
    }
  }

  @override
  void dispose() {
    _progressTimer?.cancel();
    if (_ownsCubit) _cubit.close();
    super.dispose();
  }

  bool get _limitReached =>
      widget.maximumFiles != null &&
      _cubit.files.length >= widget.maximumFiles!;

  int get _maxBytes => ((widget.fileSize ?? 5) * 1024 * 1024).toInt();

  Future<void> _openSources() async {
    FocusManager.instance.primaryFocus?.unfocus();
    if (_limitReached) return;
    final List<FilePickerSource> sources = <FilePickerSource>[
      if (widget.isFromCamera) FilePickerSource.camera,
      if (widget.isFromGallery) FilePickerSource.gallery,
      if (widget.isFromFile) FilePickerSource.file,
    ];
    if (sources.isEmpty) return;
    final FilePickerSource? picked = sources.length == 1
        ? sources.first
        : await showModalBottomSheet<FilePickerSource>(
            context: context,
            backgroundColor: Colors.transparent,
            builder: (BuildContext context) =>
                _SourceSheet(sources: sources, labels: widget.labels),
          );
    switch (picked) {
      case FilePickerSource.camera:
        await _cubit.pickCamera(
          maximumFiles: widget.maximumFiles,
          fileSize: _maxBytes,
        );
      case FilePickerSource.gallery:
        await _cubit.pickFile(
          filetype: FileType.image,
          allowMultiple: widget.isMultiple,
          fileSize: _maxBytes,
          maximumFiles: widget.maximumFiles,
        );
      case FilePickerSource.file:
        await _cubit.pickFile(
          filetype: widget.allowedFileExtensions == null
              ? FileType.any
              : FileType.custom,
          allowedExtensions: widget.allowedFileExtensions,
          allowMultiple: widget.isMultiple,
          fileSize: _maxBytes,
          maximumFiles: widget.maximumFiles,
        );
      case null:
        break;
    }
  }

  // Animates the progress bars of newly picked files up to 100%.
  void _simulateProgress(List<FilePickerItem> files) {
    _progress = files
        .map((FilePickerItem e) =>
            e.isUploaded || !widget.showProgress ? 1.0 : 0.0)
        .toList();
    _progressTimer?.cancel();
    if (_progress.every((double p) => p >= 1)) return;
    _progressTimer = Timer.periodic(const Duration(milliseconds: 400), (
      Timer timer,
    ) {
      if (!mounted) return timer.cancel();
      setState(() {
        for (int i = 0; i < _progress.length; i++) {
          _progress[i] = (_progress[i] + 0.2).clamp(0.0, 1.0);
        }
      });
      if (_progress.every((double p) => p >= 1)) timer.cancel();
    });
  }

  // Converts the picked files to the form value type [T].
  T? _toValue(List<FilePickerItem> files) {
    final FilePickerConverter<T>? custom = widget.converter;
    if (custom != null) return custom(files);
    if (files.isEmpty) return null;
    if (T == List<ImageFileBase64>) {
      return FilePickerConverters.base64List(files) as T;
    }
    if (T == ImageFileBase64) {
      return FilePickerConverters.base64(files.first) as T;
    }
    if (T == List<FormData>) {
      return FilePickerConverters.formDataList(key: widget.formDataKey)(files)
          as T;
    }
    if (T == FormData) {
      return FilePickerConverters.singleFormData(key: widget.formDataKey)(files)
          as T;
    }
    return FilePickerConverters.xFiles(files) as T;
  }

  String? _validate(T? value) {
    if (widget.isRequired) {
      final bool empty = value == null || (value is List && value.isEmpty);
      if (empty) return widget.labels.requiredError;
    }
    return widget.validator?.call(value);
  }

  void _showError(BuildContext context, FilePickerErrorType type) {
    if (widget.onError != null) return widget.onError!(context, type);
    ScaffoldMessenger.maybeOf(context)
      ?..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(widget.labels.errorMessage(type))));
  }

  @override
  Widget build(BuildContext context) {
    return FormField<T>(
      autovalidateMode: widget.autovalidateMode,
      validator: _validate,
      onSaved: widget.onSaved,
      builder: (FormFieldState<T> field) {
        return BlocProvider<CustomFilePickerCubit>.value(
          value: _cubit,
          child: BlocConsumer<CustomFilePickerCubit, CustomFilePickerState>(
            listener: (BuildContext context, CustomFilePickerState state) {
              if (state is CustomFilePickerErrorState) {
                _showError(context, state.type);
                return;
              }
              if (state is! CustomFilePickerReadyState) return;
              widget.onFilesPicked?.call(state.files);
              final T? value = _toValue(state.files);
              field.didChange(value);
              widget.onChanged?.call(value);
              if (!state.isDelete) {
                _simulateProgress(state.files);
              } else if (_progress.length > state.files.length) {
                _progress = _progress.take(state.files.length).toList();
              }
            },
            builder: (BuildContext context, CustomFilePickerState state) {
              final List<FilePickerItem> items =
                  state is CustomFilePickerReadyState
                      ? state.files
                      : <FilePickerItem>[];
              return _card(context, field, items, state);
            },
          ),
        );
      },
    );
  }

  Widget _card(
    BuildContext context,
    FormFieldState<T> field,
    List<FilePickerItem> items,
    CustomFilePickerState state,
  ) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme scheme = theme.colorScheme;
    final FilePickerStyle style = widget.style;
    final FilePickerLabels labels = widget.labels;
    final Color secondary = scheme.onSurfaceVariant;
    final Color errorColor = style.errorColor ?? scheme.error;
    final Color accent = style.accentColor ?? scheme.primary;
    final TextStyle caption = style.captionStyle ??
        theme.textTheme.bodySmall!.copyWith(color: secondary);
    final TextStyle titleStyle = style.titleStyle ??
        theme.textTheme.titleMedium!.copyWith(fontWeight: FontWeight.w600);
    final List<String>? allowed = widget.allowedFileExtensions;

    return Container(
      padding: style.cardPadding,
      decoration: BoxDecoration(
        color: style.cardColor ?? scheme.surface,
        border: style.cardBorder ?? Border.all(color: scheme.outlineVariant),
        borderRadius: BorderRadius.circular(style.cardRadius),
        boxShadow: style.cardShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          if (labels.title != null)
            Row(
              children: <Widget>[
                Expanded(child: Text(labels.title!, style: titleStyle)),
                if (widget.showOptionalLabel && !widget.isRequired) ...<Widget>[
                  const SizedBox(width: 8),
                  Text(labels.optional, style: caption),
                ],
              ],
            ),
          if (labels.title != null) const SizedBox(height: 16),
          InkWell(
            borderRadius: BorderRadius.circular(style.dropZoneRadius),
            onTap: _openSources,
            child: CustomPaint(
              foregroundPainter: _DashedBorderPainter(
                color: style.dropZoneColor ?? scheme.outline,
                radius: style.dropZoneRadius,
              ),
              child: ConstrainedBox(
                constraints: const BoxConstraints(minHeight: 100),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        width: 42,
                        height: 42,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: accent.withValues(alpha: 0.12),
                        ),
                        child: Icon(style.attachIcon, size: 20, color: accent),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        labels.attach,
                        style: caption,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          if (allowed != null && allowed.isNotEmpty)
            _InfoLine(
              text: '${labels.allowedTypes} '
                  '${allowed.join(', ').replaceAll('.', '')}',
              style: caption,
            ),
          _InfoLine(
            text:
                '${labels.maxSize} ${widget.fileSize ?? 5} ${labels.megaUnit}',
            style: caption,
          ),
          if (widget.maximumFiles != null)
            _InfoLine(
              text: labels.maxFilesLimit(widget.maximumFiles!),
              style: caption,
            ),
          for (int i = 0; i < items.length; i++) ...<Widget>[
            const SizedBox(height: 10),
            _FileCard(
              item: items[i],
              progress: i < _progress.length ? _progress[i] : 1.0,
              onRemove: () => _cubit.remove(i),
              style: style,
              labels: labels,
              accent: accent,
              successColor: style.successColor ?? Colors.green,
            ),
          ],
          if (state is CustomFilePickerReadyState &&
              state.isExceed &&
              widget.maximumFiles != null) ...<Widget>[
            const SizedBox(height: 8),
            Text(
              labels.maxFilesLimit(widget.maximumFiles!),
              style: caption.copyWith(color: errorColor),
            ),
          ],
          if (field.hasError) ...<Widget>[
            const SizedBox(height: 8),
            Text(field.errorText!, style: caption.copyWith(color: errorColor)),
          ],
          if (labels.hint != null) ...<Widget>[
            const SizedBox(height: 16),
            Text(labels.hint!, style: caption),
          ],
        ],
      ),
    );
  }
}

class _InfoLine extends StatelessWidget {
  const _InfoLine({required this.text, required this.style});

  final String text;
  final TextStyle style;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.only(bottom: 2),
      child: Text(text, style: style, textAlign: TextAlign.center),
    );
  }
}

/// One picked file: name, size, progress %, remove button, an image preview
/// once uploaded, and the progress bar.
class _FileCard extends StatelessWidget {
  const _FileCard({
    required this.item,
    required this.progress,
    required this.onRemove,
    required this.style,
    required this.labels,
    required this.accent,
    required this.successColor,
  });

  final FilePickerItem item;
  final double progress;
  final VoidCallback onRemove;
  final FilePickerStyle style;
  final FilePickerLabels labels;
  final Color accent;
  final Color successColor;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme scheme = theme.colorScheme;
    final Color secondary = scheme.onSurfaceVariant;
    final TextStyle caption = style.captionStyle ??
        theme.textTheme.bodySmall!.copyWith(color: secondary);
    final TextStyle body = style.bodyStyle ??
        theme.textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.w500);
    final bool done = progress >= 1;
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: scheme.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Row(
            children: <Widget>[
              Icon(style.attachIcon, size: 22, color: secondary),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      item.name,
                      style: body,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(_formatSize(item.size), style: caption),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Text('${(progress * 100).toStringAsFixed(0)}%', style: caption),
              IconButton(
                tooltip: labels.removeAttachment,
                onPressed: onRemove,
                visualDensity: VisualDensity.compact,
                icon: Icon(style.removeIcon, size: 16, color: secondary),
              ),
            ],
          ),
          if (item.fileType == CustomFileType.image && done) ...<Widget>[
            const SizedBox(height: 12),
            Align(
              alignment: AlignmentDirectional.centerStart,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.file(
                  File(item.file.path),
                  width: style.imagePreviewSize,
                  height: style.imagePreviewSize,
                  fit: BoxFit.cover,
                  errorBuilder: (BuildContext c, Object e, StackTrace? s) => const SizedBox.shrink(),
                ),
              ),
            ),
          ],
          const SizedBox(height: 12),
          LinearProgressIndicator(
            value: progress,
            minHeight: 4,
            borderRadius: BorderRadius.circular(8),
            backgroundColor: scheme.surfaceContainerHighest,
            color: done ? successColor : accent,
          ),
        ],
      ),
    );
  }

  static String _formatSize(int bytes) {
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
  }
}

class _SourceSheet extends StatelessWidget {
  const _SourceSheet({required this.sources, required this.labels});

  final List<FilePickerSource> sources;
  final FilePickerLabels labels;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16),
        // Material (not a decorated Container) so the tiles' ink shows.
        child: Material(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(28),
          clipBehavior: Clip.antiAlias,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                for (final FilePickerSource s in sources)
                  ListTile(
                    leading: Icon(switch (s) {
                      FilePickerSource.camera => Icons.photo_camera_outlined,
                      FilePickerSource.gallery => Icons.photo_library_outlined,
                      FilePickerSource.file => Icons.folder_open_outlined,
                    }),
                    title: Text(labels.sourceLabel(s)),
                    onTap: () => Navigator.of(context).pop(s),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _DashedBorderPainter extends CustomPainter {
  const _DashedBorderPainter({required this.color, required this.radius});

  static const double _strokeWidth = 1;
  static const double _dash = 2;
  static const double _gap = 2;

  final Color color;
  final double radius;

  @override
  void paint(Canvas canvas, Size size) {
    final Rect rect = (Offset.zero & size).deflate(_strokeWidth / 2);
    final Path outline = Path()
      ..addRRect(
        RRect.fromRectAndRadius(
          rect,
          Radius.circular(radius.clamp(0, rect.shortestSide / 2)),
        ),
      );
    final Paint paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = _strokeWidth;
    for (final PathMetric metric in outline.computeMetrics()) {
      for (double start = 0; start < metric.length; start += _dash + _gap) {
        canvas.drawPath(metric.extractPath(start, start + _dash), paint);
      }
    }
  }

  @override
  bool shouldRepaint(_DashedBorderPainter oldDelegate) =>
      oldDelegate.color != color || oldDelegate.radius != radius;
}
