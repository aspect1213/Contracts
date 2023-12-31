&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	Параметры.Свойство("Использовать", Использовать);
	Параметры.Данные.Свойство("Профиль", Профиль);
	
КонецПроцедуры

&НаКлиенте
Процедура ОК(Команда)
	Если Не ПроверитьЗаполнение() Тогда
		Возврат;
	КонецЕсли;
	Наименование = "MAPI, " + Профиль;
	Результат = Новый Структура;
	Результат.Вставить("Наименование", Наименование);
	Результат.Вставить("ВидПочтовогоКлиента", ПредопределенноеЗначение("Перечисление.ВидыПочтовыхКлиентов.Почта"));
	Результат.Вставить("Использовать", Использовать);
	Результат.Вставить("Данные", Новый Структура);
	Результат.Данные.Вставить("Профиль", Профиль);
	Закрыть(Результат);
КонецПроцедуры
