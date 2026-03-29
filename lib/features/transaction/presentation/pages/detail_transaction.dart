import 'package:flutter/material.dart';
import '../widgets/transaction_components.dart';

const Color redAmount = Color(0xFFFF5252);
const Color greenAmount = Color(0xFF4CAF50);
const Color orangeButton = Color(0xFFFFA726);
const Color lightBlueBg = Color(0xFFF0F5FE);
const Color cyanBorder = Color(0xFF29B6F6);

class TransactionDetailScreen extends StatefulWidget {
  final bool isExpense;
  final String title;
  final String nominal;
  final String category;
  final IconData categoryIcon;
  final String date;
  final String note;

  const TransactionDetailScreen({
    super.key,
    required this.isExpense,
    required this.title,
    required this.nominal,
    required this.category,
    required this.categoryIcon,
    required this.date,
    required this.note,
  });

  @override
  State<TransactionDetailScreen> createState() =>
      _TransactionDetailScreenState();
}

class _TransactionDetailScreenState extends State<TransactionDetailScreen> {
  late final TextEditingController _titleController;
  late final TextEditingController _noteController;
  late String selectedCategory;
  late IconData selectedIcon;
  late String selectedDate;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.title);
    _noteController = TextEditingController(text: widget.note);
    selectedCategory = widget.category;
    selectedIcon = widget.categoryIcon;
    selectedDate = widget.date;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Color nominalColor = widget.isExpense ? redAmount : greenAmount;
    final Color boxBorderColor = widget.isExpense ? primaryBlue : cyanBorder;
    final String titleLabel = widget.isExpense
        ? 'Judul / Nama Transaksi'
        : 'Judul / Sumber Pemasukan';

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leadingWidth: 64,
        leading: Padding(
          padding: const EdgeInsets.only(left: 20.0, top: 10.0, bottom: 10.0),
          child: Container(
            decoration: const BoxDecoration(
              color: primaryBlue,
              shape: BoxShape.circle,
            ),
            child: IconButton(
              padding: EdgeInsets.zero,
              icon: const Icon(
                Icons.arrow_back_ios_new,
                color: Colors.white,
                size: 16,
              ),
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ),
        title: const Text(
          'Detail Transaksi',
          style: TextStyle(
            color: primaryBlue,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: lightBlueBg,
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: boxBorderColor, width: 1.5),
              ),
              child: Column(
                children: [
                  const Text(
                    'NOMINAL',
                    style: TextStyle(
                      color: primaryBlue,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                      letterSpacing: 1.2,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.nominal,
                    style: TextStyle(
                      color: nominalColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 28,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Icons.info, color: Colors.grey[600], size: 18),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Mengubah nominal ini akan secara otomatis memperbarui sisa batas harian Anda.',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 12,
                            height: 1.4,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),

            CustomEditableField(
              label: titleLabel,
              icon: Icons.edit_outlined,
              controller: _titleController,
            ),
            const SizedBox(height: 20),

            CustomDropdownField(
              label: 'Kategori',
              value: selectedCategory,
              icon: selectedIcon,
              onTap: () => _showCategoryDialog(context, widget.isExpense),
            ),
            const SizedBox(height: 20),

            CustomDropdownField(
              label: 'Tanggal',
              value: selectedDate,
              icon: Icons.calendar_today_outlined,
              onTap: () => _showDatePickerDialog(context, selectedDate),
            ),
            const SizedBox(height: 20),

            CustomEditableField(
              label: 'Catatan',
              icon: Icons.description_outlined,
              controller: _noteController,
            ),
            const SizedBox(height: 40),

            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _showDeleteConfirmationDialog(context),
                    icon: const Icon(
                      Icons.delete_outline,
                      color: redAmount,
                      size: 20,
                    ),
                    label: const Text(
                      'Hapus',
                      style: TextStyle(
                        color: redAmount,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      side: BorderSide(color: Colors.red[200]!, width: 1.5),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      // integrasi api update (kirim _titleController.text, selectedCategory, selectedDate, _noteController.text)
                    },
                    icon: const Icon(
                      Icons.check_circle,
                      color: Colors.white,
                      size: 20,
                    ),
                    label: const Text(
                      'Update',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: orangeButton,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  void _showDeleteConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          backgroundColor: Colors.white,
          insetPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 24,
          ),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: const BoxDecoration(
                    color: Color(0xFFFFEBEB),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.delete_outline,
                    color: redAmount,
                    size: 36,
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Hapus Catatan?',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'Yakin ingin menghapus catatan ini? Jatah\nharianmu akan dihitung ulang.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 13,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 30),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      // integrasi api delete dan penanganan error jika saldo minus
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFF4D4D),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    child: const Text(
                      'Ya, Hapus',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: Colors.blue[100]!, width: 1.5),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    child: Text(
                      'Batal',
                      style: TextStyle(
                        color: Colors.blue[600],
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // logika kalender detail
  void _showDatePickerDialog(BuildContext context, String currentDate) {
    DateTime initialDate = DateTime.now();
    try {
      final parts = currentDate.split('/');
      initialDate = DateTime(
        int.parse(parts[2]),
        int.parse(parts[0]),
        int.parse(parts[1]),
      );
    } catch (e) {}

    int displayMonth = initialDate.month;
    int displayYear = initialDate.year;
    DateTime? tempSelectedDate = initialDate;

    final List<String> monthNames = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'Mei',
      'Jun',
      'Jul',
      'Agu',
      'Sep',
      'Okt',
      'Nov',
      'Des',
    ];
    final List<int> years = List.generate(21, (index) => 2020 + index);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            int daysInMonth = DateTime(displayYear, displayMonth + 1, 0).day;
            int daysInPrevMonth = DateTime(displayYear, displayMonth, 0).day;
            int firstDayWeekday = DateTime(
              displayYear,
              displayMonth,
              1,
            ).weekday;
            int emptySlots = firstDayWeekday == 7 ? 0 : firstDayWeekday;
            int totalCells = ((emptySlots + daysInMonth) / 7).ceil() * 7;

            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              backgroundColor: const Color(0xFFF5F7FA),
              insetPadding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 24,
              ),
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Pilih Tanggal',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 24),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 20,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: Colors.grey[200]!,
                          width: 1.5,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.02),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              IconButton(
                                icon: const Icon(
                                  Icons.arrow_back_ios_new,
                                  size: 14,
                                  color: Colors.black87,
                                ),
                                padding: EdgeInsets.zero,
                                constraints: const BoxConstraints(),
                                onPressed: () => setStateDialog(() {
                                  if (displayMonth == 1) {
                                    displayMonth = 12;
                                    displayYear--;
                                  } else {
                                    displayMonth--;
                                  }
                                }),
                              ),
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: Colors.grey[300]!,
                                      ),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: DropdownButtonHideUnderline(
                                      child: DropdownButton<int>(
                                        value: displayMonth,
                                        isDense: true,
                                        icon: const Icon(
                                          Icons.keyboard_arrow_down,
                                          size: 18,
                                        ),
                                        items: List.generate(
                                          12,
                                          (index) => DropdownMenuItem(
                                            value: index + 1,
                                            child: Text(
                                              monthNames[index].substring(0, 3),
                                              style: const TextStyle(
                                                fontSize: 13,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ),
                                        onChanged: (val) => setStateDialog(
                                          () => displayMonth = val!,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: Colors.grey[300]!,
                                      ),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: DropdownButtonHideUnderline(
                                      child: DropdownButton<int>(
                                        value: displayYear,
                                        isDense: true,
                                        icon: const Icon(
                                          Icons.keyboard_arrow_down,
                                          size: 18,
                                        ),
                                        items: years
                                            .map(
                                              (y) => DropdownMenuItem(
                                                value: y,
                                                child: Text(
                                                  y.toString(),
                                                  style: const TextStyle(
                                                    fontSize: 13,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                            )
                                            .toList(),
                                        onChanged: (val) => setStateDialog(
                                          () => displayYear = val!,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              IconButton(
                                icon: const Icon(
                                  Icons.arrow_forward_ios,
                                  size: 14,
                                  color: Colors.black87,
                                ),
                                padding: EdgeInsets.zero,
                                constraints: const BoxConstraints(),
                                onPressed: () => setStateDialog(() {
                                  if (displayMonth == 12) {
                                    displayMonth = 1;
                                    displayYear++;
                                  } else {
                                    displayMonth++;
                                  }
                                }),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: ['Su', 'Mo', 'Tu', 'We', 'Th', 'Fr', 'Sa']
                                .map(
                                  (day) => SizedBox(
                                    width: 32,
                                    child: Text(
                                      day,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: Colors.grey[500],
                                        fontSize: 11,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                )
                                .toList(),
                          ),
                          const SizedBox(height: 12),
                          GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: totalCells,
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 7,
                                  mainAxisSpacing: 8,
                                  crossAxisSpacing: 8,
                                ),
                            itemBuilder: (context, index) {
                              int day;
                              bool isCurrentMonth = false;
                              if (index < emptySlots) {
                                day = daysInPrevMonth - emptySlots + index + 1;
                              } else if (index >= emptySlots + daysInMonth) {
                                day = index - (emptySlots + daysInMonth) + 1;
                              } else {
                                day = index - emptySlots + 1;
                                isCurrentMonth = true;
                              }

                              bool isSelected =
                                  isCurrentMonth &&
                                  tempSelectedDate != null &&
                                  tempSelectedDate!.day == day &&
                                  tempSelectedDate!.month == displayMonth &&
                                  tempSelectedDate!.year == displayYear;
                              Color textColor = isSelected
                                  ? Colors.white
                                  : (isCurrentMonth
                                        ? Colors.black87
                                        : Colors.grey[400]!);

                              return GestureDetector(
                                onTap: () {
                                  if (isCurrentMonth) {
                                    DateTime cellDate = DateTime(
                                      displayYear,
                                      displayMonth,
                                      day,
                                    );
                                    DateTime today = DateTime(
                                      DateTime.now().year,
                                      DateTime.now().month,
                                      DateTime.now().day,
                                    );

                                    // blokir tanggal masa depan
                                    if (!cellDate.isAfter(today)) {
                                      setStateDialog(
                                        () => tempSelectedDate = cellDate,
                                      );
                                    }
                                  }
                                },
                                child: Container(
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    color: isSelected
                                        ? const Color(0xFF373A40)
                                        : Colors.transparent,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Text(
                                    day.toString(),
                                    style: TextStyle(
                                      color: textColor,
                                      fontWeight: isSelected
                                          ? FontWeight.bold
                                          : FontWeight.w500,
                                      fontSize: 13,
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () => Navigator.pop(context),
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              side: BorderSide(
                                color: Colors.red[300]!,
                                width: 1.5,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: Text(
                              'Batal',
                              style: TextStyle(
                                color: Colors.red[400],
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              if (tempSelectedDate != null) {
                                setState(() {
                                  selectedDate =
                                      '${tempSelectedDate!.month.toString().padLeft(2, '0')}/${tempSelectedDate!.day.toString().padLeft(2, '0')}/${tempSelectedDate!.year}';
                                });
                              }
                              Navigator.pop(context);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: orangeButton,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: const Text(
                              'Pilih',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _showCategoryDialog(BuildContext context, bool isExpense) {
    final activeList = isExpense ? pengeluaranCategories : pemasukanCategories;
    
    String tempSelected = selectedCategory;
    if (!activeList.any((cat) => cat['name'] == tempSelected))
      tempSelected = activeList[0]['name'];

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              backgroundColor: Colors.white,
              insetPadding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 24,
              ),
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Semua Kategori',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 24),
                    Flexible(
                      child: GridView.builder(
                        shrinkWrap: true,
                        physics: const BouncingScrollPhysics(),
                        itemCount: activeList.length,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              childAspectRatio: 0.85,
                              crossAxisSpacing: 10,
                              mainAxisSpacing: 16,
                            ),
                        itemBuilder: (context, index) {
                          bool isSelected =
                              tempSelected == activeList[index]['name'];
                          bool isLainnya =
                              activeList[index]['name'] == 'Lainnya';
                          Color bgColor = isSelected
                              ? primaryBlue
                              : (isLainnya
                                    ? Colors.grey[300]!
                                    : const Color(0xFFE8F0FE));
                          Color iconColor = isSelected
                              ? Colors.white
                              : (isLainnya ? Colors.black87 : primaryBlue);

                          return GestureDetector(
                            onTap: () => setStateDialog(
                              () => tempSelected = activeList[index]['name'],
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    color: bgColor,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Icon(
                                    activeList[index]['icon'],
                                    color: iconColor,
                                    size: 28,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  activeList[index]['name'],
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.black87,
                                    fontSize: 9,
                                    fontWeight: isSelected
                                        ? FontWeight.bold
                                        : FontWeight.normal,
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            selectedCategory = tempSelected;
                            selectedIcon = activeList.firstWhere(
                              (cat) => cat['name'] == tempSelected,
                            )['icon'];
                          });
                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: orangeButton,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          elevation: 0,
                        ),
                        child: const Text(
                          'Konfirmasi Kategori',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
