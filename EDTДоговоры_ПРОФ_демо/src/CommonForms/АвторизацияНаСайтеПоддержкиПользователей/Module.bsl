#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	Аутентификация = СтандартныеПодсистемыСервер.ПараметрыАутентификацииНаСайте();
	Если Аутентификация <> Неопределено Тогда
		Логин  = Аутентификация.Логин;
		Если ЗначениеЗаполнено(Аутентификация.Пароль) Тогда
			Пароль = ЭтотОбъект.УникальныйИдентификатор;
		КонецЕсли;
	КонецЕсли;
	
	Если Параметры.ЗапомнитьПароль Тогда
		Элементы.ЗапомнитьПароль.Видимость = Ложь;
		ЗапомнитьПароль = Истина;
	Иначе
		ЗапомнитьПароль = Истина;
	КонецЕсли;

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ПерейтиКРегистрацииНаСайтеНажатие(Элемент)
	
	ПерейтиПоНавигационнойСсылке("http://users.v8.1c.ru/");
	
КонецПроцедуры

&НаКлиенте
Процедура ПарольПриИзменении(Элемент)
	ПарольИзменен = Истина;
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура СохранитьДанныеАутентификацииИПродолжить()
	
	Если ПустаяСтрока(Логин) И Не ПустаяСтрока(Пароль) Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru = 'Введите код пользователя для авторизации на сайте фирмы ""1С"".'"),, "Логин");
		Возврат;
	КонецЕсли;
		
	Если ПустаяСтрока(Логин) Тогда
		СохранитьДанныеАутентификации(Неопределено, Ложь, Ложь);
		Результат = КодВозвратаДиалога.Отмена;
	Иначе
		ОписаниеОшибки = "";
		ЛогинИПароль = Новый Структура("Логин,Пароль", Логин, Пароль);
		СохранитьДанныеАутентификации(ЛогинИПароль, ПарольИзменен, ЗапомнитьПароль, ОписаниеОшибки);
		
		Если НЕ ПустаяСтрока(ОписаниеОшибки) Тогда
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ОписаниеОшибки,, "Логин");
			Возврат;
		ИначеЕсли ЗапомнитьПароль Тогда
			ТекстОповещения = НСтр("ru = 'Подключено успешно, настройки сохранены.'");
			ПоказатьОповещениеПользователя(ТекстОповещения);
		КонецЕсли;
		Результат = Новый Структура("Логин,Пароль", ЛогинИПароль.Логин, ЛогинИПароль.Пароль);
	КонецЕсли;
	Закрыть(Результат);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервереБезКонтекста
Процедура СохранитьДанныеАутентификации(Аутентификация, ПарольИзменен, ЗапомнитьПароль, ОписаниеОшибки = "")
	
	Если Аутентификация = Неопределено Тогда
		СтандартныеПодсистемыСервер.СохранитьПараметрыАутентификацииНаСайте(Аутентификация);
		Возврат;
	КонецЕсли;
	
	Если НЕ ПарольИзменен Тогда
		ПредыдущаяАутентификация = СтандартныеПодсистемыСервер.ПараметрыАутентификацииНаСайте();
		Если ПредыдущаяАутентификация <> Неопределено Тогда
			Аутентификация.Пароль = ПредыдущаяАутентификация.Пароль;
		КонецЕсли;
	КонецЕсли;
	
	Если ЗапомнитьПароль Тогда
		Если ПараметрыАутентификацииКорректные(Аутентификация, ОписаниеОшибки) Тогда
			СтандартныеПодсистемыСервер.СохранитьПараметрыАутентификацииНаСайте(Аутентификация);
		КонецЕсли;
	Иначе
		АутентификацияДляСохранения  = Новый Структура("Логин, Пароль", Аутентификация.Логин, Неопределено);
		СтандартныеПодсистемыСервер.СохранитьПараметрыАутентификацииНаСайте(АутентификацияДляСохранения);
	КонецЕсли;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ПараметрыАутентификацииКорректные(ПараметрыАутентификацииНаСайте, ОписаниеОшибки = "")
	
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


#КонецОбласти
