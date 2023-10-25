
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;

	// Оформление помеченных на удаление.
	ЭлементУсловногоОформления = УсловноеОформление.Элементы.Добавить();
	
	ЭлементЦветаОформления = ЭлементУсловногоОформления.Оформление.Элементы.Найти("TextColor");
	ЭлементЦветаОформления.Значение = Метаданные.ЭлементыСтиля.ТекстЗапрещеннойЯчейкиЦвет.Значение;
	ЭлементЦветаОформления.Использование = Истина;
	
	ЭлементОтбораДанных = ЭлементУсловногоОформления.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ЭлементОтбораДанных.ЛевоеЗначение  = Новый ПолеКомпоновкиДанных("Список.ПометкаУдаления");
	ЭлементОтбораДанных.ВидСравнения   = ВидСравненияКомпоновкиДанных.Равно;
	ЭлементОтбораДанных.ПравоеЗначение = Истина;
	ЭлементОтбораДанных.Использование  = Истина;
	
	ЭлементОформляемогоПоля = ЭлементУсловногоОформления.Поля.Элементы.Добавить();
	ЭлементОформляемогоПоля.Поле = Новый ПолеКомпоновкиДанных("Список");
	ЭлементОформляемогоПоля.Использование = Истина;
	
	Элементы.Автор.Видимость = ПолучитьФункциональнуюОпцию("ПоказыватьПользователей");
	
КонецПроцедуры

&НаКлиенте
Процедура СписокПередУдалением(Элемент, Отказ)
	
	ДанныеФайла = РаботаСФайламиВызовСервера.ДанныеФайла(Неопределено, Элементы.Список.ТекущаяСтрока);
	
	Если ДанныеФайла.ТекущаяВерсия = Элементы.Список.ТекущаяСтрока Тогда
		ПоказатьПредупреждение(, НСтр("ru = 'Активную версию нельзя удалить.'"));
		Отказ = Истина;
	КонецЕсли;	
		
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "ЗаконченоРедактирование" Или ИмяСобытия = "ВерсияСохранена" Тогда
		Элементы.Список.Обновить();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СписокПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа)
	Отказ = Истина;
КонецПроцедуры

&НаКлиенте
Процедура СписокВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	РаботаСФайламиКлиент.Открыть(
		РаботаСФайламиВызовСервера.ДанныеФайлаДляОткрытия(Неопределено, ВыбраннаяСтрока, УникальныйИдентификатор),
		УникальныйИдентификатор);
	
КонецПроцедуры

