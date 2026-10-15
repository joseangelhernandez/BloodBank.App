
import 'package:flutter/material.dart';

import '../../../../general/config/colors.dart';
import '../../../../general/utils/blank_space.dart';
import '../../../../general/utils/responsive.dart';


class FindDonorDatePicker extends StatefulWidget {
  // Avisa a la pantalla la fecha elegida.
  final ValueChanged<DateTime>? onChanged;
  // Fecha ya elegida (ej. al editar); si es null se muestra "Choose Date".
  final DateTime? initialValue;

  const FindDonorDatePicker({super.key, this.onChanged, this.initialValue});

  @override
  State<FindDonorDatePicker> createState() => _FindDonorDatePickerState();
}

class _FindDonorDatePickerState extends State<FindDonorDatePicker> {
  String? date;

  @override
  void initState() {
    super.initState();
    if (widget.initialValue != null) date = _format(widget.initialValue!);
  }

  String _format(DateTime d) => '${d.day}-${d.month}-${d.year}';

  _pickDate(context) async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: widget.initialValue,
      firstDate: DateTime(2000),
      lastDate: DateTime(2050),
    );

    // Si el usuario cancela, pickedDate es null y no hacemos nada.
    if (pickedDate == null) return;

    date = _format(pickedDate);
    setState(() {});
    widget.onChanged?.call(pickedDate);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Expanded(
          child: Container(
            width: double.infinity,
            height: twentyPixelHeight(context) * 2,
            decoration: BoxDecoration(
                color: AppColor.textLight,
                borderRadius: BorderRadius.circular(5)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                horizontalSpace(twentyPixelWidth(context) * .5),
                Text(
                  date ?? "Choose Date",
                  style: const TextStyle(
                    color: AppColor.textAss,
                    fontSize: 14,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w300,
                  ),
                  textScaler: TextScaler.linear(ScaleSize.textScaleFactor(context)),
                ),
              ],
            ),
          ),
        ),
        horizontalSpace(twentyPixelWidth(context)),
        InkWell(
          onTap: () {
            _pickDate(context);
          },
          child: Container(
            height: twentyPixelHeight(context) * 2,
            width: twentyPixelWidth(context) * 3,
            decoration: BoxDecoration(
                color: AppColor.redColor,
                borderRadius: BorderRadius.circular(5)),
            child: const Icon(
              Icons.calendar_month,
              color: AppColor.textLight,
            ),
          ),
        ),
      ],
    );
  }
}
