#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область НастройкиОтчетаПоУмолчанию

Процедура ЗаполнитьСписокКатегорийИРазделовОтчета(КлючВариантаОтчета, СписокКатегорий, СписокРазделов) Экспорт
	
	Если КлючВариантаОтчета = "СписокДокументов"
	 Или КлючВариантаОтчета = "ДокументыСИстекающимСроком" 
	 Или КлючВариантаОтчета = "ДокументыУКонтрагентов" 
	 Или КлючВариантаОтчета = "ДокументыСПросроченнымиЭтапами" Тогда 
	 
	 	СписокКатегорий.Добавить(Справочники.КатегорииОтчетов.ПоДокументам);
		
		СписокРазделов.Добавить(ОбщегоНазначения.ИдентификаторОбъектаМетаданных(
			Метаданные.Подсистемы.Настройки));

	ИначеЕсли КлючВариантаОтчета = "АнализЗаключенныхДоговоров" 	 
	  Или КлючВариантаОтчета = "ДинамикаЗаключенныхДоговоров" Тогда 

		СписокКатегорий.Добавить(Справочники.КатегорииОтчетов.ПоДокументам);
		СписокКатегорий.Добавить(Справочники.КатегорииОтчетов.Статистические);
		
		СписокРазделов.Добавить(ОбщегоНазначения.ИдентификаторОбъектаМетаданных(
			Метаданные.Подсистемы.Настройки));
 
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли