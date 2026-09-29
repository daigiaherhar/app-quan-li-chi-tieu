import 'package:quan_ly_chi_tieu/core/entities/transaction.dart';

abstract class LedgerRepository {
  Stream<List<TransactionEntity>> watchTransactions();
}
