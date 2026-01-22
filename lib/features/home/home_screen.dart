import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smartcamp_gazarecovery/core/routes.dart';
import 'presentation/cubit/home_cubit.dart';
import 'package:smartcamp_gazarecovery/features/home/presentation/cubit/home_state.dart' as hs;
import '../details/details_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    context.read<HomeCubit>().loadItems();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      body: BlocBuilder<HomeCubit, hs.HomeState>(
        builder: (context, state) {
          if (state is hs.HomeLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is hs.HomeLoaded) {
            return ListView.builder(
              itemCount: state.items.length,
              itemBuilder: (context, index) {
                final item = state.items[index];
                return ListTile(
                  title: Text(item),
                  onTap: () {
                    // Navigate with typed args
                    final args = DetailsArgs(title: item, id: index);
                    Navigator.of(context).pushNamed(AppRoutes.details, arguments: args);
                  },
                );
              },
            );
          } else if (state is hs.HomeError) {
            return Center(child: Text('Error: ${state.message}'));
          }
          return const Center(child: Text('No data'));
        },
      ),
    );
  }
}
