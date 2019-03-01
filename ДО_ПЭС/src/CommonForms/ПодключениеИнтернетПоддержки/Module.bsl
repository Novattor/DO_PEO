
// Контекст взаимодействия с сервисом ИПП
&НаКлиенте
Перем КонтекстВзаимодействия Экспорт;

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	Если ОбщегоНазначенияПовтИсп.РазделениеВключено() Тогда
		ВызватьИсключение НСтр("ru = 'Использование Интернет-поддержки недоступно при работе в модели сервиса.'");
	КонецЕсли;
	
	ЭтоФормаБизнесПроцесса = Параметры.ЭтоФормаБизнесПроцесса;
	
	Если НЕ ПустаяСтрока(Параметры.ЗаголовокКнопкиОК) Тогда
		Элементы.ФормаКомандаОК.Заголовок = Параметры.ЗаголовокКнопкиОК;
	КонецЕсли;
	
	ЗапомнитьПароль                         = Параметры.ЗапомнитьПароль;
	РежимВводаНастроекКлиентаЛицензирования = Параметры.РежимВводаНастроекКлиентаЛицензирования;
	Если РежимВводаНастроекКлиентаЛицензирования Тогда
		НастройкиСоединенияССерверами =
			ИнтернетПоддержкаПользователейСлужебныйПовтИсп.НастройкиСоединенияССерверамиИПП();
	КонецЕсли;
	
	КлючПоложенияОкна = "";
	Если ЭтоФормаБизнесПроцесса Тогда
		
		ЭтотОбъект.ПоложениеКоманднойПанели = ПоложениеКоманднойПанелиФормы.Нет;
		Элементы.КомандаОКБизнесПроцесс.КнопкаПоУмолчанию = Истина;
		КлючСохраненияПоложенияОкна = "ВКонтекстеБизнесПроцесса" + Параметры.ПриНачалеРаботыСистемы;
		ЭтотОбъект.РежимОткрытияОкна = РежимОткрытияОкнаФормы.Независимый;
		
		Логин  = Параметры.login;
		Пароль = Параметры.password;
		
		НеНапоминатьОбАвторизацииДоДата = ИнтернетПоддержкаПользователейВызовСервера.ЗначениеНастройкиИППНеНапоминатьОбАвторизацииДо();
		Если НеНапоминатьОбАвторизацииДоДата <> '00010101'
			И ТекущаяДатаСеанса() > НеНапоминатьОбАвторизацииДоДата Тогда
			ИнтернетПоддержкаПользователейВызовСервера.УстановитьНастройкуИППНеНапоминатьОбАвторизацииДо(Ложь);
		КонецЕсли;
		
		Если Параметры.ПриНачалеРаботыСистемы Тогда
			ВывестиДатуНастройкиНеНапоминатьОбАвторизацииДо();
		Иначе
			Элементы.НеНапоминатьОбАвторизацииДо.Видимость = Ложь;
		КонецЕсли;
		
	Иначе
		
		УстановитьПривилегированныйРежим(Истина);
		ДанныеАутентификации = ИнтернетПоддержкаПользователей.ДанныеАутентификацииПользователяИнтернетПоддержки();
		Если ДанныеАутентификации <> Неопределено Тогда
			Логин = ДанныеАутентификации.Логин;
		КонецЕсли;
		
		Элементы.НеНапоминатьОбАвторизацииДо.Видимость  = Ложь;
		Элементы.КоманднаяПанельБизнесПроцесс.Видимость = Ложь;
		
	КонецЕсли;
	
	Если Не ПустаяСтрока(КлючПоложенияОкна) Тогда
		КлючСохраненияПоложенияОкна = КлючПоложенияОкна;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Если ЭтоФормаБизнесПроцесса Тогда
		ИнтернетПоддержкаПользователейКлиент.ОбработатьОткрытиеФормы(КонтекстВзаимодействия, ЭтотОбъект);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)
	
	Если ОбщегоНазначенияДокументооборотКлиент.ПриЗакрытии(ЗавершениеРаботы) Тогда
		Возврат;
	КонецЕсли;
	
	Если ЭтоФормаБизнесПроцесса И Не ПрограммноеЗакрытие Тогда
		ИнтернетПоддержкаПользователейКлиент.ЗавершитьБизнесПроцесс(КонтекстВзаимодействия, ЗавершениеРаботы);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "ИПП_АктивизироватьФормуПодключенияИПП" Тогда
		Если Параметр.Активизирована <> Истина Тогда
			Если РежимОткрытияОкна <> РежимОткрытияОкнаФормы.БлокироватьОкноВладельца Тогда
				Параметр.Активизирована = Истина;
				ПодключитьОбработчикОжидания("АктивизироватьЭтуФорму", 0.1, Истина);
			ИначеЕсли ЭтотОбъект.ВладелецФормы <> Неопределено Тогда
				Параметр.Активизирована = Истина;
				ПодключитьОбработчикОжидания("АктивизироватьВладельца", 0.1, Истина);
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти


#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура НадписьПоясненияПодключенияАвторизацияОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	Если НавигационнаяСсылкаФорматированнойСтроки = "action:openPortal" Тогда
		
		ИнтернетПоддержкаПользователейКлиент.ОткрытьВебСтраницу(
			ИнтернетПоддержкаПользователейКлиентСервер.URLСтраницыПорталаПоддержки(),
			НСтр("ru = 'Портал 1С:ИТС'"));
		
	Иначе
		
		ИнтернетПоддержкаПользователейКлиент.ОтправитьСообщениеВТехПоддержку(
			НСтр("ru = 'Интернет-поддержка. Подключение Интернет-поддержки.'"),
			СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Не получается подключить Интернет-поддержку пользователей.
					|Для подключения указывается логин %1.'"),
				Элементы.Логин.ТекстРедактирования),
			,
			,
			Новый Структура("Логин, НастройкиСоединенияССерверами",
				Элементы.Логин.ТекстРедактирования,
				НастройкиСоединенияССерверами));
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура НадписьВосстановленияПароляАвторизацияНажатие(Элемент)
	
	ИнтернетПоддержкаПользователейКлиент.ОткрытьВебСтраницу(
		ИнтернетПоддержкаПользователейКлиентСервер.URLСтраницыСервисаLogin("/remind_request"),
		НСтр("ru = 'Восстановление пароля'"));
	
КонецПроцедуры

&НаКлиенте
Процедура НадписьНетЛогинаИПароляАвторизацияНажатие(Элемент)
	
	ИнтернетПоддержкаПользователейКлиент.ОткрытьВебСтраницу(
		ИнтернетПоддержкаПользователейКлиентСервер.URLСтраницыСервисаLogin("/registration"),
		НСтр("ru = 'Регистрация'"));
	
КонецПроцедуры

&НаКлиенте
Процедура НеНапоминатьОбАвторизацииДоПриИзменении(Элемент)
	
	УстановитьНастройкуНеНапоминатьОбАвторизацииДоСервер(НеНапоминатьОбАвторизацииДо);
	
КонецПроцедуры

&НаКлиенте
Процедура ДекорацияИнформацияОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ИнтернетПоддержкаПользователейКлиент.ОткрытьВебСтраницу(
		ИнтернетПоддержкаПользователейКлиентСервер.URLСтраницыПорталаПоддержки(),
		НСтр("ru = 'Портал 1С:ИТС'"));
	
КонецПроцедуры

#КонецОбласти


#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура КомандаОК(Команда)
	
	Если Не ЗаполнениеЛогинаИПароляКорректно() Тогда
		Возврат;
	КонецЕсли;
	
	Если НастройкиСоединенияССерверами = Неопределено Тогда
		НастройкиСоединенияССерверами = ИнтернетПоддержкаПользователейКлиентСервер.НастройкиСоединенияССерверами();
	КонецЕсли;
	
	УстанавливатьПодключениеНаСервере = НастройкиСоединенияССерверами.УстанавливатьПодключениеНаСервере;
	
	Состояние(, , НСтр("ru = 'Подключение Интернет-поддержки...'"));
	Если УстанавливатьПодключениеНаСервере Тогда
		РезультатАутентификации = АутентифицироватьНаСервере(
			Логин, Пароль, Истина, НастройкиСоединенияССерверами);
	Иначе
		#Если Не ВебКлиент Тогда
		РезультатАутентификации = АутентифицироватьПользователя(
			Логин, Пароль, Истина, НастройкиСоединенияССерверами);
		#КонецЕсли
	КонецЕсли;
	Состояние();
	
	Если ПустаяСтрока(РезультатАутентификации.КодОшибки) Тогда
		ПараметрыОповещения = Новый Структура("Логин, Пароль", Логин, Пароль);
		Закрыть(ПараметрыОповещения);
		Оповестить("ИнтернетПоддержкаПодключена", ПараметрыОповещения);
	ИначеЕсли РезультатАутентификации.КодОшибки = "НеверныйЛогинИлиПароль" Тогда
		ПоказатьПредупреждение(, РезультатАутентификации.СообщениеОбОшибке);
	Иначе
		
		// Сетевая или иная ошибка.
		// В этом случае:
		//	- пользователю отображается сообщение об ошибке проверки логина и пароля;
		//	- логин и пароль сохраняются в программе - см. метод АутентифицироватьПользователя().
		
		ТекстПредупреждения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Логин и пароль сохранены в программе, но проверка корректности
				|логина и пароля не выполнена из-за ошибки:
				|%1'"),
			РезультатАутентификации.СообщениеОбОшибке);
		
		ПоказатьПредупреждение(
			Новый ОписаниеОповещения("ПриСообщенииОбОшибкеПроверкиКорректностиЛогинаИПароля", ЭтотОбъект),
			ТекстПредупреждения);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура КомандаОКБизнесПроцесс(Команда)
	
	Если ЗаполнениеЛогинаИПароляКорректно() Тогда
		ПродолжитьБизнесПроцесс();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура КомандаОтмена(Команда)
	
	Закрыть(Неопределено);
	
КонецПроцедуры

#КонецОбласти


#Область СлужебныеПроцедурыИФункции

////////////////////////////////////////////////////////////////////////////////
// Общего назначения.

&НаКлиенте
Функция ЗаполнениеЛогинаИПароляКорректно()
	
	Если ПустаяСтрока(Логин) Тогда
		
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			НСтр("ru = 'Поле ""Логин"" не заполнено.'"),
			,
			"Логин");
		Возврат Ложь;
		
	ИначеЕсли ПустаяСтрока(Пароль) Тогда
		
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			НСтр("ru = 'Поле ""Пароль"" не заполнено.'"),
			,
			"Пароль");
		Возврат Ложь;
		
	КонецЕсли;
	
	Возврат Истина;
	
КонецФункции

&НаСервереБезКонтекста
Процедура СохранитьДанныеАутентификации(Знач ДанныеАутентификации)
	
	// Проверка права записи данных
	Если Не ИнтернетПоддержкаПользователей.ПравоЗаписиПараметровИПП() Тогда
		ВызватьИсключение НСтр("ru = 'Недостаточно прав для записи данных аутентификации Интернет-поддержки.'");
	КонецЕсли;
	
	// Запись данных
	УстановитьПривилегированныйРежим(Истина);
	ИнтернетПоддержкаПользователей.СохранитьДанныеАутентификации(ДанныеАутентификации);
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция АутентифицироватьНаСервере(Знач Логин, Знач Пароль, Знач ЗапомнитьПароль, НастройкиСоединенияССерверами)
	
	Возврат АутентифицироватьПользователя(Логин, Пароль, ЗапомнитьПароль, НастройкиСоединенияССерверами);
	
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Функция АутентифицироватьПользователя(Логин, Пароль, ЗапомнитьПароль, НастройкиСоединенияССерверами)
	
	РезультатАутентификации = ИнтернетПоддержкаПользователейКлиентСервер.ПроверитьЛогинИПароль(
		Логин, Пароль, НастройкиСоединенияССерверами);
	
	Если РезультатАутентификации.КодОшибки <> "НеверныйЛогинИлиПароль" Тогда
		СохранитьДанныеАутентификации(
			?(ЗапомнитьПароль, Новый Структура("Логин, Пароль", Логин, Пароль), Неопределено));
	КонецЕсли;
	
	Возврат РезультатАутентификации;
	
КонецФункции

&НаКлиенте
Процедура ПриСообщенииОбОшибкеПроверкиКорректностиЛогинаИПароля(ДополнительныеПараметры) Экспорт
	
	ПараметрыОповещения = Новый Структура("Логин, Пароль", Логин, Пароль);
	Закрыть(ПараметрыОповещения);
	Оповестить("ИнтернетПоддержкаПодключена");
	
КонецПроцедуры

&НаКлиенте
Процедура АктивизироватьЭтуФорму()
	
	ЭтотОбъект.Активизировать();
	
КонецПроцедуры

&НаКлиенте
Процедура АктивизироватьВладельца()
	
	ЭтотОбъект.ВладелецФормы.Активизировать();
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Обработка бизнес-процессов.

&НаСервере
Процедура ВывестиДатуНастройкиНеНапоминатьОбАвторизацииДо()
	
	ОбщийЗаголовокФлажка = НСтр("ru = 'Не напоминать о подключении семь дней'");
	
	ЗначениеНастройки = ИнтернетПоддержкаПользователейВызовСервера.ЗначениеНастройкиИППНеНапоминатьОбАвторизацииДо();
	НеНапоминатьОбАвторизацииДо = ?(ЗначениеНастройки = '00010101', Ложь, Истина);
	
	СтрокаФлажка = ОбщийЗаголовокФлажка
		+ ?(ЗначениеНастройки = '00010101',
			"",
			" " + НСтр("ru = '(до'") + " " + Формат(ЗначениеНастройки, "ДЛФ=D") + ")");
	
	Элементы.НеНапоминатьОбАвторизацииДо.Заголовок = СтрокаФлажка;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьНастройкуНеНапоминатьОбАвторизацииДоСервер(Значение)
	
	ИнтернетПоддержкаПользователейВызовСервера.УстановитьНастройкуИППНеНапоминатьОбАвторизацииДо(Значение);
	ВывестиДатуНастройкиНеНапоминатьОбАвторизацииДо();
	
КонецПроцедуры

&НаКлиенте
Процедура ПродолжитьБизнесПроцесс()
	
	ИнтернетПоддержкаПользователейКлиентСервер.ЗаписатьПараметрКонтекста(
		КонтекстВзаимодействия.КСКонтекст,
		"login",
		Логин);
	ИнтернетПоддержкаПользователейКлиентСервер.ЗаписатьПараметрКонтекста(
		КонтекстВзаимодействия.КСКонтекст,
		"password",
		Пароль);
	ИнтернетПоддержкаПользователейКлиентСервер.ЗаписатьПараметрКонтекста(
		КонтекстВзаимодействия.КСКонтекст,
		"savePassword",
		"true");
	
	// Сохранение логина и пароля пользователя, при успешной авторизации
	// будут переданы в метод
	// ИнтернетПоддержкаПользователейПереопределяемый.ПриАвторизацииПользователяВИнтернетПоддержке().
	
	КонтекстВзаимодействия.КСКонтекст.Логин = Логин;
	
	ПараметрыЗапроса = Новый Массив;
	ПараметрыЗапроса.Добавить(Новый Структура("Имя, Значение", "login", Логин));
	ПараметрыЗапроса.Добавить(Новый Структура("Имя, Значение", "password", Пароль));
	ПараметрыЗапроса.Добавить(Новый Структура("Имя, Значение", "savePassword", "true"));
	
	ИнтернетПоддержкаПользователейКлиент.ОбработкаКомандСервиса(
		КонтекстВзаимодействия,
		ЭтотОбъект,
		ПараметрыЗапроса);
	
КонецПроцедуры

#КонецОбласти
