
// Хранение контекста взаимодействия с сервисом
&НаКлиенте
Перем КонтекстВзаимодействия Экспорт;

&НаКлиенте
Перем КонтекстРегистрации;

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	Элементы.НадписьЛогина.Заголовок = НСтр("ru = 'Логин:'") + " " + Параметры.login;
	
	Если ТекущийВариантИнтерфейсаКлиентскогоПриложения() = ВариантИнтерфейсаКлиентскогоПриложения.Такси Тогда
		Элементы.ГруппаЗаголовка.Отображение = ОтображениеОбычнойГруппы.Нет;
		Элементы.ГруппаКонтента.Отображение = ОтображениеОбычнойГруппы.Нет;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ИнтернетПоддержкаПользователейКлиент.ОбработатьОткрытиеФормы(КонтекстВзаимодействия, ЭтотОбъект);
	
	КонтекстРегистрации = КонтекстВзаимодействия.КСКонтекст.КонтекстРегистрации;
	// В дальнейшем контекст регистрации не используется
	КонтекстВзаимодействия.КСКонтекст.КонтекстРегистрации = Неопределено;
	
	НастроитьОтображениеФормы();
	
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)
	
	Если Не ПрограммноеЗакрытие Тогда
		ИнтернетПоддержкаПользователейКлиент.ЗавершитьБизнесПроцесс(КонтекстВзаимодействия, ЗавершениеРаботы);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ОрганизацияПриИзменении(Элемент)
	
	Если ОрганизацияПередИзменением = Организация Тогда
		Возврат;
	КонецЕсли;
	
	// В зависимости от того, выполняется ли добавление новой организации
	// или указывается существующая, настроить отображение полей формы.
	
	Если Организация = "-1" Тогда
		УстановитьТолькоПросмотрПолейОрганизации(Ложь);
	Иначе
		УстановитьТолькоПросмотрПолейОрганизации(Истина);
	КонецЕсли;
	
	Если ОрганизацияПередИзменением = "-1" Тогда
		КонтекстРегистрации.ДанныеОрганизаций["-1"] = ДанныеНовойОрганизации();
	КонецЕсли;
	
	ЗаполнитьДанныеПолейОрганизации();
	
	ОрганизацияПередИзменением = Организация;
	
КонецПроцедуры

&НаКлиенте
Процедура АдресНажатие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ИмяФормыАдреса = "Обработка.БазовыеФункцииИнтернетПоддержки.Форма.ПочтовыйАдрес";
	
	ПараметрыФормы = Новый Структура("ТолькоПросмотр", (Организация <> "-1"));
	
	Если ПараметрыФормы.ТолькоПросмотр Тогда
		ОписаниеОповещения = Неопределено;
	Иначе
		ОписаниеОповещения = Новый ОписаниеОповещения("ПриВводеАдреса", ЭтотОбъект);
	КонецЕсли;
	
	ФормаАдреса = ОткрытьФорму(
		ИмяФормыАдреса,
		ПараметрыФормы,
		ЭтотОбъект,
		,
		,
		,
		ОписаниеОповещения);
	
	ФормаАдреса.КонтекстРегистрации = КонтекстРегистрации;
	
	ИнтернетПоддержкаПользователейКлиент.СкопироватьСписокЗначенийИтерационно(
		КонтекстРегистрации.Страны,
		ФормаАдреса.Элементы.Страна.СписокВыбора);
	
	РегионыСтраны = КонтекстРегистрации.РегионыСтран[ДанныеПочтовогоАдреса.Страна];
	Если РегионыСтраны = Неопределено Тогда
		РегионыСтраны = Новый СписокЗначений;
		РегионыСтраны.Добавить("-1", НСтр("ru = '<не выбран>'"));
	КонецЕсли;
	
	ИнтернетПоддержкаПользователейКлиент.СкопироватьСписокЗначенийИтерационно(
		РегионыСтраны,
		ФормаАдреса.Элементы.КодРегиона.СписокВыбора);
	
	ЗаполнитьЗначенияСвойств(ФормаАдреса, ДанныеПочтовогоАдреса);
	
	ФормаАдреса.ОбновитьОтображениеДанных();
	
КонецПроцедуры

&НаКлиенте
Процедура НадписьВыходНажатие(Элемент)
	
	ИнтернетПоддержкаПользователейКлиент.ОбработатьВыходПользователя(КонтекстВзаимодействия, ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ПояснениеКЗаголовкуОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылка, СтандартнаяОбработка)
	
	Если НавигационнаяСсылка = "TechSupport" Тогда
		
		СтандартнаяОбработка = Ложь;
		
		ТекстСообщения =
			НСтр("ru = 'Не получается ввести информацию об организации при регистрации программного продукта.
				|
				|Название организации: %1
				|Тип деятельности: %2
				|ИНН: %3
				|КПП: %4
				|Руководитель: %5
				|Телефон: %6
				|Адрес электронной почты: %7
				|Факс: %8'");
		
		ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			ТекстСообщения,
			НазваниеОрганизации,
			ТипДеятельности,
			ИНН,
			КПП,
			Руководитель,
			Телефон,
			АдресЭлектроннойПочты,
			Факс);
		
		ТекстСообщенияПродолжение = НСтр("ru = 'Адрес: %1
			|Место покупки: %2
			|Дата покупки: %3
			|Число рабочих мест: %4
			|Ответственный сотрудник: %5'");
		
		ТекстСообщенияПродолжение = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			ТекстСообщенияПродолжение,
			ПредставлениеАдреса,
			ГдеПриобретенаПрограмма,
			Формат(ДатаПриобретенияПрограммы, "ДЛФ=D"),
			Строка(ЧислоРабочихМест),
			Ответственный);
		
		ИнтернетПоддержкаПользователейКлиент.ОтправитьСообщениеВТехПоддержку(
			НСтр("ru = 'Интернет-поддержка. Ввод информации об организации.'"),
			ТекстСообщения + Символы.ПС + ТекстСообщенияПродолжение,
			,
			,
			Новый Структура("Логин, Пароль",
				ИнтернетПоддержкаПользователейКлиентСервер.ЗначениеСессионногоПараметра(
					КонтекстВзаимодействия.КСКонтекст,
					"login"),
				ИнтернетПоддержкаПользователейКлиентСервер.ЗначениеСессионногоПараметра(
					КонтекстВзаимодействия.КСКонтекст,
					"password")));
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОтправитьАнкету(Команда)
	
	Если НЕ ЗаполнениеПолейКорректно() Тогда
		Возврат;
	КонецЕсли;
	
	ПараметрыЗапроса = Новый Массив;
	
	organizationId = ?(Организация = "-1", Неопределено, Организация);
	
	ПараметрыЗапроса.Добавить(Новый Структура("Имя, Значение", "organizationId", organizationId));
	
	Если organizationId = Неопределено Тогда
		
		// Добавить данные новой организации
		ПараметрыЗапроса.Добавить(Новый Структура("Имя, Значение", "organizationName", НазваниеОрганизации));
		ПараметрыЗапроса.Добавить(Новый Структура("Имя, Значение", "typeActivity"    , ТипДеятельности));
		ПараметрыЗапроса.Добавить(Новый Структура("Имя, Значение", "inn"             , СтрЗаменить(ИНН, " ", "")));
		ПараметрыЗапроса.Добавить(Новый Структура("Имя, Значение", "kpp"             , СтрЗаменить(КПП, " ", "")));
		ПараметрыЗапроса.Добавить(Новый Структура("Имя, Значение", "director"        , Руководитель));
		ПараметрыЗапроса.Добавить(Новый Структура("Имя, Значение", "phoneNumber"     , Телефон));
		ПараметрыЗапроса.Добавить(Новый Структура("Имя, Значение", "email"           , АдресЭлектроннойПочты));
		ПараметрыЗапроса.Добавить(Новый Структура("Имя, Значение", "fax"             , Факс));
		
		ПараметрыЗапроса.Добавить(Новый Структура("Имя, Значение",
			"postIndex",
			ДанныеПочтовогоАдреса.Индекс));
		
		ПараметрыЗапроса.Добавить(Новый Структура("Имя, Значение",
			"countryId",
			?(ДанныеПочтовогоАдреса.Страна = "-1", Неопределено, ДанныеПочтовогоАдреса.Страна)));
		
		ПараметрыЗапроса.Добавить(Новый Структура("Имя, Значение",
			"regionId",
			?(ДанныеПочтовогоАдреса.КодРегиона = "-1", Неопределено, ДанныеПочтовогоАдреса.КодРегиона)));
		
		ПараметрыЗапроса.Добавить(Новый Структура("Имя, Значение",
			"area",
			ДанныеПочтовогоАдреса.Район));
		
		ПараметрыЗапроса.Добавить(Новый Структура("Имя, Значение",
			"city",
			ДанныеПочтовогоАдреса.Город));
		
		ПараметрыЗапроса.Добавить(Новый Структура("Имя, Значение",
			"street",
			ДанныеПочтовогоАдреса.Улица));
		
		ПараметрыЗапроса.Добавить(Новый Структура("Имя, Значение",
			"building",
			ДанныеПочтовогоАдреса.Дом));
		
		ПараметрыЗапроса.Добавить(Новый Структура("Имя, Значение",
			"housing",
			ДанныеПочтовогоАдреса.Строение));
		
		ПараметрыЗапроса.Добавить(Новый Структура("Имя, Значение",
			"apartment",
			ДанныеПочтовогоАдреса.Квартира));
		
	КонецЕсли;
	
	ПараметрыЗапроса.Добавить(Новый Структура("Имя, Значение", "buyingPlace", ГдеПриобретенаПрограмма));
	ПараметрыЗапроса.Добавить(Новый Структура("Имя, Значение", "buyingDate", XMLСтрокаЗначения(ДатаПриобретенияПрограммы)));
	ПараметрыЗапроса.Добавить(Новый Структура("Имя, Значение",
		"workPlaceCount",
		СтрЗаменить(Строка(ЧислоРабочихМест), Символ(160), "")));
	ПараметрыЗапроса.Добавить(Новый Структура("Имя, Значение", "responsibleWorker", Ответственный));
	
	ИнтернетПоддержкаПользователейКлиент.ОбработкаКомандСервиса(
		КонтекстВзаимодействия,
		ЭтотОбъект,
		ПараметрыЗапроса);
	
КонецПроцедуры

&НаКлиенте
Процедура КомандаОтмена(Команда)
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ПриОтветеНаВопросОбОтказеОтРегистрации", ЭтотОбъект);
	
	ПоказатьВопрос(ОписаниеОповещения,
		НСтр("ru = 'Вы уверены, что хотите отказаться от регистрации программного продукта?'"),
		РежимДиалогаВопрос.ДаНет,
		,
		,
		НСтр("ru = 'Регистрация программного продукта'"));
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура НастроитьОтображениеФормы()
	
	СписокВыбораОрганизаций = Элементы.Организация.СписокВыбора;
	
	ИнтернетПоддержкаПользователейКлиент.СкопироватьСписокЗначенийИтерационно(
		КонтекстРегистрации.СписокОрганизаций,
		СписокВыбораОрганизаций);
	
	Организация = "-1";
	
	ДанныеПочтовогоАдреса = НовыйДанныеПочтовогоАдреса();
	ПредставлениеАдреса   = НСтр("ru = '<введите адрес>'");
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьТолькоПросмотрПолейОрганизации(ТолькоПросмотрПолей)
	
	Элементы.НазваниеОрганизации.ТолькоПросмотр     = ТолькоПросмотрПолей;
	Элементы.ТипДеятельности.ТолькоПросмотр         = ТолькоПросмотрПолей;
	Элементы.ИНН.ТолькоПросмотр                     = ТолькоПросмотрПолей;
	Элементы.КПП.ТолькоПросмотр                     = ТолькоПросмотрПолей;
	Элементы.Руководитель.ТолькоПросмотр            = ТолькоПросмотрПолей;
	Элементы.Телефон.ТолькоПросмотр                 = ТолькоПросмотрПолей;
	Элементы.АдресЭлектроннойПочты.ТолькоПросмотр   = ТолькоПросмотрПолей;
	Элементы.Факс.ТолькоПросмотр                    = ТолькоПросмотрПолей;
	
КонецПроцедуры

&НаКлиенте
Функция ЗаполнениеПолейКорректно()
	
	Отказ = Ложь;
	
	Если Организация = "-1" Тогда
		
		Если ПустаяСтрока(НазваниеОрганизации) Тогда
			СообщитьОбОшибкеЗаполненияПоля(НСтр("ru = 'Поле ""Название организации"" не заполнено.'"),
				"НазваниеОрганизации",
				Отказ);
		КонецЕсли;
		
		Если ПустаяСтрока(ТипДеятельности) Тогда
			СообщитьОбОшибкеЗаполненияПоля(НСтр("ru = 'Поле ""Тип деятельности"" не заполнено.'"),
				"ТипДеятельности",
				Отказ);
		КонецЕсли;
		
		Если ПустаяСтрока(ИНН) Тогда
			СообщитьОбОшибкеЗаполненияПоля(НСтр("ru = 'Поле ""ИНН"" не заполнено.'"),
				"ИНН",
				Отказ);
		КонецЕсли;
		
		Если ПустаяСтрока(Руководитель) Тогда
			СообщитьОбОшибкеЗаполненияПоля(НСтр("ru = 'Поле ""Руководитель"" не заполнено.'"),
				"Руководитель",
				Отказ);
		КонецЕсли;
		
		Если ПустаяСтрока(Телефон) Тогда
			СообщитьОбОшибкеЗаполненияПоля(НСтр("ru = 'Поле ""Телефон"" не заполнено.'"),
				"Телефон",
				Отказ);
		КонецЕсли;
		
		Если ПустаяСтрока(АдресЭлектроннойПочты) Тогда
			СообщитьОбОшибкеЗаполненияПоля(НСтр("ru = 'Поле ""Адрес электронной почты"" не заполнено.'"),
				"АдресЭлектроннойПочты",
				Отказ);
		КонецЕсли;
		
	КонецЕсли;
	
	Если ПустаяСтрока(ГдеПриобретенаПрограмма) Тогда
		СообщитьОбОшибкеЗаполненияПоля(НСтр("ru = 'Поле ""Место покупки"" не заполнено.'"),
			"ГдеПриобретенаПрограмма",
			Отказ);
	КонецЕсли;
	
	Если ДатаПриобретенияПрограммы = '00010101' Тогда
		СообщитьОбОшибкеЗаполненияПоля(НСтр("ru = 'Поле ""Дата покупки"" не заполнено.'"),
			"ДатаПриобретенияПрограммы",
			Отказ);
	КонецЕсли;
	
	Если ЧислоРабочихМест = 0 Тогда
		СообщитьОбОшибкеЗаполненияПоля(НСтр("ru = 'Поле ""Число рабочих мест"" не заполнено.'"),
			"ЧислоРабочихМест",
			Отказ);
	КонецЕсли;
	
	Если ПустаяСтрока(Ответственный) Тогда
		СообщитьОбОшибкеЗаполненияПоля(НСтр("ru = 'Поле ""Ответственный сотрудник"" не заполнено.'"),
			"Ответственный",
			Отказ);
	КонецЕсли;
	
	Возврат (НЕ Отказ);
	
КонецФункции

&НаКлиенте
Процедура СообщитьОбОшибкеЗаполненияПоля(ТекстСообщения, ИмяПоля, Отказ)
	
	Отказ = Истина;
	Сообщение = Новый СообщениеПользователю;
	Сообщение.Текст = ТекстСообщения;
	Сообщение.Поле  = ИмяПоля;
	Сообщение.Сообщить();
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОтветеНаВопросОбОтказеОтРегистрации(РезультатВопроса, ДопПараметры) Экспорт
	
	Если РезультатВопроса = КодВозвратаДиалога.Да Тогда
		ЭтотОбъект.Закрыть();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриВводеАдреса(ОтредактированныеДанныеАдреса, ДопПараметры) Экспорт
	
	Если ТипЗнч(ОтредактированныеДанныеАдреса) <> Тип("Структура") Тогда
		Возврат;
	КонецЕсли;
	
	ДанныеПочтовогоАдреса = ОтредактированныеДанныеАдреса;
	СформироватьПредставлениеАдреса();
	
КонецПроцедуры

&НаКлиенте
Функция ДанныеНовойОрганизации()
	
	Результат = Новый Структура;
	
	Результат.Вставить("НазваниеОрганизации", НазваниеОрганизации);
	Результат.Вставить("typeActivity"       , ТипДеятельности);
	Результат.Вставить("inn"                , ИНН);
	Результат.Вставить("kpp"                , КПП);
	Результат.Вставить("director "          , Руководитель);
	Результат.Вставить("phoneNumber"        , Телефон);
	Результат.Вставить("email"              , АдресЭлектроннойПочты);
	Результат.Вставить("fax"                , Факс);
	
	Результат.Вставить("countryId"          , ДанныеПочтовогоАдреса.Страна);
	Результат.Вставить("regionId"           , ДанныеПочтовогоАдреса.КодРегиона);
	Результат.Вставить("area"               , ДанныеПочтовогоАдреса.Район);
	Результат.Вставить("postindex"          , ДанныеПочтовогоАдреса.Индекс);
	Результат.Вставить("city"               , ДанныеПочтовогоАдреса.Город);
	Результат.Вставить("street"             , ДанныеПочтовогоАдреса.Улица);
	Результат.Вставить("building"           , ДанныеПочтовогоАдреса.Дом);
	Результат.Вставить("housing"            , ДанныеПочтовогоАдреса.Строение);
	Результат.Вставить("apartment"          , ДанныеПочтовогоАдреса.Квартира);
	
	Возврат Результат;
	
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Функция НовыйДанныеПочтовогоАдреса()
	
	Результат = Новый Структура;
	Результат.Вставить("Страна"    , "-1");
	Результат.Вставить("Индекс"    , "");
	Результат.Вставить("КодРегиона", "-1");
	Результат.Вставить("Район"     , "");
	Результат.Вставить("Город"     , "");
	Результат.Вставить("Улица"     , "");
	Результат.Вставить("Дом"       , "");
	Результат.Вставить("Строение"  , "");
	Результат.Вставить("Квартира"  , "");
	
	Возврат Результат;
	
КонецФункции

&НаКлиенте
Процедура ЗаполнитьДанныеПолейОрганизации()
	
	ДанныеТекОрганизации  = КонтекстРегистрации.ДанныеОрганизаций[Организация];
	ДанныеПочтовогоАдреса = НовыйДанныеПочтовогоАдреса();
	
	Если ДанныеТекОрганизации = Неопределено Тогда
		
		НазваниеОрганизации     = "";
		ТипДеятельности         = "";
		ИНН                     = "";
		КПП                     = "";
		Руководитель            = "";
		Телефон                 = "";
		АдресЭлектроннойПочты   = "";
		Факс                    = "";
		
	Иначе
		
		ДанныеТекОрганизации.Свойство("НазваниеОрганизации"    , НазваниеОрганизации);
		ДанныеТекОрганизации.Свойство("typeActivity"           , ТипДеятельности);
		ДанныеТекОрганизации.Свойство("inn"                    , ИНН);
		ДанныеТекОрганизации.Свойство("kpp"                    , КПП);
		ДанныеТекОрганизации.Свойство("director"               , Руководитель);
		ДанныеТекОрганизации.Свойство("phoneNumber"            , Телефон);
		ДанныеТекОрганизации.Свойство("email"                  , АдресЭлектроннойПочты);
		ДанныеТекОрганизации.Свойство("fax"                    , Факс);
		
		Если ДанныеТекОрганизации.Свойство("countryId") Тогда
			ДанныеПочтовогоАдреса.Вставить("Страна",
				?(ЗначениеЗаполнено(ДанныеТекОрганизации.countryId), ДанныеТекОрганизации.countryId, "-1"));
		Иначе
			ДанныеПочтовогоАдреса.Вставить("Страна", "-1");
		КонецЕсли;
		
		Если ДанныеПочтовогоАдреса.Страна = "-1" Тогда
			ДанныеПочтовогоАдреса.Вставить("КодРегиона", "-1");
		Иначе
			Если ДанныеТекОрганизации.Свойство("regionId") Тогда
				ДанныеПочтовогоАдреса.Вставить("КодРегиона",
					?(ЗначениеЗаполнено(ДанныеТекОрганизации.regionId), ДанныеТекОрганизации.regionId, "-1"));
			Иначе
				ДанныеПочтовогоАдреса.Вставить("КодРегиона", "-1");
			КонецЕсли;
		КонецЕсли;
		
		Если ДанныеТекОрганизации.Свойство("postindex") Тогда
			ДанныеПочтовогоАдреса.Вставить("Индекс", ДанныеТекОрганизации.postindex);
		КонецЕсли;
		
		Если ДанныеТекОрганизации.Свойство("area") Тогда
			ДанныеПочтовогоАдреса.Вставить("Район", ДанныеТекОрганизации.area);
		КонецЕсли;
		
		Если ДанныеТекОрганизации.Свойство("city") Тогда
			ДанныеПочтовогоАдреса.Вставить("Город", ДанныеТекОрганизации.city);
		КонецЕсли;
		
		Если ДанныеТекОрганизации.Свойство("street") Тогда
			ДанныеПочтовогоАдреса.Вставить("Улица", ДанныеТекОрганизации.street);
		КонецЕсли;
		
		Если ДанныеТекОрганизации.Свойство("building") Тогда
			ДанныеПочтовогоАдреса.Вставить("Дом", ДанныеТекОрганизации.building);
		КонецЕсли;
		
		Если ДанныеТекОрганизации.Свойство("housing") Тогда
			ДанныеПочтовогоАдреса.Вставить("Строение", ДанныеТекОрганизации.housing);
		КонецЕсли;
		
		Если ДанныеТекОрганизации.Свойство("apartment") Тогда
			ДанныеПочтовогоАдреса.Вставить("Квартира", ДанныеТекОрганизации.apartment);
		КонецЕсли;
		
	КонецЕсли;
	
	СформироватьПредставлениеАдреса();
	
КонецПроцедуры

&НаКлиенте
Процедура СформироватьПредставлениеАдреса()
	
	ПредставлениеАдреса = "";
	Если ДанныеПочтовогоАдреса.Страна <> "-1" Тогда
		ЭлементСпискаСтрана = КонтекстРегистрации.Страны.НайтиПоЗначению(ДанныеПочтовогоАдреса.Страна);
		Если ЭлементСпискаСтрана <> Неопределено Тогда
			ПредставлениеАдреса = ЭлементСпискаСтрана.Представление;
		КонецЕсли;
	КонецЕсли;
	
	ДобавитьПодстроку(ПредставлениеАдреса, ДанныеПочтовогоАдреса.Индекс);
	
	ПредставлениеРегиона = "";
	Если ДанныеПочтовогоАдреса.КодРегиона <> "-1" Тогда
		РегионыСтраны = КонтекстРегистрации.РегионыСтран[ДанныеПочтовогоАдреса.Страна];
		Если РегионыСтраны <> Неопределено Тогда
			ЭлементРегион = РегионыСтраны.НайтиПоЗначению(ДанныеПочтовогоАдреса.КодРегиона);
			Если ЭлементРегион <> Неопределено Тогда
				ПредставлениеРегиона = ЭлементРегион.Представление;
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
	ДобавитьПодстроку(ПредставлениеАдреса, ПредставлениеРегиона);
	
	ДобавитьПодстроку(ПредставлениеАдреса, ДанныеПочтовогоАдреса.Район, НСтр("ru = 'район'") + " ");
	ДобавитьПодстроку(ПредставлениеАдреса, ДанныеПочтовогоАдреса.Город, НСтр("ru = 'г.'") + " ");
	ДобавитьПодстроку(ПредставлениеАдреса, ДанныеПочтовогоАдреса.Улица, НСтр("ru = 'ул.'") + " ");
	ДобавитьПодстроку(ПредставлениеАдреса, ДанныеПочтовогоАдреса.Дом, НСтр("ru = 'д.'") + " ");
	ДобавитьПодстроку(ПредставлениеАдреса, ДанныеПочтовогоАдреса.Строение, НСтр("ru = 'стр.'") + " ");
	ДобавитьПодстроку(ПредставлениеАдреса, ДанныеПочтовогоАдреса.Квартира, НСтр("ru = 'кв.'") + " ");
	
	Если ПустаяСтрока(ПредставлениеАдреса) Тогда
		Если Организация = "-1" Тогда
			ПредставлениеАдреса = НСтр("ru = '<введите адрес>'");
		Иначе
			ПредставлениеАдреса = НСтр("ru = '<не заполнен>'");
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция XMLСтрокаЗначения(Знач Значение)
	Возврат XMLСтрока(Значение);
КонецФункции

// Процедура добавления подстроки к строке
// Параметры:
//     ИсходнаяСтрока - Строка - исходная строка;
//     Подстрока      - Строка - строка, которая должна быть добавлена в конец исходной строки;
//     Префикс        - Строка - строка, которая добавляется перед подстрокой;
//     Разделитель    - строка - строка, которая служит разделителем между строкой и подстрокой.
//
&НаКлиенте
Процедура ДобавитьПодстроку(ИсходнаяСтрока, Знач Подстрока, Префикс = "", Разделитель = ", ")
	
	Если НЕ ПустаяСтрока(ИсходнаяСтрока) И НЕ ПустаяСтрока(Подстрока) Тогда
		ИсходнаяСтрока = ИсходнаяСтрока + Разделитель;
	КонецЕсли;
	
	Если НЕ ПустаяСтрока(Подстрока) Тогда
		ИсходнаяСтрока = ИсходнаяСтрока + Префикс + Подстрока;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
