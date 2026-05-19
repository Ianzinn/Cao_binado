import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../shared/widgets/app_bottom_nav_bar.dart';
import '../../../../shared/widgets/app_top_bar.dart';
import '../../../../shared/widgets/app_text_field.dart';
import '../store/register_animal_store.dart';

class RegisterAnimalPage extends StatefulWidget {
  const RegisterAnimalPage({super.key});

  @override
  State<RegisterAnimalPage> createState() => _RegisterAnimalPageState();
}

class _RegisterAnimalPageState extends State<RegisterAnimalPage> {
  late final RegisterAnimalStore _store;
  final _nameCtrl = TextEditingController();
  final _ageCtrl = TextEditingController();
  final _descCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _store = getIt<RegisterAnimalStore>();
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _ageCtrl.dispose();
    _descCtrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final ok = await _store.save();
    if (ok && mounted) context.go('/home');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppDarkTopBar(title: 'Cadastrar Animalzinho'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Observer(
              builder: (_) {
                final images = _store.selectedImages;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (images.isNotEmpty)
                      SizedBox(
                        height: 110,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemCount: images.length,
                          separatorBuilder: (_, __) =>
                              const SizedBox(width: 10),
                          itemBuilder: (_, i) => _SelectedImageTile(
                            file: images[i],
                            onRemove: () => _store.removeImage(i),
                          ),
                        ),
                      ),
                    if (images.isNotEmpty) const SizedBox(height: 10),
                    GestureDetector(
                      onTap: _store.pickImage,
                      child: Row(
                        children: [
                          const Icon(Icons.add_circle_outline_rounded,
                              color: AppColors.textPrimary, size: 18),
                          const SizedBox(width: 6),
                          Text(
                            'Adicionar Imagem',
                            style: GoogleFonts.poppins(
                                fontSize: 14, fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
            const SizedBox(height: 14),
            Text(
              'Adicione as informações do animal que você quer doar',
              style: GoogleFonts.poppins(
                  fontSize: 13, color: AppColors.textSecondary),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            AppLabeledField(
              label: 'Nome',
              controller: _nameCtrl,
              hint: 'Digite o nome',
              onChanged: _store.setName,
            ),
            const SizedBox(height: 14),
            AppLabeledField(
              label: 'Idade',
              controller: _ageCtrl,
              hint: 'Digite a idade do seu animalzinho',
              onChanged: _store.setAge,
            ),
            const SizedBox(height: 14),
            Observer(
              builder: (_) => AppDropdownField(
                label: 'Tipo',
                hint: 'Selecione o tipo do animal',
                value: _store.animalClass,
                items: const ['Mamífero', 'Ave', 'Réptil'],
                onChanged: _store.setAnimalClass,
              ),
            ),
            const SizedBox(height: 14),
            Observer(
              builder: (_) => AppDropdownField(
                label: 'Porte',
                hint: 'Selecione o porte do animal',
                value: _store.size,
                items: const ['Pequeno', 'Médio', 'Grande'],
                onChanged: _store.setSize,
              ),
            ),
            const SizedBox(height: 14),
            Observer(
              builder: (_) => AppDropdownField(
                label: 'Raça',
                hint: 'Selecione a raça com base no porte',
                value: _store.breed,
                items: const [
                  'Corgi',
                  'Pug',
                  'Golden Retriever',
                  'Vira lata',
                  'Siamês'
                ],
                onChanged: _store.setBreed,
              ),
            ),
            const SizedBox(height: 14),
            AppLabeledField(
              label: 'Descreva o animalzinho',
              controller: _descCtrl,
              hint: 'Exemplo: Gosta de brincar no quintal em dias de sol',
              onChanged: _store.setDescription,
              maxLines: 5,
            ),
            Observer(
              builder: (_) => _store.errorMessage != null
                  ? Padding(
                      padding: const EdgeInsets.only(top: 12),
                      child: Text(
                        _store.errorMessage!,
                        style: GoogleFonts.poppins(
                            fontSize: 13,
                            color: AppColors.statusCancelled),
                        textAlign: TextAlign.center,
                      ),
                    )
                  : const SizedBox.shrink(),
            ),
            const SizedBox(height: 28),
            Center(
              child: Observer(
                builder: (_) => GestureDetector(
                  onTap: _store.isLoading ? null : _save,
                  child: Container(
                    width: 200,
                    height: 50,
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(AppRadius.button),
                      boxShadow: AppShadows.primaryButton,
                    ),
                    alignment: Alignment.center,
                    child: _store.isLoading
                        ? const SizedBox(
                            width: 22,
                            height: 22,
                            child: CircularProgressIndicator(
                                color: Colors.white, strokeWidth: 2.5),
                          )
                        : Text(
                            'Salvar',
                            style: GoogleFonts.poppins(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: Colors.white),
                          ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
      bottomNavigationBar: const AppBottomNavBar(
        petzinhosRoute: '/favorites',
        centerRoute: '/home',
        centerLabel: 'Home',
        centerIcon: Icons.home_outlined,
        categoriesRoute: '/adopters',
      ),
    );
  }
}

class _SelectedImageTile extends StatelessWidget {
  const _SelectedImageTile({required this.file, required this.onRemove});
  final File file;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(AppRadius.input),
          child: Image.file(file,
              width: 110, height: 110, fit: BoxFit.cover),
        ),
        Positioned(
          top: 4,
          right: 4,
          child: GestureDetector(
            onTap: onRemove,
            child: Container(
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.black54,
              ),
              padding: const EdgeInsets.all(4),
              child: const Icon(Icons.close, size: 14, color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }
}
