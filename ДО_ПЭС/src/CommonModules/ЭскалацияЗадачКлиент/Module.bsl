////////////////////////////////////////////////////////////////////////////////
// Эскалация задач: модуль для работы с эскалацией и автоматическим выполнением задач.
//
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Задает приоритет правила эскалации.
//
// Параметры:
//  ПравилоЭскалации - СправочникСсылка.ПравилаЭскалации - Правило эскалации.
//  Приоритет - Число - Текущие приоритет.
//
Процедура ЗадатьПриоритет(ПравилоЭскалации, Приоритет) Экспорт
	
	ПараметрыОбработчика = Новый Структура;
	ПараметрыОбработчика.Вставить("ПравилоЭскалации", ПравилоЭскалации);
	ОписаниеОповещения = Новый ОписаниеОповещения("ЗадатьПриоритетЗавершение", ЭтотОбъект, ПараметрыОбработчика);
	
	ПоказатьВводЧисла(ОписаниеОповещения, Приоритет, НСтр("ru = 'Задание приоритета'"), 10);
	
КонецПроцедуры

// Выполняет нормализацию приоритетов всех правил эскалации.
//
Процедура НормализоватьПриоритеты() Экспорт
	
	ЭскалацияЗадачВызовСервера.НормализоватьПриоритеты();
	ОповеститьОбИзменении(Тип("СправочникСсылка.ПравилаЭскалацииЗадач"));
	
КонецПроцедуры

// Повышает приоритет правила эскалации.
//
// Параметры:
//  ПравилоЭскалации - СправочникСсылка.ПравилаЭскалации - Правило эскалации.
//  Шаблон - СправочникСсылка - Шаблон процесса, в контексте которого происходит изменение.
//
Процедура ПовыситьПриоритет(ПравилоЭскалации, Шаблон) Экспорт
	
	ЭскалацияЗадачВызовСервера.ПовыситьПриоритет(ПравилоЭскалации, Шаблон);
	ОповеститьОбИзменении(ПравилоЭскалации);
	
КонецПроцедуры

// Понижает приоритет правила эскалации.
//
// Параметры:
//  ПравилоЭскалации - СправочникСсылка.ПравилаЭскалации - Правило эскалации.
//  Шаблон - СправочникСсылка - Шаблон процесса, в контексте которого происходит изменение.
//
Процедура ПонизитьПриоритет(ПравилоЭскалации, Шаблон) Экспорт
	
	ЭскалацияЗадачВызовСервера.ПонизитьПриоритет(ПравилоЭскалации, Шаблон);
	ОповеститьОбИзменении(ПравилоЭскалации);
	
КонецПроцедуры

// Выбирает процесс правила эскалации задач.
//
// Параметры:
//  ОписаниеОповещения - ОписаниеОповещения - Описание оповещения.
//
Процедура ВыбратьПроцесс(ОписаниеОповещения) Экспорт
	
	ПараметрыОбработчика = Новый Структура;
	ПараметрыОбработчика.Вставить("ОписаниеОповещения", ОписаниеОповещения);
	ТекущееОписаниеОповещения = Новый ОписаниеОповещения(
		"ВыбратьПроцессЗавершение",
		ЭтотОбъект,
		ПараметрыОбработчика);
	
	ОткрытьФорму(
		"Справочник.ПравилаЭскалацииЗадач.Форма.ВыборПроцессаПравилаЭскалации",,,,,,
		ТекущееОписаниеОповещения);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// См. ЭскалацияЗадачКлиент.ЗадатьПриоритет().
//
Процедура ЗадатьПриоритетЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ЭскалацияЗадачВызовСервера.ЗадатьПриоритет(ДополнительныеПараметры.ПравилоЭскалации, Результат);
	ОповеститьОбИзменении(ДополнительныеПараметры.ПравилоЭскалации);
	
КонецПроцедуры

// См. ЭскалацияЗадачКлиент.ВыбратьПроцесс().
//
Процедура ВыбратьПроцессЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если ТипЗнч(Результат) = Тип("ПеречислениеСсылка.ТипыПроцессовЭскалацииЗадач") Тогда
		ВыполнитьОбработкуОповещения(
			ДополнительныеПараметры.ОписаниеОповещения,
			Результат);
	Иначе
		ШаблоныБизнесПроцессовКлиент.ВыбратьШаблонБизнесПроцесса(
			Результат,,
			ДополнительныеПараметры.ОписаниеОповещения);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти