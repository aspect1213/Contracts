#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область НастройкиОтчетаПоУмолчанию

Процедура ЗаполнитьСписокКатегорийИРазделовОтчета(КлючВариантаОтчета, СписокКатегорий, СписокРазделов) Экспорт
	
	СписокКатегорий.Добавить(Справочники.КатегорииОтчетов.ПоДокументам);
	
	СписокРазделов.Добавить(ОбщегоНазначения.ИдентификаторОбъектаМетаданных(
		Метаданные.Подсистемы.Настройки));
	
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли