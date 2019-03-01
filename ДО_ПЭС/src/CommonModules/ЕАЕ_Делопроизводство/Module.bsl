///////////////////////////////////////////////////////////////////////////////////////////////
// МОДУЛЬ СОДЕРЖИТ ПРОЦЕДУРЫ И ФУНКЦИИ РАБОТЫ С ВНУТРЕННИМИ, ВХОДЯЩИМИ И ИСХОДЯЩИМИ ДОКУМЕНТАМИ
// 

#Область ПрограммныйИнтерфейс

// Функция - Получить адрес контрагента
//
// Параметры:
//  Контрагент	 - Справочник.Контрагенты - Контрагент по которому необходимо получить адрес
// 
// Возвращаемое значение:
//   Представление - Строка - Адрес контрагента
//
Функция ПолучитьАдресКонтрагента(Контрагент) Экспорт
	
	КонтрагентФизЛицо = Ложь;
	Если Контрагент.ЮрФизЛицо = Перечисления.ЮрФизЛицо.ФизЛицо Тогда
		КонтрагентФизЛицо = Истина;
		Контрагент = Контрагент.ФизЛицо;
	КонецЕсли;
	
	Текст = "ВЫБРАТЬ ПЕРВЫЕ 1
	               |	КонтактнаяИнформация.Представление КАК Представление
	               |ИЗ
	               |	Справочник.";
	Если КонтрагентФизЛицо Тогда 
		Текст = Текст + "ФизическиеЛица."; 
	Иначе
		Текст = Текст + "Контрагенты."; 
	КонецЕсли;
	Текст = Текст +  "КонтактнаяИнформация КАК КонтактнаяИнформация
	               |ГДЕ
	               |	КонтактнаяИнформация.Ссылка = &Ссылка
	               |	И КонтактнаяИнформация.Тип = &Тип
	               |	И КонтактнаяИнформация.Вид = &Вид
	               |
	               |УПОРЯДОЧИТЬ ПО
	               |	КонтактнаяИнформация.ДействуетС УБЫВ";
	
	Запрос = Новый Запрос;
	Запрос.Текст = Текст;
	
	Запрос.УстановитьПараметр("Ссылка", Контрагент);
	Запрос.УстановитьПараметр("Тип", Перечисления.ТипыКонтактнойИнформации.Адрес);
	 
	Если КонтрагентФизЛицо Тогда
		Запрос.УстановитьПараметр("Вид", Справочники.ВидыКонтактнойИнформации.ДомашнийАдресФизическогоЛица);
	Иначе 
		Запрос.УстановитьПараметр("Вид", Справочники.ВидыКонтактнойИнформации.ФактическийАдресКонтрагента);
	КонецЕсли;
	
	Выборка = Запрос.Выполнить();
	Если НЕ Выборка.Пустой() Тогда
		ВыборкаКонтрагента = Выборка.Выбрать();
		ВыборкаКонтрагента.Следующий(); 
		
		Возврат ВыборкаКонтрагента.Представление;
		
	КонецЕсли;
	
	Возврат "";
		
КонецФункции

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

// Функция - Получить доп реквизит адрес контрагента
//  
// Параметры:
//  Параметры - Структура
//              ВидДокумента - Справочник.ВидыВнутреннихДокументов,  
//								ВидыВходящихДокументов,  
//								ВидыИсходящихДокументов   
//              Контрагент - Справочник.Контрагенты
//
//  СписокДопРеквизитов	 - 	Список доп.реквизитов Справочник.ВнутренниеДокументы, 
//													ВходящиеДокументы, 
//													ИсходящиеДокументы - документа, по которому требуется заполнить доп.реквизит Адрес   
// Возвращаемое значение:
//   Соответствие:
//        Ключ - НаименованиеРеквизита 
//        Значение - АдресКонтрагента
//
Функция ПолучитьДопРеквизитАдресКонтрагента(Параметры, СписокДопРеквизитов) Экспорт
	Соответствие = Новый Соответствие();
	
	ВидДокументаВходящееПисьмо = ЕАЕ_ОбщегоНазначенияСерверПовтИсп.ПолучитьСсылкуПоПредопределенномуОбъекту(Справочники.ЕАЕ_ПредопределенныеЗначенияОбъектов.ВидВходДокументаВходящееПисьмо);
	ВидДокументаВходящееПисьмоУФАС = ЕАЕ_ОбщегоНазначенияСерверПовтИсп.ПолучитьСсылкуПоПредопределенномуОбъекту(Справочники.ЕАЕ_ПредопределенныеЗначенияОбъектов.ВидВходДокументаВходПисьмоУФАС);
	ВидДокументаОбращениеОтГраждан = ЕАЕ_ОбщегоНазначенияСерверПовтИсп.ПолучитьСсылкуПоПредопределенномуОбъекту(Справочники.ЕАЕ_ПредопределенныеЗначенияОбъектов.ВидВходДокументаОбращениеОтГраждан);
	
	Если Параметры.ВидДокумента = ВидДокументаВходящееПисьмо Тогда
		Свойство = ЕАЕ_ОбщегоНазначенияСерверПовтИсп.ПолучитьСсылкуПоПредопределенномуОбъекту(Справочники.ЕАЕ_ПредопределенныеЗначенияОбъектов.ДопРеквАдресВходПисьмо);
	ИначеЕсли Параметры.ВидДокумента =  ВидДокументаВходящееПисьмоУФАС Тогда
		Свойство = ЕАЕ_ОбщегоНазначенияСерверПовтИсп.ПолучитьСсылкуПоПредопределенномуОбъекту(Справочники.ЕАЕ_ПредопределенныеЗначенияОбъектов.ДопРеквАдресВходПисьмоУФАС);
	ИначеЕсли Параметры.ВидДокумента =  ВидДокументаОбращениеОтГраждан Тогда
		Свойство = ЕАЕ_ОбщегоНазначенияСерверПовтИсп.ПолучитьСсылкуПоПредопределенномуОбъекту(Справочники.ЕАЕ_ПредопределенныеЗначенияОбъектов.ДопРеквАдресВходПисьмоОбращение);
	Иначе Свойство = Неопределено;
	КонецЕсли;
	
	Если НЕ Свойство = Неопределено Тогда
		НайденныеСтроки = СписокДопРеквизитов.НайтиСтроки(Новый Структура("Свойство", Свойство));
		Если НайденныеСтроки.Количество() > 0 Тогда
			НаименованиеРеквизита = НайденныеСтроки[0].ИмяРеквизитаЗначение;
			Соответствие.Вставить(НаименованиеРеквизита, ПолучитьАдресКонтрагента(Параметры.Контрагент));
		КонецЕсли; 		
	КонецЕсли;

	Возврат Соответствие;
	
КонецФункции

#КонецОбласти