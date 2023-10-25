
// Процедура ДобавитьЗначениеКСтрокеЧерезРазделитель добавляет
// к Строке Разделитель и ДобавляемоеЗначение в случае, если Строка и
// ДобавляемоеЗначение не пустые. Если Строка пустая или ДобавляемоеЗначение
// не заполнено, то добавляет к Строке ДобавляемоеЗначение.
// 
// Параметры:
// Строка (Строка или любое значение, приводимое к строке). Модифицируется в процедуре.
// Разделитель (Строка или любое значение, приводимое к строке). 
// ДобавляемоеЗначение (Строка или любое значение, приводимое к строке).
//
Процедура ДобавитьЗначениеКСтрокеЧерезРазделитель(Строка, Разделитель, ДобавляемоеЗначение) Экспорт
	Если ПустаяСтрока(Строка) Тогда
		Строка = Строка(ДобавляемоеЗначение);
	ИначеЕсли Не ПустаяСтрока(ДобавляемоеЗначение) Тогда
		Строка = Строка(Строка) + Разделитель + ДобавляемоеЗначение;
	КонецЕсли;
КонецПроцедуры

// Заключает в кавычки строку
// Параметры:
// Строка (Строка или любое значение, приводимое к строке).
Функция ВКавычках(Знач Строка, Знач Кавычка = Неопределено, Знач ВтораяКавычка = Неопределено) Экспорт
	
	Если Кавычка = Неопределено Тогда
		Кавычка = """";
	КонецЕсли;
	Если ВтораяКавычка = Неопределено Тогда
		ВтораяКавычка = Кавычка;
	КонецЕсли;
	
	Возврат Кавычка + Строка + ВтораяКавычка;
	
КонецФункции

// Возвращает пустой уникальный идентификатор
Функция УникальныйИдентификаторПустой() Экспорт
	
	Возврат Новый УникальныйИдентификатор("00000000-0000-0000-0000-000000000000");
	
КонецФункции
