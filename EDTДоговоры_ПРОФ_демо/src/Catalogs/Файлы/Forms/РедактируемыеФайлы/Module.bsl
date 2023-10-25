////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;

	Если Не ОбщегоНазначения.ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка) Тогда
		Возврат;
	КонецЕсли;
	
	Пользователь = Пользователи.ТекущийПользователь();
	СписокФайлов.Параметры.УстановитьЗначениеПараметра("Редактирует", Пользователь);
	
	ПоказыватьКолонкуРазмер = РаботаСФайламиВызовСервера.ПолучитьПоказыватьКолонкуРазмер();
	Если ПоказыватьКолонкуРазмер = Ложь Тогда
		Элементы.ТекущаяВерсияРазмер.Видимость = Ложь;
		Элементы.Список.Шапка = Ложь;
	КонецЕсли;
	
КонецПроцедуры


// Обработка события Выбор у списка 
//
&НаКлиенте
Процедура СписокВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ДанныеФайла = РаботаСФайламиВызовСервера.ДанныеФайлаДляОткрытия(ВыбраннаяСтрока, Неопределено, УникальныйИдентификатор);	
	КомандыРаботыСФайламиКлиент.Открыть(ДанныеФайла);	
	
КонецПроцедуры

&НаКлиенте
Процедура СписокПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа)
	Отказ = Истина;
КонецПроцедуры

&НаКлиенте
Процедура ЗакончитьРедактирование(Команда)
	
	Если Элементы.Список.ТекущаяСтрока = Неопределено Тогда 
		Возврат;
	КонецЕсли;
	
	ПараметрыОбновленияФайла = РаботаСФайламиКлиент.ПараметрыОбновленияФайла(Неопределено, 
		Элементы.Список.ТекущаяСтрока, УникальныйИдентификатор);
	ПараметрыОбновленияФайла.ХранитьВерсии = Элементы.Список.ТекущиеДанные.ХранитьВерсии;
	ПараметрыОбновленияФайла.РедактируетТекущийПользователь = Истина;
	ПараметрыОбновленияФайла.Редактирует = Элементы.Список.ТекущиеДанные.Редактирует;
	РаботаСФайламиКлиент.ЗакончитьРедактированиеСОповещением(ПараметрыОбновленияФайла);
		
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьФайл(Команда)
	
	Если Элементы.Список.ТекущаяСтрока = Неопределено Тогда 
		Возврат;
	КонецЕсли;
	
	ДанныеФайла = РаботаСФайламиВызовСервера.ДанныеФайлаДляОткрытия(Элементы.Список.ТекущаяСтрока, Неопределено, УникальныйИдентификатор);
	КомандыРаботыСФайламиКлиент.Открыть(ДанныеФайла);
	
КонецПроцедуры

&НаКлиенте
Процедура Освободить(Команда)
	
	Если Элементы.Список.ТекущаяСтрока = Неопределено Тогда 
		Возврат;
	КонецЕсли;
	
	ТекущиеДанные = Элементы.Список.ТекущиеДанные;
	ПараметрыОсвобожденияФайла = РаботаСФайламиКлиент.ПараметрыОсвобожденияФайла(Неопределено, 
		Элементы.Список.ТекущаяСтрока);
	ПараметрыОсвобожденияФайла.ХранитьВерсии = ТекущиеДанные.ХранитьВерсии;	
	ПараметрыОсвобожденияФайла.РедактируетТекущийПользователь = Истина;	
	ПараметрыОсвобожденияФайла.Редактирует = ТекущиеДанные.Редактирует;	
	РаботаСФайламиКлиент.ОсвободитьФайлСОповещением(ПараметрыОсвобожденияФайла);
		
КонецПроцедуры

&НаКлиенте
Процедура СохранитьИзменения(Команда)
	
	Если Элементы.Список.ТекущаяСтрока = Неопределено Тогда 
		Возврат;
	КонецЕсли;
	
	РаботаСФайламиКлиент.СохранитьИзмененияФайлаСОповещением(
		Неопределено,
		Элементы.Список.ТекущаяСтрока,
		УникальныйИдентификатор);
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьКаталогФайла(Команда)
	
	Если Элементы.Список.ТекущаяСтрока = Неопределено Тогда 
		Возврат;
	КонецЕсли;
	
	ДанныеФайла = РаботаСФайламиВызовСервера.ДанныеФайлаДляОткрытия(
		Элементы.Список.ТекущаяСтрока, Неопределено, УникальныйИдентификатор);
	
	КомандыРаботыСФайламиКлиент.ОткрытьКаталогФайла(ДанныеФайла);
	
КонецПроцедуры

&НаКлиенте
Процедура СохранитьКак(Команда)
	
	Если Элементы.Список.ТекущаяСтрока = Неопределено Тогда 
		Возврат;
	КонецЕсли;
	
	ДанныеФайла = РаботаСФайламиВызовСервера.ДанныеФайлаДляСохранения(
		Элементы.Список.ТекущаяСтрока, 
		Неопределено, 
		УникальныйИдентификатор);
	
	КомандыРаботыСФайламиКлиент.СохранитьКак(ДанныеФайла, УникальныйИдентификатор);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьИзФайлаНаДиске(Команда)
	Если Элементы.Список.ТекущаяСтрока = Неопределено Тогда 
		Возврат;
	КонецЕсли;
	
	ДанныеФайла = РаботаСФайламиВызовСервера.ДанныеФайлаИРабочийКаталог(Элементы.Список.ТекущаяСтрока);
	
	РаботаСФайламиКлиент.ОбновитьИзФайлаНаДискеСОповещением(
		Неопределено,
		ДанныеФайла,
		УникальныйИдентификатор);
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьДоступностьКоманд()
	
	Доступность = Элементы.Список.ТекущаяСтрока <> Неопределено;
	
	Элементы.ЗакончитьРедактирование.Доступность = Доступность;
	Элементы.СписокКонтекстноеМеню.ПодчиненныеЭлементы.КонтекстноеМенюСписокЗакончитьРедактирование.Доступность = Доступность;
	
	Элементы.ОткрытьФайл.Доступность = Доступность;
	Элементы.СписокКонтекстноеМеню.ПодчиненныеЭлементы.КонтекстноеМенюСписокОткрытьФайл.Доступность = Доступность;
	
	Элементы.Изменить.Доступность = Доступность;
	
	Элементы.СписокКонтекстноеМеню.ПодчиненныеЭлементы.КонтекстноеМенюСписокСохранитьИзменения.Доступность = Доступность;
	Элементы.СписокКонтекстноеМеню.ПодчиненныеЭлементы.КонтекстноеМенюСписокОткрытьКаталогФайла.Доступность = Доступность;
	Элементы.СписокКонтекстноеМеню.ПодчиненныеЭлементы.КонтекстноеМенюСписокСохранитьКак.Доступность = Доступность;
	Элементы.СписокКонтекстноеМеню.ПодчиненныеЭлементы.КонтекстноеМенюСписокОсвободить.Доступность = Доступность;
	Элементы.СписокКонтекстноеМеню.ПодчиненныеЭлементы.КонтекстноеМенюСписокОбновитьИзФайлаНаДиске.Доступность = Доступность;
	
	Элементы.ЗакончитьВсе.Доступность = Доступность;
	
КонецПроцедуры

&НаКлиенте
Процедура СписокПриАктивизацииСтроки(Элемент)
	
	УстановитьДоступностьКоманд();
	                                       	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ПолучитьСписокЗанятыхФайлов()
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	Файлы.Ссылка КАК Ссылка
		|ИЗ
		|	Справочник.Файлы КАК Файлы
		|ГДЕ
		|	Файлы.Редактирует = &ТекущийПользователь";
		
	Запрос.УстановитьПараметр("ТекущийПользователь", Пользователи.ТекущийПользователь());
	
	МассивФайлов = Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Ссылка");
	
	Возврат МассивФайлов;
	
КонецФункции

&НаКлиенте
Процедура ЗакончитьВсе(Команда)
	
	ЗанятыеФайлы = ПолучитьСписокЗанятыхФайлов();
		
	Если ЗанятыеФайлы.Количество() = 0 Тогда
		ПоказатьПредупреждение(, НСтр("ru = 'Вами не занято ни одного файла.'"));
		Возврат;
	КонецЕсли;
	
	Обработчик = Новый ОписаниеОповещения("ОбновитьСписокФайлов", ЭтотОбъект);
	
	РаботаСФайламиКлиент.ЗакончитьРедактированиеПоСсылкам(
		Обработчик,
		ЗанятыеФайлы,
		УникальныйИдентификатор,
		Истина, // СоздатьНовуюВерсию
		"", // КомментарийКВерсии
		Ложь, // ПоказыватьОповещение
		Истина); //ОсвобождатьБезВопросаФайлыКоторыхНетВРабочемКаталоге
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьСписокФайлов(Результат = Неопределено, ПараметрыВыполнения = Неопределено) Экспорт
	
	Элементы.Список.Обновить();
	
КонецПроцедуры

