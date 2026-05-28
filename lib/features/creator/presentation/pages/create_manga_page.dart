import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:appmanga/core/theme/app_colors.dart';
import '../bloc/create_manga_bloc.dart';

class CreateMangaPage extends StatefulWidget {
  const CreateMangaPage({super.key});

  @override
  State<CreateMangaPage> createState() => _CreateMangaPageState();
}

class _CreateMangaPageState extends State<CreateMangaPage> {
  final _formKey = GlobalKey<FormState>();
  final _titleCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  XFile? _selectedCover;
  String _selectedStatus = 'ongoing';
  final List<String> _selectedGenres = [];

  final List<String> _allGenres = [
    'Action', 'Adventure', 'Comedy', 'Drama', 'Fantasy', 
    'Horror', 'Mystery', 'Romance', 'Sci-fi', 'Slice of Life', 'Sports'
  ];

  @override
  void dispose() {
    _titleCtrl.dispose();
    _descCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickCover() async {
    final picker = ImagePicker();
    final file = await picker.pickImage(source: ImageSource.gallery, maxWidth: 800);
    if (file != null) {
      setState(() => _selectedCover = file);
    }
  }

  void _onSubmit() {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedCover == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vui lòng chọn ảnh bìa')),
      );
      return;
    }

    context.read<CreateMangaBloc>().add(CreateMangaSubmitted(
      title: _titleCtrl.text.trim(),
      description: _descCtrl.text.trim(),
      coverFile: _selectedCover,
      status: _selectedStatus,
      genres: _selectedGenres.map((e) => e.toLowerCase()).toList(),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<CreateMangaBloc, CreateMangaState>(
      listener: (context, state) {
        if (state is CreateMangaSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Đăng truyện thành công!'), backgroundColor: Colors.green),
          );
          context.go('/manga/${state.mangaId}');
        }
        if (state is CreateMangaError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message), backgroundColor: AppColors.red),
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('ĐĂNG TRUYỆN MỚI', style: GoogleFonts.bebasNeue(fontSize: 22)),
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: Form(
          key: _formKey,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildCoverPicker(),
                const SizedBox(height: 24),
                _buildLabel('TIÊU ĐỀ TRUYỆN *'),
                _buildTextField(_titleCtrl, 'Nhập tên bộ truyện', (v) => v!.isEmpty ? 'Bắt buộc' : null),
                const SizedBox(height: 20),
                _buildLabel('MÔ TẢ'),
                _buildTextField(_descCtrl, 'Giới thiệu nội dung...', null, maxLines: 4),
                const SizedBox(height: 20),
                _buildLabel('TRẠNG THÁI'),
                _buildStatusDropdown(),
                const SizedBox(height: 20),
                _buildLabel('THỂ LOẠI'),
                _buildGenreSelector(),
                const SizedBox(height: 40),
                _buildSubmitButton(),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCoverPicker() {
    return GestureDetector(
      onTap: _pickCover,
      child: Container(
        width: double.infinity,
        height: 220,
        decoration: BoxDecoration(
          color: AppColors.darkBg2,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.darkBorder, style: BorderStyle.solid),
        ),
        child: _selectedCover != null
            ? _buildPreviewImage()
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.add_photo_alternate_outlined, size: 48, color: AppColors.darkText3),
                  const SizedBox(height: 8),
                  const Text('Chọn ảnh bìa truyện', style: TextStyle(color: AppColors.darkText3, fontSize: 13)),
                ],
              ),
      ),
    );
  }

  Widget _buildPreviewImage() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: FutureBuilder<Uint8List>(
        future: _selectedCover!.readAsBytes(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Image.memory(snapshot.data!, fit: BoxFit.cover, width: double.infinity);
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(text, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.darkText3, letterSpacing: 1.2)),
    );
  }

  Widget _buildTextField(TextEditingController ctrl, String hint, String? Function(String?)? validator, {int maxLines = 1}) {
    return TextFormField(
      controller: ctrl,
      maxLines: maxLines,
      validator: validator,
      style: const TextStyle(color: Colors.white, fontSize: 14),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: AppColors.darkText3),
        filled: true,
        fillColor: AppColors.darkBg2,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
      ),
    );
  }

  Widget _buildStatusDropdown() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(color: AppColors.darkBg2, borderRadius: BorderRadius.circular(12)),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _selectedStatus,
          isExpanded: true,
          dropdownColor: AppColors.darkBg2,
          style: const TextStyle(color: Colors.white, fontSize: 14),
          items: const [
            DropdownMenuItem(value: 'ongoing', child: Text('Đang tiến hành')),
            DropdownMenuItem(value: 'completed', child: Text('Đã hoàn thành')),
            DropdownMenuItem(value: 'hiatus', child: Text('Tạm dừng')),
          ],
          onChanged: (v) => setState(() => _selectedStatus = v!),
        ),
      ),
    );
  }

  Widget _buildGenreSelector() {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: _allGenres.map((genre) {
        final isSelected = _selectedGenres.contains(genre);
        return FilterChip(
          label: Text(genre, style: const TextStyle(fontSize: 12)),
          selected: isSelected,
          onSelected: (val) {
            setState(() {
              val ? _selectedGenres.add(genre) : _selectedGenres.remove(genre);
            });
          },
          selectedColor: AppColors.red,
          checkmarkColor: Colors.white,
          backgroundColor: AppColors.darkBg2,
          labelStyle: TextStyle(color: isSelected ? Colors.white : AppColors.darkText3),
        );
      }).toList(),
    );
  }

  Widget _buildSubmitButton() {
    return BlocBuilder<CreateMangaBloc, CreateMangaState>(
      builder: (context, state) {
        final isLoading = state is CreateMangaLoading;
        return ElevatedButton(
          onPressed: isLoading ? null : _onSubmit,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.red,
            minimumSize: const Size(double.infinity, 54),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          ),
          child: isLoading
              ? const CircularProgressIndicator(color: Colors.white)
              : const Text('ĐĂNG TRUYỆN NGAY', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, letterSpacing: 1.5)),
        );
      },
    );
  }
}
