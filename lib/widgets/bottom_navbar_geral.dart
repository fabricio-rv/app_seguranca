import 'package:flutter/material.dart';
import '../../widgets/modal_mensagem_sair_conta.dart';

class CustomBottomNavBarGeral extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onTap;

  const CustomBottomNavBarGeral({
    Key? key,
    required this.selectedIndex,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const azul = Color(0xFF181883);
    const unselectedColor = Color(0xFFB0B0B0);

    final bottomInset = MediaQuery.of(context).viewPadding.bottom;

    return Container(
      padding: EdgeInsets.only(
        top: 8,
        bottom: bottomInset > 0 ? bottomInset : 12,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 8,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _item(
            icon: Icons.home_rounded,
            label: 'Home',
            selected: selectedIndex == 0,
            onTap: () => onTap(0),
            selectedColor: azul,
            unselectedColor: unselectedColor,
          ),
          _item(
            icon: Icons.person_rounded,
            label: 'Perfil',
            selected: selectedIndex == 1,
            onTap: () => Navigator.pushNamed(context, '/perfil_adm'),
            selectedColor: azul,
            unselectedColor: unselectedColor,
          ),
          _item(
            icon: Icons.logout_rounded,
            label: 'Sair',
            selected: false,
            onTap: () => _abrirModalSair(context),
            selectedColor: Colors.red,
            unselectedColor: unselectedColor,
          ),
        ],
      ),
    );
  }

  void _abrirModalSair(BuildContext context) {
    showModalMensagemSairConta(
      context: context,
      onConfirmar: () {
        Navigator.pushNamedAndRemoveUntil(context, '/login', (_) => false);
      },
    );
  }

  Widget _item({
    required IconData icon,
    required String label,
    required bool selected,
    required VoidCallback onTap,
    required Color selectedColor,
    required Color unselectedColor,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      splashColor: selectedColor.withOpacity(0.12),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 2),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 24,
              color: selected ? selectedColor : unselectedColor,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
                color: selected ? selectedColor : unselectedColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
