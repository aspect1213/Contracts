
Функция ПолучитьПараметрыНумерации(Объект) Экспорт 
	
	СтруктураПараметров = Новый Структура;
	СтруктураПараметров.Вставить("ЧисловойНомер", 	Объект.ЧисловойНомер);
	СтруктураПараметров.Вставить("ДатаДокумента", 	Объект.ДатаДокумента);
	СтруктураПараметров.Вставить("ВидДокумента", 	Объект.ВидДокумента);
	СтруктураПараметров.Вставить("Ответственный", 	Объект.Ответственный);
	СтруктураПараметров.Вставить("Ссылка", 			Объект.Ссылка);
	СтруктураПараметров.Вставить("Контрагент", 		Объект.Контрагент);
	СтруктураПараметров.Вставить("Родитель",		Объект.Родитель);
	Возврат СтруктураПараметров;
	
КонецФункции	
