import 'package:flutter/material.dart';

const Color primaryBlue = Color(0xFF2A62B8);

const List<String> months = ['Januari', 'Februari', 'Maret', 'April', 'Mei', 'Juni', 'Juli', 'Agustus', 'September', 'Oktober', 'November', 'Desember'];
final List<String> yearsList = List.generate(26, (index) => (2005 + index).toString());

const List<Map<String, dynamic>> pengeluaranCategories = [
  {'name': 'Makanan & Minuman', 'icon': Icons.local_cafe_outlined},
  {'name': 'Transportasi', 'icon': Icons.directions_car_outlined},
  {'name': 'Hobi', 'icon': Icons.videogame_asset_outlined},
  {'name': 'Belanja', 'icon': Icons.shopping_bag_outlined},
  {'name': 'Tagihan', 'icon': Icons.receipt_long_outlined},
  {'name': 'Kesehatan', 'icon': Icons.monitor_heart_outlined},
  {'name': 'Pendidikan', 'icon': Icons.school_outlined},
  {'name': 'Liburan', 'icon': Icons.flight_outlined},
  {'name': 'Binatang Peliharaan', 'icon': Icons.pets_outlined},
  {'name': 'Lainnya', 'icon': Icons.add_box_outlined},
];

const List<Map<String, dynamic>> pemasukanCategories = [
  {'name': 'Uang Saku', 'icon': Icons.monetization_on_outlined},
  {'name': 'Gaji', 'icon': Icons.account_balance_wallet_outlined},
  {'name': 'Investasi', 'icon': Icons.insert_chart_outlined},
  {'name': 'Hadiah', 'icon': Icons.card_giftcard_outlined},
  {'name': 'Pinjaman', 'icon': Icons.credit_card_outlined},
  {'name': 'Transfer Masuk', 'icon': Icons.payments_outlined},
  {'name': 'Lainnya', 'icon': Icons.add_box_outlined},
];

class FilterButton extends StatelessWidget {
  final IconData icon; final String text; final VoidCallback onTap;
  const FilterButton({super.key, required this.icon, required this.text, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10), decoration: BoxDecoration(color: Colors.grey[100], borderRadius: BorderRadius.circular(12)),
        child: Row(
          children: [
            Icon(icon, color: Colors.black87, size: 16), const SizedBox(width: 6),
            Expanded(child: Text(text, overflow: TextOverflow.ellipsis, style: const TextStyle(color: Colors.black87, fontSize: 12, fontWeight: FontWeight.bold))),
            const Icon(Icons.arrow_drop_down, color: Colors.black87),
          ],
        ),
      ),
    );
  }
}

class CustomBottomNav extends StatelessWidget {
  const CustomBottomNav({super.key});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      backgroundColor: primaryBlue, unselectedItemColor: Colors.white60, selectedItemColor: Colors.white,
      showSelectedLabels: true, showUnselectedLabels: true, selectedFontSize: 12, unselectedFontSize: 12, type: BottomNavigationBarType.fixed,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.receipt_long), label: 'Riwayat'), BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Beranda'), BottomNavigationBarItem(icon: Icon(Icons.tune), label: 'Pengaturan'),
      ],
    );
  }
}

class EmptyState extends StatelessWidget {
  const EmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 150, height: 150, decoration: BoxDecoration(color: const Color(0xFFFFF4E5), borderRadius: BorderRadius.circular(30)),
            child: Center(child: Container(width: 80, height: 90, decoration: BoxDecoration(border: Border.all(color: Colors.orange, width: 2), borderRadius: BorderRadius.circular(15)), child: const Icon(Icons.close, color: Colors.orange, size: 40))),
          ),
          const SizedBox(height: 24),
          const Text('Belum ada catatan', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87)),
          const SizedBox(height: 8),
          const Text('Yuk, mulai catat pengeluaranmu\nhari ini untuk kelola keuangan\nlebih baik!', textAlign: TextAlign.center, style: TextStyle(fontSize: 14, color: Color(0xFF757575), height: 1.5)),
          const SizedBox(height: 30),
          ElevatedButton.icon(
            onPressed: () {}, icon: const Icon(Icons.add, color: Colors.white), label: const Text('Tambah Transaksi', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
            style: ElevatedButton.styleFrom(backgroundColor: primaryBlue, padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
          ),
        ],
      ),
    );
  }
}

class SummaryCard extends StatelessWidget {
  final String title; final String amount;
  const SummaryCard({super.key, required this.title, required this.amount});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12), decoration: BoxDecoration(color: primaryBlue, borderRadius: BorderRadius.circular(15)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [Text(title, style: const TextStyle(color: Colors.white70, fontSize: 11)), const SizedBox(height: 8), Text(amount, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14))],
      ),
    );
  }
}

class DateHeader extends StatelessWidget {
  final String date;
  const DateHeader({super.key, required this.date});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 8),
        Text(date, style: const TextStyle(color: primaryBlue, fontWeight: FontWeight.bold, fontSize: 12)),
        const Divider(color: Colors.black12, thickness: 1, height: 16),
      ],
    );
  }
}

class TransactionItem extends StatelessWidget {
  final String title; final String category; final String amount; final IconData icon; final bool isExpense;
  const TransactionItem({super.key, required this.title, required this.category, required this.amount, required this.icon, required this.isExpense});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12), padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15), border: Border.all(color: Colors.grey[200]!)),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10), decoration: BoxDecoration(color: isExpense ? const Color(0xFFFFF4E5) : const Color(0xFFE8F5E9), borderRadius: BorderRadius.circular(12)),
            child: Icon(icon, color: Colors.black87, size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.black87)), const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2), decoration: BoxDecoration(color: isExpense ? Colors.red[50] : Colors.green[50], borderRadius: BorderRadius.circular(5)),
                  child: Text(category, style: TextStyle(color: isExpense ? Colors.red[300] : Colors.green[400], fontSize: 9, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ),
          Text(amount, style: TextStyle(color: isExpense ? const Color(0xFFFF5252) : const Color(0xFF4CAF50), fontWeight: FontWeight.bold, fontSize: 12)),
        ],
      ),
    );
  }
}

class CustomEditableField extends StatelessWidget {
  final String label; final IconData icon; final TextEditingController controller;
  const CustomEditableField({super.key, required this.label, required this.icon, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(color: Colors.grey[600], fontSize: 13)), const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.grey[300]!)),
          child: Row(
            children: [
              Icon(icon, color: Colors.grey[700], size: 20), const SizedBox(width: 12),
              Expanded(child: TextField(controller: controller, style: const TextStyle(color: Colors.black87, fontSize: 14, fontWeight: FontWeight.w500), decoration: const InputDecoration(border: InputBorder.none, isDense: true))),
            ],
          ),
        ),
      ],
    );
  }
}

class CustomDropdownField extends StatelessWidget {
  final String label; final String value; final IconData icon; final VoidCallback onTap;
  const CustomDropdownField({super.key, required this.label, required this.value, required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(color: Colors.grey[600], fontSize: 13)), const SizedBox(height: 8),
        GestureDetector(
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.grey[300]!)),
            child: Row(
              children: [
                Icon(icon, color: Colors.grey[700], size: 20), const SizedBox(width: 12),
                Expanded(child: Text(value, style: const TextStyle(color: Colors.black87, fontSize: 14, fontWeight: FontWeight.w500))), Icon(Icons.keyboard_arrow_down, color: Colors.grey[600], size: 24),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class CategoryDialogContent extends StatefulWidget {
  final String initialCategory;
  const CategoryDialogContent({super.key, required this.initialCategory});
  @override State<CategoryDialogContent> createState() => _CategoryDialogContentState();
}

class _CategoryDialogContentState extends State<CategoryDialogContent> {
  String type = 'Pengeluaran'; 
  late String selected; 

  @override 
  void initState() { 
    super.initState(); 
    selected = widget.initialCategory; 
  }

  @override
  Widget build(BuildContext context) {
    final activeList = type == 'Pengeluaran' ? pengeluaranCategories : pemasukanCategories;
    
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Semua Kategori', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black87)),
          const SizedBox(height: 16),
          
          CustomDropdown(
            items: const ['Pengeluaran', 'Pemasukan'], value: type, 
            onChanged: (val) { setState(() { type = val!; selected = ''; }); }
          ),
          const SizedBox(height: 24),
          
          Container(
            height: 300, 
            color: Colors.transparent,
            child: GridView.builder(
              physics: const BouncingScrollPhysics(), 
              itemCount: activeList.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, childAspectRatio: 0.85, crossAxisSpacing: 10, mainAxisSpacing: 16),
              itemBuilder: (context, index) {
                bool isSelected = selected == activeList[index]['name'];
                bool isLainnya = activeList[index]['name'] == 'Lainnya'; 
                
                Color bgColor = isSelected ? primaryBlue : (isLainnya ? Colors.grey[200]! : const Color(0xFFE8F0FE));
                Color iconColor = isSelected ? Colors.white : (isLainnya ? Colors.black54 : primaryBlue);

                return GestureDetector(
                  onTap: () => setState(() => selected = activeList[index]['name']),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(16), 
                        decoration: BoxDecoration(color: bgColor, borderRadius: BorderRadius.circular(20)), 
                        child: Icon(activeList[index]['icon'], color: iconColor, size: 28)
                      ),
                      const SizedBox(height: 8),
                      Text(activeList[index]['name'], textAlign: TextAlign.center, style: TextStyle(color: Colors.black87, fontSize: 9, fontWeight: isSelected ? FontWeight.bold : FontWeight.normal)),
                    ],
                  ),
                );
              },
            ),
          ),
          
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity, height: 50,
            child: ElevatedButton(
              onPressed: () => selected.isNotEmpty ? Navigator.pop(context, selected) : null,
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFFFA726), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)), elevation: 0),
              child: const Text('Konfirmasi Kategori', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 16)),
            ),
          ),
        ],
      ),
    );
  }
}

class MonthYearDialogContent extends StatefulWidget {
  final String initialMonth; final String initialYear;
  const MonthYearDialogContent({super.key, required this.initialMonth, required this.initialYear});
  @override State<MonthYearDialogContent> createState() => _MonthYearDialogContentState();
}

class _MonthYearDialogContentState extends State<MonthYearDialogContent> {
  late String month; late String year;
  double scrollProgress = 0.0;
  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState(); month = widget.initialMonth; year = widget.initialYear;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Container(
                decoration: BoxDecoration(color: primaryBlue, borderRadius: BorderRadius.circular(10)),
                child: IconButton(icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 16), onPressed: () => Navigator.pop(context), constraints: const BoxConstraints(minWidth: 35, minHeight: 35), padding: EdgeInsets.zero),
              ),
              const SizedBox(width: 16),
              const Text('Pilih Bulan dan Tahun', style: TextStyle(color: primaryBlue, fontWeight: FontWeight.bold, fontSize: 14)),
            ],
          ),
          const SizedBox(height: 24),
          
          Container(
            height: 350,
            color: Colors.transparent,
            child: Column(
              children: [
                Center(
                  child: Container(
                    height: 35, padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(color: Colors.grey[50], borderRadius: BorderRadius.circular(10), border: Border.all(color: Colors.grey[200]!)),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: year, menuMaxHeight: 250, icon: const Icon(Icons.arrow_drop_down, color: primaryBlue),
                        style: const TextStyle(color: primaryBlue, fontWeight: FontWeight.bold, fontSize: 14),
                        items: yearsList.map((val) => DropdownMenuItem(value: val, child: Text(val))).toList(),
                        onChanged: (val) => setState(() => year = val!),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                
                Expanded(
                  child: Row(
                    children: [
                      Expanded(
                        child: NotificationListener<ScrollNotification>(
                          onNotification: (notif) {
                            if (notif.metrics.maxScrollExtent > 0) {
                              setState(() => scrollProgress = (notif.metrics.pixels / notif.metrics.maxScrollExtent).clamp(0.0, 1.0));
                            }
                            return false;
                          },
                          child: ScrollConfiguration(
                            behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
                            child: ListView.builder(
                              controller: scrollController, physics: const BouncingScrollPhysics(),
                              itemCount: months.length,
                              itemBuilder: (context, index) {
                                bool isSelected = month == months[index];
                                return GestureDetector(
                                  onTap: () => setState(() => month = months[index]),
                                  child: Container(
                                    margin: const EdgeInsets.only(bottom: 12, right: 16, left: 16), padding: const EdgeInsets.symmetric(vertical: 12),
                                    decoration: BoxDecoration(color: Colors.grey[50], borderRadius: BorderRadius.circular(10), border: Border.all(color: isSelected ? Colors.transparent : Colors.transparent)),
                                    alignment: Alignment.center,
                                    child: Text(months[index], style: TextStyle(color: isSelected ? primaryBlue : const Color(0xFFB0BEC5), fontWeight: FontWeight.bold, fontSize: 14)),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                      Container(
                        width: 20, decoration: BoxDecoration(color: Colors.grey[100], borderRadius: BorderRadius.circular(10)),
                        child: Column(
                          children: [
                            GestureDetector(
                              onTap: () => scrollController.animateTo(scrollController.offset - 60, duration: const Duration(milliseconds: 200), curve: Curves.easeOut),
                              child: const Padding(padding: EdgeInsets.only(top: 4.0, bottom: 2.0), child: Icon(Icons.keyboard_arrow_up, color: primaryBlue, size: 16)),
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 6.0),
                                child: LayoutBuilder(
                                  builder: (context, constraints) {
                                    return Container(
                                      color: Colors.transparent,
                                      child: Align(alignment: Alignment(0, -1.0 + (scrollProgress * 2.0)), child: Container(height: 30, decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(10)))),
                                    );
                                  },
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () => scrollController.animateTo(scrollController.offset + 60, duration: const Duration(milliseconds: 200), curve: Curves.easeOut),
                              child: const Padding(padding: EdgeInsets.only(top: 2.0, bottom: 4.0), child: Icon(Icons.keyboard_arrow_down, color: primaryBlue, size: 16)),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity, height: 50,
            child: ElevatedButton(
              onPressed: () => Navigator.pop(context, '$month $year'),
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFFFA726), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)), elevation: 0),
              child: const Text('Pilih', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 16)),
            ),
          ),
        ],
      ),
    );
  }
}

class CustomDropdown extends StatelessWidget {
  final List<String> items; final String value; final ValueChanged<String?> onChanged;
  const CustomDropdown({super.key, required this.items, required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40, padding: const EdgeInsets.symmetric(horizontal: 16), decoration: BoxDecoration(color: Colors.grey[100], borderRadius: BorderRadius.circular(10)),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value, menuMaxHeight: 250, icon: const Icon(Icons.keyboard_arrow_down, color: Colors.black87), borderRadius: BorderRadius.circular(10),
          style: const TextStyle(color: Colors.black87, fontWeight: FontWeight.bold, fontSize: 13), items: items.map((val) => DropdownMenuItem(value: val, child: Text(val))).toList(), onChanged: onChanged,
        ),
      ),
    );
  }
}