#Область ОбработчикиСобытийФормы

&НаКлиенте
Процедура ПриЗакрытии()
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("ОткрытаИзПомощникаНачалаРаботы", Истина);
	ОткрытьФорму("Справочник.ВидыДокументов.ФормаСписка", ПараметрыФормы);
	
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	МожноЗакрыть = Ложь;
	
	Элементы.Назад.Доступность = Ложь;
	Элементы.Закрыть.Видимость = Ложь;
	ЭтоБазоваяВерсияКонфигурации = Ложь;
	
	Если СтандартныеПодсистемыСервер.ЭтоБазоваяВерсияКонфигурации() Тогда 
		ЭтоБазоваяВерсияКонфигурации = Истина;
		Элементы.ДекорацияРассылкаРасшифровка.Заголовок = 
			НСтр("ru = '1С:Договоры отправляют по почте уведомления о важных событиях.
                  |Например, о просрочке договора или его этапов.
                  |Укажите, с какого почтового ящика выполнять такие рассылки.
                  |Можно использовать вашу личную почту или завести специальный ящик.
                  |Это можно будет настроить потом (см. ""Настройка программы"").'");
	
	КонецЕсли;
	
	Итого = СтрШаблон("<HTML><HEAD>
			| <META content=""text/html; charset=utf-8"" http-equiv=Content-Type>
			| </HEAD>
			|<style type=""text/css"">
			|	body {
			|		overflow:    auto;
			|		margin-top:  6px; 		 
			|		margin-left: 10px; 
			|		margin-bottom: 6px;
			|		font-family: Arial, sans-serif;
			|		font-size:   12pt;}
			|	p {
			|		margin-top: 7px;}
			|	UL {
			|		padding: 10;
			|		margin: 10;
			|	}
			|</style>
			| <BODY>
			| <H3>%1</H3>
			| <UL>
			| <LI>
			|	<p style=""margin-top: 7px; margin-bottom: 7px"">
			|		<STRONG>%2</STRONG> %3
			|	</p>
			|</LI> 
			| <LI>
			|	<p style=""margin-top: 7px; margin-bottom: 7px"">
			|		<STRONG>%4</STRONG> %5
			|	</p>
			|</LI>",
		НСтр("ru = '1С:Договоры готовы к работе:'"),
		НСтр("ru = 'создавайте'"), 
		НСтр("ru = 'новые договоры, акты и другие документы'"),
		НСтр("ru = 'загружайте'"), 
		НСтр("ru = 'документы с диска или из почты'"));
	
	Если Не ЭтоБазоваяВерсияКонфигурации Тогда 
		Итого = Итого + СтрШаблон("
			| <LI>
			|	<p style=""margin-top: 7px; margin-bottom: 7px"">
			|		<STRONG>%1</STRONG> %2
			|	</p>
			|</LI>",
			НСтр("ru = 'согласовывайте'"),
			НСтр("ru = 'документы друг с другом '"));
	КонецЕсли;
	
	Итого = Итого + СтрШаблон("
			| <LI>
			|	<p style=""margin-top: 7px; margin-bottom: 7px"">
			|		<STRONG>%1</STRONG> %2 
			|	</p>
			|</LI> 
			| <LI>
			|	<p style=""margin-top: 7px; margin-bottom: 7px"">
			|		<STRONG>%3</STRONG> %4
			|	</p>
			|</LI> 
			| <LI>
			|	<p style=""margin-top: 7px; margin-bottom: 7px"">
			|		%5&nbsp;<STRONG>%6</STRONG> %7
			|	</p>
			|</LI> 
			|</UL></BODY></HTML>",
		НСтр("ru = 'отмечайте'"),
		НСтр("ru = 'прохождение этапов'"),
		НСтр("ru = 'отмечайте'"),
		НСтр("ru = 'передачу документов контрагентам'"),
		НСтр("ru = 'и, самое главное,'"),
		НСтр("ru = 'читайте'"),
		НСтр("ru = 'сообщения от программы в своей почте!'"));
	
	Константы.ПомощникНачалаРаботыЗапускался.Установить(Истина);
	
	ЭтоБазоваяВерсия = СтандартныеПодсистемыСервер.ЭтоБазоваяВерсияКонфигурации();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Далее(Команда)
	
	Если Элементы.Страницы.ТекущаяСтраница = Элементы.Страницы.ПодчиненныеЭлементы[0] Тогда
		Элементы.Назад.Доступность = Истина;
	КонецЕсли;
	
	Если Элементы.Страницы.ТекущаяСтраница = Элементы.ИнтернетПоддержка Тогда
		
		Если НЕ ПустаяСтрока(ИнтернетПоддержкаЛогин) Тогда
			Аутентификация = Новый Структура("Логин, Пароль", ИнтернетПоддержкаЛогин, ИнтернетПоддержкаПароль);
			ОписаниеОшибки = "";
			СохранитьАутентификацию(Аутентификация, ОписаниеОшибки);
			Если НЕ ПустаяСтрока(ОписаниеОшибки) Тогда
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ОписаниеОшибки,, "ИнтернетПоддержкаЛогин");
				Возврат;
			КонецЕсли;
		КонецЕсли;	
		
		Элементы.Страницы.ТекущаяСтраница = Элементы.РассылкаСообщений;
		
	ИначеЕсли Элементы.Страницы.ТекущаяСтраница = Элементы.РассылкаСообщений Тогда	
		
		Если ЗначениеЗаполнено(EMail) Или ЗначениеЗаполнено(Пароль) Тогда
			// Указали адрес или пароль - пробуем настроить сейчас.
			Отказ = Ложь;
			ПроверитьЗаполнениеНаСтраницеНастройкаУчетнойЗаписи(Отказ);
			Если Отказ Тогда
				Возврат;
			КонецЕсли;
			Если Не НастроитьПочтуСервер() Тогда
				ТекстПредупреждения = НСтр("ru = 'Не удалось выполнить настроку отправки сообщений по email.
					|Настройкте подключение вручную позже в окне ""Настройка программы"".'");
				ПоказатьПредупреждение(, ТекстПредупреждения);
			КонецЕсли;
		КонецЕсли;
		
		// Пропускаем шаг ввода пользователей для базовой версии
		Если ЭтоБазоваяВерсия Тогда
			Элементы.Страницы.ТекущаяСтраница = Элементы.Бухгалтерия;	
		Иначе	
			Элементы.Страницы.ТекущаяСтраница = Элементы.Пользователи;
		КонецЕсли;	
		
	ИначеЕсли Элементы.Страницы.ТекущаяСтраница = Элементы.Пользователи Тогда
		Элементы.Страницы.ТекущаяСтраница = Элементы.Бухгалтерия;
	ИначеЕсли Элементы.Страницы.ТекущаяСтраница = Элементы.Бухгалтерия Тогда
		Элементы.Страницы.ТекущаяСтраница = Элементы.Готово;
	КонецЕсли;
	
	Если Элементы.Страницы.ТекущаяСтраница = Элементы.Страницы.ПодчиненныеЭлементы[Элементы.Страницы.ПодчиненныеЭлементы.Количество() - 1] Тогда
		Элементы.Далее.Видимость = Ложь;
		Элементы.Закрыть.Видимость = Истина;
	КонецЕсли;	
		
КонецПроцедуры

&НаСервереБезКонтекста
Функция СохранитьАутентификацию(Аутентификация, ОписаниеОшибки)
	
	Если ПараметрыАутентификацииКорректные(Аутентификация, ОписаниеОшибки) Тогда
		СтандартныеПодсистемыСервер.СохранитьПараметрыАутентификацииНаСайте(Аутентификация);
		Возврат Истина;
	КонецЕсли;
	
	Возврат Ложь;
	
КонецФункции	

&НаСервереБезКонтекста
Функция ПараметрыАутентификацииКорректные(ПараметрыАутентификацииНаСайте, ОписаниеОшибки)
	
	Если ПараметрыАутентификацииНаСайте = Неопределено Тогда
		Возврат Истина;
	КонецЕсли;
	
	Билет = "";
	Попытка
		ВебСервис = ОбщегоНазначения.WSПрокси(
			"https://login.1c.ru/api/public/ticket?wsdl",
			"http://api.cas.jasig.org/",
			"TicketApiImplService",
			"TicketApiImplPort",
			ПараметрыАутентификацииНаСайте.Логин,
			ПараметрыАутентификацииНаСайте.Пароль,
			5,
			Ложь);
		
		Билет = ВебСервис.getTicket(
			ПараметрыАутентификацииНаСайте.Логин,
			ПараметрыАутентификацииНаСайте.Пароль,
			"its.1c.ru");
	Исключение
		ИнформацияОбОшибке = ИнформацияОбОшибке();
		КраткоеПредставлениеОшибки = КраткоеПредставлениеОшибки(ИнформацияОбОшибке);
		Если СтрНайти(КраткоеПредставлениеОшибки, "IncorrectLoginOrPasswordApiException") > 0 Тогда
			ОписаниеОшибки = НСтр("ru = 'Не удалось подключиться к веб-сервису сайта «1С» по причине:
									|• Некорректное имя пользователя или пароль.'");
		Иначе
			ОписаниеОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Не удалось подключиться к веб-сервису сайта «1С». Возможные причины:
					|• Некорректно введен или не введен логин и пароль;
					|• Нет подключения к Интернету;
					|• На веб-узле возникли неполадки;
					|• Брандмауэр или другое промежуточное ПО (антивирусы и т.п.) блокируют попытки программы подключиться к Интернету;
					|• Подключение к Интернету выполняется через прокси-сервер, но его параметры не заданы в программе.
					| Техническая информация: %1'"),
			КраткоеПредставлениеОшибки);
		КонецЕсли;
	КонецПопытки;
	
	Возврат ЗначениеЗаполнено(Билет);
	
КонецФункции

&НаКлиенте
Процедура КомандаЗакрыть(Команда)
	
	МожноЗакрыть = Истина;
	Закрыть();
	
КонецПроцедуры

&НаКлиенте
Процедура Назад(Команда)
	
	Если Элементы.Страницы.ТекущаяСтраница = Элементы.Страницы.ПодчиненныеЭлементы[Элементы.Страницы.ПодчиненныеЭлементы.Количество() - 1] Тогда
		Элементы.Далее.Видимость = Истина;
		Элементы.Закрыть.Видимость = Ложь;
	КонецЕсли;	
	
	Если Элементы.Страницы.ТекущаяСтраница = Элементы.Готово Тогда
		Элементы.Страницы.ТекущаяСтраница = Элементы.Бухгалтерия;
	ИначеЕсли Элементы.Страницы.ТекущаяСтраница = Элементы.Бухгалтерия Тогда	
		
		// Пропускаем шаг ввода пользователей для базовой версии
		Если ЭтоБазоваяВерсия Тогда
			Элементы.Страницы.ТекущаяСтраница = Элементы.РассылкаСообщений;
		Иначе		
			Элементы.Страницы.ТекущаяСтраница = Элементы.Пользователи;
		КонецЕсли;
		
	ИначеЕсли Элементы.Страницы.ТекущаяСтраница = Элементы.Пользователи Тогда	
		Элементы.Страницы.ТекущаяСтраница = Элементы.РассылкаСообщений;
	ИначеЕсли Элементы.Страницы.ТекущаяСтраница = Элементы.РассылкаСообщений Тогда	
		Элементы.Страницы.ТекущаяСтраница = Элементы.ИнтернетПоддержка;
	КонецЕсли;
	
	Если Элементы.Страницы.ТекущаяСтраница = Элементы.Страницы.ПодчиненныеЭлементы[0] Тогда
		Элементы.Назад.Доступность = Ложь;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Функция НастроитьПочтуСервер()
	
	// Поиск настроек.
	СтруктураПараметров = Новый Структура;
	СтруктураПараметров.Вставить("АдресЭлектроннойПочты", EMail);
	СтруктураПараметров.Вставить("Пароль", Пароль);
	СтруктураПараметров.Вставить("ДляОтправки", Истина);
	СтруктураПараметров.Вставить("ДляПолучения", Ложь);
	НайденныеНастройки = Справочники.УчетныеЗаписиЭлектроннойПочты.ОпределитьНастройкиУчетнойЗаписи(СтруктураПараметров);
	Если Не НайденныеНастройки.ДляОтправки Тогда
		Возврат Ложь;
	КонецЕсли;
	
	// Настройка учетной записи.
	НачатьТранзакцию();
	Попытка
		
		УчетнаяЗапись = Справочники.УчетныеЗаписиЭлектроннойПочты.СистемнаяУчетнаяЗаписьЭлектроннойПочты.ПолучитьОбъект();
		
		УчетнаяЗапись.ИмяПользователя = РаботаССообщениями.ИмяУчетнойЗаписиДляРассылкиСообщений();
		УчетнаяЗапись.Наименование = EMail;
		УчетнаяЗапись.АдресЭлектроннойПочты = EMail;
		
		УчетнаяЗапись.ИспользоватьДляОтправки = Истина;
		УчетнаяЗапись.ПользовательSMTP = НайденныеНастройки.ИмяПользователяДляОтправкиПисем;
		УчетнаяЗапись.СерверИсходящейПочты = НайденныеНастройки.СерверИсходящейПочты;
		УчетнаяЗапись.ПортСервераИсходящейПочты = НайденныеНастройки.ПортСервераИсходящейПочты;
		УчетнаяЗапись.ИспользоватьЗащищенноеСоединениеДляИсходящейПочты = НайденныеНастройки.ИспользоватьЗащищенноеСоединениеДляИсходящейПочты;
		УчетнаяЗапись.ТребуетсяВходНаСерверПередОтправкой = Ложь;
		НайденныеНастройки.Свойство("ИспользоватьБезопасныйВходНаСерверИсходящейПочты", УчетнаяЗапись.ИспользоватьБезопасныйВходНаСерверИсходящейПочты);
		УчетнаяЗапись.ВремяОжидания = 30;
		
		УчетнаяЗапись.Записать();
		
		УстановитьПривилегированныйРежим(Истина);
		ОбщегоНазначения.ЗаписатьДанныеВБезопасноеХранилище(УчетнаяЗапись.Ссылка, НайденныеНастройки.ПарольДляОтправкиПисем, "ПарольSMTP");
		УстановитьПривилегированныйРежим(Ложь);
		
		ЗафиксироватьТранзакцию();
		
	Исключение
		ОтменитьТранзакцию();
		ЗаписьЖурналаРегистрации(НСтр("ru = 'Ошибка при создании учетной записи электронной почты'", ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка()),
			УровеньЖурналаРегистрации.Ошибка, , , ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
		Возврат Ложь;
	КонецПопытки;
	
	Возврат Истина;
	
КонецФункции

&НаКлиенте
Процедура ПроверитьЗаполнениеНаСтраницеНастройкаУчетнойЗаписи(Отказ)
	
	Если ПустаяСтрока(EMail) Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru = 'Введите адрес электронной почты'"), , "EMail", , Отказ);
	ИначеЕсли Не ОбщегоНазначенияКлиентСервер.АдресЭлектроннойПочтыСоответствуетТребованиям(EMail, Истина) Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru = 'Адрес электронной почты введен неверно'"), , "EMail", , Отказ);
	КонецЕсли;
	
	Если ПустаяСтрока(Пароль) Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru = 'Необходимо ввести пароль'"), , "Пароль", , Отказ);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СсылкаНаСайтИнтернетПоддержкиНажатие(Элемент)
	
	ПерейтиПоНавигационнойСсылке("http://users.v8.1c.ru/");
	
КонецПроцедуры

&НаКлиенте
Процедура ЗагрузитьДанныеИзБухгалтерии(Команда)
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("НачалоРаботы", Истина);
	
	ОткрытьФорму("Обработка.ЗагрузкаИзБухгалтерииПредприятия.Форма.Форма", ПараметрыФормы);
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, СтандартнаяОбработка)
	
	Если Не МожноЗакрыть Тогда
		Отказ = Истина;
		СтандартнаяОбработка = Ложь;
	КонецЕсли;	
	
КонецПроцедуры

#КонецОбласти