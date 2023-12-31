&НаКлиенте
Перем ВнешниеРесурсыРазрешены;

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	КонстантыНабор.ВыполнятьЗамерыПроизводительности = Константы.ВыполнятьЗамерыПроизводительности.Получить();
	КонстантыНабор.ДатаПоследнейВыгрузкиЗамеровПроизводительностиUTC = Константы.ДатаПоследнейВыгрузкиЗамеровПроизводительностиUTC.Получить();
	КонстантыНабор.ОценкаПроизводительностиЭкспортВсехКлючевыхОпераций = Константы.ОценкаПроизводительностиЭкспортВсехКлючевыхОпераций.Получить();
	
	КонстантыНабор.ОценкаПроизводительностиПериодЗаписи = ОценкаПроизводительностиВызовСервераПолныеПрава.ПериодЗаписи();
	
	КаталогиЭкспорта = ОценкаПроизводительностиСлужебный.КаталогиЭкспортаОценкиПроизводительности();
	Если ТипЗнч(КаталогиЭкспорта) <> Тип("Структура")
		ИЛИ КаталогиЭкспорта.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	ВыполнятьЭкспортНаFTP = КаталогиЭкспорта.ВыполнятьЭкспортНаFTP;
	FTPКаталогЭкспорта = КаталогиЭкспорта.FTPКаталогЭкспорта;
	ВыполнятьЭкспортВЛокальныйКаталог = КаталогиЭкспорта.ВыполнятьЭкспортВЛокальныйКаталог;
	ЛокальныйКаталогЭкспорта = КаталогиЭкспорта.ЛокальныйКаталогЭкспорта;
	
	ВыполнятьЭкспорт = ВыполнятьЭкспортНаFTP Или ВыполнятьЭкспортВЛокальныйКаталог;
	
КонецПроцедуры

&НаКлиенте
Процедура ВыполнятьЭкспортПриИзменении(Элемент)
	ЭкспортРазрешен = ВыполнятьЭкспорт;
	ВыполнятьЭкспортВЛокальныйКаталог = ЭкспортРазрешен;
	ВыполнятьЭкспортНаFTP = ЭкспортРазрешен;
КонецПроцедуры	

&НаКлиенте
Процедура ВыполнятьЭкспортВКаталогПриИзменении(Элемент)
	ВыполнятьЭкспорт = ВыполнятьЭкспортВЛокальныйКаталог ИЛИ ВыполнятьЭкспортНаFTP;
КонецПроцедуры	

&НаКлиенте
Процедура ЛокальныйКаталогФайловЭкспортаНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ВыбратьКаталогЭкспортаПредложено", ЭтотОбъект);
	ОбщегоНазначенияКлиент.ПоказатьВопросОбУстановкеРасширенияРаботыСФайлами(ОписаниеОповещения);
	
КонецПроцедуры

&НаСервере
Функция ОбработкаПроверкиЗаполненияНаСервере()
	ЭлементыНаКонтроле = Новый Соответствие;
	ЭлементыНаКонтроле.Вставить(Элементы.ВыполнятьЭкспортВЛокальныйКаталог, Элементы.ЛокальныйКаталогЭкспорта);
	ЭлементыНаКонтроле.Вставить(Элементы.ВыполнятьЭкспортНаFTP, Элементы.FTPКаталогЭкспорта);
	
	ОшибокНет = Истина;	
	Для Каждого ФлажокПуть Из ЭлементыНаКонтроле Цикл
		Выполнять = ЭтотОбъект[ФлажокПуть.Ключ.ПутьКДанным];
		ПутьЭлемент = ФлажокПуть.Значение;
		Если Выполнять И ПустаяСтрока(СокрЛП(ЭтотОбъект[ПутьЭлемент.ПутьКДанным])) Тогда
			СообщениеТекст = НСтр("ru = 'Поле ""%1"" не заполнено'");
			СообщениеТекст = СтрЗаменить(СообщениеТекст, "%1", ПутьЭлемент.Заголовок);
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
				СообщениеТекст,
				,
				ПутьЭлемент.Имя,
				ПутьЭлемент.ПутьКДанным);
			ОшибокНет = Ложь;
		КонецЕсли;
	КонецЦикла;
	
	Возврат ОшибокНет;	
КонецФункции

&НаСервере
Процедура СохранитьНаСервере()
	
	ВыполнятьЛокальныйКаталог = Новый Массив;
	ВыполнятьЛокальныйКаталог.Добавить(ВыполнятьЭкспортВЛокальныйКаталог);
	ВыполнятьЛокальныйКаталог.Добавить(СокрЛП(ЭтотОбъект.ЛокальныйКаталогЭкспорта));
	
	ВыполнятьFTPКаталог = Новый Массив;
	ВыполнятьFTPКаталог.Добавить(ВыполнятьЭкспортНаFTP);
	ВыполнятьFTPКаталог.Добавить(СокрЛП(ЭтотОбъект.FTPКаталогЭкспорта));
	
	УстановитьКаталогЭкспорта(ВыполнятьЛокальныйКаталог, ВыполнятьFTPКаталог);  

	УстановитьИспользованиеРегламентногоЗадания(ВыполнятьЭкспорт);
	
	Константы.ВыполнятьЗамерыПроизводительности.Установить(КонстантыНабор.ВыполнятьЗамерыПроизводительности);
	Константы.ОценкаПроизводительностиЭкспортВсехКлючевыхОпераций.Установить(КонстантыНабор.ОценкаПроизводительностиЭкспортВсехКлючевыхОпераций);
	Константы.ОценкаПроизводительностиПериодЗаписи.Установить(КонстантыНабор.ОценкаПроизводительностиПериодЗаписи);
	Модифицированность = Ложь;
	
КонецПроцедуры

&НаКлиенте
Процедура ЛокальныйКаталогЭкспортаПриИзменении(Элемент)
	
	ВнешниеРесурсыРазрешены = Ложь;
	
КонецПроцедуры

&НаКлиенте
Процедура FTPКаталогЭкспортаПриИзменении(Элемент)
	
	ВнешниеРесурсыРазрешены = Ложь;
	
КонецПроцедуры

///////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ КОМАНД

&НаКлиенте
Процедура НастроитьРасписаниеЭкспорта(Команда)
	
	РасписаниеРегламентногоЗадания = РасписаниеЭкспортаОценкиПроизводительности();
	
	Оповещение = Новый ОписаниеОповещения("НастроитьРасписаниеЭкспортаЗавершение", ЭтотОбъект);
	Диалог = Новый ДиалогРасписанияРегламентногоЗадания(РасписаниеРегламентногоЗадания);
	Диалог.Показать(Оповещение);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ВыбратьКаталогЭкспортаПредложено(РасширениеРаботыСФайламиПодключено, ДополнительныеПараметры) Экспорт
	
	Если РасширениеРаботыСФайламиПодключено Тогда
		
		ВыборФайла = Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.ВыборКаталога);
		ВыборФайла.МножественныйВыбор = Ложь;
		ВыборФайла.Заголовок = НСтр("ru = 'Выбор каталога экспорта'");
		
		Если ВыборФайла.Выбрать() Тогда
			ВыбранныйКаталог = ВыборФайла.Каталог;
			ЛокальныйКаталогЭкспорта = ВыбранныйКаталог;
			ЭтотОбъект.Модифицированность = Истина;
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

// Изменяет каталог экспорта данных
//
// Параметры:
//  КаталогЭкспорта - Строка, новый каталог экспорта
//
&НаСервереБезКонтекста
Процедура УстановитьКаталогЭкспорта(ВыполнятьЛокальныйКаталогЭкспорта, ВыполнятьFTPКаталогЭкспорта)
	
	Задание = ОценкаПроизводительностиСлужебный.РегламентноеЗаданиеЭкспортаОценкиПроизводительности();
	
	Каталоги = Новый Структура();
	Каталоги.Вставить(ОценкаПроизводительностиКлиентСервер.ЛокальныйКаталогЭкспортаКлючЗадания(), ВыполнятьЛокальныйКаталогЭкспорта);
	Каталоги.Вставить(ОценкаПроизводительностиКлиентСервер.FTPКаталогЭкспортаКлючЗадания(), ВыполнятьFTPКаталогЭкспорта);
	
	ПараметрыЗадания = Новый Массив;	
	ПараметрыЗадания.Добавить(Каталоги);
	Задание.Параметры = ПараметрыЗадания;
	ЗафиксироватьРегламентноеЗадание(Задание);
	
КонецПроцедуры

// Изменяет признак использования регламентного задания
//
// Параметры:
//  НовоеЗначение - Булево, новое значение использования
//
// Возвращаемое значение:
//  Булево - состояние до изменения (предыдущее состояние)
//
&НаСервереБезКонтекста
Функция УстановитьИспользованиеРегламентногоЗадания(НовоеЗначение)
	
	Задание = ОценкаПроизводительностиСлужебный.РегламентноеЗаданиеЭкспортаОценкиПроизводительности();
	ТекущееСостояние = Задание.Использование;
	Если ТекущееСостояние <> НовоеЗначение Тогда
		Задание.Использование = НовоеЗначение;
		ЗафиксироватьРегламентноеЗадание(Задание);
	КонецЕсли;
	
	Возврат ТекущееСостояние;
	
КонецФункции

// Возвращает текущее расписание регламентного задания
//
// Возвращаемое значение:
//  РасписаниеРегламентногоЗадания - текущее расписание
//
&НаСервереБезКонтекста
Функция РасписаниеЭкспортаОценкиПроизводительности()
	
	Задание = ОценкаПроизводительностиСлужебный.РегламентноеЗаданиеЭкспортаОценкиПроизводительности();
	Возврат Задание.Расписание;
	
КонецФункции

// Устанавливает новое расписание регламентному заданию
//
// Параметры:
//  НовоеРасписание - РасписаниеРегламентногоЗадания, которое надо установить
//
&НаСервереБезКонтекста
Процедура УстановитьРасписание(Знач НовоеРасписание)
	
	Задание = ОценкаПроизводительностиСлужебный.РегламентноеЗаданиеЭкспортаОценкиПроизводительности();
	Задание.Расписание = НовоеРасписание;
	ЗафиксироватьРегламентноеЗадание(Задание);
	
КонецПроцедуры

// Сохраняет настройки регламентного задания
//
// Параметры:
//  Задание - РегламентноеЗадание.ЭкспортОценкиПроизводительности
//
&НаСервереБезКонтекста
Процедура ЗафиксироватьРегламентноеЗадание(Задание)
	
	УстановитьПривилегированныйРежим(Истина);
	Задание.Записать();
	
КонецПроцедуры

&НаКлиенте
Процедура НастроитьРасписаниеЭкспортаЗавершение(Расписание, ДополнительныеПараметры) Экспорт
	
	Если Расписание <> Неопределено Тогда
		УстановитьРасписание(Расписание);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СохранитьНастройки(Команда)
	
	Если ОбработкаПроверкиЗаполненияНаСервере() Тогда
		ПроверитьРазрешенияНаДоступКВнешнимРесурсам(Ложь);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СохранитьЗакрыть(Команда)
	
	Если ОбработкаПроверкиЗаполненияНаСервере() Тогда
		ПроверитьРазрешенияНаДоступКВнешнимРесурсам(Истина);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Функция ПроверитьРазрешенияНаДоступКВнешнимРесурсам(ЗакрытьФорму)
	
	Если ВнешниеРесурсыРазрешены <> Истина Тогда
		Если ЗакрытьФорму Тогда
			ОповещениеОЗакрытии = Новый ОписаниеОповещения("РазрешитьВнешнийРесурсСохранитьИЗакрыть", ЭтотОбъект);
		Иначе
			ОповещениеОЗакрытии = Новый ОписаниеОповещения("РазрешитьВнешнийРесурсСохранить", ЭтотОбъект);
		КонецЕсли;
		
		Каталоги = Новый Структура;
		Каталоги.Вставить("ВыполнятьЭкспортНаFTP", ВыполнятьЭкспортНаFTP);
		
		СтруктураURI = ОбщегоНазначенияКлиентСервер.СтруктураURI(FTPКаталогЭкспорта);
		Каталоги.Вставить("FTPКаталогЭкспорта", СтруктураURI.ИмяСервера);
		Если ЗначениеЗаполнено(СтруктураURI.Порт) Тогда
			Каталоги.Вставить("FTPКаталогЭкспортаПорт", СтруктураURI.Порт);
		КонецЕсли;
		
		Каталоги.Вставить("ВыполнятьЭкспортВЛокальныйКаталог", ВыполнятьЭкспортВЛокальныйКаталог);
		Каталоги.Вставить("ЛокальныйКаталогЭкспорта", ЛокальныйКаталогЭкспорта);
		
		Запрос = ЗапросНаИспользованиеВнешнихРесурсов(Каталоги);
		
		РаботаВБезопасномРежимеКлиент.ПрименитьЗапросыНаИспользованиеВнешнихРесурсов(
			ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(Запрос), ЭтотОбъект, ОповещениеОЗакрытии);
			
	ИначеЕсли ЗакрытьФорму Тогда
		СохранитьНаСервере();
		ЭтотОбъект.Закрыть();
		
	Иначе
		СохранитьНаСервере();
	КонецЕсли;
	
КонецФункции

&НаСервереБезКонтекста
Функция ЗапросНаИспользованиеВнешнихРесурсов(Каталоги)
	
	Возврат ОценкаПроизводительностиСлужебный.ЗапросНаИспользованиеВнешнихРесурсов(Каталоги);
	
КонецФункции

&НаКлиенте
Процедура РазрешитьВнешнийРесурсСохранитьИЗакрыть(Результат, Неопределен) Экспорт
	
	Если Результат = КодВозвратаДиалога.ОК Тогда
		ВнешниеРесурсыРазрешены = Истина;
		СохранитьНаСервере();
		ЭтотОбъект.Закрыть();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура РазрешитьВнешнийРесурсСохранить(Результат, Неопределен) Экспорт
	
	Если Результат = КодВозвратаДиалога.ОК Тогда
		ВнешниеРесурсыРазрешены = Истина;
		СохранитьНаСервере();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
