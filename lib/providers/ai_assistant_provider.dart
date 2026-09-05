import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/ai_message_model.dart';
import 'transaction_provider.dart';

final aiAssistantProvider = NotifierProvider<AIAssistantNotifier, List<AIMessageModel>>(() {
  return AIAssistantNotifier();
});

class AIAssistantNotifier extends Notifier<List<AIMessageModel>> {
  static final List<AIMessageModel> _initialMessages = [
    AIMessageModel(
      id: 'msg_welcome',
      text: "Hello Akash! 👋 I'm your AI Financial Co-Pilot. I monitor your cash flow, budget limits, upcoming bills, and savings opportunities.\n\nHow can I help you optimize your finances today?",
      isUser: false,
      timestamp: DateTime.now().subtract(const Duration(minutes: 10)),
      quickSuggestions: [
        'Where am I spending the most?',
        'How can I save ₹10,000 this month?',
        'Analyze my spending',
        'Can I afford this?',
        'Show my biggest expenses',
      ],
    ),
    AIMessageModel(
      id: 'msg_u1',
      text: 'Where am I spending the most?',
      isUser: true,
      timestamp: DateTime.now().subtract(const Duration(minutes: 8)),
    ),
    AIMessageModel(
      id: 'msg_a1',
      text: 'Shopping is currently your highest spending category at ₹16,100, which represents 38% of your total monthly expenses (₹42,350).\n\nFood & Dining follows in second place at ₹9,317 (22%).',
      isUser: false,
      timestamp: DateTime.now().subtract(const Duration(minutes: 8)),
      quickSuggestions: [
        'How can I reduce shopping?',
        'What is my remaining budget?',
      ],
    ),
    AIMessageModel(
      id: 'msg_u2',
      text: 'How can I save ₹10,000 this month?',
      isUser: true,
      timestamp: DateTime.now().subtract(const Duration(minutes: 5)),
    ),
    AIMessageModel(
      id: 'msg_a2',
      text: 'Based on your spending pattern, you could save approximately ₹10,000 by:\n\n• Reducing shopping by ₹4,000\n• Cutting food delivery by ₹2,000\n• Trimming entertainment by ₹1,500\n• Keeping ₹2,500 from your remaining discretionary budget.\n\nThis will boost your projected savings from ₹26,150 to over ₹36,000!',
      isUser: false,
      timestamp: DateTime.now().subtract(const Duration(minutes: 5)),
      quickSuggestions: [
        'Set this as my savings goal',
        'Show my biggest expenses',
      ],
    ),
  ];

  @override
  List<AIMessageModel> build() {
    return _initialMessages;
  }

  void sendMessage(String query) {
    final userMsg = AIMessageModel(
      id: 'msg_u_${DateTime.now().millisecondsSinceEpoch}',
      text: query,
      isUser: true,
      timestamp: DateTime.now(),
    );

    state = [...state, userMsg];

    // Generate smart context-aware response based on live data
    final botResponse = _generateResponse(query);
    final botMsg = AIMessageModel(
      id: 'msg_a_${DateTime.now().millisecondsSinceEpoch}',
      text: botResponse.text,
      isUser: false,
      timestamp: DateTime.now(),
      quickSuggestions: botResponse.suggestions,
    );

    state = [...state, botMsg];
  }

  _BotReply _generateResponse(String input) {
    final query = input.toLowerCase();
    final expenses = ref.read(totalExpensesProvider);
    final income = ref.read(totalIncomeProvider);
    final savings = ref.read(totalSavingsProvider);
    final categories = ref.read(categorySpendingProvider);
    final topCat = categories.isNotEmpty ? categories.first : null;

    if (query.contains('where') && (query.contains('spending') || query.contains('most'))) {
      if (topCat != null) {
        return _BotReply(
          text: "${topCat.category} is currently your highest spending category at ₹${topCat.amount.toStringAsFixed(0)}, which represents ${topCat.percentage.toStringAsFixed(1)}% of your monthly expenses (₹${expenses.toStringAsFixed(0)}).\n\nWould you like me to create an alert when ${topCat.category} exceeds 80%?",
          suggestions: ['Set budget alert', 'Analyze my spending', 'How can I save money?'],
        );
      }
    }

    if (query.contains('save') && (query.contains('10,000') || query.contains('10000') || query.contains('money'))) {
      return _BotReply(
        text: 'Based on your spending pattern, you could save approximately ₹10,000 by reducing shopping by ₹4,000, food delivery by ₹2,000 and entertainment by ₹1,500, while keeping ₹2,500 from your remaining discretionary budget.\n\nThis would put your total monthly savings at ₹${(savings + 10000).toStringAsFixed(0)}.',
        suggestions: ['Show savings goals', 'Analyze my spending', 'Can I afford this?'],
      );
    }

    if (query.contains('analyze') || query.contains('analysis')) {
      return _BotReply(
        text: "📊 Here is your comprehensive monthly financial audit:\n\n• Total Income: ₹${income.toStringAsFixed(0)}\n• Total Spent: ₹${expenses.toStringAsFixed(0)} (70.6% of ₹60k budget)\n• Net Savings: ₹${savings.toStringAsFixed(0)}\n• Spending Velocity: ₹1,411/day\n\n💡 Insight: Your essential vs discretionary spending ratio is 42:58. Trimming discretionary dining and impulse shopping can unlock extra wealth.",
        suggestions: ['Where am I spending the most?', 'How can I save ₹10,000 this month?', 'Show my biggest expenses'],
      );
    }

    if (query.contains('afford') || query.contains('buy') || query.contains('purchase')) {
      return _BotReply(
        text: "Checking your financial safety net... 🔍\n\nWith ₹${savings.toStringAsFixed(0)} in monthly free cash flow and a healthy Emergency Fund at 75% funded, you can comfortably afford purchases under ₹15,000 without disturbing your essential commitments.",
        suggestions: ['Can I afford ₹25,000?', 'Show my biggest expenses', 'Analyze my spending'],
      );
    }

    if (query.contains('biggest') || query.contains('largest') || query.contains('top expense')) {
      final txs = ref.read(transactionsProvider).where((t) => t.isExpense).toList();
      txs.sort((a, b) => b.amount.compareTo(a.amount));
      final top3 = txs.take(3).map((t) => "• ${t.title} (${t.category}): ₹${t.amount.toStringAsFixed(0)}").join('\n');

      return _BotReply(
        text: "Here are your 3 largest transactions this month:\n\n$top3\n\nThese 3 purchases account for ${((txs.take(3).fold(0.0, (s, e) => s + e.amount) / expenses) * 100).toStringAsFixed(1)}% of all expenses.",
        suggestions: ['Where am I spending the most?', 'How can I save ₹10,000 this month?'],
      );
    }

    return _BotReply(
      text: "I analyzed your query in relation to your current ₹${income.toStringAsFixed(0)} income and ₹${expenses.toStringAsFixed(0)} outflow.\n\nYour financial health score is 88/100 (Strong). You are on track with your ₹60,000 monthly limit. What specific advice or breakdown can I generate for you?",
      suggestions: [
        'Where am I spending the most?',
        'How can I save ₹10,000 this month?',
        'Analyze my spending',
      ],
    );
  }
}

class _BotReply {
  final String text;
  final List<String> suggestions;

  _BotReply({required this.text, required this.suggestions});
}
