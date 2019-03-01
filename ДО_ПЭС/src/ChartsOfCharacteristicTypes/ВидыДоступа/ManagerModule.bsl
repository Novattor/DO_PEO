#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЙ ПРОГРАММНЫЙ ИНТЕРФЕЙС

// Процедура Обновляет описание свойств видов доступа в
// параметрах ограничения доступа при изменении конфигурации.
// 
// Параметры:
//  ЕстьИзменения - Булево (возвращаемое значение) - если производилась запись,
//                  устанавливается Истина, иначе не изменяется.
//
Процедура ОбновитьОписаниеСвойств(ЕстьИзменения = Неопределено, ТолькоПроверка = Ложь) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	Если ТолькоПроверка ИЛИ МонопольныйРежим() Тогда
		СнятьМонопольныйРежим = Ложь;
	Иначе
		СнятьМонопольныйРежим = Истина;
		УстановитьМонопольныйРежим(Истина);
	КонецЕсли;
	
	СвойстваВидовДоступа = СвойстваВидовДоступа();
	
	Блокировка = Новый БлокировкаДанных;
	ЭлементБлокировки = Блокировка.Добавить("Константа.ПараметрыОграниченияДоступа");
	ЭлементБлокировки.Режим = РежимБлокировкиДанных.Исключительный;
	
	НачатьТранзакцию();
	Попытка
		Блокировка.Заблокировать();
		
		Параметры = СтандартныеПодсистемыСервер.ПараметрыРаботыПрограммы(
			"ПараметрыОграниченияДоступа");
		
		Сохраненные = Неопределено;
		
		Если Параметры.Свойство("СвойстваВидовДоступа") Тогда
			Сохраненные = Параметры.СвойстваВидовДоступа;
			
			Если НЕ ОбщегоНазначения.ДанныеСовпадают(СвойстваВидовДоступа, Сохраненные) Тогда
				Сохраненные = Неопределено;
			КонецЕсли;
		КонецЕсли;
		
		Если Сохраненные = Неопределено Тогда
			ЕстьИзменения = Истина;
			Если ТолькоПроверка Тогда
				ЗафиксироватьТранзакцию();
				Возврат;
			КонецЕсли;
			СтандартныеПодсистемыСервер.УстановитьПараметрРаботыПрограммы(
				"ПараметрыОграниченияДоступа",
				"СвойстваВидовДоступа",
				СвойстваВидовДоступа);
		КонецЕсли;
		
		ЗафиксироватьТранзакцию();
	Исключение
		ОтменитьТранзакцию();
		Если СнятьМонопольныйРежим Тогда
			УстановитьМонопольныйРежим(Ложь);
		КонецЕсли;
		ВызватьИсключение;
	КонецПопытки;
	
	Если СнятьМонопольныйРежим Тогда
		УстановитьМонопольныйРежим(Ложь);
	КонецЕсли;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

// Возвращает таблицу свойств видов доступа, созданную на основе данных,
// заполняемых в процедуре, подготовленной прикладным разработчиком:
// УправлениеДоступомПереопределяемый.ЗаполнитьСвойстваВидаДоступа(ВидДоступа).
// 
// Свойства вида доступа, заполняемые автоматически:
//
//    Имя                                           - Строка - имя предопределенного элемента.
//    ВидДоступа                                    - ПланВидовХарактеристикСсылка.ВидыДоступа.
//    ВидДоступаИспользуетсяВсегда                  - Булево - используется для управления интерфейсом.
//
// Свойства вида доступа, переопределяемые прикладным разработчиком:
//
//    Таблицы                                       - Массив - полные имена таблиц значений доступа
//                                                    в формате метода объекта метаданных ПолноеИмя().
//    ВидДоступаЧерезПраваПоЗначениямДоступа        - Булево (начальное значение Ложь).
//    ВидДоступаЕдинственныйДляТипаЗначенияДоступа  - Булево (начальное значение Истина).
//    ВидДоступаБезГруппЗначенияДоступа             - Булево (начальное значение Истина).
//    ВидДоступаСОднойГруппойЗначенияДоступа        - Булево (начальное значение Истина).
//
Функция СвойстваВидовДоступа()
	
	// Подготовка свойств всех видов доступа.
	ТаблицаСвойств = Новый ТаблицаЗначений;
	ТаблицаСвойств.Колонки.Добавить("Имя",                                          Новый ОписаниеТипов("Строка"));
	ТаблицаСвойств.Колонки.Добавить("ВидДоступа",                                   Новый ОписаниеТипов("ПланВидовХарактеристикСсылка.ВидыДоступа"));
	ТаблицаСвойств.Колонки.Добавить("Таблицы",                                      Новый ОписаниеТипов("Массив"));
	ТаблицаСвойств.Колонки.Добавить("ВидДоступаЧерезПраваПоЗначениямДоступа",       Новый ОписаниеТипов("Булево"));
	ТаблицаСвойств.Колонки.Добавить("ВидДоступаЕдинственныйДляТипаЗначенияДоступа", Новый ОписаниеТипов("Булево"));
	ТаблицаСвойств.Колонки.Добавить("ВидДоступаБезГруппЗначенияДоступа",            Новый ОписаниеТипов("Булево"));
	ТаблицаСвойств.Колонки.Добавить("ВидДоступаСОднойГруппойЗначенияДоступа",       Новый ОписаниеТипов("Булево"));
	ТаблицаСвойств.Колонки.Добавить("ВидДоступаИспользуетсяВсегда",                 Новый ОписаниеТипов("Булево"));
	
	ПоИменам  = Новый Соответствие;
	ПоСсылкам = Новый Соответствие;
	
	ВидыДоступаЗначенийДоступа = Новый Структура;
	ВидыДоступаЗначенийДоступа.Вставить("ПоТипам",        Новый Соответствие);
	ВидыДоступаЗначенийДоступа.Вставить("ПоТипамСсылок",  Новый Соответствие);
	ВидыДоступаЗначенийДоступа.Вставить("ПоПолнымИменам", Новый Соответствие);
	
	ЗначенияДоступаСГруппами = Новый Структура;
	ЗначенияДоступаСГруппами.Вставить("ПоТипам",        Новый Соответствие);
	ЗначенияДоступаСГруппами.Вставить("ПоТипамСсылок",  Новый Соответствие);
	ЗначенияДоступаСГруппами.Вставить("ПоПолнымИменам", Новый Соответствие);
	
	ЗаголовокОшибки =
		НСтр("ru = 'Ошибка в процедуре ЗаполнитьСвойстваВидаДоступа
		           |общего модуля УправлениеДоступомПереопределяемый.
		           |
		           |'");
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ВидыДоступа.Ссылка КАК ВидДоступа,
	|	НЕОПРЕДЕЛЕНО КАК ИмяПредопределенныхДанных
	|ИЗ
	|	ПланВидовХарактеристик.ВидыДоступа КАК ВидыДоступа
	|ГДЕ
	|	ВидыДоступа.Предопределенный = ИСТИНА
	|
	|УПОРЯДОЧИТЬ ПО
	|	ВидыДоступа.Ссылка";
	
	Запрос.Текст = СтрЗаменить(Запрос.Текст, "НЕОПРЕДЕЛЕНО", "ВидыДоступа.ИмяПредопределенныхДанных");
	Выборка = Запрос.Выполнить().Выбрать();
	
	Пока Выборка.Следующий() Цикл
		
		Свойства = Новый Структура;
		Свойства.Вставить("ВидДоступа", Выборка.ВидДоступа);
		Свойства.Вставить("Таблицы",    Новый Массив);
		Свойства.Вставить("ВидДоступаЧерезПраваПоЗначениямДоступа",       Ложь);
		Свойства.Вставить("ВидДоступаЕдинственныйДляТипаЗначенияДоступа", Истина);
		Свойства.Вставить("ВидДоступаБезГруппЗначенияДоступа",            Истина);
		Свойства.Вставить("ВидДоступаСОднойГруппойЗначенияДоступа",       Истина);
		
		ОбработчикиСобытия = ОбщегоНазначения.ОбработчикиСлужебногоСобытия(
			"СтандартныеПодсистемы.УправлениеДоступом\ПриЗаполненииСвойствВидаДоступа");
		
		Для каждого Обработчик Из ОбработчикиСобытия Цикл
			Обработчик.Модуль.ПриЗаполненииСвойствВидаДоступа(Свойства);
		КонецЦикла;
		
		УправлениеДоступомПереопределяемый.ЗаполнитьСвойстваВидаДоступа(Свойства);
		
		Свойства.Вставить("ВидДоступаИспользуетсяВсегда", Ложь);
		Свойства.Вставить("Имя", Выборка.ИмяПредопределенныхДанных);
		
		Для каждого Таблица Из Свойства.Таблицы Цикл
			МетаданныеТаблицы = Метаданные.НайтиПоПолномуИмени(Таблица);
			
			// Проверка имен таблиц.
			Если МетаданныеТаблицы = Неопределено Тогда
				ВызватьИсключение СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
					ЗаголовокОшибки +
					НСтр("ru = 'Не найдена таблица ""%1"",
					           |указанная для вида доступа ""%2"".'"),
					Таблица,
					Свойства.ВидДоступа);
			КонецЕсли;
			
			ТипСсылки = СтандартныеПодсистемыСервер.ТипСсылкиИлиКлючаЗаписиОбъектаМетаданных(
				МетаданныеТаблицы);
				
			ТипОбъекта = СтандартныеПодсистемыСервер.ТипОбъектаИлиНабораЗаписейОбъектаМетаданных(
				МетаданныеТаблицы);
			
			// Заполнение видов доступа значений доступа.
			ВидыДоступа = ВидыДоступаЗначенийДоступа.ПоПолнымИменам[Таблица];
			Если ВидыДоступа = Неопределено Тогда
				
				ВидыДоступа = Новый Массив;
				ВидыДоступа.Добавить(Свойства.ВидДоступа);
				
				ВидыДоступаЗначенийДоступа.ПоПолнымИменам.Вставить(Таблица,  ВидыДоступа);
				ВидыДоступаЗначенийДоступа.ПоТипамСсылок.Вставить(ТипСсылки, ВидыДоступа);
				ВидыДоступаЗначенийДоступа.ПоТипам.Вставить(ТипСсылки,  ВидыДоступа);
				ВидыДоступаЗначенийДоступа.ПоТипам.Вставить(ТипОбъекта, ВидыДоступа);
				
			ИначеЕсли ВидыДоступа.Найти(Свойства.ВидДоступа) = Неопределено Тогда
				ВидыДоступа.Добавить(Свойства.ВидДоступа);
			КонецЕсли;
			
		КонецЦикла;
		
		ПоИменам.Вставить (Свойства.Имя,        Свойства);
		ПоСсылкам.Вставить(Свойства.ВидДоступа, Свойства);
		ЗаполнитьЗначенияСвойств(ТаблицаСвойств.Добавить(), Свойства);
	КонецЦикла;
	
	СвойстваВидовДоступа = Новый Структура;
	СвойстваВидовДоступа.Вставить("ПоИменам",  ПоИменам);
	СвойстваВидовДоступа.Вставить("ПоСсылкам", ПоСсылкам);
	СвойстваВидовДоступа.Вставить("Таблица",   Новый ХранилищеЗначения(ТаблицаСвойств));
	
	СвойстваВидовДоступа.Вставить("ВидыДоступаЗначенийДоступа", ВидыДоступаЗначенийДоступа);
	СвойстваВидовДоступа.Вставить("ЗначенияДоступаСГруппами",   ЗначенияДоступаСГруппами);
	
	Возврат ОбщегоНазначения.ФиксированныеДанные(СвойстваВидовДоступа);
	
КонецФункции

#КонецЕсли