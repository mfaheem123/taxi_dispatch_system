import 'package:flutter/material.dart';

class CabFlowStripeScreen extends StatefulWidget {
  final String pkrAmount;
  final String gbpAmount;
  final String defaultEmail;

  const CabFlowStripeScreen({
    super.key,
    this.pkrAmount = "PKR 56,613.07",
    this.gbpAmount = "£146.01",
    this.defaultEmail = "you@gmail.com",
  });

  @override
  State<CabFlowStripeScreen> createState() => _CabFlowStripeScreenState();
}

class _CabFlowStripeScreenState extends State<CabFlowStripeScreen> {
  bool isPkrSelected = true;
  String selectedCountry = "Pakistan";

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _cardNumberController = TextEditingController();
  final TextEditingController _expiryController = TextEditingController();
  final TextEditingController _cvcController = TextEditingController();
  final TextEditingController _cardholderController = TextEditingController();

  final List<String> _countries = [
    "Pakistan",
    "United Kingdom",
    "United States",
    "United Arab Emirates",
    "Saudi Arabia",
  ];

  @override
  void initState() {
    super.initState();
    // _emailController.text = widget.defaultEmail;
  }

  @override
  void dispose() {
    _emailController.dispose();
    _cardNumberController.dispose();
    _expiryController.dispose();
    _cvcController.dispose();
    _cardholderController.dispose();
    super.dispose();
  }

  String get _activeAmountText =>
      isPkrSelected ? widget.pkrAmount : widget.gbpAmount;

  @override
  Widget build(BuildContext context) {
    const Color bgWhite = Colors.white;
    const Color borderGrey = Color(0xFFE0E6ED);
    const Color textDark = Color(0xFF1A1F36);
    const Color textMuted = Color(0xFF697386);
    const Color textLight = Color(0xFF8792A2);
    const Color stripeBlue = Color(0xFF0074D4);

    return Scaffold(
      backgroundColor: bgWhite,
      body: LayoutBuilder(
        builder: (context, outerConstraints) {
          final bool isWide = outerConstraints.maxWidth >= 820;

          final Widget leftColumn = SizedBox(
            width: isWide ? 360 : double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //  CabFlow | Sandbox
                Row(
                  children: [
                    InkWell(
                      onTap: () {
                        if (Navigator.of(context).canPop()) {
                          Navigator.of(context).pop();
                        }
                      },
                      borderRadius: BorderRadius.circular(4),
                      child: const Padding(
                        padding: EdgeInsets.all(2),
                        child: Icon(
                          Icons.arrow_back,
                          size: 15,
                          color: textMuted,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Container(
                      width: 20,
                      height: 20,
                      decoration: BoxDecoration(
                        color: const Color(0xFFF4F6F8),
                        borderRadius: BorderRadius.circular(3),
                        border: Border.all(color: borderGrey),
                      ),
                      child: const Icon(
                        Icons.storefront_outlined,
                        size: 12,
                        color: textMuted,
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      "CabFlow",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: textDark,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 7,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1D5B8C),
                        borderRadius: BorderRadius.circular(3),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.view_in_ar,
                            size: 11,
                            color: Colors.white,
                          ),
                          SizedBox(width: 3),
                          Text(
                            "Sandbox",
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 28),

                const Text(
                  "Pay CabFlow",
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: textMuted,
                  ),
                ),

                const SizedBox(height: 18),

                const Text(
                  "Choose currency",
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: textDark,
                  ),
                ),

                const SizedBox(height: 12),

                // PKR & GBP Buttons
                Row(
                  children: [
                    Expanded(
                      child: _CurrencyTile(
                        label: widget.pkrAmount,
                        flagType: _FlagType.pk,
                        isSelected: isPkrSelected,
                        onTap: () => setState(() => isPkrSelected = true),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _CurrencyTile(
                        label: widget.gbpAmount,
                        flagType: _FlagType.gb,
                        isSelected: !isPkrSelected,
                        onTap: () => setState(() => isPkrSelected = false),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 10),

                const Text(
                  "1 GBP ≈ 387.7342 PKR (includes 4% conversion fee)",
                  style: TextStyle(
                    fontSize: 11,
                    color: textLight,
                  ),
                ),

                const SizedBox(height: 32),

                // Booking Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Booking",
                      style: TextStyle(
                        fontSize: 13.5,
                        fontWeight: FontWeight.w600,
                        color: textDark,
                      ),
                    ),
                    Text(
                      _activeAmountText,
                      style: const TextStyle(
                        fontSize: 13.5,
                        fontWeight: FontWeight.w600,
                        color: textDark,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );

          final Widget rightColumn = SizedBox(
            width: isWide ? 420 : double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Stripe Button
                SizedBox(
                  width: double.infinity,
                  height: 44,
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0A0A0A),
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.bolt, size: 17, color: Colors.white),
                        SizedBox(width: 5),
                        Text(
                          "Stripe",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.2,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 18),

                const Center(
                  child: Text(
                    "OR",
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: textLight,
                    ),
                  ),
                ),

                const SizedBox(height: 18),

                // Contact information
                const Text(
                  "Contact information",
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: textDark,
                  ),
                ),
                const SizedBox(height: 8),

                Container(
                  height: 42,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: bgWhite,
                    borderRadius: BorderRadius.circular(5),
                    border: Border.all(color: borderGrey),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.03),
                        blurRadius: 3,
                        offset: const Offset(0, 1),
                      ),
                    ],
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(
                        width: 62,
                        child: Text(
                          "Email",
                          style: TextStyle(
                            fontSize: 13,
                            color: textLight,
                          ),
                        ),
                      ),
                      Expanded(
                        child: TextField(
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          style: const TextStyle(
                            fontSize: 13,
                            color: textDark,
                          ),
                          decoration: InputDecoration(
                            isDense: true,
                            hintText: widget.defaultEmail,
                            hintStyle: const TextStyle(
                              fontSize: 13,
                              color: Color(0xFF9AA5B4),
                            ),
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.zero,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 22),

                // Payment method
                const Text(
                  "Payment method",
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: textDark,
                  ),
                ),
                const SizedBox(height: 10),

                Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFFFAFBFD),
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: borderGrey),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.04),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Card Header Row
                      Container(
                        height: 40,
                        padding: const EdgeInsets.symmetric(horizontal: 14),
                        decoration: const BoxDecoration(
                          color: bgWhite,
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(6),
                          ),
                        ),
                        child: const Row(
                          children: [
                            Icon(
                              Icons.credit_card,
                              size: 16,
                              color: textDark,
                            ),
                            SizedBox(width: 9),
                            Text(
                              "Card",
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: textDark,
                              ),
                            ),
                          ],
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.fromLTRB(14, 12, 14, 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Card information",
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: textMuted,
                              ),
                            ),
                            const SizedBox(height: 7),

                            Container(
                              decoration: BoxDecoration(
                                color: bgWhite,
                                borderRadius: BorderRadius.circular(5),
                                border: Border.all(color: borderGrey),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.025),
                                    blurRadius: 2,
                                    offset: const Offset(0, 1),
                                  ),
                                ],
                              ),
                              child: Column(
                                children: [
                                  SizedBox(
                                    height: 40,
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: TextField(
                                            controller: _cardNumberController,
                                            keyboardType: TextInputType.number,
                                            style: const TextStyle(
                                              fontSize: 13,
                                              color: textDark,
                                            ),
                                            decoration: const InputDecoration(
                                              hintText: "Card Number",
                                              hintStyle: TextStyle(
                                                color: Color(0xFF9AA5B4),
                                                fontSize: 13,
                                              ),
                                              border: InputBorder.none,
                                              contentPadding:
                                              EdgeInsets.symmetric(
                                                horizontal: 12,
                                                vertical: 11,
                                              ),
                                            ),
                                          ),
                                        ),
                                        const Padding(
                                          padding: EdgeInsets.only(right: 10),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              _MiniCardLogo(brand: _CardBrand.mastercard),
                                              SizedBox(width: 4),
                                              _MiniCardLogo(brand: _CardBrand.visa),
                                              SizedBox(width: 4),
                                              _MiniCardLogo(brand: _CardBrand.amex),
                                              SizedBox(width: 4),
                                              _MiniCardLogo(brand: _CardBrand.discover),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const Divider(height: 1, color: borderGrey),
                                  SizedBox(
                                    height: 40,
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: TextField(
                                            controller: _expiryController,
                                            keyboardType: TextInputType.datetime,
                                            style: const TextStyle(
                                              fontSize: 13,
                                              color: textDark,
                                            ),
                                            decoration: const InputDecoration(
                                              hintText: "MM / YY",
                                              hintStyle: TextStyle(
                                                color: Color(0xFF9AA5B4),
                                                fontSize: 13,
                                              ),
                                              border: InputBorder.none,
                                              contentPadding:
                                              EdgeInsets.symmetric(
                                                horizontal: 12,
                                                vertical: 11,
                                              ),
                                            ),
                                          ),
                                        ),
                                        Container(
                                          width: 1,
                                          height: double.infinity,
                                          color: borderGrey,
                                        ),
                                        Expanded(
                                          child: TextField(
                                            controller: _cvcController,
                                            keyboardType: TextInputType.number,
                                            style: const TextStyle(
                                              fontSize: 13,
                                              color: textDark,
                                            ),
                                            decoration: const InputDecoration(
                                              hintText: "CVC",
                                              hintStyle: TextStyle(
                                                color: Color(0xFF9AA5B4),
                                                fontSize: 13,
                                              ),
                                              suffixIcon: Padding(
                                                padding:
                                                EdgeInsets.only(right: 10),
                                                child: Icon(
                                                  Icons.credit_card_outlined,
                                                  size: 17,
                                                  color: textLight,
                                                ),
                                              ),
                                              suffixIconConstraints:
                                              BoxConstraints(
                                                minWidth: 22,
                                                minHeight: 22,
                                              ),
                                              border: InputBorder.none,
                                              contentPadding:
                                              EdgeInsets.symmetric(
                                                horizontal: 12,
                                                vertical: 11,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(height: 14),

                            const Text(
                              "Cardholder name",
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: textMuted,
                              ),
                            ),
                            const SizedBox(height: 7),

                            Container(
                              height: 40,
                              decoration: BoxDecoration(
                                color: bgWhite,
                                borderRadius: BorderRadius.circular(5),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.025),
                                    blurRadius: 2,
                                    offset: const Offset(0, 1),
                                  ),
                                ],
                              ),
                              child: TextField(
                                controller: _cardholderController,
                                style: const TextStyle(
                                  fontSize: 13,
                                  color: textDark,
                                ),
                                decoration: InputDecoration(
                                  hintText: "Full name on card",
                                  hintStyle: const TextStyle(
                                    color: Color(0xFF9AA5B4),
                                    fontSize: 13,
                                  ),
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 11,
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5),
                                    borderSide:
                                    const BorderSide(color: borderGrey),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5),
                                    borderSide:
                                    const BorderSide(color: stripeBlue),
                                  ),
                                ),
                              ),
                            ),

                            const SizedBox(height: 14),

                            const Text(
                              "Country or region",
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: textMuted,
                              ),
                            ),
                            const SizedBox(height: 7),

                            Container(
                              height: 40,
                              decoration: BoxDecoration(
                                color: bgWhite,
                                borderRadius: BorderRadius.circular(5),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.025),
                                    blurRadius: 2,
                                    offset: const Offset(0, 1),
                                  ),
                                ],
                              ),
                              child: DropdownButtonFormField<String>(
                                value: selectedCountry,
                                isExpanded: true,
                                icon: const Icon(
                                  Icons.keyboard_arrow_down,
                                  size: 18,
                                  color: textMuted,
                                ),
                                style: const TextStyle(
                                  fontSize: 13,
                                  color: textDark,
                                ),
                                decoration: InputDecoration(
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 9,
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5),
                                    borderSide:
                                    const BorderSide(color: borderGrey),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5),
                                    borderSide:
                                    const BorderSide(color: stripeBlue),
                                  ),
                                ),
                                items: _countries
                                    .map(
                                      (c) => DropdownMenuItem<String>(
                                    value: c,
                                    child: Text(c),
                                  ),
                                )
                                    .toList(),
                                onChanged: (val) {
                                  if (val != null) {
                                    setState(() => selectedCountry = val);
                                  }
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // Pay Button
                SizedBox(
                  width: double.infinity,
                  height: 42,
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: stripeBlue,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                    child: const Text(
                      "Pay",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );

          if (isWide) {
            return Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 44),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 1120),
                  child: IntrinsicHeight(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Expanded(
                          child: Align(
                            alignment: Alignment.topCenter,
                            child: Padding(
                              padding: const EdgeInsets.only(top: 12),
                              child: leftColumn,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 36),
                          child: VerticalDivider(
                            width: 1,
                            thickness: 1,
                            color: borderGrey.withOpacity(0.75),
                          ),
                        ),
                        Expanded(
                          child: Align(
                            alignment: Alignment.topCenter,
                            child: rightColumn,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                leftColumn,
                const SizedBox(height: 28),
                const Divider(height: 1, color: borderGrey),
                const SizedBox(height: 28),
                rightColumn,
              ],
            ),
          );
        },
      ),
    );
  }
}

enum _FlagType { pk, gb }

class _CurrencyTile extends StatelessWidget {
  final String label;
  final _FlagType flagType;
  final bool isSelected;
  final VoidCallback onTap;

  const _CurrencyTile({
    required this.label,
    required this.flagType,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(5),
      child: Container(
        height: 40,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : const Color(0xFFF6F8FA),
          borderRadius: BorderRadius.circular(5),
          border: Border.all(
            color: isSelected
                ? const Color(0xFF1A1F36)
                : const Color(0xFFE0E6ED),
            width: isSelected ? 1.5 : 1.0,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _MiniFlag(type: flagType),
            const SizedBox(width: 7),
            Flexible(
              child: Text(
                label,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1A1F36),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MiniFlag extends StatelessWidget {
  final _FlagType type;

  const _MiniFlag({required this.type});

  @override
  Widget build(BuildContext context) {
    if (type == _FlagType.pk) {
      return Container(
        width: 18,
        height: 12,
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(2),
          border: Border.all(color: const Color(0xFFD9E2EC), width: 0.6),
        ),
        child: Row(
          children: [
            Container(
              width: 5,
              color: Colors.white,
            ),
            Expanded(
              child: Container(
                color: const Color(0xFF01411C),
                child: Center(
                  child: SizedBox(
                    width: 9,
                    height: 9,
                    child: Stack(
                      children: [
                        Positioned(
                          left: 0.8,
                          top: 1.4,
                          child: Container(
                            width: 6.2,
                            height: 6.2,
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                        Positioned(
                          left: 2.5,
                          top: 0.6,
                          child: Container(
                            width: 5.2,
                            height: 5.2,
                            decoration: const BoxDecoration(
                              color: Color(0xFF01411C),
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                        Positioned(
                          right: 0.3,
                          top: 0.8,
                          child: Transform.rotate(
                            angle: 0.35,
                            child: const Icon(
                              Icons.star,
                              size: 3.6,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      width: 18,
      height: 12,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: const Color(0xFF012169),
        borderRadius: BorderRadius.circular(2),
        border: Border.all(color: const Color(0xFFD9E2EC), width: 0.6),
      ),
      child: Stack(
        children: [
          Positioned.fill(
            child: Transform.rotate(
              angle: 0.58,
              child: Center(
                child: Container(
                  height: 2.2,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          Positioned.fill(
            child: Transform.rotate(
              angle: -0.58,
              child: Center(
                child: Container(
                  height: 2.2,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          Center(
            child: Container(
              width: 3.4,
              height: double.infinity,
              color: Colors.white,
            ),
          ),
          Center(
            child: Container(
              width: double.infinity,
              height: 3.4,
              color: Colors.white,
            ),
          ),
          Center(
            child: Container(
              width: 2.0,
              height: double.infinity,
              color: const Color(0xFFC8102E),
            ),
          ),
          Center(
            child: Container(
              width: double.infinity,
              height: 2.0,
              color: const Color(0xFFC8102E),
            ),
          ),
        ],
      ),
    );
  }
}

enum _CardBrand { mastercard, visa, amex, discover }

class _MiniCardLogo extends StatelessWidget {
  final _CardBrand brand;

  const _MiniCardLogo({required this.brand});

  @override
  Widget build(BuildContext context) {
    switch (brand) {
      case _CardBrand.mastercard:
        return Container(
          width: 24,
          height: 15,
          decoration: BoxDecoration(
            color: const Color(0xFF141A2A),
            borderRadius: BorderRadius.circular(2.5),
          ),
          child: Center(
            child: SizedBox(
              width: 16,
              height: 10,
              child: Stack(
                children: [
                  Positioned(
                    left: 0,
                    child: Container(
                      width: 10,
                      height: 10,
                      decoration: const BoxDecoration(
                        color: Color(0xFFEB001B),
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                  Positioned(
                    right: 0,
                    child: Container(
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                        color: const Color(0xFFF79E1B).withOpacity(0.92),
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );

      case _CardBrand.visa:
        return Container(
          width: 24,
          height: 15,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(2.5),
            border: Border.all(color: const Color(0xFFD9E2EC), width: 0.7),
          ),
          child: const Text(
            "VISA",
            style: TextStyle(
              fontSize: 7.5,
              fontWeight: FontWeight.w900,
              fontStyle: FontStyle.italic,
              color: Color(0xFF1A1F71),
              letterSpacing: -0.3,
            ),
          ),
        );

      case _CardBrand.amex:
        return Container(
          width: 24,
          height: 15,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: const Color(0xFF2E77BC),
            borderRadius: BorderRadius.circular(2.5),
          ),
          child: const Text(
            "AMEX",
            style: TextStyle(
              fontSize: 6.2,
              fontWeight: FontWeight.w800,
              color: Colors.white,
              letterSpacing: -0.2,
            ),
          ),
        );

      case _CardBrand.discover:
        return Container(
          width: 24,
          height: 15,
          padding: const EdgeInsets.symmetric(horizontal: 2),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(2.5),
            border: Border.all(color: const Color(0xFFD9E2EC), width: 0.7),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "DISC",
                style: TextStyle(
                  fontSize: 5.5,
                  fontWeight: FontWeight.w900,
                  color: Color(0xFF1A1F36),
                  letterSpacing: -0.3,
                ),
              ),
              Container(
                width: 4.5,
                height: 4.5,
                margin: const EdgeInsets.only(left: 0.5),
                decoration: const BoxDecoration(
                  color: Color(0xFFF76B1C),
                  shape: BoxShape.circle,
                ),
              ),
            ],
          ),
        );
    }
  }
}