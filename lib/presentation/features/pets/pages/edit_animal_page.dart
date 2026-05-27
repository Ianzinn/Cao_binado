import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../domain/models/pet_model.dart';
import '../../../../domain/repositories/pet_repository.dart';
import '../../../../shared/statics/pet_breeds.dart';
import '../../../../shared/widgets/app_text_field.dart';
import '../../../../shared/widgets/app_top_bar.dart';
import '../store/edit_animal_store.dart';

class EditAnimalPage extends StatefulWidget {
  const EditAnimalPage({super.key, required this.pet});

  final PetModel pet;

  @override
  State<EditAnimalPage> createState() => _EditAnimalPageState();
}

class _EditAnimalPageState extends State<EditAnimalPage> {
  late final EditAnimalStore _store;
  late final TextEditingController _nameCtrl;
  late final TextEditingController _ageCtrl;
  late final TextEditingController _descCtrl;

  @override
  void initState() {
    super.initState();
    _store = EditAnimalStore(
      petRepository: getIt<PetRepository>(),
      pet: widget.pet,
    );
    _nameCtrl = TextEditingController(text: widget.pet.nome);
    _ageCtrl = TextEditingController(text: widget.pet.idade);
    _descCtrl = TextEditingController(text: widget.pet.descricao);
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
    if (!mounted) return;
    if (ok) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Pet atualizado com sucesso!')),
      );
      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppDarkTopBar(title: 'Editar Pet'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Edite as informações do pet',
              style: GoogleFonts.poppins(
                  fontSize: 13, color: AppColors.textSecondary),
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
                label: 'Espécie',
                hint: 'Selecione a espécie do animal',
                value: _store.animalClass,
                items: const ['Cachorro', 'Gato', 'Outros'],
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
              builder: (_) => AppAutocompleteField(
                label: 'Raça',
                hint: 'Digite ou selecione a raça',
                initialValue: _store.breed,
                options: kPetBreeds,
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
    );
  }
}
