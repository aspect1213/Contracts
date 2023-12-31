&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	Файл = Параметры.Файл;
	ДанныеФайла = Параметры.ДанныеФайла;
	ИмяОткрываемогоФайла = Параметры.ИмяОткрываемогоФайла;
	Если Параметры.Свойство("УникальныйИдентификатор") Тогда
		ИдентификаторРодительскойФормы = Параметры.УникальныйИдентификатор;
	КонецЕсли;
	
	КодФайла = Файл.Код;
	
	Если ДанныеФайла.РедактируетТекущийПользователь Тогда
		РежимРедактирования = Истина;
	КонецЕсли;	
	
	Если ДанныеФайла.Версия <> ДанныеФайла.ТекущаяВерсия Тогда
		РежимРедактирования = Ложь;
	КонецЕсли;	
	
	Элементы.Текст.ТолькоПросмотр = Не РежимРедактирования;
	Элементы.ПоказатьОтличия.Видимость = Не ОбщегоНазначенияКлиентСервер.ЭтоLinuxКлиент();
	Элементы.Редактировать.Доступность = Не РежимРедактирования;
	Элементы.ЗакончитьРедактирование.Доступность = РежимРедактирования;
	Элементы.ЗаписатьИЗакрыть.Доступность = РежимРедактирования;
	Элементы.Записать.Доступность = РежимРедактирования;
	
	Если ДанныеФайла.Версия <> ДанныеФайла.ТекущаяВерсия Тогда
		Элементы.Редактировать.Доступность = Ложь;
	КонецЕсли;	
	
	ЗаголовокСтрока = ФайловыеФункцииКлиентСервер.ПолучитьИмяСРасширением(ДанныеФайла.ПолноеНаименованиеВерсии, 
		ДанныеФайла.Расширение);
	Если Не РежимРедактирования Тогда
		ЗаголовокСтрока = ЗаголовокСтрока + НСтр("ru=' (только просмотр)'");
	КонецЕсли;
	Заголовок = ЗаголовокСтрока;
	
	Если ЗначениеЗаполнено(ДанныеФайла.Версия) Тогда
		КодировкаТекстаФайла = РаботаСФайламиВызовСервера.ПолучитьКодировкуВерсииФайла(ДанныеФайла.Версия);
		
		Если ЗначениеЗаполнено(КодировкаТекстаФайла) Тогда
			СписокКодировок = РаботаСоСтроками.ПолучитьСписокКодировок();
			ЭлементСписка = СписокКодировок.НайтиПоЗначению(КодировкаТекстаФайла);
			Если ЭлементСписка = Неопределено Тогда
				КодировкаПредставление = КодировкаТекстаФайла;
			Иначе	
				КодировкаПредставление = ЭлементСписка.Представление;
			КонецЕсли;
		Иначе	
			КодировкаПредставление = НСтр("ru='По умолчанию'");
		КонецЕсли;
		
	КонецЕсли;	
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	КлючУникальности = КодФайла;
	
	КодировкаТекстаДляЧтения = КодировкаТекстаФайла;
	Если Не ЗначениеЗаполнено(КодировкаТекстаДляЧтения) Тогда
		КодировкаТекстаДляЧтения = Неопределено;
	КонецЕсли;	
	
	Текст.Прочитать(ИмяОткрываемогоФайла, КодировкаТекстаДляЧтения);
	
КонецПроцедуры

&НаКлиенте
Процедура СохранитьКак(Команда)
	
	// выбираем путь к файлу на диске
	ВыборФайла = Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.Сохранение);
	ВыборФайла.МножественныйВыбор = Ложь;
	ИмяСРасширением = ФайловыеФункцииКлиентСервер.ПолучитьИмяСРасширением(ДанныеФайла.ПолноеНаименованиеВерсии, 
		ДанныеФайла.Расширение);
	ВыборФайла.ПолноеИмяФайла = ИмяСРасширением;
	Фильтр = СтрШаблон(
		НСтр("ru = 'Все файлы (*.%1)|*.%1'"), ДанныеФайла.Расширение);
	ВыборФайла.Фильтр = Фильтр;
	
	Если ВыборФайла.Выбрать() Тогда
		
		ВыбранноеПолноеИмяФайла = ВыборФайла.ПолноеИмяФайла;
		
		КодировкаТекстаДляЗаписи = КодировкаТекстаФайла;
		Если Не ЗначениеЗаполнено(КодировкаТекстаДляЗаписи) Тогда
			КодировкаТекстаДляЗаписи = Неопределено;
		КонецЕсли;	
		
		Текст.Записать(ВыбранноеПолноеИмяФайла, КодировкаТекстаДляЗаписи);
		
		Состояние(НСтр("ru = 'Файл успешно сохранен'"), , ВыбранноеПолноеИмяФайла);
		
	КонецЕсли;	
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьКарточку(Команда)
	
	ПоказатьЗначение(,Файл);
	
КонецПроцедуры

&НаКлиенте
Процедура ВнешнийРедактор(Команда)
	
	ЗаписатьТекст();
	РаботаСФайламиКлиент.ВыполнитьЗапускПриложения(ИмяОткрываемогоФайла);
	Закрыть();
	
КонецПроцедуры

&НаКлиенте
Процедура Редактировать(Команда)
	
	КомандыРаботыСФайламиКлиент.Редактировать(Файл, ПолучитьУникальныйИдентификатор());
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "ФайлРедактировался" И Параметр = Файл Тогда
		РежимРедактирования = Истина;
		УстановитьДоступностьКоманд();
	КонецЕсли;
	
	Если ИмяСобытия = "Запись_Файл" И Параметр.Событие = "ДанныеФайлаИзменены" Тогда
		
		ФайлВОповещении = Неопределено;
		
		Если ТипЗнч(Параметр) = Тип("Структура") Тогда
			ФайлВОповещении = Параметр.Файл;
		Иначе	
			ФайлВОповещении = Источник;
		КонецЕсли;	
		
		Если ФайлВОповещении = Файл Тогда
			
			ДанныеФайла = РаботаСФайламиВызовСервера.ДанныеФайла(Файл);
			
			РежимРедактирования = Ложь;
			
			Если ДанныеФайла.РедактируетТекущийПользователь Тогда
				РежимРедактирования = Истина;
			КонецЕсли;	
			
			Если ДанныеФайла.Версия <> ДанныеФайла.ТекущаяВерсия Тогда
				РежимРедактирования = Ложь;
			КонецЕсли;	
			
			УстановитьДоступностьКоманд();
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура Записать(Команда)
	
	ЗаписатьТекст();
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаписатьТекст()
	
	Если Модифицированность Тогда
		
		КодировкаТекстаДляЗаписи = КодировкаТекстаФайла;
		Если Не ЗначениеЗаполнено(КодировкаТекстаДляЗаписи) Тогда
			КодировкаТекстаДляЗаписи = Неопределено;
		КонецЕсли;	
		
		Текст.Записать(ИмяОткрываемогоФайла, КодировкаТекстаДляЗаписи);
		Модифицированность = Ложь;
		
	КонецЕсли;	
	
КонецПроцедуры

&НаКлиенте
Функция ПолучитьУникальныйИдентификатор()
	
	Если ЗначениеЗаполнено(ИдентификаторРодительскойФормы) Тогда
		Возврат ИдентификаторРодительскойФормы;
	КонецЕсли;
	
	Возврат УникальныйИдентификатор;
	
КонецФункции	

&НаКлиенте
Процедура ЗакончитьРедактирование(Команда)
	
	ЗаписатьТекст();
	
	Обработчик = Новый ОписаниеОповещения("УстановитьДоступностьФайловыхКоманд", ЭтотОбъект);
	
	ПараметрыОбновленияФайла = РаботаСФайламиКлиент.ПараметрыОбновленияФайла(Обработчик, Файл, 
		ПолучитьУникальныйИдентификатор());
	ПараметрыОбновленияФайла.Кодировка = КодировкаТекстаФайла;
	РаботаСФайламиКлиент.ЗакончитьРедактированиеСОповещением(ПараметрыОбновленияФайла);
		
КонецПроцедуры

&НаКлиенте
Процедура УстановитьДоступностьФайловыхКоманд(Результат = Неопределено, ПараметрыВыполнения = Неопределено) Экспорт
	
	Если Результат = Истина Тогда
		РежимРедактирования = Ложь;
	КонецЕсли;	
	УстановитьДоступностьКоманд();
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, СтандартнаяОбработка)
	
	Если Модифицированность И Не БылЗаданВопросПередЗакрытием Тогда
		
		Отказ = Истина;
		
		ИмяИРасширение = ФайловыеФункцииКлиентСервер.ПолучитьИмяСРасширением(ДанныеФайла.ПолноеНаименованиеВерсии, 
			ДанныеФайла.Расширение);
			
		ТекстВопроса = СтрШаблон(
			НСтр("ru ='Файл ""%1"" был изменен.
			|Сохранить изменения?'"), ИмяИРасширение);
			
		Обработчик = Новый ОписаниеОповещения("ПослеВопросаПередЗакрытием", ЭтотОбъект);
		
		Кнопки = Новый СписокЗначений;
		Кнопки.Добавить(КодВозвратаДиалога.Да, НСтр("ru = 'Сохранить'"));
		Кнопки.Добавить(КодВозвратаДиалога.Нет, НСтр("ru = 'Не сохранять'"));
		Кнопки.Добавить(КодВозвратаДиалога.Отмена);
		
		ПоказатьВопрос(Обработчик, ТекстВопроса, Кнопки);
		БылЗаданВопросПередЗакрытием = Истина;
		
	ИначеЕсли РежимРедактирования И Не БылЗаданВопросПередЗакрытием Тогда	
		
		Обработчик = Новый ОписаниеОповещения("УстановитьДоступностьФайловыхКоманд", ЭтотОбъект);
		
		ПараметрыОбновленияФайла = РаботаСФайламиКлиент.ПараметрыОбновленияФайла(Обработчик, Файл, 
			ПолучитьУникальныйИдентификатор());
		ПараметрыОбновленияФайла.СоздатьНовуюВерсию = ДанныеФайла.ХранитьВерсии;
		ПараметрыОбновленияФайла.Кодировка = КодировкаТекстаФайла;
		РаботаСФайламиКлиент.ЗакончитьРедактированиеСОповещением(ПараметрыОбновленияФайла);
		
	КонецЕсли;	
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеВопросаПередЗакрытием(Ответ, ПараметрыВыполнения) Экспорт
	
	Если Ответ = КодВозвратаДиалога.Нет Тогда 
		Закрыть();
	ИначеЕсли Ответ = КодВозвратаДиалога.Да Тогда 
		
		ЗаписатьТекст();

		Обработчик = Новый ОписаниеОповещения("УстановитьДоступностьФайловыхКоманд", ЭтотОбъект);
		
		ПараметрыОбновленияФайла = РаботаСФайламиКлиент.ПараметрыОбновленияФайла(Обработчик, Файл, 
			ПолучитьУникальныйИдентификатор());
		ПараметрыОбновленияФайла.Кодировка = КодировкаТекстаФайла;
		ПараметрыОбновленияФайла.СоздатьНовуюВерсию = ДанныеФайла.ХранитьВерсии;
		РаботаСФайламиКлиент.ЗакончитьРедактированиеСОповещением(ПараметрыОбновленияФайла);
		
		Модифицированность = Ложь;
		Закрыть();
		
	ИначеЕсли Ответ = КодВозвратаДиалога.Отмена Тогда 
		БылЗаданВопросПередЗакрытием = Ложь;
	КонецЕсли;	
	
КонецПроцедуры	

&НаКлиенте
Процедура ОбработкаВыбора(ВыбранноеЗначение, ИсточникВыбора)
	
	Если ВРег(ИсточникВыбора.ИмяФормы) = ВРег("Справочник.ВерсииФайлов.Форма.ФормаВыбораСпособаСравненияВерсий") Тогда
		
		Если ВыбранноеЗначение <> КодВозвратаДиалога.ОК Тогда
			Возврат;
		КонецЕсли;
		
		// Повторное чтение настройки
		СпособСравненияВерсийФайлов = ФайловыеФункцииСлужебныйКлиентСервер.ПерсональныеНастройкиРаботыСФайлами().СпособСравненияВерсийФайлов;
		Если СпособСравненияВерсийФайлов = Неопределено Тогда
			Возврат;
		КонецЕсли;
		
		ПродолжитьСравнениеВерсий(СпособСравненияВерсийФайлов);
		
	ИначеЕсли ВРег(ИсточникВыбора.ИмяФормы) = ВРег("Справочник.Файлы.Форма.ВыборКодировки") Тогда
		
		Если ТипЗнч(ВыбранноеЗначение) <> Тип("Структура") Тогда
			Возврат;
		КонецЕсли;
		
		КодировкаТекстаФайла = ВыбранноеЗначение.Значение;
		КодировкаПредставление = ВыбранноеЗначение.Представление;
		
		ПрочитатьТекст();
		
		РаботаСФайламиСлужебныйВызовСервера.ЗаписатьКодировкуВерсииФайлаИИзвлеченныйТекст(
			ДанныеФайла.Версия,
			КодировкаТекстаФайла,
			Текст.ПолучитьТекст());
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПоказатьОтличия(Команда)
	
	#Если НЕ ВебКлиент Тогда
		// Чтение настройки
		СпособСравненияВерсийФайлов = ФайловыеФункцииСлужебныйКлиентСервер.ПерсональныеНастройкиРаботыСФайлами().СпособСравненияВерсийФайлов;
		
		Если СпособСравненияВерсийФайлов = Неопределено Тогда 
			// Инициализация настройки
			ОткрытьФорму("Справочник.ВерсииФайлов.Форма.ФормаВыбораСпособаСравненияВерсий", , ЭтаФорма);
			Возврат;
		КонецЕсли;
		
		ПродолжитьСравнениеВерсий(СпособСравненияВерсийФайлов);
	#Иначе
		ПоказатьПредупреждение(, НСтр("ru = 'Сравнение версий в веб-клиенте не поддерживается.'"));
	#КонецЕсли

КонецПроцедуры

&НаКлиенте
Процедура УстановитьДоступностьКоманд()
	
	Элементы.Текст.ТолькоПросмотр = Не РежимРедактирования;
	Элементы.ПоказатьОтличия.Доступность = РежимРедактирования;
	Элементы.Редактировать.Доступность = Не РежимРедактирования;
	Элементы.ЗакончитьРедактирование.Доступность = РежимРедактирования;
	Элементы.ЗаписатьИЗакрыть.Доступность = РежимРедактирования;
	Элементы.Записать.Доступность = РежимРедактирования;
	
	ЗаголовокСтрока = ФайловыеФункцииКлиентСервер.ПолучитьИмяСРасширением(ДанныеФайла.ПолноеНаименованиеВерсии, 
		ДанныеФайла.Расширение);
	Если Не РежимРедактирования Тогда
		ЗаголовокСтрока = ЗаголовокСтрока + НСтр("ru=' (только просмотр)'");
	КонецЕсли;
	Заголовок = ЗаголовокСтрока;
	
КонецПроцедуры

&НаКлиенте
Процедура ПрочитатьТекст()
	
	Текст.Прочитать(ИмяОткрываемогоФайла, КодировкаТекстаФайла);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаписатьИЗакрыть(Команда)
	
	Если Модифицированность Тогда
		
		ЗаписатьТекст();
		
		Обработчик = Новый ОписаниеОповещения("ЗакрытьФорму", ЭтотОбъект);
			
		ПараметрыОбновленияФайла = РаботаСФайламиКлиент.ПараметрыОбновленияФайла(Обработчик, Файл, 
			ПолучитьУникальныйИдентификатор());
		ПараметрыОбновленияФайла.Кодировка = КодировкаТекстаФайла;
		РаботаСФайламиКлиент.ЗакончитьРедактированиеСОповещением(ПараметрыОбновленияФайла);
		
		Возврат;
		
	КонецЕсли;
	
	Закрыть();
	
КонецПроцедуры

&НаКлиенте
Процедура ЗакрытьФорму(Результат = Неопределено, ПараметрыВыполнения = Неопределено) Экспорт
	
	Если Результат = Истина Тогда
		Закрыть();
	КонецЕсли;	
	
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьКодировку(Команда)
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("ТекущаяКодировка", КодировкаТекстаФайла);
	ОткрытьФорму("Справочник.Файлы.Форма.ВыборКодировки", ПараметрыФормы, ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ПродолжитьСравнениеВерсий(СпособСравненияВерсийФайлов)
	#Если НЕ ВебКлиент Тогда
		
		ЗаписатьТекст();
		
		ДанныеФайлаДляСохранения = РаботаСФайламиВызовСервера.ДанныеФайлаДляСохранения(
			Файл, Неопределено, УникальныйИдентификатор);
		
		АдресФайла = ДанныеФайлаДляСохранения.НавигационнаяСсылкаТекущейВерсии;
		
		Если ДанныеФайла.ТекущаяВерсия <> ДанныеФайла.Версия Тогда
			АдресФайла = РаботаСФайламиСлужебныйВызовСервера.ПолучитьНавигационнуюСсылкуДляОткрытия(
				ДанныеФайла.Версия, УникальныйИдентификатор);
		КонецЕсли;
		
		ПутьКФайлу = ПолучитьИмяВременногоФайла(ДанныеФайла.Расширение);
		
		ПередаваемыеФайлы = Новый Массив;
		Описание = Новый ОписаниеПередаваемогоФайла(ПутьКФайлу, АдресФайла);
		ПередаваемыеФайлы.Добавить(Описание);
		
		// Сохраним Файл из БД на диск
		Если Не ПолучитьФайлы(ПередаваемыеФайлы,, ПутьКФайлу, Ложь) Тогда
			Возврат;
		КонецЕсли;
		
		РаботаСФайламиКлиент.СравнитьФайлы(ПутьКФайлу, ИмяОткрываемогоФайла, СпособСравненияВерсийФайлов);
		
	#КонецЕсли
КонецПроцедуры

&НаКлиенте
Процедура Печатать(Команда)
	
	#Если ВебКлиент Тогда 
		ПоказатьПредупреждение(, НСтр("ru = 'В Веб-клиенте печать файлов не поддерживается.'"));
		Возврат;
	#КонецЕсли
	
	СистемнаяИнфо = Новый СистемнаяИнформация;
	Если СистемнаяИнфо.ТипПлатформы <> ТипПлатформы.Windows_x86 
	   И СистемнаяИнфо.ТипПлатформы <> ТипПлатформы.Windows_x86_64 Тогда
		ПоказатьПредупреждение(, НСтр("ru = 'Печать файлов возможна только в Windows.'"));
		Возврат;
	КонецЕсли;
	
	Если РежимРедактирования Тогда
		ЗаписатьТекст();
	КонецЕсли;	
	
	РаботаСФайламиКлиент.НапечататьИзПриложенияПоИмениФайла(ИмяОткрываемогоФайла);
	
КонецПроцедуры
