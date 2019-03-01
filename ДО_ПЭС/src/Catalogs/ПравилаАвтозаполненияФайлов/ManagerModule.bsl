#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Возвращает структуру полей ПравилаАвтозаполненияШаблоновФайлов
//
// Возвращаемое значение:
//   Структура
//
Функция ПолучитьСтруктуруПравилаАвтозаполнения() Экспорт
	
	ПараметрыПравила = Новый Структура;
	ПараметрыПравила.Вставить("Наименование");
	ПараметрыПравила.Вставить("ВладелецФайла");
	ПараметрыПравила.Вставить("ШаблонФайла");
	ПараметрыПравила.Вставить("Ответственный");
	ПараметрыПравила.Вставить("Комментарий");
	
	ДанныеДляАвтозаполнения = Новый ТаблицаЗначений;
	ДанныеДляАвтозаполнения.Колонки.Добавить("ТермДляЗамены");
	ДанныеДляАвтозаполнения.Колонки.Добавить("ЗаменяемаяСтрока");
	ДанныеДляАвтозаполнения.Колонки.Добавить("ЗначениеЗамены");
	ДанныеДляАвтозаполнения.Колонки.Добавить("ВыражениеОбработкиРезультатаЗамены");
	ДанныеДляАвтозаполнения.Колонки.Добавить("ФорматЗначенияЗамены");
	ДанныеДляАвтозаполнения.Колонки.Добавить("ТипЗначенияЗамены");
	ПараметрыПравила.Вставить("ДанныеДляАвтозаполнения", ДанныеДляАвтозаполнения);
	
	Возврат ПараметрыПравила;
	
КонецФункции

// Создает и записывает в БД правило автозаполнения
//
// Параметры:
//   ПараметрыПравила - Структура - структура полей правила автозаполнения шаблонов файлов.
//
Функция СоздатьПравилоАвтозаполнения(СтруктураПравила) Экспорт
	
	НовоеПравило = Справочники.ПравилаАвтозаполненияФайлов.СоздатьЭлемент();
	ЗаполнитьЗначенияСвойств(НовоеПравило, СтруктураПравила);
	Для Каждого Строка Из СтруктураПравила.ДанныеДляАвтозаполнения Цикл
		НоваяСтрока = НовоеПравило.ДанныеДляАвтозаполнения.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока, Строка);
	КонецЦикла;
	НовоеПравило.Записать();
	
	// Свяжем с шаблоном файла
	Попытка
		ШаблонДокумента = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(СтруктураПравила.ШаблонФайла, "ВладелецФайла");
		
		Если ТипЗнч(ШаблонДокумента) = Тип("СправочникСсылка.ШаблоныВнутреннихДокументов") 
			Или ТипЗнч(ШаблонДокумента) = Тип("СправочникСсылка.ШаблоныИсходящихДокументов") Тогда 
			ЗаблокироватьДанныеДляРедактирования(ШаблонДокумента);
			ШаблонДокументаОбъект = ШаблонДокумента.ПолучитьОбъект();
			НоваяСтрока = ШаблонДокументаОбъект.ПравилаАвтозаполнения.Добавить();
			НоваяСтрока.ШаблонФайла = СтруктураПравила.ШаблонФайла;
			НоваяСтрока.ПравилоАвтозаполнения = НовоеПравило.Ссылка;
			
			ШаблонДокументаОбъект.Записать();
			РазблокироватьДанныеДляРедактирования(ШаблонДокумента);
		КонецЕсли;
	Исключение
		
	КонецПопытки;

	
	Возврат НовоеПравило.Ссылка;
	
КонецФункции

#КонецОбласти

#КонецЕсли