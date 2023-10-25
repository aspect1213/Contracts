#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	ИсходнаяТаблица = ПолучитьИзВременногоХранилища(Параметры.АдресДублей);
	ЗначениеВРеквизитФормы(ИсходнаяТаблица, "ТаблицаДублей");
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ВернутьсяКРедактированию(Команда)
	
	Закрыть(Неопределено);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаписатьКонтрагента(Команда)
	
	Закрыть("ЗаписатьКонтрагента");
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийТаблицыФормыТаблицаДублей

&НаКлиенте
Процедура ТаблицаДублейВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	ПоказатьЗначение(, Элемент.ТекущиеДанные.Ссылка);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#КонецОбласти