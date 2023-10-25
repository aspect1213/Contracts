#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Отбор.Свойство("ПометкаУдаления") И Не Параметры.Отбор.ПометкаУдаления Тогда 
		Элементы.ПоказыватьУдаленные.Видимость = Ложь;
	Иначе 
		ПоказыватьУдаленные = Ложь;
		ПоказатьУдаленные();
	КонецЕсли;
	
	ДоговорныеДокументы.СписокДокументовУсловноеОформлениеПомеченныхНаУдаление(Список);
	
КонецПроцедуры

&НаСервере
Процедура ПриЗагрузкеДанныхИзНастроекНаСервере(Настройки)
	
	Если Не Параметры.Отбор.Свойство("ПометкаУдаления") Тогда
		ПоказыватьУдаленные = Настройки["ПоказыватьУдаленные"];
		ПоказатьУдаленные();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ПоказыватьУдаленные(Команда)
	
	ПоказыватьУдаленные = Не ПоказыватьУдаленные;
	
	ПоказатьУдаленные();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ПоказатьУдаленные()
	
	Если ПоказыватьУдаленные Тогда
		ОбщегоНазначенияКлиентСервер.УдалитьЭлементыГруппыОтбораДинамическогоСписка(Список, "ПометкаУдаления");
	Иначе
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Список, "ПометкаУдаления", Ложь);
	КонецЕсли;
	
	Элементы.ПоказыватьУдаленные.Пометка = ПоказыватьУдаленные;
	
КонецПроцедуры

#КонецОбласти
