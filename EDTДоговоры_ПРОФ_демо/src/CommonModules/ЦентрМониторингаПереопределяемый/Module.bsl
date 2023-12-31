////////////////////////////////////////////////////////////////////////////////
// Подсистема "Центр Мониторинга"
//
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Выполняется при запуске регламентного задания.
//
Процедура ПриСбореПоказателейСтатистикиКонфигурации() Экспорт
		
	// _Демо начало примера
	// Собрать статистику по количеству каждого вида номенклатуры
	// В регистр сведений <СтатистикаКонфигураций> будут внесен набор записей следующего состава
	//
	// Справочник._ДемоНоменклатура.ВидНоменклатуры1	Количество1
	// Справочник._ДемоНоменклатура.ВидНоменклатуры2	Количество2
	// ...
	// Справочник._ДемоНоменклатура.ВидНоменклатурыN	КоличествоN
	//СоответствиеИменМетаданных = Новый Соответствие;
	//
	//ТекстЗапроса = "
	//|ВЫБРАТЬ
	//|	ВидНоменклатуры КАК ВидНоменклатуры,
	//|	КОЛИЧЕСТВО(*) КАК Количество
	//|ИЗ
	//|	Справочник._ДемоНоменклатура
	//|ГДЕ
	//|	ЭтоГруппа = Ложь
	//|СГРУППИРОВАТЬ ПО
	//|	ВидНоменклатуры
	//|";
	//СоответствиеИменМетаданных.Вставить("Справочник._ДемоНоменклатура", ТекстЗапроса);
	//
	//ЦентрМониторинга.ЗаписатьСтатистикуКонфигурации(СоответствиеИменМетаданных);
	// _Демо конец примера
	
	// _Демо начало примера
	// Собрать статистику по способу установки курса справочника Валюты
	// В регистр сведений <СтатистикаКонфигураций> будут внесена записи следующего вида
	//
	// Справочник.Валюты.СпособУстановкиКурса1		Количество1
	// Справочник.Валюты.СпособУстановкиКурса2		Количество2
	// ...
	// Справочник.Валюты.СпособУстановкиКурсаN		КоличествоN
	//СоответствиеИменМетаданных = Новый Соответствие;
	//
	//ТекстЗапроса = "ВЫБРАТЬ
	//			   |	СпособУстановкиКурса КАК СпособУстановкиКурса,
	//			   |	КОЛИЧЕСТВО(*) КАК Количество
	//               |ИЗ
	//               |	Справочник.Валюты КАК Валюты
	//               |СГРУППИРОВАТЬ ПО
	//               |	СпособУстановкиКурса
	//			   |";
	//СоответствиеИменМетаданных.Вставить("Справочник.Валюты", ТекстЗапроса);
	//
	//ЦентрМониторинга.ЗаписатьСтатистикуКонфигурации(СоответствиеИменМетаданных);
	//// _Демо конец примера
	//
	//// _Демо начало примера
	//// Собрать статистику по количество валют, курс которых загружается через интернет
	//// В регистр сведений <СтатистикаКонфигураций> будут внесена запись следующего вида
	//// Справочник.Валюты.ЗагружаетсяИзИнтернета		Количество
	//Запрос = Новый Запрос;
	//Запрос.Текст = "ВЫБРАТЬ
	//               |	КОЛИЧЕСТВО(*) КАК Количество
	//               |ИЗ
	//               |	Справочник.Валюты КАК Валюты
	//               |ГДЕ
	//               |	Валюты.СпособУстановкиКурса = &СпособУстановкиКурса";
	//			   
	//Запрос.УстановитьПараметр("СпособУстановкиКурса", Перечисления.СпособыУстановкиКурсаВалюты.ЗагрузкаИзИнтернета);
	//Результат = Запрос.Выполнить();
	//Выборка = Результат.Выбрать();
	//Выборка.Следующий();
	//
	//ЦентрМониторинга.ЗаписатьСтатистикуОбъектаКонфигурации("Справочник.Валюты.ЗагружаетсяИзИнтернета", Выборка.Количество);
	// _Демо конец примера
КонецПроцедуры

#КонецОбласти
