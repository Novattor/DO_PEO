
&НаКлиенте
Процедура ЗагрузитьКакОтдельныеФайлы(Команда)
	
	Перем ВладелецФайлов;
	
	ВыделенныеСтроки = Элементы.ТаблицаФайлов.ВыделенныеСтроки;
	Если ВыделенныеСтроки.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;	
	
	Массив = Новый Массив;
	Массив.Добавить(Тип("СправочникСсылка.ВнутренниеДокументы"));
	Массив.Добавить(Тип("СправочникСсылка.ВходящиеДокументы"));
	Массив.Добавить(Тип("СправочникСсылка.ИсходящиеДокументы"));
	Массив.Добавить(Тип("СправочникСсылка.ПапкиФайлов"));
	ОписаниеТипов = Новый ОписаниеТипов(Массив);
	ОписаниеОповещения = Новый ОписаниеОповещения(
		"ЗагрузитьКакОтдельныеФайлыПродолжение",
		ЭтотОбъект);
	ПоказатьВводЗначения(ОписаниеОповещения, ВладелецФайлов, "Выберите владельца файла", ОписаниеТипов);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗагрузитьКакОтдельныеФайлыПродолжение(ВладелецФайлов, Параметры) Экспорт
	
	Если Не ЗначениеЗаполнено(ВладелецФайлов) Тогда
		Возврат;
	КонецЕсли;
	ВыделенныеСтроки = Элементы.ТаблицаФайлов.ВыделенныеСтроки;
	РасширениеРезультата = Строка(ФорматХраненияОдностраничный);
	РасширениеРезультата = НРег(РасширениеРезультата); 
	
	НомерФайла = РаботаСФайламиВызовСервера.ПолучитьНовыйНомерДляСканирования(ВладелецФайлов);
	
	Для Каждого НомерСтроки Из ВыделенныеСтроки Цикл
		ЗагрузитьОднуВыделеннуюСтроку(ВладелецФайлов, НомерСтроки, НомерФайла);
	КонецЦикла;	
	
	Если ТаблицаФайлов.Количество() = 0 Тогда
		Закрыть();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗагрузитьОднуВыделеннуюСтроку(ВладелецФайлов, НомерСтроки, НомерФайла)
	
	СтрокаТаблицы = Элементы.ТаблицаФайлов.ДанныеСтроки(НомерСтроки);
	
	Путь = СтрокаТаблицы.ПутьКФайлу;
	
	РасширениеРезультата = Строка(ФорматХраненияОдностраничный);
	РасширениеРезультата = НРег(РасширениеРезультата); 
	
	// если pdf - тут тоже делать конвертацию - только если со сканера
	Если ТипЗагрузки = ПредопределенноеЗначение("Перечисление.ТипЗагрузкиПотоковогоСканирования.СоСканера") Тогда
		Если РасширениеРезультата = "pdf" Тогда
			
			ФайлРезультатаВременный = "";
			#Если НЕ ВебКлиент Тогда 	
				ФайлРезультатаВременный = ПолучитьИмяВременногоФайла("pdf");
			#КонецЕсли	
		
			СтрокаВсехПутей = Путь;
			ПараметрыПриложения["СтандартныеПодсистемы.КомпонентаTwain"].ОбъединитьВМногостраничныйФайл(СтрокаВсехПутей, ФайлРезультатаВременный, ПутьКПрограммеКонвертации);
			Путь = ФайлРезультатаВременный;
			
		КонецЕсли;	
	КонецЕсли;
	
	ИмяФайла = РаботаСФайламиКлиентСервер.ИмяСканированногоФайла(НомерФайла, ПрефиксИнформационнойБазы);
	НомерФайла = НомерФайла + 1;
	
	НеОткрыватьКарточкуПослеСозданияИзФайла = Истина;
	СозданныйФайл = РаботаСФайламиКлиент.СоздатьДокументНаОсновеФайла(Путь, ВладелецФайлов, ЭтаФорма, 
		НеОткрыватьКарточкуПослеСозданияИзФайла, ИмяФайла);
	
	Если НЕ ПустаяСтрока(ФайлРезультатаВременный) Тогда
		УдалитьФайл(ФайлРезультатаВременный);
	КонецЕсли;	
	
	Если (ТипЗагрузки = ПредопределенноеЗначение("Перечисление.ТипЗагрузкиПотоковогоСканирования.ИзКаталога") И УдалятьФайлыПослеЗагрузки) 
		ИЛИ (ТипЗагрузки = ПредопределенноеЗначение("Перечисление.ТипЗагрузкиПотоковогоСканирования.СоСканера")) Тогда
		УдалитьФайл(Путь);
	КонецЕсли;	
	
	ТаблицаФайлов.Удалить(СтрокаТаблицы);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗагрузитьКакОдинФайл(Команда)
	
	Перем ВладелецФайлов;
	
	ВыделенныеСтроки = Элементы.ТаблицаФайлов.ВыделенныеСтроки;
	Если ВыделенныеСтроки.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;	
	
	Массив = Новый Массив;
	Массив.Добавить(Тип("СправочникСсылка.ВнутренниеДокументы"));
	Массив.Добавить(Тип("СправочникСсылка.ВходящиеДокументы"));
	Массив.Добавить(Тип("СправочникСсылка.ИсходящиеДокументы"));
	Массив.Добавить(Тип("СправочникСсылка.ПапкиФайлов"));
	ОписаниеТипов = Новый ОписаниеТипов(Массив);
	ОписаниеОповещения = Новый ОписаниеОповещения(
		"ЗагрузитьКакОдинФайлПродолжение",
		ЭтотОбъект);
	ПоказатьВводЗначения(ОписаниеОповещения, ВладелецФайлов, "Выберите владельца файла", ОписаниеТипов);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗагрузитьКакОдинФайлПродолжение(ВладелецФайлов, Параметры) Экспорт
	
	Если Не ЗначениеЗаполнено(ВладелецФайлов) Тогда
		Возврат;
	КонецЕсли;
	ВыделенныеСтроки = Элементы.ТаблицаФайлов.ВыделенныеСтроки;
	НомерФайла = РаботаСФайламиВызовСервера.ПолучитьНовыйНомерДляСканирования(ВладелецФайлов);
	ИмяФайла = РаботаСФайламиКлиентСервер.ИмяСканированногоФайла(НомерФайла, ПрефиксИнформационнойБазы);
	
	Если ВыделенныеСтроки.Количество() = 1 Тогда
		НомерСтроки = ВыделенныеСтроки[0];
		ЗагрузитьОднуВыделеннуюСтроку(ВладелецФайлов, НомерСтроки, НомерФайла);
		
		Если ТаблицаФайлов.Количество() = 0 Тогда
			Закрыть();
		КонецЕсли;	
		
		Возврат;
	КонецЕсли;	
	
	РасширениеРезультата = Строка(ФорматХраненияОдностраничный);
	РасширениеРезультата = НРег(РасширениеРезультата); 
	
	Путь = "";
	ФайлРезультатаВременный = "";
	МассивВременныхФайлов = Новый Массив;
	
	МассивПутейКартинок = Новый Массив;
	Для Каждого НомерСтроки Из ВыделенныеСтроки Цикл
		
		СтрокаТаблицы = Элементы.ТаблицаФайлов.ДанныеСтроки(НомерСтроки);
		МассивПутейКартинок.Добавить(СтрокаТаблицы.ПутьКФайлу);
		ТаблицаФайлов.Удалить(СтрокаТаблицы);
		
	КонецЦикла;	
	
	// здесь работаем со всеми картинками - объединяем их в один многостраничный файл
	СтрокаВсехПутей = "";
	
	Если ТипЗагрузки = ПредопределенноеЗначение("Перечисление.ТипЗагрузкиПотоковогоСканирования.ИзКаталога") Тогда
		
		Для Каждого Строка Из МассивПутейКартинок Цикл
			
			Файл = Новый Файл(Строка);
			Расширение = Файл.Расширение;
			ФайлВременный = "";
		#Если НЕ ВебКлиент Тогда 	
			ФайлВременный = ПолучитьИмяВременногоФайла(Расширение);
		#КонецЕсли	
			
			МассивВременныхФайлов.Добавить(ФайлВременный);
			
			КопироватьФайл(Строка, ФайлВременный);
			
			СтрокаВсехПутей = СтрокаВсехПутей + "*";
			СтрокаВсехПутей = СтрокаВсехПутей + ФайлВременный;
		КонецЦикла;
		
	Иначе	
		
		Для Каждого Строка Из МассивПутейКартинок Цикл
			СтрокаВсехПутей = СтрокаВсехПутей + "*";
			СтрокаВсехПутей = СтрокаВсехПутей + Строка;
		КонецЦикла;
		
	КонецЕсли;	
	
#Если НЕ ВебКлиент Тогда 	
	РасширениеРезультата = Строка(ФорматХраненияМногостраничный);
	РасширениеРезультата = НРег(РасширениеРезультата); 
	ФайлРезультатаВременный = ПолучитьИмяВременногоФайла(РасширениеРезультата);
#КонецЕсли	
	ПараметрыПриложения["СтандартныеПодсистемы.КомпонентаTwain"].ОбъединитьВМногостраничныйФайл(СтрокаВсехПутей, ФайлРезультатаВременный, ПутьКПрограммеКонвертации);
	Путь = ФайлРезультатаВременный;
	
	НеОткрыватьКарточкуПослеСозданияИзФайла = Истина;
	СозданныйФайл = РаботаСФайламиКлиент.СоздатьДокументНаОсновеФайла(Путь, ВладелецФайлов, ЭтаФорма, 
		НеОткрыватьКарточкуПослеСозданияИзФайла, ИмяФайла);
		
	Если НЕ ПустаяСтрока(ФайлРезультатаВременный) Тогда
		УдалитьФайл(ФайлРезультатаВременный);
	КонецЕсли;	
	
	Для Каждого ПутьФайла Из МассивВременныхФайлов Цикл
		УдалитьФайл(ПутьФайла);
	КонецЦикла;	
	
	Если (ТипЗагрузки = ПредопределенноеЗначение("Перечисление.ТипЗагрузкиПотоковогоСканирования.ИзКаталога") И УдалятьФайлыПослеЗагрузки) 
		ИЛИ (ТипЗагрузки = ПредопределенноеЗначение("Перечисление.ТипЗагрузкиПотоковогоСканирования.СоСканера")) Тогда
		
		УдалитьФайл(Путь);
		
		Для Каждого ПутьФайла Из МассивПутейКартинок Цикл
			УдалитьФайл(ПутьФайла);
		КонецЦикла;	
		
	КонецЕсли;	
		
	Если ТаблицаФайлов.Количество() = 0 Тогда
		Закрыть();
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	ТекстНастроек = Параметры.ТекстНастроек;
	ТипЗагрузки = Параметры.ТипЗагрузки; 
	
	Файлы = Параметры.МассивПутейНераспознанныхФайлов;

	Для Каждого Путь Из Файлы Цикл
		Строка = ТаблицаФайлов.Добавить();
		Строка.ПутьКФайлу = Путь;
		Файл = Новый Файл(Путь);
		Строка.Представление = Файл.ИмяБезРасширения;
		Строка.ИндексКартинки = ФайловыеФункцииКлиентСервер.ПолучитьИндексПиктограммыФайла(Файл.Расширение);
	КонецЦикла;	
	
	Для Каждого Стр Из Параметры.ФайлыДляУдаления Цикл
		Строка = ФайлыДляУдаления.Добавить();
		Строка.Путь = Стр.Путь;
	КонецЦикла;	
	
	ПутьКПрограммеКонвертации =  Параметры.ПутьКПрограммеКонвертации;
	ФорматХраненияОдностраничный =  Параметры.ФорматХраненияОдностраничный;
	ФорматХраненияМногостраничный =  Параметры.ФорматХраненияМногостраничный;
	УдалятьФайлыПослеЗагрузки = Параметры.УдалятьФайлыПослеЗагрузки;
	
	ПрефиксИнформационнойБазы = ПолучитьФункциональнуюОпцию("ПрефиксИнформационнойБазы");
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	Если ОбщегоНазначенияДокументооборотКлиент.ПередЗакрытием(
		Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка, Модифицированность) Тогда
		Возврат;
	КонецЕсли;
	
	// проверять то есть файлы и давать Вопрос - продолжить или нет
	Если ТаблицаФайлов.Количество() <> 0 и Не БылЗаданВопросПередЗакрытием Тогда
		
		СтрокаПроУдаление = "";
		
		Кнопки = Новый СписокЗначений;
		Кнопки.Добавить("Да");
		Кнопки.Добавить("Нет");
					
		Если (ТипЗагрузки = ПредопределенноеЗначение("Перечисление.ТипЗагрузкиПотоковогоСканирования.ИзКаталога") И УдалятьФайлыПослеЗагрузки) 
			ИЛИ (ТипЗагрузки = ПредопределенноеЗначение("Перечисление.ТипЗагрузкиПотоковогоСканирования.СоСканера")) Тогда
			
			СтрокаПроУдаление = НСтр("ru = 'При закрытии они будут удалены. '");
			Кнопки.Добавить("Закрыть без удаления");
			
		КонецЕсли;	
		
		ТекстВопроса = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Осталось незагруженными картинок: %1. %2Продолжить?'"),
			ТаблицаФайлов.Количество(), СтрокаПроУдаление);
			
		ОписаниеОповещения = Новый ОписаниеОповещения(
			"ПередЗакрытиемПродолжение",
			ЭтотОбъект);
		ПоказатьВопрос(ОписаниеОповещения, ТекстВопроса, Кнопки);
		Отказ = Истина;
	КонецЕсли;	
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытиемПродолжение(КодВозврата, Параметры) Экспорт
	
	Если КодВозврата = "Да" ИЛИ КодВозврата = "Закрыть без удаления" Тогда	
		
		Если КодВозврата = "Да" Тогда
			
			Если (ТипЗагрузки = ПредопределенноеЗначение("Перечисление.ТипЗагрузкиПотоковогоСканирования.ИзКаталога") И УдалятьФайлыПослеЗагрузки) 
				ИЛИ (ТипЗагрузки = ПредопределенноеЗначение("Перечисление.ТипЗагрузкиПотоковогоСканирования.СоСканера")) Тогда
				
				Для Каждого Строка Из ТаблицаФайлов Цикл
					УдалитьФайл(Строка.ПутьКФайлу);
				КонецЦикла;	
				
			КонецЕсли;
			
			Для Каждого Строка Из ФайлыДляУдаления Цикл
				Путь = Строка.Путь;
				УдалитьФайл(Путь);
			КонецЦикла;	
			ФайлыДляУдаления.Очистить();
			
		КонецЕсли;
		
		ТаблицаФайлов.Очистить();
		БылЗаданВопросПередЗакрытием = Истина;
		Закрыть();
	Иначе
		Отказ = Истина;
	КонецЕсли;	
	
КонецПроцедуры

&НаКлиенте
Процедура ТаблицаФайловПриАктивизацииСтроки(Элемент)
	
	Если Элементы.ТаблицаФайлов.ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	НомерТекущейСТроки = Элементы.ТаблицаФайлов.ТекущаяСтрока;
	СтрокаТаблицы = Элементы.ТаблицаФайлов.ДанныеСтроки(НомерТекущейСТроки);
	
	Если ПутьКВыбранномуФайлу <> СтрокаТаблицы.ПутьКФайлу Тогда
		
		ПутьКВыбранномуФайлу = СтрокаТаблицы.ПутьКФайлу;
		
		Если ПустаяСтрока(СтрокаТаблицы.АдресКартинки) Тогда
			ДвоичныеДанные = Новый ДвоичныеДанные(ПутьКВыбранномуФайлу);
			СтрокаТаблицы.АдресКартинки = ПоместитьВоВременноеХранилище(ДвоичныеДанные, УникальныйИдентификатор);
		КонецЕсли;	
		
		АдресКартинки = СтрокаТаблицы.АдресКартинки;
		
	КонецЕсли;	
	
	ВыделенныеСтроки = Элементы.ТаблицаФайлов.ВыделенныеСтроки;
	Если ВыделенныеСтроки.Количество() >= 2 Тогда
		Элементы.ФормаЗагрузитьКакОдинФайл.Доступность = Истина;
	Иначе
		Элементы.ФормаЗагрузитьКакОдинФайл.Доступность = Ложь;
	КонецЕсли;	
	
	
КонецПроцедуры

// Удаление файла со снятием атрибута readonly
Процедура УдалитьФайл(ПолноеИмяФайла)
	
	Файл = Новый Файл(ПолноеИмяФайла);
	Если Файл.Существует() Тогда
		Файл.УстановитьТолькоЧтение(Ложь);
		УдалитьФайлы(ПолноеИмяФайла);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ТаблицаФайловВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
    СтандартнаяОбработка = Ложь;
    
    НомерТекущейСтроки = Элементы.ТаблицаФайлов.ТекущаяСтрока;
    СтрокаТаблицы = Элементы.ТаблицаФайлов.ДанныеСтроки(НомерТекущейСтроки);
    
    ЗапуститьПриложение(СтрокаТаблицы.ПутьКФайлу);
	
КонецПроцедуры
