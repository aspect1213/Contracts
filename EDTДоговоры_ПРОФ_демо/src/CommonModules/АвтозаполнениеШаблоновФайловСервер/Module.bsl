
// Получает массив автозаполнений в файле
// Параметры:Файл - ссылка на объект файла
//			ФайлОснование - файл, на основании которого был создан Файл. Ссылка на шаблон файла.
//			ФактическийВладелецФайла - ссылка на владельца файла, на основании которого следует производить подстановку данных
// Возвращает:массив замен в формате "какое поле заменить"-"какую строку заменить"-"на что заменить"
Функция ПолучитьМассивАвтозаполненийШаблона(Файл, ФайлОснование, ФактическийВладелецФайла) Экспорт
	
	СтрокаОшибки = "";
	МассивДанныеЗамен = Новый Массив;
	Если ТипЗнч(ФактическийВладелецФайла) <> Тип("СправочникСсылка.ДоговорныеДокументы") Тогда 
		Возврат МассивДанныеЗамен;
	КонецЕсли;
	
	Запрос = Новый Запрос();
	Запрос.Текст = 
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	АвтозаполненияФайлов.ДанныеДляАвтозаполнения.(
		|		ТермДляЗамены,
		|		ЗаменяемаяСтрока,
		|		ЗначениеЗамены,
		|		ВыражениеОбработкиРезультатаЗамены,
		|		ФорматЗначенияЗамены,
		|		НомерКолонкиТабличнойЧасти
		|	)
		|ИЗ
		|	Справочник.ПравилаАвтозаполненияФайлов КАК АвтозаполненияФайлов
		|ГДЕ
		|	АвтозаполненияФайлов.ВладелецФайла = &ВладелецФайла
		|	И АвтозаполненияФайлов.ШаблонФайла = &ШаблонФайла";

	Запрос.УстановитьПараметр("ВладелецФайла", ФактическийВладелецФайла.ВидДокумента);
	Запрос.УстановитьПараметр("ШаблонФайла", ФайлОснование);
	
	Результат = Запрос.Выполнить();
	ВыборкаДетальныеЗаписи = Результат.Выбрать();
	
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		ДанныеДляЗамены = ВыборкаДетальныеЗаписи.ДанныеДляАвтозаполнения.Выбрать();
		Пока ДанныеДляЗамены.Следующий() Цикл
			ДанныеВладельцаФайлаДляАвтозаполнения = Новый Структура(
				"ТермДляЗамены, ЗаменяемаяСтрока, ЗначениеЗамены, НомерКолонкиТабличнойЧасти");
			ДанныеВладельцаФайлаДляАвтозаполнения.ТермДляЗамены = ДанныеДляЗамены.ТермДляЗамены;
			ДанныеВладельцаФайлаДляАвтозаполнения.ЗаменяемаяСтрока = ДанныеДляЗамены.ЗаменяемаяСтрока;
			ДанныеВладельцаФайлаДляАвтозаполнения.НомерКолонкиТабличнойЧасти = 0;
			РезультатЗамены = ""; ТабличнаяЧасть = Ложь;
			Если Лев(ДанныеДляЗамены.ЗначениеЗамены, 1) = "{"
				И Прав(ДанныеДляЗамены.ЗначениеЗамены, 1) = "}"
				И Найти(ДанныеДляЗамены.ЗначениеЗамены, НСтр("ru = 'ТабличнаяЧасть'")) > 0 Тогда
				Попытка
					
					ЗначениеРеквизита = АвтозаполнениеШаблоновФайловСерверПовтИспВызов.ПолучитьЗначениеРеквизитаТабличнойЧастиДляАвтозаполнения(
						Файл.Ссылка, СтрЗаменить(СтрЗаменить(ДанныеДляЗамены.ЗначениеЗамены, "}", ""), "{", ""), ФактическийВладелецФайла);
						
					ТабличнаяЧасть = Истина;
					Если ЗначениеЗаполнено(ДанныеДляЗамены.ФорматЗначенияЗамены) Тогда
						Если ТипЗнч(ЗначениеРеквизита) = Тип("Массив") Тогда 
							Для Каждого ЗначениеМассива Из ЗначениеРеквизита Цикл 
								ЗначениеМассива.Значение = СокрЛП(Формат(ЗначениеМассива.Значение, 
									ДанныеДляЗамены.ФорматЗначенияЗамены));
							КонецЦикла;
							
							РезультатЗамены = ЗначениеРеквизита;
						Иначе 
							РезультатЗамены = СокрЛП(Формат(ЗначениеРеквизита, ДанныеДляЗамены.ФорматЗначенияЗамены));
						КонецЕсли;
					Иначе
						Если ТипЗнч(ЗначениеРеквизита) = Тип("Массив") Тогда 
							Для Каждого ЗначениеМассива Из ЗначениеРеквизита Цикл 
								ЗначениеМассива.Значение = СокрЛП(ЗначениеМассива.Значение);
							КонецЦикла;
							
							РезультатЗамены = ЗначениеРеквизита;
						Иначе 
							РезультатЗамены = СокрЛП(ЗначениеРеквизита);
						КонецЕсли;
						
						РезультатЗамены = ЗначениеРеквизита;
					КонецЕсли;
					
					ДанныеВладельцаФайлаДляАвтозаполнения.НомерКолонкиТабличнойЧасти = ДанныеДляЗамены.НомерКолонкиТабличнойЧасти;
				Исключение
					ОшибкаИнфо = ИнформацияОбОшибке();
					Если ОшибкаИнфо.Описание = "ОшибкаДоступаКРеквизиту" Тогда
						СтрокаОшибки = СтрокаОшибки + ДанныеДляЗамены + Символы.ВК;
					Иначе
						ВызватьИсключение(ОшибкаИнфо.Описание);
					КонецЕсли;
				КонецПопытки;
				
			ИначеЕсли Лев(ДанныеДляЗамены.ЗначениеЗамены, 1) = "{"
				И Прав(ДанныеДляЗамены.ЗначениеЗамены, 1) = "}"
				И Найти(ДанныеДляЗамены.ЗначениеЗамены, НСтр("ru = 'ДопРеквизиты'")) = 0
				И Найти(ДанныеДляЗамены.ЗначениеЗамены, НСтр("ru = 'ДопСвойства'")) = 0
				И Найти(ДанныеДляЗамены.ЗначениеЗамены, НСтр("ru = 'КонтактнаяИнформация'")) = 0 Тогда
				Попытка
					// Реквизит "Получатель" введен искусственно, поэтому его определяем в особом порядке.
					ЗначениеРеквизита = АвтозаполнениеШаблоновФайловСерверПовтИспВызов.ПолучитьЗначениеРеквизитаДляАвтозаполнения(
						Файл.Ссылка, 
						СтрЗаменить(СтрЗаменить(ДанныеДляЗамены.ЗначениеЗамены, "}", ""),
						"{", ""), ФактическийВладелецФайла);
					
					Если ЗначениеЗаполнено(ДанныеДляЗамены.ФорматЗначенияЗамены) Тогда
						РезультатЗамены = Формат(ЗначениеРеквизита, ДанныеДляЗамены.ФорматЗначенияЗамены);
					Иначе
						РезультатЗамены = ЗначениеРеквизита;
					КонецЕсли;
				Исключение
					ОшибкаИнфо = ИнформацияОбОшибке();
					Если ОшибкаИнфо.Описание = "ОшибкаДоступаКРеквизиту" Тогда
						СтрокаОшибки = СтрокаОшибки + ДанныеДляЗамены + Символы.ВК;
					Иначе
						ВызватьИсключение(ОшибкаИнфо.Описание);
					КонецЕсли;
				КонецПопытки;
			ИначеЕсли Лев(ДанныеДляЗамены.ЗначениеЗамены, 1) = "{"
				И Прав(ДанныеДляЗамены.ЗначениеЗамены, 1) = "}"
				И (Найти(ДанныеДляЗамены.ЗначениеЗамены, НСтр("ru = 'ДопРеквизиты'")) > 0
				ИЛИ Найти(ДанныеДляЗамены.ЗначениеЗамены, НСтр("ru = 'ДопСвойства'")) > 0) Тогда
				
				ЗначениеДопРеквизита = АвтозаполнениеШаблоновФайловСерверПовтИспВызов.ПолучитьЗначениеДопРеквизитаДляЗамены(Файл.Ссылка,
					СтрЗаменить(СтрЗаменить(ДанныеДляЗамены.ЗначениеЗамены, "}", ""), "{", ""),
					ФактическийВладелецФайла);
					
				Если ЗначениеЗаполнено(ДанныеДляЗамены.ФорматЗначенияЗамены) Тогда
					Если ТипЗнч(ЗначениеДопРеквизита) = Тип("Массив") Тогда 
						Для Каждого Элемент Из ЗначениеДопРеквизита Цикл 
							Элемент.Значение = Формат(Элемент.Значение, ДанныеДляЗамены.ФорматЗначенияЗамены);
						КонецЦикла;
					Иначе 
						РезультатЗамены = Формат(ЗначениеДопРеквизита, ДанныеДляЗамены.ФорматЗначенияЗамены);
					КонецЕсли;
				Иначе
					РезультатЗамены = ЗначениеДопРеквизита;
				КонецЕсли;
             ИначеЕсли Лев(ДанныеДляЗамены.ЗначениеЗамены, 1) = "{"
				И Прав(ДанныеДляЗамены.ЗначениеЗамены, 1) = "}"
				И Найти(ДанныеДляЗамены.ЗначениеЗамены, НСтр("ru = 'КонтактнаяИнформация'")) > 0 Тогда
				
				ЗначениеДопРеквизита = АвтозаполнениеШаблоновФайловСерверПовтИспВызов.ПолучитьЗначениеКонтактнойИнформацииДляЗамены(Файл.Ссылка,
					СтрЗаменить(СтрЗаменить(ДанныеДляЗамены.ЗначениеЗамены, "}", ""), "{", ""),
					ФактическийВладелецФайла);
					
				Если ЗначениеЗаполнено(ДанныеДляЗамены.ФорматЗначенияЗамены) Тогда
					РезультатЗамены = Формат(ЗначениеДопРеквизита, ДанныеДляЗамены.ФорматЗначенияЗамены);
				Иначе
					РезультатЗамены = ЗначениеДопРеквизита;
				КонецЕсли;
			ИначеЕсли ЗначениеЗаполнено(ДанныеДляЗамены.ЗначениеЗамены) Тогда
				РезультатЗамены = ДанныеДляЗамены.ЗначениеЗамены;
			Иначе
				РезультатОбработки = "";
				Выражение = СтрЗаменить(ДанныеДляЗамены.ВыражениеОбработкиРезультатаЗамены, "Файл.ВладелецФайла", "ФактическийВладелецФайла");
				Выполнить(Выражение);
				РезультатЗамены = РезультатОбработки; 
			КонецЕсли;
			
			Если ЗначениеЗаполнено(ДанныеДляЗамены.ВыражениеОбработкиРезультатаЗамены)
				И ЗначениеЗаполнено(ДанныеДляЗамены.ЗначениеЗамены) Тогда
				Попытка
					УстановитьБезопасныйРежим(Истина);
					РезультатОбработки = "";
					Выражение = СтрЗаменить(ДанныеДляЗамены.ВыражениеОбработкиРезультатаЗамены, "Файл.ВладелецФайла", "ФактическийВладелецФайла");
					Выполнить(Выражение);
					ДанныеВладельцаФайлаДляАвтозаполнения.ЗначениеЗамены = Строка(РезультатОбработки);
					УстановитьБезопасныйРежим(Ложь);
				Исключение
					ДанныеВладельцаФайлаДляАвтозаполнения.ЗначениеЗамены = "";
				КонецПопытки;
			ИначеЕсли ТабличнаяЧасть Тогда 
				ДанныеВладельцаФайлаДляАвтозаполнения.ЗначениеЗамены = РезультатЗамены;
			Иначе
				ДанныеВладельцаФайлаДляАвтозаполнения.ЗначениеЗамены = Строка(РезультатЗамены);
			КонецЕсли;
			
			МассивДанныеЗамен.Добавить(ДанныеВладельцаФайлаДляАвтозаполнения);
		КонецЦикла;
	КонецЦикла;
		
	Если НЕ ПустаяСтрока(СтрокаОшибки) Тогда
		СтрокаОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Следующие реквизиты правила автозаполнения заданы некорректно:
				|%1'"), СтрокаОшибки);
		ВызватьИсключение СтрокаОшибки;
	КонецЕсли;
	
	Возврат МассивДанныеЗамен;
	
КонецФункции

// Выполняет файл с использованием настроек замены
// Параметры:Файл - ссылка на заполняемый файл
//			МассивДанныхДляАвтоЗамен - массив настроек замен
//			ОбновитьВерсиюЗаполненнымФайлом - необходимость обновить версию файла после заполнения файла данными. Если Истина, то 
//					после автозаполнения в текущую версию файла запишется измененный файл. Если Ложь, то
//					после автозаполнения текущая версия файла не изменяется, функция вернет только 
//					путь к измененному (заполненному) файлу на диске.
// Возвращает:Если СохранятьВерсию = Истина, то ПустаяСтрока
//			 Если СохранятьВерсию = Ложь, то путь к измененному файлу на диске
Функция ВыполнитьАвтоЗаполнениеШаблона(Файл, МассивДанныхДляАвтоЗамен, НастройкиАвтозаполнения) Экспорт	
		
	МассивЗамен = НастройкиАвтозаполнения.МассивЗамен; 
	РасширениеФайла = НастройкиАвтозаполнения.РасширениеФайла;
	ДвоичныеДанныеФайла = НастройкиАвтозаполнения.ДвоичныеДанныеФайла;
    ЗаполнятьMSWordНаСервере = НастройкиАвтозаполнения.ВыполнятьЗаполнениеMSWordНаСервере;
	
	Если ДвоичныеДанныеФайла.Размер() = 0 Тогда
		Возврат Неопределено; 
	КонецЕсли;
		
	Если РасширениеФайла = "doc" И ЗаполнятьMSWordНаСервере Тогда
		ДвоичныеДанныеЗаполненногоФайла = АвтозаполнениеШаблоновФайловКлиентСервер.ЗаполнитьФайлMSWordПоДвоичнымДанным(РасширениеФайла, 
			МассивДанныхДляАвтоЗамен, 
			ДвоичныеДанныеФайла);
	ИначеЕсли АвтозаполнениеШаблоновФайловКлиентСервер.ТекстовыйФормат(РасширениеФайла) Тогда 
		ДвоичныеДанныеЗаполненногоФайла = АвтозаполнениеШаблоновФайловКлиентСервер.ЗаполнитьТекстовыйФайл(ДвоичныеДанныеФайла, РасширениеФайла, МассивДанныхДляАвтоЗамен);
	ИначеЕсли РасширениеФайла = "docx" Тогда
		Попытка
			ДвоичныеДанныеЗаполненногоФайла = АвтозаполнениеШаблоновФайловКлиентСервер.ЗаполнитьФайлMSWordВXML(ДвоичныеДанныеФайла, 
				РасширениеФайла, 
				МассивДанныхДляАвтоЗамен,
				Ложь);
		Исключение
			ДвоичныеДанныеЗаполненногоФайла = АвтозаполнениеШаблоновФайловКлиентСервер.ЗаполнитьФайлMSWordВXML(ДвоичныеДанныеФайла, 
				РасширениеФайла, 
				МассивДанныхДляАвтоЗамен,
				Истина);
		КонецПопытки;
	КонецЕсли;
	
	Возврат ДвоичныеДанныеЗаполненногоФайла;
	
КонецФункции

// Обновляет версию файла на основании двоичных данных
// Параметры:ДвоичныеДанные - двоичные данные файла
//			ВерсияСсылка - ссылка на версию объекта файл, которую необходимо обновить двоичными данными
Процедура ОбновитьВерсиюИзДвоичныхДанных(ДвоичныеДанные, Объект, КомментарийКНовойВерсии = "", УникальныйИдентификатор = Неопределено) Экспорт
	
	Если ТипЗнч(Объект) = Тип("СправочникСсылка.ВерсииФайлов") Тогда
		ВерсияСсылка = Объект;
	ИначеЕсли ТипЗнч(Объект) = Тип("СправочникСсылка.Файлы") Тогда 
		ВерсияСсылка = Объект.ТекущаяВерсия;
	КонецЕсли;
	
	ВременныйФайл = ПолучитьИмяВременногоФайла(ВерсияСсылка.Расширение);
	ДвоичныеДанные.Записать(ВременныйФайл);
	
	ХранЗначения = ЗагрузкаФайлов.ИзвлечьТекстВХранилищеЗначения(ВременныйФайл);
	Текст = ХранЗначения.Получить();
	ВременныйФайлТекст = ПолучитьИмяВременногоФайла("txt");
	ЗаписьТекста = Новый ЗаписьТекста(ВременныйФайлТекст);
	ЗаписьТекста.Записать(Текст);
	ЗаписьТекста.Закрыть();
	ДвоичныеДанныеТекста = Новый ДвоичныеДанные(ВременныйФайлТекст);
	
	СведенияОФайле = РаботаСФайламиКлиентСервер.СведенияОФайле("ФайлСВерсией");
	СведенияОФайле.ИмяБезРасширения = ВерсияСсылка.ПолноеНаименование;
	СведенияОФайле.Комментарий = КомментарийКНовойВерсии;
	СведенияОФайле.АдресВременногоХранилищаФайла = ПоместитьВоВременноеХранилище(ДвоичныеДанные);
	СведенияОФайле.АдресВременногоХранилищаТекста = ПоместитьВоВременноеХранилище(ДвоичныеДанныеТекста);
	СведенияОФайле.РасширениеБезТочки = ВерсияСсылка.Расширение;
	СведенияОФайле.ВремяИзменения = ТекущаяДата();
	СведенияОФайле.ВремяИзмененияУниверсальное = ТекущаяУниверсальнаяДата();
	СведенияОФайле.Размер = ДвоичныеДанные.Размер();
	СведенияОФайле.ХранитьВерсии = ВерсияСсылка.Владелец.ХранитьВерсии;
	
	ВерсияСсылка = РаботаСФайламиВызовСервера.ОбновитьВерсиюФайла(
		ВерсияСсылка.Владелец, СведенияОФайле, ВерсияСсылка, УникальныйИдентификатор);
	
	Если ТипЗнч(ВерсияСсылка) = Тип("СправочникСсылка.ВерсииФайлов") Тогда
    	РаботаСФайламиВызовСервера.ОбновитьВерсиюВФайле(ВерсияСсылка.Владелец, ВерсияСсылка, Неопределено, УникальныйИдентификатор);
	КонецЕсли;	
	
	УдалитьФайлы(ВременныйФайл);
	 
КонецПроцедуры

// Возвращает двоичные данные файла
// Параметры:Файл - ссылка на файл, двоичные данные которого необходимо получить
Функция ПолучитьДвоичныеДанныеФайла(Файл) Экспорт
	
	ТекущаяВерсия = Файл.ТекущаяВерсия.ПолучитьОбъект();	
	Если ТекущаяВерсия.ТипХраненияФайла = Перечисления.ТипыХраненияФайлов.ВТомахНаДиске Тогда
    	Если НЕ ТекущаяВерсия.Том.Пустая() Тогда
        	ПолныйПуть = ФайловыеФункции.ПолныйПутьТома(ТекущаяВерсия.Том) + ТекущаяВерсия.ПутьКФайлу; 
            Попытка
            	ДвоичныеДанныеФайла = Новый ДвоичныеДанные(ПолныйПуть);
			Исключение
				ТекстИсключения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
					НСтр("ru = 'Ошибка получения данных файла ""%1"".'"),
					Файл.Наименование);
				ВызватьИсключение ТекстИсключения;
			КонецПопытки;
		Иначе
			ТекстИсключения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Ошибка получения данных файла ""%1"".'"), 
				Файл.Наименование);
			ВызватьИсключение ТекстИсключения;
		КонецЕсли;
	ИначеЕсли ТекущаяВерсия.ТипХраненияФайла = Перечисления.ТипыХраненияФайлов.ВИнформационнойБазе
		ИЛИ НЕ ЗначениеЗаполнено(ТекущаяВерсия.ТипХраненияФайла) Тогда
		
		ХранилищеФайла = РаботаСФайламиВызовСервера.ПолучитьХранилищеФайлаИзИнформационнойБазы(ТекущаяВерсия.Ссылка);
		ДвоичныеДанныеФайла = ХранилищеФайла.Получить();
		
	Иначе
		ТекстИсключения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Ошибка получения данных файла ""%1"".'"), 
			Файл.Наименование);
		ВызватьИсключение ТекстИсключения;
	КонецЕсли;
	
	Возврат ДвоичныеДанныеФайла;
	
КонецФункции

// Получает настройки, связанные с автозаполнением файлов
// Параметры:
//			ФайлСсылка - ссылка на объект типа Файл
//			Документ - ссылка на Вн, Вх или Исх документ - владелец файла
// Возвращает:
//			Структура
//				ДвоичныеДанныеФайла - двоичные данные последней версии файла
//				РасширениеФайла - расширение последней версии файла
//				ВыполнятьЗаполнениеMSWordНаСервере - флаг, показывающий, где выполняется заполнение файлов формата MSWord
//				МассивЗамен - массив структур в формате "какое поле заменить"-"какую строку заменить"-"на что заменить"
//				ОснованиеСозданияФайла - ссылка на файл-шаблон, если параметр ФайлСсылка был создан из шаблона	
Функция ПолучитьНастройкиАвтозаполненияШаблоновФайлов(ФайлСсылка, Документ = Неопределено, ПолучитьДанныеОШтрихкоде = Ложь) Экспорт
	
	ДвоичныеДанныеФайла = ПолучитьДвоичныеДанныеФайла(ФайлСсылка);
	РасширениеФайла = НРег(ФайлСсылка.ТекущаяВерсияРасширение);
	ВыполнятьЗаполнениеMSWordНаСервере = Константы.ИзменениеФайловMSWordТолькоНаСервере.Получить();
	Если АвтозаполнениеШаблоновФайловСервер.ФайлНаходитсяВИерархииПапокШаблонов(ФайлСсылка) Тогда
		ОснованиеФайла = ФайлСсылка
	Иначе
		ОснованиеФайла = ФайлСсылка.ШаблонОснованиеДляСоздания;
	КонецЕсли;
		
	МассивЗамен = АвтозаполнениеШаблоновФайловСервер.ПолучитьМассивАвтозаполненийШаблона(
		ФайлСсылка,
		ОснованиеФайла, 
		?(Документ = Неопределено, ФайлСсылка.ВладелецФайла, Документ));
	ОснованиеСозданияФайла = ФайлСсылка.ШаблонОснованиеДляСоздания;
	
	ДанныеВозврата = Новый Структура;
	ДанныеВозврата.Вставить("ДвоичныеДанныеФайла", ДвоичныеДанныеФайла);
	ДанныеВозврата.Вставить("РасширениеФайла", РасширениеФайла);
	ДанныеВозврата.Вставить("ВыполнятьЗаполнениеMSWordНаСервере", ВыполнятьЗаполнениеMSWordНаСервере);
	ДанныеВозврата.Вставить("МассивЗамен", МассивЗамен);
	ДанныеВозврата.Вставить("ОснованиеСозданияФайла", ОснованиеСозданияФайла);
	
	Возврат ДанныеВозврата;
	
КонецФункции

// Проверяет, что файл находится в папке "Шаблоны файлов" или во вложенной в нее папке
// Результат (Булево) - файл находится в иерархии папки "Шаблоны файлов"
//
// Параметры: 
// - Файл (СправочникСсылка.Файлы)
//
Функция ФайлНаходитсяВИерархииПапокШаблонов(Файл) Экспорт
	
	Если ТипЗнч(Файл) <> Тип("СправочникСсылка.Файлы") Тогда
		Возврат Ложь;
	КонецЕсли;
	
	ВладелецФайла = Файл.ВладелецФайла;
	Если ТипЗнч(ВладелецФайла) <> Тип("СправочникСсылка.ВидыДокументов") Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Возврат Истина;
	
КонецФункции

// Получает признак того, редактируется файл или нет
Функция ФайлРедактируется(ФайлСсылка) Экспорт
	
	Возврат НЕ ФайлСсылка.Редактирует.Пустая();
	
КонецФункции

// Получает значение дополнительного реквизита объекта, если оно есть
Функция ПолучитьЗначениеДопРеквизитаОбъекта(Объект, ИмяРеквизита) Экспорт
	
	Результат = Неопределено;
	
	ТаблицаСвойств = УправлениеСвойствами.ПолучитьЗначенияСвойств(Объект);
	Для Каждого СтрокаТаблицы Из ТаблицаСвойств Цикл
		Если СтрокаТаблицы.Свойство.Заголовок = ИмяРеквизита Тогда
			Возврат СтрокаТаблицы.Значение;
		КонецЕсли;
	КонецЦикла;
	
	Возврат Результат;
	
КонецФункции

// Возвращает все таблицы файла формата MS Word 2007+
Функция ПолучитьВсеТаблицыФайлаOpenXML(ДвоичныеДанныеФайла, РасширениеФайла) Экспорт
	
	Результат = Новый Массив;
	
	СтарыйПутьКФайлу = ПолучитьИмяВременногоФайла(РасширениеФайла);
	ДвоичныеДанныеФайла.Записать(СтарыйПутьКФайлу);
	
	КопироватьФайл(СтарыйПутьКФайлу, СтрЗаменить(СтарыйПутьКФайлу, РасширениеФайла, "zip"));
	ИмяФайлаСПутемZIP = СтрЗаменить(СтарыйПутьКФайлу, РасширениеФайла, "zip");

	ВременнаяПапкаДляРазархивирования = ПолучитьИмяВременногоФайла("");
	ВременныйZIPФайл = ПолучитьИмяВременногоФайла("zip"); 

	Архив = Новый ЧтениеZipФайла();
	Архив.Открыть(ИмяФайлаСПутемZIP);
	Архив.ИзвлечьВсе(ВременнаяПапкаДляРазархивирования, РежимВосстановленияПутейФайловZIP.Восстанавливать);
	Архив.Закрыть();

	ЧтениеXML = Новый ЧтениеXML();
	
	Если РасширениеФайла = "docx" Тогда
		ЧтениеXML.ОткрытьФайл(ВременнаяПапкаДляРазархивирования + "/word/document.xml");		
		
		ПостроительDOM = Новый ПостроительDOM;
		ОбъектДокумент = ПостроительDOM.Прочитать(ЧтениеXML);	
		СчетчикТаблиц = 0;
		ВыражениеXPath = ОбъектДокумент.СоздатьВыражениеXPath("//w:tbl", Новый РазыменовательПространствИменDOM(ОбъектДокумент));

		РезультатXPath = ВыражениеXPath.Вычислить(ОбъектДокумент);
		УзелDOMТаблица = РезультатXPath.ПолучитьСледующий();
		Пока УзелDOMТаблица <> Неопределено Цикл
		    СчетчикТаблиц = СчетчикТаблиц + 1;
			Результат.Добавить("Таблица " + СчетчикТаблиц);
			УзелDOMТаблица = РезультатXPath.ПолучитьСледующий();
		КонецЦикла;
		ЧтениеXML.Закрыть();
	ИначеЕсли РасширениеФайла = "odt" Тогда			
		ЧтениеXML.ОткрытьФайл(ВременнаяПапкаДляРазархивирования + "/content.xml");		
		
		ПостроительDOM = Новый ПостроительDOM;
		ОбъектДокумент = ПостроительDOM.Прочитать(ЧтениеXML);	
		СчетчикТаблиц = 0;
		ВыражениеXPath = ОбъектДокумент.СоздатьВыражениеXPath("//table:table", Новый РазыменовательПространствИменDOM(ОбъектДокумент));

		РезультатXPath = ВыражениеXPath.Вычислить(ОбъектДокумент);
		УзелDOMТаблица = РезультатXPath.ПолучитьСледующий();
		Пока УзелDOMТаблица <> Неопределено Цикл
		    СчетчикТаблиц = СчетчикТаблиц + 1;
			Результат.Добавить("Таблица " + СчетчикТаблиц);
			УзелDOMТаблица = РезультатXPath.ПолучитьСледующий();
		КонецЦикла;
		ЧтениеXML.Закрыть();
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции
