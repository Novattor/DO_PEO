#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Проверяет что заполнены поля шаблона
Функция ПолучитьСписокНезаполненныхПолейНеобходимыхДляСтарта() Экспорт
	
	МассивПолей = Новый Массив;

	Если Не ЗначениеЗаполнено(Исполнитель) Тогда
		МассивПолей.Добавить("Исполнитель");
	КонецЕсли;	
	
	Возврат МассивПолей;
	
КонецФункции	

//Формирует текстовое представление бизнес-процесса, создаваемого по шаблону
Функция СформироватьСводкуПоШаблону() Экспорт
	
	Результат = ШаблоныБизнесПроцессов.ПолучитьОбщуюЧастьОписанияШаблона(Ссылка);
		
	Если ЗначениеЗаполнено(НаименованиеБизнесПроцесса) Тогда
		Результат = Результат + НСтр("ru = 'Заголовок'") + ": " + НаименованиеБизнесПроцесса + Символы.ПС;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Описание) Тогда
		Результат = Результат + НСтр("ru = 'Описание'") + ": " + Описание + Символы.ПС;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Важность) Тогда
		Результат = Результат + НСтр("ru = 'Важность'") + ": " + Строка(Важность) + Символы.ПС;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Исполнитель) Тогда
		Результат = Результат + Нстр("ru = 'Исполнитель'") + ": "
			+ Строка(Исполнитель)
			+ Символы.ПС;
	КонецЕсли;
	
	ДлительностьПроцесса = СрокиИсполненияПроцессов.ДлительностьИсполненияПроцесса(ЭтотОбъект);
	ДлительностьПроцессаСтрокой = СрокиИсполненияПроцессовКлиентСервер.ПредставлениеДлительности(
		ДлительностьПроцесса.СрокИсполненияПроцессаДни,
		ДлительностьПроцесса.СрокИсполненияПроцессаЧасы,
		ДлительностьПроцесса.СрокИсполненияПроцессаМинуты);
		
	Если ЗначениеЗаполнено(ДлительностьПроцессаСтрокой) Тогда
		Результат = Результат + Нстр("ru = 'Срок'") + ": "
			+ ДлительностьПроцессаСтрокой;
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

#КонецОбласти

#Область ПрограммныйИнтерфейс_ПоддержкаМеханизмаОтсутствий

// Получает исполнителей
Функция ПолучитьИсполнителей() Экспорт
	
	МассивИсполнителей = Новый Массив;
	
	Если ЗначениеЗаполнено(Исполнитель) Тогда
		ДанныеИсполнителя = ОтсутствияКлиентСервер.ПолучитьДанныеИсполнителя(Исполнитель);
		МассивИсполнителей.Добавить(ДанныеИсполнителя);
	КонецЕсли;
	
	Возврат МассивИсполнителей;
	
КонецФункции

#КонецОбласти

#Область ОбработчикиСобытий

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	Если ЭтоГруппа Тогда 
		Возврат;
	КонецЕсли;
	
	Если ЭтоНовый() Тогда 
		ШаблоныБизнесПроцессов.НачальноеЗаполнениеШаблона(ЭтотОбъект, ДанныеЗаполнения);
	КонецЕсли;	
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	Если ЭтоГруппа Тогда 
		Возврат;
	КонецЕсли;
	
	Если ШаблонВКомплексномПроцессе Тогда
		ПроверяемыйЭлемент = ПроверяемыеРеквизиты.Найти("Наименование");
		ПроверяемыеРеквизиты.Удалить(ПроверяемыйЭлемент);
	КонецЕсли;
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	ШаблоныБизнесПроцессов.ШаблонПередЗаписью(ЭтотОбъект, Отказ);
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли