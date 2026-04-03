import 'package:flutter/material.dart';
import 'package:money_management_mobile/core/constants/global_constant.dart';
import 'package:money_management_mobile/core/theme/theme.dart';
import 'package:money_management_mobile/core/widgets/widgets.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class MonthYearDialogContent extends StatefulWidget {
  final int initialMonth;
  final int initialYear;
  final int? initialSelectedMonth;
  final int? initialSelectedYear;
  final int startYear;

  const MonthYearDialogContent({
    super.key,
    required this.initialMonth,
    required this.initialYear,
    this.initialSelectedMonth,
    this.initialSelectedYear,
    required this.startYear,
  });

  @override
  State<MonthYearDialogContent> createState() => _MonthYearDialogContentState();
}

class _MonthYearDialogContentState extends State<MonthYearDialogContent> {
  late List<int> yearList;
  final double itemHeight = 54;

  late final ScrollController monthController;
  late final ScrollController yearController;

  late int month;
  late int year;
  int? selectedMonth;
  int? selectedYear;
  double scrollProgress = 0.0;

  @override
  void initState() {
    super.initState();
    month = widget.initialMonth;
    year = widget.initialYear;
    selectedMonth = widget.initialSelectedMonth;
    selectedYear = widget.initialSelectedYear;

    yearList = List.generate(
      DateTime.now().year - widget.startYear + 1,
      (index) => widget.startYear + index,
    );

    monthController = ScrollController(
      initialScrollOffset: (month - 2) * itemHeight,
    );

    yearController = ScrollController(
      initialScrollOffset: (yearList.indexOf(year) - 1) * itemHeight,
    );
  }

  @override
  void dispose() {
    monthController.dispose();
    yearController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Pilih Bulan & Tahun',
                style: Theme.of(
                  context,
                ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
              ),
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: PhosphorIcon(
                  PhosphorIconsRegular.x,
                  color: AppColors.bulma,
                  size: 20,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSizes.spacing4),
          Container(
            height: 200,
            color: Colors.transparent,
            child: Row(
              children: [
                Expanded(
                  child: _buildScrollableList(
                    itemCount: 12,
                    selectedIndex: selectedMonth == null
                        ? -1
                        : selectedMonth! - 1,
                    onSelected: (index) {
                      final tappedMonth = index + 1;
                      setState(() {
                        if (selectedMonth == tappedMonth) {
                          selectedMonth = null;
                          return;
                        }

                        month = tappedMonth;
                        selectedMonth = tappedMonth;
                        selectedYear ??= year;
                      });
                    },
                    labelBuilder: (index) =>
                        GlobalConstant.monthMapping[index + 1]!,
                    controller: monthController,
                  ),
                ),
                const SizedBox(width: AppSizes.spacing4),
                Expanded(
                  child: _buildScrollableList(
                    itemCount: yearList.length,
                    selectedIndex: selectedYear == null
                        ? -1
                        : yearList.indexOf(selectedYear!),
                    onSelected: (index) {
                      final tappedYear = yearList[index];
                      setState(() {
                        if (selectedYear == tappedYear) {
                          selectedYear = null;
                          selectedMonth = null;
                          return;
                        }

                        year = tappedYear;
                        selectedYear = tappedYear;
                      });
                    },
                    labelBuilder: (index) => yearList[index].toString(),
                    controller: yearController,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSizes.spacing4),
          AppButton(
            text: 'Pilih',
            onPressed: () =>
                Navigator.pop(context, (selectedMonth, selectedYear)),
          ),
        ],
      ),
    );
  }

  Widget _buildScrollableList({
    required int itemCount,
    required int selectedIndex,
    required Function(int) onSelected,
    required String Function(int) labelBuilder,
    required ScrollController controller,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.gohan,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.beerus),
      ),
      child: ScrollConfiguration(
        behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
        child: ListView.builder(
          physics: const BouncingScrollPhysics(),
          controller: controller,
          padding: const EdgeInsets.symmetric(vertical: 8),
          itemCount: itemCount,
          itemBuilder: (context, index) {
            bool isSelected = selectedIndex == index;

            return GestureDetector(
              onTap: () => onSelected(index),
              child: Container(
                height: itemHeight,
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppColors.lightPrimary
                      : Colors.transparent,
                ),
                alignment: Alignment.center,
                child: Text(
                  labelBuilder(index),
                  style: TextStyle(
                    color: isSelected ? AppColors.primary : AppColors.trunks,
                    fontWeight: isSelected
                        ? FontWeight.bold
                        : FontWeight.normal,
                    fontSize: 14,
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
