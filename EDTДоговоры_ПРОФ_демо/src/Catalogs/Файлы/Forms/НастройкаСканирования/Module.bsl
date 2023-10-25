
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	Если Параметры.КомпонентаУстановлена Тогда
		Элементы.ВерсияКомпонентыСканирования.Видимость = Истина;
	Иначе
		Элементы.ВерсияКомпонентыСканирования.Видимость = Ложь;
	КонецЕсли;	
	
	ИдентификаторКлиента = Параметры.ИдентификаторКлиента;
	
	ПоказыватьДиалогСканера = 
		ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить("НастройкиСканирования/ПоказыватьДиалогСканера", 
			ИдентификаторКлиента);
	Если ПоказыватьДиалогСканера = Неопределено Тогда
		ПоказыватьДиалогСканера = Ложь;
		ХранилищеОбщихНастроек.Сохранить("НастройкиСканирования/ПоказыватьДиалогСканера", 
			ИдентификаторКлиента, ПоказыватьДиалогСканера);
	КонецЕсли;
	
	ИмяУстройства = 
		ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить("НастройкиСканирования/ИмяУстройства", ИдентификаторКлиента);
	Если ИмяУстройства = Неопределено Тогда
		ИмяУстройства = "";
		ХранилищеОбщихНастроек.Сохранить("НастройкиСканирования/ИмяУстройства", ИдентификаторКлиента, ИмяУстройства);
	КонецЕсли;
	
	ФорматСканированногоИзображения = 
		ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить("НастройкиСканирования/ФорматСканированногоИзображения", 
			ИдентификаторКлиента, Перечисления.ФорматыСканированногоИзображения.PNG);
	Если ФорматСканированногоИзображения.Пустая() Тогда
		ФорматСканированногоИзображения = Перечисления.ФорматыСканированногоИзображения.PNG;
		ХранилищеОбщихНастроек.Сохранить("НастройкиСканирования/ФорматСканированногоИзображения", 
			ИдентификаторКлиента, ФорматСканированногоИзображения);
	КонецЕсли;
	
	ФорматХраненияОдностраничный = 
		ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить("НастройкиСканирования/ФорматХраненияОдностраничный", 
			ИдентификаторКлиента, Перечисления.ФорматыХраненияОдностраничныхФайлов.PNG);
	Если ФорматХраненияОдностраничный.Пустая() Тогда
		ФорматХраненияОдностраничный = Перечисления.ФорматыХраненияОдностраничныхФайлов.PNG;
		ХранилищеОбщихНастроек.Сохранить("НастройкиСканирования/ФорматХраненияОдностраничный", 
			ИдентификаторКлиента, ФорматХраненияОдностраничный);
	КонецЕсли;
	
	ФорматХраненияМногостраничный = 
		ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить("НастройкиСканирования/ФорматХраненияМногостраничный", 
			ИдентификаторКлиента, Перечисления.ФорматыХраненияМногостраничныхФайлов.TIF);
	Если ФорматХраненияМногостраничный.Пустая() Тогда
		ФорматХраненияМногостраничный = Перечисления.ФорматыХраненияМногостраничныхФайлов.TIF;
		ХранилищеОбщихНастроек.Сохранить("НастройкиСканирования/ФорматХраненияМногостраничный", 
			ИдентификаторКлиента, ФорматХраненияМногостраничный);
	КонецЕсли;
	
	Разрешение = ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить("НастройкиСканирования/Разрешение", ИдентификаторКлиента);
	Цветность = ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить("НастройкиСканирования/Цветность", ИдентификаторКлиента);
	
	Поворот = ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить("НастройкиСканирования/Поворот", ИдентификаторКлиента);
	РазмерБумаги =  ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить("НастройкиСканирования/РазмерБумаги", ИдентификаторКлиента);
	
	ДвустороннееСканирование = ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить("НастройкиСканирования/ДвустороннееСканирование", 
		ИдентификаторКлиента);
	ИспользоватьImageMagickДляПреобразованияВPDF 
		= ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить("НастройкиСканирования/ИспользоватьImageMagickДляПреобразованияВPDF", 
			ИдентификаторКлиента);
	
	КачествоJPG =  ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить("НастройкиСканирования/КачествоJPG", 
		ИдентификаторКлиента);
	Если КачествоJPG = 0 Тогда
		КачествоJPG = 100;
	КонецЕсли;	
	
	СжатиеTIFF =  ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить("НастройкиСканирования/СжатиеTIFF", 
		ИдентификаторКлиента, Перечисления.ВариантыСжатияTIFF.БезСжатия);
	
	ПутьКПрограммеКонвертации =  ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить(
		"НастройкиСканирования/ПутьКПрограммеКонвертации", 
		ИдентификаторКлиента, "magick.exe");
	
	ФорматJPG = Перечисления.ФорматыСканированногоИзображения.JPG;
	ФорматTIF = Перечисления.ФорматыСканированногоИзображения.TIF;
	
	ФорматМногостраничныйTIF = Перечисления.ФорматыХраненияМногостраничныхФайлов.TIF;
	ФорматОдностраничныйPDF = Перечисления.ФорматыХраненияОдностраничныхФайлов.PDF;
	ФорматОдностраничныйJPG = Перечисления.ФорматыХраненияОдностраничныхФайлов.JPG;
	ФорматОдностраничныйTIF = Перечисления.ФорматыХраненияОдностраничныхФайлов.TIF;
	ФорматОдностраничныйPNG = Перечисления.ФорматыХраненияОдностраничныхФайлов.PNG;
	
	Если НЕ ИспользоватьImageMagickДляПреобразованияВPDF Тогда
		ФорматХраненияМногостраничный = ФорматМногостраничныйTIF;
	КонецЕсли;	
	
	Элементы.ГруппаФорматаХранения.Видимость = ИспользоватьImageMagickДляПреобразованияВPDF;
	
	Если ИспользоватьImageMagickДляПреобразованияВPDF Тогда
		Если ФорматХраненияОдностраничный = ФорматОдностраничныйPDF Тогда
			Элементы.КачествоJPG.Видимость = (ФорматСканированногоИзображения = ФорматJPG);
			Элементы.СжатиеTIFF.Видимость = (ФорматСканированногоИзображения = ФорматTIF);
		Иначе	
			Элементы.КачествоJPG.Видимость = (ФорматХраненияОдностраничный = ФорматОдностраничныйJPG);
			Элементы.СжатиеTIFF.Видимость = (ФорматХраненияОдностраничный = ФорматОдностраничныйTIF);
		КонецЕсли;
	Иначе	
		Элементы.КачествоJPG.Видимость = (ФорматСканированногоИзображения = ФорматJPG);
		Элементы.СжатиеTIFF.Видимость = (ФорматСканированногоИзображения = ФорматTIF);
	КонецЕсли;
	
	Элементы.ДекорацияОтступЭквивалентСжатие.Видимость 
		= (Элементы.КачествоJPG.Видимость Или Элементы.СжатиеTIFF.Видимость);
	
	ВидимостьДекораций = (ИспользоватьImageMagickДляПреобразованияВPDF 
		И (ФорматХраненияОдностраничный = ФорматОдностраничныйPDF));
	Элементы.ДекорацияФорматХраненияОдностраничный.Видимость = ВидимостьДекораций;
	Элементы.ДекорацияФорматСканированногоИзображения.Видимость = ВидимостьДекораций;
	
	ВидимостьФорматаСканирования = (ИспользоватьImageMagickДляПреобразованияВPDF 
		И (ФорматХраненияОдностраничный = ФорматОдностраничныйPDF)) ИЛИ (НЕ ИспользоватьImageMagickДляПреобразованияВPDF);
	Элементы.ГруппаФорматаСканирования.Видимость = ВидимостьФорматаСканирования;
	Элементы.ДекорацияОтступЭквивалентТип.Видимость = 
		Элементы.ГруппаФорматаСканирования.Видимость И Элементы.ГруппаФорматаХранения.Видимость;
	
	Элементы.ФорматХраненияМногостраничный.Доступность = ИспользоватьImageMagickДляПреобразованияВPDF;
	
	ФорматХраненияОдностраничныйПредыдущее = ФорматХраненияОдностраничный;
	
	Если НЕ ИспользоватьImageMagickДляПреобразованияВPDF Тогда
		Элементы.ФорматСканированногоИзображения.Заголовок = НСтр("ru = 'Формат'");
	Иначе
		Элементы.ФорматСканированногоИзображения.Заголовок = НСтр("ru = 'Тип'");
	КонецЕсли;	
	
КонецПроцедуры

&НаКлиенте
Функция СформироватьНастройку(Имя, Значение, ИдентификаторКлиента)
	
	Элемент = Новый Структура;
	Элемент.Вставить("Объект", "НастройкиСканирования/" + Имя);
	Элемент.Вставить("Настройка", ИдентификаторКлиента);
	Элемент.Вставить("Значение", Значение);
	Возврат Элемент;
	
КонецФункции	

&НаКлиенте
Процедура ОК(Команда)
	МассивСтруктур = Новый Массив;
	
	СистемнаяИнформация = Новый СистемнаяИнформация();
	ИдентификаторКлиента = СистемнаяИнформация.ИдентификаторКлиента;
	
	МассивСтруктур.Добавить (СформироватьНастройку("ПоказыватьДиалогСканера", ПоказыватьДиалогСканера, ИдентификаторКлиента));
	МассивСтруктур.Добавить (СформироватьНастройку("ИмяУстройства", ИмяУстройства, ИдентификаторКлиента));

	МассивСтруктур.Добавить (СформироватьНастройку("ФорматСканированногоИзображения", 
		ФорматСканированногоИзображения, ИдентификаторКлиента));
	МассивСтруктур.Добавить (СформироватьНастройку("ФорматХраненияОдностраничный", 
		ФорматХраненияОдностраничный, ИдентификаторКлиента));
	МассивСтруктур.Добавить (СформироватьНастройку("ФорматХраненияМногостраничный", 
		ФорматХраненияМногостраничный, ИдентификаторКлиента));
	МассивСтруктур.Добавить (СформироватьНастройку("Разрешение", Разрешение, ИдентификаторКлиента));
	МассивСтруктур.Добавить (СформироватьНастройку("Цветность", Цветность, ИдентификаторКлиента));
	МассивСтруктур.Добавить (СформироватьНастройку("Поворот", Поворот, ИдентификаторКлиента));
	МассивСтруктур.Добавить (СформироватьНастройку("РазмерБумаги", РазмерБумаги, ИдентификаторКлиента));
	МассивСтруктур.Добавить (СформироватьНастройку("ДвустороннееСканирование", 
		ДвустороннееСканирование, ИдентификаторКлиента));
	МассивСтруктур.Добавить (СформироватьНастройку("ИспользоватьImageMagickДляПреобразованияВPDF", 
		ИспользоватьImageMagickДляПреобразованияВPDF, ИдентификаторКлиента));
	МассивСтруктур.Добавить (СформироватьНастройку("КачествоJPG", КачествоJPG, ИдентификаторКлиента));
	МассивСтруктур.Добавить (СформироватьНастройку("СжатиеTIFF", СжатиеTIFF, ИдентификаторКлиента));
	
	ОбщегоНазначенияВызовСервера.ХранилищеОбщихНастроекСохранитьМассив(МассивСтруктур);
	Закрыть(КодВозвратаДиалога.ОК);
	
	ОбновитьПовторноИспользуемыеЗначения();
	
	Оповестить("ИзмененыНастройкиСканирования");
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьНомераОтсканированныхФайлов(Команда)
	ОткрытьФорму("РегистрСведений.НомераОтсканированныхФайлов.ФормаСписка");
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	ОбновитьСостояние();
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьСостояние()
	
	Элементы.ИмяУстройства.Доступность = Ложь;
	Элементы.ФорматСканированногоИзображения.Доступность = Ложь;
	Элементы.ФорматХраненияОдностраничный.Доступность = Ложь;
	Элементы.ФорматХраненияМногостраничный.Доступность = Ложь;
	Элементы.СжатиеTIFF.Доступность = Ложь;
	Элементы.КачествоJPG.Доступность = Ложь;
	Элементы.Разрешение.Доступность = Ложь;
	Элементы.Цветность.Доступность = Ложь;
	Элементы.Поворот.Доступность = Ложь;
	Элементы.РазмерБумаги.Доступность = Ложь;
	Элементы.ДвустороннееСканирование.Доступность = Ложь;
	Элементы.УстановитьСтандартныеНастройки.Доступность = Ложь;
	Элементы.ИспользоватьImageMagickДляПреобразованияВPDF.Доступность = Ложь;
	Элементы.ПоказыватьДиалогСканера.Доступность = Ложь;

	Если РаботаСоСканеромКлиент.ПроинициализироватьКомпоненту() Тогда
		
		Элементы.ВерсияКомпонентыСканирования.Видимость = Истина;
		
		Элементы.ВерсияКомпонентыСканирования.Ширина = 5; 
		ВерсияКомпонентыСканирования = РаботаСоСканеромКлиент.ВерсияКомпонентыСканирования();
		
		Если РаботаСоСканеромКлиент.ДоступнаКомандаСканировать() Тогда
			
			Элементы.ИмяУстройства.Доступность = Истина;
			
			Элементы.ИмяУстройства.СписокВыбора.Очистить();
			МассивУстройств = РаботаСоСканеромКлиент.ПолучитьУстройства();
			Для Каждого Строка Из МассивУстройств Цикл
				Элементы.ИмяУстройства.СписокВыбора.Добавить(Строка);
			КонецЦикла;
			
			Если Не ПустаяСтрока(ИмяУстройства) Тогда
				
				Элементы.ФорматСканированногоИзображения.Доступность = Истина;
				Элементы.ФорматХраненияОдностраничный.Доступность = Истина;
				Элементы.ФорматХраненияМногостраничный.Доступность = Истина;
				Элементы.СжатиеTIFF.Доступность = Истина;
				Элементы.КачествоJPG.Доступность = Истина;
				Элементы.Разрешение.Доступность = Истина;
				Элементы.Цветность.Доступность = Истина;
				Элементы.УстановитьСтандартныеНастройки.Доступность = Истина;
				
				Элементы.ИспользоватьImageMagickДляПреобразованияВPDF.Доступность = Истина;
				Элементы.ПоказыватьДиалогСканера.Доступность = Истина;
				
				ДвустороннееСканированиеЧисло = РаботаСоСканеромКлиент.ПолучитьНастройку(ИмяУстройства, "DUPLEX");
				Элементы.ДвустороннееСканирование.Доступность = (ДвустороннееСканированиеЧисло <> -1);
				
				Если Разрешение.Пустая() ИЛИ Цветность.Пустая() Тогда
					РазрешениеЧисло = РаботаСоСканеромКлиент.ПолучитьНастройку(ИмяУстройства, "XRESOLUTION");
					ЦветностьЧисло  = РаботаСоСканеромКлиент.ПолучитьНастройку(ИмяУстройства, "PIXELTYPE");
					ПоворотЧисло  = РаботаСоСканеромКлиент.ПолучитьНастройку(ИмяУстройства, "ROTATION");
					РазмерБумагиЧисло  = РаботаСоСканеромКлиент.ПолучитьНастройку(ИмяУстройства, "SUPPORTEDSIZES");
					
					Элементы.Поворот.Доступность = (ПоворотЧисло <> -1);
					Элементы.РазмерБумаги.Доступность = (РазмерБумагиЧисло <> -1);
					
					ДвустороннееСканирование = (ДвустороннееСканированиеЧисло = 1);
					
					РаботаСФайламиВызовСервера.ПреобразоватьПараметрыСканераВПеречисления(
						РазрешениеЧисло, ЦветностьЧисло, ПоворотЧисло, РазмерБумагиЧисло, 
						Разрешение, Цветность, Поворот, РазмерБумаги);
					РаботаСоСканеромКлиент.СохранитьВНастройкахПараметрыСканера(Разрешение, Цветность, Поворот, РазмерБумаги);
					
				Иначе
					Элементы.Поворот.Доступность = Не Поворот.Пустая();
					Элементы.РазмерБумаги.Доступность = Не РазмерБумаги.Пустая();
				КонецЕсли;	
				
			КонецЕсли;		
		Иначе
			Элементы.ИмяУстройства.Доступность = Ложь;
		КонецЕсли;
		
	Иначе
		
		КомпонентаНеУстановлена = Истина;
		ПодключитьОбработчикОжидания("НачатьУстановкуКомпоненты", 0.2, Истина);
		
		ВерсияКомпонентыСканирования = НСтр("ru= 'Компонента сканирования не установлена'");
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура НачатьУстановкуКомпоненты()
	
	ОписаниеОповещения = Новый ОписаниеОповещения(
		"НачатьУстановкуКомпонентыПослеВопроса",
		ЭтотОбъект);
		
	ТекстВопроса = Нстр("ru = 'Компонента сканирования не установлена. Установить компоненту?'");
		
	ПоказатьВопрос(ОписаниеОповещения, ТекстВопроса, РежимДиалогаВопрос.ДаНет,,КодВозвратаДиалога.Да);
	
КонецПроцедуры

&НаКлиенте
Процедура НачатьУстановкуКомпонентыПослеВопроса(Результат, ПараметрыЗаписи) Экспорт
	
	Если Результат <> КодВозвратаДиалога.Да Тогда 
		Закрыть();
		Возврат;
	КонецЕсли;

	Обработчик = Новый ОписаниеОповещения("УстановитьКомпонентуСканированияЗавершение", ЭтотОбъект);
	РаботаСоСканеромКлиент.УстановитьКомпоненту(Обработчик);
	
КонецПроцедуры	

&НаКлиенте
Процедура УстановитьКомпонентуСканирования(Команда)
	
	Обработчик = Новый ОписаниеОповещения("УстановитьКомпонентуСканированияЗавершение", ЭтотОбъект);
	РаботаСоСканеромКлиент.УстановитьКомпоненту(Обработчик);
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьКомпонентуСканированияЗавершение(Результат, ПараметрыВыполнения) Экспорт
	ОбновитьСостояние();
КонецПроцедуры

&НаКлиенте
Процедура ИмяУстройстваПриИзменении(Элемент)
	ПрочитатьНастройкиСканера();
КонецПроцедуры

&НаКлиенте
Процедура ИмяУстройстваОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	Если ИмяУстройства = ВыбранноеЗначение Тогда // Ничего не изменилось - ничего не делаем.
		СтандартнаяОбработка = Ложь;
	КонецЕсли;	
КонецПроцедуры

&НаКлиенте
Процедура ПрочитатьНастройкиСканера()
	
	Элементы.ФорматСканированногоИзображения.Доступность = Не ПустаяСтрока(ИмяУстройства);
	Элементы.Разрешение.Доступность = Не ПустаяСтрока(ИмяУстройства);
	Элементы.Цветность.Доступность = Не ПустаяСтрока(ИмяУстройства);
	Элементы.ДвустороннееСканирование.Доступность = Ложь;
	Элементы.УстановитьСтандартныеНастройки.Доступность = Не ПустаяСтрока(ИмяУстройства);
	
	Элементы.ФорматХраненияОдностраничный.Доступность = Не ПустаяСтрока(ИмяУстройства);
	Элементы.ФорматХраненияМногостраничный.Доступность = Не ПустаяСтрока(ИмяУстройства);
	Элементы.СжатиеTIFF.Доступность = Не ПустаяСтрока(ИмяУстройства);
	Элементы.КачествоJPG.Доступность = Не ПустаяСтрока(ИмяУстройства);
	Элементы.ИспользоватьImageMagickДляПреобразованияВPDF.Доступность = Не ПустаяСтрока(ИмяУстройства);
	Элементы.ПоказыватьДиалогСканера.Доступность = Не ПустаяСтрока(ИмяУстройства);
	
	Если Не ПустаяСтрока(ИмяУстройства) Тогда
	
		ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
						 НСтр("ru = 'Идет сбор сведений о сканере ""%1""...'"), ИмяУстройства);
		Состояние(ТекстСообщения);
		
		РазрешениеЧисло = РаботаСоСканеромКлиент.ПолучитьНастройку(ИмяУстройства, "XRESOLUTION");
		ЦветностьЧисло  = РаботаСоСканеромКлиент.ПолучитьНастройку(ИмяУстройства, "PIXELTYPE");
		ПоворотЧисло  = РаботаСоСканеромКлиент.ПолучитьНастройку(ИмяУстройства, "ROTATION");
		РазмерБумагиЧисло  = РаботаСоСканеромКлиент.ПолучитьНастройку(ИмяУстройства, "SUPPORTEDSIZES");
		ДвустороннееСканированиеЧисло = РаботаСоСканеромКлиент.ПолучитьНастройку(ИмяУстройства, "DUPLEX");
		
		Элементы.Поворот.Доступность = (ПоворотЧисло <> -1);
		Элементы.РазмерБумаги.Доступность = (РазмерБумагиЧисло <> -1);
		
		Элементы.ДвустороннееСканирование.Доступность = (ДвустороннееСканированиеЧисло <> -1);
		ДвустороннееСканирование = (ДвустороннееСканированиеЧисло = 1);
		
		РаботаСФайламиВызовСервера.ПреобразоватьПараметрыСканераВПеречисления(
			РазрешениеЧисло, ЦветностьЧисло, ПоворотЧисло, РазмерБумагиЧисло,
			Разрешение, Цветность, Поворот, РазмерБумаги);
			
		Состояние();
	
	Иначе
		Элементы.Поворот.Доступность = Ложь;
		Элементы.РазмерБумаги.Доступность = Ложь;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьСтандартныеНастройки(Команда)
	
	ПрочитатьНастройкиСканера();
	
	КачествоJPG = 75;
	ФорматХраненияОдностраничный = ПредопределенноеЗначение("Перечисление.ФорматыХраненияОдностраничныхФайлов.JPG");
	Цветность = ПредопределенноеЗначение("Перечисление.ЦветностиИзображения.Цветное");

КонецПроцедуры

&НаКлиенте
Процедура ФорматСканированногоИзображенияПриИзменении(Элемент)
	
	Если ИспользоватьImageMagickДляПреобразованияВPDF Тогда
		Если ФорматХраненияОдностраничный = ФорматОдностраничныйPDF Тогда
			Элементы.КачествоJPG.Видимость = (ФорматСканированногоИзображения = ФорматJPG);
			Элементы.СжатиеTIFF.Видимость = (ФорматСканированногоИзображения = ФорматTIF);
		Иначе	
			Элементы.КачествоJPG.Видимость = (ФорматХраненияОдностраничный = ФорматОдностраничныйJPG);
			Элементы.СжатиеTIFF.Видимость = (ФорматХраненияОдностраничный = ФорматОдностраничныйTIF);
		КонецЕсли;
	Иначе	
		Элементы.КачествоJPG.Видимость = (ФорматСканированногоИзображения = ФорматJPG);
		Элементы.СжатиеTIFF.Видимость = (ФорматСканированногоИзображения = ФорматTIF);
	КонецЕсли;
	
	Элементы.ДекорацияОтступЭквивалентСжатие.Видимость 
		= (Элементы.КачествоJPG.Видимость Или Элементы.СжатиеTIFF.Видимость);
	
КонецПроцедуры

&НаСервере
Функция ПреобразоватьФорматСканированияВФорматХранения(ФорматСканирования)
	
	Если ФорматСканирования = Перечисления.ФорматыСканированногоИзображения.BMP Тогда
		Возврат Перечисления.ФорматыХраненияОдностраничныхФайлов.BMP;
	ИначеЕсли ФорматСканирования = Перечисления.ФорматыСканированногоИзображения.GIF Тогда
		Возврат Перечисления.ФорматыХраненияОдностраничныхФайлов.GIF;
	ИначеЕсли ФорматСканирования = Перечисления.ФорматыСканированногоИзображения.JPG Тогда
		Возврат Перечисления.ФорматыХраненияОдностраничныхФайлов.JPG;
	ИначеЕсли ФорматСканирования = Перечисления.ФорматыСканированногоИзображения.PNG Тогда
		Возврат Перечисления.ФорматыХраненияОдностраничныхФайлов.PNG; 
	ИначеЕсли ФорматСканирования = Перечисления.ФорматыСканированногоИзображения.TIF Тогда
		Возврат Перечисления.ФорматыХраненияОдностраничныхФайлов.TIF;
	КонецЕсли;
	
	Возврат Перечисления.ФорматыХраненияОдностраничныхФайлов.PNG; 
	
КонецФункции	

&НаСервере
Функция ПреобразоватьФорматХраненияВФорматСканирования(ФорматХранения)
	
	Если ФорматХранения = Перечисления.ФорматыХраненияОдностраничныхФайлов.BMP Тогда
		Возврат Перечисления.ФорматыСканированногоИзображения.BMP;
	ИначеЕсли ФорматХранения = Перечисления.ФорматыХраненияОдностраничныхФайлов.GIF Тогда
		Возврат Перечисления.ФорматыСканированногоИзображения.GIF;
	ИначеЕсли ФорматХранения = Перечисления.ФорматыХраненияОдностраничныхФайлов.JPG Тогда
		Возврат Перечисления.ФорматыСканированногоИзображения.JPG;
	ИначеЕсли ФорматХранения = Перечисления.ФорматыХраненияОдностраничныхФайлов.PNG Тогда
		Возврат Перечисления.ФорматыСканированногоИзображения.PNG; 
	ИначеЕсли ФорматХранения = Перечисления.ФорматыХраненияОдностраничныхФайлов.TIF Тогда
		Возврат Перечисления.ФорматыСканированногоИзображения.TIF;
	КонецЕсли;
	
	Возврат ФорматСканированногоИзображения; 
	
КонецФункции	

&НаСервере
Процедура ОтработатьИзмененияИспользоватьImageMagick()
	
	Если НЕ ИспользоватьImageMagickДляПреобразованияВPDF Тогда
		ФорматХраненияМногостраничный = ФорматМногостраничныйTIF;
		ФорматСканированногоИзображения = ПреобразоватьФорматХраненияВФорматСканирования(ФорматХраненияОдностраничный);
		Элементы.ФорматСканированногоИзображения.Заголовок = НСтр("ru = 'Формат'");
	Иначе
		ФорматХраненияОдностраничный = ПреобразоватьФорматСканированияВФорматХранения(ФорматСканированногоИзображения);
		Элементы.ФорматСканированногоИзображения.Заголовок = НСтр("ru = 'Тип'");
	КонецЕсли;	
	
	ВидимостьДекораций = (ИспользоватьImageMagickДляПреобразованияВPDF 
		И (ФорматХраненияОдностраничный = ФорматОдностраничныйPDF));
	Элементы.ДекорацияФорматХраненияОдностраничный.Видимость = ВидимостьДекораций;
	Элементы.ДекорацияФорматСканированногоИзображения.Видимость = ВидимостьДекораций;
	
	ВидимостьФорматаСканирования = (ИспользоватьImageMagickДляПреобразованияВPDF 
		И (ФорматХраненияОдностраничный = ФорматОдностраничныйPDF)) ИЛИ (НЕ ИспользоватьImageMagickДляПреобразованияВPDF);
	Элементы.ГруппаФорматаСканирования.Видимость = ВидимостьФорматаСканирования;
	
	Элементы.ФорматХраненияМногостраничный.Доступность = ИспользоватьImageMagickДляПреобразованияВPDF;
	Элементы.ГруппаФорматаХранения.Видимость = ИспользоватьImageMagickДляПреобразованияВPDF;	
	
	Элементы.ДекорацияОтступЭквивалентТип.Видимость = 
		Элементы.ГруппаФорматаСканирования.Видимость И Элементы.ГруппаФорматаХранения.Видимость;
		
	Элементы.ДекорацияОтступЭквивалентСжатие.Видимость 
		= (Элементы.КачествоJPG.Видимость Или Элементы.СжатиеTIFF.Видимость);
		
КонецПроцедуры


&НаКлиенте
Процедура ИспользоватьImageMagickДляПреобразованияВPDFПриИзменении(Элемент)
	
	ОтработатьИзмененияИспользоватьImageMagick();
	
КонецПроцедуры

&НаСервере
Процедура ОтработатьИзмененияФорматХраненияОдностраничный()
	
	Элементы.ГруппаФорматаСканирования.Видимость = (ФорматХраненияОдностраничный = ФорматОдностраничныйPDF);
	
	Если ФорматХраненияОдностраничный = ФорматОдностраничныйPDF Тогда
		ФорматСканированногоИзображения = ПреобразоватьФорматХраненияВФорматСканирования(ФорматХраненияОдностраничныйПредыдущее);
	КонецЕсли;	
	
	ВидимостьДекораций = (ИспользоватьImageMagickДляПреобразованияВPDF 
		И (ФорматХраненияОдностраничный = ФорматОдностраничныйPDF));
	Элементы.ДекорацияФорматХраненияОдностраничный.Видимость = ВидимостьДекораций;
	Элементы.ДекорацияФорматСканированногоИзображения.Видимость = ВидимостьДекораций;
	
	Если ИспользоватьImageMagickДляПреобразованияВPDF Тогда
		Если ФорматХраненияОдностраничный = ФорматОдностраничныйPDF Тогда
			Элементы.КачествоJPG.Видимость = (ФорматСканированногоИзображения = ФорматJPG);
			Элементы.СжатиеTIFF.Видимость = (ФорматСканированногоИзображения = ФорматTIF);
		Иначе	
			Элементы.КачествоJPG.Видимость = (ФорматХраненияОдностраничный = ФорматОдностраничныйJPG);
			Элементы.СжатиеTIFF.Видимость = (ФорматХраненияОдностраничный = ФорматОдностраничныйTIF);
		КонецЕсли;
	Иначе	
		Элементы.КачествоJPG.Видимость = (ФорматСканированногоИзображения = ФорматJPG);
		Элементы.СжатиеTIFF.Видимость = (ФорматСканированногоИзображения = ФорматTIF);
	КонецЕсли;
	
	Элементы.ДекорацияОтступЭквивалентТип.Видимость = 
		Элементы.ГруппаФорматаСканирования.Видимость И Элементы.ГруппаФорматаХранения.Видимость;
	
	Элементы.ДекорацияОтступЭквивалентСжатие.Видимость 
		= (Элементы.КачествоJPG.Видимость Или Элементы.СжатиеTIFF.Видимость);
	
	ФорматХраненияОдностраничныйПредыдущее = ФорматХраненияОдностраничный;
	
КонецПроцедуры

&НаКлиенте
Процедура ФорматХраненияОдностраничныйПриИзменении(Элемент)
	
	ОтработатьИзмененияФорматХраненияОдностраничный();
	
КонецПроцедуры
