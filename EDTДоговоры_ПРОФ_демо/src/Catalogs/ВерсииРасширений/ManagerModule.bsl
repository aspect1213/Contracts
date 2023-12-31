#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныйПрограммныйИнтерфейс

// Возвращает текущую версию расширений.
// Для поиска версии используется описание установленных расширений,
// дополненное описанием конфигурации, которое обеспечивает соответствие уникального
// идентификатора "слепку" метаданных из конфигурации и подключенных расширений.
//
Функция ВерсияРасширений() Экспорт
	
	Если Не ОбщегоНазначенияПовтИсп.ДоступноИспользованиеРазделенныхДанных()
	   И ЗначениеЗаполнено(ПараметрыСеанса.УстановленныеРасширения) Тогда
		ВызватьИсключение
			НСтр("ru = 'Расширения недоступны в неразделенном режиме.
			           |Удалите все расширения через конфигуратор.'");
	КонецЕсли;
	
	Если СтандартныеПодсистемыСервер.УстановленныеРасширенияНедоступны() Тогда
		Возврат ПустаяСсылка();
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(ПараметрыСеанса.УстановленныеРасширения) Тогда
		ЗарегистрироватьПервыйВходПослеУдаленияВсехРасширений();
		Возврат ПустаяСсылка();
	КонецЕсли;
	
	ВерсияРасширений = ВерсияРасширенийБезУчетаКонтрольнойСуммы();
	Если ЗначениеЗаполнено(ВерсияРасширений) Тогда
		Возврат ВерсияРасширений;
	КонецЕсли;
	
	// Описание расширений включено описание метаданных конфигурации,
	// так как состав подключенных расширений зависит от изменения конфигурации.
	ОписаниеРасширений = ПараметрыСеанса.УстановленныеРасширения + Символы.ПС
		+ "#" + Метаданные.Имя + " (" + Метаданные.Версия + ")";
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ОписаниеРасширений", ОписаниеРасширений);
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ВерсииРасширений.Ссылка КАК Ссылка
	|ИЗ
	|	Справочник.ВерсииРасширений КАК ВерсииРасширений
	|ГДЕ
	|	ВерсииРасширений.ОписаниеМетаданных ПОДОБНО &ОписаниеРасширений";
	
	Блокировка = Новый БлокировкаДанных;
	ЭлементБлокировки = Блокировка.Добавить("Справочник.ВерсииРасширений");
	ЭлементБлокировки.Режим = РежимБлокировкиДанных.Разделяемый;
	НачатьТранзакцию();
	Попытка
		Выборка = Запрос.Выполнить().Выбрать();
		ЗафиксироватьТранзакцию();
	Исключение
		ОтменитьТранзакцию();
		ВызватьИсключение;
	КонецПопытки;
	
	Если Выборка.Следующий() Тогда
		ВерсияРасширений = Выборка.Ссылка;
	Иначе
		Блокировка = Новый БлокировкаДанных;
		ЭлементБлокировки = Блокировка.Добавить("Справочник.ВерсииРасширений");
		ЭлементБлокировки.Режим = РежимБлокировкиДанных.Исключительный;
		НачатьТранзакцию();
		Попытка
			Выборка = Запрос.Выполнить().Выбрать();
			Если Выборка.Следующий() Тогда
				ВерсияРасширений = Выборка.Ссылка;
			Иначе
				Запрос = Новый Запрос;
				Запрос.Текст =
				"ВЫБРАТЬ
				|	ВерсииРасширений.Ссылка КАК Ссылка
				|ИЗ
				|	Справочник.ВерсииРасширений КАК ВерсииРасширений";
				Выборка = Запрос.Выполнить().Выбрать();
				Если Выборка.Следующий() И Выборка.Количество() = 1 Тогда
					Объект = Выборка.Ссылка.ПолучитьОбъект();
					// Тут должна быть именно ТекущаяДата(), так как
					// именно она устанавливается в поле НачалоСеанса.
					Объект.ПоследняяДатаДобавленияВторойВерсии = ТекущаяДата();
					Объект.Записать();
					ВключитьЗаданиеУдалениеУстаревшихПараметровРаботыВерсийРасширений(Истина);
				КонецЕсли;
				Объект = СоздатьЭлемент();
				Объект.ОписаниеМетаданных = ОписаниеРасширений;
				Объект.Записать();
				ВерсияРасширений = Объект.Ссылка;
			КонецЕсли;
			ЗафиксироватьТранзакцию();
		Исключение
			ОтменитьТранзакцию();
			ВызватьИсключение;
		КонецПопытки;
	КонецЕсли;
	
	Возврат ВерсияРасширений;
	
КонецФункции

// При запуске в режиме отладки без обновления информационной базы допустимо
// использовать старый кэш метаданных расширений.
//
Процедура ПеререгистрироватьВерсиюРасширенийВРежимеОтладки() Экспорт
	
	Если СтандартныеПодсистемыСервер.УстановленныеРасширенияНедоступны() Тогда
		Возврат;
	КонецЕсли;
	
	ВерсияРасширений = ВерсияРасширенийБезУчетаКонтрольнойСуммы();
	Если Не ЗначениеЗаполнено(ВерсияРасширений) Тогда
		Возврат;
	КонецЕсли;
	
	Если ПараметрыСеанса.ВерсияРасширений <> ВерсияРасширений Тогда
		ПараметрыСеанса.ВерсияРасширений = ВерсияРасширений;
		ЗарегистрироватьИспользованиеВерсииРасширений();
	КонецЕсли;
	
КонецПроцедуры

// Добавляет сведения, что сеанс начал использование версии метаданных.
Процедура ЗарегистрироватьИспользованиеВерсииРасширений() Экспорт
	
	Если СтандартныеПодсистемыСервер.УстановленныеРасширенияНедоступны() Тогда
		ВерсияРасширений = ПараметрыСеанса.ВерсияРасширений;
		Возврат;
	КонецЕсли;
	
	// Тут должна быть именно ТекущаяДата(), так как
	// именно она устанавливается в поле НачалоСеанса.
	НачалоСеанса     = ТекущаяДата();
	НомерСеанса      = НомерСеансаИнформационнойБазы();
	ВерсияРасширений = ПараметрыСеанса.ВерсияРасширений;
	
	Если Не ЗначениеЗаполнено(ВерсияРасширений) Тогда
		Возврат;
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ ПЕРВЫЕ 2
	|	ИСТИНА КАК ЗначениеИстина
	|ИЗ
	|	Справочник.ВерсииРасширений КАК ВерсииРасширений";
	
	Блокировка = Новый БлокировкаДанных;
	ЭлементБлокировки = Блокировка.Добавить("Справочник.ВерсииРасширений");
	ЭлементБлокировки.Режим = РежимБлокировкиДанных.Разделяемый;
	
	НачатьТранзакцию();
	Попытка
		Блокировка.Заблокировать();
		РезультатыЗапроса = Запрос.ВыполнитьПакет();
		ЗафиксироватьТранзакцию();
	Исключение
		ОтменитьТранзакцию();
		ВызватьИсключение;
	КонецПопытки;
	
	Если РезультатыЗапроса[0].Выбрать().Количество() < 2 Тогда
		Возврат;
	КонецЕсли;
	
	НаборЗаписей = РегистрыСведений.СеансыВерсийРасширений.СоздатьНаборЗаписей();
	НаборЗаписей.Отбор.НомерСеанса.Установить(НомерСеанса);
	НаборЗаписей.Отбор.НачалоСеанса.Установить(НачалоСеанса);
	НаборЗаписей.Отбор.ВерсияРасширений.Установить(ВерсияРасширений);
	
	НоваяЗапись = НаборЗаписей.Добавить();
	НоваяЗапись.НомерСеанса      = НомерСеанса;
	НоваяЗапись.НачалоСеанса     = НачалоСеанса;
	НоваяЗапись.ВерсияРасширений = ВерсияРасширений;
	
	НаборЗаписей.Записать();
	
КонецПроцедуры

// Удаляет устаревшие версии метаданных.
Процедура УдалитьУстаревшиеВерсииПараметров() Экспорт
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ТекущаяВерсияРасширений", ПараметрыСеанса.ВерсияРасширений);
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ВерсииРасширений.Ссылка КАК ВерсияРасширений,
	|	СеансыВерсийРасширений.НомерСеанса КАК НомерСеанса,
	|	СеансыВерсийРасширений.НачалоСеанса КАК НачалоСеанса
	|ИЗ
	|	Справочник.ВерсииРасширений КАК ВерсииРасширений
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.СеансыВерсийРасширений КАК СеансыВерсийРасширений
	|		ПО (СеансыВерсийРасширений.ВерсияРасширений = ВерсииРасширений.Ссылка)
	|ГДЕ
	|	ВерсииРасширений.Ссылка <> &ТекущаяВерсияРасширений
	|ИТОГИ ПО
	|	ВерсияРасширений
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ ПЕРВЫЕ 1
	|	ВерсииРасширений.Ссылка КАК ВерсияРасширений,
	|	ВерсииРасширений.ПоследняяДатаДобавленияВторойВерсии
	|ИЗ
	|	Справочник.ВерсииРасширений КАК ВерсииРасширений
	|ГДЕ
	|	ВерсииРасширений.ПоследняяДатаДобавленияВторойВерсии <> ДАТАВРЕМЯ(1, 1, 1, 0, 0, 0)
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ ПЕРВЫЕ 1
	|	ВерсииРасширений.Ссылка КАК ВерсияРасширений,
	|	ВерсииРасширений.ДатаПервогоВходаПослеУдаленияВсехРасширений
	|ИЗ
	|	Справочник.ВерсииРасширений КАК ВерсииРасширений
	|ГДЕ
	|	ВерсииРасширений.ДатаПервогоВходаПослеУдаленияВсехРасширений <> ДАТАВРЕМЯ(1, 1, 1, 0, 0, 0)";
	
	Блокировка = Новый БлокировкаДанных;
	ЭлементБлокировки = Блокировка.Добавить("Справочник.ВерсииРасширений");
	ЭлементБлокировки.Режим = РежимБлокировкиДанных.Разделяемый;
	ЭлементБлокировки = Блокировка.Добавить("РегистрСведений.СеансыВерсийРасширений");
	ЭлементБлокировки.Режим = РежимБлокировкиДанных.Разделяемый;
	
	НачатьТранзакцию();
	Попытка
		Блокировка.Заблокировать();
		РезультатыЗапроса = Запрос.ВыполнитьПакет();
		ЗафиксироватьТранзакцию();
	Исключение
		ОтменитьТранзакцию();
		ВызватьИсключение;
	КонецПопытки;
	
	Выгрузка = РезультатыЗапроса[0].Выгрузить(ОбходРезультатаЗапроса.ПоГруппировкам);
	
	МассивСеансов = ПолучитьСеансыИнформационнойБазы();
	
	// Версия, которая была первой при очередном добавлении второй версии
	// (в самом начале или после удаления устаревших версий) может
	// использоваться сеансами, которые были открыты до этого события.
	ВерсияИспользуемаяВНезарегистрированныхСеансах = Неопределено;
	ДатаОкончанияСеансовИспользующихРасширенияБезРегистрации = '00010101';
	Если ЗначениеЗаполнено(ПараметрыСеанса.УстановленныеРасширения) Тогда
		Если Не РезультатыЗапроса[1].Пустой() Тогда
			Свойства = РезультатыЗапроса[1].Выгрузить()[0];
			ДатаОкончанияСеансовИспользующихРасширенияБезРегистрации
				= Свойства.ПоследняяДатаДобавленияВторойВерсии;
			ПерваяВерсия = Свойства.ВерсияРасширений;
		КонецЕсли;
	Иначе
		Если Не РезультатыЗапроса[2].Пустой() Тогда
			Свойства = РезультатыЗапроса[2].Выгрузить()[0];
			ДатаОкончанияСеансовИспользующихРасширенияБезРегистрации
				= Свойства.ДатаПервогоВходаПослеУдаленияВсехРасширений;
			ПерваяВерсия = Свойства.ВерсияРасширений;
		КонецЕсли;
	КонецЕсли;
	
	ПроверяемыеПриложения = Новый Соответствие;
	ПроверяемыеПриложения.Вставить("1CV8", Истина);
	ПроверяемыеПриложения.Вставить("1CV8C", Истина);
	ПроверяемыеПриложения.Вставить("WebClient", Истина);
	ПроверяемыеПриложения.Вставить("COMConnection", Истина);
	ПроверяемыеПриложения.Вставить("WSConnection", Истина);
	ПроверяемыеПриложения.Вставить("BackgroundJob", Истина);
	ПроверяемыеПриложения.Вставить("SystemBackgroundJob", Истина);
	
	Сеансы = Новый Соответствие;
	Для Каждого Сеанс Из МассивСеансов Цикл
		Если ПроверяемыеПриложения.Получить(Сеанс.ИмяПриложения) = Неопределено Тогда
			Продолжить;
		КонецЕсли;
		Сеансы.Вставить(Сеанс.НомерСеанса, Сеанс.НачалоСеанса);
		Если Сеанс.НачалоСеанса < ДатаОкончанияСеансовИспользующихРасширенияБезРегистрации Тогда
			ВерсияИспользуемаяВНезарегистрированныхСеансах = ПерваяВерсия;
		КонецЕсли;
	КонецЦикла;
	
	// Удаление устаревших версий метаданных.
	ВерсииУдалялись = Ложь;
	Для Каждого ОписаниеВерсии Из Выгрузка.Строки Цикл
		ВерсияИспользуется = Ложь;
		Для Каждого Строка Из ОписаниеВерсии.Строки Цикл
			Если СеансСуществует(Строка, Сеансы) Тогда
				ВерсияИспользуется = Истина;
				Прервать;
			КонецЕсли;
		КонецЦикла;
		ТекущаяВерсия = ОписаниеВерсии.ВерсияРасширений;
		Если ВерсияИспользуется
		 Или ТекущаяВерсия = ВерсияИспользуемаяВНезарегистрированныхСеансах Тогда
			Продолжить;
		КонецЕсли;
		Объект = ТекущаяВерсия.ПолучитьОбъект();
		Объект.Удалить();
		ВерсииУдалялись = Истина;
	КонецЦикла;
	
	// Отключение регламентного задания, если осталась только одна версия расширений.
	Блокировка = Новый БлокировкаДанных;
	ЭлементБлокировки = Блокировка.Добавить("Справочник.ВерсииРасширений");
	ЭлементБлокировки.Режим = РежимБлокировкиДанных.Разделяемый;
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ ПЕРВЫЕ 2
	|	ВерсииРасширений.Ссылка КАК Ссылка,
	|	ВерсииРасширений.ДатаПервогоВходаПослеУдаленияВсехРасширений
	|ИЗ
	|	Справочник.ВерсииРасширений КАК ВерсииРасширений";
	
	НачатьТранзакцию();
	Попытка
		Блокировка.Заблокировать();
		Выгрузка = Запрос.Выполнить().Выгрузить();
		Если Выгрузка.Количество() < 2 Тогда
			Если Выгрузка.Количество() = 0 Тогда
				ВключитьЗаданиеУдалениеУстаревшихПараметровРаботыВерсийРасширений(Ложь);
			Иначе
				// Удаление всех регистраций использования метаданных.
				ВсеЗаписи = РегистрыСведений.СеансыВерсийРасширений.СоздатьНаборЗаписей();
				ВсеЗаписи.Записать();
				Если ЗначениеЗаполнено(ПараметрыСеанса.УстановленныеРасширения) Тогда
					ВключитьЗаданиеУдалениеУстаревшихПараметровРаботыВерсийРасширений(Ложь);
				КонецЕсли;
				Если ВерсииУдалялись
				   И ЗначениеЗаполнено(Выгрузка[0].ДатаПервогоВходаПослеУдаленияВсехРасширений) Тогда
					
					Объект = Выгрузка[0].Ссылка.ПолучитьОбъект();
					Объект.ДатаПервогоВходаПослеУдаленияВсехРасширений = Неопределено;
					Объект.Записать();
				КонецЕсли;
			КонецЕсли;
		Иначе
			// Удаление устаревших регистраций использования метаданных.
			ВсеЗаписи = РегистрыСведений.СеансыВерсийРасширений.СоздатьНаборЗаписей();
			ВсеЗаписи.Прочитать();
			
			Для Каждого Строка Из ВсеЗаписи Цикл
				Если СеансСуществует(Строка, Сеансы) Тогда
					Продолжить;
				КонецЕсли;
				НаборЗаписей = РегистрыСведений.СеансыВерсийРасширений.СоздатьНаборЗаписей();
				НаборЗаписей.Отбор.НомерСеанса.Установить(Строка.НомерСеанса);
				НаборЗаписей.Отбор.НачалоСеанса.Установить(Строка.НачалоСеанса);
				НаборЗаписей.Отбор.ВерсияРасширений.Установить(Строка.ВерсияРасширений);
				НаборЗаписей.Записать();
			КонецЦикла;
		КонецЕсли;
		ЗафиксироватьТранзакцию();
	Исключение
		ОтменитьТранзакцию();
		ВызватьИсключение;
	КонецПопытки;
	
КонецПроцедуры

// Вызывается из формы УстановленныеРасширения.
Процедура ПриУдаленииВсехРасширений() Экспорт
	
	ЗарегистрироватьПервыйВходПослеУдаленияВсехРасширений();
	ВключитьЗаданиеУдалениеУстаревшихПараметровРаботыВерсийРасширений(Истина);
	
КонецПроцедуры

// Включает/Отключает регламентное задание УдалениеУстаревшихПараметровРаботыВерсийРасширений.
Процедура ВключитьЗаданиеУдалениеУстаревшихПараметровРаботыВерсийРасширений(Включить) Экспорт
	
	СтандартныеПодсистемыСервер.УстановитьИспользованиеПредопределенногоРегламентногоЗадания(
		Метаданные.РегламентныеЗадания.УдалениеУстаревшихПараметровРаботыВерсийРасширений, Включить);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Для функции ВерсияРасширений и процедуры ПеререгистрироватьВерсиюРасширенийВРежимеОтладки.
Функция ВерсияРасширенийБезУчетаКонтрольнойСуммы()
	
	Если Не ЗначениеЗаполнено(ПараметрыСеанса.УстановленныеРасширения) Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	Если Не ОбщегоНазначенияКлиентСервер.РежимОтладки()
	 Или Не ОбщегоНазначенияПовтИсп.ДоступноИспользованиеРазделенныхДанных()
	 Или ОбновлениеИнформационнойБазы.НеобходимоОбновлениеИнформационнойБазы() Тогда
		
		Возврат Неопределено;
	КонецЕсли;
	
	УстановленныеРасширения = ПараметрыСеанса.УстановленныеРасширения;
	ОписаниеРасширений = Новый Массив;
	ЧислоСтрок = СтрЧислоСтрок(УстановленныеРасширения);
	Для НомерСтроки = 1 По ЧислоСтрок Цикл
		ТекущаяСтрока = СтрПолучитьСтроку(УстановленныеРасширения, НомерСтроки);
		Позиция = СтрНайти(ТекущаяСтрока, ")");
		ОписаниеРасширений.Добавить(Лев(ТекущаяСтрока, Позиция));
	КонецЦикла;
	ОписаниеРасширений.Добавить("#" + Метаданные.Имя + " (" + Метаданные.Версия + ")");
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ВерсииРасширений.Ссылка КАК Ссылка,
	|	ВерсииРасширений.ОписаниеМетаданных
	|ИЗ
	|	Справочник.ВерсииРасширений КАК ВерсииРасширений
	|ГДЕ
	|	ИСТИНА В
	|			(ВЫБРАТЬ ПЕРВЫЕ 1
	|				ИСТИНА
	|			ИЗ
	|				РегистрСведений.ИдентификаторыОбъектовВерсийРасширений КАК ВерсииИдентификаторов
	|			ГДЕ
	|				ВерсииИдентификаторов.ВерсияРасширений = ВерсииРасширений.Ссылка)
	|
	|УПОРЯДОЧИТЬ ПО
	|	ВерсииРасширений.Код УБЫВ";
	Выборка = Запрос.Выполнить().Выбрать();
	
	Пока Выборка.Следующий() Цикл
		ВерсияРасширений = Выборка.Ссылка;
		Для Каждого ОписаниеРасширения Из ОписаниеРасширений Цикл
			НомерСтроки = ОписаниеРасширений.Найти(ОписаниеРасширения) + 1;
			ТекущаяСтрока = СтрПолучитьСтроку(Выборка.ОписаниеМетаданных, НомерСтроки);
			Если Не СтрНачинаетсяС(ТекущаяСтрока, ОписаниеРасширения) Тогда
				ВерсияРасширений = Неопределено;
				Прервать;
			КонецЕсли;
		КонецЦикла;
		Если ЗначениеЗаполнено(ВерсияРасширений) Тогда
			Прервать;
		КонецЕсли;
	КонецЦикла;
	
	Возврат ВерсияРасширений;
	
КонецФункции

// Для процедуры УдалитьУстаревшиеВерсииПараметров.
Функция СеансСуществует(ОписаниеСеанса, СуществующиеСеансы)
	
	НачалоСеанса = СуществующиеСеансы[ОписаниеСеанса.НомерСеанса];
	
	Возврат НачалоСеанса <> Неопределено
	      И НачалоСеанса > (ОписаниеСеанса.НачалоСеанса - 30)
	      И (ОписаниеСеанса.НачалоСеанса + 30) > НачалоСеанса;
	
КонецФункции

// Для функции ВерсияРасширений и процедуры ПриУдаленииВсехРасширений.
Процедура ЗарегистрироватьПервыйВходПослеУдаленияВсехРасширений()
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ ПЕРВЫЕ 2
	|	ВерсииРасширений.Ссылка КАК Ссылка,
	|	ВерсииРасширений.ДатаПервогоВходаПослеУдаленияВсехРасширений
	|ИЗ
	|	Справочник.ВерсииРасширений КАК ВерсииРасширений";
	Выгрузка = Запрос.Выполнить().Выгрузить();
	
	Если Выгрузка.Количество() = 1
	   И Не ЗначениеЗаполнено(Выгрузка[0].ДатаПервогоВходаПослеУдаленияВсехРасширений) Тогда
		
		Объект = Выгрузка[0].Ссылка.ПолучитьОбъект();
		// Тут должна быть именно ТекущаяДата(), так как
		// именно она устанавливается в поле НачалоСеанса.
		Объект.ДатаПервогоВходаПослеУдаленияВсехРасширений = ТекущаяДата();
		Объект.Записать();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли