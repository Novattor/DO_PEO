
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Если Параметры.Свойство("СсылкаНаКатегорию") Тогда
		Если НЕ Параметры.СсылкаНаКатегорию.Пустая() Тогда
			ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(Список.Отбор,
			"Категория",
			Параметры.СсылкаНаКатегорию,
			ВидСравненияКомпоновкиДанных.Равно);
			Категория = Параметры.СсылкаНаКатегорию;
			Элементы.Список.ПодчиненныеЭлементы.Категория.Видимость = Ложь;
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура СписокПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа)
	
	Если НЕ ПроверитьВозможностьСозданияПравила() Тогда
		Отказ = Истина;
		Возврат;
	КонецЕсли;
	
	Если НЕ Копирование Тогда
		ПараметрыФормы = Новый Структура("Категория", Категория);
		ОткрытьФорму("Справочник.ПравилаАвтоматическойКатегоризацииДанных.ФормаОбъекта", ПараметрыФормы, Элемент); 
		Отказ = Истина;
	КонецЕсли;
	
КонецПроцедуры                                       

&НаСервере
Функция ПроверитьВозможностьСозданияПравила()
	
	УстановитьПривилегированныйРежим(Истина);
	ИДЗадания = РегламентныеЗадания.НайтиПредопределенное("АвтоматическаяКатегоризацияДанных").УникальныйИдентификатор;
	Задание = РегламентныеЗаданияСервер.ПолучитьРегламентноеЗадание(ИДЗадания);
	Свойства = РегламентныеЗаданияСлужебный.ПолучитьСвойстваПоследнегоФоновогоЗаданияВыполненияРегламентногоЗадания(Задание);
	Если  Задание <> Неопределено
		И Свойства <> Неопределено
		И Задание.Использование 
		И Свойства.Состояние = СостояниеФоновогоЗадания.Активно Тогда
		Текст = НСтр("ru = 'В настоящее время выполняется регламентное задание ""Автоматическая категоризация данных"".
			|Для создания правила необходимо выключить данное задание либо дождаться его завершения.'");
		Сообщение = Новый СообщениеПользователю;
		Сообщение.Текст = НСтр(Текст);
		Сообщение.Сообщить();
		Возврат Ложь;
	КонецЕсли;
	Возврат Истина;
	
КонецФункции

&НаКлиенте
Процедура ПроверитьПравило(Команда)
	
	Если НЕ Элементы.Список.ТекущиеДанные = Неопределено Тогда
		ПараметрыФормы = Новый Структура("ПравилоАК", Элементы.Список.ТекущиеДанные.Ссылка);
	 	ОткрытьФорму("Справочник.ПравилаАвтоматическойКатегоризацииДанных.Форма.ФормаПроверкаПравила", ПараметрыФормы,,,,,,
			РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	КонецЕсли;
	
КонецПроцедуры
	
