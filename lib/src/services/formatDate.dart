
import 'package:intl/intl.dart';

class FormatDatee {

  String formatPastDate(String date,bool isTodayInHour){    
    String resultDate;    
  
    DateTime now = DateTime.now();
    DateTime startYear = DateTime(now.year, 1,1);
  
    DateTime fromDate = DateTime.parse(date);
  
    int todayDay = now.difference(startYear).inDays;
    int deliveryDay = fromDate.difference(startYear).inDays;    

    if(todayDay == deliveryDay && isTodayInHour == true){
      resultDate = DateFormat.jm().format(
        DateTime.parse(date)
      );
    } else if(todayDay == deliveryDay && isTodayInHour != true){
      resultDate = 'hoy';

    } else if(todayDay - 1 == deliveryDay){
      resultDate = 'ayer';
    } else if(todayDay - 2 == deliveryDay){
      resultDate = 'antier';
    } else if(todayDay - 3 == deliveryDay){
      resultDate = DateFormat('EEEE', 'es_MX').format(fromDate);
    } else if(todayDay - 4 == deliveryDay){
      resultDate = DateFormat('EEEE', 'es_MX').format(fromDate);
    } else if(todayDay - 5 == deliveryDay){
      resultDate = DateFormat('EEEE', 'es_MX').format(fromDate);
    } else {
      resultDate = DateFormat.yMd('es').format(fromDate);
    }

    return resultDate;
  }

  String formatPastDateMessages(String date,bool isTodayInHour){    
    String resultDate;    
  
    DateTime now = DateTime.now();
  
    DateTime fromDate = DateTime.parse(
      DateFormat('yyyy-MM-dd').format(DateTime.parse(date))      
    );
  
    int diference = now.difference(fromDate).inDays;
  

    if(diference == 0 && isTodayInHour == true){
      resultDate = DateFormat.jm().format(
        DateTime.parse(date)
      );
    } else if(diference == 0 && isTodayInHour != true){
      resultDate = 'hoy';

    } else if(diference == 1){
      resultDate = 'ayer';
    } else if(diference == 2){
      resultDate = 'antier';
    } else if(diference == 3){
      resultDate = DateFormat('EEEE', 'es_MX').format(fromDate);
    } else if(diference == 4){
      resultDate = DateFormat('EEEE', 'es_MX').format(fromDate);
    } else if(diference == 5){
      resultDate = DateFormat('EEEE', 'es_MX').format(fromDate);
    } else {
      resultDate = DateFormat.yMd('es').format(fromDate);
    }

    return resultDate;
  }
}