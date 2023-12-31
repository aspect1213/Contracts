#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	Если Параметры.Свойство("ЭтоНастройкаДляЗагрузки") Тогда
		ЭтоНастройкаДляЗагрузки	= Параметры.ЭтоНастройкаДляЗагрузки;
	КонецЕсли;	
	
	РежимНастройкиДляОбычногоПользователя = Параметры.РежимНастройкиДляОбычногоПользователя;
	Если РежимНастройкиДляОбычногоПользователя Тогда
		
		Заголовок = НСтр("ru = 'Настройка почты'");
		Элементы.ДекорацияНастройка.Заголовок 
			= НСтр("ru = 'Укажите параметры для подключения к вашему почтовому ящику.'");
		
		Элементы.ДекорацияВыполнениеНастройки.Заголовок = НСтр("ru = 'Выполняется настройка учетной записи почты.
			|Пожалуйста, подождите...'");
		Элементы.ДекорацияУспешно.Заголовок = НСтр("ru = 'Рассылка сообщений настроена успешно.'");
		
		Если ЭтоНастройкаДляЗагрузки Тогда
			Элементы.ДекорацияГотово.Заголовок = 
				НСтр("ru = 'Настройка почты завершена.
				| 
				|Вы можете изменить эти настройки потом с помощью команды ""Настройка"" в меню ""Еще"" окна загрузки почты.
				|Сейчас откроется список писем.'");
				
			Элементы.ДекорацияГдеЛежат.Заголовок = НСтр("ru = 'Где лежат письма, которые вы хотите загрузить в программу:'");	
			
			Элементы.ВариантОтправки.СписокВыбора.Очистить();
			Элементы.ВариантОтправки.СписокВыбора.Добавить(Перечисления.ВидыПочтовыхКлиентов.ИнтернетПочта,
				НСтр("ru ='В почтовом ящике в Интернет'"));
			Элементы.ВариантОтправки.СписокВыбора.Добавить(Перечисления.ВидыПочтовыхКлиентов.MSOutlook,
				НСтр("ru ='В вашем Microsoft Outlook'"));
			
		Иначе
				
			Элементы.ДекорацияГотово.Заголовок = 
				НСтр("ru = 'Настройка почты завершена.
				| 
				|Вы можете изменить эти настройки потом с помощью команды ""Настройка"" в меню ""Еще"" окна отправки письма.
				|Сейчас откроется окно отправки письма.'");
				
			Элементы.ДекорацияГдеЛежат.Заголовок = НСтр("ru = 'Каким способом будет отправлено письмо:'");		
			
			Элементы.ВариантОтправки.СписокВыбора.Очистить();
			Элементы.ВариантОтправки.СписокВыбора.Добавить(Перечисления.ВидыПочтовыхКлиентов.ИнтернетПочта,
				НСтр("ru ='Подключившись к вашему почтовому ящику в Интернет'"));
			Элементы.ВариантОтправки.СписокВыбора.Добавить(Перечисления.ВидыПочтовыхКлиентов.MSOutlook,
				НСтр("ru ='Используя ваш Microsoft Outlook'"));
				
		КонецЕсли;	
		
		ИспользоватьДляОтправки = Истина;
		ИспользоватьДляПолучения = Истина;
		
		Элементы.СтраницыНастройкиВручную.ОтображениеСтраниц = ОтображениеСтраницФормы.ЗакладкиСверху;
		Элементы.ИспользоватьУчетнуюЗапись.Видимость = Истина;
		
		ВариантПочты = Перечисления.ВидыПочтовыхКлиентов.ИнтернетПочта;
		
		Если Параметры.Свойство("ВидПочтовогоКлиента") И Параметры.Свойство("Профиль") 
			И Параметры.Свойство("Данные") Тогда
			
			ВариантПочты = Параметры.ВидПочтовогоКлиента;
			Профиль = Параметры.Профиль;
			
			Если ВариантПочты = Перечисления.ВидыПочтовыхКлиентов.ИнтернетПочта Тогда
				
				СуществующаяУчетнаяЗапись = Профиль;
				
				АдресЭлектроннойПочты = СуществующаяУчетнаяЗапись.АдресЭлектроннойПочты;
				УстановитьПривилегированныйРежим(Истина);
				ПарольДляОтправкиПисем 
					= ОбщегоНазначения.ПрочитатьДанныеИзБезопасногоХранилища(СуществующаяУчетнаяЗапись, "ПарольSMTP");
				УстановитьПривилегированныйРежим(Ложь);
				
			ИначеЕсли ВариантПочты = Перечисления.ВидыПочтовыхКлиентов.MSOutlook Тогда	
				
				Данные = Параметры.Данные;
				Если Данные.Свойство("Путь") Тогда
					ПапкаOutlook = Данные.Путь;
				КонецЕсли;	
				
			КонецЕсли;	
			
		КонецЕсли;	
		
		Команды["Готово"].Заголовок = НСтр("ru ='Далее'");
		Команды["Готово"].Подсказка = НСтр("ru ='Далее'");
		
		КлючСохраненияПоложенияОкна = "НастройкаУчетнойЗаписиЭлектроннойПочты";
		
		Элементы.ДекорацияФайловаяБаза.Видимость = Ложь;
		
	Иначе
		
		Элементы.СтраницаВыборВариантаПочты.Видимость = Ложь;
		Элементы.СтраницаНастройкаOutlook.Видимость = Ложь;
		Элементы.СтраницаГотово.Видимость = Ложь;
		
		УчетнаяЗапись = Справочники.УчетныеЗаписиЭлектроннойПочты.СистемнаяУчетнаяЗаписьЭлектроннойПочты;
		АдресЭлектроннойПочты = УчетнаяЗапись.АдресЭлектроннойПочты;
		УстановитьПривилегированныйРежим(Истина);
		ПарольДляОтправкиПисем = ОбщегоНазначения.ПрочитатьДанныеИзБезопасногоХранилища(УчетнаяЗапись, "ПарольSMTP");
		УстановитьПривилегированныйРежим(Ложь);
		
		Заголовок = НСтр("ru = 'Настройка отправки сообщений'");
		Элементы.ДекорацияНастройка.Заголовок = НСтр("ru = 'Укажите адрес, с которого ""1С:Договоры"" будут отправлять сообщения пользователям.'");
		Элементы.ДекорацияВыполнениеНастройки.Заголовок = НСтр("ru = 'Выполняется настройка отправки сообщений.
			|Пожалуйста, подождите...'");
		Элементы.ДекорацияУспешно.Заголовок = НСтр("ru = 'Отправка сообщений настроена успешно.'");
		
		ИспользоватьДляОтправки = Истина;
		ИспользоватьДляПолучения = Ложь;
		
		Элементы.СтраницыНастройкиВручную.ОтображениеСтраниц = ОтображениеСтраницФормы.Нет;
		Элементы.ИспользоватьУчетнуюЗапись.Видимость = Ложь;
		
		Высота = 15;
		
		КлючСохраненияПоложенияОкна = "НастройкаСистемнойУчетнойЗаписиЭлектроннойПочты";
		
		Элементы.ДекорацияФайловаяБаза.Видимость = ОбщегоНазначения.ИнформационнаяБазаФайловая();
		
	КонецЕсли;
	
	ДлительностьОжиданияСервера = 30;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
Процедура АдресЭлектроннойПочтыВручнуюПриИзменении(Элемент)
	
	Если Не ЗначениеЗаполнено(АдресЭлектроннойПочты)
		Или ЗначениеЗаполнено(ИмяПользователяДляОтправкиПисем) Тогда
		Возврат;
	КонецЕсли;
	
	ИмяПользователяДляОтправкиПисем = АдресЭлектроннойПочты;
	
КонецПроцедуры

&НаКлиенте
Процедура ИспользоватьДляПолученияПриИзменении(Элемент)
	
	Элементы.СтраницаНастройкаПолучения.Доступность = ИспользоватьДляПолучения;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Готово(Команда)
	
	Если Элементы.СтраницыНастройки.ТекущаяСтраница = Элементы.СтраницаВыборВариантаПочты Тогда
		
		Если ВариантПочты = ПредопределенноеЗначение("Перечисление.ВидыПочтовыхКлиентов.ИнтернетПочта") Тогда
			ПерейтиНаСтраницуНастройка();
		Иначе	
			ПерейтиНаСтраницуНастройкаOutlook();
		КонецЕсли;	
		
	ИначеЕсли Элементы.СтраницыНастройки.ТекущаяСтраница = Элементы.СтраницаНастройкаOutlook Тогда	
		
		ПерейтиНаСтраницуГотово();
		
	ИначеЕсли Элементы.СтраницыНастройки.ТекущаяСтраница = Элементы.СтраницаГотово Тогда		
		
		ПерейтиНаСтраницуУспешнаяНастройка();
	
	ИначеЕсли Элементы.СтраницыНастройки.ТекущаяСтраница = Элементы.СтраницаНастройка Тогда
		
		Отказ = Ложь;
		ПроверитьЗаполнениеНаСтраницеНастройкаУчетнойЗаписи(Отказ);
		Если Отказ Тогда
			Высота = 22;
			Возврат;
		КонецЕсли;
		
		ПодобратьНастройкиУчетнойЗаписи();
		
		Если ПроверкаЗавершиласьСОшибками Тогда
			ПерейтиНаСтраницуНеудачнаяНастройка();
		Иначе
			ПерейтиНаСтраницуВыполнениеНастройки();
			ПараметрыОбработчикаОжидания = Неопределено;
			ПроверитьВыполнениеФоновогоЗадания();
		КонецЕсли;
		
	ИначеЕсли Элементы.СтраницыНастройки.ТекущаяСтраница = Элементы.СтраницаНастройкаВручную Тогда
		
		Отказ = Ложь;
		ПроверитьЗаполнениеНаСтраницеРучнойНастройки(Отказ);
		Если Отказ Тогда
			Возврат;
		КонецЕсли;
		
		ПроверитьНастройкиУчетнойЗаписи();
		
		Если ПроверкаЗавершиласьСОшибками Тогда
			ПоказатьПредупреждение(, СообщенияОбОшибках);
		Иначе
			ПерейтиНаСтраницуУспешнаяНастройка();
		КонецЕсли;
		
	ИначеЕсли Элементы.СтраницыНастройки.ТекущаяСтраница = Элементы.СтраницаУспешнаяНастройка Тогда
		
		Закрыть(НастроеннаяУчетнаяЗапись);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура Настроить(Команда)
	
	ПерейтиНаСтраницуНастройкаВручную();

КонецПроцедуры

&НаКлиенте
Процедура Отмена(Команда)
	
	Закрыть();
	
КонецПроцедуры

&НаКлиенте
Процедура Повторить(Команда)
	
	ПерейтиНаСтраницуНастройка();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервереБезКонтекста
Функция ЗаданиеВыполнено(ИдентификаторЗадания)
	Возврат ДлительныеОперации.ЗаданиеВыполнено(ИдентификаторЗадания);
КонецФункции

&НаКлиенте
Процедура ПерейтиНаСтраницуВыполнениеНастройки()
	
	Элементы.ФормаГотово.Видимость = Истина;
	Элементы.ФормаГотово.Доступность = Ложь;
	Элементы.ФормаГотово.КнопкаПоУмолчанию = Истина;
	
	Элементы.ФормаПовторить.Видимость = Ложь;
	
	Элементы.ФормаНастроить.Видимость = Ложь;
	
	Элементы.ФормаОтмена.Видимость = Истина;
	Элементы.ФормаОтмена.Доступность = Истина;
	
	Элементы.СтраницыНастройки.ТекущаяСтраница = Элементы.СтраницаВыполнениеНастройки;
	
	ТекущийЭлемент = Элементы.ФормаОтмена;
	
КонецПроцедуры

&НаКлиенте
Процедура ПерейтиНаСтраницуНастройка()
	
	Элементы.ФормаГотово.Видимость = Истина;
	Элементы.ФормаГотово.Доступность = Истина;
	Элементы.ФормаГотово.КнопкаПоУмолчанию = Истина;
	
	Элементы.ФормаПовторить.Видимость = Ложь;
	
	Элементы.ФормаНастроить.Видимость = Ложь;
	
	Элементы.ФормаОтмена.Видимость = Истина;
	Элементы.ФормаОтмена.Доступность = Истина;
	
	Элементы.СтраницыНастройки.ТекущаяСтраница = Элементы.СтраницаНастройка;
	
	ТекущийЭлемент = Элементы.АдресЭлектроннойПочты;
	
КонецПроцедуры

&НаСервере
Процедура ИзменитьТекстКомандыГотово(Текст)
	
	Команды["Готово"].Заголовок = Текст;
	Команды["Готово"].Подсказка = Текст;

КонецПроцедуры

&НаКлиенте
Процедура ПерейтиНаСтраницуГотово()
	
	ИзменитьТекстКомандыГотово(НСтр("ru ='Готово'"));
	Элементы.СтраницыНастройки.ТекущаяСтраница = Элементы.СтраницаГотово;

	Элементы.ФормаГотово.Видимость = Истина;
	Элементы.ФормаГотово.Доступность = Истина;
	Элементы.ФормаГотово.КнопкаПоУмолчанию = Истина;
	
	Элементы.ФормаОтмена.Видимость = Ложь;
	
КонецПроцедуры

&НаКлиенте
Процедура ПерейтиНаСтраницуНастройкаOutlook()
	
	Элементы.ФормаГотово.Видимость = Истина;
	Элементы.ФормаГотово.Доступность = Истина;
	Элементы.ФормаГотово.КнопкаПоУмолчанию = Истина;
	
	Элементы.ФормаПовторить.Видимость = Ложь;
	
	Элементы.ФормаНастроить.Видимость = Ложь;
	
	Элементы.ФормаОтмена.Видимость = Истина;
	Элементы.ФормаОтмена.Доступность = Истина;
	
	Элементы.СтраницыНастройки.ТекущаяСтраница = Элементы.СтраницаНастройкаOutlook;
	
	НайтиПапкуВходящиеВOutlook();
	
КонецПроцедуры

&НаКлиенте
Процедура НайтиПапкуВходящиеВOutlook()

	Application = Новый COMОбъект("Outlook.Application");
	
	Попытка
		
		Folder = Application.GetNamespace("MAPI");
		НайтиВложенныеПапки(Folder);
		
	Исключение
		// Может закончиться неудачей
	КонецПопытки;
	
	Application = Неопределено;
	
КонецПроцедуры	

&НаКлиенте
Процедура НайтиВложенныеПапки(КореньИсточник)
	
	Если ЗначениеЗаполнено(ПапкаOutlook) Тогда
		Возврат;
	КонецЕсли;	
	
	Folders = КореньИсточник.Folders;
	КоличествоПапок = Folders.Count();
	
	Если КоличествоПапок > 0 Тогда
		
		Для НомерПапки = 1 По КоличествоПапок Цикл
			
			Folder = Folders.Item(НомерПапки);
			Если Folders.Item(НомерПапки).DefaultItemType <> 0 Тогда
				Продолжить;
			КонецЕсли;
			
			Путь = Folder.FolderPath;
			Если СтрЗаканчиваетсяНа(Путь, "Входящие") Или СтрЗаканчиваетсяНа(Путь, "Inbox") Тогда
				ПапкаOutlook = Путь;
				Возврат;
			КонецЕсли;	
			
			НайтиВложенныеПапки(Folder);
			
		КонецЦикла;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПерейтиНаСтраницуНеудачнаяНастройка()
	
	Элементы.ФормаГотово.Видимость = Ложь;
	
	Элементы.ФормаПовторить.Видимость = Истина;
	Элементы.ФормаПовторить.КнопкаПоУмолчанию = Истина;
	
	Элементы.ФормаНастроить.Видимость = Истина;
	
	Элементы.ФормаОтмена.Видимость = Истина;
	Элементы.ФормаОтмена.Доступность = Истина;
	
	Элементы.СтраницыНастройки.ТекущаяСтраница = Элементы.СтраницаНеудачнаяНастройка;
	
	ТекущийЭлемент = Элементы.ФормаПовторить;
	
КонецПроцедуры

&НаКлиенте
Процедура ПерейтиНаСтраницуУспешнаяНастройка()
	
	Если РежимНастройкиДляОбычногоПользователя Тогда
		
		Если ВариантПочты = ПредопределенноеЗначение("Перечисление.ВидыПочтовыхКлиентов.ИнтернетПочта") Тогда
			Закрыть(НастроеннаяУчетнаяЗапись);
		Иначе
			Закрыть(ПапкаOutlook);
		КонецЕсли;	
		
		Возврат;
	КонецЕсли;
	
	Элементы.ФормаГотово.Видимость = Истина;
	Элементы.ФормаГотово.Доступность = Истина;
	
	Элементы.ФормаПовторить.Видимость = Ложь;
	
	Элементы.ФормаНастроить.Видимость = Ложь;
	
	Элементы.ФормаОтмена.Видимость = Ложь;
	
	Элементы.СтраницыНастройки.ТекущаяСтраница = Элементы.СтраницаУспешнаяНастройка;
	
КонецПроцедуры

&НаКлиенте
Процедура ПерейтиНаСтраницуНастройкаВручную()
	
	Элементы.ФормаГотово.Видимость = Истина;
	Элементы.ФормаГотово.Доступность = Истина;
	Элементы.ФормаГотово.КнопкаПоУмолчанию = Истина;
	
	Элементы.ФормаПовторить.Видимость = Ложь;
	
	Элементы.ФормаНастроить.Видимость = Ложь;
	
	Элементы.ФормаОтмена.Видимость = Истина;
	Элементы.ФормаОтмена.Доступность = Истина;
	
	Элементы.СтраницаНастройкаВручную.Видимость = Истина;
	Элементы.СтраницыНастройки.ТекущаяСтраница = Элементы.СтраницаНастройкаВручную;
	Высота = 22;
	
	Если ЗначениеЗаполнено(АдресЭлектроннойПочты) Тогда
		ИмяПользователяДляОтправкиПисем = АдресЭлектроннойПочты;
	КонецЕсли;
	
	Если РежимНастройкиДляОбычногоПользователя Тогда
		ИмяПользователяДляПолученияПисем = ИмяПользователяДляОтправкиПисем;
		ПарольДляПолученияПисем = ПарольДляОтправкиПисем;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПодобратьНастройкиУчетнойЗаписи()
	
	ПроверкаЗавершиласьСОшибками = Ложь;
	
	НаименованиеЗадания = НСтр("ru = 'Поиск настроек почтового сервера'");
	ВыполняемыйМетод = "Справочники.УчетныеЗаписиЭлектроннойПочты.ОпределитьНастройкиУчетнойЗаписи";
	
	СтруктураПараметров = Новый Структура;
	СтруктураПараметров.Вставить("АдресЭлектроннойПочты", АдресЭлектроннойПочты);
	СтруктураПараметров.Вставить("Пароль", ПарольДляОтправкиПисем);
	СтруктураПараметров.Вставить("ДляОтправки", Истина);
	Если РежимНастройкиДляОбычногоПользователя Тогда
		СтруктураПараметров.Вставить("ДляПолучения", Истина);
	Иначе
		СтруктураПараметров.Вставить("ДляПолучения", Ложь);
	КонецЕсли;
	
	Попытка
		РезультатФоновогоЗадания = ДлительныеОперации.ЗапуститьВыполнениеВФоне(
			УникальныйИдентификатор,
			ВыполняемыйМетод,
			СтруктураПараметров, 
			НаименованиеЗадания);
	Исключение
		ПроверкаЗавершиласьСОшибками = Истина;
	КонецПопытки;
	
КонецПроцедуры

&НаКлиенте
Процедура ПроверитьВыполнениеФоновогоЗадания()
	
	Если Не РезультатФоновогоЗадания.ЗаданиеВыполнено Тогда
		Попытка
			РезультатФоновогоЗадания.ЗаданиеВыполнено = ЗаданиеВыполнено(РезультатФоновогоЗадания.ИдентификаторЗадания);
		Исключение
			ПроверкаЗавершиласьСОшибками = Истина;
			ПерейтиНаСтраницуНеудачнаяНастройка();
			Возврат;
		КонецПопытки;
	КонецЕсли;
	
	Если РезультатФоновогоЗадания.ЗаданиеВыполнено Тогда
		НайденныеНастройки = ПолучитьИзВременногоХранилища(РезультатФоновогоЗадания.АдресХранилища);
		Если РежимНастройкиДляОбычногоПользователя Тогда
			ПроверкаЗавершиласьСОшибками = Не НайденныеНастройки.ДляОтправки Или Не НайденныеНастройки.ДляПолучения;
		Иначе
			ПроверкаЗавершиласьСОшибками = Не НайденныеНастройки.ДляОтправки;
		КонецЕсли;
		ЗаполнитьЗначенияСвойств(ЭтотОбъект, НайденныеНастройки);
		Если Не ПроверкаЗавершиласьСОшибками Тогда
			СоздатьУчетнуюЗапись(НайденныеНастройки);
			
			Если РежимНастройкиДляОбычногоПользователя Тогда
				ПерейтиНаСтраницуГотово();
			Иначе	
				ПерейтиНаСтраницуУспешнаяНастройка();
			КонецЕсли;	
			
		Иначе
			ПерейтиНаСтраницуНеудачнаяНастройка();
		КонецЕсли;
	Иначе
		Если ПараметрыОбработчикаОжидания = Неопределено Тогда
			ДлительныеОперацииКлиент.ИнициализироватьПараметрыОбработчикаОжидания(ПараметрыОбработчикаОжидания);
		Иначе
			ДлительныеОперацииКлиент.ОбновитьПараметрыОбработчикаОжидания(ПараметрыОбработчикаОжидания);
		КонецЕсли;
		ПодключитьОбработчикОжидания("ПроверитьВыполнениеФоновогоЗадания", ПараметрыОбработчикаОжидания.ТекущийИнтервал, Истина);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПроверитьЗаполнениеНаСтраницеНастройкаУчетнойЗаписи(Отказ)
	
	Если ПустаяСтрока(АдресЭлектроннойПочты) Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru = 'Введите адрес электронной почты'"), , "АдресЭлектроннойПочты", , Отказ);
	ИначеЕсли Не ОбщегоНазначенияКлиентСервер.АдресЭлектроннойПочтыСоответствуетТребованиям(АдресЭлектроннойПочты, Истина) Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru = 'Адрес электронной почты введен неверно'"), , "АдресЭлектроннойПочты", , Отказ);
	КонецЕсли;
	
	Если ПустаяСтрока(ПарольДляОтправкиПисем) Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru = 'Введите пароль'"), , "ПарольДляОтправкиПисем", , Отказ);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПроверитьЗаполнениеНаСтраницеРучнойНастройки(Отказ)
	
	Если ПустаяСтрока(АдресЭлектроннойПочты) Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru = 'Введите адрес электронной почты'"), , "АдресЭлектроннойПочты", , Отказ);
	ИначеЕсли Не ОбщегоНазначенияКлиентСервер.АдресЭлектроннойПочтыСоответствуетТребованиям(АдресЭлектроннойПочты, Истина) Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru = 'Адрес электронной почты введен неверно'"), , "АдресЭлектроннойПочты", , Отказ);
	КонецЕсли;
	
	Если ПустаяСтрока(ИмяПользователяДляОтправкиПисем) Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru = 'Введите имя пользователя для отправки писем'"), , "ИмяПользователяДляОтправкиПисем", , Отказ);
	КонецЕсли;
	
	Если ПустаяСтрока(ПарольДляОтправкиПисем) Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru = 'Введите пароль'"), , "ПарольДляОтправкиПисем", , Отказ);
	КонецЕсли;
	
	Если ПустаяСтрока(СерверИсходящейПочты) Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru = 'Введите адрес SMTP сервера почты'"), , "СерверИсходящейПочты", , Отказ);
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(ПортСервераИсходящейПочты) Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru = 'Введите порт SMTP сервера почты'"), , "ПортСервераИсходящейПочты", , Отказ);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура СоздатьУчетнуюЗапись(НайденныеНастройки)
	
	НачатьТранзакцию();
	Попытка
		
		Если РежимНастройкиДляОбычногоПользователя Тогда
			УчетнаяЗапись = Справочники.УчетныеЗаписиЭлектроннойПочты.СоздатьЭлемент();
		Иначе
			УчетнаяЗапись = Справочники.УчетныеЗаписиЭлектроннойПочты.СистемнаяУчетнаяЗаписьЭлектроннойПочты.ПолучитьОбъект();
		КонецЕсли;
		
		Если РежимНастройкиДляОбычногоПользователя Тогда
			УчетнаяЗапись.ОтветственныйЗаОбработкуПисем = ПользователиКлиентСервер.ТекущийПользователь();
		КонецЕсли;
		
		УчетнаяЗапись.ИмяПользователя = ИмяОтправителя();
		УчетнаяЗапись.Наименование = АдресЭлектроннойПочты;
		УчетнаяЗапись.АдресЭлектроннойПочты = АдресЭлектроннойПочты;
		
		УчетнаяЗапись.ИспользоватьДляОтправки = Истина;
		УчетнаяЗапись.ПользовательSMTP = НайденныеНастройки.ИмяПользователяДляОтправкиПисем;
		УчетнаяЗапись.СерверИсходящейПочты = НайденныеНастройки.СерверИсходящейПочты;
		УчетнаяЗапись.ПортСервераИсходящейПочты = НайденныеНастройки.ПортСервераИсходящейПочты;
		УчетнаяЗапись.ИспользоватьЗащищенноеСоединениеДляИсходящейПочты = НайденныеНастройки.ИспользоватьЗащищенноеСоединениеДляИсходящейПочты;
		УчетнаяЗапись.ТребуетсяВходНаСерверПередОтправкой = Ложь;
		НайденныеНастройки.Свойство("ИспользоватьБезопасныйВходНаСерверИсходящейПочты", УчетнаяЗапись.ИспользоватьБезопасныйВходНаСерверИсходящейПочты);
		
		Если НайденныеНастройки.ДляПолучения Тогда
			УчетнаяЗапись.ИспользоватьДляПолучения = Истина;
			УчетнаяЗапись.Пользователь = НайденныеНастройки.ИмяПользователяДляПолученияПисем;
			УчетнаяЗапись.ПротоколВходящейПочты = НайденныеНастройки.Протокол;
			УчетнаяЗапись.СерверВходящейПочты = НайденныеНастройки.СерверВходящейПочты;
			УчетнаяЗапись.ПортСервераВходящейПочты = НайденныеНастройки.ПортСервераВходящейПочты;
			УчетнаяЗапись.ИспользоватьЗащищенноеСоединениеДляВходящейПочты = НайденныеНастройки.ИспользоватьЗащищенноеСоединениеДляВходящейПочты;
			НайденныеНастройки.Свойство("ИспользоватьБезопасныйВходНаСерверВходящейПочты", УчетнаяЗапись.ИспользоватьБезопасныйВходНаСерверВходящейПочты);
		КонецЕсли;
		
		УчетнаяЗапись.ВремяОжидания = ДлительностьОжиданияСервера;
		
		УчетнаяЗапись.Записать();
		
		УстановитьПривилегированныйРежим(Истина);
		ОбщегоНазначения.ЗаписатьДанныеВБезопасноеХранилище(УчетнаяЗапись.Ссылка, НайденныеНастройки.ПарольДляОтправкиПисем, "ПарольSMTP");
		Если НайденныеНастройки.ДляПолучения Тогда
			ОбщегоНазначения.ЗаписатьДанныеВБезопасноеХранилище(УчетнаяЗапись.Ссылка, НайденныеНастройки.ПарольДляПолученияПисем);
		КонецЕсли;
		УстановитьПривилегированныйРежим(Ложь);
		
		ЗафиксироватьТранзакцию();
		
	Исключение
		ОтменитьТранзакцию();
		ЗаписьЖурналаРегистрации(НСтр("ru = 'Ошибка при создании учетной записи электронной почты'", ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка()),
			УровеньЖурналаРегистрации.Ошибка, , , ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
		ВызватьИсключение;
	КонецПопытки;
	
	НастроеннаяУчетнаяЗапись = УчетнаяЗапись.Ссылка;
	
КонецПроцедуры

&НаСервере
Процедура ПроверитьНастройкиУчетнойЗаписи()
	
	ПроверкаЗавершиласьСОшибками = Ложь;
	
	СообщениеСервераИсходящейПочты = ПроверитьПодключениеКСерверуИсходящейПочты();
	
	ТекстОшибки = "";
	Если Не ПустаяСтрока(СообщениеСервераИсходящейПочты) Тогда
		ТекстОшибки = НСтр("ru = 'Не удалось подключиться к серверу исходящей почты:'" + Символы.ПС)
			+ СообщениеСервераИсходящейПочты + Символы.ПС;
	КонецЕсли;
	
	СообщенияОбОшибках = СокрЛП(ТекстОшибки);
	
	Если Не ПустаяСтрока(ТекстОшибки) Тогда
		ПроверкаЗавершиласьСОшибками = Истина;
	Иначе
		
		НайденныеНастройки = Новый Структура;
		НайденныеНастройки.Вставить("ДляОтправки", Истина);
		НайденныеНастройки.Вставить("ИмяПользователяДляОтправкиПисем", ИмяПользователяДляОтправкиПисем);
		НайденныеНастройки.Вставить("СерверИсходящейПочты", СерверИсходящейПочты);
		НайденныеНастройки.Вставить("ПортСервераИсходящейПочты", ПортСервераИсходящейПочты);
		НайденныеНастройки.Вставить("ИспользоватьЗащищенноеСоединениеДляИсходящейПочты", ИспользоватьЗащищенноеСоединениеДляИсходящейПочты);
		НайденныеНастройки.Вставить("ПарольДляОтправкиПисем", ПарольДляОтправкиПисем);
		НайденныеНастройки.Вставить("ИспользоватьБезопасныйВходНаСерверИсходящейПочты", ИспользоватьБезопасныйВходНаСерверИсходящейПочты);
		
		Если ИспользоватьДляПолучения Тогда
			НайденныеНастройки.Вставить("ДляПолучения", Истина);
			НайденныеНастройки.Вставить("Протокол", "POP3");
			НайденныеНастройки.Вставить("ИмяПользователяДляПолученияПисем", ИмяПользователяДляПолученияПисем);
			НайденныеНастройки.Вставить("СерверВходящейПочты", СерверВходящейПочты);
			НайденныеНастройки.Вставить("ПортСервераВходящейПочты", ПортСервераВходящейПочты);
			НайденныеНастройки.Вставить("ИспользоватьЗащищенноеСоединениеДляВходящейПочты", ИспользоватьЗащищенноеСоединениеДляВходящейПочты);
			НайденныеНастройки.Вставить("ПарольДляПолученияПисем", ПарольДляПолученияПисем);
			НайденныеНастройки.Вставить("ИспользоватьБезопасныйВходНаСерверВходящейПочты", ИспользоватьБезопасныйВходНаСерверВходящейПочты);
		Иначе
			НайденныеНастройки.Вставить("ДляПолучения", Ложь);
		КонецЕсли;
		
		СоздатьУчетнуюЗапись(НайденныеНастройки);
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция ПроверитьПодключениеКСерверуИсходящейПочты()
	
	ПараметрыПисьма = Новый Структура;
	
	Тема = НСтр("ru = 'Тестовое сообщение 1С:Договоры'");
	Тело = НСтр("ru = 'Это сообщение отправлено подсистемой электронной почты 1С:Договоры'");
	
	Письмо = Новый ИнтернетПочтовоеСообщение;
	Письмо.Тема = Тема;
	
	Получатель = Письмо.Получатели.Добавить(АдресЭлектроннойПочты);
	Получатель.ОтображаемоеИмя = ИмяОтправителя();
	
	Письмо.ИмяОтправителя = ИмяОтправителя();
	Письмо.Отправитель.ОтображаемоеИмя = ИмяОтправителя();
	Письмо.Отправитель.Адрес = АдресЭлектроннойПочты;
	
	Текст = Письмо.Тексты.Добавить(Тело);
	Текст.ТипТекста = ТипТекстаПочтовогоСообщения.ПростойТекст;

	Профиль = ИнтернетПочтовыйПрофиль();
	ИнтернетПочта = Новый ИнтернетПочта;
	
	ТекстОшибки = "";
	Попытка
		ИнтернетПочта.Подключиться(Профиль);
		ИнтернетПочта.Послать(Письмо);
	Исключение
		ТекстОшибки = КраткоеПредставлениеОшибки(ИнформацияОбОшибке());
	КонецПопытки;
	
	ИнтернетПочта.Отключиться();
	
	Возврат ТекстОшибки;
	
КонецФункции

&НаСервере
Функция ИнтернетПочтовыйПрофиль()
	
	Профиль = Новый ИнтернетПочтовыйПрофиль;
	Профиль.АдресСервераSMTP = СерверИсходящейПочты;
	Профиль.ИспользоватьSSLSMTP = ИспользоватьЗащищенноеСоединениеДляИсходящейПочты;
	Профиль.ПарольSMTP = ПарольДляОтправкиПисем;
	Профиль.ПользовательSMTP = ИмяПользователяДляОтправкиПисем;
	Профиль.ПортSMTP = ПортСервераИсходящейПочты;
	Профиль.ТолькоЗащищеннаяАутентификацияSMTP = ИспользоватьБезопасныйВходНаСерверИсходящейПочты;
	
	Если ИспользоватьДляПолучения Тогда
		Профиль.АдресСервераPOP3 = СерверВходящейПочты;
		Профиль.ИспользоватьSSLPOP3 = ИспользоватьЗащищенноеСоединениеДляВходящейПочты;
		Профиль.Пароль = ПарольДляПолученияПисем;
		Профиль.Пользователь = ИмяПользователяДляПолученияПисем;
		Профиль.ПортPOP3 = ПортСервераВходящейПочты;
		Профиль.ТолькоЗащищеннаяАутентификацияPOP3 = ИспользоватьБезопасныйВходНаСерверВходящейПочты;
	КонецЕсли;
	
	Профиль.Таймаут = ДлительностьОжиданияСервера;
	
	Возврат Профиль;
	
КонецФункции

&НаСервере
Функция ИмяОтправителя()
	
	ИмяОтправителя = "";
	
	Если РежимНастройкиДляОбычногоПользователя Тогда
		ТекущийПользователь = ПользователиКлиентСервер.ТекущийПользователь();
		ИмяОтправителя = Строка(ТекущийПользователь);
	Иначе
		ИмяОтправителя = РаботаССообщениями.ИмяУчетнойЗаписиДляРассылкиСообщений();
	КонецЕсли;
	
	Возврат ИмяОтправителя;
	
КонецФункции

&НаКлиенте
Процедура ПапкаOutlookНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	#Если НЕ ВебКлиент Тогда			
		
	Обработчик = Новый ОписаниеОповещения("ПослеВыбораПапкиOutlook", 
		ЭтотОбъект);
		
	ОткрытьФорму(
		"Обработка.НастройкаПочты.Форма.ЗагрузкаMSOutlook",
		,
		УникальныйИдентификатор,,,,
		Обработчик,
		РежимОткрытияОкнаФормы.БлокироватьВесьИнтерфейс);
	#Иначе
		ПоказатьПредупреждение(, НСтр("ru = 'В веб клиенте загрузка из Microsoft Outlook не поддерживается.'"));
	#КонецЕсли
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеВыбораПапкиOutlook(КодВозврата, ПараметрыВыполнения) Экспорт
	
	Если ТипЗнч(КодВозврата) = Тип("Структура") Тогда
		
		ПапкаOutlook = КодВозврата.Данные.Путь;
		
	КонецЕсли;	

КонецПроцедуры

#КонецОбласти