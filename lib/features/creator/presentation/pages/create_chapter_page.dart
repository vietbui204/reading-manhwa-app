import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:appmanga/core/theme/app_colors.dart';
import 'package:appmanga/features/manga/domain/entities/manga_entity.dart';
import '../bloc/create_chapter_bloc.dart';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';

class CreateChapterPage extends StatefulWidget {
  // mangaId tuỳ chọn — nếu truyền vào sẽ tự chọn manga đó
  final String? preselectedMangaId;
  const CreateChapterPage({super.key, this.preselectedMangaId});

  @override
  State<CreateChapterPage> createState() => _CreateChapterPageState();
}

class _CreateChapterPageState extends State<CreateChapterPage> {
  final _formKey          = GlobalKey<FormState>();
  final _chapterNumCtrl   = TextEditingController();
  final _titleCtrl        = TextEditingController();
  bool _isLocked          = false;
  int _unlockCost         = 30;
  bool _isPremiumOnly     = false;

  @override
  void dispose() {
    _chapterNumCtrl.dispose();
    _titleCtrl.dispose();
    super.dispose();
  }
  Widget _buildThumbnail(File file) {
    if (kIsWeb) {
      // Web: dùng Image.network với object URL
      return FutureBuilder<Uint8List>(
        future: file.readAsBytes(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Image.memory(
              snapshot.data!,
              width : 48,
              height: 64,
              fit   : BoxFit.cover,
            );
          }
          return Container(
            width : 48,
            height: 64,
            color : AppColors.darkBg3,
            child : const Center(
              child: SizedBox(
                width : 16,
                height: 16,
                child : CircularProgressIndicator(
                  strokeWidth: 1.5,
                  color      : AppColors.darkText3,
                ),
              ),
            ),
          );
        },
      );
    }
    // Mobile/Desktop: dùng Image.file bình thường
    return Image.file(
      file,
      width : 48,
      height: 64,
      fit   : BoxFit.cover,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CreateChapterBloc, CreateChapterState>(
      listener: (context, state) {
        if (state is CreateChapterSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content         : Text('Đăng chapter thành công!'),
              backgroundColor : Colors.green,
            ),
          );
          // Trả true về để ProfilePage reload
          context.pop(true);
        }
        if (state is CreateChapterReady &&
            state.errorMessage != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content         : Text(state.errorMessage!),
              backgroundColor : AppColors.red,
            ),
          );
        }
      },
      builder: (context, state) {
        if (state is CreateChapterLoadingMangas) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(color: AppColors.red),
            ),
          );
        }
        if (state is CreateChapterError) {
          return Scaffold(
            appBar: AppBar(title: const Text('Thêm chapter')),
            body  : Center(child: Text(state.message)),
          );
        }
        if (state is CreateChapterReady) {
          return _buildForm(context, state);
        }
        return const Scaffold(
          body: Center(
            child: CircularProgressIndicator(color: AppColors.red),
          ),
        );
      },
    );
  }

  Widget _buildForm(BuildContext context, CreateChapterReady state) {
    final isLoading = state.isUploading || state.isSubmitting;

    return Scaffold(
      backgroundColor: AppColors.darkBg,
      appBar: AppBar(
        backgroundColor: AppColors.darkBg,
        title: const Text(
          'Thêm chapter mới',
          style: TextStyle(color: AppColors.darkText),
        ),
        iconTheme: const IconThemeData(color: AppColors.darkText),
        elevation: 0,
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              // ── 1. Chọn truyện ──────────────────────
              _SectionTitle('1. Chọn truyện'),
              const SizedBox(height: 10),
              _buildMangaSelector(context, state),
              const SizedBox(height: 24),

              // ── 2. Thông tin chapter ─────────────────
              _SectionTitle('2. Thông tin chapter'),
              const SizedBox(height: 10),
              Row(children: [
                // Số chapter
                Expanded(
                  flex: 2,
                  child: TextFormField(
                    controller : _chapterNumCtrl,
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                    style      : const TextStyle(
                      color: AppColors.darkText,
                    ),
                    decoration : _inputDecoration('Số chapter *'),
                    validator  : (v) {
                      if (v == null || v.isEmpty) {
                        return 'Bắt buộc';
                      }
                      if (int.tryParse(v) == null) {
                        return 'Không hợp lệ';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(width: 12),
                // Tiêu đề
                Expanded(
                  flex: 3,
                  child: TextFormField(
                    controller : _titleCtrl,
                    style      : const TextStyle(
                      color: AppColors.darkText,
                    ),
                    decoration : _inputDecoration(
                      'Tiêu đề (tuỳ chọn)',
                    ),
                  ),
                ),
              ]),
              const SizedBox(height: 20),

              // ── 3. Cài đặt khoá ──────────────────────
              _SectionTitle('3. Cài đặt truy cập'),
              const SizedBox(height: 10),
              _buildLockSettings(context, state),
              const SizedBox(height: 24),

              // ── 4. Chọn ảnh trang ─────────────────────
              _SectionTitle(
                '4. Ảnh trang truyện'
                    ' (${state.selectedPages.length} trang)',
              ),
              const SizedBox(height: 10),
              _buildPagePicker(context, state),
              const SizedBox(height: 32),

              // ── Nút đăng ──────────────────────────────
              _buildSubmitButton(context, state, isLoading),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  // ── Manga selector ──────────────────────────────────
  Widget _buildMangaSelector(
      BuildContext context,
      CreateChapterReady state,
      ) {
    if (state.mangas.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color       : AppColors.darkBg2,
          borderRadius: BorderRadius.circular(12),
          border      : Border.all(color: AppColors.darkBorder),
        ),
        child: const Row(children: [
          Icon(Icons.info_outline,
              color: AppColors.darkText3, size: 18),
          SizedBox(width: 8),
          Text(
            'Chưa có truyện nào. Hãy tạo truyện trước.',
            style: TextStyle(color: AppColors.darkText3, fontSize: 13),
          ),
        ]),
      );
    }

    return Column(
      children: state.mangas.map((manga) {
        final isSelected = state.selectedManga?.id == manga.id;
        return GestureDetector(
          onTap: () => context.read<CreateChapterBloc>().add(
            CreateChapterMangaSelected(manga),
          ),
          child: Container(
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color       : isSelected
                  ? AppColors.red.withOpacity(0.1)
                  : AppColors.darkBg2,
              borderRadius: BorderRadius.circular(10),
              border      : Border.all(
                color: isSelected
                    ? AppColors.red
                    : AppColors.darkBorder,
                width: isSelected ? 1.5 : 1,
              ),
            ),
            child: Row(children: [
              // Ảnh bìa nhỏ
              ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: manga.coverUrl != null
                    ? CachedNetworkImage(
                  imageUrl : manga.coverUrl!,
                  width    : 44,
                  height   : 60,
                  fit      : BoxFit.cover,
                  errorWidget: (_, __, ___) =>
                      Container(
                        width : 44,
                        height: 60,
                        color : AppColors.darkBg3,
                      ),
                )
                    : Container(
                  width : 44,
                  height: 60,
                  color : AppColors.darkBg3,
                  child : const Icon(Icons.image,
                      color: AppColors.darkText3),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    manga.title,
                    style: TextStyle(
                      fontSize  : 13,
                      fontWeight: FontWeight.w600,
                      color     : isSelected
                          ? AppColors.red
                          : AppColors.darkText,
                    ),
                    maxLines : 2,
                    overflow : TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _statusText(manga.status),
                    style: const TextStyle(
                      fontSize: 11,
                      color   : AppColors.darkText3,
                    ),
                  ),
                ],
              )),
              if (isSelected)
                const Icon(Icons.check_circle,
                    color: AppColors.red, size: 20),
            ]),
          ),
        );
      }).toList(),
    );
  }

  // ── Lock settings ───────────────────────────────────
  Widget _buildLockSettings(
      BuildContext context,
      CreateChapterReady state,
      ) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color       : AppColors.darkBg2,
        borderRadius: BorderRadius.circular(12),
        border      : Border.all(color: AppColors.darkBorder),
      ),
      child: Column(children: [
        // Switch khoá chapter
        Row(children: [
          Expanded(child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Khoá chapter',
                  style: TextStyle(
                    color: AppColors.darkText, fontSize: 14,
                    fontWeight: FontWeight.w500,
                  )),
              const SizedBox(height: 2),
              Text(
                'Yêu cầu điểm để mở khoá',
                style: const TextStyle(
                  color: AppColors.darkText3, fontSize: 12,
                ),
              ),
            ],
          )),
          Switch(
            value      : _isLocked,
            activeColor: AppColors.red,
            onChanged  : (val) => setState(() {
              _isLocked = val;
              if (val) _isPremiumOnly = false;
            }),
          ),
        ]),

        // Slider điểm khoá
        if (_isLocked) ...[
          const Divider(color: AppColors.darkBorder),
          Row(children: [
            const Icon(Icons.stars,
                size: 16, color: Colors.amber),
            const SizedBox(width: 8),
            Text(
              'Cần $_unlockCost điểm',
              style: const TextStyle(
                color: Colors.amber,
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          ]),
          Slider(
            value     : _unlockCost.toDouble(),
            min       : 10,
            max       : 200,
            divisions : 19,
            activeColor: AppColors.red,
            label     : '$_unlockCost điểm',
            onChanged : (v) =>
                setState(() => _unlockCost = v.toInt()),
          ),
        ],

        const Divider(color: AppColors.darkBorder),

        // Switch Premium only
        Row(children: [
          Expanded(child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Chỉ Premium',
                  style: TextStyle(
                    color: AppColors.darkText, fontSize: 14,
                    fontWeight: FontWeight.w500,
                  )),
              Text(
                'Chỉ thành viên Premium được đọc',
                style: const TextStyle(
                  color: AppColors.darkText3, fontSize: 12,
                ),
              ),
            ],
          )),
          Switch(
            value      : _isPremiumOnly,
            activeColor: Colors.amber,
            onChanged  : (val) => setState(() {
              _isPremiumOnly = val;
              if (val) _isLocked = false;
            }),
          ),
        ]),
      ]),
    );
  }

  // ── Page picker + preview grid ──────────────────────
  Widget _buildPagePicker(
      BuildContext context,
      CreateChapterReady state,
      ) {
    return Column(children: [
      // Nút chọn ảnh
      SizedBox(
        width: double.infinity,
        child: OutlinedButton.icon(
          icon : const Icon(Icons.photo_library,
              color: AppColors.red),
          label: Text(
            state.selectedPages.isEmpty
                ? 'Chọn ảnh trang truyện'
                : 'Thêm ảnh',
            style: const TextStyle(color: AppColors.red),
          ),
          style: OutlinedButton.styleFrom(
            side   : const BorderSide(color: AppColors.red),
            padding: const EdgeInsets.symmetric(vertical: 13),
            shape  : RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          onPressed: () => _pickPages(context),
        ),
      ),

      // Preview grid + kéo thả sắp xếp
      if (state.selectedPages.isNotEmpty) ...[
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color       : AppColors.darkBg2,
            borderRadius: BorderRadius.circular(12),
            border      : Border.all(color: AppColors.darkBorder),
          ),
          child: Column(children: [
            Row(children: [
              const Icon(Icons.drag_indicator,
                  size: 14, color: AppColors.darkText3),
              const SizedBox(width: 6),
              Text(
                'Kéo để sắp xếp thứ tự trang',
                style: const TextStyle(
                  fontSize: 11, color: AppColors.darkText3,
                ),
              ),
            ]),
            const SizedBox(height: 10),
            // Upload progress
            if (state.isUploading)
              Column(children: [
                LinearProgressIndicator(
                  color: AppColors.red,
                  backgroundColor: AppColors.darkBg3,
                ),
                const SizedBox(height: 6),
                Text(
                  'Đang upload ảnh...',
                  style: const TextStyle(
                    fontSize: 12, color: AppColors.darkText3,
                  ),
                ),
                const SizedBox(height: 10),
              ]),
            // Reorderable grid
            ReorderableListView.builder(
              shrinkWrap    : true,
              physics       : const NeverScrollableScrollPhysics(),
              itemCount     : state.selectedPages.length,
              onReorder     : (oldIndex, newIndex) {
                if (newIndex > oldIndex) newIndex--;
                context.read<CreateChapterBloc>().add(
                  CreateChapterPagesReordered(oldIndex, newIndex),
                );
              },
              itemBuilder   : (context, index) {
                final file = state.selectedPages[index];
                return Container(
                  key   : ValueKey(file.path),
                  margin: const EdgeInsets.only(bottom: 8),
                  decoration: BoxDecoration(
                    color       : AppColors.darkBg3,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(children: [
                    // Drag handle
                    const Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 10,
                      ),
                      child: Icon(Icons.drag_handle,
                          color: AppColors.darkText3, size: 20),
                    ),
                    // Số trang
                    Container(
                      width : 28,
                      height: 28,
                      decoration: const BoxDecoration(
                        color : AppColors.red,
                        shape : BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                          '${index + 1}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    // Thumbnail
                    ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: _buildThumbnail(file),
                    ),
                    const SizedBox(width: 10),
                    // Tên file
                    Expanded(
                      child: Text(
                        file.path.split('/').last,
                        style: const TextStyle(
                          fontSize: 11,
                          color   : AppColors.darkText2,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    // Nút xoá
                    IconButton(
                      icon     : const Icon(Icons.close,
                          color: AppColors.darkText3, size: 18),
                      onPressed: () =>
                          context.read<CreateChapterBloc>().add(
                            CreateChapterPageRemoved(index),
                          ),
                    ),
                  ]),
                );
              },
            ),
          ]),
        ),
      ],
    ]);
  }

  // ── Submit button ───────────────────────────────────
  Widget _buildSubmitButton(
      BuildContext context,
      CreateChapterReady state,
      bool isLoading,
      ) {
    String label = 'Đăng chapter';
    if (state.isUploading) {
      label = 'Đang upload ảnh...';
    } else if (state.isSubmitting) {
      label = 'Đang lưu...';
    }

    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: state.canSubmit
              ? AppColors.red : AppColors.darkBg3,
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        onPressed: (isLoading || !state.canSubmit)
            ? null
            : () => _onSubmit(context),
        child: isLoading
            ? Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(
              width : 18,
              height: 18,
              child : CircularProgressIndicator(
                strokeWidth: 2,
                color      : Colors.white,
              ),
            ),
            const SizedBox(width: 10),
            Text(label,
                style: const TextStyle(color: Colors.white)),
          ],
        )
            : Text(
          state.canSubmit
              ? 'Đăng chapter'
              : 'Chọn truyện và ảnh để tiếp tục',
          style: TextStyle(
            color: state.canSubmit
                ? Colors.white : AppColors.darkText3,
            fontWeight: FontWeight.bold,
            fontSize  : 15,
          ),
        ),
      ),
    );
  }

  // ── Helpers ─────────────────────────────────────────
  Future<void> _pickPages(BuildContext context) async {
    final picker = ImagePicker();
    final files  = await picker.pickMultiImage(
      maxWidth     : 1200,
      imageQuality : 85,
    );
    if (files.isEmpty) return;
    if (!context.mounted) return;
    context.read<CreateChapterBloc>().add(
      CreateChapterPagesAdded(
        files.map((f) => File(f.path)).toList(),
      ),
    );
  }

  void _onSubmit(BuildContext context) {
    if (!_formKey.currentState!.validate()) return;
    final num = int.tryParse(_chapterNumCtrl.text.trim());
    if (num == null) return;

    context.read<CreateChapterBloc>().add(
      CreateChapterSubmitted(
        chapterNumber : num,
        title         : _titleCtrl.text.trim().isEmpty
            ? null : _titleCtrl.text.trim(),
        isLocked      : _isLocked,
        unlockCost    : _unlockCost,
        isPremiumOnly : _isPremiumOnly,
      ),
    );
  }

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText   : label,
      labelStyle  : const TextStyle(color: AppColors.darkText3),
      filled      : true,
      fillColor   : AppColors.darkBg2,
      border      : OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide  : const BorderSide(color: AppColors.darkBorder),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide  : const BorderSide(color: AppColors.darkBorder),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide  : const BorderSide(color: AppColors.red),
      ),
    );
  }

  String _statusText(String status) {
    switch (status) {
      case 'completed': return 'Hoàn thành';
      case 'hiatus'   : return 'Tạm dừng';
      default         : return 'Đang ra';
    }
  }
}

// ── Section title widget ────────────────────────────────
class _SectionTitle extends StatelessWidget {
  final String text;
  const _SectionTitle(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        fontSize  : 15,
        fontWeight: FontWeight.bold,
        color     : AppColors.darkText,
      ),
    );
  }
}