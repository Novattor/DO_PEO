
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Список.Параметры.УстановитьЗначениеПараметра("ЗначениеОтбора", Параметры.ЗначениеОтбора);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "БизнесПроцессИзменен" Тогда
		Элементы.Список.Обновить();
	КонецЕсли;
	
КонецПроцедуры
