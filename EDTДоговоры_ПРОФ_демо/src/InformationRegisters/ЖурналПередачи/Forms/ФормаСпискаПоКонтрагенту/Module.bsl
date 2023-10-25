
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Контрагент = Параметры.Контрагент;
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(Список.Отбор, 
		"Пользователь", Контрагент);
		
	Заголовок = СтрШаблон(НСтр("ru = 'Журнал передачи контрагенту %1'"),
		Строка(Контрагент));
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура СписокПриАктивизацииСтроки(Элемент)
	
	ТекущиеДанные = Элементы.Список.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда 
		Элементы.ОтметитьВозврат.Доступность = Ложь;
		Возврат;
	КонецЕсли;	
	
	Элементы.ОтметитьВозврат.Доступность = Не ТекущиеДанные.Возвращен;
	
КонецПроцедуры

&НаКлиенте
Процедура СписокПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа, Параметр)
	
	Отказ = Истина;
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("Режим", "СоздатьПоКонтрагенту");
	ПараметрыФормы.Вставить("Пользователь", Контрагент);
	
	ОткрытьФорму("РегистрСведений.ЖурналПередачи.ФормаЗаписи", ПараметрыФормы,,,,,, 
		РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

&НаКлиенте
Процедура СписокПередНачаломИзменения(Элемент, Отказ)
	
	Отказ = Истина;
	
	ТекущиеДанные = Элементы.Список.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда 
		Возврат;
	КонецЕсли;
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("Режим", "Открыть");
	ПараметрыФормы.Вставить("Документ", ТекущиеДанные.Документ);
	ПараметрыФормы.Вставить("Пользователь", Контрагент);
	
	ОткрытьФорму("РегистрСведений.ЖурналПередачи.ФормаЗаписи", ПараметрыФормы,,,,,, 
		РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОтметитьВозврат(Команда)
	
	ТекущиеДанные = Элементы.Список.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда 
		Возврат;
	КонецЕсли;
	
	УстановитьВозвращен(ТекущиеДанные.Документ);
	
	ПоказатьОповещениеПользователя(
			НСтр("ru = 'Документ отмечен как возвращенный от контрагента'"), 
			ПолучитьНавигационнуюСсылку(ТекущиеДанные.Документ));
			
	Оповестить("ИзмененЖурналПередачи", ТекущиеДанные.Документ);
	
	Элементы.Список.Обновить();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервереБезКонтекста
Процедура УстановитьВозвращен(Документ)
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	ЖурналПередачи.Период КАК Период,
		|	ЖурналПередачи.Документ КАК Документ
		|ИЗ
		|	РегистрСведений.ЖурналПередачи КАК ЖурналПередачи
		|ГДЕ
		|	ЖурналПередачи.Документ = &Документ
		|	И ЖурналПередачи.Возвращен = ЛОЖЬ";
	Запрос.УстановитьПараметр("Документ", Документ);
		
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда 
		МенеджерЗаписи = РегистрыСведений.ЖурналПередачи.СоздатьМенеджерЗаписи();
		МенеджерЗаписи.Документ = Выборка.Документ;
		МенеджерЗаписи.Период = Выборка.Период;
		МенеджерЗаписи.Прочитать();
		
		Если МенеджерЗаписи.Возвращен Тогда 
			Возврат;
		КонецЕсли;	
	
		МенеджерЗаписи.Возвращен = Истина;
		МенеджерЗаписи.ДатаВозврата = ТекущаяДата();
		МенеджерЗаписи.Записать();
	КонецЕсли;
	
КонецПроцедуры	

#КонецОбласти
