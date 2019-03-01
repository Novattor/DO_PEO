#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
	
#Область ОбработчикиСобытий

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	Если ПометкаУдаления Тогда
		Возврат;
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(Организация) Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			ЭлектронноеВзаимодействиеКлиентСервер.ТекстСообщения("Поле", "Заполнение", "Организация"),
			ЭтотОбъект,
			"Организация",
			,
			Отказ);
	КонецЕсли;

	Если СпособОбменаЭД = Перечисления.СпособыОбменаЭД.ЧерезОператораЭДОТакском
		Или СпособОбменаЭД = Перечисления.СпособыОбменаЭД.ЧерезСервис1СЭДО Тогда
		
		Если СертификатыПодписейОрганизации.Количество() = 0 Тогда
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
				ЭлектронноеВзаимодействиеКлиентСервер.ТекстСообщения("Список", "Заполнение", , , НСтр("ru = 'Сертификаты организации'")),
				ЭтотОбъект,
				"СертификатыПодписейОрганизации",
				,
				Отказ);
		КонецЕсли;
		
		Возврат;
	Иначе
		Отбор = Новый Структура;
		Отбор.Вставить("ИспользоватьЭП", Истина);
		
		Если ИсходящиеДокументы.НайтиСтроки(Отбор).Количество() > 0 И СертификатыПодписейОрганизации.Количество() = 0 Тогда
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
				ЭлектронноеВзаимодействиеКлиентСервер.ТекстСообщения("Список", "Заполнение", , , НСтр("ru = 'Сертификаты организации'")),
				ЭтотОбъект,
				"СертификатыПодписейОрганизации",
				,
				Отказ);
		КонецЕсли;
		
		Возврат;
	КонецЕсли;
	
	Если СпособОбменаЭД = Перечисления.СпособыОбменаЭД.ЧерезFTP Тогда
		Если НЕ ЗначениеЗаполнено(АдресСервера) Тогда
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
				ЭлектронноеВзаимодействиеКлиентСервер.ТекстСообщения("Поле", "Заполнение", НСтр("ru = 'Адрес сервера'")),
				ЭтотОбъект,
				"АдресСервера",
				,
				Отказ);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	ОчиститьРегистр = Ложь;
	Если ПометкаУдаления Тогда
		Запрос = Новый Запрос;
		Запрос.Текст =
		"ВЫБРАТЬ
		|	СоглашенияОбИспользованииЭДИсходящиеДокументы.Ссылка
		|ИЗ
		|	Справочник.СоглашенияОбИспользованииЭД.ИсходящиеДокументы КАК СоглашенияОбИспользованииЭДИсходящиеДокументы
		|ГДЕ
		|	СоглашенияОбИспользованииЭДИсходящиеДокументы.ПрофильНастроекЭДО = &ПрофильНастроекЭДО
		|	И НЕ СоглашенияОбИспользованииЭДИсходящиеДокументы.Ссылка.ПометкаУдаления";
		Запрос.УстановитьПараметр("ПрофильНастроекЭДО", ЭтотОбъект.Ссылка);
		
		Если Не Запрос.Выполнить().Пустой() Тогда
			ТекстСообщения = НСтр("ru = 'Операция отменена. Текущий профиль настроек ЭДО используется в действующих настройках ЭДО.'");
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, , , , Отказ);
		КонецЕсли;
		
		Если Не Отказ Тогда
			ОчиститРегистрНовыеДокументаВСервисеЭДО();
			ОчиститьРегистр = Истина;
		КонецЕсли;
		
	КонецЕсли;
	
	Если Не ОчиститьРегистр И Не ЭтоНовый() Тогда
		ИдентификаторСсылки = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Ссылка, "ИдентификаторОрганизации");
		Если Не ИдентификаторОрганизации = ИдентификаторСсылки Тогда
			ОчиститРегистрНовыеДокументаВСервисеЭДО();
		КонецЕсли;
		
	КонецЕсли;

КонецПроцедуры

#КонецОбласти
	
#Область СлужебныеПроцедурыИФункции

Процедура ОчиститРегистрНовыеДокументаВСервисеЭДО()
	
	НаборЗаписей = РегистрыСведений.НовыеДокументыВСервисеЭДО.СоздатьНаборЗаписей();
	НаборЗаписей.Отбор.ПрофильЭДО.Установить(Ссылка);
	НаборЗаписей.Записать();
	
КонецПроцедуры

// Только для внутреннего использования
Функция ПрофильНастроекЭДОУникален() Экспорт
	
	Если ПометкаУдаления Тогда
		Возврат Истина;
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ РАЗЛИЧНЫЕ
	|	ПрофилиНастроекЭДО.Ссылка КАК ПрофильНастроекЭДО
	|ИЗ
	|	Справочник.ПрофилиНастроекЭДО КАК ПрофилиНастроекЭДО
	|ГДЕ
	|	ПрофилиНастроекЭДО.Ссылка <> &Ссылка
	|	И ПрофилиНастроекЭДО.СпособОбменаЭД = &СпособОбменаЭД
	|	И ПрофилиНастроекЭДО.Организация = &Организация
	|	И ПрофилиНастроекЭДО.ИдентификаторОрганизации = &ИдентификаторОрганизации
	|	И НЕ ПрофилиНастроекЭДО.ПометкаУдаления";
	
	Запрос.УстановитьПараметр("ИдентификаторОрганизации", ЭтотОбъект.ИдентификаторОрганизации);
	Запрос.УстановитьПараметр("Организация",              ЭтотОбъект.Организация);
	Запрос.УстановитьПараметр("Ссылка",                   ЭтотОбъект.Ссылка);
	Запрос.УстановитьПараметр("СпособОбменаЭД",           ЭтотОбъект.СпособОбменаЭД);
	Результат = Запрос.Выполнить();
	ТекущийПрофильНастроекУникален = Результат.Пустой();
	
	Если Не ТекущийПрофильНастроекУникален Тогда
		ШаблонСообщения = НСтр("ru = 'В информационной базе уже существует профиль настроек с реквизитами:
		|Организация - %1;
		|Идентификатор организации - %2;
		|Способ обмена - %3;'");
		Выборка = Результат.Выбрать();
		Выборка.Следующий();
		ТекстОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
														ШаблонСообщения,
														ЭтотОбъект.Организация,
														ЭтотОбъект.ИдентификаторОрганизации,
														ЭтотОбъект.СпособОбменаЭД);
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстОшибки);
	КонецЕсли;
	
	Возврат ТекущийПрофильНастроекУникален;
	
КонецФункции

// Только для внутреннего использования
Процедура ИзменитьДанныеВСвязанныхНастройкахЭДО(ПрофильНастроекЭДО, Отказ) Экспорт
	
	// Замена табличной части в связанных настройках ЭДО.
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	СоглашенияОбИспользованииЭД.ИдентификаторКонтрагента,
	|	СоглашенияОбИспользованииЭД.Ссылка КАК НастройкаЭДО
	|ИЗ
	|	Справочник.СоглашенияОбИспользованииЭД КАК СоглашенияОбИспользованииЭД
	|ГДЕ
	|	НЕ СоглашенияОбИспользованииЭД.РасширенныйРежимНастройкиСоглашения
	|	И НЕ СоглашенияОбИспользованииЭД.ПометкаУдаления
	|	И СоглашенияОбИспользованииЭД.ПрофильНастроекЭДО = &ПрофильНастроекЭДО";
	
	Запрос.УстановитьПараметр("ПрофильНастроекЭДО", ПрофильНастроекЭДО.Ссылка);
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	НачатьТранзакцию();
	Попытка
		Пока Выборка.Следующий() Цикл
			Блокировка = Новый БлокировкаДанных;
			ЭлементБлокировки = Блокировка.Добавить("Справочник.СоглашенияОбИспользованииЭД");
			ЭлементБлокировки.УстановитьЗначение("Ссылка", Выборка.НастройкаЭДО);
			Блокировка.Заблокировать();
			
			// Готовится ТЧ для разовой замены в Настройках ЭДО.
			ИсходнаяТаблицаЭД = ПрофильНастроекЭДО.ИсходящиеДокументы.Выгрузить();
			ИсходнаяТаблицаЭД.Колонки.Добавить("ПрофильНастроекЭДО");
			ИсходнаяТаблицаЭД.Колонки.Добавить("СпособОбменаЭД");
			ИсходнаяТаблицаЭД.Колонки.Добавить("ИдентификаторОрганизации");
			ИсходнаяТаблицаЭД.Колонки.Добавить("ИдентификаторКонтрагента");
			
			ИсходнаяТаблицаЭД.ЗаполнитьЗначения(ПрофильНастроекЭДО.Ссылка,                   "ПрофильНастроекЭДО");
			ИсходнаяТаблицаЭД.ЗаполнитьЗначения(ПрофильНастроекЭДО.СпособОбменаЭД,           "СпособОбменаЭД");
			ИсходнаяТаблицаЭД.ЗаполнитьЗначения(ПрофильНастроекЭДО.ИдентификаторОрганизации, "ИдентификаторОрганизации");
			ИсходнаяТаблицаЭД.ЗаполнитьЗначения(Выборка.ИдентификаторКонтрагента,            "ИдентификаторКонтрагента");
			
			ВыбраннаяНастройкаЭДО = Выборка.НастройкаЭДО.ПолучитьОбъект();
			ВыбраннаяНастройкаЭДО.ОбменДанными.Загрузка = Истина;
			ВыбраннаяНастройкаЭДО.ИдентификаторОрганизации = ПрофильНастроекЭДО.ИдентификаторОрганизации;
			ВыбраннаяНастройкаЭДО.ИспользоватьУПД = ПрофильНастроекЭДО.ИспользоватьУПД;
			ВыбраннаяНастройкаЭДО.ИспользоватьУКД = ПрофильНастроекЭДО.ИспользоватьУКД;
			ВыбраннаяНастройкаЭДО.ИсходящиеДокументы.Загрузить(ИсходнаяТаблицаЭД);
			ВыбраннаяНастройкаЭДО.Записать();
		КонецЦикла;
		ЗафиксироватьТранзакцию();
	Исключение
		ОтменитьТранзакцию();
		ВызватьИсключение;
	КонецПопытки;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли