#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	ДелаЗначение = Отсутствия.ПолучитьДелаСотрудника(
		Параметры.ДатаНачала,
		Параметры.ДатаОкончания,
		Параметры.Сотрудник);
	ЗначениеВРеквизитФормы(ДелаЗначение, "Дела");
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыДела

&НаКлиенте
Процедура ДелаВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ОбработатьВыборСтроки(Элемент.ДанныеСтроки(ВыбраннаяСтрока));
	
КонецПроцедуры

&НаКлиенте
Процедура ДелаПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа, Параметр)
	
	Отказ = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура ДелаПередНачаломИзменения(Элемент, Отказ)
	
	Отказ = Истина;
	ОбработатьВыборСтроки(Элемент.ТекущиеДанные);
	
КонецПроцедуры

&НаКлиенте
Процедура ДелаПередУдалением(Элемент, Отказ)
	
	Отказ = Истина;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Да(Команда)
	
	Закрыть(КодВозвратаДиалога.Да);
	
КонецПроцедуры

&НаКлиенте
Процедура Нет(Команда)
	
	Закрыть(КодВозвратаДиалога.Нет);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ОбработатьВыборСтроки(ДанныеСтроки)
	
	Если ДанныеСтроки = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ПоказатьЗначение(, ДанныеСтроки.Ссылка);
	
КонецПроцедуры

#КонецОбласти