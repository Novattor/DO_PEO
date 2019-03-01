
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если ЗначениеЗаполнено(Параметры.Получатель) Тогда 
		Список.Параметры.УстановитьЗначениеПараметра("Получатель", Параметры.Получатель);
	КонецЕсли;	
	
	// Комплекты документов
	Если Параметры.Свойство("ЯвляетсяКомплектомДокументов") Тогда
		Список.Параметры.УстановитьЗначениеПараметра("ЯвляетсяКомплектомДокументов", Параметры.ЯвляетсяКомплектомДокументов);
	КонецЕсли;
	
	// Виды документов
	Если Параметры.Свойство("ВидДокумента") Тогда
		Список.Параметры.УстановитьЗначениеПараметра("ВидДокумента", Параметры.ВидДокумента);
	КонецЕсли;
	
	Если Параметры.Свойство("Заголовок") Тогда
		Заголовок = Параметры.Заголовок;
	КонецЕсли;
	
	ВыбранныеДокументыНадпись = НСтр("ru = 'Выбранные документы:'");
	
	Если ЗакрыватьПриВыборе Тогда
		Элементы.ВыбранныеДокументыНадпись.Видимость = Ложь;
		Элементы.ВыбранныеЗначения.Видимость = Ложь;
	КонецЕсли;
	
	//кешируем количество доступных шаблонов внутренних документов
	КоличествоДоступныхШаблоновДокументов = ОбновитьКоличествоДоступныхШаблоновВыполнить();
	
	ПоказыватьУдаленные = Ложь;
	ПоказатьУдаленные();
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	//Обработчик ожидания для периодического обновления количества доступных шаблонов документов через каждые 20 минут
	ПодключитьОбработчикОжидания("ОбновитьКоличествоДоступныхШаблонов", 1200, Ложь);
	
КонецПроцедуры

&НаСервере
Процедура ПриЗагрузкеДанныхИзНастроекНаСервере(Настройки)
	
	ПоказыватьУдаленные = Настройки["ПоказыватьУдаленные"];
	ПоказатьУдаленные();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСписок

&НаКлиенте
Процедура СписокВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Если ЗакрыватьПриВыборе Тогда
		Если Элементы.Список.ТекущиеДанные = Неопределено Тогда
			Возврат;
		КонецЕсли;
		
		ОповеститьОВыборе(Элементы.Список.ТекущиеДанные.Ссылка);
		Возврат;
	КонецЕсли;
	
	ВыборЗначенияСервер(Элементы.Список.ТекущиеДанные.Ссылка);
	
КонецПроцедуры

&НаКлиенте
Процедура СписокПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа)
	
	Отказ = Истина;
	СоздатьНовыйДокумент(Копирование);

КонецПроцедуры

&НаКлиенте
Процедура СписокПередНачаломИзменения(Элемент, Отказ)
	
	Отказ = Истина;
	
	ТекущиеДанные = Элементы.Список.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда 
		Возврат;
	КонецЕсли;
	
	ПараметрыОткрытия = Новый Структура("Ключ", ТекущиеДанные.Ссылка);
	ОткрытьФорму("Справочник.ИсходящиеДокументы.ФормаОбъекта", ПараметрыОткрытия, Элементы.Список);
	
КонецПроцедуры

&НаКлиенте
Процедура СписокПередУдалением(Элемент, Отказ)
	
	Отказ = Истина;
	РаботаСоСпискамиДокументовКлиент.ВыполнитьУстановкуПометкиУдаления(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура СписокНачалоПеретаскивания(Элемент, ПараметрыПеретаскивания, Выполнение)
	
	МассивДокументов = Новый Массив;
	Для Каждого Значение Из ПараметрыПеретаскивания.Значение Цикл
		ДанныеСтроки = Элементы.Список.ДанныеСтроки(Значение);
		Если ДанныеСтроки <> Неопределено Тогда
			МассивДокументов.Добавить(ДанныеСтроки.Ссылка);
		КонецЕсли;	
	КонецЦикла;
		
	ПараметрыПеретаскивания.Значение = МассивДокументов;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыВыбранныеЗначения

&НаКлиенте
Процедура ВыбранныеЗначенияВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ПоказатьЗначение(, Элемент.ТекущиеДанные.Значение);
	
КонецПроцедуры

&НаКлиенте
Процедура ВыбранныеЗначенияПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа)
	Отказ = Истина;
КонецПроцедуры

&НаКлиенте
Процедура ВыбранныеЗначенияПослеУдаления(Элемент)
	ОбновитьОтображение();
КонецПроцедуры

&НаКлиенте
Процедура ВыбранныеЗначенияПроверкаПеретаскивания(Элемент, ПараметрыПеретаскивания, СтандартнаяОбработка, Строка, Поле)
	СтандартнаяОбработка = Ложь;
КонецПроцедуры

&НаКлиенте
Процедура ВыбранныеЗначенияПеретаскивание(Элемент, ПараметрыПеретаскивания, СтандартнаяОбработка, Строка, Поле)
	
	СтандартнаяОбработка = Ложь;
	
	Если ТипЗнч(ПараметрыПеретаскивания.Значение) = Тип("СправочникСсылка.ИсходящиеДокументы") 
	 Или ТипЗнч(ПараметрыПеретаскивания.Значение) = Тип("Массив") Тогда
		ВыборЗначенияСервер(ПараметрыПеретаскивания.Значение);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Выбрать(Команда)
	
	Если ЗакрыватьПриВыборе Тогда
		Если Элементы.Список.ТекущиеДанные = Неопределено Тогда
			ПоказатьПредупреждение(, НСтр("ru = 'Не выбрана строка.'"));
			Возврат;
		КонецЕсли;
		ОповеститьОВыборе(Элементы.Список.ТекущиеДанные.Ссылка);
	Иначе
		Если ВыбранныеЗначения.Количество() = 0 Тогда
			ВыделенныеСтроки = Элементы.Список.ВыделенныеСтроки;
			Если ВыделенныеСтроки.Количество() = 0 Тогда
				ПоказатьПредупреждение(, НСтр("ru = 'Не выбран ни один документ.'"));
				Возврат;
			КонецЕсли;
			
			Если Элементы.Список.ТекущиеДанные = Неопределено Тогда
				Возврат;
			КонецЕсли;
			ОповеститьОВыборе(Элементы.Список.ТекущиеДанные.Ссылка);
			
		ИначеЕсли ВыбранныеЗначения.Количество() = 1 Тогда
			ОповеститьОВыборе(ВыбранныеЗначения[0].Значение);
		ИначеЕсли ВыбранныеЗначения.Количество() > 1 Тогда
			ОповеститьОВыборе(ВыбранныеЗначения.ВыгрузитьЗначения());
		КонецЕсли;
		Закрыть();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПоказыватьУдаленные(Команда)
	
	ПоказыватьУдаленные = Не ПоказыватьУдаленные;
	
	ПоказатьУдаленные();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ВыборЗначенияСервер(ВыбранноеЗначение)
	
	Если ТипЗнч(ВыбранноеЗначение) = Тип("Массив") Тогда 
		ЗначениеМассив = ВыбранноеЗначение;
	Иначе	
		ЗначениеМассив = Новый Массив;
		ЗначениеМассив.Добавить(ВыбранноеЗначение);
	КонецЕсли;
	
	Для Каждого Значение Из ЗначениеМассив Цикл
		Элемент = ВыбранныеЗначения.НайтиПоЗначению(Значение);
		Если Элемент = Неопределено Тогда
			ВыбранныеЗначения.Добавить(Значение);
			ВыбранныеЗначения.СортироватьПоПредставлению();
		Иначе
			ВыбранныеЗначения.Удалить(Элемент);
		КонецЕсли;
	КонецЦикла;
	
	ОбновитьОтображение();
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьОтображение()
	ВыбранныеДокументыНадпись = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		НСтр("ru = 'Выбранные документы (%1):'"),
			ВыбранныеЗначения.Количество());
	УсловноеОформление.Элементы[0].Отбор.Элементы[0].ПравоеЗначение = ВыбранныеЗначения;
КонецПроцедуры

&НаСервере
Процедура ПоказатьУдаленные()
	
	Если ПоказыватьУдаленные Тогда
		ОбщегоНазначенияКлиентСервер.УдалитьЭлементыГруппыОтбораДинамическогоСписка(Список, "ПометкаУдаления");
	Иначе	
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Список, "ПометкаУдаления", Ложь);
	КонецЕсли;	
	
	Элементы.ПоказыватьУдаленные.Пометка = ПоказыватьУдаленные;
	
КонецПроцедуры

&НаКлиенте
Процедура СоздатьНовыйДокумент(Копирование)
	
	Если Копирование Тогда 
		
		ТекущиеДанные = Элементы.Список.ТекущиеДанные;
		Если ТекущиеДанные <> Неопределено Тогда 
			ПараметрыФормы = Новый Структура;
			ПараметрыФормы.Вставить("ЗначениеКопирования", ТекущиеДанные.Ссылка);
			Открытьформу("Справочник.ИсходящиеДокументы.ФормаОбъекта", ПараметрыФормы, Элементы.Список, Новый УникальныйИдентификатор);
		КонецЕсли;	
		
	Иначе	
		
		ОписаниеОповещения = Новый ОписаниеОповещения(
			"СоздатьНовыйДокументПродолжение",
			ЭтотОбъект);
			
		Если КоличествоДоступныхШаблоновДокументов > 0 Тогда
			РаботаСШаблонамиДокументовКлиент.ПоказатьФормуСозданияДокументаПоШаблону(
				ОписаниеОповещения,
				"ШаблоныИсходящихДокументов");
		Иначе
			Результат = "СоздатьПустойДокумент";
			ВыполнитьОбработкуОповещения(ОписаниеОповещения, Результат);
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СоздатьНовыйДокументПродолжение(Результат, Параметры) Экспорт
	
	Если Результат = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	КлючеваяОперация = "ИсходящиеДокументыВыполнениеКомандыСоздать";
	ОценкаПроизводительностиКлиентСервер.НачатьЗамерВремени(КлючеваяОперация);
	
	ПараметрыФормы = Новый Структура;
	
	Если ТипЗнч(Результат) = Тип("Строка") Тогда
		ПараметрыФормы.Вставить("ШаблонДокумента", Результат);
	Иначе
		ПараметрыФормы.Вставить("ШаблонДокумента", Результат.ШаблонДокумента);
	КонецЕсли;
	
	Открытьформу("Справочник.ИсходящиеДокументы.ФормаОбъекта", ПараметрыФормы, Элементы.Список, Новый УникальныйИдентификатор);
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ОбновитьКоличествоДоступныхШаблоновВыполнить()

	Запрос = Новый Запрос();
	Запрос.Текст = "ВЫБРАТЬ РАЗРЕШЕННЫЕ
	               |	ШаблоныДокументов.Код
	               |ИЗ
	               |	Справочник.ШаблоныИсходящихДокументов КАК ШаблоныДокументов";
	Возврат Запрос.Выполнить().Выбрать().Количество();
	
КонецФункции

&НаКлиенте
Процедура ОбновитьКоличествоДоступныхШаблонов()
	
	КоличествоДоступныхШаблоновДокументов = ОбновитьКоличествоДоступныхШаблоновВыполнить();
	
КонецПроцедуры

#КонецОбласти
