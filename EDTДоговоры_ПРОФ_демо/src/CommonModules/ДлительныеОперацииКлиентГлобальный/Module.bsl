////////////////////////////////////////////////////////////////////////////////
// Подсистема "Базовая функциональность".
// Поддержка работы длительных серверных операций в веб-клиенте.
//  
////////////////////////////////////////////////////////////////////////////////

#Область СлужебныеПроцедурыИФункции

Процедура КонтрольДлительныхОпераций() Экспорт
	
	АктивныеДлительныеОперации = ДлительныеОперацииКлиент.АктивныеДлительныеОперации();
	Если АктивныеДлительныеОперации.Обработка Тогда
		Возврат;
	КонецЕсли;
	
	АктивныеДлительныеОперации.Обработка = Истина;
	Попытка
		ПроконтролироватьДлительныеОперации(АктивныеДлительныеОперации.Список);
		
		АктивныеДлительныеОперации.Обработка = Ложь;
	Исключение
		АктивныеДлительныеОперации.Обработка = Ложь;
		ВызватьИсключение;
	КонецПопытки;
	
КонецПроцедуры

Процедура ПроконтролироватьДлительныеОперации(АктивныеДлительныеОперации)
	
	ТекущаяДата = ОбщегоНазначенияКлиент.ДатаСеанса();
	
	КонтролируемыеОперации = Новый Соответствие;
	ЗаданияДляПроверки = Новый Массив;
	ЗаданияДляОтмены = Новый Массив;
	
	Для каждого ДлительнаяОперация Из АктивныеДлительныеОперации Цикл
		
		ДлительнаяОперация = ДлительнаяОперация.Значение;
		
		ОперацияОтменена = Ложь;
		Если ДлительнаяОперация.ФормаВладелец <> Неопределено И Не ДлительнаяОперация.ФормаВладелец.Открыта() Тогда
			ОперацияОтменена = Истина;
		КонецЕсли;
		Если ДлительнаяОперация.ОповещениеОЗавершении <> Неопределено И ТипЗнч(ДлительнаяОперация.ОповещениеОЗавершении.Модуль) = Тип("УправляемаяФорма") 
			И Не ДлительнаяОперация.ОповещениеОЗавершении.Модуль.Открыта() Тогда
			ОперацияОтменена = Истина;
		КонецЕсли;
		
		Если ОперацияОтменена Тогда
			
			КонтролируемыеОперации.Вставить(ДлительнаяОперация.ИдентификаторЗадания, ДлительнаяОперация);
			ЗаданияДляОтмены.Добавить(ДлительнаяОперация.ИдентификаторЗадания);
			
		ИначеЕсли ДлительнаяОперация.Контроль <= ТекущаяДата Тогда
			
			КонтролируемыеОперации.Вставить(ДлительнаяОперация.ИдентификаторЗадания, ДлительнаяОперация);
			
			ЗаданиеДляПроверки = Новый Структура("ИдентификаторЗадания,ВыводитьПрогрессВыполнения,ВыводитьСообщения");
			ЗаполнитьЗначенияСвойств(ЗаданиеДляПроверки, ДлительнаяОперация);
			ЗаданияДляПроверки.Добавить(ЗаданиеДляПроверки);
			
		КонецЕсли;
		
	КонецЦикла;
	
	Статусы = Новый Соответствие;
	Статусы = ДлительныеОперацииВызовСервера.ОперацииВыполнены(ЗаданияДляПроверки, ЗаданияДляОтмены);
	Для каждого СтатусОперации Из Статусы Цикл
		Операция = КонтролируемыеОперации[СтатусОперации.Ключ];
		Статус = СтатусОперации.Значение;
		Если ПроконтролироватьДлительнуюОперацию(Операция, Статус) Тогда
			АктивныеДлительныеОперации.Удалить(СтатусОперации.Ключ);
		КонецЕсли;
		
	КонецЦикла;

	Если АктивныеДлительныеОперации.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	ТекущаяДата = ОбщегоНазначенияКлиент.ДатаСеанса();
	Интервал = 120; 
	Для каждого Операция Из АктивныеДлительныеОперации Цикл
		Интервал = Мин(Интервал, Операция.Значение.Контроль - ТекущаяДата);
		ЕстьАктивныеОперации = Истина;
	КонецЦикла;
	
	ПодключитьОбработчикОжидания("КонтрольДлительныхОпераций", Интервал, Истина);
	
КонецПроцедуры

Функция ПроконтролироватьДлительнуюОперацию(ДлительнаяОперация, Статус)
	
	Если Статус.Статус <> "Отменено" И ДлительнаяОперация.ОповещениеОПрогрессеВыполнения <> Неопределено Тогда
		Прогресс = Новый Структура;
		Прогресс.Вставить("Статус", Статус.Статус);
		Прогресс.Вставить("ИдентификаторЗадания", ДлительнаяОперация.ИдентификаторЗадания);
		Прогресс.Вставить("Прогресс", Статус.Прогресс);
		Прогресс.Вставить("Сообщения", Статус.Сообщения);
		ВыполнитьОбработкуОповещения(ДлительнаяОперация.ОповещениеОПрогрессеВыполнения, Прогресс);
	КонецЕсли;
		
	Если Статус.Статус = "Выполнено" Тогда
		
		ПоказатьОповещение(ДлительнаяОперация);
		ВыполнитьОповещение(ДлительнаяОперация, Статус);
		Возврат Истина;
		
	ИначеЕсли Статус.Статус = "Ошибка" Тогда
		
		ВыполнитьОповещение(ДлительнаяОперация, Статус);
		Возврат Истина;
		
	ИначеЕсли Статус.Статус = "Отменено" Тогда
		
		Возврат Истина;
		
	КонецЕсли;
	
	ИнтервалОжидания = ДлительнаяОперация.ТекущийИнтервал;
	Если ДлительнаяОперация.Интервал = 0 Тогда
		ИнтервалОжидания = ИнтервалОжидания * 1.4;
		Если ИнтервалОжидания > 15 Тогда
			ИнтервалОжидания = 15;
		КонецЕсли;
		ДлительнаяОперация.ТекущийИнтервал = ИнтервалОжидания;
	КонецЕсли;
	ДлительнаяОперация.Контроль = ОбщегоНазначенияКлиент.ДатаСеанса() + ИнтервалОжидания;
	Возврат Ложь;
		
КонецФункции

Процедура ПоказатьОповещение(ДлительнаяОперация)
	
	Оповещение = ДлительнаяОперация.ОповещениеПользователя;
	Если Не Оповещение.Показать Тогда
		Возврат;
	КонецЕсли;
	
	ПоказатьОповещениеПользователя(?(Оповещение.Текст <> Неопределено, Оповещение.Текст, НСтр("ru = 'Действие выполнено'")), 
		Оповещение.НавигационнаяСсылка, Оповещение.Пояснение);

КонецПроцедуры

Процедура ВыполнитьОповещение(Знач ДлительнаяОперация, Знач Статус)
	
	Если ДлительнаяОперация.ОповещениеОЗавершении = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Результат = Новый Структура;
	Результат.Вставить("Статус",    Статус.Статус);
	Результат.Вставить("АдресРезультата", ДлительнаяОперация.АдресРезультата);
	Результат.Вставить("АдресДополнительногоРезультата", ДлительнаяОперация.АдресДополнительногоРезультата);
	Результат.Вставить("КраткоеПредставлениеОшибки", Статус.КраткоеПредставлениеОшибки);
	Результат.Вставить("ПодробноеПредставлениеОшибки", Статус.ПодробноеПредставлениеОшибки);
	ВыполнитьОбработкуОповещения(ДлительнаяОперация.ОповещениеОЗавершении, Результат);

КонецПроцедуры

#КонецОбласти
