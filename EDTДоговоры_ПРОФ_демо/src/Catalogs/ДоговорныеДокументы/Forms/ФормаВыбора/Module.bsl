
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("Документы") Тогда
		
		Список.Параметры.УстановитьЗначениеПараметра("МассивСсылок", Параметры.Документы);
		
	КонецЕсли;
	
	ПоказыватьУдаленные = Ложь;
	ПоказатьУдаленные();
	
	ДоговорныеДокументы.СписокДокументовУсловноеОформлениеПомеченныхНаУдаление(Список);
	
	Состояние = "МоиАктивные";
	УстановитьОтборСписка();
	ОбщегоНазначенияДокументооборотКлиентСервер.ПоказатьСкрытьКнопкуОчисткиОтбора(
		Элементы.ОтборСостояниеДокумента, Состояние, "ВсеДокументы");
	
КонецПроцедуры

&НаСервере
Процедура ПриЗагрузкеДанныхИзНастроекНаСервере(Настройки)
	
	ПоказыватьУдаленные = Настройки["ПоказыватьУдаленные"];
	ПоказатьУдаленные();
	
	УстановитьОтборСписка();
	ОбщегоНазначенияДокументооборотКлиентСервер.ПоказатьСкрытьКнопкуОчисткиОтбора(
		Элементы.ОтборСостояниеДокумента, Состояние, "ВсеДокументы");
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура СписокВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	ВыбратьВыполнить();
КонецПроцедуры

&НаКлиенте
Процедура ОтборСостояниеДокументаОчистка(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Состояние = "ВсеДокументы";
	
	УстановитьОтборСписка();
	
	ОбщегоНазначенияДокументооборотКлиентСервер.ПоказатьСкрытьКнопкуОчисткиОтбора(Элемент, Состояние, "ВсеДокументы");
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборСостояниеДокументаПриИзменении(Элемент)
	
	Если Не ЗначениеЗаполнено(Состояние) Тогда 
		Состояние = "ВсеДокументы";
	КонецЕсли;	
	
	УстановитьОтборСписка();
	
	ОбщегоНазначенияДокументооборотКлиентСервер.ПоказатьСкрытьКнопкуОчисткиОтбора(Элемент, Состояние, "ВсеДокументы");
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Выбрать(Команда)
	ВыбратьВыполнить();
КонецПроцедуры

&НаКлиенте
Процедура ПоказыватьУдаленные(Команда)
	
	ПоказыватьУдаленные = Не ПоказыватьУдаленные;
	
	ПоказатьУдаленные();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ВыбратьВыполнить()
	
	Если Элементы.Список.ТекущаяСтрока <> Неопределено Тогда
		ОповеститьОВыборе(Элементы.Список.ТекущаяСтрока);
	КонецЕсли;	
	
КонецПроцедуры

&НаСервере
Процедура ПоказатьУдаленные()
	
	Если ПоказыватьУдаленные Тогда
		ОбщегоНазначенияКлиентСервер.УдалитьЭлементыГруппыОтбораДинамическогоСписка(Список, "ПометкаУдаления");
	Иначе
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Список, "ПометкаУдаления", Ложь);
	КонецЕсли;
	
	Элементы.ПоказыватьУдаленные.Пометка = ПоказыватьУдаленные;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьОтборСписка()
	
	ТекущийПользователь = ПользователиКлиентСервер.ТекущийПользователь();
	Если Состояние = "МоиАктивные" Тогда 
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(Список.Отбор,
			"Закрыт",
			Ложь);
			
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(Список.Отбор,
			"Ответственный",
			ТекущийПользователь);	
			
		Элементы.Ответственный.Видимость = Ложь;
	Иначе
		ОбщегоНазначенияКлиентСервер.УдалитьЭлементыГруппыОтбора(Список.Отбор,
			"Закрыт");
			
		ОбщегоНазначенияКлиентСервер.УдалитьЭлементыГруппыОтбора(Список.Отбор,
			"Ответственный");
			
		Элементы.Ответственный.Видимость = Истина;	
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
