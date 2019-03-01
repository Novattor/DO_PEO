
#Область ПрограммныйИнтерфейс

Процедура ВыбратьАдресатов(ПараметрыФормы, ФормаВладельца, ОписаниеОповещенияОбработкиВыбора) Экспорт
	
	Если Не ПараметрыФормы.Свойство("КонтролироватьДублиАдресатов") Тогда
		ПараметрыФормы.Вставить("КонтролироватьДублиАдресатов", Истина);
	КонецЕсли;
	
	ОткрытьФорму("Справочник.АдреснаяКнига.ФормаСписка",
		ПараметрыФормы,
		ФормаВладельца,,,,
		ОписаниеОповещенияОбработкиВыбора,
		РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

Функция СтруктураВыбранногоАдресата() Экспорт
	
	СтруктураВыбранногоАдресата = Новый Структура(
		"Контакт");
		
	Возврат СтруктураВыбранногоАдресата;
	
КонецФункции

// Подбор/выбор исполнителей для процессов

Процедура ПодобратьИсполнителейДляПроцессов(
	Форма, ТаблицаИсполнителей, ОписаниеОповещенияОбработкиВыбора, КонтролироватьДублиАдресатов = Истина) Экспорт
	
	ВыбранныеАдресаты = Новый Массив;
	
	Для Каждого СтрИсполнитель Из ТаблицаИсполнителей Цикл
		
		Если Не ЗначениеЗаполнено(СтрИсполнитель.Исполнитель) Тогда
			Продолжить;
		КонецЕсли;
		
		ВыбранныеАдресаты.Добавить(СтрИсполнитель.Исполнитель);
		
	КонецЦикла;
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("РежимРаботыФормы", 2);
	ПараметрыФормы.Вставить("УпрощенныйИнтерфейс", Истина);
	ПараметрыФормы.Вставить("ОтображатьСотрудников", Истина);
	ПараметрыФормы.Вставить("ОтображатьРоли", Истина);
	ПараметрыФормы.Вставить("ЗаголовокФормы", НСтр("ru = 'Подбор исполнителей'"));
	ПараметрыФормы.Вставить("ЗаголовокСпискаВыбранных", НСтр("ru = 'Выбранные пользователи и роли:'"));
	ПараметрыФормы.Вставить("ЗаголовокСпискаАдреснойКниги", НСтр("ru = 'Все пользователи и роли:'"));
	ПараметрыФормы.Вставить("ВыбранныеАдресаты", ВыбранныеАдресаты);
	ПараметрыФормы.Вставить("КонтролироватьДублиАдресатов", КонтролироватьДублиАдресатов);
	
	ВыбратьАдресатов(ПараметрыФормы, Форма, ОписаниеОповещенияОбработкиВыбора);
	
КонецПроцедуры

Процедура ВыбратьИсполнителяДляПроцесса(
	Форма, ТаблицаФормы, ОписаниеОповещенияОбработкиВыбора = Неопределено) Экспорт
	
	ДопПараметры = Новый Структура;
	ДопПараметры.Вставить("Форма", Форма);
	ДопПараметры.Вставить("ТаблицаФормы", ТаблицаФормы);
	ДопПараметры.Вставить("ОписаниеОповещенияОбработкиВыбора", ОписаниеОповещенияОбработкиВыбора);
	
	ОписаниеОповещения = Новый ОписаниеОповещения(
		"ЗавершитьВыборИсполнителяДляПроцессов", ЭтотОбъект, ДопПараметры);
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("РежимРаботыФормы", 1);
	ПараметрыФормы.Вставить("УпрощенныйИнтерфейс", Истина);
	ПараметрыФормы.Вставить("ОтображатьСотрудников", Истина);
	ПараметрыФормы.Вставить("ОтображатьРоли", Истина);
	ПараметрыФормы.Вставить("ЗаголовокФормы", НСтр("ru = 'Выбор исполнителя'"));
	
	Если ТаблицаФормы.ТекущиеДанные <> Неопределено
		И ЗначениеЗаполнено(ТаблицаФормы.ТекущиеДанные.Исполнитель) Тогда
		ПараметрыФормы.Вставить("ВыбранныеАдресаты", ТаблицаФормы.ТекущиеДанные.Исполнитель);
	КонецЕсли;
	
	ВыбратьАдресатов(ПараметрыФормы, Форма, ОписаниеОповещения);
	
КонецПроцедуры

Процедура ЗавершитьВыборИсполнителяДляПроцессов(ВыбранныйИсполнитель, ДопПараметры) Экспорт
	
	Если ВыбранныйИсполнитель = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ДопПараметры.ТаблицаФормы.ТекущиеДанные.Исполнитель = ВыбранныйИсполнитель;
	ДопПараметры.Форма.Модифицированность = Истина;
	
	Если ДопПараметры.ОписаниеОповещенияОбработкиВыбора <> Неопределено Тогда
		ВыполнитьОбработкуОповещения(ДопПараметры.ОписаниеОповещенияОбработкиВыбора, Неопределено);
	КонецЕсли;
	
КонецПроцедуры

Процедура ВыбратьУчастникаПроцесса(
	Элемент, ВыбранноеЗначение, СтандартнаяОбработка, Форма, Участник, ОписаниеОповещения = Неопределено) Экспорт
	
	СтандартнаяОбработка = Ложь;
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("РежимРаботыФормы", 1);
	ПараметрыФормы.Вставить("УпрощенныйИнтерфейс", Истина);
	ПараметрыФормы.Вставить("ОтображатьСотрудников", Истина);
	ПараметрыФормы.Вставить("ОтображатьРоли", Истина);
	ПараметрыФормы.Вставить("ЗаголовокФормы", НСтр("ru = 'Выбор исполнителя'"));
	
	Если ЗначениеЗаполнено(ВыбранноеЗначение) Тогда
		ПараметрыФормы.Вставить("ВыбранныеАдресаты", ВыбранноеЗначение);
	КонецЕсли;
	
	ОткрытьФорму("Справочник.АдреснаяКнига.Форма.ФормаСписка",
		ПараметрыФормы, 
		Элемент,,,,
		ОписаниеОповещения,
		РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

// Подбор/выбор исполнителей для шаблонов процессов

Процедура ПодобратьИсполнителейДляШаблоновПроцессов(
	Форма, ОписаниеОповещенияОбработкиВыбора, КонтролироватьДублиАдресатов = Истина) Экспорт
	
	ИменаПредметов = МультипредметностьКлиентСервер.
		ПолучитьМассивИменПредметовОбъекта(Форма.Объект);
		
	СписокПредметов = Новый СписокЗначений;
	СписокПредметов.ЗагрузитьЗначения(ИменаПредметов);
		
	ВыбранныеАдресаты = Новый Массив;
	
	Для Каждого СтрИсполнитель Из Форма.Объект.Исполнители Цикл
		
		Если Не ЗначениеЗаполнено(СтрИсполнитель.Исполнитель) Тогда
			Продолжить;
		КонецЕсли;
		
		ВыбранныеАдресаты.Добавить(СтрИсполнитель.Исполнитель);
		
	КонецЦикла;
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("РежимРаботыФормы", 2);
	ПараметрыФормы.Вставить("УпрощенныйИнтерфейс", Истина);
	ПараметрыФормы.Вставить("ОтображатьСотрудников", Истина);
	ПараметрыФормы.Вставить("ОтображатьРоли", Истина);
	
	Если Не ЗначениеЗаполнено(Форма.Объект.ВладелецШаблона)
		Или ТипЗнч(Форма.Объект.ВладелецШаблона) <> Тип("БизнесПроцессСсылка.КомплексныйПроцесс") Тогда
		
		ПараметрыФормы.Вставить("ОтображатьАвтоподстановкиПоПроцессам", Истина);
	КонецЕсли;
	
	ПараметрыФормы.Вставить("ЗаголовокФормы", НСтр("ru = 'Подбор исполнителей'"));
	ПараметрыФормы.Вставить("ЗаголовокСпискаВыбранных", НСтр("ru = 'Выбранные пользователи и роли:'"));
	ПараметрыФормы.Вставить("ЗаголовокСпискаАдреснойКниги", НСтр("ru = 'Все пользователи и роли:'"));
	ПараметрыФормы.Вставить("ВыбранныеАдресаты", ВыбранныеАдресаты);
	ПараметрыФормы.Вставить("ИменаПредметов", СписокПредметов);
	ПараметрыФормы.Вставить("КонтролироватьДублиАдресатов", КонтролироватьДублиАдресатов);
	
	ВыбратьАдресатов(ПараметрыФормы, Форма, ОписаниеОповещенияОбработкиВыбора);
	
КонецПроцедуры

Процедура ВыбратьИсполнителяДляШаблонаПроцесса(
	Форма, ТаблицаФормы, ОписаниеОповещенияОбработкиВыбора = Неопределено) Экспорт
	
	ИменаПредметов = МультипредметностьКлиентСервер.
		ПолучитьМассивИменПредметовОбъекта(Форма.Объект);
		
	СписокПредметов = Новый СписокЗначений;
	СписокПредметов.ЗагрузитьЗначения(ИменаПредметов);
		
	ДопПараметры = Новый Структура;
	ДопПараметры.Вставить("Форма", Форма);
	ДопПараметры.Вставить("ТаблицаФормы", ТаблицаФормы);
	ДопПараметры.Вставить("ОписаниеОповещенияОбработкиВыбора", ОписаниеОповещенияОбработкиВыбора);
	
	ОписаниеОповещения = Новый ОписаниеОповещения(
		"ЗавершитьВыборИсполнителяДляПроцессов", ЭтотОбъект, ДопПараметры);
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("РежимРаботыФормы", 1);
	ПараметрыФормы.Вставить("УпрощенныйИнтерфейс", Истина);
	ПараметрыФормы.Вставить("ОтображатьСотрудников", Истина);
	ПараметрыФормы.Вставить("ОтображатьРоли", Истина);
	ПараметрыФормы.Вставить("ЗаголовокФормы", НСтр("ru = 'Выбор исполнителя'"));
	
	Если Не ЗначениеЗаполнено(Форма.Объект.ВладелецШаблона)
		Или ТипЗнч(Форма.Объект.ВладелецШаблона) <> Тип("БизнесПроцессСсылка.КомплексныйПроцесс") Тогда
		
		ПараметрыФормы.Вставить("ОтображатьАвтоподстановкиПоПроцессам", Истина);
	КонецЕсли;
	
	ПараметрыФормы.Вставить("ИменаПредметов", СписокПредметов);
	
	ВыбратьАдресатов(ПараметрыФормы, Форма, ОписаниеОповещения);
	
КонецПроцедуры

Процедура ВыбратьУчастникаДляШаблонаПроцесса(
	Элемент, ВыбранноеЗначение, СтандартнаяОбработка, Форма, Участник, ОписаниеОповещения = Неопределено) Экспорт
	
	СтандартнаяОбработка = Ложь;
	
	ИменаПредметов = МультипредметностьКлиентСервер.ПолучитьМассивИменПредметовОбъекта(Форма.Объект);
	
	СписокПредметов = Новый СписокЗначений;
	СписокПредметов.ЗагрузитьЗначения(ИменаПредметов);
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("РежимРаботыФормы", 1);
	ПараметрыФормы.Вставить("УпрощенныйИнтерфейс", Истина);
	ПараметрыФормы.Вставить("ОтображатьСотрудников", Истина);
	ПараметрыФормы.Вставить("ОтображатьРоли", Истина);
	
	Если Не ЗначениеЗаполнено(Форма.Объект.ВладелецШаблона)
		Или ТипЗнч(Форма.Объект.ВладелецШаблона) <> Тип("БизнесПроцессСсылка.КомплексныйПроцесс") Тогда
		ПараметрыФормы.Вставить("ОтображатьАвтоподстановкиПоПроцессам", Истина);
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ВыбранноеЗначение) Тогда
		ПараметрыФормы.Вставить("ВыбранныеАдресаты", ВыбранноеЗначение);
	КонецЕсли;
	
	ПараметрыФормы.Вставить("ИменаПредметов", СписокПредметов);
	ПараметрыФормы.Вставить("ЗаголовокФормы", НСтр("ru = 'Выбор исполнителя'"));
	
	ОткрытьФорму("Справочник.АдреснаяКнига.Форма.ФормаСписка",
		ПараметрыФормы, 
		Элемент,,,,
		ОписаниеОповещения,
		РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
		
КонецПроцедуры

// Подбор/выбор пользователей для контрольных карточек

Процедура ПодобратьПользователейДляКонтроля(
	Форма, ТаблицаИсполнителей, ОписаниеОповещенияОбработкиВыбора) Экспорт
	
	ВыбранныеАдресаты = Новый Массив;
	
	Для Каждого СтрИсполнитель Из ТаблицаИсполнителей Цикл
		
		Если Не ЗначениеЗаполнено(СтрИсполнитель.Исполнитель) Тогда
			Продолжить;
		КонецЕсли;
		
		ВыбранныеАдресаты.Добавить(СтрИсполнитель.Исполнитель);
		
	КонецЦикла;
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("РежимРаботыФормы", 2);
	ПараметрыФормы.Вставить("УпрощенныйИнтерфейс", Истина);
	ПараметрыФормы.Вставить("ОтображатьСотрудников", Истина);
	ПараметрыФормы.Вставить("ОтображатьРоли", Истина);
	ПараметрыФормы.Вставить("ЗаголовокФормы", НСтр("ru = 'Подбор исполнителей'"));
	ПараметрыФормы.Вставить("ЗаголовокСпискаВыбранных", НСтр("ru = 'Выбранные пользователи и роли:'"));
	ПараметрыФормы.Вставить("ЗаголовокСпискаАдреснойКниги", НСтр("ru = 'Все пользователи и роли:'"));
	ПараметрыФормы.Вставить("ВыбранныеАдресаты", ВыбранныеАдресаты);
	
	ВыбратьАдресатов(ПараметрыФормы, Форма, ОписаниеОповещенияОбработкиВыбора);
	
КонецПроцедуры

Процедура ВыбратьПользователяДляКонтроля(Форма, Элемент, ВыбранноеЗначение,
	СписокОтбора = Неопределено) Экспорт
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("РежимРаботыФормы", 1);
	ПараметрыФормы.Вставить("УпрощенныйИнтерфейс", Истина);
	ПараметрыФормы.Вставить("ОтображатьСотрудников", Истина);
	ПараметрыФормы.Вставить("ОтображатьРоли", Истина);
	ПараметрыФормы.Вставить("ЗаголовокФормы", НСтр("ru = 'Выбор исполнителя'"));
	
	Если ЗначениеЗаполнено(ВыбранноеЗначение) Тогда
		ПараметрыФормы.Вставить("ВыбранныеАдресаты", ВыбранноеЗначение);
	КонецЕсли;
	Если СписокОтбора <> Неопределено Тогда
		ПараметрыФормы.Вставить("СписокОтбора", СписокОтбора);
	КонецЕсли;
	
	ОткрытьФорму("Справочник.АдреснаяКнига.Форма.ФормаСписка",
		ПараметрыФормы,
		Элемент,,,,,
		РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

// Подбор/выбор согласующих для шаблонов документов.

Процедура ПодобратьСогласующихДляШаблонаДокумента(Форма) Экспорт
	
	Объект = ПолучитьОбъектФормы(Форма);
	ВыбранныеАдресаты = Новый Массив;
	
	Для Каждого СтрИсполнитель Из Объект.ИсполнителиСогласования Цикл
		Если Не ЗначениеЗаполнено(СтрИсполнитель.Исполнитель) Тогда
			Продолжить;
		КонецЕсли;
		ВыбранныеАдресаты.Добавить(СтрИсполнитель.Исполнитель);
	КонецЦикла;
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("РежимРаботыФормы", 2);
	ПараметрыФормы.Вставить("УпрощенныйИнтерфейс", Истина);
	ПараметрыФормы.Вставить("ОтображатьСотрудников", Истина);
	ПараметрыФормы.Вставить("ОтображатьРоли", Истина);
	ПараметрыФормы.Вставить("ЗаголовокФормы", НСтр("ru = 'Подбор исполнителей'"));
	ПараметрыФормы.Вставить("ЗаголовокСпискаВыбранных", НСтр("ru = 'Выбранные пользователи и роли:'"));
	ПараметрыФормы.Вставить("ЗаголовокСпискаАдреснойКниги", НСтр("ru = 'Все пользователи и роли:'"));
	ПараметрыФормы.Вставить("ВыбранныеАдресаты", ВыбранныеАдресаты);
	ПараметрыФормы.Вставить("КонтролироватьДублиАдресатов", Истина);
	
	ОткрытьФорму("Справочник.АдреснаяКнига.ФормаСписка",
		ПараметрыФормы,
		Форма.Элементы.ИсполнителиСогласования,,,,,
		РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

Процедура ВыбратьСогласующегоДляШаблонаДокумента(Форма) Экспорт
	
	СтандартнаяОбработка = Ложь;
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("РежимРаботыФормы", 1);
	ПараметрыФормы.Вставить("УпрощенныйИнтерфейс", Истина);
	ПараметрыФормы.Вставить("ОтображатьСотрудников", Истина);
	ПараметрыФормы.Вставить("ОтображатьРоли", Истина);
	ПараметрыФормы.Вставить("ЗаголовокФормы", НСтр("ru = 'Выбор исполнителей'"));
	
	Если Форма.Элементы.ИсполнителиСогласования.ТекущиеДанные <> Неопределено Тогда
		ПараметрыФормы.Вставить("ВыбранныеАдресаты",
			Форма.Элементы.ИсполнителиСогласования.ТекущиеДанные.Исполнитель);
	КонецЕсли;
	
	ОткрытьФорму("Справочник.АдреснаяКнига.ФормаСписка",
		ПараметрыФормы,
		Форма.Элементы.ИсполнителиСогласованияИсполнитель,,,,,
		РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
		
	
КонецПроцедуры

// Подбор/выбор участников рабочей группы

Процедура ПодобратьУчастниковРабочейГруппы(Форма) Экспорт
	
	ВыбратьУчастниковРабочейГруппы(Форма, Истина);
	
КонецПроцедуры

Процедура ВыбратьУчастникаРабочейГруппы(Форма, СтандартнаяОбработка) Экспорт
	
	СтандартнаяОбработка = Ложь;
	
	ВыбратьУчастниковРабочейГруппы(Форма, Ложь);
	
КонецПроцедуры

// Подбор/выбор участников рабочей группы для шаблонов документов

Процедура ПодобратьУчастниковРабочейГруппыДляШаблоновДокументов(Форма) Экспорт
	
	ВыбратьУчастниковРабочейГруппы_ШаблоныДокументов(Форма, Истина);
	
КонецПроцедуры

Процедура ВыбратьУчастникаРабочейГруппыДляШаблоновДокументов(Форма) Экспорт
	
	ВыбратьУчастниковРабочейГруппы_ШаблоныДокументов(Форма, Ложь);
	
КонецПроцедуры

// Подбор/выбор лиц утверждающих документ

Процедура ПодобратьУтверждающихДляШаблонаДокумента(Форма) Экспорт
	
	Объект = ПолучитьОбъектФормы(Форма);
	ВыбранныеАдресаты = Новый Массив;
	
	Для Каждого СтрИсполнитель Из Объект.ГрифыУтверждения Цикл
		Если Не ЗначениеЗаполнено(СтрИсполнитель.АвторУтверждения) Тогда
			Продолжить;
		КонецЕсли;
		ВыбранныеАдресаты.Добавить(СтрИсполнитель.АвторУтверждения);
	КонецЦикла;
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("РежимРаботыФормы", 2);
	ПараметрыФормы.Вставить("УпрощенныйИнтерфейс", Истина);
	ПараметрыФормы.Вставить("ОтображатьСотрудников", Истина);
	ПараметрыФормы.Вставить("ЗаголовокФормы", НСтр("ru = 'Подбор утверждающих'"));
	ПараметрыФормы.Вставить("ЗаголовокСпискаВыбранных", НСтр("ru = 'Выбранные пользователи:'"));
	ПараметрыФормы.Вставить("ЗаголовокСпискаАдреснойКниги", НСтр("ru = 'Все пользователи:'"));
	ПараметрыФормы.Вставить("ВыбранныеАдресаты", ВыбранныеАдресаты);
	ПараметрыФормы.Вставить("КонтролироватьДублиАдресатов", Истина);
	
	ОткрытьФорму("Справочник.АдреснаяКнига.ФормаСписка",
		ПараметрыФормы,
		Форма.Элементы.ГрифыУтверждения,,,,,
		РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);

КонецПроцедуры

Процедура ВыбратьУтверждающегоДляШаблонаДокумента(Форма) Экспорт
	
	СтандартнаяОбработка = Ложь;
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("РежимРаботыФормы", 1);
	ПараметрыФормы.Вставить("УпрощенныйИнтерфейс", Истина);
	ПараметрыФормы.Вставить("ОтображатьСотрудников", Истина);
	ПараметрыФормы.Вставить("ОтображатьРоли", Истина);
	ПараметрыФормы.Вставить("ЗаголовокФормы", НСтр("ru = 'Выбор утверждающих'"));
	
	Если Форма.Элементы.ГрифыУтверждения.ТекущиеДанные <> Неопределено Тогда
		ПараметрыФормы.Вставить("ВыбранныеАдресаты",
			Форма.Элементы.ГрифыУтверждения.ТекущиеДанные.АвторУтверждения);
	КонецЕсли;
	
	ОткрытьФорму("Справочник.АдреснаяКнига.ФормаСписка",
		ПараметрыФормы,
		Форма.Элементы.ГрифыУтвержденияАвторУтверждения,,,,,
		РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);

КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ВыбратьУчастниковРабочейГруппы(Форма, МножественныйВыбор)
	
	РабочаяГруппа = Новый Массив;
	ТекущиеДанные = Форма.Элементы.РабочаяГруппаТаблица.ТекущиеДанные;
	
	Если МножественныйВыбор Или Не ЗначениеЗаполнено(ТекущиеДанные.Участник) Тогда
		Для Каждого РабочаяГруппаТаблицаСтрока Из Форма.РабочаяГруппаТаблица Цикл
			Если ЗначениеЗаполнено(РабочаяГруппаТаблицаСтрока.Участник) Тогда 
				Участник = СтруктураВыбранногоАдресата();
				Участник.Вставить("Контакт", РабочаяГруппаТаблицаСтрока.Участник);
				РабочаяГруппа.Добавить(Участник);
			КонецЕсли;
		КонецЦикла;
		
		РежимРаботыФормы = 2;
		ЗаголовокФормы = НСтр("ru = 'Подбор участников рабочей группы'");
		ЗаголовокСпискаВыбранных = НСтр("ru = 'Выбранные участники:'");
		ЗаголовокСпискаАдреснойКниги = НСтр("ru = 'Все пользователи и роли:'");
		МножественныйВыбор = Истина;
	Иначе
		РежимРаботыФормы = 1;
		ЗаголовокФормы = НСтр("ru = 'Выбор участника рабочей группы'");
		ЗаголовокСпискаВыбранных = "";
		ЗаголовокСпискаАдреснойКниги = "";
	КонецЕсли;
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("РежимРаботыФормы", РежимРаботыФормы);
	ПараметрыФормы.Вставить("ОтображатьСотрудников", Истина);
	ПараметрыФормы.Вставить("ОтображатьРоли", Истина);
	ПараметрыФормы.Вставить("ВыбиратьКонтейнерыПользователей", Истина);
	ПараметрыФормы.Вставить("ЗаголовокФормы", ЗаголовокФормы);
	ПараметрыФормы.Вставить("ЗаголовокСпискаВыбранных", ЗаголовокСпискаВыбранных);
	ПараметрыФормы.Вставить("ЗаголовокСпискаАдреснойКниги", ЗаголовокСпискаАдреснойКниги);
	ПараметрыФормы.Вставить("ВыбранныеАдресаты", РабочаяГруппа);
	
	ДопПараметры = Новый Структура;
	ДопПараметры.Вставить("Форма", Форма);
	ДопПараметры.Вставить("МножественныйВыбор", МножественныйВыбор);
	
	ОписаниеОповещения = Новый ОписаниеОповещения(
		"ЗавершитьВыборУчастниковРабочейГруппы", ЭтотОбъект, ДопПараметры);
		
	ВыбратьАдресатов(ПараметрыФормы, Форма, ОписаниеОповещения);
	
КонецПроцедуры

Процедура ЗавершитьВыборУчастниковРабочейГруппы(ВыбранныеУчастники, ДопПараметры) Экспорт
	
	Если ВыбранныеУчастники = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Форма = ДопПараметры.Форма;
	
	Если ДопПараметры.МножественныйВыбор Тогда
		
		РеквизитТаблица = Форма.РабочаяГруппаТаблица;
		КоличествоСтрок = РеквизитТаблица.Количество();
		
		// Удаление лишних строк.
		Для Инд = 1 По КоличествоСтрок Цикл
			
			Строка = РеквизитТаблица[КоличествоСтрок - Инд];
			УдалитьУчастника = Истина;
			
			Для Каждого ВыбранныйИсполнитель Из ВыбранныеУчастники Цикл
				Если Строка.Участник = ВыбранныйИсполнитель.Контакт Тогда
					
					УдалитьУчастника = Ложь;
					Прервать;
				КонецЕсли;
			КонецЦикла;
			
			Если УдалитьУчастника Тогда
				РеквизитТаблица.Удалить(Строка);
			КонецЕсли;
			
		КонецЦикла;
		
		ИндексИзмененнойСтроки = РеквизитТаблица.Количество();
		
		// Добавление новых строк.
		Для Каждого ВыбранныйАдресат Из ВыбранныеУчастники Цикл
			
			ПараметрыОтбора = Новый Структура;
			ПараметрыОтбора.Вставить("Участник", ВыбранныйАдресат.Контакт);
			
			НайденныеСтроки = РеквизитТаблица.НайтиСтроки(ПараметрыОтбора);
			Если НайденныеСтроки.Количество() = 0 Тогда
				
				НоваяСтрока = РеквизитТаблица.Добавить();
				ЗаполнитьЗначенияСвойств(НоваяСтрока, ВыбранныйАдресат);
				НоваяСтрока.Участник = ВыбранныйАдресат.Контакт;
				
			КонецЕсли;
			
			РаботаСРабочимиГруппамиКлиент.УстановитьРеквизитыУсловногоОформления(НоваяСтрока);
			
		КонецЦикла;
	
	Иначе
		
		ТекущаяСтрока = Форма.Элементы.РабочаяГруппаТаблица.ТекущаяСтрока;
		ТекущиеДанные = Форма.РабочаяГруппаТаблица.НайтиПоИдентификатору(ТекущаяСтрока);
		ЗаполнитьЗначенияСвойств(ТекущиеДанные, ВыбранныеУчастники[0]);
		ТекущиеДанные.Участник = ВыбранныеУчастники[0].Контакт;
		РаботаСРабочимиГруппамиКлиент.УстановитьРеквизитыУсловногоОформления(ТекущиеДанные);
		
	КонецЕсли;
	
	Форма.КоличествоУчастниковРабочейГруппы = Форма.РабочаяГруппаТаблица.Количество();
	Форма.Модифицированность = Истина;
	
	РаботаСРабочимиГруппамиКлиент.РабочаяГруппаПриОкончанииРедактирования(
		Форма, Форма.Элементы.РабочаяГруппаТаблица, Ложь);
	
КонецПроцедуры

Процедура ВыбратьУчастниковРабочейГруппы_ШаблоныДокументов(Форма, МножественныйВыбор)
	
	Объект = ПолучитьОбъектФормы(Форма);
	ВыбранныеАдресаты = Новый Массив;
	ТекущиеДанные = Форма.Элементы.РабочаяГруппаДокумента.ТекущиеДанные;
	
	Если МножественныйВыбор Или Не ЗначениеЗаполнено(ТекущиеДанные.Участник) Тогда
		Для Каждого СтрУчастник Из Объект.РабочаяГруппаДокумента Цикл
			
			Если Не ЗначениеЗаполнено(СтрУчастник.Участник) Тогда
				Продолжить;
			КонецЕсли;
			
			СтруктураВыбранногоАдресата = СтруктураВыбранногоАдресата();
			СтруктураВыбранногоАдресата.Контакт = СтрУчастник.Участник;
			
			ВыбранныеАдресаты.Добавить(СтруктураВыбранногоАдресата);
			
		КонецЦикла;
		
		РежимРаботыФормы = 2;
		ЗаголовокФормы = НСтр("ru = 'Подбор участников рабочей группы'");
		ЗаголовокСпискаВыбранных = НСтр("ru = 'Выбранные участники:'");
		ЗаголовокСпискаАдреснойКниги = НСтр("ru = 'Все пользователи и роли:'");
		МножественныйВыбор = Истина;
	Иначе
		РежимРаботыФормы = 1;
		ЗаголовокФормы = НСтр("ru = 'Выбор участника рабочей группы'");
		ЗаголовокСпискаВыбранных = "";
		ЗаголовокСпискаАдреснойКниги = "";
	КонецЕсли;
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("РежимРаботыФормы", РежимРаботыФормы);
	ПараметрыФормы.Вставить("ОтображатьСотрудников", Истина);
	ПараметрыФормы.Вставить("ОтображатьРоли", Истина);
	ПараметрыФормы.Вставить("ВыбиратьКонтейнерыПользователей", Истина);
	ПараметрыФормы.Вставить("ОтображатьАвтоподстановкиПоДокументам", Истина);
	ПараметрыФормы.Вставить("ЗаголовокФормы", ЗаголовокФормы);
	ПараметрыФормы.Вставить("ЗаголовокСпискаВыбранных", ЗаголовокСпискаВыбранных);
	ПараметрыФормы.Вставить("ЗаголовокСпискаАдреснойКниги", ЗаголовокСпискаАдреснойКниги);
	ПараметрыФормы.Вставить("ВыбранныеАдресаты", ВыбранныеАдресаты);
	
	ДопПараметры = Новый Структура;
	ДопПараметры.Вставить("Форма", Форма);
	ДопПараметры.Вставить("МножественныйВыбор", МножественныйВыбор);
	
	ОписаниеОповещения = Новый ОписаниеОповещения(
		"ЗавершитьВыборУчастниковРабочейГруппы_ШаблоныДокументов", ЭтотОбъект, ДопПараметры);
		
	ВыбратьАдресатов(ПараметрыФормы, Форма, ОписаниеОповещения);
	
КонецПроцедуры

Процедура ЗавершитьВыборУчастниковРабочейГруппы_ШаблоныДокументов(ВыбранныеУчастники, ДопПараметры) Экспорт
	
	Если ВыбранныеУчастники = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	форма = ДопПараметры.форма;
	Объект = ПолучитьОбъектФормы(Форма);
	
	Если ДопПараметры.МножественныйВыбор Тогда
		
		РеквизитТаблица = Объект.РабочаяГруппаДокумента;
		КоличествоСтрок = РеквизитТаблица.Количество();
		
		// Удаление лишних строк.
		Для Инд = 1 По КоличествоСтрок Цикл
			
			Строка = РеквизитТаблица[КоличествоСтрок - Инд];
			УдалитьУчастника = Истина;
			
			Для Каждого ВыбранныйИсполнитель Из ВыбранныеУчастники Цикл
				Если Строка.Участник = ВыбранныйИсполнитель.Контакт Тогда
					
					УдалитьУчастника = Ложь;
					Прервать;
				КонецЕсли;
			КонецЦикла;
			
			Если УдалитьУчастника Тогда
				РеквизитТаблица.Удалить(Строка);
			КонецЕсли;
			
		КонецЦикла;
		
		ИндексИзмененнойСтроки = РеквизитТаблица.Количество();
		
		// Добавление новых строк.
		Для Каждого ВыбранныйАдресат Из ВыбранныеУчастники Цикл
			
			ПараметрыОтбора = Новый Структура;
			ПараметрыОтбора.Вставить("Участник", ВыбранныйАдресат.Контакт);
			
			НайденныеСтроки = РеквизитТаблица.НайтиСтроки(ПараметрыОтбора);
			Если НайденныеСтроки.Количество() = 0 Тогда
				
				НоваяСтрока = РеквизитТаблица.Добавить();
				ЗаполнитьЗначенияСвойств(НоваяСтрока, ВыбранныйАдресат);
				НоваяСтрока.Участник = ВыбранныйАдресат.Контакт;
				
			КонецЕсли;
			
			РаботаСРабочимиГруппамиКлиент.УстановитьРеквизитыУсловногоОформления(НоваяСтрока);
			
		КонецЦикла;
		
	Иначе
		
		ТекущиеДанные = форма.Элементы.РабочаяГруппаДокумента.ТекущиеДанные;
		ЗаполнитьЗначенияСвойств(ТекущиеДанные, ВыбранныеУчастники[0]);
		ТекущиеДанные.Участник = ВыбранныеУчастники[0].Контакт;
		
		РаботаСРабочимиГруппамиКлиент.УстановитьРеквизитыУсловногоОформления(НоваяСтрока);
		
	КонецЕсли;
	
	Форма.Модифицированность = Истина;
	
	РаботаСРабочимиГруппамиКлиент.ШаблонРабочаяГруппаПриОкончанииРедактирования(
		Форма,
		Объект.РабочаяГруппаДокумента,
		Форма.Элементы.РабочаяГруппаДокумента,
		Ложь); // ОтменаРедактирования
	
КонецПроцедуры

Функция ПолучитьОбъектФормы(Форма)
	
	Если ДелопроизводствоКлиентСервер.ЭтоФормаВидаДокумента(Форма.ИмяФормы) Тогда 
		Возврат Форма.ШаблонДокумента;
	Иначе 
		Возврат Форма.Объект;
	КонецЕсли;
	
КонецФункции

#КонецОбласти