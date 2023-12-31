////////////////////////////////////////////////////////////////////////////////
// Подсистема "Пользователи".
//
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Возвращает Истина если есть хотя бы один пользователь с ролью ПолныеПрава
Функция ЕстьАдминистратор() Экспорт
	
	ВсеПользователи = ПользователиИнформационнойБазы.ПолучитьПользователей();
	Для каждого Эл Из ВсеПользователи Цикл
		Роли = Эл.Роли;
		Если Роли.Содержит(Метаданные.Роли.ПолныеПрава) Тогда
			Возврат Истина;
		КонецЕсли;	
	КонецЦикла;	

	Возврат Ложь;
	
КонецФункции	

// ВОзвращает Истина если в базе нет ни одного пользователя
Функция ПользователейНет() Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ ПЕРВЫЕ 1
		|	Пользователи.Ссылка
		|ИЗ
		|	Справочник.Пользователи КАК Пользователи";
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	Если ВыборкаДетальныеЗаписи.Количество() = 0 Тогда
		Возврат Истина;
	Иначе
		Возврат Ложь;
	КонецЕсли;
	
КонецФункции

// Возвращает пользователей с ролью ПолныеПравы.
//
// Возвращаемое значение:
//  Массив - Администраторы системы.
//
Функция Администраторы() Экспорт
	
	АдминистраторыИБ = Новый Массив;
	ВсеПользователиИБ = ПользователиИнформационнойБазы.ПолучитьПользователей();
	Для каждого ПользовательИБ Из ВсеПользователиИБ Цикл
		Роли = ПользовательИБ.Роли;
		Если Роли.Содержит(Метаданные.Роли.ПолныеПрава) Тогда
			АдминистраторыИБ.Добавить(ПользовательИБ.УникальныйИдентификатор);
		КонецЕсли;
	КонецЦикла;
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	Пользователи.Ссылка КАК Ссылка
		|ИЗ
		|	Справочник.Пользователи КАК Пользователи
		|ГДЕ
		|	Пользователи.ИдентификаторПользователяИБ В (&АдминистраторыИБ)";
	Запрос.УстановитьПараметр("АдминистраторыИБ", АдминистраторыИБ);
	
	Возврат Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Ссылка");
	
КонецФункции

// По части наименования формирует список для выбора пользователей
// Параметры:
//		Текст - часть наименования, по которому выполняется поиск
// Возвращает:
//		СписокЗначений, содержащий ссылки на найденные по части наименования объекты
Функция СформироватьДанныеВыбораПользователя(Текст) Экспорт
	
	ДанныеВыбора = Новый СписокЗначений;
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	Пользователи.Ссылка КАК Ссылка,
	|	Пользователи.Должность КАК Должность
	|ИЗ
	|	Справочник.Пользователи КАК Пользователи
	|ГДЕ
	|	Пользователи.Наименование ПОДОБНО &Текст
	|	И Пользователи.Недействителен = ЛОЖЬ";
	
	Запрос.УстановитьПараметр("Текст", Текст + "%");
	
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		
		Если ЗначениеЗаполнено(Выборка.Должность) Тогда 
			ДобавкаТекст = "";
			ДобавкаТекст = СтрШаблон(НСтр("ru = ' (%1)'"), Строка(Выборка.Должность));
			ПредставлениеФорматированнаяСтрока = Новый ФорматированнаяСтрока(
				Строка(Выборка.Ссылка), 
				Новый ФорматированнаяСтрока(ДобавкаТекст, 
					, WebЦвета.Серый)
				);
			ДанныеВыбора.Добавить(Выборка.Ссылка, ПредставлениеФорматированнаяСтрока);
			
		Иначе
			
			ДанныеВыбора.Добавить(Выборка.Ссылка);
			
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат ДанныеВыбора;
	
КонецФункции	

#КонецОбласти