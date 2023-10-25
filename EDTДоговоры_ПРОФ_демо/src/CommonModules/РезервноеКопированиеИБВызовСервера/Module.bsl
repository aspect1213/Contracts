////////////////////////////////////////////////////////////////////////////////
// Подсистема "Резервное копирование ИБ".
//
////////////////////////////////////////////////////////////////////////////////

#Область СлужебныеПроцедурыИФункции

// Устанавливает настройку в параметры резервного копирования. 
// 
// Параметры: 
//	ИмяЭлемента - Строка - имя параметра.
// 	ЗначениеЭлемента - Произвольный тип - значение параметра.
//
Процедура УстановитьЗначениеНастройки(ИмяЭлемента, ЗначениеЭлемента) Экспорт
	
	РезервноеКопированиеИБСервер.УстановитьЗначениеНастройки(ИмяЭлемента, ЗначениеЭлемента);
	
КонецПроцедуры

// Формирует значение ближайшего следующего автоматического резервного копирования в соответствии с расписанием.
//
// Параметры:
//	НачальнаяНастройка - Булево - признак начальной настройки.
//
Функция ДатаСледующегоАвтоматическогоКопирования(ОтложитьРезервноеКопирование = Ложь) Экспорт
	
	Результат = Новый Структура;
	НастройкиРезервногоКопирования = РезервноеКопированиеИБСервер.НастройкиРезервногоКопирования();
	
	ТекущаяДата = ТекущаяДатаСеанса();
	
	РасписаниеКопирования = НастройкиРезервногоКопирования.РасписаниеКопирования;
	ПериодПовтораВТечениеДня = РасписаниеКопирования.ПериодПовтораВТечениеДня;
	ПериодПовтораДней = РасписаниеКопирования.ПериодПовтораДней;
	
	Если ОтложитьРезервноеКопирование Тогда
		Значение = ТекущаяДата + 60 * 15;
	ИначеЕсли ПериодПовтораВТечениеДня <> 0 Тогда
		Значение = ТекущаяДата + ПериодПовтораВТечениеДня;
	ИначеЕсли ПериодПовтораДней <> 0 Тогда
		Значение = ТекущаяДата + ПериодПовтораДней * 3600 * 24;
	Иначе
		Значение = НачалоДня(КонецДня(ТекущаяДата) + 1);
	КонецЕсли;
	Результат.Вставить("МинимальнаяДатаСледующегоАвтоматическогоРезервногоКопирования", Значение);
	
	ЗаполнитьЗначенияСвойств(НастройкиРезервногоКопирования, Результат);
	РезервноеКопированиеИБСервер.УстановитьПараметрыРезервногоКопирования(НастройкиРезервногоКопирования);
	
	Возврат Результат;
	
КонецФункции

// Устанавливает дату последнего оповещения пользователя.
//
// Параметры: 
//	ДатаНапоминания - Дата - дата и время последнего оповещения пользователя о необходимости проведения резервного
//	                         копирования.
//
Процедура УстановитьДатуПоследнегоНапоминания(ДатаНапоминания) Экспорт
	
	РезервноеКопированиеИБСервер.УстановитьДатуПоследнегоНапоминания(ДатаНапоминания);
	
КонецПроцедуры

#КонецОбласти
