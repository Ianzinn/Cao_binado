import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_theme.dart';

class ScheduleVisitResult {
  const ScheduleVisitResult({
    required this.location,
    required this.dateTime,
    this.notes,
  });

  final String location;
  final DateTime dateTime;
  final String? notes;
}

class ScheduleVisitBottomSheet extends StatefulWidget {
  const ScheduleVisitBottomSheet({super.key, required this.petNome});

  final String petNome;

  @override
  State<ScheduleVisitBottomSheet> createState() =>
      _ScheduleVisitBottomSheetState();
}

class _ScheduleVisitBottomSheetState extends State<ScheduleVisitBottomSheet> {
  final _locationCtrl = TextEditingController();
  final _notesCtrl = TextEditingController();
  DateTime? _date;
  TimeOfDay? _time;

  @override
  void dispose() {
    _locationCtrl.dispose();
    _notesCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _date ?? now,
      firstDate: now,
      lastDate: now.add(const Duration(days: 365)),
    );
    if (picked != null) setState(() => _date = picked);
  }

  Future<void> _pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _time ?? TimeOfDay.now(),
    );
    if (picked != null) setState(() => _time = picked);
  }

  bool get _canSubmit =>
      _locationCtrl.text.trim().isNotEmpty &&
      _date != null &&
      _time != null;

  void _confirm() {
    if (!_canSubmit) return;
    final dt = DateTime(
      _date!.year,
      _date!.month,
      _date!.day,
      _time!.hour,
      _time!.minute,
    );
    Navigator.of(context).pop(
      ScheduleVisitResult(
        location: _locationCtrl.text.trim(),
        dateTime: dt,
        notes: _notesCtrl.text.trim().isEmpty ? null : _notesCtrl.text.trim(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        24,
        24,
        24,
        24 + MediaQuery.of(context).viewInsets.bottom,
      ),
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
          const SizedBox(height: 20),
          Text(
            'Marcar visita',
            style: GoogleFonts.poppins(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Informe os dados da visita para adoção do ${widget.petNome}.',
            style: GoogleFonts.poppins(
              fontSize: 13,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 20),
          _Label('Local da visita'),
          const SizedBox(height: 6),
          TextField(
            controller: _locationCtrl,
            onChanged: (_) => setState(() {}),
            decoration: _decoration(hint: 'Ex.: Pet Center BH'),
            style: GoogleFonts.poppins(fontSize: 14),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(child: _PickerField(
                label: 'Data',
                value: _date == null
                    ? 'Selecionar'
                    : _formatDate(_date!),
                onTap: _pickDate,
              )),
              const SizedBox(width: 12),
              Expanded(child: _PickerField(
                label: 'Horário',
                value: _time == null
                    ? 'Selecionar'
                    : _formatTime(_time!),
                onTap: _pickTime,
              )),
            ],
          ),
          const SizedBox(height: 14),
          _Label('Observações (opcional)'),
          const SizedBox(height: 6),
          TextField(
            controller: _notesCtrl,
            maxLines: 3,
            decoration: _decoration(
              hint: 'Ex.: chegar 10 min antes, levar documento',
            ),
            style: GoogleFonts.poppins(fontSize: 14),
          ),
          const SizedBox(height: 24),
          GestureDetector(
            onTap: _canSubmit ? _confirm : null,
            child: Container(
              height: 52,
              decoration: BoxDecoration(
                color: _canSubmit ? AppColors.accent : AppColors.textSecondary,
                borderRadius: BorderRadius.circular(99),
              ),
              alignment: Alignment.center,
              child: Text(
                'Confirmar visita',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              'Cancelar',
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

  InputDecoration _decoration({required String hint}) => InputDecoration(
        hintText: hint,
        hintStyle: GoogleFonts.poppins(
          fontSize: 13,
          color: AppColors.textPlaceholder,
        ),
        filled: true,
        fillColor: AppColors.surface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.input),
          borderSide: BorderSide.none,
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      );

  String _formatDate(DateTime d) =>
      '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}/${d.year}';

  String _formatTime(TimeOfDay t) =>
      '${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}';
}

class _Label extends StatelessWidget {
  const _Label(this.text);
  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: GoogleFonts.poppins(
        fontSize: 13,
        fontWeight: FontWeight.w500,
        color: AppColors.textPrimary,
      ),
    );
  }
}

class _PickerField extends StatelessWidget {
  const _PickerField({
    required this.label,
    required this.value,
    required this.onTap,
  });

  final String label;
  final String value;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _Label(label),
        const SizedBox(height: 6),
        GestureDetector(
          onTap: onTap,
          child: Container(
            height: 46,
            padding: const EdgeInsets.symmetric(horizontal: 14),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(AppRadius.input),
            ),
            alignment: Alignment.centerLeft,
            child: Text(
              value,
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: AppColors.textPrimary,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
