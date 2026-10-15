
import 'package:flutter/material.dart';

import '../../../../general/config/colors.dart';
import '../../../../general/utils/blank_space.dart';
import '../../../../general/utils/responsive.dart';

class CustomDrawerItem extends StatelessWidget {
  final String textt;
  final IconData suffixIcon;
  final String onTapp; // nombre de la ruta a la que vamos
  final VoidCallback? onTap; // accion opcional (ej. Logout) en vez de una ruta
  const CustomDrawerItem({super.key, required this.textt, required this.suffixIcon, required this.onTapp, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
              padding: EdgeInsets.only(
                bottom: twentyPixelHeight(context)*1
              ),
              child: InkWell(
                onTap: (){
                  if (onTap != null) {
                    onTap!();
                  } else if (onTapp.isNotEmpty) {
                    Navigator.pop(context); // cerramos el drawer
                    Navigator.pushNamed(context, onTapp);
                  }
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(suffixIcon,color: AppColor.whiteColor,),
                    horizontalSpace(twentyPixelWidth(context)*.5),
                    Text(
                      textt,
                      style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: Colors.white,
                          fontFamily: "Poppins"),
                    ),
                  ],
                ),
              ),
            );
  }
}

