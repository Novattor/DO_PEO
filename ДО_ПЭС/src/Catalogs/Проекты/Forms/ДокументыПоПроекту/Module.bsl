#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	Проект = Параметры.Проект;
	ВестиУчетСканКопийОригиналовДокументов = ПолучитьФункциональнуюОпцию("ВестиУчетСканКопийОригиналовДокументов");
	ИспользоватьФайлыУВходящихДокументов = ПолучитьФункциональнуюОпцию("ИспользоватьФайлыУВходящихДокументов");
	ИспользоватьФайлыУИсходящихДокументов = ПолучитьФункциональнуюОпцию("ИспользоватьФайлыУИсходящихДокументов");
	ДоступнаРаботаСЭДО = РаботаССВД.ДоступнаРаботаСЭДО();
	ИспользоватьКонтрольОбъектов = ПолучитьФункциональнуюОпцию("ИспользоватьКонтрольОбъектов");
	ИспользоватьБизнесПроцессыИЗадачи = ПолучитьФункциональнуюОпцию("ИспользоватьБизнесПроцессыИЗадачи");
	ИспользоватьЭлектронныеПодписи = ЭлектроннаяПодпись.ИспользоватьЭлектронныеПодписи();
	ИспользоватьКатегорииДанных = ПолучитьФункциональнуюОпцию("ИспользоватьКатегорииДанных");
	
	ЧтениеВнутреннихДокументов = ПравоДоступа("Чтение", Метаданные.Справочники.ВнутренниеДокументы);
	ЧтениеВходящихДокументов = ПравоДоступа("Чтение", Метаданные.Справочники.ВходящиеДокументы);
	ЧтениеИсходящихДокументов = ПравоДоступа("Чтение", Метаданные.Справочники.ИсходящиеДокументы);
	
	Если ЧтениеВходящихДокументов Тогда
		СписокВходяшие.ТекстЗапроса = 
			СтрЗаменить(СписокВходяшие.ТекстЗапроса, "//", "");
		Элементы.ЕстьКатегорииВходящие.Видимость = ИспользоватьКатегорииДанных;
		Элементы.ПодписанЭПВходящие.Видимость = ИспользоватьЭлектронныеПодписи;
		Элементы.ЗадачиВходящие.Видимость = ИспользоватьБизнесПроцессыИЗадачи;
		Элементы.СостояниеКонтроляВходящие.Видимость = ИспользоватьКонтрольОбъектов;
		Элементы.ПоступилПоСВДВходящие.Видимость = ДоступнаРаботаСЭДО;	
		Элементы.ФайлыВходящие.Видимость = ИспользоватьФайлыУВходящихДокументов;
		
		СписокВходяшие.Параметры.УстановитьЗначениеПараметра("Проект", Проект);
		СписокВходяшие.Параметры.УстановитьЗначениеПараметра("ВестиУчетСканКопийОригиналовДокументов", ВестиУчетСканКопийОригиналовДокументов);
		СписокВходяшие.Параметры.УстановитьЗначениеПараметра("ТекущаяДата", НачалоДня(ТекущаяДатаСеанса()));
	Иначе	
		Элементы.СтраницаВходящиеДокументы.Видимость = Ложь;
	КонецЕсли;
	
	Если ЧтениеИсходящихДокументов Тогда
		СписокИсходящие.ТекстЗапроса = 
			СтрЗаменить(СписокИсходящие.ТекстЗапроса, "//", "");
		Элементы.ЕстьКатегорииИсходящие.Видимость = ИспользоватьКатегорииДанных;
		Элементы.ПодписанЭПИсходящие.Видимость = ИспользоватьЭлектронныеПодписи;
		Элементы.ЗадачиИсходящие.Видимость = ИспользоватьБизнесПроцессыИЗадачи;
		Элементы.СостояниеКонтроляИсходящие.Видимость = ИспользоватьКонтрольОбъектов;
		Элементы.СостояниеСВДИсходящие.Видимость = ДоступнаРаботаСЭДО;
		Элементы.ФайлыИсходящие.Видимость = ИспользоватьФайлыУИсходящихДокументов;
		
		СписокИсходящие.Параметры.УстановитьЗначениеПараметра("Проект", Проект);
		СписокИсходящие.Параметры.УстановитьЗначениеПараметра("ВестиУчетСканКопийОригиналовДокументов", ВестиУчетСканКопийОригиналовДокументов);
		СписокИсходящие.Параметры.УстановитьЗначениеПараметра("ТекущаяДата", НачалоДня(ТекущаяДатаСеанса()));
	Иначе	
		Элементы.СтраницаИсходящиеДокументы.Видимость = Ложь;
	КонецЕсли;
	
	Если ЧтениеВнутреннихДокументов Тогда
		Элементы.ЕстьКатегорииВнутренние.Видимость = ИспользоватьКатегорииДанных;
		Элементы.ПодписанЭПВнутренние.Видимость = ИспользоватьЭлектронныеПодписи;
		Элементы.ЗадачиВнутренние.Видимость = ИспользоватьБизнесПроцессыИЗадачи;
		Элементы.СостояниеКонтроляВнутренние.Видимость = ИспользоватьКонтрольОбъектов;
		
		СписокВнутренние.Параметры.УстановитьЗначениеПараметра("Проект", Проект);
		СписокВнутренние.Параметры.УстановитьЗначениеПараметра("ВестиУчетСканКопийОригиналовДокументов", ВестиУчетСканКопийОригиналовДокументов);
		СписокВнутренние.Параметры.УстановитьЗначениеПараметра("ТекущаяДата", НачалоДня(ТекущаяДатаСеанса()));
	Иначе	
		Элементы.СтраницаВнутренниеДокументы.Видимость = Ложь;
	КонецЕсли;
	
	ТекущаяПапка = Неопределено;
	Элементы.Папки.ТекущаяСтрока = ТекущаяПапка;
	СписокВнутренние.Параметры.УстановитьЗначениеПараметра("Папка", Элементы.Папки.ТекущаяСтрока);
	
	ВидПросмотра = Перечисления.ВидыПросмотраСпискаОбъектов.Списком;
	ПереключитьВидПросмотра();
	
	Результат = ОбновитьКоличествоДоступныхШаблоновВыполнить();
	КоличествоДоступныхШаблоновВнутреннихДокументов = Результат.КоличествоДоступныхШаблоновВнутреннихДокументов;
	КоличествоДоступныхШаблоновВходящихДокументов = Результат.КоличествоДоступныхШаблоновВходящихДокументов;
	КоличествоДоступныхШаблоновИсходящихДокументов = Результат.КоличествоДоступныхШаблоновИсходящихДокументов;
	
КонецПроцедуры

&НаСервере
Процедура ПриЗагрузкеДанныхИзНастроекНаСервере(Настройки)
	
	ТекущаяПапка = Настройки["ТекущаяПапка"];
	Элементы.Папки.ТекущаяСтрока = ТекущаяПапка;
	
	Если Элементы.Папки.ТекущаяСтрока <> Неопределено Тогда
		СписокВнутренние.Параметры.УстановитьЗначениеПараметра("Папка", Элементы.Папки.ТекущаяСтрока);
	КонецЕсли;
	
	ВидПросмотра = Настройки["ВидПросмотра"];
	ПереключитьВидПросмотра();
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	//Обработчик ожидания для периодического обновления количества доступных шаблонов документов через каждые 20 минут
	ПодключитьОбработчикОжидания("ОбновитьКоличествоДоступныхШаблонов", 1200, Ложь);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "ЗаписьКонтроля" Тогда
		Если ЗначениеЗаполнено(Параметр.Предмет) И ДелопроизводствоКлиентСервер.ЭтоДокумент(Параметр.Предмет) Тогда 
			ОповеститьОбИзменении(Параметр.Предмет);
		КонецЕсли;	
	КонецЕсли;	
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицФормы

&НаКлиенте
Процедура СписокВнутренниеПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа, Параметр)
	
	Отказ = Истина;
	СоздатьНовыйВнутреннийДокумент(Копирование);
	
КонецПроцедуры

&НаКлиенте
Процедура СоздатьНовыйВнутреннийДокумент(Копирование)
	
	ТекущийДокумент = Элементы.СписокВнутренние.ТекущаяСтрока;
	
	Если Копирование Тогда 
		ПараметрыФормы = Новый Структура;
		ПараметрыФормы.Вставить("ЗначениеКопирования", ТекущийДокумент);
		Открытьформу("Справочник.ВнутренниеДокументы.ФормаОбъекта", ПараметрыФормы, Элементы.СписокВнутренние, Новый УникальныйИдентификатор);
		Возврат;
	КонецЕсли;
	
	ОписаниеОповещения = Новый ОписаниеОповещения(
		"СоздатьНовыйВнутреннийДокументПродолжение",
		ЭтотОбъект);
	Если КоличествоДоступныхШаблоновВнутреннихДокументов > 0 Тогда
		РаботаСШаблонамиДокументовКлиент.ПоказатьФормуСозданияДокументаПоШаблону(
			ОписаниеОповещения,
			"ШаблоныВнутреннихДокументов");
	Иначе
		Результат = "СоздатьПустойДокумент";
		ВыполнитьОбработкуОповещения(ОписаниеОповещения, Результат);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СоздатьНовыйВнутреннийДокументПродолжение(Результат, Параметры) Экспорт
	
	Если Результат = Неопределено Тогда
		Возврат;
	КонецЕсли;	
	
	ЗначенияЗаполнения = Новый Структура;
	ЗначенияЗаполнения.Вставить("Проект", Проект);
	
	Если ВидПросмотра = ПредопределенноеЗначение("Перечисление.ВидыПросмотраСпискаОбъектов.ПоПапкам") Тогда
		Если ЗначениеЗаполнено(Элементы.Папки.ТекущаяСтрока) Тогда
			ЗначенияЗаполнения.Вставить("Папка", Элементы.Папки.ТекущаяСтрока);
		КонецЕсли;
	КонецЕсли;
	
		
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("ЗначенияЗаполнения", ЗначенияЗаполнения);
	
	Если ТипЗнч(Результат) = Тип("Строка") Тогда
		ПараметрыФормы.Вставить("ШаблонДокумента", Результат);
	Иначе
		ПараметрыФормы.Вставить("ШаблонДокумента", Результат.ШаблонДокумента);
	КонецЕсли;
	
	Открытьформу("Справочник.ВнутренниеДокументы.ФормаОбъекта", ПараметрыФормы, Элементы.СписокВнутренние, Новый УникальныйИдентификатор);
	
КонецПроцедуры

&НаКлиенте
Процедура СписокВходящиеПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа, Параметр)
	
	Отказ = Истина;
	СоздатьНовыйВходящийДокумент(Копирование);
	
КонецПроцедуры

&НаКлиенте
Процедура СоздатьНовыйВходящийДокумент(Копирование)
	
	ТекущийДокумент = Элементы.СписокВходящие.ТекущаяСтрока;
	
	Если Копирование Тогда 
		ПараметрыФормы = Новый Структура;
		ПараметрыФормы.Вставить("ЗначениеКопирования", ТекущийДокумент);
		Открытьформу("Справочник.ВходящиеДокументы.ФормаОбъекта", ПараметрыФормы, Элементы.СписокВходящие, Новый УникальныйИдентификатор);
		Возврат;
	КонецЕсли;
	
	ОписаниеОповещения = Новый ОписаниеОповещения(
		"СоздатьНовыйВходящийДокументПродолжение",
		ЭтотОбъект);
		
	Если КоличествоДоступныхШаблоновВходящихДокументов > 0 Тогда
		РаботаСШаблонамиДокументовКлиент.ПоказатьФормуСозданияДокументаПоШаблону(
			ОписаниеОповещения,
			"ШаблоныВходящихДокументов");
	Иначе
		Результат = "СоздатьПустойДокумент";
		ВыполнитьОбработкуОповещения(ОписаниеОповещения, Результат);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СоздатьНовыйВходящийДокументПродолжение(Результат, Параметры) Экспорт
	
	Если Результат = Неопределено Тогда
		Возврат;
	КонецЕсли;	
	
	ЗначенияЗаполнения = Новый Структура;
	ЗначенияЗаполнения.Вставить("Проект", Проект);
	
	Если ТипЗнч(Результат) = Тип("Строка") Тогда
		ШаблонДокумента = Результат;
	Иначе
		ШаблонДокумента = Результат.ШаблонДокумента;
	КонецЕсли;
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("ЗначенияЗаполнения", ЗначенияЗаполнения);
	ПараметрыФормы.Вставить("ЗаполнятьРеквизитыДоСоздания", Ложь);
	ПараметрыФормы.Вставить("ШаблонДокумента", ШаблонДокумента);
	
	ИмяФормыДокумента = "Справочник.ВходящиеДокументы.ФормаОбъекта";
	
	ОткрытьФорму(ИмяФормыДокумента, ПараметрыФормы, Элементы.СписокВходящие, Новый УникальныйИдентификатор);
	
КонецПроцедуры

&НаКлиенте
Процедура СписокИсходящиеПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа, Параметр)
	
	Отказ = Истина;
	СоздатьНовыйИсходящийДокумент(Копирование);

КонецПроцедуры

&НаКлиенте
Процедура СоздатьНовыйИсходящийДокумент(Копирование)
	
	ТекущийДокумент = Элементы.СписокИсходящие.ТекущаяСтрока;
	
	Если Копирование Тогда 
		ПараметрыФормы = Новый Структура;
		ПараметрыФормы.Вставить("ЗначениеКопирования", ТекущийДокумент);
		Открытьформу("Справочник.ИсходящиеДокументы.ФормаОбъекта", ПараметрыФормы, Элементы.СписокИсходящие, Новый УникальныйИдентификатор);
		Возврат;
	КонецЕсли;
	
	ОписаниеОповещения = Новый ОписаниеОповещения(
		"СоздатьНовыйИсходящийДокументПродолжение",
		ЭтотОбъект);
		
	Если КоличествоДоступныхШаблоновИсходящихДокументов > 0 Тогда
		РаботаСШаблонамиДокументовКлиент.ПоказатьФормуСозданияДокументаПоШаблону(
			ОписаниеОповещения,
			"ШаблоныИсходящихДокументов");
	Иначе
		Результат = "СоздатьПустойДокумент";
		ВыполнитьОбработкуОповещения(ОписаниеОповещения, Результат);
	КонецЕсли;
	
КонецПроцедуры	

&НаКлиенте
Процедура СоздатьНовыйИсходящийДокументПродолжение(Результат, Параметры) Экспорт
	
	Если Результат = Неопределено Тогда
		Возврат;
	КонецЕсли;	
	
	ЗначенияЗаполнения = Новый Структура;
	ЗначенияЗаполнения.Вставить("Проект", Проект);
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("ЗначенияЗаполнения", ЗначенияЗаполнения);
	
	Если ТипЗнч(Результат) = Тип("Строка") Тогда
		ПараметрыФормы.Вставить("ШаблонДокумента", Результат);
	Иначе
		ПараметрыФормы.Вставить("ШаблонДокумента", Результат.ШаблонДокумента);
	КонецЕсли;
	
	Открытьформу("Справочник.ИсходящиеДокументы.ФормаОбъекта", ПараметрыФормы, Элементы.СписокИсходящие, Новый УникальныйИдентификатор);
	
КонецПроцедуры

&НаКлиенте
Процедура ПапкиПриАктивизацииСтроки(Элемент)
	
	Если ВидПросмотра = ПредопределенноеЗначение("Перечисление.ВидыПросмотраСпискаОбъектов.ПоПапкам")
		И ТекущаяПапка <> Элементы.Папки.ТекущаяСтрока Тогда 
		
		ТекущаяПапка = Элементы.Папки.ТекущаяСтрока;
		
		ПодключитьОбработчикОжидания("ОбработкаОжидания", 0.2, Истина);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПапкиПроверкаПеретаскивания(Элемент, ПараметрыПеретаскивания, СтандартнаяОбработка, Строка, Поле)
	СтандартнаяОбработка = Ложь;
КонецПроцедуры

&НаКлиенте
Процедура ПапкиПеретаскивание(Элемент, ПараметрыПеретаскивания, СтандартнаяОбработка, Строка, Поле)
	
	СтандартнаяОбработка = Ложь;
	
	Если Не ЗначениеЗаполнено(Строка) Тогда
		ЭтоПереносПапок = ТипЗнч(ПараметрыПеретаскивания.Значение) = Тип("Массив") 
			И ПараметрыПеретаскивания.Значение.Количество() > 0
			И ТипЗнч(ПараметрыПеретаскивания.Значение[0]) = Тип("СправочникСсылка.ПапкиВнутреннихДокументов");
			
		Если Не ЭтоПереносПапок Тогда
			Возврат;	
		КонецЕсли;			
	КонецЕсли;
	
	Если ТипЗнч(ПараметрыПеретаскивания.Значение) = Тип("Массив") 
		И ПараметрыПеретаскивания.Значение.Количество() > 0 
		И ТипЗнч(ПараметрыПеретаскивания.Значение[0]) = Тип("СправочникСсылка.ВнутренниеДокументы") Тогда
		
		Если ИзменитьПапкуДокументов(ПараметрыПеретаскивания.Значение, Строка) = Истина Тогда
			Элементы.СписокВнутренние.Обновить();
			
			Если ПараметрыПеретаскивания.Значение.Количество() = 1 Тогда
				ПолноеОписание = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
					НСтр("ru = 'Внутренний документ ""%1"" перенесен в папку ""%2""'"), ПараметрыПеретаскивания.Значение[0], Строка);
				
				ПоказатьОповещениеПользователя(
					НСтр("ru = 'Внутренний документ перенесен.'"),
					ПолучитьНавигационнуюСсылку(ПараметрыПеретаскивания.Значение[0]),
					ПолноеОписание,
					БиблиотекаКартинок.Информация32);
			Иначе
				ПолноеОписание = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
					НСтр("ru = 'Внутренние документы (%1 шт.) перенесены в папку ""%2""'"), ПараметрыПеретаскивания.Значение.Количество(), Строка);
				
				ПоказатьОповещениеПользователя(
					НСтр("ru = 'Внутренние документы перенесены.'"),
					,
					ПолноеОписание,
					БиблиотекаКартинок.Информация32);
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
	СтруктураПараметров = Новый Структура;
	СтруктураПараметров.Вставить("Строка", Строка);
	СтруктураПараметров.Вставить("ПараметрыПеретаскивания", ПараметрыПеретаскивания);
	ОписаниеОповещения = Новый ОписаниеОповещения(
		"ПапкиПеретаскиваниеПродолжение",
		ЭтотОбъект,
		СтруктураПараметров);
	
	Если ТипЗнч(ПараметрыПеретаскивания.Значение) = Тип("Массив") 
		И ПараметрыПеретаскивания.Значение.Количество() >= 1 
		И ТипЗнч(ПараметрыПеретаскивания.Значение[0]) = Тип("СправочникСсылка.ПапкиВнутреннихДокументов") Тогда
		
		НайденоЗацикливание = Ложь;
		Если РаботаСФайламиВызовСервера.СменитьРодителяПапок(ПараметрыПеретаскивания.Значение, Строка, НайденоЗацикливание) = Истина Тогда
			Элементы.Папки.Обновить();
			Элементы.СписокВнутренние.Обновить();
			
			Если ПараметрыПеретаскивания.Значение.Количество() = 1 Тогда
				ПолноеОписание = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
					НСтр("ru = 'Папка ""%1"" перенесена в папку ""%2""'"), ПараметрыПеретаскивания.Значение[0], Строка);
				
				ПоказатьОповещениеПользователя(
					НСтр("ru = 'Папка перенесена.'"),
					,
					ПолноеОписание,
					БиблиотекаКартинок.Информация32);
			Иначе
				ПолноеОписание = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
					НСтр("ru = 'Папки (%1 шт.) перенесены в папку ""%2""'"), ПараметрыПеретаскивания.Значение.Количество(), Строка);
				
				ПоказатьОповещениеПользователя(
					НСтр("ru = 'Папки перенесены.'"),
					,
					ПолноеОписание,
					БиблиотекаКартинок.Информация32);
			КонецЕсли;
			
			ВыполнитьОбработкуОповещения(ОписаниеОповещения);
		Иначе
			Если НайденоЗацикливание = Истина Тогда
				ПоказатьПредупреждение(ОписаниеОповещения, НСтр("ru = 'Зацикливание уровней !'"));
			КонецЕсли;
		КонецЕсли;
	Иначе 
		ВыполнитьОбработкуОповещения(ОписаниеОповещения);
	КонецЕсли;
		
КонецПроцедуры

&НаКлиенте
Процедура ПапкиПеретаскиваниеПродолжение(Результат, Параметры) Экспорт 
	
	ОбработатьПеретаскиваниеФайлов(Параметры.ПараметрыПеретаскивания, "Папка", Параметры.Строка);

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ВключитьПросмотрПапками(Команда)
	
	Если ВидПросмотра <> ПредопределенноеЗначение("Перечисление.ВидыПросмотраСпискаОбъектов.ПоПапкам") Тогда
		ВидПросмотра = ПредопределенноеЗначение("Перечисление.ВидыПросмотраСпискаОбъектов.ПоПапкам");
		ПереключитьВидПросмотра();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВключитьПросмотрСписком(Команда)
	
	Если ВидПросмотра <> ПредопределенноеЗначение("Перечисление.ВидыПросмотраСпискаОбъектов.Списком") Тогда
		ВидПросмотра = ПредопределенноеЗначение("Перечисление.ВидыПросмотраСпискаОбъектов.Списком");
		ПереключитьВидПросмотра();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ОбработкаОжидания()
	
	КлючеваяОперация = "ВнутренниеДокументыВыполнениеКомандыОтборПоПапке";
	ОценкаПроизводительностиКлиентСервер.НачатьЗамерВремени(КлючеваяОперация);
		
	СписокВнутренние.Параметры.УстановитьЗначениеПараметра("Папка", Элементы.Папки.ТекущаяСтрока);
	
КонецПроцедуры

&НаСервере
Процедура ПереключитьВидПросмотра()
	
	Параметр = СписокВнутренние.Параметры.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных("Папка"));
	Параметр.Использование = (ВидПросмотра = Перечисления.ВидыПросмотраСпискаОбъектов.ПоПапкам);
   	
	Элементы.ВключитьПросмотрПапкамиВнутренние.Пометка = Ложь;
	Элементы.ВключитьПросмотрСпискомВнутренние.Пометка = Ложь;
	
	Элементы.Папки.Видимость = Ложь;
	
	Если ВидПросмотра = Перечисления.ВидыПросмотраСпискаОбъектов.Списком Тогда
		
        //Элементы.ПапкаВнутренние.Видимость = Истина;
		Элементы.ВключитьПросмотрСпискомВнутренние.Пометка = Истина;

	ИначеЕсли ВидПросмотра = Перечисления.ВидыПросмотраСпискаОбъектов.ПоПапкам Тогда
		
		Элементы.Папки.Видимость = Истина;
		
		Если Элементы.СписокВнутренние.ТекущаяСтрока <> Неопределено Тогда 
			Элементы.Папки.ТекущаяСтрока = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(
				Элементы.СписокВнутренние.ТекущаяСтрока, "Папка");
		КонецЕсли;	
		Если Элементы.Папки.ТекущаяСтрока <> Неопределено Тогда 
			СписокВнутренние.Параметры.УстановитьЗначениеПараметра("Папка", Элементы.Папки.ТекущаяСтрока);
			ТекущаяПапка = Элементы.Папки.ТекущаяСтрока;
		КонецЕсли;
		
		//Элементы.ПапкаВнутренние.Видимость = Ложь;
		Элементы.ВключитьПросмотрПапкамиВнутренние.Пометка = Истина;
		
	Иначе
		ВидПросмотра = Перечисления.ВидыПросмотраСпискаОбъектов.ПоПапкам;
		ПереключитьВидПросмотра();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьКоличествоДоступныхШаблонов()
	
	Результат = ОбновитьКоличествоДоступныхШаблоновВыполнить();
	КоличествоДоступныхШаблоновВнутреннихДокументов = Результат.КоличествоДоступныхШаблоновВнутреннихДокументов;
	КоличествоДоступныхШаблоновВходящихДокументов = Результат.КоличествоДоступныхШаблоновВходящихДокументов;
	КоличествоДоступныхШаблоновИсходящихДокументов = Результат.КоличествоДоступныхШаблоновИсходящихДокументов;
		
КонецПроцедуры	

&НаСервереБезКонтекста
Функция ОбновитьКоличествоДоступныхШаблоновВыполнить()

	КоличествоДоступныхШаблоновВнутреннихДокументов = 0;
	КоличествоДоступныхШаблоновВходящихДокументов = 0;
	КоличествоДоступныхШаблоновИсходящихДокументов = 0;
	
	Если ПравоДоступа("Чтение", Метаданные.Справочники.ШаблоныВходящихДокументов) Тогда 
		Запрос = Новый Запрос;
		Запрос.Текст = 
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	КОЛИЧЕСТВО(*) КАК Количество
		|ИЗ
		|	Справочник.ШаблоныВходящихДокументов КАК ШаблоныВходящихДокументов";
		
		Выборка = Запрос.Выполнить().Выбрать();
		Если Выборка.Следующий() Тогда 
			КоличествоДоступныхШаблоновВходящихДокументов = Выборка.Количество;
		КонецЕсли;
	КонецЕсли;	
	
	Если ПравоДоступа("Чтение", Метаданные.Справочники.ШаблоныИсходящихДокументов) Тогда 
		Запрос = Новый Запрос;
		Запрос.Текст = 
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	КОЛИЧЕСТВО(*) КАК Количество
		|ИЗ
		|	Справочник.ШаблоныИсходящихДокументов КАК ШаблоныИсходящихДокументов";
		
		Выборка = Запрос.Выполнить().Выбрать();
		Если Выборка.Следующий() Тогда 
			КоличествоДоступныхШаблоновИсходящихДокументов = Выборка.Количество;
		КонецЕсли;
	КонецЕсли;
	
	Если ПравоДоступа("Чтение", Метаданные.Справочники.ШаблоныВнутреннихДокументов) Тогда 
		Запрос = Новый Запрос;
		Запрос.Текст = 
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	КОЛИЧЕСТВО(*) КАК Количество
		|ИЗ
		|	Справочник.ШаблоныВнутреннихДокументов КАК ШаблоныВнутреннихДокументов";
	
		Выборка = Запрос.Выполнить().Выбрать();
		Если Выборка.Следующий() Тогда 
			КоличествоДоступныхШаблоновВнутреннихДокументов = Выборка.Количество;
		КонецЕсли;
	КонецЕсли;	
	
	Результат = Новый Структура;
	Результат.Вставить("КоличествоДоступныхШаблоновВнутреннихДокументов", КоличествоДоступныхШаблоновВнутреннихДокументов);
	Результат.Вставить("КоличествоДоступныхШаблоновВходящихДокументов", КоличествоДоступныхШаблоновВходящихДокументов);
	Результат.Вставить("КоличествоДоступныхШаблоновИсходящихДокументов", КоличествоДоступныхШаблоновИсходящихДокументов);
	
	Возврат Результат;
	
КонецФункции

&НаКлиенте
Процедура ОбработатьПеретаскиваниеФайлов(ПараметрыПеретаскивания, ИмяРеквизита, ЗначениеРеквизита)
	
	Если ТипЗнч(ПараметрыПеретаскивания.Значение) = Тип("Файл") 
	   И ПараметрыПеретаскивания.Значение.ЭтоФайл() Тогда
		
		МассивФайлов = Новый Массив;
		МассивФайлов.Добавить(ПараметрыПеретаскивания.Значение.ПолноеИмя);
		
		ЗначенияЗаполнения = Новый Структура;
		ЗначенияЗаполнения.Вставить(ИмяРеквизита, ЗначениеРеквизита);
		
		ПараметрыОткрытияФормы = Новый Структура;
		ПараметрыОткрытияФормы.Вставить("МассивФайлов", МассивФайлов);
		ПараметрыОткрытияФормы.Вставить("ЗначенияЗаполнения", ЗначенияЗаполнения);
		
		ОткрытьФорму("Справочник.ВнутренниеДокументы.ФормаОбъекта", ПараметрыОткрытияФормы);
		
	ИначеЕсли ТипЗнч(ПараметрыПеретаскивания.Значение) = Тип("Массив")
		И ПараметрыПеретаскивания.Значение.Количество() > 0 
		И ТипЗнч(ПараметрыПеретаскивания.Значение[0]) = Тип("Файл") Тогда
		
		МассивФайлов = Новый Массив;
		Для Каждого ФайлПринятый Из ПараметрыПеретаскивания.Значение Цикл
			МассивФайлов.Добавить(ФайлПринятый.ПолноеИмя);
		КонецЦикла;
		
		ЗначенияЗаполнения = Новый Структура;
		ЗначенияЗаполнения.Вставить(ИмяРеквизита, ЗначениеРеквизита);
		
		ПараметрыОткрытияФормы = Новый Структура;
		ПараметрыОткрытияФормы.Вставить("МассивФайлов", МассивФайлов);
		ПараметрыОткрытияФормы.Вставить("ЗначенияЗаполнения", ЗначенияЗаполнения);
		
		ОткрытьФорму("Справочник.ВнутренниеДокументы.ФормаОбъекта", ПараметрыОткрытияФормы);
		
	КонецЕсли;
	
КонецПроцедуры	

&НаСервереБезКонтекста 
Функция МожноИзменятьПапку(ДокументСсылка)
	
	Шаблон = ОбщегоНазначенияДокументооборот.ЗначениеРеквизитаОбъектаВПривилегированномРежиме(
		ДокументСсылка, "Шаблон");
	
	Если ЗначениеЗаполнено(Шаблон) И Не РольДоступна("ПолныеПрава") Тогда 
		
		ЗапретитьИзменятьРеквизитыИзШаблона 
		= ОбщегоНазначенияДокументооборот.ЗначениеРеквизитаОбъектаВПривилегированномРежиме(
			Шаблон, "ЗапретитьИзменятьРеквизитыИзШаблона");
			
		Если ЗапретитьИзменятьРеквизитыИзШаблона И ЗначениеЗаполнено(Шаблон.Папка) Тогда
			Возврат Ложь;
		КонецЕсли;	
			
	КонецЕсли;
		
	Возврат Истина;	
	
КонецФункции	

&НаСервереБезКонтекста 
Функция ИзменитьПапкуДокументов(МассивДокументов, НоваяПапка)
	
	Если МассивДокументов.Количество() = 0 Тогда
		Возврат Ложь;
	КонецЕсли;
	
	// тот же родитель - ничего делать не надо
	Если МассивДокументов[0].Папка = НоваяПапка Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Для Каждого ДокументСсылка Из МассивДокументов Цикл
		
		Если Не ДокументооборотПраваДоступа.ПолучитьПраваПоОбъекту(ДокументСсылка).Изменение Тогда 
			ВызватьИсключение СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
								НСтр("ru = 'У вас нет права на изменение документа ""%1"".'"),
								Строка(ДокументСсылка));
		КонецЕсли;
		
		Если Не МожноИзменятьПапку(ДокументСсылка) Тогда 
			
			ВызватьИсключение СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
								НСтр("ru = 'Запрещено изменять папку у документа ""%1"".'"),
								Строка(ДокументСсылка));
		КонецЕсли;
		
	КонецЦикла;	
	
	НачатьТранзакцию();
	Попытка
		Для Каждого ДокументСсылка Из МассивДокументов Цикл
			ЗаблокироватьДанныеДляРедактирования(ДокументСсылка);
			ДокументОбъект = ДокументСсылка.ПолучитьОбъект();
			ДокументОбъект.Папка = НоваяПапка;
			ДокументОбъект.Записать();
		КонецЦикла;
		ЗафиксироватьТранзакцию();
	Исключение
		ОтменитьТранзакцию();
		ВызватьИсключение;
	КонецПопытки;
	
	Возврат Истина;
	
КонецФункции	

#КонецОбласти
