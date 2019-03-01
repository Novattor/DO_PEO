
// Делает запись о файле
//
// Параметры:
//   ПутьФайла - полный путь к временному файлу
//   Том - том
//   Версия - ВерсияФайла
//
Процедура ЗаписатьФайл(Том, ПутьФайла, Описание, Версия) Экспорт
	
	Если Не ЗначениеЗаполнено(Том) Или Не ЗначениеЗаполнено(ПутьФайла) Тогда
		
		ЗаписьЖурналаРегистрации(
			НСтр("ru = 'ФайлыКУдалению.ЗаписатьФайл'"),
			УровеньЖурналаРегистрации.Ошибка,,,
			НСтр("ru = 'Не заполнен том или путь'"));
		
		Возврат;
	КонецЕсли;	
	
	УстановитьПривилегированныйРежим(Истина);
	
	МенеджерЗаписи = РегистрыСведений.ФайлыКУдалению.СоздатьМенеджерЗаписи();
	
	МенеджерЗаписи.Том = Том;
	МенеджерЗаписи.ПутьКФайлу = ПутьФайла;
	МенеджерЗаписи.ДатаУдаления = ТекущаяДатаСеанса();
	МенеджерЗаписи.Версия = Версия;
	
	МенеджерЗаписи.Записать();
	
	ПолныйПутьНаТоме = ФайловыеФункцииСлужебный.ПолныйПутьТома(Том) + ПутьФайла;
	ОписаниеЖР = Описание + " " + ПолныйПутьНаТоме;
	
	ЗаписьЖурналаРегистрации(
		НСтр("ru = 'ФайлыКУдалению.ЗаписатьФайл'"),
		УровеньЖурналаРегистрации.Информация,,,
		ОписаниеЖР);
	
КонецПроцедуры

Процедура УдалитьСтарыеФайлы() Экспорт
	
	ЗаписьЖурналаРегистрации(
		НСтр("ru = 'ФайлыКУдалению.УдалитьСтарыеФайлы'"),
		УровеньЖурналаРегистрации.Информация,,,
		НСтр("ru = 'Начало процедуры'"));
	
	УстановитьПривилегированныйРежим(Истина);
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ФайлыКУдалению.Том,
		|	ФайлыКУдалению.ПутьКФайлу,
		|	ФайлыКУдалению.Версия
		|ИЗ
		|	РегистрСведений.ФайлыКУдалению КАК ФайлыКУдалению
		|ГДЕ
		|	ФайлыКУдалению.ДатаУдаления < &Дата";
		  
	Запрос.УстановитьПараметр("Дата", ТекущаяДатаСеанса() - 24 * 3600);	  // за последние сутки не стираем
	
	УдаленоСчетчик = 0;
	
	Таблица = Запрос.Выполнить().Выгрузить();
	Для Каждого Строка Из Таблица Цикл
		
		ПолныйПутьНаТоме = ФайловыеФункцииСлужебный.ПолныйПутьТома(Строка.Том) + Строка.ПутьКФайлу;
		
		ПутьИспользуется = Ложь;
		
		Если ЗначениеЗаполнено(Строка.Версия) Тогда
			
			ВерсияДанные = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Строка.Версия, "ТипХраненияФайла, Том, ПутьКФайлу");
			Если ВерсияДанные.ТипХраненияФайла = Перечисления.ТипыХраненияФайлов.ВТомахНаДиске Тогда
				ПолныйПутьНаТомеВерсии = ФайловыеФункцииСлужебный.ПолныйПутьТома(ВерсияДанные.Том) + ВерсияДанные.ПутьКФайлу;
				Если ПолныйПутьНаТомеВерсии = ПолныйПутьНаТоме Тогда
					ПутьИспользуется = Истина;
				КонецЕсли;			
			КонецЕсли;	
			
		Иначе	
			
			ЗапросПути = Новый Запрос;
			ЗапросПути.Текст = 
				"ВЫБРАТЬ ПЕРВЫЕ 1
				|	ВерсииФайлов.Ссылка
				|ИЗ
				|	Справочник.ВерсииФайлов КАК ВерсииФайлов
				|ГДЕ
				|	ВерсииФайлов.ПутьКФайлу ПОДОБНО &ПутьКФайлу
				|	И ВерсииФайлов.Том = &Том";
				  
			ЗапросПути.УстановитьПараметр("ПутьКФайлу", Строка.ПутьКФайлу);
			ЗапросПути.УстановитьПараметр("Том", Строка.Том);
			Результат = ЗапросПути.Выполнить();
			ПутьИспользуется = Не Результат.Пустой();
			
		КонецЕсли;	
		
		Если ПутьИспользуется Тогда
			
			ТекстОшибки = СтрШаблон(НСтр("ru = 'Файл в томе (%1) все еще используется.'"), ПолныйПутьНаТоме);
			
			ЗаписьЖурналаРегистрации(
				НСтр("ru = 'ФайлыКУдалению.УдалитьСтарыеФайлы'"),
				УровеньЖурналаРегистрации.Ошибка,,,
				ТекстОшибки);
			
			Продолжить;
			
		КонецЕсли;	
		
		ЗаписьЖурналаРегистрации(
			НСтр("ru = 'ФайлыКУдалению.УдалитьСтарыеФайлы'"),
			УровеньЖурналаРегистрации.Информация,,,
			ПолныйПутьНаТоме);
		
		Попытка
			ФайлВременный = Новый Файл(ПолныйПутьНаТоме);	
			Если ФайлВременный.ЭтоФайл() И ФайлВременный.Существует() Тогда
				ФайлВременный.УстановитьТолькоЧтение(Ложь);
				УдалитьФайлы(ПолныйПутьНаТоме);
			КонецЕсли;
		Исключение
			// файла может не быть
		КонецПопытки;	
		
		// стираем запись
		МенеджерЗаписи = РегистрыСведений.ФайлыКУдалению.СоздатьМенеджерЗаписи();
		МенеджерЗаписи.ПутьКФайлу = Строка.ПутьКФайлу;
		МенеджерЗаписи.Том = Строка.Том;
		МенеджерЗаписи.Удалить();
		
		УдаленоСчетчик = УдаленоСчетчик + 1;
		
	КонецЦикла;	
	
	Описание = СтрШаблон(НСтр("ru = 'Конец процедуры. Удалено файлов: %1'"), УдаленоСчетчик);
	
	ЗаписьЖурналаРегистрации(
		НСтр("ru = 'ФайлыКУдалению.УдалитьСтарыеФайлы'"),
		УровеньЖурналаРегистрации.Информация,,,
		Описание);
	
КонецПроцедуры	
