abstract class ApiUrls {
  static const String baseUrl = 'https://olampardalar.uz/api';

  ///Workers
  static const String getAllWorker = '/ishchilar/';
  static const String createWorker = '/ishchilar/';
  static const String deleteWorker = '/ishchilar/';
  static const String updateWorker = '/ishchilar/';

  ///Customers
  static const String getAllCustomers = '/mijozlar/';
  static const String createCustomer = '/mijozlar/';
  static const String deleteCustomer = '/mijozlar/';
  static const String updateCustomer = '/mijozlar/';

  ///Dashboard
  static const String getDashboard = '/sotuv/bugun';
  static const String finishSales = '/sotuv/yakunlash';
  static const String workerDeail = '/sotuv/oylik/kun/ishchi';

  ///Tovar
  static const String getProducts = '/tovar/';
  static const String createProduct = '/tovar/';
  static const String delete = '/tovar/';

  ///Oylik Savdo
  static const String getMonthlySelling = '/tarix/oylik';

  ///Tarix
  static const String getHistory = '/tarix/';

  ///Harajat
  static const String getHarajat = '/xarajat/harajat';
  static const String postHarajat = '/xarajat/harajat';


}