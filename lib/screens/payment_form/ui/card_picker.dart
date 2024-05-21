import 'package:flutter/material.dart';

import '../../../../domain/tarlan_provider.dart';
import '../../../data/model/transaction/transaction_info.dart';
import '../../../utils/hex_color.dart';
import '../../../utils/space.dart';

class CardPicker extends StatefulWidget {
  final List<String> menuItems;
  final List<TransactionCard> cards;
  final TextEditingController controller;
  final TarlanProvider provider;

  const CardPicker({
    super.key,
    required this.menuItems,
    required this.cards,
    required this.controller,
    required this.provider,
  });

  @override
  State<StatefulWidget> createState() => _CardPickerState();
}

class _CardPickerState extends State<CardPicker> {
  // A map to keep track of the card being deleted
  final Map<String, bool> _deletingCards = {};

  LinearGradient mainGradient() {
    return LinearGradient(
      begin: Alignment.bottomLeft,
      end: Alignment.topRight,
      colors: [
        HexColor(widget.provider.colorsInfo.mainFormColor),
        HexColor(widget.provider.colorsInfo.secondaryFormColor),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final mainColor = HexColor(widget.provider.colorsInfo.mainTextInputColor);
    return Container(
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.only(topLeft: Radius.circular(16), topRight: Radius.circular(16)),
        gradient: mainGradient(),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: Space.m),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const SizedBox(width: 48), // Spacer to balance the close button
              Expanded(
                child: Text(
                  'Сохраненные карты',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.normal, color: mainColor),
                ),
              ),
              IconButton(
                icon: Icon(
                  Icons.cancel_rounded,
                  color: mainColor,
                ),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
          const SizedBox(height: Space.xxs),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: Container(
              decoration: BoxDecoration(gradient: mainGradient()),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                ),
                onPressed: () {
                  widget.controller.text = '';
                  widget.provider.switchToRegularPay();
                  widget.provider.notify();
                  Navigator.pop(context);
                },
                child: Text(
                  '+ Добавить новую карту',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.normal, color: mainColor),
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: widget.menuItems.length,
              itemBuilder: (BuildContext context, int index) {
                final item = widget.menuItems[index];
                final card = widget.cards.firstWhere((element) => element.maskedPan == item);
                return Column(
                  children: [
                    ListTile(
                      leading: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 300),
                        transitionBuilder: (Widget child, Animation<double> animation) {
                          return FadeTransition(opacity: animation, child: child);
                        },
                        child: _deletingCards[item] == true
                            ? Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: Icon(Icons.not_interested, color: mainColor),
                                    onPressed: () {
                                      // Cancel deletion
                                      setState(() {
                                        _deletingCards.remove(item);
                                      });
                                    },
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.check, color: mainColor),
                                    onPressed: () {
                                      widget.provider.deactivateCard(card.cardToken);
                                      setState(() {
                                        widget.cards.remove(card);
                                        if (widget.cards.isEmpty) {
                                          widget.controller.text = '';
                                          widget.provider.switchToRegularPay();
                                          widget.provider.notify();
                                          Navigator.pop(context);
                                        }
                                        _deletingCards.remove(item);
                                      });
                                    },
                                  ),
                                ],
                              )
                            : IconButton(
                                key: ValueKey<int>(index),
                                icon: Icon(Icons.delete_forever_outlined, color: mainColor),
                                onPressed: () {
                                  // Show confirm and cancel icons
                                  setState(() {
                                    _deletingCards[item] = true;
                                  });
                                },
                              ),
                      ),
                      title: Text(
                        item,
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.normal, color: mainColor),
                      ),
                      onTap: () {
                        widget.controller.text = item;
                        widget.provider.setOneClickCardToken(card.cardToken);
                        Navigator.pop(context);
                      },
                    ),
                    Divider(color: mainColor),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
