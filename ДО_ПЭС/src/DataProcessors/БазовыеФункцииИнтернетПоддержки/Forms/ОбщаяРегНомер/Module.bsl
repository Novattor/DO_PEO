
// Хранение контекста взаимодействия с сервисом
&НаКлиенте
Перем КонтекстВзаимодействия Экспорт;

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	МестоЗапуска = Параметры.МестоЗапуска;
	
	// Заполнение формы необходимыми параметрами.
	ЗаполнитьФорму();
	
	Если ТекущийВариантИнтерфейсаКлиентскогоПриложения() = ВариантИнтерфейсаКлиентскогоПриложения.Такси Тогда
		Элементы.ГруппаЗаголовкаРегНомера.Отображение = ОтображениеОбычнойГруппы.Нет;
		Элементы.ГруппаКонтентаРегНомер.Отображение = ОтображениеОбычнойГруппы.Нет;
	КонецЕсли;
	
	НеНапоминатьОбАвторизацииДоДата = ИнтернетПоддержкаПользователейВызовСервера.ЗначениеНастройкиИППНеНапоминатьОбАвторизацииДо();
	Если НеНапоминатьОбАвторизацииДоДата <> '00010101'
		И ТекущаяДатаСеанса() > НеНапоминатьОбАвторизацииДоДата Тогда
			ИнтернетПоддержкаПользователейВызовСервера.УстановитьНастройкуИППНеНапоминатьОбАвторизацииДо(Ложь);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ИнтернетПоддержкаПользователейКлиент.ОбработатьОткрытиеФормы(КонтекстВзаимодействия, ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)
	
	Если НЕ ПрограммноеЗакрытие Тогда
		ИнтернетПоддержкаПользователейКлиент.ЗавершитьБизнесПроцесс(КонтекстВзаимодействия, ЗавершениеРаботы);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура НадписьВыходаПользователяРегНомерНажатие(Элемент)
	
	ИнтернетПоддержкаПользователейКлиент.ОбработатьВыходПользователя(КонтекстВзаимодействия, ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура СписокЗарегистрированныхПродуктовРегНомерНажатие(Элемент)
	
	ИнтернетПоддержкаПользователейКлиент.ОткрытьВебСтраницу(
		ИнтернетПоддержкаПользователейКлиентСервер.URLСтраницыПорталаПоддержки("/software?needAccessToken=true"),
		НСтр("ru = 'Список зарегистрированных продуктов'"),
		ИнтернетПоддержкаПользователейКлиентСервер.ЗначениеСессионногоПараметра(КонтекстВзаимодействия.КСКонтекст, "login"),
		ИнтернетПоддержкаПользователейКлиентСервер.ЗначениеСессионногоПараметра(КонтекстВзаимодействия.КСКонтекст, "password"));
	
КонецПроцедуры

&НаКлиенте
Процедура ЗарегистрироватьПродуктРегНомерНажатие(Элемент)
	
	ПараметрыЗапроса = Новый Массив;
	ПараметрыЗапроса.Добавить(Новый Структура("Имя, Значение", "registerProduct", "true"));
	
	ИнтернетПоддержкаПользователейКлиент.ОбработкаКомандСервиса(КонтекстВзаимодействия, ЭтотОбъект, ПараметрыЗапроса);
	
КонецПроцедуры

&НаКлиенте
Процедура ПояснениеКЗаголовкуРегНомерОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылка, СтандартнаяОбработка)
	
	Если НавигационнаяСсылка = "TechSupport" Тогда
		
		СтандартнаяОбработка = Ложь;
		
		ЛогинПользователя = ИнтернетПоддержкаПользователейКлиентСервер.ЗначениеСессионногоПараметра(
			КонтекстВзаимодействия.КСКонтекст,
			"login");
		
		ТекстСообщения =
			НСтр("ru = 'Не получается ввести регистрационный номер программного продукта.'");
		
		ИнтернетПоддержкаПользователейКлиент.ОтправитьСообщениеВТехПоддержку(
			НСтр("ru = 'Интернет-поддержка. Ввод регистрационного номера.'"),
			ТекстСообщения,
			,
			,
			Новый Структура("Логин, Пароль",
				ЛогинПользователя,
				ИнтернетПоддержкаПользователейКлиентСервер.ЗначениеСессионногоПараметра(
					КонтекстВзаимодействия.КСКонтекст,
					"password")));
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура НеНапоминатьОбАвторизацииДо1ПриИзменении(Элемент)
	
	УстановитьНастройкуНеНапоминатьОбАвторизацииДоСервер(НеНапоминатьОбАвторизацииДо);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОКРегНомер(Команда)
	
	Если НЕ ЗаполнениеПолейКорректно() Тогда
		Возврат;
	КонецЕсли;
	
	ИнтернетПоддержкаПользователейКлиентСервер.ЗаписатьПараметрКонтекста(
		КонтекстВзаимодействия.КСКонтекст,
		"regnumber",
		РегистрационныйНомерРегНомер);
	
	ПараметрыЗапроса = Новый Массив;
	ПараметрыЗапроса.Добавить(Новый Структура("Имя, Значение", "regnumber", РегистрационныйНомерРегНомер));
	
	ИнтернетПоддержкаПользователейКлиент.ОбработкаКомандСервиса(КонтекстВзаимодействия, ЭтотОбъект, ПараметрыЗапроса);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Выполняет начальное заполнение полей формы
&НаСервере
Процедура ЗаполнитьФорму()
	
	Если Параметры.ПриНачалеРаботыСистемы Тогда
		ВывестиДатуНастройкиНеНапоминатьОбАвторизацииДо();
	Иначе
		Элементы.НеНапоминатьОбАвторизацииДо.Видимость = Ложь;
	КонецЕсли;
	
	ЗаголовокПользователя = НСтр("ru = 'Логин:'") + " " + Параметры.login;
	
	Элементы.НадписьЛогинаПользователяРегНомер.Заголовок = ЗаголовокПользователя;
	РегистрационныйНомерРегНомер = Параметры.regNumber;
	
	СохранятьПароль = Истина;
	
КонецПроцедуры

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
Функция ЗаполнениеПолейКорректно()
	
	Результат = Истина;
	
	Если ПустаяСтрока(РегистрационныйНомерРегНомер) Тогда
		
		Сообщение = Новый СообщениеПользователю;
		Сообщение.Текст = НСтр("ru = 'Не заполнено поле ""Регистрационный номер""'");
		Сообщение.Поле  = "РегистрационныйНомерРегНомер";
		Сообщение.Сообщить();
		
		Результат = Ложь;
		
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

#КонецОбласти
