
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ПолныеПрава = РольДоступна("ПолныеПрава");
	
	ПоказыватьНедействительных = Ложь;
	ПоказатьНедействительных();
	Элементы.ФормаПереключитьПоказНедействительных.Пометка = ПоказыватьНедействительных;
	
КонецПроцедуры

&НаСервере
Процедура ПоказатьНедействительных()
	
	Если ПоказыватьНедействительных Тогда
		
		ОбщегоНазначенияКлиентСервер.УдалитьЭлементыГруппыОтбораДинамическогоСписка(
			Список, "Недействителен");		
		ОбщегоНазначенияКлиентСервер.УдалитьЭлементыГруппыОтбораДинамическогоСписка(
			Список, "ПометкаУдаления");		
			
	Иначе
		
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
			Список, "Недействителен", Ложь);
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
			Список, "ПометкаУдаления", Ложь);
			
	КонецЕсли;
		
КонецПроцедуры		

&НаСервере
Процедура ПереключитьПоказНедействительныхНаСервере()
	
	ПоказыватьНедействительных = Не ПоказыватьНедействительных;
	ПоказатьНедействительных();
	
КонецПроцедуры

&НаКлиенте
Процедура ПереключитьПоказНедействительных(Команда)
	
	ПереключитьПоказНедействительныхНаСервере();
	Элементы.ФормаПереключитьПоказНедействительных.Пометка = ПоказыватьНедействительных;
	
КонецПроцедуры

&НаКлиенте
Процедура Создать(Команда)
	
	Если ПолныеПрава Тогда
		
		ПараметрыФормы = Новый Структура;
	
		ОткрытьФорму("Справочник.Пользователи.Форма.ФормаЭлементаДляАдминистратора",
			ПараметрыФормы,
			ЭтаФорма,,,,
			,
			РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
			
	Иначе
				
		ПоказатьПредупреждение(, 
			НСтр("ru = 'Для добавления нового пользователя обратитесь к администратору программы.'"));
		
	КонецЕсли;	
	
КонецПроцедуры
