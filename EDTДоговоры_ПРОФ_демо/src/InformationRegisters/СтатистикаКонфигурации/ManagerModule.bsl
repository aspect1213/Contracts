#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныеПроцедурыИФункции

Функция ПолучитьСтатистику(ВидСтатистики, ТаблицаИмен = Неопределено, ИдентификаторОбластиСтатистики = Неопределено) Экспорт
	Запрос = Новый Запрос;
	
	Если ТаблицаИмен = Неопределено Тогда
		Запрос.Текст = "
		|ВЫБРАТЬ
		|	ОперацииСтатистики.Наименование КАК ОперацияСтатистики,
		|	СтатистикаКонфигурации.Значение КАК Значение
		|ИЗ
		|	РегистрСведений.СтатистикаКонфигурации КАК СтатистикаКонфигурации
		|ВНУТРЕННЕЕ СОЕДИНЕНИЕ
		|	РегистрСведений.ОперацииСтатистики КАК ОперацииСтатистики
		|ПО
		|	СтатистикаКонфигурации.ОперацияСтатистики = ОперацииСтатистики.ИдентификаторОперации
		|ГДЕ
		|	СтатистикаКонфигурации.ВидСтатистики = &ВидСтатистики
		|";
		Запрос.УстановитьПараметр("ВидСтатистики", ВидСтатистики);
		РезультатЗапроса = Запрос.Выполнить();
	Иначе
		Запрос.Текст = "
		|ВЫБРАТЬ
		|	ТаблицаИмен.ОперацияСтатистикиНаименование КАК ОперацияСтатистикиНаименование,
		|	ТаблицаИмен.ИндексСтроки КАК ИндексСтроки
		|ПОМЕСТИТЬ
		|	ТаблицаИмен
		|ИЗ
		|	&ТаблицаИмен КАК ТаблицаИмен
		|ИНДЕКСИРОВАТЬ ПО
		|	ОперацияСтатистикиНаименование	
		|;
		|ВЫБРАТЬ
		|	ТаблицаИмен.ИндексСтроки КАК ОперацияСтатистикиИндекс,
		|	СтатистикаКонфигурации.Значение КАК Значение
		|ИЗ
		|	РегистрСведений.СтатистикаКонфигурации КАК СтатистикаКонфигурации
		|ВНУТРЕННЕЕ СОЕДИНЕНИЕ
		|	РегистрСведений.ОперацииСтатистики КАК ОперацииСтатистики
		|ПО
		|	СтатистикаКонфигурации.ОперацияСтатистики = ОперацииСтатистики.ИдентификаторОперации
		|ВНУТРЕННЕЕ СОЕДИНЕНИЕ
		|	ТаблицаИмен
		|ПО
		|	ТаблицаИмен.ОперацияСтатистикиНаименование = ОперацииСтатистики.Наименование
		|ГДЕ
		|	СтатистикаКонфигурации.ВидСтатистики = &ВидСтатистики
		|	И СтатистикаКонфигурации.ИдентификаторОбластиСтатистики = &ИдентификаторОбластиСтатистики
		|УПОРЯДОЧИТЬ ПО
		|	ТаблицаИмен.ИндексСтроки
		|";
		Запрос.УстановитьПараметр("ВидСтатистики", ВидСтатистики);
		Запрос.УстановитьПараметр("ИдентификаторОбластиСтатистики", ИдентификаторОбластиСтатистики);
		Запрос.УстановитьПараметр("ТаблицаИмен", ТаблицаИмен);
		РезультатЗапроса = Запрос.Выполнить();
	КонецЕсли;
	
	Возврат РезультатЗапроса;
КонецФункции

Функция ПолучитьИменаСтатистики(ВидСтатистики) Экспорт
	НулеваяОбласть = РегистрыСведений.ОбластиСтатистики.ПолучитьСсылку("0");
	
	Запрос = Новый Запрос;
	Запрос.Текст = "
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	СтатистикаКонфигурации.ОперацияСтатистики КАК ОперацияСтатистикиСсылка,
	|	ОперацииСтатистики.Наименование КАК ОперацияСтатистикиНаименование
	|ИЗ
	|	РегистрСведений.СтатистикаКонфигурации КАК СтатистикаКонфигурации
	|ВНУТРЕННЕЕ СОЕДИНЕНИЕ
	|	РегистрСведений.ОперацииСтатистики КАК ОперацииСтатистики
	|ПО
	|	СтатистикаКонфигурации.ОперацияСтатистики = ОперацииСтатистики.ИдентификаторОперации
	|ГДЕ
	|	СтатистикаКонфигурации.ВидСтатистики = &ВидСтатистики
	|УПОРЯДОЧИТЬ ПО
	|	ОперацииСтатистики.Наименование
	|";
	Запрос.УстановитьПараметр("ВидСтатистики", ВидСтатистики);
	Запрос.УстановитьПараметр("НулеваяОбласть", НулеваяОбласть);
	РезультатЗапроса = Запрос.Выполнить();
	
	Возврат РезультатЗапроса;
КонецФункции

Функция ЗаписатьСтатистикуКонфигурации(Знач СоответствиеИменМетаданных = Неопределено) Экспорт
	СтатистикаКонфигурации = НовыйСтатистикаКонфигурации(СоответствиеИменМетаданных);
	Записать(СтатистикаКонфигурации.НеРазделенная, РегистрыСведений.ОбластиСтатистики.ПолучитьСсылку("0", Истина));
	
	Если СтатистикаКонфигурации.Разделенная <> Неопределено Тогда
		ЗаписатьРазделенную(СтатистикаКонфигурации.Разделенная);
	КонецЕсли;
КонецФункции

Функция НовыйСтатистикаКонфигурации(СоответствиеИменМетаданных = Неопределено)
	СоответствиеИменМетаданныхРезультат = Новый Соответствие;
	МассивИменМетаданных = Новый Массив();
	
	РазделениеПоОбластямДанныхВключено = ЦентрМониторингаСлужебный.РазделениеПоОбластямДанныхВключено();
	
	Если СоответствиеИменМетаданных <> Неопределено Тогда
		Для Каждого ИмяМетаданных Из СоответствиеИменМетаданных Цикл
			СоответствиеИменМетаданныхРезультат.Вставить(ИмяМетаданных.Ключ, ИмяМетаданных.Значение);
			МассивИменМетаданных.Добавить(ИмяМетаданных.Ключ);	
		КонецЦикла;
	КонецЕсли;
	
	Таблицы = ПолучитьСтруктуруХраненияБазыДанных(МассивИменМетаданных);
	
	СоответствиеИменМетаданныхПоОбластям = РазделитьКонфигурациюПоОбластям(Таблицы, СоответствиеИменМетаданных, СоответствиеИменМетаданныхРезультат, РазделениеПоОбластямДанныхВключено);
	
	Возврат СоответствиеИменМетаданныхПоОбластям;
КонецФункции

Функция РазделитьКонфигурациюПоОбластям(Таблицы, СоответствиеИменМетаданных, СоответствиеИменМетаданныхРезультат, РазделениеПоОбластямДанныхВключено)
	Если РазделениеПоОбластямДанныхВключено Тогда
		СоответствиеИменМетаданныхПоОбластям = Новый Структура("НеРазделенная, Разделенная", Новый Соответствие, Новый Соответствие);
	Иначе
		СоответствиеИменМетаданныхПоОбластям = Новый Структура("НеРазделенная, Разделенная", Новый Соответствие, Неопределено);
	КонецЕсли;
		
	БазоваяФункциональностьВМоделиСервисаСуществует = ОбщегоНазначения.ПодсистемаСуществует("ТехнологияСервиса.РаботаВМоделиСервиса.БазоваяФункциональностьВМоделиСервиса");
	Если БазоваяФункциональностьВМоделиСервисаСуществует Тогда
		МодульРаботаВМоделиСервиса = ОбщегоНазначения.ОбщийМодуль("РаботаВМоделиСервиса");
		ОбластьДанныхОсновныеДанныеСостав = МодульРаботаВМоделиСервиса.ОбластьДанныхОсновныеДанныеСостав();
	КонецЕсли;
	
	Для Каждого ТекСтрока Из Таблицы Цикл
		Если СоответствиеИменМетаданных <> Неопределено Тогда
			Если СоответствиеИменМетаданных[ТекСтрока.Метаданные] = Неопределено Тогда
				Продолжить;
			КонецЕсли;			
		КонецЕсли;
		
		Основная = ?(ТекСтрока.Назначение = "Основная", Истина, Ложь);
		ТабличнаяЧасть = ?(ТекСтрока.Назначение = "ТабличнаяЧасть", Истина, Ложь);
		
		Если (Основная ИЛИ ТабличнаяЧасть) И ЗначениеЗаполнено(ТекСтрока.ИмяТаблицы) Тогда
			Если Основная Тогда
				ОбъектМетаданных = Метаданные.НайтиПоПолномуИмени(ТекСтрока.Метаданные);
				Если РазделениеПоОбластямДанныхВключено Тогда
					ЭлементСоставаОбщегоРеквизита = ОбластьДанныхОсновныеДанныеСостав.Найти(ОбъектМетаданных);
				КонецЕсли;
			КонецЕсли;
						
			Если СоответствиеИменМетаданныхРезультат[ТекСтрока.ИмяТаблицы] = Неопределено Тогда
				ТекстЗапроса = ЗапросПоУмолчанию(ТекСтрока.ИмяТаблицы);
			Иначе
				ТекстЗапроса = СоответствиеИменМетаданныхРезультат[ТекСтрока.ИмяТаблицы]["Запрос"];
			КонецЕсли;
			
			Если РазделениеПоОбластямДанныхВключено Тогда
				Если ЭлементСоставаОбщегоРеквизита <> Неопределено Тогда
					Если ЭлементСоставаОбщегоРеквизита.Использование = Метаданные.СвойстваОбъектов.ИспользованиеОбщегоРеквизита.НеИспользовать Тогда
						ЕстьРазделение = Ложь;
					Иначе
						ЕстьРазделение = Истина;
					КонецЕсли;
				Иначе
					МетаданныеМассив = СтрРазделить(ТекСтрока.Метаданные, ".");
					Если МетаданныеМассив[0] = "ЖурналДокументов" Тогда
						ЕстьРазделение = Истина;
					ИначеЕсли МетаданныеМассив[0] = "Перечисление" Тогда
						ЕстьРазделение = Ложь;
					ИначеЕсли МетаданныеМассив[0] = "Последовательность" Тогда
						ЕстьРазделение = Истина;
					Иначе
						ЕстьРазделение = Истина;
					КонецЕсли;
				КонецЕсли;
			Иначе
				ЕстьРазделение = Ложь;
			КонецЕсли;
									
			Если ЕстьРазделение Тогда
				СоответствиеИменМетаданныхПоОбластям.Разделенная.Вставить(ТекСтрока.ИмяТаблицы, Новый Структура("Запрос, ОперацииСтатистики, ВидСтатистики", ТекстЗапроса, Неопределено, 0));
			Иначе
				СоответствиеИменМетаданныхПоОбластям.НеРазделенная.Вставить(ТекСтрока.ИмяТаблицы, Новый Структура("Запрос, ОперацииСтатистики, ВидСтатистики", ТекстЗапроса, Неопределено, 0));
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
		
	Возврат СоответствиеИменМетаданныхПоОбластям;	
КонецФункции

Функция ЗаписатьНастройкиКонфигурации() Экспорт
	НастройкиКонфигурации = РазделитьФункциональныеОпцииПоОбластям();
	Записать(НастройкиКонфигурации.НеРазделенная, РегистрыСведений.ОбластиСтатистики.ПолучитьСсылку("0", Истина));
	Если ЗначениеЗаполнено(НастройкиКонфигурации.Разделенная) Тогда
		ЗаписатьРазделенную(НастройкиКонфигурации.Разделенная);
	КонецЕсли;
КонецФункции

Функция РазделитьФункциональныеОпцииПоОбластям()
	СоответствиеИменМетаданныхПоОбластям = Новый Структура("НеРазделенная, Разделенная", Новый Соответствие, Новый Соответствие);
	
	РазделениеПоОбластямДанныхВключено = ЦентрМониторингаСлужебный.РазделениеПоОбластямДанныхВключено();
	Если РазделениеПоОбластямДанныхВключено Тогда
		БазоваяФункциональностьВМоделиСервисаСуществует = ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.РаботаВМоделиСервиса.БазоваяФункциональностьВМоделиСервиса");
		Если БазоваяФункциональностьВМоделиСервисаСуществует Тогда
			МодульРаботаВМоделиСервиса = ОбщегоНазначения.ОбщийМодуль("РаботаВМоделиСервиса");
			ОбластьДанныхОсновныеДанныеСостав = МодульРаботаВМоделиСервиса.ОбластьДанныхОсновныеДанныеСостав();
		КонецЕсли;
	КонецЕсли;
		
	Для Каждого ФункциональнаяОпция Из Метаданные.ФункциональныеОпции Цикл
		ОписаниеТиповФункциональнойОпции = Новый ОписаниеТипов(ФункциональнаяОпция.Хранение.Тип);
		Если Метаданные.Константы.Содержит(ФункциональнаяОпция.Хранение) И ОписаниеТиповФункциональнойОпции.СодержитТип(Тип("Булево")) Тогда
			Если РазделениеПоОбластямДанныхВключено Тогда
				ЭлементСоставаОбщегоРеквизита = ОбластьДанныхОсновныеДанныеСостав.Найти(ФункциональнаяОпция.Хранение);
				Если ЭлементСоставаОбщегоРеквизита <> Неопределено Тогда
					Если ЭлементСоставаОбщегоРеквизита.Использование = Метаданные.СвойстваОбъектов.ИспользованиеОбщегоРеквизита.НеИспользовать Тогда
						ЕстьРазделение = Ложь;
					Иначе
						ЕстьРазделение = Истина;
					КонецЕсли;
				Иначе
					ЕстьРазделение = Ложь;
				КонецЕсли;
			Иначе
				ЕстьРазделение = Ложь;
			КонецЕсли;
			
			Если ЕстьРазделение Тогда
				СоответствиеИменМетаданныхПоОбластям.Разделенная.Вставить(ФункциональнаяОпция.ПолноеИмя(), Новый Структура("Запрос, ОперацииСтатистики, ВидСтатистики", ФункциональнаяОпция.Хранение, Неопределено, 1));	
			Иначе
				СоответствиеИменМетаданныхПоОбластям.НеРазделенная.Вставить(ФункциональнаяОпция.ПолноеИмя(), Новый Структура("Запрос, ОперацииСтатистики, ВидСтатистики", ФункциональнаяОпция.Хранение, Неопределено, 1));
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	
	Возврат СоответствиеИменМетаданныхПоОбластям;
КонецФункции

Процедура ОчиститьСтатистикуКонфигурации() Экспорт
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	СтатистикаКонфигурации.ИдентификаторОбластиСтатистики КАК ИдентификаторОбластиСтатистики
		|ИЗ
		|	РегистрСведений.СтатистикаКонфигурации КАК СтатистикаКонфигурации";
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	НаборЗаписей = РегистрыСведений.СтатистикаКонфигурации.СоздатьНаборЗаписей();
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		НаборЗаписей.Отбор.ИдентификаторОбластиСтатистики.Установить(ВыборкаДетальныеЗаписи.ИдентификаторОбластиСтатистики);
		НаборЗаписей.Записать(Истина);
	КонецЦикла;
КонецПроцедуры

Процедура Записать(СтатистикаКонфигурации, Область) Экспорт
	НачатьТранзакцию();
	Попытка
		НаборЗаписей = РегистрыСведений.СтатистикаКонфигурации.СоздатьНаборЗаписей();
		ЕстьЗапись = Ложь;
		
		ОперацииСсылки = Новый Соответствие;
		Для Каждого ТекОбъект Из СтатистикаКонфигурации Цикл
			Если ТекОбъект.Значение["ВидСтатистики"] = 0 Тогда
				РезультатЗапроса = ПолучитьРезультат(ТекОбъект.Значение["Запрос"]);
				ОперацииСтатистики = ПолучитьРезультатОперацииСтатистики(ТекОбъект.Ключ, РезультатЗапроса);
			ИначеЕсли ТекОбъект.Значение["ВидСтатистики"] = 1 Тогда
				Значение = ?(Константы[ТекОбъект.Значение["Запрос"].Имя].Получить(), 1, 0);
				ОперацииСтатистики = Новый Массив;
				ОперацияСтатистики = Новый Структура("ОперацияСтатистикиНаименование, КоличествоОпераций", ТекОбъект.Ключ, Значение);
				ОперацииСтатистики.Добавить(ОперацияСтатистики);
			КонецЕсли;
			
			Для Каждого ОперацияСтатистики Из ОперацииСтатистики Цикл
				Если ОперацииСсылки[ОперацияСтатистики.ОперацияСтатистикиНаименование] = Неопределено Тогда
					ОперацииСсылки.Вставить(ОперацияСтатистики.ОперацияСтатистикиНаименование, РегистрыСведений.ОперацииСтатистики.ПолучитьСсылку(ОперацияСтатистики.ОперацияСтатистикиНаименование));
				КонецЕсли;
				
				ЕстьЗапись = Истина;
				НовЗапись = НаборЗаписей.Добавить();
				НовЗапись.ИдентификаторОбластиСтатистики = Область;
				НовЗапись.ОперацияСтатистики = ОперацииСсылки[ОперацияСтатистики.ОперацияСтатистикиНаименование];
				НовЗапись.ВидСтатистики = ТекОбъект.Значение.ВидСтатистики;
				НовЗапись.Значение = Число(СтрЗаменить(ОперацияСтатистики.КоличествоОпераций,",","."));
			КонецЦикла;
		КонецЦикла;
		
		Если ЕстьЗапись Тогда
			НаборЗаписей.Записать(Ложь);
		КонецЕсли;
				
		ЗафиксироватьТранзакцию();
	Исключение
		ОтменитьТранзакцию();
		
		Ошибка = ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
		ЗаписьЖурналаРегистрации("ОбработкаОперацииСтатистики", УровеньЖурналаРегистрации.Ошибка, "ТУТ МЕТАДАННЫЕ",,Ошибка);
	КонецПопытки;
КонецПроцедуры

Процедура ЗаписатьРазделенную(СтатистикаКонфигурации)
	ОбластиДанныхРезультат = ПолучитьОбластиДанныхРезультатЗапроса();
	Выборка = ОбластиДанныхРезультат.Выбрать();
	Пока Выборка.Следующий() Цикл
		ОбластьДанныхСтрока = Строка(Выборка.ОбластьДанных);
		ОбластьДанныхСсылка = РегистрыСведений.ОбластиСтатистики.ПолучитьСсылку(ОбластьДанныхСтрока);
		Если РегистрыСведений.ОбластиСтатистики.СобиратьСтатистикуКонфигурации(ОбластьДанныхСтрока) Тогда
			Попытка
				ОбщегоНазначения.УстановитьРазделениеСеанса(Истина, Выборка.ОбластьДанных);
			Исключение
				Инфо = ИнформацияОбОшибке();
				ЗаписьЖурналаРегистрации("СтатистикаКонфигурации",
				УровеньЖурналаРегистрации.Ошибка,
				,,
				"Не удалось установить разделение сеанса. Область данных = " + Формат(Выборка.ОбластьДанных, "ЧГ=0")
				+Символы.ПС + ПодробноеПредставлениеОшибки(Инфо));
				
				ОбщегоНазначения.УстановитьРазделениеСеанса(Ложь);
				Продолжить;
			КонецПопытки;
			Записать(СтатистикаКонфигурации, ОбластьДанныхСсылка);
			ОбщегоНазначения.УстановитьРазделениеСеанса(Ложь);
		КонецЕсли;
	КонецЦикла;
КонецПроцедуры

Функция ПолучитьОбластиДанныхРезультатЗапроса() Экспорт
	БазоваяФункциональностьВМоделиСервисаСуществует = ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.РаботаВМоделиСервиса.БазоваяФункциональностьВМоделиСервиса");
	Если БазоваяФункциональностьВМоделиСервисаСуществует Тогда
		МодульРаботаВМоделиСервиса = ОбщегоНазначения.ОбщийМодуль("РаботаВМоделиСервиса");
		Результат = МодульРаботаВМоделиСервиса.ПолучитьОбластиДанныхРезультатЗапроса();
	КонецЕсли;
	
	Возврат Результат;
КонецФункции

Функция ПолучитьРезультатОперацииСтатистики(ОперацияСтатистикиКорень, РезультатЗапроса)
	ОперацииСтатистики = Новый Массив;
		
	Если РезультатЗапроса <> Неопределено Тогда
		Выборка = РезультатЗапроса.Выбрать();
		Пока Выборка.Следующий() Цикл
			ОперацияСтатистикиПредставление = ОперацияСтатистикиКорень + ".";
 			Количество = "0,000";
			
			ОперацияСтатистики = Новый Структура("ОперацияСтатистикиНаименование, КоличествоОпераций");
			
			Для Каждого ТекКолонка Из РезультатЗапроса.Колонки Цикл
				Если ТекКолонка.Имя <> "Количество" Тогда
					ОперацияСтатистикиПредставление = ОперацияСтатистикиПредставление + Выборка[ТекКолонка.Имя] + ".";	
				Иначе
					Количество = Формат(Выборка[ТекКолонка.Имя], "ЧДЦ=3; ЧРД=,; ЧН=0,000; ЧГ=");
				КонецЕсли;
			КонецЦикла;
			ОперацияСтатистики.ОперацияСтатистикиНаименование = Лев(ОперацияСтатистикиПредставление, СтрДлина(ОперацияСтатистикиПредставление) - 1);
			ОперацияСтатистики.КоличествоОпераций = Количество;
			
			ОперацииСтатистики.Добавить(ОперацияСтатистики);
		КонецЦикла;
	КонецЕсли;
		
	Возврат ОперацииСтатистики;
КонецФункции

Функция ПолучитьРезультат(ТекстЗапроса)
	Результат = Неопределено;
	
	Запрос = Новый Запрос(ТекстЗапроса);
	Результат = Запрос.Выполнить();

	Возврат Результат;
КонецФункции
	
Функция ЗапросПоУмолчанию(ТаблицаМетаданных)
	ТекстЗапроса = "ВЫБРАТЬ
	|	КОЛИЧЕСТВО(*) КАК Количество
	|ИЗ
	|	" + ТаблицаМетаданных + "
	|";
	
	Возврат ТекстЗапроса;
КонецФункции

#КонецОбласти

#КонецЕсли