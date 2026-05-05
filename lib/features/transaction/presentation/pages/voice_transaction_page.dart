import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:money_management_mobile/core/routes/app_router.dart';
import 'package:money_management_mobile/core/theme/theme.dart';
import 'package:money_management_mobile/features/category/domain/entities/category_entity.dart';
import 'package:money_management_mobile/features/category/presentation/cubit/category_cubit.dart';
import 'package:money_management_mobile/features/category/presentation/cubit/category_state.dart';
import 'package:money_management_mobile/features/transaction/domain/entities/transaction_entity.dart';
import 'package:money_management_mobile/features/transaction/presentation/cubit/voice_transaction_cubit.dart';
import 'package:money_management_mobile/features/transaction/presentation/cubit/voice_transaction_state.dart';
import 'package:money_management_mobile/features/transaction/presentation/widgets/category_bottom_sheet.dart';
import 'package:money_management_mobile/features/transaction/presentation/widgets/voice_idle_view.dart';
import 'package:money_management_mobile/features/transaction/presentation/widgets/voice_listening_view.dart';
import 'package:money_management_mobile/features/transaction/presentation/widgets/voice_parsed_view.dart';
import 'package:money_management_mobile/features/transaction/presentation/widgets/voice_error_view.dart';
import 'package:money_management_mobile/features/transaction/presentation/widgets/voice_success_view.dart';

class VoiceTransactionPage extends StatefulWidget {
  const VoiceTransactionPage({super.key});

  @override
  State<VoiceTransactionPage> createState() => _VoiceTransactionPageState();
}

class _VoiceTransactionPageState extends State<VoiceTransactionPage> {
  int? _overrideCategoryId;
  String? _overrideCategoryName;

  List<CategoryEntity> _categoriesFor(TransactionType type) {
    final s = context.read<CategoryCubit>().state;
    if (s is CategoryLoaded) {
      return type == TransactionType.expense
          ? s.expenseCategories
          : s.incomeCategories;
    }
    return [];
  }

  Future<void> _showCategoryPicker(
      ParsedTransactionData data,
      int currentId,
      ) async {
    final categories = _categoriesFor(data.type);
    if (categories.isEmpty) return;

    final result = await showModalBottomSheet<int>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => CategoryBottomSheet(
        categories: categories,
        selectedCategory: currentId,
      ),
    );

    if (result != null && mounted) {
      final picked = categories.firstWhere(
            (c) => c.id == result,
        orElse: () => categories.first,
      );
      setState(() {
        _overrideCategoryId = picked.id;
        _overrideCategoryName = picked.name;
      });
    }
  }

  void _resetOverride() {
    _overrideCategoryId = null;
    _overrideCategoryName = null;
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<VoiceTransactionCubit, VoiceTransactionState>(
      listener: (context, state) {
        if (state is VoiceTransactionError) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(state.message,
                style: const TextStyle(color: AppColors.gohan)),
            backgroundColor: AppColors.danger100,
          ));
        }
        if (state is VoiceTransactionInitial || state is VoiceTransactionParsed) {
          _resetOverride();
        }
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: AppColors.gohan,
          appBar: _buildAppBar(context),
          body: SafeArea(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              transitionBuilder: (child, anim) => FadeTransition(
                opacity: anim,
                child: SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(0, 0.03),
                    end: Offset.zero,
                  ).animate(CurvedAnimation(parent: anim, curve: Curves.easeOut)),
                  child: child,
                ),
              ),
              child: _buildBody(context, state),
            ),
          ),
        );
      },
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      titleSpacing: 24,
      leading: Transform.translate(
        offset: const Offset(16, 0),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(10),
            ),
            child: IconButton(
              icon: const Icon(Icons.arrow_back, color: AppColors.gohan, size: 20),
              onPressed: () =>
              context.canPop() ? context.pop() : context.go(AppRouter.dashboard),
            ),
          ),
        ),
      ),
      title: const Text('Voice & Text Input',
          style: TextStyle(color: AppColors.bulma)),
    );
  }

  Widget _buildBody(BuildContext context, VoiceTransactionState state) {
    final cubit = context.read<VoiceTransactionCubit>();

    return switch (state) {
      VoiceTransactionInitial() => VoiceIdleView(
        key: const ValueKey('idle'),
        onStartListening: cubit.startListening,
        onSubmitText: cubit.submitTextInput,
      ),
      VoiceTransactionListening(transcript: final t, elapsed: final e) =>
          VoiceListeningView(
            key: const ValueKey('listening'),
            transcript: t,
            elapsed: e,
            onStop: cubit.stopListening,
          ),
      VoiceTransactionParsing() => const _LoadingView(
        key: ValueKey('parsing'),
        label: 'Memproses transaksi...',
      ),
      VoiceTransactionParsed(parsedData: final d) => VoiceParsedView(
        key: const ValueKey('parsed'),
        data: d,
        overrideCategoryId: _overrideCategoryId,
        overrideCategoryName: _overrideCategoryName,
        onShowCategoryPicker: _showCategoryPicker,
        onSave: () {
          if (_overrideCategoryId != null) {
            cubit.overrideParsedData(ParsedTransactionData(
              amount: d.amount,
              type: d.type,
              name: d.name,
              categoryName: _overrideCategoryName ?? d.categoryName,
              categoryId: _overrideCategoryId!,
              transactionAt: d.transactionAt,
              note: d.note,
            ));
          } else {
            cubit.saveTransaction();
          }
        },
        onReset: cubit.reset,
      ),
      VoiceTransactionParseError(rawInput: final raw) => VoiceErrorView(
        key: const ValueKey('error'),
        rawInput: raw,
        onReset: cubit.reset,
      ),
      VoiceTransactionSubmitting() => const _LoadingView(
        key: ValueKey('submitting'),
        label: 'Menyimpan transaksi...',
      ),
      VoiceTransactionSuccess(transaction: final t) => VoiceSuccessView(
        key: const ValueKey('success'),
        transaction: t,
        onHome: () =>
        context.canPop() ? context.pop() : context.go(AppRouter.dashboard),
        onDetail: () =>
        context.canPop() ? context.pop() : context.go(AppRouter.dashboard),
        onRecordAgain: cubit.reset,
      ),
      VoiceTransactionError() => VoiceIdleView(
        key: const ValueKey('idle-err'),
        onStartListening: cubit.startListening,
        onSubmitText: cubit.submitTextInput,
      ),
    };
  }
}

// Inline — too small to deserve its own file
class _LoadingView extends StatelessWidget {
  final String label;
  const _LoadingView({super.key, required this.label});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(color: AppColors.primary),
          const SizedBox(height: 20),
          Text(label, style: const TextStyle(color: AppColors.trunks, fontSize: 15)),
        ],
      ),
    );
  }
}