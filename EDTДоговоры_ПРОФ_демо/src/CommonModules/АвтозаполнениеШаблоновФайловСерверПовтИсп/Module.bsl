
// Формирует дерево значений с реквизитами и доп. реквизитами документа указанного типа.
//
// Параметры:
//  ВидВладельцаФайла - СправочникСсылка.ВидыВнутреннихДокументов, СправочникСсылка.ВидыИсходящихДокументов - 
//						Текстовое описание параметра процедуры (функции).
//
// Возвращаемое значение:
//  ДеревоЗначений - дерево значений с реквизитами документа
//	 * Наименование - Строка - Имя реквизита.
//	 * Тип - Строка - Имя типа реквизита.
//	 * ОбъектРодитель - Строка - полный путь до элемента дерева реквизитов
Функция ЗаполнитьДеревоРеквизитовДляВыбора(ВидВладельцаФайла, ТипКонтрагента) Экспорт
	
	ИсключенияРеквизитов = Новый СписокЗначений;
	// Договорные документы
	ИсключенияРеквизитов.Добавить("ВидДокумента");
	ИсключенияРеквизитов.Добавить("Описание");
	ИсключенияРеквизитов.Добавить("ДатаСортировки");
	ИсключенияРеквизитов.Добавить("ДатаСоздания");
	ИсключенияРеквизитов.Добавить("НомерИДатаДокумента");
	ИсключенияРеквизитов.Добавить("Закрыт");
	ИсключенияРеквизитов.Добавить("СрокДействия");
	ИсключенияРеквизитов.Добавить("ЧисловойНомер");
	
	Если ВидВладельцаФайла.Тип = Перечисления.ТипыДоговорныхДокументов.Договор Тогда 
		ИсключенияРеквизитов.Добавить("Договор");
	КонецЕсли;
	
	// Ответственный
	ИсключенияРеквизитов.Добавить("ИдентификаторПользователяИБ");
	ИсключенияРеквизитов.Добавить("ИдентификаторПользователяСервиса");
	ИсключенияРеквизитов.Добавить("Комментарий");
	ИсключенияРеквизитов.Добавить("НавигационнаяСсылкаИнформационнойБазы");
	ИсключенияРеквизитов.Добавить("Недействителен");
	ИсключенияРеквизитов.Добавить("Подготовлен");
	ИсключенияРеквизитов.Добавить("Подразделение");
	ИсключенияРеквизитов.Добавить("Служебный");
	ИсключенияРеквизитов.Добавить("ФизическоеЛицо");
	ИсключенияРеквизитов.Добавить("СвойстваПользователяИБ");
	ИсключенияРеквизитов.Добавить("ИндексНумерации");
	
	// Контрагенты
	ИсключенияРеквизитов.Добавить("ЮридическоеФизическоеЛицо");
	ИсключенияРеквизитов.Добавить("ИНН");
	ИсключенияРеквизитов.Добавить("КПП");
	
	Типы = Новый ОписаниеТипов("Строка");
	ТипБулево = Новый ОписаниеТипов("Булево");
	КЧ = Новый КвалификаторыЧисла(10, 0);
	ТипЧисло = Новый ОписаниеТипов("Число",,, КЧ);
	КЧ1 = Новый КвалификаторыЧисла(1, 0);
	ТипЧисло1 = Новый ОписаниеТипов("Число",,, КЧ1);
	
	Дерево = Новый ДеревоЗначений;
	Дерево.Колонки.Добавить("Наименование", Типы);
	Дерево.Колонки.Добавить("Тип", Типы);
	Дерево.Колонки.Добавить("ОбъектРодитель", Типы);
	Дерево.Колонки.Добавить("Описание", Типы);
	Дерево.Колонки.Добавить("ОписаниеПоляЗамены", Типы);
	Дерево.Колонки.Добавить("РеквизитРодитель", Типы);
	
	Дерево.Колонки.Добавить("ПолеФайла", Типы);
	Дерево.Колонки.Добавить("СоздатьПоле", ТипБулево);
	Дерево.Колонки.Добавить("РеквизитТабличнойЧасти", ТипБулево);
	Дерево.Колонки.Добавить("ДополнительныйРеквизит", ТипБулево);
	Дерево.Колонки.Добавить("НомерКолонкиТабличнойЧасти", ТипЧисло);
	Дерево.Колонки.Добавить("ФорматСвойства", Типы);
	Дерево.Колонки.Добавить("КоличествоПолей", ТипЧисло1);
	
	СправочникОбъект = Метаданные.Справочники.ДоговорныеДокументы;
	ЗаполнитьДеревоРеквизитов(Дерево, СправочникОбъект.Реквизиты, "ВладелецФайла", 1, 
		ВидВладельцаФайла, ТипКонтрагента, ИсключенияРеквизитов);
	
	НоваяСтрокаСписок = Дерево.Строки.Добавить();
	НоваяСтрокаСписок.Наименование = "СписокТоваровИУслуг";
	НоваяСтрокаСписок.Описание = НСтр("ru = 'Список товаров и услуг'");
	НоваяСтрокаСписок.РеквизитТабличнойЧасти = Истина;
	
	ЗаполнитьДеревоРеквизитов(НоваяСтрокаСписок, СправочникОбъект.ТабличныеЧасти.Товары.Реквизиты, 
		"ВладелецФайла|ТабличнаяЧасть", 1, ВидВладельцаФайла, ТипКонтрагента, ИсключенияРеквизитов,, Истина);
	
	Попытка
		НаборСвойств = УправлениеСвойствамиСлужебный.ПолучитьНаборыСвойствОбъекта(ВидВладельцаФайла);
		
		Если НаборСвойств.Количество() > 0 Тогда  
			Для Каждого ЭлементНабораСвойств Из НаборСвойств Цикл
				Для Каждого ДопРеквизит Из ЭлементНабораСвойств.Набор.ДополнительныеРеквизиты Цикл
					Если ДопРеквизит <> Неопределено И ЗначениеЗаполнено(ДопРеквизит.Свойство) Тогда
						РеквизитыСвойства = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(ДопРеквизит.Свойство,
							"ПометкаУдаления, Заголовок, ТипЗначения, УникальныйКодДляПоля, ФорматСвойства");
						Если ДопРеквизит.ПометкаУдаления Или РеквизитыСвойства.ПометкаУдаления = Истина Тогда 
							Продолжить;
						КонецЕсли;
						
						НоваяСтрокаДопРеквизит = Дерево.Строки.Добавить();
						НоваяСтрокаДопРеквизит.Наименование = РеквизитыСвойства.УникальныйКодДляПоля;
						НоваяСтрокаДопРеквизит.Тип = РеквизитыСвойства.ТипЗначения;
						НоваяСтрокаДопРеквизит.ОбъектРодитель = "ВладелецФайла.ДопРеквизиты";
						НоваяСтрокаДопРеквизит.Описание = РеквизитыСвойства.Заголовок;
						НоваяСтрокаДопРеквизит.ОписаниеПоляЗамены = РеквизитыСвойства.Заголовок;
						НоваяСтрокаДопРеквизит.ДополнительныйРеквизит = Истина;
						НоваяСтрокаДопРеквизит.ФорматСвойства = РеквизитыСвойства.ФорматСвойства;
					КонецЕсли;
				КонецЦикла;
			КонецЦикла;
		КонецЕсли;
	Исключение
		// У владельца файла может не быть доп.реквизитов
	КонецПопытки;

	Возврат Дерево;
	
КонецФункции

Процедура ЗаполнитьДеревоРеквизитов(
	Родитель, 
	НаборРеквизитов, 
	Путь, 
	УровеньВложенности, 
	ВидВладельцаФайла,
	ТипКонтрагента,
	ИсключенияРеквизитов,
	Знач ТочечныеИсключения = Неопределено,
	РеквизитТабличнойЧасти = Ложь)
	
	Если УровеньВложенности > 2 Тогда
		Возврат;
	КонецЕсли;
	
	Для Каждого Реквизит Из НаборРеквизитов Цикл
		
		Если ТипЗнч(Реквизит) <> Тип("ОписаниеСтандартногоРеквизита") Тогда
			РеквизитВключен = Истина;
			РеквизитВходитВФункциональныеОпции = Ложь;
			
			Если ИсключенияРеквизитов.НайтиПоЗначению(Реквизит.Имя) <> Неопределено Тогда 
				Продолжить;
			КонецЕсли;
			
			Если ТочечныеИсключения <> Неопределено И 
				ТочечныеИсключения.НайтиПоЗначению(Реквизит.Имя) <> Неопределено Тогда 
				Продолжить;
			КонецЕсли;
			
			Для Каждого ФункциональнаяОпция Из Метаданные.ФункциональныеОпции Цикл
				Если ФункциональнаяОпция.Состав.Содержит(Реквизит) Тогда
					РеквизитВходитВФункциональныеОпции = Истина;
					РеквизитВключен = ПолучитьФункциональнуюОпцию(ФункциональнаяОпция.Имя);
					Если РеквизитВключен Тогда
						Прервать;
					КонецЕсли;
				КонецЕсли;
			КонецЦикла;
			
			Если РеквизитВходитВФункциональныеОпции И НЕ РеквизитВключен Тогда
				Продолжить;
			КонецЕсли;
		КонецЕсли;
		
		Строка = Родитель.Строки.Добавить();
		Строка.Наименование = Реквизит.Имя;
		Строка.Тип = Реквизит.Тип;
		Строка.ОбъектРодитель = Путь;
		Строка.РеквизитТабличнойЧасти = РеквизитТабличнойЧасти;
		
		Если Не РеквизитТабличнойЧасти Тогда 
			РеквизитРодитель = СтрЗаменить(Путь,"ВладелецФайла", "");
			РеквизитРодитель = СтрЗаменить(РеквизитРодитель, "|", "_");
			Строка.РеквизитРодитель = РеквизитРодитель;
			Если Лев(Строка.РеквизитРодитель, 1) = "_" Тогда 
				Строка.РеквизитРодитель = Прав(Строка.РеквизитРодитель, СтрДлина(Строка.РеквизитРодитель) - 1);
			КонецЕсли;
		Иначе 
			Строка.НомерКолонкиТабличнойЧасти = 10000;
			Строка.РеквизитРодитель = "ТЧ";
		КонецЕсли;
		
		Если Не ЗначениеЗаполнено(Реквизит.Синоним) Тогда 
			Строка.Описание = Реквизит.Имя;
		Иначе 
			Строка.Описание = Реквизит.Синоним;
		КонецЕсли;
		
		Если ЗначениеЗаполнено(Реквизит.Комментарий) Тогда 
			Строка.ОписаниеПоляЗамены = Реквизит.Комментарий;
		ИначеЕсли ЗначениеЗаполнено(Реквизит.Синоним) Тогда 
			Строка.ОписаниеПоляЗамены = Реквизит.Синоним;
		Иначе 
			Строка.ОписаниеПоляЗамены = Реквизит.Имя;
		КонецЕсли;
		
		Для Каждого СправочникОбъект Из Метаданные.Справочники Цикл
			
			Если СправочникОбъект.ПредставлениеОбъекта <> Строка(Реквизит.Тип) Тогда
				Продолжить;
			ИначеЕсли СправочникОбъект.Имя = "ВидыДокументов" Тогда
				Продолжить;
				
			ИначеЕсли СправочникОбъект.Имя = "Номенклатура" Тогда
				
				ТочечныеИсключения = Новый СписокЗначений;
				ТочечныеИсключения.Добавить("Цена");
				ТочечныеИсключения.Добавить("ЕдиницаИзмерения");
				ТочечныеИсключения.Добавить("СтавкаНДС");
				
			ИначеЕсли СправочникОбъект.Имя = "ДоговорныеДокументы" Тогда
				// Для групповых элементов удаляем тип
				Строка.Тип = Неопределено;
				
				ДобавитьСтроку(Строка, Путь, "ДатаДокумента", НСтр("ru = 'Дата договора'"),
					Тип("Дата"), РеквизитТабличнойЧасти);
					
				ДобавитьСтроку(Строка, Путь, "НомерДокумента", НСтр("ru = 'Номер договора'"),
					Тип("Строка"), РеквизитТабличнойЧасти);
				Продолжить;
				
			ИначеЕсли СправочникОбъект.Имя = "Пользователи" Тогда 
				// Для групповых элементов удаляем тип
				Строка.Тип = Неопределено;
				
				ДобавитьСтроку(Строка, Путь, "Наименование", НСтр("ru = 'Имя'"),
					Тип("Строка"), РеквизитТабличнойЧасти, НСтр("ru = 'Имя ответственного'"));
				
			ИначеЕсли СправочникОбъект.Имя = "Контрагенты" Тогда 
				// Для групповых элементов удаляем тип
				Строка.Тип = Неопределено;
				
				ТочечныеИсключения = Новый СписокЗначений;
				Если ТипКонтрагента = Перечисления.ЮридическоеФизическоеЛицо.ФизическоеЛицо Тогда 
					ТочечныеИсключения.Добавить("НаименованиеПолное");
					ТочечныеИсключения.Добавить("ДолжностьПодписывающего");
					ТочечныеИсключения.Добавить("ДействуетНаОсновании");
					ТочечныеИсключения.Добавить("ВЛице");
					
				ИначеЕсли ТипКонтрагента = Перечисления.ЮридическоеФизическоеЛицо.ИндивидуальныйПредприниматель Тогда 
					ТочечныеИсключения.Добавить("НаименованиеПолное");
					ТочечныеИсключения.Добавить("ДолжностьПодписывающего");
					ТочечныеИсключения.Добавить("ПаспортныеДанные");
					ТочечныеИсключения.Добавить("ВЛице");
					
				Иначе 
					
					ДобавитьСтроку(Строка, Путь, "Наименование", НСтр("ru = 'Сокращенное наименование'"),
						Тип("Строка"), РеквизитТабличнойЧасти, НСтр("ru = 'Сокращенное наименование контрагента'"));
					
					ТочечныеИсключения.Добавить("ПаспортныеДанные");
					ТочечныеИсключения.Добавить("ФИО");
					
				КонецЕсли;
			КонецЕсли;
			
			ЗаполнитьДеревоРеквизитов(Строка, СправочникОбъект.Реквизиты, Путь + "|" + Строка.Наименование,
				УровеньВложенности + 1, ВидВладельцаФайла, ТипКонтрагента, ИсключенияРеквизитов, ТочечныеИсключения, 
				РеквизитТабличнойЧасти);
			ТочечныеИсключения = Новый СписокЗначений;
			Попытка
				Если СправочникОбъект.ТабличныеЧасти.Найти("ДополнительныеРеквизиты") <> Неопределено Тогда
					Если СправочникОбъект.Имя = "Номенклатура" Тогда
						ЗаполнитьСписокДопРеквизитов(Родитель, СправочникОбъект, Путь + "|" + Реквизит.Имя, 
							ВидВладельцаФайла, РеквизитТабличнойЧасти);
					ИначеЕсли СправочникОбъект.Имя = "Контрагенты" Тогда
						ЗаполнитьСписокДопРеквизитов(Строка, СправочникОбъект, Путь + "|" + Реквизит.Имя, 
							ВидВладельцаФайла, РеквизитТабличнойЧасти, ТипКонтрагента);
					Иначе 
						ЗаполнитьСписокДопРеквизитов(Строка, СправочникОбъект, Путь + "|" + Реквизит.Имя, 
							ВидВладельцаФайла, РеквизитТабличнойЧасти);
					КонецЕсли;
				КонецЕсли;
			Исключение
				// У справочника может не быть ни одного настроенного доп.реквизита
			КонецПопытки;
			
			Прервать;
		КонецЦикла;
		
	КонецЦикла;
	
КонецПроцедуры

Процедура ДобавитьСтроку(Строка, Путь, Наименование, Описание, Тип, РеквизитТабличнойЧасти, ОписаниеПоляЗамены = "")
	
	НоваяСтрока = Строка.Строки.Добавить();
	НоваяСтрока.Наименование = Наименование;
	НоваяСтрока.Тип = Тип;
	НоваяСтрока.Описание = Описание;
	НоваяСтрока.ОбъектРодитель =  Путь + "|" + Строка.Наименование;
	НоваяСтрока.РеквизитТабличнойЧасти = РеквизитТабличнойЧасти;
	
	Если Не РеквизитТабличнойЧасти Тогда 
		РеквизитРодитель = СтрЗаменить(Путь + "|" + Строка.Наименование, "ВладелецФайла", "");
		РеквизитРодитель = СтрЗаменить(РеквизитРодитель, "|", "_");
		НоваяСтрока.РеквизитРодитель = РеквизитРодитель;
		Если Лев(НоваяСтрока.РеквизитРодитель, 1) = "_" Тогда 
			НоваяСтрока.РеквизитРодитель = Прав(НоваяСтрока.РеквизитРодитель, СтрДлина(НоваяСтрока.РеквизитРодитель) - 1);
		КонецЕсли;
	КонецЕсли;
	
	Если ОписаниеПоляЗамены = "" Тогда 
		НоваяСтрока.ОписаниеПоляЗамены = Описание;
	Иначе 
		НоваяСтрока.ОписаниеПоляЗамены = ОписаниеПоляЗамены;
	КонецЕсли;
	
КонецПроцедуры

Процедура ЗаполнитьСписокДопРеквизитов(Строка, СправочникОбъект, Путь, ВидВладельцаФайла, РеквизитТабличнойЧасти, ТипКонтрагента = Неопределено)
	
	УстановитьПривилегированныйРежим(Истина);
	Объект = Справочники[СправочникОбъект.Имя].СоздатьЭлемент();
	
	Если ЗначениеЗаполнено(ТипКонтрагента) Тогда 
		Объект.ЮридическоеФизическоеЛицо = ТипКонтрагента;
	КонецЕсли;
	
	НаборСвойств = УправлениеСвойствамиСлужебный.ПолучитьНаборыСвойствОбъекта(Объект);
	КоличествоНаборов = НаборСвойств.Количество();
	
	Если КоличествоНаборов > 0 Тогда
		Для Каждого ВложенныйНаборСвойств Из НаборСвойств Цикл
			Для Каждого ДопРеквизит Из ВложенныйНаборСвойств.Набор.ДополнительныеРеквизиты Цикл
				РеквизитыСвойства = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(ДопРеквизит.Свойство,
					"ПометкаУдаления, Заголовок, Наименование, ТипЗначения, Комментарий, УникальныйКодДляПоля, ФорматСвойства");
				Если ДопРеквизит.ПометкаУдаления Или РеквизитыСвойства.ПометкаУдаления = Истина Тогда 
					Продолжить;
				КонецЕсли;
				
				НоваяСтрокаДопРеквизит = Строка.Строки.Добавить();
				НоваяСтрокаДопРеквизит.Наименование = РеквизитыСвойства.УникальныйКодДляПоля;
				НоваяСтрокаДопРеквизит.Тип = РеквизитыСвойства.ТипЗначения;
				НоваяСтрокаДопРеквизит.Описание = РеквизитыСвойства.Заголовок;
				НоваяСтрокаДопРеквизит.ДополнительныйРеквизит = Истина;
				НоваяСтрокаДопРеквизит.ФорматСвойства = РеквизитыСвойства.ФорматСвойства;
				
				Если КоличествоНаборов = 1 Тогда 
					НаборНаименование = "";
				Иначе 
					НаборНаименование = ВложенныйНаборСвойств.Набор.Наименование;
				КонецЕсли;
				
				НоваяСтрокаДопРеквизит.ОбъектРодитель = Путь + "|" + НСтр("ru = 'ДопРеквизиты'") 
					+ ?(ЗначениеЗаполнено(НаборНаименование), "|" + НаборНаименование, "");
				НоваяСтрокаДопРеквизит.ОбъектРодитель = СтрЗаменить(НоваяСтрокаДопРеквизит.ОбъектРодитель, 
					НСтр("ru = 'Доп. свойства'"), НСтр("ru = 'ДопСвойства'"));
					
					
				НоваяСтрокаДопРеквизит.РеквизитТабличнойЧасти = РеквизитТабличнойЧасти;
				
				Если Не РеквизитТабличнойЧасти Тогда 
					РеквизитРодитель = СтрЗаменить(НоваяСтрокаДопРеквизит.ОбъектРодитель,"ВладелецФайла", "");
					РеквизитРодитель = СтрЗаменить(РеквизитРодитель, "|", "_");
					НоваяСтрокаДопРеквизит.РеквизитРодитель = РеквизитРодитель;
					Если Лев(НоваяСтрокаДопРеквизит.РеквизитРодитель, 1) = "_" Тогда 
						НоваяСтрокаДопРеквизит.РеквизитРодитель = Прав(НоваяСтрокаДопРеквизит.РеквизитРодитель, 
							СтрДлина(НоваяСтрокаДопРеквизит.РеквизитРодитель) - 1);
					КонецЕсли;
				Иначе 
					НоваяСтрокаДопРеквизит.НомерКолонкиТабличнойЧасти = 10000;
					НоваяСтрокаДопРеквизит.РеквизитРодитель = "ТЧ";
				КонецЕсли;
				
				Если ЗначениеЗаполнено(РеквизитыСвойства.Комментарий) Тогда 
					НоваяСтрокаДопРеквизит.ОписаниеПоляЗамены = РеквизитыСвойства.Комментарий;
				Иначе 
					НоваяСтрокаДопРеквизит.ОписаниеПоляЗамены = РеквизитыСвойства.Заголовок;
				КонецЕсли;
				
			КонецЦикла;
		КонецЦикла;
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Ложь);
	
КонецПроцедуры
