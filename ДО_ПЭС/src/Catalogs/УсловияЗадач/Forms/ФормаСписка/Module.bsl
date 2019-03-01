#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	УстановитьУсловноеОформление();
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	// Режим выбора.
	Если Параметры.РежимВыбора Тогда
		
		СтандартныеПодсистемыСервер.УстановитьКлючНазначенияФормы(ЭтотОбъект, "ВыборПодбор");
		РежимОткрытияОкна = РежимОткрытияОкнаФормы.БлокироватьОкноВладельца;
		
		Элементы.Список.РежимВыбора = Истина;
		Элементы.ФормаВыбрать.Видимость = Истина;
		элементы.ФормаВыбрать.КнопкаПоУмолчанию = Истина;
		
		Если Параметры.ЗакрыватьПриВыборе = Ложь Тогда
			// Режим подбора.
			Заголовок = НСтр("ru = 'Подбор условий проверки задач'");
			Элементы.Список.МножественныйВыбор = Истина;
			Элементы.Список.РежимВыделения = РежимВыделенияТаблицы.Множественный;
		Иначе
			Заголовок = НСтр("ru = 'Выбор условия проверки задач'");
		КонецЕсли;
		
		АвтоЗаголовок = Ложь;
		
	КонецЕсли;
	
	// Показывать удаленные.
	ОбщегоНазначенияДокументооборотКлиентСервер.УстановитьОтборПоказыватьУдаленные(
		Список,
		ПоказыватьУдаленные,
		Элементы.ПоказыватьУдаленные);
	
КонецПроцедуры

&НаСервере
Процедура ПриЗагрузкеДанныхИзНастроекНаСервере(Настройки)
	
	// Показывать удаленные.
	ОбщегоНазначенияДокументооборотКлиентСервер.УстановитьОтборПоказыватьУдаленные(
		Список,
		ПоказыватьУдаленные,
		Элементы.ПоказыватьУдаленные);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ПоказыватьУдаленные(Команда)
	
	ПоказыватьУдаленные = Не ПоказыватьУдаленные;
	ОбщегоНазначенияДокументооборотКлиентСервер.УстановитьОтборПоказыватьУдаленные(
		Список,
		ПоказыватьУдаленные,
		Элементы.ПоказыватьУдаленные);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьУсловноеОформление()
	
	Список.УсловноеОформление.Элементы.Очистить();
	ЭскалацияЗадач.УстановитьУсловноеОформлениеСписка(Список.УсловноеОформление);
	
КонецПроцедуры

#КонецОбласти