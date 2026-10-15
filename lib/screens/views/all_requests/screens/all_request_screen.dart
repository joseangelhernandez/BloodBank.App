import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../general/utils/blank_space.dart';
import '../../../../general/utils/responsive.dart';
import '../../../../providers/blood_request_provider.dart';
import '../../components/widgets/custom_appbar.dart';
import '../../components/widgets/custom_blood_filter_box.dart';
import '../../home/widgets/request_feed_item.dart';

class AllRequestScreen extends StatefulWidget {
  static const pageRoute = "/all-request";
  const AllRequestScreen({super.key});

  @override
  State<AllRequestScreen> createState() => _AllRequestScreenState();
}

class _AllRequestScreenState extends State<AllRequestScreen> {
  @override
  void initState() {
    super.initState();
    // El filtro arranca en "All": cargamos la lista sin filtro.
    // Esperamos a que termine el primer build para poder usar el provider.
    Future.microtask(() => _onFilterChanged("All"));
  }

  // Cambia el filtro del provider y recarga la lista filtrada.
  // El Home usa otra lista, asi que no hay que limpiar nada al salir.
  Future<void> _onFilterChanged(String group) async {
    final provider = context.read<BloodRequestProvider>();
    // "All" significa sin filtro.
    await provider.setBloodGroup(group == "All" ? null : group);

    if (!mounted) return;
    if (provider.errorMessage != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          content: Text(provider.errorMessage!),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(titlee: "Blood Requests", actionTrue: true),
      body: Padding(
        padding: EdgeInsets.only(
          left: twentyPixelWidth(context),
          right: twentyPixelWidth(context),
        ),
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  verticalSpace(twentyPixelHeight(context)),

                  CustomBloodFilterBox(onChanged: _onFilterChanged),
                ],
              ),
            ),
            // Una tarjeta por cada solicitud, con el mismo espacio de antes.
            // Solo esta parte se reconstruye cuando cambia la lista.
            Consumer<BloodRequestProvider>(
              builder: (context, provider, child) {
                final requests = provider.filteredRequests;
                return SliverList.builder(
                  itemCount: requests.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: EdgeInsets.only(
                        top: twentyPixelHeight(context) * 1,
                      ),
                      child: CustomRequestFeedItem(request: requests[index]),
                    );
                  },
                );
              },
            ),
            SliverToBoxAdapter(
              child: verticalSpace(twentyPixelHeight(context) * 1.5),
            ),
          ],
        ),
      ),
    );
  }
}
