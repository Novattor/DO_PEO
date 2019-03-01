#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Возвращает настройки отбора показателя.
//
// Возвращаемое значение:
//  Структура - Настройки отбора. См. Справочники.ПоказателиПроцессов.НастройкиОтбора().
//
Функция НастройкиОтбора() Экспорт
	
	НастройкиОтбора = Справочники.ПоказателиПроцессов.НастройкиОтбора();
	ЗаполнитьЗначенияСвойств(НастройкиОтбора, ЭтотОбъект);
	НастройкиОтбора.НаборВариантовОтбора = НаборВариантовОтбора();
	
	Возврат НастройкиОтбора;
	
КонецФункции

#КонецОбласти

#Область ОбработчикиСобытий

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка)
	
	Автор = ПользователиКлиентСервер.ТекущийПользователь();
	
	Если ТипЗнч(ДанныеЗаполнения) <> Тип("Структура") Тогда
		Возврат;
	КонецЕсли;
	
	Если ДанныеЗаполнения.Свойство("ВариантРасчета") Тогда
		ЗаполнитьЗначенияСвойств(ЭтотОбъект, ДанныеЗаполнения.ВариантРасчета);
	КонецЕсли;
	
	Если ДанныеЗаполнения.Свойство("ВариантОтбора") Тогда
		НовыйВариантОтбора = ОтборыДанных.Добавить();
		ЗаполнитьЗначенияСвойств(НовыйВариантОтбора, ДанныеЗаполнения.ВариантОтбора);
	КонецЕсли;
	
	Если ДанныеЗаполнения.Свойство("НаборВариантовОтбора") Тогда
		Для Каждого ВариантОтбора Из ДанныеЗаполнения.НаборВариантовОтбора Цикл
			НовыйВариантОтбора = ОтборыДанных.Добавить();
			ЗаполнитьЗначенияСвойств(НовыйВариантОтбора, ВариантОтбора);
		КонецЦикла;
	КонецЕсли;
	
	Если ДанныеЗаполнения.Свойство("НастройкиОтбора") Тогда
		ЗаполнитьЗначенияСвойств(ЭтотОбъект, ДанныеЗаполнения.НастройкиОтбора);
		Для Каждого ВариантОтбора Из ДанныеЗаполнения.НастройкиОтбора.НаборВариантовОтбора Цикл
			НовыйВариантОтбора = ОтборыДанных.Добавить();
			ЗаполнитьЗначенияСвойств(НовыйВариантОтбора, ВариантОтбора);
		КонецЦикла;
	КонецЕсли;
	
	ЗаполнитьНаименование();
	Если Не ЗначениеЗаполнено(ПериодРасчета) Тогда
		ПериодРасчета = Справочники.ПоказателиПроцессов.ПериодПоУмолчаниюВариантаРасчета(ВариантРасчета());
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	ИсключаемыеРеквизиты = Новый Массив;
	
	Если ПериодРасчета <> Перечисления.ПериодыРасчетаПоказателейПроцессов.ПоДням Тогда
		ИсключаемыеРеквизиты.Добавить("ДниПериодаРасчета");
	КонецЕсли;
	
	Если ПериодРасчета <> Перечисления.ПериодыРасчетаПоказателейПроцессов.Произвольный Тогда
		ИсключаемыеРеквизиты.Добавить("НачалоПериодаРасчета");
		ИсключаемыеРеквизиты.Добавить("ОкончаниеПериодаРасчета");
	КонецЕсли;
	
	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты, ИсключаемыеРеквизиты);
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если ЭтоНовый() Тогда
		
		ДополнительныеСвойства.Вставить("ЭтоНовый");
		
	Иначе
		
		ПредыдущиеЗначенияРеквизитов = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Ссылка,
			"ПометкаУдаления, ДанныеДляРасчета, СпособРасчета,
			|ПериодРасчета, ДниПериодаРасчета, НачалоПериодаРасчета, ОкончаниеПериодаРасчета, ОтборыДанных");
		
		// Изменился вариант расчета.
		ИзменилсяВариантРасчета = ПредыдущиеЗначенияРеквизитов.ДанныеДляРасчета <> ДанныеДляРасчета
			Или ПредыдущиеЗначенияРеквизитов.СпособРасчета <> СпособРасчета;
		Если ИзменилсяВариантРасчета Тогда
			ДополнительныеСвойства.Вставить("ИзменилсяВариантРасчета");
		КонецЕсли;
		
		// Изменился период расчета.
		ИзменилсяПериодРасчета = ПредыдущиеЗначенияРеквизитов.ПериодРасчета <> ПериодРасчета
			Или (ПериодРасчета = Перечисления.ПериодыРасчетаПоказателейПроцессов.ПоДням
				И ПредыдущиеЗначенияРеквизитов.ДниПериодаРасчета <> ДниПериодаРасчета)
			Или (ПериодРасчета = Перечисления.ПериодыРасчетаПоказателейПроцессов.Произвольный
				И ПредыдущиеЗначенияРеквизитов.НачалоПериодаРасчета <> НачалоПериодаРасчета
				И ПредыдущиеЗначенияРеквизитов.ОкончаниеПериодаРасчета <> ОкончаниеПериодаРасчета);
		
		// Изменился отбора данных.
		ПредыдущийОтборДанных = ПредыдущиеЗначенияРеквизитов.ОтборыДанных.Выгрузить();
		ПредыдущийОтборДанных.Колонки.Удалить("Ссылка");
		ИзменилсяОтборДанных = Не ОбщегоНазначения.ДанныеСовпадают(
			ПредыдущийОтборДанных,
			ОтборыДанных.Выгрузить());
		
		// Изменился способ расчета показателя.
		Если ИзменилсяВариантРасчета Или ИзменилсяПериодРасчета Или ИзменилсяОтборДанных Тогда
			ДополнительныеСвойства.Вставить("ИзменилсяСпособРасчета");
		КонецЕсли;
		
		// Установили пометку удаления.
		Если ПометкаУдаления И Не ПредыдущиеЗначенияРеквизитов.ПометкаУдаления Тогда
			// Если активна подписка у удаляющего пользователя  - просто отменяем подписку.
			Если РегистрыСведений.ПодпискиНаПоказателиПроцессов.ПодпискаАктивна(Ссылка) Тогда
				ПометкаУдаления = Ложь;
				РегистрыСведений.ПодпискиНаПоказателиПроцессов.Удалить(Ссылка);
			КонецЕсли;
		КонецЕсли;
		
	КонецЕсли;
	
	Если ДополнительныеСвойства.Свойство("ЭтоНовый") Или ДополнительныеСвойства.Свойство("ИзменилсяВариантРасчета") Тогда
		ТипЗначенияПоказателя = Справочники.ПоказателиПроцессов.ТипЗначенияВариантаРасчета(ВариантРасчета());
	КонецЕсли;
	
	Если АвтоНаименование Тогда
		ЗаполнитьНаименование();
	КонецЕсли;
	
	РассчитатьХеши();
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если ДополнительныеСвойства.Свойство("ЭтоНовый") Тогда
		РегистрыСведений.ПодпискиНаПоказателиПроцессов.Добавить(Ссылка);
		РегистрыСведений.ОчередьПересчетаПоказателейПроцессов.Добавить(Ссылка);
	КонецЕсли;
	
КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)
	
	Автор = ПользователиКлиентСервер.ТекущийПользователь();
	СозданАвтоматически = Ложь;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Выполняет расчет хешей объекта.
//
Процедура РассчитатьХеши()
	
	Если ПометкаУдаления Тогда
		ХешНастроекОтбора = Неопределено;
		ХешАвтоматическогоПоказателя = Неопределено;
		Возврат;
	КонецЕсли;
	
	ХешиПоказателя = Справочники.ПоказателиПроцессов.ХешиПоказателя(ВариантРасчета(), НастройкиОтбора());
	ЗаполнитьЗначенияСвойств(ЭтотОбъект, ХешиПоказателя);
	
	Если ЭтоНовый() И СозданАвтоматически Тогда
		ХешАвтоматическогоПоказателя = ХешиПоказателя.ХешПоказателя;
	КонецЕсли;
	
КонецПроцедуры

// Автоматически заполняет наименование объекта.
//
Процедура ЗаполнитьНаименование()
	
	ПредставлениеПоказателя = Справочники.ПоказателиПроцессов.ПредставлениеПоказателя(ВариантРасчета(), НастройкиОтбора());
	Если Не ЗначениеЗаполнено(ПредставлениеПоказателя) Тогда
		АвтоНаименование = Ложь;
		Возврат;
	КонецЕсли;
	
	Наименование = ПредставлениеПоказателя;
	
КонецПроцедуры

// Возвращает вариант расчета показателя.
//
// Возвращаемое значение:
//  Структура - Вариант расчета показателя. См. Справочники.ПоказателяПроцессов.ВариантРасчета().
//
Функция ВариантРасчета()
	
	ВариантРасчета = Справочники.ПоказателиПроцессов.ВариантРасчета();
	ЗаполнитьЗначенияСвойств(ВариантРасчета, ЭтотОбъект);
	
	Возврат ВариантРасчета;
	
КонецФункции

// Возвращает набор вариантов отбора показателя.
//
// Возвращаемое значение:
//  Массив - Набор вариант расчета показателя.
//
Функция НаборВариантовОтбора()
	
	НаборВариантовОтбора = Новый Массив;
	
	Для Каждого ОтборДанных Из ОтборыДанных Цикл
		ВариантОтбора = Справочники.ПоказателиПроцессов.ВариантОтбора();
		ЗаполнитьЗначенияСвойств(ВариантОтбора, ОтборДанных);
		НаборВариантовОтбора.Добавить(ВариантОтбора);
	КонецЦикла;
	
	Возврат НаборВариантовОтбора;
	
КонецФункции

#КонецОбласти

#КонецЕсли