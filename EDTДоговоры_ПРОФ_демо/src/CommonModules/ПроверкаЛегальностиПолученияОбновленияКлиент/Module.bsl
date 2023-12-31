////////////////////////////////////////////////////////////////////////////////
// Подсистема "Проверка легальности получения обновления".
//
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Запрашивает у пользователя диалог с подтверждением легальности полученного
// обновления и завершает работу системы, если обновление получено не легально
// (см. параметр ЗавершатьРаботуСистемы).
//
// Параметры:
//  ЗавершатьРаботуСистемы - Булево - завершать работу системы, если пользователь
//                                    указал что обновление получено не легально.
//
// Возвращаемое значение:
//   Булево - Истина, если проверка завершилась успешно (пользователь
//            подтвердил, что обновление получено легально).
//
Процедура ПоказатьПроверкуЛегальностиПолученияОбновления(Оповещение, ЗавершатьРаботуСистемы = Ложь) Экспорт
	
	Если СтандартныеПодсистемыКлиентПовтИсп.ПараметрыРаботыКлиента().ЭтоБазоваяВерсияКонфигурации Тогда
		Возврат;
	КонецЕсли;
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("ПоказыватьПредупреждениеОПерезапуске", ЗавершатьРаботуСистемы);
	ПараметрыФормы.Вставить("ПрограммноеОткрытие", Истина);
	
	ОткрытьФорму("Обработка.ЛегальностьПолученияОбновлений.Форма", ПараметрыФормы,,,,, Оповещение);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

// Проверить легальность получения обновления при запуске программы.
// Должна вызываться перед обновлением информационной базы.
//
Процедура ПроверитьЛегальностьПолученияОбновленияПриЗапуске(Параметры) Экспорт
	
	ПараметрыКлиента = СтандартныеПодсистемыКлиентПовтИсп.ПараметрыРаботыКлиентаПриЗапуске();
	
	Если Не ПараметрыКлиента.Свойство("ПроверитьЛегальностьПолученияОбновления") Тогда
		Возврат;
	КонецЕсли;
	
	Параметры.ИнтерактивнаяОбработка = Новый ОписаниеОповещения(
		"ИнтерактивнаяОбработкаПроверкиЛегальностиПолученияОбновления", ЭтотОбъект);
	
КонецПроцедуры

// Только для внутреннего использования. Продолжение процедуры ПроверитьЛегальностьПолученияОбновленияПриЗапуске.
Процедура ИнтерактивнаяОбработкаПроверкиЛегальностиПолученияОбновления(Параметры, Неопределен) Экспорт
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("ПрограммноеОткрытие", Истина);
	ПараметрыФормы.Вставить("ПоказыватьПредупреждениеОПерезапуске", Истина);
	ПараметрыФормы.Вставить("ПропуститьПерезапуск", Истина);
	
	ОткрытьФорму("Обработка.ЛегальностьПолученияОбновлений.Форма", ПараметрыФормы, , , , ,
		Новый ОписаниеОповещения("ПослеЗакрытияФормыПроверкиЛегальностиПолученияОбновленияПриЗапуске",
			ЭтотОбъект, Параметры));
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Только для внутреннего использования. Продолжение процедуры ПроверитьЛегальностьПолученияОбновленияПриЗапуске.
Процедура ПослеЗакрытияФормыПроверкиЛегальностиПолученияОбновленияПриЗапуске(Результат, Параметры) Экспорт
	
	Если Результат <> Истина Тогда
		Параметры.Отказ = Истина;
	КонецЕсли;
	
	ВыполнитьОбработкуОповещения(Параметры.ОбработкаПродолжения);
	
КонецПроцедуры

#КонецОбласти
