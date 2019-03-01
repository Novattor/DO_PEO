
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	НастройкаУсловияХранилищеЗначения = Параметры.НастройкаУсловия;
	
	Настройки = НастройкаУсловияХранилищеЗначения.Получить();
	
	СхемаКомпоновкиДанных = Справочники.ПравилаРазмещенияФайловВТомах.ПолучитьМакет("Версии");
	Если Настройки = Неопределено Тогда
		Настройки = СхемаКомпоновкиДанных.НастройкиПоУмолчанию;
	КонецЕсли;

	АдресСхемы = ПоместитьВоВременноеХранилище(СхемаКомпоновкиДанных, Новый УникальныйИдентификатор());
	ИсточникНастроек = Новый ИсточникДоступныхНастроекКомпоновкиДанных(АдресСхемы);
	Компоновщик.Инициализировать(ИсточникНастроек);
	Компоновщик.ЗагрузитьНастройки(Настройки);
	
	ПредставлениеПравил = Строка(Компоновщик.Настройки.Отбор);
	Заголовок = СтрШаблон(
		НСтр("ru = 'Версии файлов, которые подходят для правила: ""%1""'"), 
		ПредставлениеПравил);
	
	РаботаСФайламиВызовСервера.СкопироватьОтбор(Список.Отбор, Компоновщик.Настройки.Отбор);
	
КонецПроцедуры
