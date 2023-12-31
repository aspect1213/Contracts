////////////////////////////////////////////////////////////////////////////////
// Подсистема "Печать".
//
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Переопределяет таблицу возможных форматов для сохранения табличного документа.
// Вызывается из ОбщегоНазначения.НастройкиФорматовСохраненияТабличногоДокумента()
//
// Параметры:
//  ТаблицаФорматов - ТаблицаЗначений:
//                   *  ТипФайлаТабличногоДокумента - ТипФайлаТабличногоДокумента                 - значение в
//                                                                                                  платформе,
//                                                                                                  соответствующее
//                                                                                                  формату;
//                   *  Ссылка                      - ПеречислениеСсылка.ФорматыСохраненияОтчетов - ссылка на
//                                                                                                  метаданные, где
//                                                                                                  хранится
//                                                                                                  представление;
//                   *  Представление               - Строка -                                    - представление типа
//                                                             файла (заполняется из перечисления);
//                   *  Расширение                  - Строка -                                    - тип файла для
//                                                             операционной системы;
//                   *  Картинка                    - Картинка                                    - значок формата.
//
Процедура ПриЗаполненииНастроекФорматовСохраненияТабличногоДокумента(ТаблицаФорматов) Экспорт
	
КонецПроцедуры

// Переопределяет список команд печати, получаемый функцией УправлениеПечатью.КомандыПечатиФормы.
Процедура ПередДобавлениемКомандПечати(ИмяФормы, КомандыПечати, СтандартнаяОбработка) Экспорт
	
КонецПроцедуры

// Дополнительные настройки списка команд печати.
//
// Параметры:
//  НастройкиСписка - Структура - модификаторы списка команд печати.
//   * МенеджерКомандПечати     - МенеджерОбъекта - менеджер объекта, в котором формируется список команд печати;
//   * АвтоматическоеЗаполнение - Булево - заполнять команды печати из объектов, входящих в состав журнала.
//                                         Значение по умолчанию: Истина.
//
Процедура ПриПолученииНастроекСпискаКомандПечати(НастройкиСписка) Экспорт
	
КонецПроцедуры

// Определяет объекты, в которых есть процедура ДобавитьКомандыПечати().
//
// Параметры:
//  СписокОбъектов - Массив - список менеджеров объектов.
//
Процедура ПриОпределенииОбъектовСКомандамиПечати(СписокОбъектов) Экспорт
	
	//СписокОбъектов.Добавить(Справочники.Контрагенты);
	
КонецПроцедуры

// Вызывается после завершения вызова процедуры Печать менеджера печати объекта, имеет те же параметры.
// 
// Параметры:
//  МассивОбъектов - Массив - список объектов, для которых была выполнена процедура Печать;
//  ПараметрыПечати - Структура - произвольные параметры, переданные при вызове команды печати;
//  КоллекцияПечатныхФорм - ТаблицаЗначений - содержит табличные документы и дополнительную информацию;
//  ОбъектыПечати - СписокЗначений - соответствие между объектами и именами областей в табличных документах, где
//                                   значение - Объект, представление - имя области с объектом в табличных документах;
//  ПараметрыВывода - Структура - параметры, связанные с выводом табличных документов:
//   * ПараметрыОтправки - Структура - информация для заполнения письма при отправке печатной формы по электронной почте.
//                                     Содержит следующие поля (описание см. в общем модуле конфигурации
//                                     РаботаСПочтовымиСообщениямиКлиент в процедуре СоздатьНовоеПисьмо):
//    ** Получатель;
//    ** Тема,
//    ** Текст.
Процедура ПриПечати(МассивОбъектов, ПараметрыПечати, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода) Экспорт
	
	// _Демо начало примера
	Для Каждого ПечатнаяФорма Из КоллекцияПечатныхФорм Цикл
		Если ПечатнаяФорма.ТабличныйДокумент.ВысотаТаблицы > 0 Тогда
			ПечатнаяФорма.ТабличныйДокумент.НижнийКолонтитул.ТекстСлева = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = 'Дата формирования: %1'"), Формат(ТекущаяДатаСеанса(), "ДЛФ=DD"));
			ПечатнаяФорма.ТабличныйДокумент.НижнийКолонтитул.Выводить = Истина;
		КонецЕсли;
	КонецЦикла;
	// _Демо конец примера
	
КонецПроцедуры

// Переопределяет параметры отправки печатных форм при подготовке письма.
// 
// Параметры:
//
//  ПараметрыОтправки
//    * Получатель - Массив
//    * Тема - Строка
//    * Текст - Строка
//    * Вложения - Структура:
//      ** АдресВоВременномХранилище - Строка
//      ** Представление - Строка - имя файла.
//  ОбъектыПечати - Массив - параметр МассивСсылок в вызове процедуры Печать
//  ПараметрыВывода - Структура - параметр ПараметрыВывода в вызове процедуры Печать
//  ПечатныеФормы - ТаблицаЗначений - коллекция табличных документов:
//    * Название - Строка - название печатной формы;
//    * ТабличныйДокумент - ТабличныйДокумент - печатая форма.
Процедура ПередОтправкойПоПочте(ПараметрыОтправки, ПараметрыВывода, ОбъектыПечати, ПечатныеФормы) Экспорт
	// _Демо начало примера
	ПараметрыОтправки.Текст = СокрП(ПараметрыОтправки.Текст) + Символы.ПС + Символы.ПС 
		+ "____________________"
		+ Символы.ПС + Символы.ПС
		+ НСтр("ru = 'Информация в этом сообщении предназначена исключительно для конкретных лиц, которым она адресована. В сообщении может содержаться конфиденциальная информация, которая не может быть раскрыта или использована кем-либо, кроме адресатов. Если вы не адресат этого сообщения, то использование, переадресация, копирование или распространение содержания сообщения или его части незаконно и запрещено. Если Вы получили это сообщение ошибочно, пожалуйста, незамедлительно сообщите отправителю об этом и удалите со всем содержимым само сообщение и любые возможные его копии и вложения.'");
		
	// _Демо конец примера
КонецПроцедуры

#КонецОбласти
