#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Раздел = Параметры.Раздел;
	
	СписокКатегорий = Параметры.СписокКатегорий.Скопировать();
	
	НеОтображатьИерархию = НеДостаточноВариантовДляГруппировки();

	Если Не ПустаяСтрока(Параметры.ЗаголовокФормы) Тогда
		Заголовок = Параметры.ЗаголовокФормы;
	ИначеЕсли ЗначениеЗаполнено(Раздел) Тогда
		
		Если ТипЗнч(Раздел) = Тип("Строка") Тогда
			
			Подсистема = Метаданные.Подсистемы.Найти(Раздел);
			
			Если НЕ Подсистема = Неопределено Тогда
				ЗаголовокФормы = Подсистема.Синоним;
			Конецесли;
					
		Иначе
			
			ЗаголовокФормы = Раздел;
			
		КонецЕсли;

		Заголовок = СтрШаблон(НСтр("ru = 'Отчеты раздела ""%1""'"), ЗаголовокФормы);

	Иначе
		Заголовок = НСтр("ru = 'Отчеты'");
	КонецЕсли;
	
	ИдСтроки = 0;
	
	КлючОбъектаНастроек = Заголовок;
	текКлючВарианта = ХранилищеНастроекДанныхФорм.Загрузить(КлючОбъектаНастроек, "КлючВарианта");
	
	КатегорияСиноним = ХранилищеНастроекДанныхФорм.Загрузить(КлючОбъектаНастроек, "КатегорияСиноним");
	
	ОбновитьДеревоОтчетов();

	// находим сохраненную настройку последнего отчета, выбранного пользователем
	Если Не НеОтображатьИерархию Тогда
		
		СтрокиДерева = ДеревоОтчетовИВариантов.ПолучитьЭлементы();
		
		Для Каждого СтрокаДерева Из СтрокиДерева Цикл
			
			ВариантыОтчета = СтрокаДерева.ПолучитьЭлементы();
			Если НЕ СтрокаДерева.Синоним =  КатегорияСиноним Тогда
				Продолжить;
			КонецЕсли;
			
			Для Каждого ВариантОтчета Из ВариантыОтчета Цикл
				Если ВариантОтчета.КлючВарианта = текКлючВарианта Тогда
					идТекущаяКатегория = ВариантОтчета.ПолучитьИдентификатор();
				КонецЕсли;
			КонецЦикла;
			
		КонецЦикла;
	Иначе 
		
		ВариантыОтчета = ДеревоОтчетовИВариантов.ПолучитьЭлементы();
		Для Каждого ВариантОтчета Из ВариантыОтчета Цикл
			Если ВариантОтчета.КлючВарианта = текКлючВарианта Тогда
				идТекущаяКатегория = ВариантОтчета.ПолучитьИдентификатор();
			КонецЕсли;
		КонецЦикла;
		
	КонецЕсли;
	
	Элементы.ДеревоОтчетовИВариантов.ТекущаяСтрока = идТекущаяКатегория;
	
	Элементы.ДеревоОтчетовИВариантовКонтекстноеМенюНеОтображатьИерархию.Пометка = НеОтображатьИерархию;

КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии()
	
	ТекущиеДанные = Элементы.ДеревоОтчетовИВариантов.ТекущиеДанные;
	
	Если (НЕ ТекущиеДанные = Неопределено) И 
			(ТекущиеДанные.ПолучитьРодителя() <> Неопределено 
			Или НеОтображатьИерархию) Тогда
			
				//Сохранение последнего отчета, с которым работал пользователь
				КлючОбъектаНастроек = Заголовок;
				СтрокаРодитель =ТекущиеДанные.ПолучитьРодителя();
				КатегорияСиноним =  ?(СтрокаРодитель <> Неопределено, СтрокаРодитель.Синоним, "");
				текКлючВарианта = ТекущиеДанные.КлючВарианта;
				ЗаписатьНастройкиДереваКатегорий(КлючОбъектаНастроек, текКлючВарианта, КатегорияСиноним);
		
	КонецЕсли;

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ДеревоОтчетовИВариантовПриАктивизацииСтроки(Элемент)
	
	ПодключитьОбработчикОжидания("ОбработкаОжиданияДеревоОтчетовИВариантовПриАктивизацииСтроки", 0.2, Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура ДеревоОтчетовИВариантовВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ОткрытьОтчетВыполнить();
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьОтчетыРаздела(Команда)
	
	РеквизитыРаздел = ОбщегоНазначенияДокументооборотВызовСервера.ЗначенияРеквизитовОбъекта(
							РазделГипперссылка,"Имя");
							
	ПараметрРаздел = РеквизитыРаздел.Имя;

	ПараметрыФормы = Новый Структура("Раздел", ПараметрРаздел); 

	ОткрытьФорму(
		"Обработка.ВсеОтчеты.Форма.ФормаПоКатегориям",
		ПараметрыФормы,
		ЭтаФорма, 
		);

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФорм


&НаКлиенте
Процедура Обновить(Команда)
	
	ОбновитьДеревоОтчетов();
	
КонецПроцедуры

&НаКлиенте
Процедура НеОтображатьИерархию(Команда)
	
	НеОтображатьИерархию = Не НеОтображатьИерархию;
	Элементы.ДеревоОтчетовИВариантовКонтекстноеМенюНеОтображатьИерархию.Пометка = НеОтображатьИерархию;
	
	ОбновитьДеревоОтчетов();
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ОбработкаОжиданияДеревоОтчетовИВариантовПриАктивизацииСтроки()
	ТекущиеДанные = Элементы.ДеревоОтчетовИВариантов.ТекущиеДанные; 
	
	// Кешируем значения КлючаВарианта, имени отчета и необходимости показывать привью отчета
	Если ТекущиеДанные = Неопределено тогда
		// если нет строк
		ТекКлючВарианта = "";
		ТекИмяОтчета = "";
		ТекОтображатьСнимок = Ложь;	
		
	ИначеЕсли ТекущиеДанные.ПолучитьРодителя() = Неопределено И (НЕ НеОтображатьИерархию) Тогда
		//Отчет
		ТекКлючВарианта = "";
		ТекИмяОтчета = "";
		ТекОтображатьСнимок = Ложь;
		
	Иначе
		//Вариант отчета
		ТекКлючВарианта = ТекущиеДанные.КлючВарианта;
		ТекИмяОтчета = ТекущиеДанные.ИмяОтчета;
		ТекОтображатьСнимок = Истина;
		
	КонеЦесли;
	
	ПоказатьСнимокОтчета(ТекИмяОтчета,ТекКлючВарианта,ТекОтображатьСнимок);

КонецПроцедуры

&НаСервере
Процедура ПоказатьСнимокОтчета(ИмяОтчета, КлючВарианта, ОтображатьСнимок)
	
	ВариантОтчета = НастройкиВариантовОтчетовДокументооборот.ПолучитьНастройкуВариантаОтчета(ИмяОтчета, КлючВарианта);
	
	Если (Не ОтображатьСнимок) Или (ВариантОтчета = Неопределено)  Тогда
		КартинкаОтчета = "";
		Возврат;
	КонецЕсли;
	
	ХранилищеСнимок = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ВариантОтчета, "ХранилищеСнимокОтчета");
	ДвоичныеДанные = ХранилищеСнимок.Получить();
	
	ЕстьКартинка = ЗначениеЗаполнено(ДвоичныеДанные);
	
	Если НЕ ВариантОтчета.Пустая()И ЕстьКартинка Тогда
		
		КартинкаОтчета = ПолучитьНавигационнуюСсылку(ВариантОтчета.Ссылка, "ХранилищеСнимокОтчета");
			
	Иначе
		КартинкаОтчета = "";
			
	Конецесли;
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьДеревоОтчетов()
	
	Дерево = РеквизитФормыВЗначение("ДеревоОтчетовИВариантов");
	Дерево.Строки.Очистить();
		
	ТекстЗапроса = "
			|ВЫБРАТЬ РАЗРЕШЕННЫЕ РАЗЛИЧНЫЕ
			|&ПараметрКатегория
			| 
			|	НастройкиВариантовОтчетовДокументооборот.Наименование КАК Наименование,
			|	НастройкиВариантовОтчетовДокументооборот.КлючВарианта КАК КлючВарианта,
			|	НЕ НастройкиВариантовОтчетовДокументооборот.Пользовательский КАК Предопределенный,
			|	НастройкиВариантовОтчетовДокументооборот.Отчет
			|ИЗ
			|	Справочник.НастройкиВариантовОтчетовДокументооборот КАК НастройкиВариантовОтчетовДокументооборот
			|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.КатегорииОтчетов КАК КатегорииОтчетов
			|		ПО (НЕ КатегорииОтчетов.ИспользоватьДляКонтекстныхОтчетов)
			|			И (НЕ КатегорииОтчетов.ПометкаУдаления)
			|			И НастройкиВариантовОтчетовДокументооборот.Категории.Категория = КатегорииОтчетов.Ссылка
			|ГДЕ
			|	НЕ НастройкиВариантовОтчетовДокументооборот.ПометкаУдаления
			|	И НЕ НастройкиВариантовОтчетовДокументооборот.Вспомогательный
			|	И (НЕ НастройкиВариантовОтчетовДокументооборот.ТолькоДляАвтора
			|			ИЛИ НастройкиВариантовОтчетовДокументооборот.Автор = &ТекущийПользователь)
			|	И НЕ КатегорииОтчетов.Ссылка ЕСТЬ NULL";
	
	Если Не СписокКатегорий.Количество() = 0 Тогда
		ТекстЗапроса = ТекстЗапроса + " 
			|И НастройкиВариантовОтчетовДокументооборот.Категории.Категория В(&СписокКатегорий)";
	КонецЕсли;

	
	Если ЗначениеЗаполнено(Раздел) Тогда
		ТекстЗапроса = ТекстЗапроса + " 
			|И НастройкиВариантовОтчетовДокументооборот.Размещение.Раздел = &Раздел";
	КонецЕсли;
	
	ТекстЗапроса = ТекстЗапроса + " 
			|	 УПОРЯДОЧИТЬ ПО
			|		&ПорядокКатегория
			|	 	НастройкиВариантовОтчетовДокументооборот.Наименование";
			
			
	Если НеОтображатьИерархию Тогда
		ТекстЗапроса = ТекстЗапроса + " 
			|ИТОГИ ПО
			|	Общие
			|	";
	Иначе
		 ТекстЗапроса = ТекстЗапроса + " 
			|ИТОГИ ПО
			|	Категория
			|	";
		
	КонецЕсли;

	Если НеОтображатьИерархию Тогда
		
		ПараметрКатегория = "";
		ПорядокКатегория = "";
		
	Иначе
		
		ПараметрКатегория = "КатегорииОтчетов.Ссылка КАК Категория,";
		ПорядокКатегория = "КатегорииОтчетов.Наименование,";
		
	Конецесли;

	ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "&ПараметрКатегория", ПараметрКатегория);
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "&ПорядокКатегория", ПорядокКатегория);

	
	ЗапросПоВариантам = Новый Запрос;
	ЗапросПоВариантам.Текст = ТекстЗапроса;
	
	ЗапросПоВариантам.УстановитьПараметр("ТекущийПользователь", 
							ПользователиКлиентСервер.ТекущийПользователь());
	ЗапросПоВариантам.УстановитьПараметр("СписокКатегорий", СписокКатегорий);
	
	Если ЗначениеЗаполнено(Раздел) Тогда
		
		Если ТипЗнч(Раздел) = Тип("Строка") Тогда
			
			Подсистема = Метаданные.Подсистемы.Найти(Раздел);
			ОтборРаздел = ОбщегоНазначения.ИдентификаторОбъектаМетаданных(Подсистема);
			
		Иначе
			
			ОтборРаздел = Раздел;
		
		КонецЕсли;
	
		ЗапросПоВариантам.УстановитьПараметр("Раздел", ОтборРаздел);
		
	КонецЕсли;
	
	ВыборкаКатегории = ЗапросПоВариантам.Выполнить().Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
	
	Пока ВыборкаКатегории.Следующий() Цикл
		
		ВыборкаВариантОтчета = ВыборкаКатегории.Выбрать();
		
		// Добавляем Категорию
		Если НЕ НеОтображатьИерархию Тогда
			
			ВетвьОтчет = Дерево.Строки.Добавить();
			ВетвьОтчет.КлючВарианта = "";
			ВетвьОтчет.ИндексКартинки = 100;
		КонецЕсли;
		
		Пока ВыборкаВариантОтчета.Следующий() Цикл
			
			Эл = Метаданные.Отчеты.Найти(ВыборкаВариантОтчета.Отчет.Имя);
			// Проверяем права доступа на отчет
			Если (Эл =Неопределено) ИЛИ (НЕ ПравоДоступа("Использование", Эл)) Тогда
				Продолжить;
			КонецЕсли;

			Если НЕ НеОтображатьИерархию Тогда
				Строка = ВетвьОтчет.Строки.Добавить();
								
			Иначе
				Строка = Дерево.Строки.Добавить();
								
			КонецЕсли;
			
			Строка.Синоним = ВыборкаВариантОтчета.Наименование;
			Строка.КлючВарианта = ВыборкаВариантОтчета.КлючВарианта;
			Строка.ИмяОтчета = ВыборкаВариантОтчета.Отчет.Имя;
			Строка.ИндексКартинки = ?(ВыборкаВариантОтчета.Предопределенный = Истина, 2, 1);
			
		КонецЦикла;
		
		Если НЕ НеОтображатьИерархию  И ЗначениеЗаполнено(ВыборкаКатегории.Категория)  Тогда
			
			ВетвьОтчет.Синоним = ВыборкаКатегории.Категория.Наименование + 
									" (" + Строка(ВетвьОтчет.Строки.Количество()) + ")";
									
		КонецЕсли;

	КонецЦикла;
		
	ЗначениеВДанныеФормы(Дерево, ДеревоОтчетовИВариантов);
	Дерево = новый ДеревоЗначений();
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьОтчетВыполнить()
	
	ТекущиеДанные = Элементы.ДеревоОтчетовИВариантов.ТекущиеДанные;
	Если ТекущиеДанные.ПолучитьРодителя() <> Неопределено Или НеОтображатьИерархию Тогда
		
		ПараметрыФормы = Новый Структура;
		ПараметрыФормы.Вставить("КлючВарианта", ТекущиеДанные.КлючВарианта);
		ПараметрыФормы.Вставить("СформироватьПриОткрытии", Истина);
		
		ИмяФормыОтчета = "Отчет." + ТекущиеДанные.ИмяОтчета + ".ФормаОбъекта";
		ОткрытьФорму(ИмяФормыОтчета, ПараметрыФормы, , ИмяФормыОтчета + ТекущиеДанные.КлючВарианта);
		
	Иначе
		
		ПоказатьПредупреждение(, НСтр("ru = 'Выберите какой-либо вариант отчета!'"));
		
	КонецЕсли;
	
КонецПроцедуры	

&НаСервере
Процедура ЗаписатьНастройкиДереваКатегорий(КлючОбъектаНастроек, КлючВарианта, КатегорияСиноним)
	
	ХранилищеНастроекДанныхФорм.Сохранить(КлючОбъектаНастроек, "КлючВарианта", КлючВарианта);	
	ХранилищеНастроекДанныхФорм.Сохранить(КлючОбъектаНастроек, "КатегорияСиноним", КатегорияСиноним);

КонецПроцедуры

&НаСервере
Функция НеДостаточноВариантовДляГруппировки()
	
	Запрос = Новый Запрос();
	ТекстЗапроса= "
			|ВЫБРАТЬ РАЗРЕШЕННЫЕ РАЗЛИЧНЫЕ
			|	НастройкиВариантовОтчетовДокументооборот.КлючВарианта КАК КлючВарианта,
			|	НастройкиВариантовОтчетовДокументооборот.Отчет КАК Отчет
			|ИЗ
			|	Справочник.НастройкиВариантовОтчетовДокументооборот КАК НастройкиВариантовОтчетовДокументооборот
			|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.КатегорииОтчетов КАК КатегорииОтчетов
			|		ПО (НЕ КатегорииОтчетов.ПометкаУдаления)
			|			И НастройкиВариантовОтчетовДокументооборот.Категории.Категория = КатегорииОтчетов.Ссылка
			|ГДЕ
			|	НЕ НастройкиВариантовОтчетовДокументооборот.ПометкаУдаления
			|	И (НЕ НастройкиВариантовОтчетовДокументооборот.ТолькоДляАвтора
			|			ИЛИ НастройкиВариантовОтчетовДокументооборот.Автор = &ТекущийПользователь)
			|	И НЕ КатегорииОтчетов.Ссылка ЕСТЬ NULL";

			
	Если Не СписокКатегорий.Количество() = 0 Тогда
		ТекстЗапроса = ТекстЗапроса + " 
			|И НастройкиВариантовОтчетовДокументооборот.Категории.Категория В(&СписокКатегорий)";
	КонецЕсли;
	
	
	Если ЗначениеЗаполнено(Раздел) Тогда
		ТекстЗапроса = ТекстЗапроса + " 
			|И НастройкиВариантовОтчетовДокументооборот.Размещение.Раздел = &Раздел";
	КонецЕсли;

	Запрос.Текст = ТекстЗапроса;
	
	Запрос.УстановитьПараметр("ТекущийПользователь", 
									ПользователиКлиентСервер.ТекущийПользователь());
	Запрос.УстановитьПараметр("СписокКатегорий", СписокКатегорий);
	
	Если ЗначениеЗаполнено(Раздел) Тогда
		
		Если ТипЗнч(Раздел) = Тип("Строка") Тогда
			
			Подсистема = Метаданные.Подсистемы.Найти(Раздел);
			ОтборРаздел = ОбщегоНазначения.ИдентификаторОбъектаМетаданных(Подсистема); 
			
		Иначе
			
			ОтборРаздел = Раздел;
		
		КонецЕсли;
	
		Запрос.УстановитьПараметр("Раздел",	ОтборРаздел);
		
	КонецЕсли;
	
	Выборка = Запрос.Выполнить().Выбрать();

	Кол = 0;
	
	Пока Выборка.Следующий() Цикл
		
		Эл = Метаданные.Отчеты.Найти(Выборка.Отчет.Имя);
		// Проверяем права доступа на отчет
		Если (Эл = Неопределено) ИЛИ (НЕ ПравоДоступа("Использование", Эл)) Тогда
			Продолжить;
		КонецЕсли;
		Кол = Кол +1;
	КонецЦикла;
	
	// Если в дереве категорий получается больше 7 элементов, то строим дерево. Меньше не строим.
	Если Кол > 7 Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Возврат Истина;

КонецФункции

#КонецОбласти

