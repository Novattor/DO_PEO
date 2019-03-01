#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	Если Не Объект.Ссылка.Пустая() Тогда
		HTMLКодИнструкции = РаботаСИнструкциями.ТекстИнструкции(Объект.Ссылка);
		ТекстИнструкции = РаботаСИнструкциями.УстановитьСтильОформленияИнструкции(HTMLКодИнструкции);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
