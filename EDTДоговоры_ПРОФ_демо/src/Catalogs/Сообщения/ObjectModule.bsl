#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка)
	
	Если ЭтоНовый() Тогда
		Дата = ТекущаяДата();
		Автор = ПользователиКлиентСервер.ТекущийПользователь();
	КонецЕсли;	
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ)
	
	Если Не ПустаяСтрока(Текст) Тогда
		Наименование = Текст;
	ИначеЕсли ЗначениеЗаполнено(Предмет) Тогда
		Наименование = Предмет;
	Иначе
		Наименование = НСтр("ru = 'Сообщение'");
	КонецЕсли;	
	
КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)
	
	ДатаОтправкиПоПочте = Неопределено;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли
