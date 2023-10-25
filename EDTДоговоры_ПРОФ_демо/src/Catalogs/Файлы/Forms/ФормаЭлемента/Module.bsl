
#Область ОбработчикиКомандФормы_Отправить

#КонецОбласти

#Область ОбработчикиСобытийФормы
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	ПараметрыФайлОснование = Параметры.ФайлОснование;
	
	Если НЕ Параметры.ФайлОснование.Пустая() И Объект.ТекущаяВерсия.Пустая() Тогда
		
		Элементы.ИконкаФайлаБольшая.Видимость = Ложь;
		Элементы.ИконкаФайлаБольшаяНаОсновании.Видимость = Истина;
		ИндексКартинкиНаОсновании = Параметры.ФайлОснование.ИндексКартинки;
		
		ЗаполнитьПараметрыКарточки(Параметры.ФайлОснование);
		
		Если Параметры.ФайлОснование.ТекущаяВерсия.ТипХраненияФайла 
			= Перечисления.ТипыХраненияФайлов.ВТомахНаДиске Тогда
			
			НетФайлаШаблона = Ложь;
			ПолныйПуть = "";
			
			Если НЕ Параметры.ФайлОснование.ТекущаяВерсия.Том.Пустая() Тогда
				
				ПолныйПуть = ФайловыеФункции.ПолныйПутьТома(Параметры.ФайлОснование.ТекущаяВерсия.Том)
					+ Параметры.ФайлОснование.ТекущаяВерсия.ПутьКФайлу; 
				Файл = Новый Файл(ПолныйПуть);
				НетФайлаШаблона = Не Файл.Существует();
				
			Иначе
				НетФайлаШаблона = Истина;
			КонецЕсли;
			
			Если НетФайлаШаблона Тогда
				
				ТекстОшибки = СтрШаблон(
					НСтр("ru ='Отсутствует файл (""%1"") у шаблона.'"),
					ПолныйПуть);
				
				ВызватьИсключение ТекстОшибки;
				
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЕсли;
	
	ТекущийПользователь = Пользователи.ТекущийПользователь();
	
	Элементы.Владелец.ТолькоПросмотр = Истина;
	Элементы.Владелец.КнопкаВыбора = Ложь;
	
	ДанныеФайлаКорректны = Ложь;
	
	Если Параметры.Свойство("РежимСоздания") Тогда 
		РежимСоздания = Параметры.РежимСоздания;
	КонецЕсли;
	
	Если Параметры.Ключ = Неопределено Или Параметры.Ключ.Пустая() Тогда
		
		НовыйФайл = Истина;
		
		Если Параметры.ЗначениеКопирования.Пустая() Тогда
			Объект.ВладелецФайла = Параметры.ВладелецФайла;
		Иначе
			Объект.ТекущаяВерсия = Справочники.ВерсииФайлов.ПустаяСсылка();
			Параметры.ФайлОснование = Параметры.ЗначениеКопирования;
		КонецЕсли;
		
	КонецЕсли;
	
	ДокОснование = Параметры.ФайлОснование;
	Если Не ДокОснование.Пустая() Тогда
		
		Объект.ПолноеНаименование = ДокОснование.ПолноеНаименование;
		Объект.Наименование = Объект.ПолноеНаименование;
		Объект.ХранитьВерсии = ДокОснование.ХранитьВерсии;
		
	КонецЕсли;
	
	ДанныеФайлаКорректны = Ложь;
	Если Не Объект.Ссылка.Пустая() Тогда
		ДанныеФайла = РаботаСФайламиВызовСервера.ДанныеФайла(Объект.Ссылка);
		ДанныеФайлаКорректны = Истина;
		
		Если ДанныеФайла.СтатусРаспознаванияТекста = "Распознано" Тогда
			Распознан = Истина;
		КонецЕсли;
		
		Если ДанныеФайла.СтатусИзвлеченияТекста = "Извлечен" Тогда
			ИзвлеченТекст = Истина;
		КонецЕсли;
		
	КонецЕсли;
	
	ТипВладельца = ТипЗнч(Объект.ВладелецФайла);
	Элементы.Владелец.Заголовок = ТипВладельца;
	
	НовыйФайлЗаписан = Ложь;
	
	Если Параметры.Свойство("КарточкаОткрытаПослеСозданияФайла") Тогда
		Если Параметры.КарточкаОткрытаПослеСозданияФайла Тогда
			Попытка
				ЗаблокироватьДанныеФормыДляРедактирования();
			Исключение
			КонецПопытки;
		КонецЕсли;
	КонецЕсли;
	
	ОбновитьПредставлениеВладельца();
	
	ИспользоватьАвтозаполнениеФайлов = Истина;
	
	Если НЕ Параметры.ФайлОснование.Пустая() И Объект.ТекущаяВерсия.Пустая() Тогда
		Объект.ШаблонОснованиеДляСоздания = Параметры.ФайлОснование;
	КонецЕсли;

	СписокРасширенийТекстовыхФайлов = ФайловыеФункции.ПолучитьСписокРасширенийТекстовыхФайлов();
	Если ФайловыеФункцииКлиентСервер.РасширениеФайлаВСписке(СписокРасширенийТекстовыхФайлов, Объект.ТекущаяВерсияРасширение) Тогда
		
		Если ЗначениеЗаполнено(Объект.ТекущаяВерсия) Тогда
			
			КодировкаЗначение = РаботаСФайламиВызовСервера.ПолучитьКодировкуВерсииФайла(Объект.ТекущаяВерсия);
			
			СписокКодировок = РаботаСоСтроками.ПолучитьСписокКодировок();
			ЭлементСписка = СписокКодировок.НайтиПоЗначению(КодировкаЗначение);
			Если ЭлементСписка = Неопределено Тогда
				Кодировка = КодировкаЗначение;
			Иначе
				Кодировка = ЭлементСписка.Представление;
			КонецЕсли;
			
		КонецЕсли;
		
		Если Не ЗначениеЗаполнено(Кодировка) Тогда
			Кодировка = НСтр("ru='По умолчанию'");
		КонецЕсли;
		
	Иначе
		Элементы.Кодировка.Видимость = Ложь;
	КонецЕсли;
	
	// Параметры оповещения
	Параметры.Свойство("ПараметрыОповещения", ПараметрыОповещения);
	
	Если Не ЗначениеЗаполнено(Объект.Ссылка) Тогда
		РазрешеноРедактирование = Истина;
	КонецЕсли;	
	
	КешИнформации = РегистрыСведений.КешИнформацииОбОбъектах.СоздатьМенеджерЗаписи();
	КешИнформации.Объект = Объект.Ссылка;
	КешИнформации.Прочитать();
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	УстановитьДоступностьЭлементовФормы();
	
	НаименованиеДоЗаписи = Объект.Наименование;
	
	Оповестить("ОбновитьСписокПоследних");
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	ЗаполнитьПараметрыКарточки(ТекущийОбъект);
	
	ЗапретитьРедактироватьФайлы = Ложь;
	РазрешеноРедактирование = Истина;
	
	ХранитьВерсииНачальноеЗначение = ТекущийОбъект.ХранитьВерсии;	
	
КонецПроцедуры

// Заполняет параметры первой закладки
//
// Параметры:
// ТекущийОбъект - текущий объект
//
&НаСервере
Процедура ЗаполнитьПараметрыКарточки(ТекущийОбъект)

	СозданСтатус = СтрШаблон(
		НСтр("ru = '%1 (%2)'"),
		Формат(ТекущийОбъект.ДатаСоздания, "ДФ='dd.MM.yyyy HH:mm'"),
		Строка(ТекущийОбъект.Автор));
	ИзмененСтатус = СтрШаблон(
		НСтр("ru = '%1 (%2)'"),
		Формат(ТекущийОбъект.ТекущаяВерсияДатаСоздания, "ДФ='dd.MM.yyyy HH:mm'"),
		Строка(ТекущийОбъект.ТекущаяВерсияАвтор));
	
	ИмяИРасширение = ОбщегоНазначенияКлиентСервер.ПолучитьИмяСРасширением(ТекущийОбъект.ПолноеНаименование, 
		ТекущийОбъект.ТекущаяВерсияРасширение);
	
	РазмерСтрока = СтрШаблон(
		НСтр("ru = 'Размер: %1'"), 
			РаботаСоСтроками.ПолучитьРазмерСтрокой(ТекущийОбъект.ТекущаяВерсияРазмер));
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, СтандартнаяОбработка)
	
	Если Не БылЗаданВопросОткрытьДляРедактирования Тогда
		
		Если РежимСоздания = "ИзШаблона" И НовыйФайл
			И НовыйФайлЗаписан И (Не ФайлРедактировался) Тогда
			
			СтрокаВопроса = СтрШаблон(
			  НСтр("ru = 'Открыть файл ""%1"" для редактирования?'"),
			  СокрЛП(Объект.ПолноеНаименование) );
		  
			Обработчик = Новый ОписаниеОповещения("ПослеВопросаОткрытьДляРедактирования", ЭтотОбъект);			  
		  	ПоказатьВопрос(Обработчик, СтрокаВопроса, РежимДиалогаВопрос.ДаНет, ,КодВозвратаДиалога.Да);
		   
		  	Отказ = Истина;
		  	БылЗаданВопросОткрытьДляРедактирования = Истина;
		  	Возврат;
				
		КонецЕсли;
		  
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеВопросаОткрытьДляРедактирования(Ответ, ПараметрыВыполнения) Экспорт
	
	Если Ответ <> КодВозвратаДиалога.Да Тогда 
		Закрыть();
	Иначе	
		Обработчик = Новый ОписаниеОповещения("ЗакрытьФорму", ЭтотОбъект);
		РаботаСФайламиКлиент.РедактироватьСОповещением(Обработчик, Объект.Ссылка, УникальныйИдентификатор);
	КонецЕсли;	
	
КонецПроцедуры	

&НаКлиенте
Процедура ЗакрытьФорму(Ответ, ПараметрыВыполнения) Экспорт
	
	Закрыть();
	
КонецПроцедуры	

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСОбытия = "ФайлОткрыт" И Параметр = Объект.Ссылка Тогда
		НовыйФайл = Ложь;
	КонецЕсли;

	Если ИмяСобытия = "Запись_Файл" И Параметр.Событие = "ФайлРедактировался" 
		И Источник = Объект.Ссылка Тогда
		ФайлРедактировался = Истина;
	КонецЕсли;

	Если ИмяСобытия = "Запись_Файл" И Параметр.Событие = "ДанныеФайлаИзменены" Тогда
		
		ФайлВОповещении = Источник;
		
		Если ФайлВОповещении = Объект.Ссылка Тогда
			Если ДанныеФайла <> Неопределено Тогда
				ДанныеФайлаКорректны = Ложь;
			КонецЕсли;
			
			Прочитать();
			УстановитьДоступностьЭлементовФормы();
			
		КонецЕсли;
		
	КонецЕсли;
	
	Если ИмяСобытия = "ОбъектЗашифрован" И Параметр = Объект.Ссылка Тогда
		
		Если ДанныеФайла <> Неопределено Тогда
			ДанныеФайлаКорректны = Ложь;
		КонецЕсли;
		
		Прочитать();
	КонецЕсли;
	
	Если ИмяСобытия = "АктивнаяВерсияИзменена" И Параметр = Объект.Ссылка Тогда
		Прочитать();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
	
	Объект.Наименование = Объект.ПолноеНаименование;	
	ПараметрыЗаписи.Вставить("ЭтоНовый", Объект.Ссылка.Пустая());
	
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	ПараметрыЗаписи.Вставить("ЭтоНовыйОбъект", Не ЗначениеЗаполнено(ТекущийОбъект.Ссылка));
	
	ТекущийОбъект.ДополнительныеСвойства.Вставить("УникальныйИдентификатор", УникальныйИдентификатор);
	
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	Если НаименованиеДоЗаписи <> ТекущийОбъект.Наименование Тогда
		Если ТекущийОбъект.ТекущаяВерсия.ТипХраненияФайла = Перечисления.ТипыХраненияФайлов.ВТомахНаДиске Тогда
			
			РаботаСФайламиВызовСервера.ПереименоватьФайлВерсииНаДиске(ТекущийОбъект.ТекущаяВерсия, 
				НаименованиеДоЗаписи, ТекущийОбъект.Наименование, УникальныйИдентификатор);
				
		КонецЕсли;
	КонецЕсли;
		
	Если НовыйФайл Тогда 
		ДанныеФайла = РаботаСФайламиВызовСервера.ДанныеФайла(Объект.Ссылка);
		ДанныеФайлаКорректны = Истина;
	КонецЕсли;

	Если НЕ Параметры.ФайлОснование.Пустая() И Объект.ТекущаяВерсия.Пустая() Тогда
		СоздатьКопиюВерсии(Объект.Ссылка, Параметры.ФайлОснование, Истина);
		Если ЗначениеЗаполнено(АдресДвоичныхДанныхЗаполненногоФайлаВоВременномХранилище) Тогда
			АвтозаполнениеШаблоновФайловСервер.ОбновитьВерсиюИзДвоичныхДанных(ПолучитьИзВременногоХранилища(АдресДвоичныхДанныхЗаполненногоФайлаВоВременномХранилище), 
					ТекущийОбъект.Ссылка, 
					"Автозаполнение полей файла",
					УникальныйИдентификатор);
			АвтозаполнениеВыполнялось = Истина;
			Прочитать();
		КонецЕсли;
		Модифицированность = Истина;
	КонецЕсли;
	
	//Считываем настройки автозаполнения для дальнейшего использования
	ИспользоватьАвтозаполнениеФайлов = Истина;
	Если ИспользоватьАвтозаполнениеФайлов И НовыйФайл Тогда
		НастройкиАвтозаполнения = АвтозаполнениеШаблоновФайловСервер.ПолучитьНастройкиАвтозаполненияШаблоновФайлов(Объект, Объект.ВладелецФайла);
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ПараметрыФайлОснование) Тогда
		Элементы.ИконкаФайлаБольшая.Видимость = Истина;
		Элементы.ИконкаФайлаБольшаяНаОсновании.Видимость = Ложь;
	КонецЕсли;	
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	#Если НЕ Вебклиент Тогда
		Если НовыйФайл
			И ТипЗнч(Объект.ВладелецФайла) = Тип("СправочникСсылка.ДоговорныеДокументы")
			И НастройкиАвтозаполнения <> Неопределено
			И НастройкиАвтозаполнения.МассивЗамен <> Неопределено 
			И НастройкиАвтозаполнения.МассивЗамен.Количество() > 0
			И НЕ АвтозаполнениеВыполнялось Тогда
			
			АвтозаполнениеШаблоновФайловКлиентСервер.ЗаполнитьПоляФайлаДаннымиВладельца(
				Истина,
				Объект.Ссылка,
				Истина,
				УникальныйИдентификатор,
				Объект.ВладелецФайла);
			Прочитать();			
			Состояние();
		КонецЕсли;
	#КонецЕсли
	
	Если ПараметрыЗаписи.ЭтоНовый Тогда
		Если ЗначениеЗаполнено(ПараметрыОповещения) Тогда
			ПараметрОповещения = Новый Структура;
			ПараметрОповещения.Вставить("Ссылка", Объект.Ссылка);
			ПараметрОповещения.Вставить("ПараметрСобытия", ПараметрыОповещения.ПараметрСобытия);
			Оповестить(ПараметрыОповещения.ИмяСобытия, ПараметрОповещения);
		КонецЕсли;
	КонецЕсли;
	
	Если НовыйФайл И Не НовыйФайлЗаписан Тогда 
		
		НовыйФайлЗаписан = Истина;
		
		ПараметрыОповещения = Новый Структура;
		ПараметрыОповещения.Вставить("Владелец", Объект.ВладелецФайла);
		ПараметрыОповещения.Вставить("Файл", Объект.Ссылка);
		ПараметрыОповещения.Вставить("ИдентификаторРодительскойФормы", Неопределено);
		ПараметрыОповещения.Вставить("Событие", "СозданФайл");
		Если ТипЗнч(ЭтаФорма.ВладелецФормы) = Тип("УправляемаяФорма") Тогда 
			ПараметрыОповещения.ИдентификаторРодительскойФормы = ЭтаФорма.ВладелецФормы.УникальныйИдентификатор;
		КонецЕсли;	
			
		Оповестить("Запись_Файл", ПараметрыОповещения);
	Иначе
		Если НаименованиеДоЗаписи <> Объект.Наименование Тогда
			// в кеше обновить файл
			РаботаСФайламиКлиент.ОбновитьИнформациюВРабочемКаталоге(Объект.ТекущаяВерсия, Объект.Наименование);
			НаименованиеДоЗаписи = Объект.Наименование;
		КонецЕсли;
	КонецЕсли;
	
	ПараметрыОповещения = Новый Структура;
	ПараметрыОповещения.Вставить("Файл", Объект.Ссылка);
	ПараметрыОповещения.Вставить("Владелец", Объект.ВладелецФайла);
	
	Оповестить("ФайлИзменен", ПараметрыОповещения);
	
	Если ЗначениеЗаполнено(ПараметрыФайлОснование) Тогда
		ПараметрыПриложения["СтандартныеПодсистемы.ЕстьИспользованныеШаблоныФайлов"] = Истина;
	КонецЕсли;	
	
	УстановитьДоступностьЭлементовФормы();
	
КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)

	Если Объект.ХранитьВерсии <> ХранитьВерсииНачальноеЗначение И Не Объект.ХранитьВерсии
		И ЗначениеЗаполнено(Объект.ШаблонОснованиеДляСоздания)
		И ДоговорныеДокументыКлиентСервер.ЭтоДоговорнойДокумент(Объект.ВладелецФайла)
		И Не РольДоступна("ПолныеПрава") Тогда
		
		ТекстСообщения = НСтр("ru = 'Запрещено снимать флаг ""Хранить версии"" для файлов, созданных по шаблону.'");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения,,"Объект.ХранитьВерсии",,Отказ);
		
	КонецЕсли;	
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

// Функция предназначена для копирования последней версии
// из Файла-источника в Файл-приемник
// Параметры:
//	Приемник - ссылка на "Файл" куда копируется прилинкованный Файл
//	Источник - ссылка на "Файл" откуда копируется прилинкованный Файл
&НаСервере
Функция СоздатьКопиюВерсии(Приемник, Источник, ЗаполнятьШаблон = Ложь)	

	Если Источник.ТекущаяВерсия.Пустая() Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	ХранилищеФайла = Неопределено;
	Если Источник.ТекущаяВерсия.ТипХраненияФайла = Перечисления.ТипыХраненияФайлов.ВИнформационнойБазе Тогда 
		ХранилищеФайла = РаботаСФайламиВызовСервера.ПолучитьХранилищеФайлаИзИнформационнойБазы(Источник.ТекущаяВерсия);
	КонецЕсли;	
	
	СведенияОФайле = РаботаСФайламиКлиентСервер.СведенияОФайле("ФайлСВерсией");
	СведенияОФайле.ИмяБезРасширения = Объект.Наименование;
	СведенияОФайле.Размер = Источник.ТекущаяВерсия.Размер;
	СведенияОФайле.РасширениеБезТочки = Источник.ТекущаяВерсия.Расширение;
	СведенияОФайле.АдресВременногоХранилищаФайла = ХранилищеФайла;
	СведенияОФайле.АдресВременногоХранилищаТекста = Источник.ТекущаяВерсия.ТекстХранилище;
	СведенияОФайле.СсылкаНаВерсиюИсточник = Источник.ТекущаяВерсия;
	СведенияОФайле.ВремяИзменения = Источник.ТекущаяВерсия.ДатаМодификацииФайла;
	СведенияОФайле.ВремяИзмененияУниверсальное = Источник.ТекущаяВерсия.ДатаМодификацииУниверсальная;
	Версия = РаботаСФайламиВызовСервера.СоздатьВерсию(Приемник, СведенияОФайле);
	
	// Обновим форму Файла (ведь запись может произойти и не при закрытии формы)
	Объект.ТекущаяВерсия = Версия.Ссылка;
	
	// Обновим запись в информационной базе
	РаботаСФайламиВызовСервера.ОбновитьВерсиюВФайле(Приемник, 
		Версия, 
		Источник.ТекущаяВерсия.ТекстХранилище, 
		УникальныйИдентификатор);
		
	Кодировка = РаботаСФайламиВызовСервера.ПолучитьКодировкуВерсииФайла(Источник.ТекущаяВерсия);
		
	Если Кодировка <> Неопределено Тогда
		РаботаСФайламиВызовСервера.ЗаписатьКодировкуВерсииФайла(Приемник.ТекущаяВерсия, Кодировка);
	КонецЕсли;	
		
	ПараметрыРаспознавания = РаботаСФайламиВызовСервера.ПодготовитьПараметрыРаспознавания();
	Если ПараметрыРаспознавания <> Неопределено И ПараметрыРаспознавания.Свойство("РаспознатьПослеДобавления") И ПараметрыРаспознавания.РаспознатьПослеДобавления Тогда
		РаспознатьНемедленно = Ложь;
		ОписаниеОшибки = "";
		РаспознанныйТекст = "";
		РаботаСФайламиВызовСервера.РаспознатьФайл(Объект.Ссылка, 
			ПараметрыРаспознавания, 
			ОписаниеОшибки, 
			РаспознанныйТекст, 
			УникальныйИдентификатор,  
			РаспознатьНемедленно);
	КонецЕсли;
		
	Прочитать();		

	Если ИспользоватьАвтозаполнениеФайлов 
		И ЗаполнятьШаблон 
		И ТипЗнч(Объект.ВладелецФайла) = Тип("СправочникСсылка.ДоговорныеДокументы") Тогда
		РезультатЗаполнения = АвтозаполнениеШаблоновФайловКлиентСервер.ЗаполнитьПоляФайлаДаннымиВладельца(Ложь, Объект.Ссылка, Истина, УникальныйИдентификатор);
		Если РезультатЗаполнения.Результат Тогда
			АвтозаполнениеВыполнялось = Истина;
		КонецЕсли;
		Прочитать();
	КонецЕсли;

КонецФункции // СоздатьКопиюВерсии()

// Устанавливает доступность команд и элементов формы
&НаКлиенте
Процедура УстановитьДоступностьЭлементовФормы()
	
	ДоступныДействияСФайлом = Не Объект.ТекущаяВерсия.Пустая() И Не Объект.Ссылка.Пустая();
	
	РедактируетТекущийПользователь = (Объект.Редактирует = ПользователиКлиентСервер.ТекущийПользователь());
	РедактируетДругой = Не Объект.Редактирует.Пустая() И Не РедактируетТекущийПользователь;
	
	Элементы.ХранитьВерсии.Доступность = ДоступныДействияСФайлом И Не Объект.ПометкаУдаления;
	Элементы.ОткрытьКаталогФайла.Доступность = ДоступныДействияСФайлом;
	Элементы.СохранитьКак.Доступность = ДоступныДействияСФайлом;
	
	Элементы.ПолноеНаименование.ТолькоПросмотр = НЕ Объект.Редактирует.Пустая();
	
	Элементы.ОбновитьИзФайлаНаДиске.Доступность = ДоступныДействияСФайлом И РазрешеноРедактирование;
	
	Элементы.ФормаПросмотретьТекстовыйОбраз.Доступность = ДоступныДействияСФайлом;
	
КонецПроцедуры

&НаКлиенте
Процедура ПолноеНаименованиеПриИзменении(Элемент)
	
	Объект.ПолноеНаименование = СокрЛП(Объект.ПолноеНаименование);
	Попытка
		ФайловыеФункцииКлиент.КорректноеИмяФайла(Объект.ПолноеНаименование, Истина);
	Исключение
		Информация = ИнформацияОбОшибке();
		ПоказатьПредупреждение(, Информация.Описание);
	КонецПопытки;
	
	Объект.Наименование = СокрЛП(Объект.ПолноеНаименование);
	
	ИмяИРасширение = ОбщегоНазначенияКлиентСервер.ПолучитьИмяСРасширением(Объект.ПолноеНаименование, 
		Объект.ТекущаяВерсияРасширение);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаписатьВыполнить()
	
	Записать();
	Прочитать();
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьПредставлениеВладельца()
	
	ТипВладельца = ТипЗнч(Объект.ВладелецФайла);
	ТипВладельцаСтрока = Строка(ТипВладельца);
	ПолныйПутьОписание = Строка(Объект.ВладелецФайла);
	
	Если ТипВладельца = Тип("СправочникСсылка.ДоговорныеДокументы") Тогда
		ВидДокумента = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Объект.ВладелецФайла, "ВидДокумента");
		Тип = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ВидДокумента, "Тип");
		ТипВладельцаСтрока = Строка(Тип);
	КонецЕсли;	
	
	Элементы.ПолныйПутьОписание.Заголовок = ТипВладельцаСтрока;
	
КонецПроцедуры	

// Выполняет открытие файла на просмотр
&НаКлиенте
Процедура ОткрытьФайлВыполнить()
	
	Если Объект.Ссылка.Пустая() Тогда
		ОчиститьСообщения();
		Если Не Записать() Тогда 
			Возврат;
		КонецЕсли;
	КонецЕсли;
	
	Обработчик = Новый ОписаниеОповещения("ПрочитатьИУстановитьДоступностьЭлементовФормы", ЭтотОбъект);
	РаботаСФайламиКлиент.РедактироватьСОповещением(Обработчик, Объект.Ссылка, УникальныйИдентификатор);
	
КонецПроцедуры

&НаКлиенте
Процедура ПрочитатьИУстановитьДоступностьЭлементовФормы(Результат, ПараметрыВыполнения) Экспорт
	Прочитать();
	УстановитьДоступностьЭлементовФормы();
КонецПроцедуры

&НаКлиенте
Процедура ПолучитьДанныеФайлаЕслиНекорректны()
	
	Если ДанныеФайла = Неопределено ИЛИ НЕ ДанныеФайлаКорректны Тогда
		ДанныеФайла = РаботаСФайламиВызовСервера.ДанныеФайла(Объект.Ссылка);
		ДанныеФайлаКорректны = Истина;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗакончитьРедактирование(Команда)
	
	Если Объект.Редактирует.Пустая() Тогда
		
		СтрокаСообщения = Новый ФорматированнаяСтрока(
			НСтр("ru = 'Нельзя закончить редактирование файла '"),
			Новый ФорматированнаяСтрока(Строка(Объект.Ссылка), Новый Шрифт(,,Истина)),
			НСтр("ru=', т.к. он не занят для редактирования.'") );	
			
		ПоказатьПредупреждение(,СтрокаСообщения);	
		
		Возврат;
		
	КонецЕсли;	
	
	
	Если Модифицированность Тогда
		Записать();
	КонецЕсли;	
	
	ПолучитьДанныеФайлаЕслиНекорректны();
	
	Обработчик = Новый ОписаниеОповещения("ПрочитатьИУстановитьДоступностьЭлементовФормы", ЭтотОбъект);
	ПараметрыОбновленияФайла = РаботаСФайламиКлиент.ПараметрыОбновленияФайла(Обработчик, ДанныеФайла.Ссылка, УникальныйИдентификатор);
	ПараметрыОбновленияФайла.ХранитьВерсии = ДанныеФайла.ХранитьВерсии;
	ПараметрыОбновленияФайла.РедактируетТекущийПользователь = ДанныеФайла.РедактируетТекущийПользователь;
	ПараметрыОбновленияФайла.Редактирует = ДанныеФайла.Редактирует;
	РаботаСФайламиКлиент.ЗакончитьРедактированиеСОповещением(ПараметрыОбновленияФайла);
	
КонецПроцедуры

&НаКлиенте
Процедура Занять(Команда)
	
	Если Модифицированность Тогда
		Записать();
	КонецЕсли;	
	
	Обработчик = Новый ОписаниеОповещения("ПрочитатьИУстановитьДоступностьЭлементовФормы", ЭтотОбъект);
	
	РаботаСФайламиКлиент.ЗанятьСОповещением(Обработчик, Объект.Ссылка, УникальныйИдентификатор);
	
КонецПроцедуры

&НаКлиенте
Процедура ОтменитьРедактирование(Команда)
	
	ОтменитьРедактированиеВыполнить();
		
КонецПроцедуры

&НаКлиенте
Процедура ОтменитьРедактированиеВыполнить()
	
	Если Объект.Редактирует.Пустая() Тогда
		
		СтрокаСообщения = Новый ФорматированнаяСтрока(
			НСтр("ru = 'Нельзя освободить файл '"),
			Новый ФорматированнаяСтрока(Строка(Объект.Ссылка), Новый Шрифт(,,Истина)),
			НСтр("ru=', т.к. он не занят для редактирования.'") );	
			
		ПоказатьПредупреждение(,СтрокаСообщения);	
		
		Возврат;
		
	КонецЕсли;	
	
	Если Модифицированность Тогда
		Записать();
	КонецЕсли;	
	
	ПолучитьДанныеФайлаЕслиНекорректны();
	
	Обработчик = Новый ОписаниеОповещения("ПрочитатьИУстановитьДоступностьЭлементовФормы", ЭтотОбъект);
	
	ПараметрыОсвобожденияФайла = РаботаСФайламиКлиент.ПараметрыОсвобожденияФайла(Обработчик, ДанныеФайла.Ссылка);
	ПараметрыОсвобожденияФайла.ХранитьВерсии = ДанныеФайла.ХранитьВерсии;	
	ПараметрыОсвобожденияФайла.РедактируетТекущийПользователь = ДанныеФайла.РедактируетТекущийПользователь;	
	ПараметрыОсвобожденияФайла.Редактирует = ДанныеФайла.Редактирует;	
	ПараметрыОсвобожденияФайла.УникальныйИдентификатор = УникальныйИдентификатор;	
	РаботаСФайламиКлиент.ОсвободитьФайлСОповещением(ПараметрыОсвобожденияФайла);
		
КонецПроцедуры

&НаКлиенте
Процедура СохранитьИзменения(Команда)
	
	СохранитьИзмененияВыполнить();
	
КонецПроцедуры

&НаКлиенте
Процедура СохранитьИзмененияВыполнить()
	
	Если Объект.Редактирует.Пустая() Тогда
		
		СтрокаСообщения = Новый ФорматированнаяСтрока(
			НСтр("ru = 'Нельзя сохранить изменения файла '"),
			Новый ФорматированнаяСтрока(Строка(Объект.Ссылка), Новый Шрифт(,,Истина)),
			НСтр("ru=', т.к. он не занят для редактирования.'") );	
			
		ПоказатьПредупреждение(,СтрокаСообщения);	
		
		Возврат;
		
	КонецЕсли;	
	
	Если Модифицированность Тогда
		Записать();
	КонецЕсли;	
	
	Обработчик = Новый ОписаниеОповещения("ПрочитатьИУстановитьДоступностьЭлементовФормы", ЭтотОбъект);
	РаботаСФайламиКлиент.СохранитьИзмененияФайлаСОповещением(Обработчик, Объект.Ссылка, УникальныйИдентификатор);
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьКаталогФайла(Команда)
	
	ОткрытьКаталогФайлаВыполнить();
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьКаталогФайлаВыполнить()
	
	ДанныеФайла = РаботаСФайламиВызовСервера.ДанныеФайлаДляОткрытия(Объект.Ссылка, Неопределено, УникальныйИдентификатор);
	КомандыРаботыСФайламиКлиент.ОткрытьКаталогФайла(ДанныеФайла);
	
КонецПроцедуры

&НаКлиенте
Процедура СохранитьКак(Команда)
	
	ДанныеФайла = РаботаСФайламиВызовСервера.ДанныеФайлаДляСохранения(Объект.Ссылка, Неопределено, УникальныйИдентификатор);
	КомандыРаботыСФайламиКлиент.СохранитьКак(ДанныеФайла, УникальныйИдентификатор);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьИзФайлаНаДиске(Команда)
	
	ОбновитьИзФайлаНаДискеВыполнить();
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьИзФайлаНаДискеВыполнить()
	
	Если Объект.Ссылка.Пустая() Тогда
		ОчиститьСообщения();
		Если Не Записать() Тогда 
			Возврат;
		КонецЕсли;	
	КонецЕсли;	
	
	Если Модифицированность Тогда
		Записать();
	КонецЕсли;	
	
	ДанныеФайла = РаботаСФайламиВызовСервера.ДанныеФайла(Объект.Ссылка);
	
	Обработчик = Новый ОписаниеОповещения("ПрочитатьИУстановитьДоступностьЭлементовФормы", ЭтотОбъект);
	
	РаботаСФайламиКлиент.ОбновитьИзФайлаНаДискеСОповещением(
		Обработчик,
		ДанныеФайла,
		УникальныйИдентификатор);
	
КонецПроцедуры
	
///////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ ПОДСИСТЕМЫ СВОЙСТВ

&НаКлиенте
Процедура ВладелецПриИзменении(Элемент)
	
	Элементы.ЗаполнитьДаннымиВладельца.Видимость = Истина;
	
	ТипВладельца = ТипЗнч(Объект.ВладелецФайла);
	Элементы.Владелец.Заголовок = ТипВладельца;
	
	ОбновитьПредставлениеВладельца();
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьТекстовыйОбраз(Команда)
	
	Если Объект.Зашифрован Тогда
		ПоказатьПредупреждение(, НСтр("ru = 'Нельзя открыть текстовый образ зашифрованного файла.'"));
		Возврат;
	КонецЕсли;	
	
	ПараметрыФормы = Новый Структура("ОбъектСсылка, ИзКарточкиФайла, ИзвлеченТекст, Распознан", 
		Объект.Ссылка, Истина, ИзвлеченТекст, Распознан);
	ОткрытьФорму("Справочник.Файлы.Форма.ФормаТекстовогоОбраза", ПараметрыФормы);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьДаннымиВладельца(Команда)
	
	Если Объект.Ссылка.Пустая() Тогда 
		Если Не Записать() Тогда 
			Возврат;
		КонецЕсли;
		
		ПоказатьОповещениеПользователя(
			НСтр("ru = 'Создание:'"), 
			ПолучитьНавигационнуюСсылку(Объект.Ссылка),
			Строка(Объект.Ссылка),
			БиблиотекаКартинок.Информация32);
	Иначе
		Если Модифицированность Тогда
			Если Не Записать() Тогда 
				Возврат;
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
	ДанныеВыполнения = АвтозаполнениеШаблоновФайловКлиентСервер.ЗаполнитьПоляФайлаДаннымиВладельца(Истина,
		Объект.Ссылка, 
		Истина, 
		УникальныйИдентификатор);
	Если ДанныеВыполнения.Результат Тогда
		Прочитать();
		Текст = НСтр("ru = 'Поля в файле обновлены данными владельца.'");
	Иначе
		ВызватьИсключение(ДанныеВыполнения.Описание);
	КонецЕсли;
	ПоказатьПредупреждение(, Текст);
	
КонецПроцедуры

// Отрабатывает нажатие на кнопке "..."
&НаКлиенте
Процедура КомандаЕще(Команда)
	
	СписокЗначений = Новый СписокЗначений;
	
	РедактируетТекущийПользователь = (Объект.Редактирует = ПользователиКлиентСервер.ТекущийПользователь());
	РедактируетДругой = Не Объект.Редактирует.Пустая() И Не РедактируетТекущийПользователь;
	
	СписокЗначений.Добавить("ОткрытьКаталогФайла", НСтр("ru = 'Открыть каталог файла'"),, БиблиотекаКартинок.Папка);
	
	Если РазрешеноРедактирование Тогда
		
		Если Не РедактируетДругой Тогда
			СписокЗначений.Добавить("ОбновитьИзФайлаНаДиске", НСтр("ru = 'Обновить из файла на диске'"),, БиблиотекаКартинок.ОбновитьФайлИзФайлаНаДиске);
		КонецЕсли;	
		
	КонецЕсли;
	
	ОписаниеОповещения = Новый ОписаниеОповещения(
		"КомандаЕщеВыбораЗначенияПродолжение",
		ЭтотОбъект);
	
	ПоказатьВыборИзМеню(ОписаниеОповещения, СписокЗначений);
	
КонецПроцедуры

// Обработчик команды с подменю в карточке файла - продолжение
&НаКлиенте
Процедура КомандаЕщеВыбораЗначенияПродолжение(Результат, Параметры) Экспорт
	
	Если Результат = Неопределено Или ТипЗнч(Результат) <> Тип("ЭлементСпискаЗначений") Тогда
		Возврат;
	КонецЕсли;	
	
	Если Результат.Значение = "ОткрытьКаталогФайла" Тогда
		ОткрытьКаталогФайлаВыполнить();
		Возврат;
	ИначеЕсли Результат.Значение = "ОбновитьИзФайлаНаДиске" Тогда
		ОбновитьИзФайлаНаДискеВыполнить();
		Возврат;
	ИначеЕсли Результат.Значение = "ОтменитьРедактирование" Тогда
		ОтменитьРедактированиеВыполнить();
		Возврат;
	ИначеЕсли Результат.Значение = "СохранитьИзменения" Тогда
		СохранитьИзмененияВыполнить();
		Возврат;
	КонецЕсли;	
	
КонецПроцедуры

// Отрабатывает нажатие на элементе ПолныйПутьОписание
&НаКлиенте
Процедура ПолныйПутьОписаниеНажатие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Если ЗначениеЗаполнено(Объект.ВладелецФайла) Тогда
		
		ПоказатьЗначение(, Объект.ВладелецФайла);
		
	КонецЕсли;	
	
КонецПроцедуры

// Отрабатывает нажатие на элементе ИконкаФайлаБольшая
&НаКлиенте
Процедура ИконкаФайлаБольшаяНажатие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ОткрытьФайлВыполнить();
	
КонецПроцедуры

#КонецОбласти