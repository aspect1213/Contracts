
#Область НастройкиОтчетаПоУмолчанию

Процедура ЗаполнитьСписокКатегорийИРазделовОтчета(КлючВариантаОтчета, СписокКатегорий, СписокРазделов) Экспорт
	
	Если КлючВариантаОтчета = "Основной" Тогда
		
		СписокКатегорий.Добавить(Справочники.КатегорииОтчетов.Администрирование);
		
		СписокРазделов.Добавить(ОбщегоНазначения.ИдентификаторОбъектаМетаданных(
			Метаданные.Подсистемы.Настройки));
		
	Иначе
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

