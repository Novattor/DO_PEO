#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	// Отображать удаленные - при первом открытии формы нужно не отображать удаленные.
	УстановитьОтборПоказыватьУдаленные();
	
	Если Параметры.РежимВыбора Тогда
		
		СтандартныеПодсистемыСервер.УстановитьКлючНазначенияФормы(ЭтотОбъект, "ВыборПодбор");
		РежимОткрытияОкна = РежимОткрытияОкнаФормы.БлокироватьОкноВладельца;
		
		Если Параметры.ЗакрыватьПриВыборе = Ложь Тогда
			// Режим подбора.
			Заголовок = НСтр("ru = 'Подбор броней'");
			Элементы.Список.МножественныйВыбор = Истина;
			Элементы.Список.РежимВыделения = РежимВыделенияТаблицы.Множественный;
		Иначе
			Заголовок = НСтр("ru = 'Выбор броней'");
		КонецЕсли;
		
	Иначе
		Элементы.Список.РежимВыбора = Ложь;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПриЗагрузкеДанныхИзНастроекНаСервере(Настройки)
	
	// Отображать удаленные
	УстановитьОтборПоказыватьУдаленные();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ПоказыватьУдаленные(Команда)
	
	ПоказыватьУдаленные = Не ПоказыватьУдаленные;
	УстановитьОтборПоказыватьУдаленные();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы_Отправить

&НаКлиенте
Процедура ПроцессСогласование(Команда)
	
	ОткрытьПомощникСозданияОсновныхПроцессов("Согласование");
	
КонецПроцедуры

&НаКлиенте
Процедура ПроцессИсполнение(Команда)
	
	ОткрытьПомощникСозданияОсновныхПроцессов("Исполнение");
	
КонецПроцедуры

&НаКлиенте
Процедура ПроцессОзнакомление(Команда)
	
	ОткрытьПомощникСозданияОсновныхПроцессов("Ознакомление");
	
КонецПроцедуры

&НаКлиенте
Процедура ПроцессОбработка(Команда)
	
	ТипыОпераций = Новый Массив;
	ТипыОпераций.Добавить("ОбработкаВнутреннегоДокумента");
	ТипыОпераций.Добавить("КомплексныйПроцесс");
	
	ОткрытьПомощникСозданияОсновныхПроцессов(ТипыОпераций);
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьПомощникСозданияОсновныхПроцессов(ТипыОпераций)
	
	ВыделенныеСтроки = Новый Массив;
	
	Для Каждого СтрСписка Из Элементы.Список.ВыделенныеСтроки Цикл
		ВыделенныеСтроки.Добавить(Элементы.Список.ДанныеСтроки(СтрСписка).Ссылка);
	КонецЦикла;
	
	РаботаСБизнесПроцессамиКлиент.ОткрытьПомощникСозданияОсновныхПроцессов(
		ТипыОпераций, ВыделенныеСтроки, ЭтаФорма, "ФормаСписка");
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьОтборПоказыватьУдаленные()
	
	Параметр = Список.Параметры.НайтиЗначениеПараметра(
		Новый ПараметрКомпоновкиДанных("ОтборПоказыватьУдаленные"));
	Параметр.Использование = Ложь;
	
	Элементы.ФормаПоказыватьУдаленные.Пометка = ПоказыватьУдаленные;
	
	Если Не ПоказыватьУдаленные Тогда
		Список.Параметры.УстановитьЗначениеПараметра("ОтборПоказыватьУдаленные", Ложь);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти