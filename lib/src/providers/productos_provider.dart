import 'dart:convert';
import 'dart:io';
import 'package:formvalidation/src/preferencias_usuario/preferencias_usuario.dart';
import 'package:mime_type/mime_type.dart';
import 'package:http_parser/http_parser.dart';

import 'package:http/http.dart' as http;
import 'package:formvalidation/src/models/producto_model.dart';


class ProductosProvider{
  // Url de la base de datos de firebase
  final String _url = 'https://flutter-varios-f6c9b.firebaseio.com';
  final prefs = new PreferenciasUsuario();

 Future<bool> crearProducto(ProductoModel produto ) async {

   // Petición post para insertar un nuevo registro
   final url = '$_url/productos.json?auth=${prefs.token}';

   final resp = await http.post(url,body: productoModelToJson(produto));

  final decodedData = json.decode(resp.body);

  print(decodedData);

  return true;
  }

  Future<bool> editarProducto(ProductoModel producto ) async {

   // Petición post para insertar un nuevo registro
   final url = '$_url/productos/${producto.id}.json?auth=${prefs.token}';

   final resp = await http.put(url,body: productoModelToJson(producto));

  final decodedData = json.decode(resp.body);

  print(decodedData);

  return true;
  }

// Listar productos
  Future<List<ProductoModel>> cargarProductos() async{
    final url = '$_url/productos.json?auth=${prefs.token}';
    final resp = await http.get(url);

    //Extraer la informacion
    final  Map<String,dynamic> decodedData = json.decode(resp.body);
    final List<ProductoModel> productos = new List();
    
    //print(decodedData);
    if(decodedData == null) return [];

    // Recorrer el decodedData
    decodedData.forEach((id,prod){
      print(id);
      final productTemp = ProductoModel.fromJson(prod);
      productTemp.id = id;

      //Almacenarlo en la lista
      productos.add(productTemp);
    });

    print(productos);
    return productos;
  }

  Future<int> borrarProducto(String id) async{
    final url = '$_url/productos/$id.json?auth=${prefs.token}';
    final resp = await http.delete(url);

    print(json.decode(resp.body));

    return 1;
  }

  Future<String> subirImagen(File imagen)async{
    final url = Uri.parse('https://api.cloudinary.com/v1_1/detgodfbg/image/upload?upload_preset=cwye3brj');
    final mimeType = mime(imagen.path).split('/'); //image/jpg

    final imagenUploadRequest = http.MultipartRequest(
      'POST',
      url
    );

    // Preparar el archivo para adjuntarlo
    final file = await http.MultipartFile.fromPath(
      'file', 
      imagen.path,
      contentType: MediaType(mimeType[0],mimeType[1])
      );
      imagenUploadRequest.files.add(file);

      final streamResponse = await imagenUploadRequest.send();
      final resp = await http.Response.fromStream(streamResponse);

      if(resp.statusCode !=200 && resp.statusCode !=201){
        print('Algo salió mal');
        print(resp.body);

        return null;
      }
      final respData = json.decode(resp.body);
      print(respData);

      return respData['secure_url'];
  }
}