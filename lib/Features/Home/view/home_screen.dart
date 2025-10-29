import 'package:flutter/material.dart';
import 'package:minhalistadecompras/Components/loading.dart';
import 'package:minhalistadecompras/features/Auth/view/login_screen.dart';
import 'package:minhalistadecompras/features/Home/model/shopping_list_model.dart';
import 'package:minhalistadecompras/features/Home/view_model/home_view_model.dart';
import 'package:minhalistadecompras/helper/validator.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => HomeViewModel(),
      child: const _HomeScreenContent(),
    );
  }
}

class _HomeScreenContent extends StatefulWidget {
  const _HomeScreenContent();

  @override
  State<_HomeScreenContent> createState() => _HomeScreenContentState();
}

enum CreateLocation {
  casa('Casa'),
  mercado('Mercado');

  final String value;
  const CreateLocation(this.value);
}

class _HomeScreenContentState extends State<_HomeScreenContent> {
  final _formKey = GlobalKey<FormState>();
  final _listNameTextFieldController = TextEditingController();
  final _marketTextFieldController = TextEditingController();
  bool _showError = false;
  CreateLocation? _locateSelected;

  void clearWidgets() {
    _listNameTextFieldController.clear();
    _marketTextFieldController.clear();
    _locateSelected = null;
    _showError = false;
  }

  // Create new shoppingList
  void _createShoppingList() async {
    if (_locateSelected != null) {
      final viewModel = context.read<HomeViewModel>();
      final success = await viewModel.createShoppingList(
        ShoppingListModel(
          createdAt: DateTime.now(),
          listName: _listNameTextFieldController.text,
          locationCreated: _locateSelected?.value ?? 'x',
          marketName: _marketTextFieldController.text,
        ),
      );
      Future.delayed(const Duration(seconds: 3));

      if (mounted) {
        Future.delayed(const Duration(seconds: 2));
        if (success) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Lista criada com sucesso!'),
              backgroundColor: Color(0xFF2ECC71),
              duration: Duration(seconds: 2),
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Erro ao criar lista!'),
              backgroundColor: Colors.red,
              duration: Duration(seconds: 2),
            ),
          );
        }
        clearWidgets();
      }
    }
  }

  void _logout() async {
    final viewModel = context.read<HomeViewModel>();
    final success = await viewModel.signOut();
    if (success) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
        (route) => false,
      );
    }
  }

  void _showCreateListForm() {
    final validatorHelper = Validator();
    _locateSelected = null;
    showModalBottomSheet(
      context: context,
      isDismissible: false,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => StatefulBuilder(
        builder: (BuildContext context, setState) => Container(
          padding: EdgeInsets.all(16),
          height: _locateSelected == CreateLocation.mercado
              ? MediaQuery.of(context).size.height * 0.6
              : MediaQuery.of(context).size.height * 0.5,
          child: Form(
            key: _formKey,
            child: Column(
              //mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    Container(
                      width: 50,
                      height: 5,
                      alignment: AlignmentDirectional(1, 0),
                      margin: EdgeInsets.only(bottom: 16),
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    Align(
                      alignment: AlignmentGeometry.directional(-1, 0),
                      child: Text(
                        'Nova Lista',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[800],
                        ),
                      ),
                    ),
                    Divider(color: Colors.grey[300]),
                    SizedBox(height: 16),

                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Nome',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                        SizedBox(height: 5),
                        TextFormField(
                          controller: _listNameTextFieldController,
                          decoration: InputDecoration(
                            hintText: 'Digite um nome para sua lista',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(
                                color: Color(0xFF2ECC71),
                                width: 2,
                              ),
                            ),
                          ),
                          validator: validatorHelper.validateListName,
                        ),
                      ],
                    ),

                    SizedBox(height: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Local de criação',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                        SizedBox(height: 5),

                        RadioGroup<CreateLocation>(
                          groupValue: _locateSelected,
                          onChanged: (CreateLocation? value) {
                            setState(() {
                              _locateSelected = value;
                              _showError = false;
                              print(_locateSelected);
                            });
                          },
                          child: const Column(
                            children: [
                              RadioListTile(
                                title: Text('Casa'),
                                value: CreateLocation.casa,
                              ),
                              RadioListTile(
                                title: Text('Mercado'),
                                value: CreateLocation.mercado,
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 5),

                        Visibility(
                          visible: _showError == true,
                          child: Container(
                            margin: EdgeInsetsDirectional.only(start: 15),
                            child: Text(
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.error,
                                fontSize: 12,
                              ),
                              'Campo obrigatório',
                            ),
                          ),
                        ),

                        // TEXTFIELD ENABLE SE RADIO = MERCADO
                        Visibility(
                          visible: _locateSelected == CreateLocation.mercado,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Mercado',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[600],
                                ),
                              ),
                              SizedBox(height: 5),
                              TextFormField(
                                controller: _marketTextFieldController,
                                decoration: InputDecoration(
                                  hintText: 'Digite o nome do mercado',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide(
                                      color: Color(0xFF2ECC71),
                                      width: 2,
                                    ),
                                  ),
                                ),
                                validator:
                                    _locateSelected == CreateLocation.mercado
                                    ? validatorHelper.validateMarketName
                                    : null,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 16),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: () {
                        clearWidgets();
                        Navigator.pop(context);
                      },
                      child: Text('Cancelar'),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        if (!_formKey.currentState!.validate() ||
                            _locateSelected == null) {
                          setState(() {
                            _showError = true;
                          });
                          return;
                        }
                        // CLOSE FORM
                        Navigator.pop(context);

                        showDialog(
                          context: context,
                          barrierDismissible:
                              true, // Não permite fechar clicando fora
                          builder: (context) => const ShoppingCartLoading(
                            message: 'Criando lista',
                          ),
                        );

                        _createShoppingList();
                        await Future.delayed(const Duration(seconds: 2));
                        Navigator.pop(context);
                        // Fechar o loading
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF2ECC71),
                      ),
                      child: Text('Criar'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showProfileDialog() {
    final viewModel = context.read<HomeViewModel>();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          spacing: 10.0,
          children: [
            CircleAvatar(
              backgroundColor: Color(0xFF2ECC71),
              radius: 25,
              child: Text(
                viewModel.getUserEmail().substring(0, 1).toUpperCase(),
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Perfil', style: TextStyle(fontSize: 18)),
                  Text(
                    viewModel.getUserEmail(),
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(Icons.edit, color: Color(0xFF2ECC71)),
              title: Text('Editar Perfil'),
              onTap: () {
                Navigator.pop(context);
                // TODO: Implementar edição de perfil
              },
            ),
            ListTile(
              leading: Icon(Icons.settings, color: Color(0xFF3498DB)),
              title: Text('Configurações'),
              onTap: () {
                Navigator.pop(context);
                // TODO: Implementar configurações
              },
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.logout, color: Colors.red),
              title: Text('Sair', style: TextStyle(color: Colors.red)),
              onTap: () {
                Navigator.pop(context);
                _logout();
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.read<HomeViewModel>();
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Color(0xFF2ECC71),
        title: Row(
          children: [
            Icon(Icons.shopping_bag, color: Colors.white),
            SizedBox(width: 8),
            Text(
              'Smart Market',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.notifications_outlined, color: Colors.white),
            onPressed: () {
              // TODO: Implementar notificações
            },
          ),
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: GestureDetector(
              onTap: _showProfileDialog,
              child: CircleAvatar(
                backgroundColor: Colors.white,
                child: Text(
                  viewModel.getUserEmail().substring(0, 1).toUpperCase(),
                  style: TextStyle(
                    color: Color(0xFF2ECC71),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          // Cabeçalho com boas-vindas
          Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF2ECC71), Color(0xFF27AE60)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Color(0xFF2ECC71).withOpacity(0.3),
                  blurRadius: 15,
                  offset: Offset(0, 5),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Olá! 👋',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  viewModel.getUserEmail(),
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white.withOpacity(0.9),
                  ),
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildStatCard(
                      'Listas',
                      '${viewModel.shoppingLists.length}',
                      Icons.list_alt,
                    ),
                    _buildStatCard('Gasto', 'R\$ 656', Icons.attach_money),
                  ],
                ),
              ],
            ),
          ),

          SizedBox(height: 24),

          // Título da seção
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Minhas Listas',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[800],
                ),
              ),
              TextButton.icon(
                onPressed: () {
                  // TODO: Ver todas as listas
                },
                icon: Icon(Icons.arrow_forward, size: 18),
                label: Text('Ver todas'),
                style: TextButton.styleFrom(foregroundColor: Color(0xFF2ECC71)),
              ),
            ],
          ),

          SizedBox(height: 12),

          // Lista de compras
          ...viewModel.shoppingLists.map(
            (list) => _buildShoppingListCard(list),
          ),

          SizedBox(height: 80), // Espaço para o FAB
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          _showCreateListForm();
        },
        backgroundColor: Color(0xFF2ECC71),
        label: Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildStatCard(String label, String value, IconData icon) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      width: 150,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Icon(icon, color: Colors.white, size: 24),
          SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: Colors.white.withOpacity(0.9),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildShoppingListCard(Map<String, dynamic> list) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {
            // TODO: Abrir detalhes da lista
          },
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: (list['color'] as Color).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(list['icon'], color: list['color'], size: 28),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        list['title'],
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[800],
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        '${list['items']} itens • R\$ ${list['total'].toStringAsFixed(2)}',
                        style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.grey[400],
                  size: 16,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
