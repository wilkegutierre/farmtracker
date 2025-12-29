import 'package:farmtracker/domains/consts/app_strings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NaoExisteCulturaAreaCliente extends StatelessWidget {
  const NaoExisteCulturaAreaCliente({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: SizedBox(
        height: 160,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(AppStrings.nenhumaCulturaFoiInformada),
            Text(AppStrings.adicinoeUmaOuMaisCulturas),
          ],
        ),
      ),
    );
  }
}
