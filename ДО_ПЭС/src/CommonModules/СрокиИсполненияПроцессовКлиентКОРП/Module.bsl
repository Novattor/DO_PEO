
////////////////////////////////////////////////////////////////////////////////
// Сроки исполнения процессов клиент КОРП: содержит клиентские процедуры и функции по работе
// со сроками процессов в редакциях КОРП/ДГУ.
//  
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс_РасчетСроковПроцессов

// Записывает рассчитанные точные сроки по схеме.
// Вызывается после расчета точных сроков по команде в остановленном процессе.
//
// Параметры:
//  ПричинаПереносаСрока - Строка - причина переноса сроков, указывается для фиксации факта переноса сроков.
//  АдресХранилищаСРассчитаннымиСроками - Строка - адрес временного хранилища, привязанный к форме, в котором сохранен
//                                        результат расчета сроков.
//  Форма - УправляемаяФорма - карточка комплексного процесса.
//
Процедура ЗаписатьРассчитанныеТочныеСрокиПоСхеме(
	ПричинаПереносаСрока, АдресХранилищаСРассчитаннымиСроками, Форма) Экспорт
	
	ПараметрыЗаписи = Новый Структура;
	ПараметрыЗаписи.Вставить("ЗаписьТочныхСроковПоСхеме", Истина);
	ПараметрыЗаписи.Вставить("ПричинаПереносаСрока", ПричинаПереносаСрока);
	ПараметрыЗаписи.Вставить("АдресХранилищаСРассчитаннымиСроками", АдресХранилищаСРассчитаннымиСроками);
	
	Форма.Записать(ПараметрыЗаписи);
	
КонецПроцедуры

// Показывает сообщение пользователю о завершении расчета точных сроков по схеме.
//
// Параметры:
//  ПараметрыЗаписи - Структура - стандартный параметр обработчика ПослеЗаписи управляемой формы.
//
Процедура ПоказатьСообщениеОЗавершенииРасчетаСроков(ПараметрыЗаписи) Экспорт
	
	Если Не ПараметрыЗаписи.Свойство("ЗаписьТочныхСроковПоСхеме") Тогда
		Возврат;
	КонецЕсли;
	
	ПоказатьПредупреждение(, НСтр("ru = 'Расчет сроков завершен.'"));
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции_ПереносСроков

// Проверяет необходимость подтверждения переноса срока и вызывает диалог подтверждения.
// Предназначена для вызова из обработчика формы ПередЗаписью.
//
// Используется для переопределения одноименной процедуры в модуле СрокиИсполненияПроцессовКлиент.
// Вместо текущей следует использовать процедуру из модуля СрокиИсполненияПроцессовКлиент.
//
// Параметры:
//  Форма - УправляемаяФорма - форма процесса или шаблона.
//  Отказ, ПараметрыЗаписи - параметры обработчика ПередЗаписью.
//
Процедура ПодтвердитьПереносСрокаПроцесса(Форма, Отказ, ПараметрыЗаписи) Экспорт
	
	Если ПараметрыЗаписи.Свойство("ПереносСрокаПодтвержден")
		Или Отказ Тогда
		
		Возврат;
	КонецЕсли;
	
	ЭтоШаблон = ШаблоныБизнесПроцессовКлиентСервер.ЭтоШаблонПроцесса(Форма.Объект.Ссылка);
	
	СрокИсполненияПроцессаИзменен = Форма.СрокИсполненияПроцессаИзменен;
	
	Если Не ЭтоШаблон Тогда
		СрокиИсполненияЗадачИзменены = Форма.СрокиИсполненияЗадачИзменены;
	Иначе
		СрокиИсполненияЗадачИзменены = Ложь;
	КонецЕсли;
	
	Если СрокИсполненияПроцессаИзменен = Ложь И СрокиИсполненияЗадачИзменены = Ложь Тогда
		Возврат;
	КонецЕсли;
	
	ТребуетсяПереносСроковВышестоящихПроцессов = ТребуетсяПереносСроковВышестоящихПроцессов(Форма);
	
	Если ЭтоШаблон И Не ТребуетсяПереносСроковВышестоящихПроцессов Тогда
		Возврат;
	КонецЕсли;
	
	ОткрытьФормуПодтверждения = Ложь;
	Если СрокИсполненияПроцессаИзменен Тогда
		Если ТребуетсяПереносСроковВышестоящихПроцессов Тогда
			ОткрытьФормуПодтверждения = Истина;
		Иначе
			ОткрытьФормуПодтверждения = Форма.ВестиУчетПереносаСроков;
		КонецЕсли;
	ИначеЕсли СрокиИсполненияЗадачИзменены Тогда
		ОткрытьФормуПодтверждения = Форма.ВестиУчетПереносаСроков;
	КонецЕсли;
	Если Не ОткрытьФормуПодтверждения Тогда
		Возврат;
	КонецЕсли;
	
	ПараметрыФормы = Новый Структура;
	
	Если СрокИсполненияПроцессаИзменен Тогда
		
		ПараметрыФормы.Вставить("СформироватьДеревоВышестоящихПроцессовСНовымиСроками",
			ТребуетсяПереносСроковВышестоящихПроцессов);
		
		ПараметрыФормы.Вставить("Процесс", Форма.Объект.Ссылка);
		ПараметрыФормы.Вставить("НовыйСрокИсполнения", Форма.Объект.СрокИсполненияПроцесса);
	КонецЕсли;
	
	Если Форма.ВестиУчетПереносаСроков Тогда
		ПараметрыФормы.Вставить("ЗапрашиватьПричинуПереносаСроков", Истина);
	КонецЕсли;
	
	ДопПараметры = Новый Структура;
	ДопПараметры.Вставить("Форма", Форма);
	ДопПараметры.Вставить("ПараметрыЗаписи", ПараметрыЗаписи);
	
	ОписаниеОповещения = Новый ОписаниеОповещения(
		"ПродолжитьПослеПодтвержденияПереносаСрока", СрокиИсполненияПроцессовКлиент, ДопПараметры);
	
	ОткрытьФорму("ОбщаяФорма.ПодтверждениеПереносаСрока",
		ПараметрыФормы,
		Форма,,,,
		ОписаниеОповещения,
		РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
	Отказ = Истина;
	
КонецПроцедуры

// Продолжение процедуры ПодтвердитьПереносСрокаПроцесса.
//
// Используется для переопределения одноименной процедуры в модуле СрокиИсполненияПроцессовКлиент.
// Вместо текущей следует использовать процедуру из модуля СрокиИсполненияПроцессовКлиент.
//
Процедура ПродолжитьПослеПодтвержденияПереносаСрока(РезультатПодтверждения, ДопПараметры) Экспорт
	
	Если РезультатПодтверждения = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Форма = ДопПараметры.Форма;
	ПараметрыЗаписи = ДопПараметры.ПараметрыЗаписи;
	
	ПараметрыЗаписи.Вставить("ПереносСрокаПодтвержден", Истина);
	
	Если ТипЗнч(РезультатПодтверждения) = Тип("Строка") Тогда
		ПараметрыЗаписи.Вставить("ПричинаПереносаСрока", РезультатПодтверждения);
	КонецЕсли;
	
	Форма.Записать(ПараметрыЗаписи);
	
	Если ПараметрыЗаписи.Свойство("ЗакрытьФормуПослеЗаписи") Тогда
		Форма.Закрыть();
	КонецЕсли;
	
КонецПроцедуры

// Проверяет необходимость подтверждения переноса срока и вызывает диалог подтверждения.
// Предназначена для вызова из обработчика ПередЗаписью формы изменения параметров процесса.
//
// Используется для переопределения одноименной процедуры в модуле СрокиИсполненияПроцессовКлиент.
// Вместо текущей следует использовать процедуру из модуля СрокиИсполненияПроцессовКлиент.
//
// Параметры:
//  Форма - УправляемаяФорма - форма процесса или шаблона.
//  ОписаниеОповещения - ОписаниеОповещения - оповещение, которое следует выполнить после подтверждения.
//
Процедура ПодтвердитьПереносСрокаПроцессаПриВозвратеНаДоработку(Форма, ОписаниеОповещения) Экспорт
	
	Если Форма.СрокИсполненияПроцессаИзменен Тогда
	
		ПараметрыФормы = Новый Структура;
		
		ОткрытьФормуПодтверждения = Ложь;
		
		Если Форма.СрокИсполненияПроцессаИзменен Тогда
			ПараметрыФормы.Вставить("СформироватьДеревоВышестоящихПроцессовСНовымиСроками", Истина);
			ПараметрыФормы.Вставить("Процесс", Форма.Объект.Ссылка);
			ПараметрыФормы.Вставить("НовыйСрокИсполнения", Форма.Объект.СрокИсполненияПроцесса);
			
			ОткрытьФормуПодтверждения = Истина;
		КонецЕсли;
		
		Если Форма.ВестиУчетПереносаСроков Тогда
			ПараметрыФормы.Вставить("ЗапрашиватьПричинуПереносаСроков", Истина);
		КонецЕсли;
		
		Если ОткрытьФормуПодтверждения Тогда
			ДопПараметры = Новый Структура;
			ДопПараметры.Вставить("Форма", Форма);
			ДопПараметры.Вставить("ОписаниеОповещения", ОписаниеОповещения);
			
			ОписаниеОповещения = Новый ОписаниеОповещения(
				"ПродолжитьПослеПодтвержденияПереносаСрокаПриВозвратеНаДоработку",
				СрокиИсполненияПроцессовКлиент, ДопПараметры);
			
			ОткрытьФорму("ОбщаяФорма.ПодтверждениеПереносаСрока",
				ПараметрыФормы,
				Форма,,,,
				ОписаниеОповещения,
				РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
			
			Отказ = Истина;
		Иначе
			ВыполнитьОбработкуОповещения(ОписаниеОповещения, Неопределено);
		КонецЕсли;
		
	Иначе
		ВыполнитьОбработкуОповещения(ОписаниеОповещения, Неопределено);
	КонецЕсли;
	
КонецПроцедуры

// Продолжение процедуры ПодтвердитьПереносСрокаПроцессаПриВозвратеНаДоработку.
//
// Используется для переопределения одноименной процедуры в модуле СрокиИсполненияПроцессовКлиент.
// Вместо текущей следует использовать процедуру из модуля СрокиИсполненияПроцессовКлиент.
//
Процедура ПродолжитьПослеПодтвержденияПереносаСрокаПриВозвратеНаДоработку(
	РезультатПодтверждения, ДопПараметры) Экспорт
	
	Если РезультатПодтверждения = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Форма = ДопПараметры.Форма;
	ОписаниеОповещения = ДопПараметры.ОписаниеОповещения;
	
	Если ТипЗнч(РезультатПодтверждения) = Тип("Строка") Тогда
		Форма.ПричинаПереносаСрока = РезультатПодтверждения;
	КонецЕсли;
	
	ВыполнитьОбработкуОповещения(ОписаниеОповещения, Неопределено);
	
КонецПроцедуры

// Проверяет факт изменения сроков в форме процесса или шаблона.
// И при изменении посылает оповещение с именем "ПереносСрокаИсполненияПроцесса"
// другим формам процессов.
// Предназначена для вызова из обработчика формы ПослеЗаписи.
//
// Используется для переопределения одноименной процедуры в модуле СрокиИсполненияПроцессовКлиент.
// Вместо текущей следует использовать процедуру из модуля СрокиИсполненияПроцессовКлиент.
//
// Параметры:
//  Форма - УправляемаяФорма - форма процесса или шаблона.
//
Процедура ОповеститьОПереносеСроков(Форма) Экспорт
	
	Если Не ТребуетсяПереносСроковВышестоящихПроцессов(Форма) Тогда
		Возврат;
	КонецЕсли;
	
	ОповеститьОПереносеСроков = Ложь;
	
	РеквизитыФормыДляПроверки = Новый Структура;
	РеквизитыФормыДляПроверки.Вставить("СрокИсполненияПроцессаИзменен");
	РеквизитыФормыДляПроверки.Вставить("СрокиИсполненияЗадачИзменены");
	
	ЗаполнитьЗначенияСвойств(РеквизитыФормыДляПроверки, Форма);
	
	Если РеквизитыФормыДляПроверки.СрокИсполненияПроцессаИзменен = Истина Тогда
		ОповеститьОПереносеСроков = Истина;
		Форма.СрокИсполненияПроцессаИзменен = Ложь;
	КонецЕсли;
	
	Если РеквизитыФормыДляПроверки.СрокиИсполненияЗадачИзменены = Истина Тогда
		ОповеститьОПереносеСроков = Истина;
		Форма.СрокиИсполненияЗадачИзменены = Ложь;
	КонецЕсли;
	
	Если ОповеститьОПереносеСроков Тогда
		Оповестить("ПереносСрокаИсполненияПроцесса", Форма.Объект.Ссылка, Форма);
	КонецЕсли;
	
КонецПроцедуры

// Определяет необходимость переноса сроков вышестоящих процессов
// по карточке процесса/шаблона.
//
// Параметры:
//  УправляемаяФорма - карточка процесса/шаблона.
//
Функция ТребуетсяПереносСроковВышестоящихПроцессов(Форма)
	
	ЭтоШаблон = ШаблоныБизнесПроцессовКлиентСервер.ЭтоШаблонПроцесса(Форма.Объект.Ссылка);
	
	ТребуетсяПереносСроковВышестоящихПроцессов = Ложь;
	Если ЭтоШаблон Тогда
		ТребуетсяПереносСроковВышестоящихПроцессов = 
			ЗначениеЗаполнено(Форма.Объект.КомплексныйПроцесс)
			И Форма.КомплексныйПроцессСтартован
			И Не Форма.КомплексныйПроцессПомеченНаУдаление
			И Не Форма.КомплексныйПроцессЗавершен
			И Форма.СостояниеКомплексногоПроцесса =
				ПредопределенноеЗначение("Перечисление.СостоянияБизнесПроцессов.Активен");
	Иначе
		ТребуетсяПереносСроковВышестоящихПроцессов =
			Форма.Объект.Стартован
			И Не Форма.Объект.ПометкаУдаления
			И Не Форма.Объект.Завершен
			И Форма.Объект.Состояние = 
				ПредопределенноеЗначение("Перечисление.СостоянияБизнесПроцессов.Активен");
	КонецЕсли;
	
	Возврат ТребуетсяПереносСроковВышестоящихПроцессов;
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции_КарточкиПроцессовИШаблонов

// Возвращает дату отсчета определенную в форме процесса/шаблона с учетом
// настроек отложенного старта.
//
// Параметры:
//  Форма - УправляемаяФорма - форма процесса/шаблона.
//
Функция ДатаОтсчетаВФорме(Форма)
	
	ДатаОтсчета = ТекущаяДата();
	
	РеквизитыФормы = Новый Структура(
		"ДатаОтсчетаДляРасчетаСроков, НастройкаСтарта, ОтложенныйСтартДни, ОтложенныйСтартЧасы");
		
	ЗаполнитьЗначенияСвойств(РеквизитыФормы, Форма);
	
	Если Форма.ДатаОтсчетаДляРасчетаСроков = Неопределено Тогда
		Возврат ДатаОтсчета;
	КонецЕсли;
	
	ДатаОтсчета = Форма.ДатаОтсчетаДляРасчетаСроков;
	
	Если РеквизитыФормы.НастройкаСтарта <> Неопределено Тогда
		Если РеквизитыФормы.НастройкаСтарта.ДатаОтложенногоСтарта > ДатаОтсчета Тогда
			ДатаОтсчета = РеквизитыФормы.НастройкаСтарта.ДатаОтложенногоСтарта;
		КонецЕсли;
	ИначеЕсли РеквизитыФормы.ОтложенныйСтартДни <> Неопределено
		И РеквизитыФормы.ОтложенныйСтартЧасы <> Неопределено Тогда
		
		ДатаОтсчета = ДатаОтсчета
			+ РеквизитыФормы.ОтложенныйСтартДни * 86400
			+ РеквизитыФормы.ОтложенныйСтартЧасы * 3600;
	КонецЕсли;
	
	Возврат ДатаОтсчета;
	
КонецФункции

//////////////////////////////
// Проверка корректности сроков исполнения процессов

// Возвращает массив сроков участников или действий процесса.
//
// Используется для переопределения одноименной функции в модуле СрокиИсполненияПроцессовКлиент.
// Вместо текущей следует использовать функцию из модуля СрокиИсполненияПроцессовКлиент.
//
// Параметры:
//  Процесс - ДанныеФормыСтруктура, Структура - процесс в форме или структура сроков процесса.
//
// Возвращаемое значение:
//  Массив
//   * Дата
//
Функция ТочныеСрокиПроцесса(Процесс) Экспорт
	
	ТочныеСрокиПроцесса = Новый Массив;
	
	Если Процесс.Свойство("Исполнители") Тогда
		Для Каждого СтрокаИсполнитель Из Процесс.Исполнители Цикл
			ТочныеСрокиПроцесса.Добавить(СтрокаИсполнитель.СрокИсполнения);
		КонецЦикла;
	КонецЕсли;
	
	Если Процесс.Свойство("СрокИсполнения") Тогда
		ТочныеСрокиПроцесса.Добавить(Процесс.СрокИсполнения);
	КонецЕсли;
	
	Если Процесс.Свойство("СрокОбработкиРезультатов")
		И (Не Процесс.Свойство("Проверяющий") Или ЗначениеЗаполнено(Процесс.Проверяющий)) Тогда
		
		ТочныеСрокиПроцесса.Добавить(Процесс.СрокОбработкиРезультатов);
	КонецЕсли;
	
	Если Процесс.Свойство("Шаблоны") Тогда
		Для Каждого СтрокаШаблон Из Процесс.Шаблоны Цикл
			ТочныеСрокиПроцесса.Добавить(СтрокаШаблон.СрокИсполненияПроцесса);
		КонецЦикла;
	КонецЕсли;
	
	Если Процесс.Свойство("Этапы") Тогда
		Для Каждого СтрокаШаблон Из Процесс.Этапы Цикл
			ТочныеСрокиПроцесса.Добавить(СтрокаШаблон.СрокИсполненияПроцесса);
		КонецЦикла;
	КонецЕсли;
	
	Возврат ТочныеСрокиПроцесса;
	
КонецФункции

//////////////////////////////
// Сроки участников процесса

// Возвращает структуру доп. параметров для изменения срока по представлению.
//
// Используется для переопределения одноименной функции в модуле СрокиИсполненияПроцессовКлиент.
// Вместо текущей следует использовать функцию из модуля СрокиИсполненияПроцессовКлиент.
//
// Возвращаемое значение:
//  Структура
//   * Форма - УправляемаяФорма - форма процесса или шаблона.
//   * Поле - Строка - наименования элемент управления сроком исполнения.
//   * НаименованиеИзмененногоРеквизита - Строка - наименование измененного реквизита.
//   * Исполнитель - СправочникСсылка.Пользователи,
//                   СправочникСсылка.РолиИсполнителей - исполнитель срок которого изменяется.
//
Функция ДопПараметрыДляИзмененияСрокаПоПредставлению() Экспорт
	
	Параметры = Новый Структура;
	
	Параметры.Вставить("Форма");
	Параметры.Вставить("Поле", "");
	Параметры.Вставить("НаименованиеИзмененногоРеквизита", "");
	Параметры.Вставить("Исполнитель");
	
	Возврат Параметры;
	
КонецФункции

// Возвращает параметры для выбора срока исполнения участника процесса.
//
// Используется для переопределения одноименной функции в модуле СрокиИсполненияПроцессовКлиент.
// Вместо текущей следует использовать функцию из модуля СрокиИсполненияПроцессовКлиент.
//
// Возвращаемое значение:
//  Структура - параметры для выбора срока.
//   * Форма - УправляемаяФорма - форма процесса или шаблона.
//   * ИмяРеквизитаСрокИсполнения - Строка
//   * ИмяРеквизитаСрокИсполненияДни - Строка
//   * ИмяРеквизитаСрокИсполненияЧасы - Строка
//   * ИмяРеквизитаСрокИсполненияМинуты - Строка
//   * ИмяРеквизитаВариантУстановкиСрока - Строка
//   * ИмяРеквизитаПредставлениеСрока - Строка
//   * ИмяОбъектаФормы - Строка
//   * СрокиПредшественников - Дата, ДанныеФормыКоллекция
//   * НаименованиеСрокаУчастника - Строка
//   * Участник - СправочникСсылка.Пользователи,
//                   СправочникСсылка.РолиИсполнителей - участник процесса.
//
Функция ПараметрыВыбораСрокаУчастникаПроцесса() Экспорт
	
	Параметры = Новый Структура;
	
	Параметры.Вставить("Форма");
	Параметры.Вставить("ИмяРеквизитаСрокИсполнения");
	Параметры.Вставить("ИмяРеквизитаСрокИсполненияДни");
	Параметры.Вставить("ИмяРеквизитаСрокИсполненияЧасы");
	Параметры.Вставить("ИмяРеквизитаСрокИсполненияМинуты");
	Параметры.Вставить("ИмяРеквизитаВариантУстановкиСрока");
	Параметры.Вставить("ИмяРеквизитаПредставлениеСрока");
	Параметры.Вставить("ИмяОбъектаФормы");
	Параметры.Вставить("СрокиПредшественников");
	Параметры.Вставить("НаименованиеСрокаУчастника");
	Параметры.Вставить("Участник");
	
	Возврат Параметры;
	
КонецФункции

// Открывает форму выбора срока для текущей строки таблицы Исполнители
//
// Используется для переопределения одноименной процедуры в модуле СрокиИсполненияПроцессовКлиент.
// Вместо текущей следует использовать процедуру из модуля СрокиИсполненияПроцессовКлиент.
//
// Параметры:
//  Параметры - Структура - см. ПараметрыВыбораСрокаУчастникаПроцесса
//
Процедура ВыбратьСрокУчастникаПроцесса(Параметры) Экспорт
	
	Если Не ЗначениеЗаполнено(Параметры.Форма.ДатаОтсчетаДляРасчетаСроков)
		Или Параметры.Форма.ТекущийЭлемент.КнопкаВыбора = Ложь Тогда
		
		Возврат;
	КонецЕсли;
	
	ДатаОтсчета = ДатаОтсчетаВФорме(Параметры.Форма);
	
	Если ТипЗнч(Параметры.СрокиПредшественников) = Тип("ДанныеФормыКоллекция") Тогда
		Для Каждого СтрокаСрок Из Параметры.СрокиПредшественников Цикл
			ДатаОтсчета = Макс(ДатаОтсчета, СтрокаСрок.СрокИсполнения);
		КонецЦикла;
	ИначеЕсли ТипЗнч(Параметры.СрокиПредшественников) = Тип("Дата") Тогда
		ДатаОтсчета = Макс(ДатаОтсчета, Параметры.СрокиПредшественников);
	КонецЕсли;
	
	ОписаниеОповещения = Новый ОписаниеОповещения(
		"ЗавершитьВыборСрокаУчастникаПроцесса", СрокиИсполненияПроцессовКлиент, Параметры);
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("Исполнитель", Параметры.Участник);
	
	ОбъектФормы = Параметры.Форма;
	Если ЗначениеЗаполнено(Параметры.ИмяОбъектаФормы) Тогда
		ОбъектФормы = Параметры.Форма[Параметры.ИмяОбъектаФормы];
	КонецЕсли;
	ПараметрыФормы.Вставить("СрокИсполнения", ОбъектФормы[Параметры.ИмяРеквизитаСрокИсполнения]);
	ПараметрыФормы.Вставить("ДатаОтсчета", ДатаОтсчета);
	
	ОткрытьФорму("ОбщаяФорма.ВыборСрокаИсполнения",
		ПараметрыФормы, Параметры.Форма,,,, ОписаниеОповещения, РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

//////////////////////////////
// Сроки в таблице Исполнители

// Изменяет срок исполнения в текущей строке таблицы Исполнители
// по представлению.
//
// Используется для переопределения одноименной процедуры в модуле СрокиИсполненияПроцессовКлиент.
// Вместо текущей следует использовать процедуру из модуля СрокиИсполненияПроцессовКлиент.
//
// Параметры:
//  Форма - УправляемаяФорма - форма процесса или шаблона процесса
//  ЭлементИсполнители - ТаблицаФормы - элемент формы таблица исполнителей.
//  РеквизитИсполнители - ДанныеФормыКоллекция - таблица исполнителей процесса.
//  ВариантИсполнения - ПеречислениеСсылка.ВариантыМаршрутизацииЗадач - вариант исполнения задач процесса.
//
Процедура ИзменитьСрокИсполненияПоПредставлениюВТаблицеИсполнители(
	Форма, ЭлементИсполнители, РеквизитИсполнители, ВариантИсполнения = Неопределено) Экспорт
	
	ТекущиеДанные = ЭлементИсполнители.ТекущиеДанные;
	
	Параметры = Новый Структура;
	Параметры.Вставить("ТекстСообщенияПредупреждения", "");
	
	ВПредставленииМожетБытьДата = ЗначениеЗаполнено(Форма.ДатаОтсчетаДляРасчетаСроков)
		И (Форма.ВозможенВыборТочнойДатыВСроках);
	Параметры.Вставить("ВПредставленииМожетБытьДата", ВПредставленииМожетБытьДата);
	Параметры.Вставить("Форма", Форма);
	Параметры.Вставить("Исполнитель", ТекущиеДанные.Исполнитель);
	
	РезультатЗаполнения = СрокиИсполненияПроцессовКлиент.ИзменитьСрокИсполненияПоПредставлению(
		ТекущиеДанные.СрокИсполнения,
		ТекущиеДанные.СрокИсполненияДни,
		ТекущиеДанные.СрокИсполненияЧасы,
		ТекущиеДанные.СрокИсполненияМинуты,
		ТекущиеДанные.ВариантУстановкиСрокаИсполнения,
		ТекущиеДанные.СрокИсполненияПредставление,
		Параметры);
		
	Если РезультатЗаполнения Тогда
		
		СрокиИсполненияПроцессовКлиент.ЗаполнитьСрокиИсполненияВТаблицеИсполнителейПоТекущейСтроке(
			РеквизитИсполнители, ТекущиеДанные, ВариантИсполнения);
			
		Форма.ЗаполнитьПредставлениеСроковИсполнения();
		
		ИндексИзмененнойСтроки = РеквизитИсполнители.Индекс(ТекущиеДанные);
		
		Форма.ОбновитьСрокиИсполненияОтложенно("Исполнители", ИндексИзмененнойСтроки);
		
		Если ЗначениеЗаполнено(Параметры.ТекстСообщенияПредупреждения) Тогда
			ПоказатьПредупреждение(, Параметры.ТекстСообщенияПредупреждения);
		КонецЕсли;
		
	Иначе
		
		ТекущееПоле = СтрШаблон("Объект.Исполнители[%1].СрокИсполненияПредставление",
			ТекущиеДанные.НомерСтроки - 1);
		
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			Параметры.ТекстСообщенияПредупреждения,,
			ТекущееПоле);
		
	КонецЕсли;
	
	Форма.Модифицированность = Истина;
	
КонецПроцедуры

// Открывает форму выбора срока для текущей строки таблицы Исполнители
//
// Используется для переопределения одноименной процедуры в модуле СрокиИсполненияПроцессовКлиент.
// Вместо текущей следует использовать процедуру из модуля СрокиИсполненияПроцессовКлиент.
//
// Параметры:
//  Форма - УправляемаяФорма - форма процесса или шаблона процесса
//  ЭлементИсполнители - ТаблицаФормы - элемент формы таблица исполнителей.
//  РеквизитИсполнители - ДанныеФормыКоллекция - таблица исполнителей процесса.
//  ВариантИсполнения - ПеречислениеСсылка.ВариантыМаршрутизацииЗадач - вариант исполнения задач процесса.
//
Процедура ВыбратьСрокИсполненияДляСтрокиТаблицыИсполнители(
	Форма, ЭлементИсполнители, РеквизитИсполнители, ВариантИсполнения = Неопределено) Экспорт
	
	Если Не ЗначениеЗаполнено(Форма.ДатаОтсчетаДляРасчетаСроков)
		Или ЭлементИсполнители.ТекущийЭлемент.КнопкаВыбора = Ложь Тогда
		
		Возврат;
	КонецЕсли;
	
	ТекущиеДанные = ЭлементИсполнители.ТекущиеДанные;
	
	НомерСтроки = РеквизитИсполнители.Индекс(ТекущиеДанные) + 1;
	
	ВариантыМаршуртизацииЗадач = РаботаСБизнесПроцессамиКлиентСервер.ВариантыМаршуртизацииЗадач();
	
	ДатаОтсчета = ДатаОтсчетаВФорме(Форма);
	
	Если ВариантИсполнения = ВариантыМаршуртизацииЗадач.Последовательно И НомерСтроки <> 1 Тогда
		
		ИндексПредыдущейСтроки = НомерСтроки - 2;
		ПредыдущаяСтрока = РеквизитИсполнители[ИндексПредыдущейСтроки];
		
		Если Не СрокиИсполненияПроцессовКлиентСервер.ЭтоСтрокаОтвественного(ПредыдущаяСтрока) Тогда
			ДатаОтсчета = ПредыдущаяСтрока.СрокИсполнения;
		КонецЕсли;
		
	ИначеЕсли ВариантИсполнения = ВариантыМаршуртизацииЗадач.Смешанно Тогда
		
		Если ТекущиеДанные.Свойство("ПорядокСогласования") Тогда
			ИмяПоляПорядокИсполнения = "ПорядокСогласования";
		Иначе
			ИмяПоляПорядокИсполнения = "ПорядокИсполнения";
		КонецЕсли;
		
		МаксимальныйСрокЭтапа = Дата(1,1,1);
		
		НомерПервойСтрокиИсполнителя = 1;
		
		ВариантыПорядкаВыполненияЗадач = 
			РаботаСБизнесПроцессамиКлиентСервер.ВариантыПорядкаВыполненияЗадач();
		
		Для Каждого СтрИсполнитель Из РеквизитИсполнители Цикл
			
			// Определим строку ответственного исполнителя и пропустим ее обработку.
			Если СрокиИсполненияПроцессовКлиентСервер.ЭтоСтрокаОтвественного(СтрИсполнитель) Тогда
				НомерПервойСтрокиИсполнителя = 2;
				Продолжить;
			КонецЕсли;
			
			СтрИсполнительНомерСтроки = РеквизитИсполнители.Индекс(СтрИсполнитель) + 1;
			
			Если СтрИсполнитель[ИмяПоляПорядокИсполнения] = ВариантыПорядкаВыполненияЗадач.ПослеПредыдущего
				И СтрИсполнительНомерСтроки <> НомерПервойСтрокиИсполнителя Тогда
				
				ДатаОтсчета = Макс(МаксимальныйСрокЭтапа, ДатаОтсчета);
				МаксимальныйСрокЭтапа = Дата(1,1,1);
			КонецЕсли;
			
			Если СтрИсполнительНомерСтроки = НомерСтроки Тогда
				Прервать;
			КонецЕсли;
			
			МаксимальныйСрокЭтапа = Макс(СтрИсполнитель.СрокИсполнения, МаксимальныйСрокЭтапа);
			
		КонецЦикла;
		
	КонецЕсли;
	
	ДопПараметры = Новый Структура;
	ДопПараметры.Вставить("ТекущиеДанные", ТекущиеДанные);
	ДопПараметры.Вставить("ВариантИсполнения", ВариантИсполнения);
	ДопПараметры.Вставить("ЭлементИсполнители", ЭлементИсполнители);
	ДопПараметры.Вставить("РеквизитИсполнители", РеквизитИсполнители);
	ДопПараметры.Вставить("Форма", Форма);
	
	ОписаниеОповещения = Новый ОписаниеОповещения(
		"ЗавершитьВыборСрокаИсполненияДляСтрокиТаблицыИсполнители",
		СрокиИсполненияПроцессовКлиент, ДопПараметры);
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("Исполнитель", ТекущиеДанные.Исполнитель);
	ПараметрыФормы.Вставить("СрокИсполнения", ТекущиеДанные.СрокИсполнения);
	ПараметрыФормы.Вставить("ДатаОтсчета", ДатаОтсчета);
	
	ОткрытьФорму("ОбщаяФорма.ВыборСрокаИсполнения",
		ПараметрыФормы, Форма,,,, ОписаниеОповещения, РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

#КонецОбласти