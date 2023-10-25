#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

Процедура ОбработкаПолученияФормы(ВидФормы, Параметры, ВыбраннаяФорма, ДополнительнаяИнформация, СтандартнаяОбработка)
	
	Если ВидФормы <> "ФормаОбъекта" Тогда
		Возврат;
	КонецЕсли;

	СтандартнаяОбработка = Ложь;
	
	Если Параметры.Свойство("Ключ") И ЗначениеЗаполнено(Параметры.Ключ) Тогда
		ВыбраннаяФорма = "ФормаЭлемента";
	ИначеЕсли Параметры.Свойство("ЗначениеКопирования") И ЗначениеЗаполнено(Параметры.ЗначениеКопирования) Тогда 
		ВыбраннаяФорма = "ФормаЭлемента";
	ИначеЕсли Параметры.Свойство("ЗначенияЗаполнения") 
		И ТипЗнч(Параметры.ЗначенияЗаполнения) = Тип("Структура")
		И Параметры.ЗначенияЗаполнения.Свойство("ЮридическоеФизическоеЛицо") Тогда 
		ВыбраннаяФорма = "ФормаЭлемента";
	Иначе	
		ВыбраннаяФорма = "ФормаВыбораВида";
	КонецЕсли;

КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Групповое изменение объектов.

// Возвращает реквизиты объекта, которые не рекомендуется редактировать
// с помощью обработки группового изменения реквизитов.
//
// Возвращаемое значение:
//  Массив - список имен реквизитов объекта.
Функция РеквизитыНеРедактируемыеВГрупповойОбработке() Экспорт
	
	Результат = Новый Массив;
	
	Результат.Добавить("ИНН");
	Результат.Добавить("КПП");
	
	Возврат Результат;
	
КонецФункции

// СтандартныеПодсистемы.ВерсионированиеОбъектов

// Определяет настройки объекта для подсистемы ВерсионированиеОбъектов.
//
// Параметры:
//  Настройки - Структура - настройки подсистемы.
Процедура ПриОпределенииНастроекВерсионированияОбъектов(Настройки) Экспорт
	Настройки.ПриПолученииСлужебныхРеквизитов = Истина;
КонецПроцедуры

// Ограничивает видимость реквизитов объекта в отчете по версии.
//
// Параметры:
//  Реквизиты - Массив - список имен реквизитов объекта.
Процедура ПриПолученииСлужебныхРеквизитов(Реквизиты) Экспорт
КонецПроцедуры

// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов

// СтандартныеПодсистемы.Печать

////////////////////////////////////////////////////////////////////////////////
// Интерфейс для работы с подсистемой Печать.

// Заполняет список команд печати.
// 
// Параметры:
//   КомандыПечати - ТаблицаЗначений - состав полей см. в функции УправлениеПечатью.СоздатьКоллекциюКомандПечати.
//
Процедура ДобавитьКомандыПечати(КомандыПечати) Экспорт
	
	// СтандартныеПодсистемы.ЗащитаПерсональныхДанных
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.ЗащитаПерсональныхДанных") Тогда
		Модуль = ОбщегоНазначения.ОбщийМодуль("ЗащитаПерсональныхДанных");
		Модуль.ДобавитьКомандуПечатиСогласияНаОбработкуПерсональныхДанных(КомандыПечати);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.ЗащитаПерсональныхДанных
	
КонецПроцедуры

// Конец СтандартныеПодсистемы.Печать

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

Процедура ОбновитьПредопределенныеВидыКонтактнойИнформацииКонтрагента() Экспорт
	
КонецПроцедуры

Процедура ОбработкаПолученияДанныхВыбора(ДанныеВыбора, Параметры, СтандартнаяОбработка)
	
	Если Не Параметры.Отбор.Свойство("ПометкаУдаления") Тогда
		Параметры.Отбор.Вставить("ПометкаУдаления", Ложь);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли