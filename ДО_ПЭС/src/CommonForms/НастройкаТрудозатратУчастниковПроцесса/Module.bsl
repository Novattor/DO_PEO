#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Для Каждого СтрУчастник Из Параметры.Участники Цикл
		ЗаполнитьЗначенияСвойств(Участники.Добавить(), СтрУчастник);
	КонецЦикла;
	
	Элементы.ИсполнителиШаг.Видимость = 
		Параметры.ВариантМаршрутизацииЗадач = Перечисления.ВариантыМаршрутизацииЗадач.Смешанно;
	
	Элементы.ИсполнителиТрудозатраты.Заголовок = 
		ВРег(Лев(Параметры.ЕдиницаИзмеренияТрудозатрат, 1))
		+ Прав(Параметры.ЕдиницаИзмеренияТрудозатрат, СтрДлина(Параметры.ЕдиницаИзмеренияТрудозатрат)-1);
	
	Если ТолькоПросмотр Тогда
		Элементы.ФормаГотово.Видимость = Ложь;
		Элементы.ФормаОтмена.Заголовок = НСтр("ru = 'Закрыть'");
		Элементы.ФормаОтмена.КнопкаПоУмолчанию = Истина;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	РасчитатьИтоговыеТрудозатратыИсполнителей();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыИсполнители

&НаКлиенте
Процедура ИсполнителиТрудозатратыПланИсполнителяПриИзменении(Элемент)
	
	РасчитатьИтоговыеТрудозатратыИсполнителей();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Отмена(Команда)
	
	Закрыть(Неопределено);
	
КонецПроцедуры

&НаКлиенте
Процедура Готово(Команда)
	
	РезультатНастройки = Новый Массив;
	
	Для Каждого СтрУчастник ИЗ Участники Цикл
		
		СтруктураСтрокиУчастника = РаботаСБизнесПроцессамиКлиент.
			СтруктураСтрокиТрудозатратУчастникаПроцесса(
				СтрУчастник.РольВПроцессе,
				СтрУчастник.ПолеТрудозатрат,
				СтрУчастник.Трудозатраты,
				СтрУчастник.Участник,
				СтрУчастник.Шаг,
				СтрУчастник.НомерСтроки);
		РезультатНастройки.Добавить(СтруктураСтрокиУчастника);
		
	КонецЦикла;
	
	Закрыть(РезультатНастройки);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура РасчитатьИтоговыеТрудозатратыИсполнителей()
	
	ИтоговыеТрудозатратыИсполнителей = Участники.Итог("Трудозатраты");
	
КонецПроцедуры

#КонецОбласти

