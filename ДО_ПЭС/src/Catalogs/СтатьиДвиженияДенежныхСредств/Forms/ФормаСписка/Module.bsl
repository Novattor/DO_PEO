#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	УправлениеДоступностью();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ДекорацияИзменитьНажатие(Элемент)
	
	ОписаниеОповещения = Новый ОписаниеОповещения("НастройкаПрограммыЗавершение", ЭтотОбъект);
	ОткрытьФорму("Обработка.НастройкаПрограммы.Форма.ОбменДанными",,,,,,
		ОписаниеОповещения, РежимОткрытияОкнаФормы.БлокироватьВесьИнтерфейс);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура НастройкаПрограммыЗавершение(Результат, Параметры) Экспорт
	
	УправлениеДоступностью();
	
КонецПроцедуры

Процедура УправлениеДоступностью()
	
	// Редактирование может быть запрещено, поскольку справочник обновляется загрузкой.
	Если ПравоДоступа("Редактирование", Метаданные.Справочники.СтатьиДвиженияДенежныхСредств) Тогда
		ТолькоПросмотр = Константы.ЗапретитьРедактированиеСтатейДвиженияДенежныхСредств.Получить();
		// Подчеркнем это недоступностью команд.
		Элементы.ГруппаКомандыРедактирования.Доступность = НЕ ТолькоПросмотр;
		Элементы.ГруппаКомандыРедактированияКонтекст.Доступность = НЕ ТолькоПросмотр;
		Элементы.ДекорацииОбъясняющиеЗапрет.Видимость = ТолькоПросмотр;
		Элементы.ДекорацияИзменить.Видимость = ПравоДоступа("Использование", 
			Метаданные.Обработки.НастройкаПрограммы);
	Иначе
		Элементы.ДекорацииОбъясняющиеЗапрет.Видимость = Ложь;
		Элементы.ДекорацияИзменить.Видимость = Ложь;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти