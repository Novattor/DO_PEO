////////////////////////////////////////////////////////////////////////////////
// Подсистема "Базовая функциональность".
// В этом модуле содержится реализация обработчиков модуля приложения. 
//
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Выполняется перед интерактивным началом работы пользователя с областью данных или в локальном режиме.
//
// Соответствует обработчику ПередНачаломРаботыСистемы.
//
// Параметры:
//  Параметры - Структура - структура со свойствами:
//              Отказ                  - Булево - Возвращаемое значение. Если установить Истина,
//                                       то работа программы будет прекращена.
//              Перезапустить          - Булево - Возвращаемое значение. Если установить Истина и параметр.
//                                       Отказ тоже установлен в Истина, то выполняется перезапуск программы.
//              ДополнительныеПараметрыКоманднойСтроки - Строка - Возвращаемое значение. Имеет смысл
//                                       когда Отказ и Перезапустить установлены Истина.
//              ИнтерактивнаяОбработка - ОписаниеОповещения - Возвращаемое значение. Для открытия окна,
//                                       блокирующего вход в программу, следует присвоить в этот параметр
//                                       описание обработчика оповещения, который открывает окно.
//                                       См. пример ниже.
//              ОбработкаПродолжения   - ОписаниеОповещения - если открывается окно, блокирующее вход
//                                       в программу, то в обработке закрытия этого окна необходимо
//                                       выполнить оповещение ОбработкаПродолжения.
//                                       См. пример ниже.
//
// Пример открытия окна, блокирующего вход в программу:
//
//		Если ОткрытьОкноПриЗапуске Тогда
//			Параметры.ИнтерактивнаяОбработка = Новый ОписаниеОповещения("ОткрытьОкно", ЭтотОбъект);
//		КонецЕсли;
//
//	Процедура ОткрытьОкно(Параметры, ДополнительныеПараметры) Экспорт
//		// Показываем окно, по закрытию которого вызывается обработчик оповещения ОткрытьОкноЗавершение.
//		Оповещение = Новый ОписаниеОповещения("ОткрытьОкноЗавершение", ЭтотОбъект, Параметры);
//		Форма = ОткрытьФорму(... ,,, ... Оповещение);
//		Если Не Форма.Открыта() Тогда // Если ПриСозданииНаСервере Отказ установлен Истина.
//			ВыполнитьОбработкуОповещения(Параметры.ОбработкаПродолжения);
//		КонецЕсли;
//	КонецПроцедуры
//
//	Процедура ОткрытьОкноЗавершение(Результат, Параметры) Экспорт
//		...
//		ВыполнитьОбработкуОповещения(Параметры.ОбработкаПродолжения);
//		
//	КонецПроцедуры
//
Процедура ПередНачаломРаботыСистемы(Параметры) Экспорт
	
	ПараметрыРаботыКлиента = СтандартныеПодсистемыКлиентПовтИсп.ПараметрыРаботыКлиентаПриЗапуске();
	Если ПараметрыРаботыКлиента.ОткрытьРасчетПравДоступаПослеОбновления Тогда
		Параметры.ИнтерактивнаяОбработка = Новый ОписаниеОповещения("ОткрытьРасчетПравДоступаПослеОбновления", ЭтотОбъект);
	ИначеЕсли ПараметрыРаботыКлиента.ЗапретРасчетПравДоступаПослеОбновления Тогда
		Параметры.Отказ = Истина;
		Параметры.ИнтерактивнаяОбработка = Новый ОписаниеОповещения("ЗапретРасчетПравДоступаПослеОбновления", ЭтотОбъект);
	ИначеЕсли ПараметрыРаботыКлиента.ПредупреждениеРасчетПравДоступаПослеОбновления Тогда
		Параметры.ИнтерактивнаяОбработка = Новый ОписаниеОповещения("ПредупреждениеРасчетПравДоступаПослеОбновления", ЭтотОбъект);
	КонецЕсли;
	
КонецПроцедуры

// Выполняется при интерактивном начале работы пользователя с областью данных или в локальном режиме.
//
// Соответствует обработчику ПриНачалеРаботыСистемы.
//
// Параметры:
//  Параметры - Структура - структура со свойствами:
//            * Отказ                  - Булево - Возвращаемое значение. Если установить Истина,
//                                       то работа программы будет прекращена.
//            * Перезапустить          - Булево - Возвращаемое значение. Если установить Истина и параметр.
//                                       Отказ тоже установлен в Истина, то выполняется перезапуск программы.
//            * ДополнительныеПараметрыКоманднойСтроки - Строка - Возвращаемое значение. Имеет смысл
//                                       когда Отказ и Перезапустить установлены Истина.
//            * ИнтерактивнаяОбработка - ОписаниеОповещения - Возвращаемое значение. Для открытия окна,
//                                       блокирующего вход в программу, следует присвоить в этот параметр
//                                       описание обработчика оповещения, который открывает окно.
//                                       См. пример выше (для обработчика ПередНачаломРаботыСистемы).
//            * ОбработкаПродолжения   - ОписаниеОповещения - если открывается окно, блокирующее вход
//                                       в программу, то в обработке закрытия этого окна необходимо
//                                       выполнить оповещение ОбработкаПродолжения.
//                                       См. пример выше (для обработчика ПередНачаломРаботыСистемы).
//
Процедура ПриНачалеРаботыСистемы(Параметры) Экспорт
	
	// ИнтернетПоддержкаПользователей
	ИнтернетПоддержкаПользователейКлиент.ПриНачалеРаботыСистемы();
	// Конец ИнтернетПоддержкаПользователе
	
	ПодключитьВнешнююКомпоненту("ОбщийМакет.ДрайверСканераШтрихкодов");
	РаботаСТорговымОборудованием.ОтключитьСканерШтрихкодов();
	РаботаСТорговымОборудованием.ПодключитьСканерШтрихкодов("ПоискДокументовПоШтрихкоду");

	ПротоколированиеРаботыПользователей.ЗаписатьВходВСистему();
	ФайловыеФункцииКлиент.ПеренестиЗаписиИзРегистраФайлыВРабочемКаталоге();
	ФайловыеФункцииКлиент.ПеренестиЗаписиИзРегистраРабочиеКаталогиФайлов();
	
	ОбщийОбработчикОжиданияКлиент.ПодключитьОбщийОбработчикОжидания();
	
	// ВстроеннаяПочта
	СтандартныеПодсистемыКлиент.УстановитьПараметрКлиента(
		"АвтоматическиСохранятьВерсииНеотправленногоПисьма", 
		ВстроеннаяПочтаСервер.ПолучитьПерсональнуюНастройку("АвтоматическиСохранятьВерсииНеотправленногоПисьма"));
	// ВстроеннаяПочта	
	
КонецПроцедуры

// Обработать параметры запуска программы.
// Реализация функции может быть расширена для обработки новых параметров.
//
// Параметры:
//  ЗначениеПараметраЗапуска - Строка - первое значение параметра запуска, 
//                                      до первого символа ";".
//  ПараметрыЗапуска  - Строка - параметр запуска, переданный в конфигурацию 
//                               с помощью ключа командной строки /C.
//  Отказ             - Булево - Возвращаемое значение. Если установить Истина,
//                               то выполнение процедуры ПриНачалеРаботыСистемы будет прервано.
//
Процедура ПриОбработкеПараметровЗапуска(ЗначениеПараметраЗапуска, ПараметрыЗапуска, Отказ) Экспорт

КонецПроцедуры

// Выполняется при интерактивном начале работы пользователя с областью данных или в локальном режиме.
// Вызывается после завершения действий ПриНачалеРаботыСистемы.
// Используется для подключения обработчиков ожидания, которые не должны вызываться
// в случае интерактивных действий перед и при начале работы системы.
//
// Начальная страница (рабочий стол) в этот момент еще не открыта, поэтому запрещено открывать
// формы напрямую, а следует использовать для этих целей обработчик ожидания.
// Запрещено использовать это событие для интерактивного взаимодействия с пользователем
// (ПоказатьВопрос и аналогичные действия). Для этих целей следует использовать
// событие ПриНачалеРаботыСистемы, который поддерживает продолжение своего выполнения.
//
Процедура ПослеНачалаРаботыСистемы() Экспорт
	
	ИмяПараметра = "РасчетПравДоступаПослеОбновления.ОткрытьРасчетПравДоступаПослеОбновления";
	ПараметрыРаботыКлиента = СтандартныеПодсистемыКлиентПовтИсп.ПараметрыРаботыКлиента();
	Если ПараметрыРаботыКлиента.ОткрытьРасчетПравДоступаПослеОбновления 
		Или ПараметрыПриложения[ИмяПараметра] <> Неопределено Тогда
		ПодключитьОбработчикОжидания("ОбработчикОжиданияОткрытьРасчетПравДоступаПослеОбновления", 0.1, Истина);
	КонецЕсли;
	
	ОбменСКонтрагентамиСлужебныйКлиент.ПодключитьОповещенияЭДО();
	
КонецПроцедуры

// Выполняется перед интерактивном завершении работы пользователя с областью данных или в локальном режиме.
// Соответствует обработчику ПередЗавершениемРаботыСистемы.
// Доопределяет список предупреждений пользователю перед завершением работы системы.
//
// Параметры:
//  Отказ - Булево - Признак отказа от выхода из программы. Если в теле процедуры-обработчика установить
//                   данному параметру значение Истина, то работа с программой не будет завершена.
//  Предупреждения - Массив - в массив можно добавить элементы типа Структура,
//                            свойства которой см. в СтандартныеПодсистемыКлиент.ПредупреждениеПриЗавершенииРаботы.
//
//
Процедура ПередЗавершениемРаботыСистемы(Отказ, Предупреждения) Экспорт
	
КонецПроцедуры

// Переопределяет заголовок приложения.
//
// Параметры:
//  ЗаголовокПриложения - Строка - текст заголовка приложения;
//  ПриЗапуске - Булево - Истина, если вызывается при начале работы программы.
Процедура ПриУстановкеЗаголовкаКлиентскогоПриложения(ЗаголовокПриложения, ПриЗапуске) Экспорт
	
	
		
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Открывать обработку обновления прав.
//
Процедура ОткрытьРасчетПравДоступаПослеОбновления(Параметры, ДополнительныеПараметры) Экспорт
	
	Оповещение = Новый ОписаниеОповещения("ОткрытьРасчетПравДоступаПослеОбновленияЗавершение", ЭтотОбъект, Параметры);
	Форма = ОткрытьФорму("Обработка.РасчетПравДоступаПослеОбновления.Форма",,,,,, Оповещение);
	
КонецПроцедуры

// Обрабатывает закрытие обработки обновления прав.
//
Процедура ОткрытьРасчетПравДоступаПослеОбновленияЗавершение(Результат, Параметры) Экспорт
	
	Если Результат <> "ВходВПрограммуРазрешен"
		И Результат <> "Завершено" Тогда
		Параметры.ОбработкаПродолжения.ДополнительныеПараметры.Отказ = Истина;
	КонецЕсли;
	Если Результат = "ВходВПрограммуРазрешен" Тогда
		ИмяПараметра = "РасчетПравДоступаПослеОбновления.ОткрытьРасчетПравДоступаПослеОбновления";
		ПараметрыПриложения.Вставить(ИмяПараметра, Истина);
	КонецЕсли;
	ВыполнитьОбработкуОповещения(Параметры.ОбработкаПродолжения);
	
КонецПроцедуры

// Открывать обработку обновления прав.
//
Процедура ОбработкаОткрытьРасчетПравДоступаПослеОбновления() Экспорт
	
	Оповещение = Новый ОписаниеОповещения("ОбработкаОткрытьРасчетПравДоступаПослеОбновленияЗавершение", ЭтотОбъект);
	Форма = ОткрытьФорму("Обработка.РасчетПравДоступаПослеОбновления.Форма",,,,,, Оповещение);
	
КонецПроцедуры

// Обрабатывает закрытие обработки обновления прав.
//
Процедура ОбработкаОткрытьРасчетПравДоступаПослеОбновленияЗавершение(Результат, Параметры) Экспорт
	
	Если Результат <> "Завершено" Тогда
		ЗавершитьРаботуСистемы(Ложь);
	КонецЕсли;
	
КонецПроцедуры

// Показывает запрет на вход в программу.
//
Процедура ЗапретРасчетПравДоступаПослеОбновления(Параметры, ДополнительныеПараметры) Экспорт
	
	ТекстПредупреждения = 
		НСтр("ru = 'Вход в программу временно невозможен в связи с обновлением на новую версию.
		|Обратитесь к администратору за подробностями.'");
	
	Кнопки = Новый СписокЗначений;
	Кнопки.Добавить("Перезапустить", НСтр("ru = 'Перезапустить'"));
	Кнопки.Добавить("Завершить",     НСтр("ru = 'Завершить работу'"));
	
	ПараметрыВопроса = СтандартныеПодсистемыКлиент.ПараметрыВопросаПользователю();
	ПараметрыВопроса.ПредлагатьБольшеНеЗадаватьЭтотВопрос = Ложь;
	ПараметрыВопроса.БлокироватьВесьИнтерфейс = Истина;
	ПараметрыВопроса.Картинка = БиблиотекаКартинок.Предупреждение32;
	ПараметрыВопроса.Вставить("КнопкаПоУмолчанию", "Перезапустить");
	ПараметрыВопроса.Вставить("КнопкаТаймаута",    "Перезапустить");
	ПараметрыВопроса.Вставить("Таймаут",           60);
	
	Оповещение = Новый ОписаниеОповещения("ЗапретРасчетПравДоступаПослеОбновленияЗавершение", ЭтотОбъект, Параметры);
	
	СтандартныеПодсистемыКлиент.ПоказатьВопросПользователю(Оповещение, ТекстПредупреждения, Кнопки, ПараметрыВопроса)
	
КонецПроцедуры

// Обрабатывает закрытие запрета на вход в программу.
//
Процедура ЗапретРасчетПравДоступаПослеОбновленияЗавершение(Результат, Параметры) Экспорт
	
	Если Результат.Значение = "Перезапустить" Тогда
		Параметры.ОбработкаПродолжения.ДополнительныеПараметры.Перезапустить = Истина;
	КонецЕсли;
	ВыполнитьОбработкуОповещения(Параметры.ОбработкаПродолжения);
	
КонецПроцедуры

// Показывает предупреждение.
//
Процедура ПредупреждениеРасчетПравДоступаПослеОбновления(Параметры, ДополнительныеПараметры) Экспорт
	
	ТекстПредупреждения = 
		НСтр("ru = 'Выполняется пересчет прав доступа. Некоторые данные в программе могут быть недоступны.
		|Обратитесь к администратору за подробностями.'");
	
	Кнопки = Новый СписокЗначений;
	Кнопки.Добавить("Продолжить", НСтр("ru = 'Начать работу'"));
	Кнопки.Добавить("Завершить",     НСтр("ru = 'Завершить работу'"));
	
	ПараметрыВопроса = СтандартныеПодсистемыКлиент.ПараметрыВопросаПользователю();
	ПараметрыВопроса.ПредлагатьБольшеНеЗадаватьЭтотВопрос = Ложь;
	ПараметрыВопроса.БлокироватьВесьИнтерфейс = Истина;
	ПараметрыВопроса.Картинка = БиблиотекаКартинок.Предупреждение32;
	ПараметрыВопроса.Вставить("КнопкаПоУмолчанию", "Продолжить");
	ПараметрыВопроса.Вставить("КнопкаТаймаута",    "Продолжить");
	ПараметрыВопроса.Вставить("Таймаут",           60);
	
	Оповещение = Новый ОписаниеОповещения("ПредупреждениеРасчетПравДоступаПослеОбновленияЗавершение", ЭтотОбъект, Параметры);
	
	СтандартныеПодсистемыКлиент.ПоказатьВопросПользователю(Оповещение, ТекстПредупреждения, Кнопки, ПараметрыВопроса)
	
КонецПроцедуры

// Обрабатывает закрытие предупреждения.
//
Процедура ПредупреждениеРасчетПравДоступаПослеОбновленияЗавершение(Результат, Параметры) Экспорт
	
	Если Результат.Значение = "Завершить" Тогда
		Параметры.ОбработкаПродолжения.ДополнительныеПараметры.Отказ = Истина;
	КонецЕсли;
	ВыполнитьОбработкуОповещения(Параметры.ОбработкаПродолжения);
	
КонецПроцедуры

#КонецОбласти