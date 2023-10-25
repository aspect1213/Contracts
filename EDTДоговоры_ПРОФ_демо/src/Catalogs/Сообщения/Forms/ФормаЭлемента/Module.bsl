#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Элементы.ПредметСсылкой.Видимость = Ложь;
	
	Если ЗначениеЗаполнено(Параметры.Основание) Тогда
		Объект.Предмет = Параметры.Основание;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Объект.Предмет) Тогда
		Элементы.Предмет.Видимость = Ложь;
		Элементы.ПредметСсылкой.Видимость = Истина;
	КонецЕсли;	
	
	Если Объект.Автор = Пользователи.ТекущийПользователь() Тогда
		Элементы.КомандаОтправить.Видимость = Истина;
		Элементы.КомандаОтмена.Видимость = Истина;
		Элементы.Автор.Видимость = Ложь;
		Элементы.Кому.Видимость = Истина;
		Элементы.Дата.Видимость = Ложь;
		Элементы.Текст.Видимость = Истина;
		Элементы.ТекстHTML.Видимость = Ложь;
	Иначе	
		ТолькоПросмотр = Истина;
		Элементы.КомандаОтправить.Видимость = Ложь;
		Элементы.КомандаОтмена.Видимость = Ложь;
		Элементы.Автор.Видимость = Истина;
		Элементы.Кому.Видимость = Ложь;
		Элементы.Дата.Видимость = Истина;
		Элементы.Текст.Видимость = Ложь;
		Элементы.ТекстHTML.Видимость = Истина;
		ОбновитьТекстHTML();
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Объект.Автор) Тогда
		Элементы.Декорация1СДоговоры.Видимость = Ложь;
	Иначе
		Элементы.Автор.Видимость = Ложь;
	КонецЕсли;	
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
	
	КлючеваяОперация = "СообщенияВыполнениеКомандыЗаписать";
	ОценкаПроизводительностиКлиентСервер.НачатьЗамерВремени(КлючеваяОперация);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии()
	
	Если РаботаССообщениямиКлиентСервер.ТребуетсяОтправитьСообщение(Объект) Тогда
		РаботаССообщениямиВызовСервера.ЗапуститьРассылкуСообщений();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
Процедура ТекстHTMLПриНажатии(Элемент, ДанныеСобытия, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	РаботаС_HTMLКлиент.ОткрытьСсылку(ДанныеСобытия.Href, ДанныеСобытия.Element);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура КомандаОтправить(Команда)
	
	Объект.Дата = ТекущаяДата();

	ОчиститьСообщения();	
	Если Записать() Тогда
		Закрыть();
	КонецЕсли;	
	
КонецПроцедуры

&НаКлиенте
Процедура КомандаОтмена(Команда)
	
	Если Не Модифицированность Тогда
		Закрыть();
		Возврат;
	КонецЕсли;
	
	Отказ = Истина;
	ОписаниеОповещения = Новый ОписаниеОповещения(
		"ОбработатьЗакрытие", 
		ЭтотОбъект);

	ПоказатьВопрос(ОписаниеОповещения,
		НСтр("ru = 'Сообщение не будет записано. Закрыть сообщение без записи?'"),
		РежимДиалогаВопрос.ДаНет,,
		КодВозвратаДиалога.Да);
		
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ОбновитьТекстHTML()
	
	ТекстHTML = Объект.Текст;
	ТекстHTML = СтрЗаменить(ТекстHTML, Символы.ПС, "<br>");
	РаботаС_HTML.ДобавитьТегиКСсылкам(ТекстHTML);
	
	ТекстHTML = СтрШаблон("<html>
		|<head>
		|<style type=""text/css"">
		|	body {
		|		overflow:    auto;
		|		margin-top:  10px;
		|		margin-left: 10px;
		|		font-family: Arial, sans-serif;
		|		font-size:   10pt;}
		| 	a:link {
		|		color: #006699; text-decoration: none;}
		|	a:visited {
		|		color: #006699; text-decoration: none;}
		|	a:hover {
		|		color: #006699; text-decoration: underline;}
		|	p {
		|		margin-top: 7px;}
		|</style>
		|<body>%1</body></html>", ТекстHTML);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработатьЗакрытие(Ответ, Параметры) Экспорт 
	
	Если Ответ = КодВозвратаДиалога.Да Тогда
		Модифицированность = Ложь;
		Закрыть();
	Иначе 
		Возврат;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти