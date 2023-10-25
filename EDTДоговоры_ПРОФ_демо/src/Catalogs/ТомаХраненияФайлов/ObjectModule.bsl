#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	Если ЭтоГруппа Тогда
		Возврат;
	КонецЕсли;	
	
	Если Не ДополнительныеСвойства.Свойство("ПропуститьОсновнуюПроверкуЗаполнения") Тогда
	
		Если Не НомерПорядкаУникален(ПорядокЗаполнения, Ссылка) Тогда
			ТекстОшибки = НСтр("ru = 'Порядок заполнения не уникален - в системе уже есть том с таким порядком'");
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстОшибки, , "ПорядокЗаполнения", "Объект", Отказ);
		КонецЕсли;
		
		Если МаксимальныйРазмер <> 0 Тогда
			ТекущийРазмерВБайтах = 0;
			Если Не Ссылка.Пустая() Тогда
				
				ФайловыеФункцииСлужебный.ПриОпределенииРазмераФайловНаТоме(
					Ссылка, ТекущийРазмерВБайтах);
			КонецЕсли;
			ТекущийРазмер = ТекущийРазмерВБайтах / (1024 * 1024);
			
			Если МаксимальныйРазмер < ТекущийРазмер Тогда
				ТекстОшибки = НСтр("ru = 'Максимальный размер тома меньше, чем текущий размер'");
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстОшибки, , "МаксимальныйРазмер", "Объект", Отказ);
			КонецЕсли;
		КонецЕсли;
		
		Если ПустаяСтрока(ПолныйПутьWindows) И ПустаяСтрока(ПолныйПутьLinux) Тогда
			ТекстОшибки = НСтр("ru = 'Не заполнен полный путь'");
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстОшибки, , "ПолныйПутьWindows", "Объект", Отказ);
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстОшибки, , "ПолныйПутьLinux",   "Объект", Отказ);
			Возврат;
		КонецЕсли;
		
		Если Не ПолучитьФункциональнуюОпцию("ИспользуютсяПрофилиБезопасности")
		   И Не ПустаяСтрока(ПолныйПутьWindows)
		   И (    Лев(ПолныйПутьWindows, 2) <> "\\"
		      ИЛИ СтрНайти(ПолныйПутьWindows, ":") <> 0 ) Тогда
			
			ТекстОшибки = НСтр("ru = 'Путь к тому должен быть в формате UNC (\\servername\resource).'");
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстОшибки, , "ПолныйПутьWindows", "Объект", Отказ);
			Возврат;
		КонецЕсли;
	КонецЕсли;
	
	Если Не ДополнительныеСвойства.Свойство("ПропуститьПроверкуДоступаКПапке") Тогда
		ИмяПоляСПолнымПутем = "";
		ПолныйПутьТома = "";
		
		ТипПлатформыСервера = ОбщегоНазначенияПовтИсп.ТипПлатформыСервера();
		
		Если ТипПлатформыСервера = ТипПлатформы.Windows_x86
		 ИЛИ ТипПлатформыСервера = ТипПлатформы.Windows_x86_64 Тогда
			
			ПолныйПутьТома = ПолныйПутьWindows;
			ИмяПоляСПолнымПутем = "ПолныйПутьWindows";
		Иначе
			ПолныйПутьТома = ПолныйПутьLinux;
			ИмяПоляСПолнымПутем = "ПолныйПутьLinux";
		КонецЕсли;
		
		ИмяКаталогаТестовое = ПолныйПутьТома + "ПроверкаДоступа\";
		
		Попытка
			СоздатьКаталог(ИмяКаталогаТестовое);
			УдалитьФайлы(ИмяКаталогаТестовое);
		Исключение
			ИнформацияОбОшибке = ИнформацияОбОшибке();
			
			Если ПолучитьФункциональнуюОпцию("ИспользуютсяПрофилиБезопасности") Тогда
				ШаблонОшибки =
					НСтр("ru = 'Путь к тому некорректен.
					           |Возможно не настроены разрешения в профилях безопасности,
					           |или учетная запись, от лица которой работает
					           |сервер 1С:Предприятия, не имеет прав доступа к каталогу тома.
					           |
					           |%1'");
			Иначе
				ШаблонОшибки =
					НСтр("ru = 'Путь к тому некорректен.
					           |Возможно учетная запись, от лица которой работает
					           |сервер 1С:Предприятия, не имеет прав доступа к каталогу тома.
					           |
					           |%1'");
			КонецЕсли;
			
			ТекстОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				ШаблонОшибки, КраткоеПредставлениеОшибки(ИнформацияОбОшибке));
			
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
				ТекстОшибки, , ИмяПоляСПолнымПутем, "Объект", Отказ);
		КонецПопытки;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Возвращает Ложь, если есть том с таким порядком.
Функция НомерПорядкаУникален(ПорядокЗаполнения, СсылкаНаТом)
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	КОЛИЧЕСТВО(Тома.ПорядокЗаполнения) КАК Количество
	|ИЗ
	|	Справочник.ТомаХраненияФайлов КАК Тома
	|ГДЕ
	|	Тома.ПорядокЗаполнения = &ПорядокЗаполнения
	|	И Тома.Ссылка <> &СсылкаНаТом";
	
	Запрос.Параметры.Вставить("ПорядокЗаполнения", ПорядокЗаполнения);
	Запрос.Параметры.Вставить("СсылкаНаТом", СсылкаНаТом);
	
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда
		Возврат Выборка.Количество = 0;
	КонецЕсли;
	
	Возврат Истина;
	
КонецФункции

#КонецОбласти

#КонецЕсли