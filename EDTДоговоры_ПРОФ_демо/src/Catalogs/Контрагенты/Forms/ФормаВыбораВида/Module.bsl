#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	СписокВидовОпераций.Добавить(Перечисления.ЮридическоеФизическоеЛицо.ЮридическоеЛицо, 
		НСтр("ru = 'Юридическое лицо'"));
		
	СписокВидовОпераций.Добавить(Перечисления.ЮридическоеФизическоеЛицо.ФизическоеЛицо,
		НСтр("ru = 'Физическое лицо'"));
	
	СписокВидовОпераций.Добавить(Перечисления.ЮридическоеФизическоеЛицо.ИндивидуальныйПредприниматель,
		НСтр("ru = 'Индивидуальный предприниматель'"));
		
	Если Параметры.Свойство("РежимВыбора") Тогда 
		РежимВыбора = Параметры.РежимВыбора;
	КонецЕсли;		
	
	Если Параметры.Свойство("ТекстЗаполнения") Тогда 
		ТекстЗаполнения = Параметры.ТекстЗаполнения;
	КонецЕсли;
	
	Если Параметры.Свойство("АдресОтправителя") Тогда
		АдресОтправителя = Параметры.АдресОтправителя;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура СоздатьКонтрагента(Команда)
	
	СтрокаТаблицы = Элементы.СписокВидовОпераций.ТекущиеДанные;
	
	Если НЕ СтрокаТаблицы = Неопределено Тогда
		
		ОткрытьФормуНовогоКонтрагента(СтрокаТаблицы.Значение);
		
	КонецЕсли; 
		
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ОткрытьФормуНовогоКонтрагента(ВидКонтрагента)
	
	Модифицированность = Ложь;
	Закрыть();
	
	ЗначенияЗаполнения = Новый Структура("ЮридическоеФизическоеЛицо", ВидКонтрагента);
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("ЗначенияЗаполнения", ЗначенияЗаполнения);
	
	Если РежимВыбора Тогда 
		ПараметрыФормы.Вставить("РежимВыбора", РежимВыбора);
	КонецЕсли;	
	
	Если ЗначениеЗаполнено(ТекстЗаполнения) Тогда 
		ПараметрыФормы.Вставить("ТекстЗаполнения", ТекстЗаполнения);
	КонецЕсли;	
	
	Если ЗначениеЗаполнено(АдресОтправителя) Тогда 
		ПараметрыФормы.Вставить("АдресОтправителя", АдресОтправителя);
	КонецЕсли;	
	
	ОткрытьФорму("Справочник.Контрагенты.Форма.ФормаЭлемента", ПараметрыФормы, ВладелецФормы, ВидКонтрагента);
	
КонецПроцедуры	

&НаКлиенте
Процедура СписокВидовОперацийВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	СтрокаТаблицы = СписокВидовОпераций.НайтиПоИдентификатору(ВыбраннаяСтрока);
	
	ОткрытьФормуНовогоКонтрагента(СтрокаТаблицы.Значение);

КонецПроцедуры

#КонецОбласти