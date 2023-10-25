
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	Если Не Пользователи.РолиДоступны("ИзменениеДополнительныхСведений") Тогда
		Элементы.ФормаЗаписать.Видимость = Ложь;
		Элементы.ФормаЗаписатьИЗакрыть.Видимость = Ложь;
	КонецЕсли;
	
	Если Не Пользователи.РолиДоступны("ДобавлениеИзменениеДополнительныхРеквизитовИСведений") Тогда
		Элементы.ИзменитьСоставДополнительныхСведений.Видимость = Ложь;
	КонецЕсли;
	
	СсылкаНаОбъект = Параметры.Ссылка;
	
	// Получение списка доступных наборов свойств.
	НаборыСвойств = УправлениеСвойствамиСлужебный.ПолучитьНаборыСвойствОбъекта(Параметры.Ссылка);
	Для каждого Строка Из НаборыСвойств Цикл
		ДоступныеНаборыСвойств.Добавить(Строка.Набор);
	КонецЦикла;
	
	// Заполнение таблицы значений свойств.
	ЗаполнитьТаблицуЗначенийСвойств(Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, СтандартнаяОбработка)
	
	Оповещение = Новый ОписаниеОповещения("ЗаписатьИЗакрытьЗавершение", ЭтотОбъект);
	ОбщегоНазначенияКлиент.ПоказатьПодтверждениеЗакрытияФормы(Оповещение, Отказ);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "Запись_НаборыДополнительныхРеквизитовИСведений" Тогда
		
		Если ДоступныеНаборыСвойств.НайтиПоЗначению(Источник) <> Неопределено Тогда
			ЗаполнитьТаблицуЗначенийСвойств(Ложь);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыТаблицаЗначенийСвойств

&НаКлиенте
Процедура ТаблицаЗначенийСвойствПриИзменении(Элемент)
	
	Модифицированность = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура ТаблицаЗначенийСвойствПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа)
	
	Отказ = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура ТаблицаЗначенийСвойствПередУдалением(Элемент, Отказ)
	
	Если Элемент.ТекущиеДанные.НомерКартинки = -1 Тогда
		Отказ = Истина;
		Элемент.ТекущиеДанные.Значение = Элемент.ТекущиеДанные.ТипЗначения.ПривестиЗначение(Неопределено);
		Модифицированность = Истина;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ТаблицаЗначенийСвойствПриНачалеРедактирования(Элемент, НоваяСтрока, Копирование)
	
	Элемент.ПодчиненныеЭлементы.ТаблицаЗначенийСвойствЗначение.ОграничениеТипа
		= Элемент.ТекущиеДанные.ТипЗначения;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Записать(Команда)
	
	ЗаписатьЗначенияСвойств();
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаписатьИЗакрыть(Команда)
	
	ЗаписатьИЗакрытьЗавершение();
	
КонецПроцедуры

&НаКлиенте
Процедура ИзменитьСоставДополнительныхСведений(Команда)
	
	Если ДоступныеНаборыСвойств.Количество() = 0
	 ИЛИ НЕ ЗначениеЗаполнено(ДоступныеНаборыСвойств[0].Значение) Тогда
		
		ПоказатьПредупреждение(,
			НСтр("ru = 'Не удалось получить наборы дополнительных сведений объекта.
			           |
			           |Возможно у объекта не заполнены необходимые реквизиты.'"));
	Иначе
		ПараметрыФормы = Новый Структура;
		ПараметрыФормы.Вставить("ПоказатьДополнительныеРеквизиты");
		
		ОткрытьФорму("Справочник.НаборыДополнительныхРеквизитовИСведений.ФормаСписка", ПараметрыФормы);
		
		ПараметрыПерехода = Новый Структура;
		ПараметрыПерехода.Вставить("Набор", ДоступныеНаборыСвойств[0].Значение);
		ПараметрыПерехода.Вставить("Свойство", Неопределено);
		ПараметрыПерехода.Вставить("ЭтоДополнительноеСведение", Истина);
		
		Если Элементы.ТаблицаЗначенийСвойств.ТекущиеДанные <> Неопределено Тогда
			ПараметрыПерехода.Вставить("Набор", Элементы.ТаблицаЗначенийСвойств.ТекущиеДанные.Набор);
			ПараметрыПерехода.Вставить("Свойство", Элементы.ТаблицаЗначенийСвойств.ТекущиеДанные.Свойство);
		КонецЕсли;
		
		Оповестить("Переход_НаборыДополнительныхРеквизитовИСведений", ПараметрыПерехода);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ЗаписатьИЗакрытьЗавершение(Результат = Неопределено, ДополнительныеПараметры = Неопределено) Экспорт
	
	ЗаписатьЗначенияСвойств();
	Модифицированность = Ложь;
	Закрыть();
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьТаблицуЗначенийСвойств(ИзОбработчикаПриСоздании)
	
	// Заполнение дерева значениями свойств.
	Если ИзОбработчикаПриСоздании Тогда
		ЗначенияСвойств = ПрочитатьЗначенияСвойствИзРегистраСведений();
	Иначе
		ЗначенияСвойств = ПолучитьТекущиеЗначенияСвойств();
		ТаблицаЗначенийСвойств.Очистить();
	КонецЕсли;
	
	Таблица = УправлениеСвойствамиСлужебный.ПолучитьТаблицуЗначенийСвойств(
		ЗначенияСвойств, ДоступныеНаборыСвойств, Истина);
	
	Для каждого Строка Из Таблица Цикл
		НоваяСтрока = ТаблицаЗначенийСвойств.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока, Строка);
		НоваяСтрока.НомерКартинки = ?(Строка.Удалено, 0, -1);
		
		Если Строка.Значение = Неопределено
			И ОбщегоНазначения.ОписаниеТипаСостоитИзТипа(Строка.ТипЗначения, Тип("Булево")) Тогда
			НоваяСтрока.Значение = Ложь;
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаписатьЗначенияСвойств()
	
	// Запись значений свойств в регистр сведений.
	ЗначенияСвойств = Новый Массив;
	
	Для каждого Строка Из ТаблицаЗначенийСвойств Цикл
		
		Если ЗначениеЗаполнено(Строка.Значение)
		  И (Строка.Значение <> Ложь) Тогда
			
			Значение = Новый Структура("Свойство, Значение", Строка.Свойство, Строка.Значение);
			ЗначенияСвойств.Добавить(Значение);
		КонецЕсли;
	КонецЦикла;
	
	ЗаписатьНаборСвойствВРегистр(СсылкаНаОбъект, ЗначенияСвойств);
	
	Модифицированность = Ложь;
	
КонецПроцедуры

&НаСервереБезКонтекста
Процедура ЗаписатьНаборСвойствВРегистр(Знач Ссылка, Знач ЗначенияСвойств)
	
	Набор = РегистрыСведений.ДополнительныеСведения.СоздатьНаборЗаписей();
	Набор.Отбор.Объект.Установить(Ссылка);
	
	Для каждого Строка Из ЗначенияСвойств Цикл
		Запись = Набор.Добавить();
		Запись.Свойство = Строка.Свойство;
		Запись.Значение = Строка.Значение;
		Запись.Объект   = Ссылка;
	КонецЦикла;
	
	Набор.Записать();
	
КонецПроцедуры

&НаСервере
Функция ПрочитатьЗначенияСвойствИзРегистраСведений()
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ДополнительныеСведения.Свойство,
	|	ДополнительныеСведения.Значение
	|ИЗ
	|	РегистрСведений.ДополнительныеСведения КАК ДополнительныеСведения
	|ГДЕ
	|	ДополнительныеСведения.Объект = &Объект";
	Запрос.УстановитьПараметр("Объект", Параметры.Ссылка);
	
	Возврат Запрос.Выполнить().Выгрузить();
	
КонецФункции

&НаСервере
Функция ПолучитьТекущиеЗначенияСвойств()
	
	ЗначенияСвойств = Новый ТаблицаЗначений;
	ЗначенияСвойств.Колонки.Добавить("Свойство");
	ЗначенияСвойств.Колонки.Добавить("Значение");
	
	Для каждого Строка Из ТаблицаЗначенийСвойств Цикл
		
		Если ЗначениеЗаполнено(Строка.Значение) И (Строка.Значение <> Ложь) Тогда
			НоваяСтрока = ЗначенияСвойств.Добавить();
			НоваяСтрока.Свойство = Строка.Свойство;
			НоваяСтрока.Значение = Строка.Значение;
		КонецЕсли;
	КонецЦикла;
	
	Возврат ЗначенияСвойств;
	
КонецФункции

#КонецОбласти
