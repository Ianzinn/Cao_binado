import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_theme.dart';

class PetFiltersBottomSheet extends StatefulWidget {
  const PetFiltersBottomSheet({
    super.key,
    required this.initialEspecie,
    required this.initialPorte,
  });

  final String? initialEspecie;
  final String? initialPorte;

  @override
  State<PetFiltersBottomSheet> createState() => _PetFiltersBottomSheetState();
}

class _PetFiltersBottomSheetState extends State<PetFiltersBottomSheet> {
  String? _selectedEspecie;
  String? _selectedPorte;

  static const _especies = ['Cachorro', 'Gato', 'Outros'];
  static const _portes = ['Pequeno', 'Médio', 'Grande'];

  @override
  void initState() {
    super.initState();
    _selectedEspecie = widget.initialEspecie;
    _selectedPorte = widget.initialPorte;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.divider,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'Filtros',
            style: GoogleFonts.poppins(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 20),
          _SectionLabel('Espécie'),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _FilterChip(
                label: 'Todos',
                isSelected: _selectedEspecie == null,
                onTap: () => setState(() => _selectedEspecie = null),
              ),
              ..._especies.map(
                (e) => _FilterChip(
                  label: e,
                  isSelected: _selectedEspecie == e,
                  onTap: () => setState(
                    () => _selectedEspecie = _selectedEspecie == e ? null : e,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          _SectionLabel('Porte'),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _FilterChip(
                label: 'Todos',
                isSelected: _selectedPorte == null,
                onTap: () => setState(() => _selectedPorte = null),
              ),
              ..._portes.map(
                (p) => _FilterChip(
                  label: p,
                  isSelected: _selectedPorte == p,
                  onTap: () => setState(
                    () => _selectedPorte = _selectedPorte == p ? null : p,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 28),
          GestureDetector(
            onTap: () =>
                Navigator.of(context).pop((_selectedEspecie, _selectedPorte)),
            child: Container(
              height: 52,
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(99),
              ),
              alignment: Alignment.center,
              child: Text(
                'Aplicar filtros',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          TextButton(
            onPressed: () => Navigator.of(context).pop((null, null)),
            child: Text(
              'Limpar filtros',
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: AppColors.textSecondary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel(this.text);
  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: GoogleFonts.poppins(
        fontSize: 13,
        fontWeight: FontWeight.w600,
        color: AppColors.textSecondary,
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  const _FilterChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 9),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : AppColors.surface,
          borderRadius: BorderRadius.circular(99),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.divider,
          ),
        ),
        child: Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 13,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
            color: isSelected ? Colors.white : AppColors.textPrimary,
          ),
        ),
      ),
    );
  }
}
