import 'dart:io';
import 'package:http/io_client.dart';
import 'package:path_provider/path_provider.dart';

class pdfUtils {
  Future<String?> loadPDF(String url) async {
    try{
      final ioClient = HttpClient()
        ..badCertificateCallback =
            (X509Certificate cert, String host, int port) => true;
      final client = IOClient(ioClient);
      final response = await client.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final tempDir = await getTemporaryDirectory();
        final file = File('${tempDir.path}/file.pdf');
        await file.writeAsBytes(response.bodyBytes, flush: true);
        return file.path;
      }else {
        throw Exception('Error al descargar PDF: ${response.statusCode}');
      }
    }catch(e){
      print(e);
      return null;
    }
  }
}