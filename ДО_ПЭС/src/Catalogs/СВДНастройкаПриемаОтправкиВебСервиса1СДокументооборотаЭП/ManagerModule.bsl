#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
	
// Возвращает прокси веб-сервиса
// Возвращаемое значение
// Прокси веб-сервиса
// 		WSПрокси
//
Функция ПолучитьПрокси(НастройкаПриемаОтправки)
	
	МестоположениеWSDL = НастройкаПриемаОтправки.АдресВебСервиса;
	Если ЗначениеЗаполнено(МестоположениеWSDL) И 
		Прав(МестоположениеWSDL, 1) <> "/" И Прав(МестоположениеWSDL, 1) <> "\" Тогда
		МестоположениеWSDL = МестоположениеWSDL + "/";
	КонецЕсли;	
	МестоположениеWSDL = МестоположениеWSDL + "ws/medo1c.1cws?wsdl";
	
	ИмяПользователя = НастройкаПриемаОтправки.Логин;
	Пароль 		 	= НастройкаПриемаОтправки.Пароль;
	
	Если ИмяПользователя = Неопределено ИЛИ ПустаяСтрока(ИмяПользователя) Тогда
		ВызватьИсключение НСтр("ru = 'Не заполнены параметры авторизации на сервере СВД'");
	КонецЕсли;	
	
	Определение = Новый WSОпределения(
		МестоположениеWSDL, 
		ИмяПользователя,
		Пароль);
	
	Прокси = Новый WSПрокси(
		Определение,
		"http://www.1c.ru/medosigned",
		"MEDO1C",
		"MEDO1CSoap");
		
	Прокси.Пользователь = ИмяПользователя;
	Прокси.Пароль = Пароль;
	
	Возврат Прокси;
	
КонецФункции	

// Возвращает прокси веб-сервиса
// Возвращаемое значение
// Прокси веб-сервиса
// 		WSПрокси
//
Функция ПроверитьСоединение(АдресВебСервиса, ИмяПользователя, Пароль) Экспорт
	
	МестоположениеWSDL = АдресВебСервиса;
	Если ЗначениеЗаполнено(МестоположениеWSDL) И 
		Прав(МестоположениеWSDL, 1) <> "/" И Прав(МестоположениеWSDL, 1) <> "\" Тогда
		МестоположениеWSDL = МестоположениеWSDL + "/";
	КонецЕсли;	
	МестоположениеWSDL = МестоположениеWSDL + "ws/medo1c.1cws?wsdl";
	
	Если ИмяПользователя = Неопределено ИЛИ ПустаяСтрока(ИмяПользователя) Тогда
		ВызватьИсключение НСтр("ru = 'Не заполнены параметры авторизации на сервере СВД'");
	КонецЕсли;	
	
	Определение = Новый WSОпределения(
		МестоположениеWSDL, 
		ИмяПользователя,
		Пароль);
	
	Прокси = Новый WSПрокси(
		Определение,
		"http://www.1c.ru/medosigned",
		"MEDO1C",
		"MEDO1CSoap");
		
	Прокси.Пользователь = ИмяПользователя;
	Прокси.Пароль = Пароль;
	
	Результат = Прокси.TestConnection();
	Возврат Результат;
	
КонецФункции	

// Отправить сообщение СВД
Функция ОтправитьСообщение(НастройкаПриемаОтправки, Транспорт, ИсходящееСообщениеСВД) Экспорт
	
	МассивФайлов = РаботаСФайламиВызовСервера.ПолучитьВсеПодчиненныеФайлы(ИсходящееСообщениеСВД);
	Если МассивФайлов.Количество() <> 1 Тогда
		
		Если МассивФайлов.Количество() = 0 Тогда
			
			ЗаписьЖурналаРегистрации(
				НСтр("ru = 'Отправка исходящих сообщений СВД'",
					ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка()),
				УровеньЖурналаРегистрации.Ошибка,
				Метаданные.Документы.ИсходящееСообщениеСВД,
				ИсходящееСообщениеСВД,
				НСтр("ru = 'Отсутствует файл сообщения.'",
					ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка()));
				
		Иначе	
				
			ЗаписьЖурналаРегистрации(
				НСтр("ru = 'Отправка исходящих сообщений СВД'",
					ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка()),
				УровеньЖурналаРегистрации.Ошибка, 
				Метаданные.Документы.ИсходящееСообщениеСВД,
				ИсходящееСообщениеСВД, 
				НСтр("ru = 'Количество файлов сообщения больше одного.'",
					ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка()));
				
		КонецЕсли;
		
		Возврат Ложь;
		
	КонецЕсли;	
	
	ФайлСсылка = МассивФайлов[0];
	
	ТекущаяВерсия = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ФайлСсылка, "ТекущаяВерсия");
	ТипХраненияФайла = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ТекущаяВерсия, "ТипХраненияФайла");
	
	ИмяФайлаСПутем = РаботаСФайламиВызовСервера.ПолучитьИмяФайлаСПутемКДвоичнымДанным(ТекущаяВерсия);
	Если Не ЗначениеЗаполнено(ИмяФайлаСПутем) Тогда
		
		ЗаписьЖурналаРегистрации(
			НСтр("ru = 'Отправка исходящих сообщений СВД'",
				ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка()),
			УровеньЖурналаРегистрации.Ошибка,
			Метаданные.Документы.ИсходящееСообщениеСВД,
			ИсходящееСообщениеСВД,
			НСтр("ru = 'Отсутствует файл сообщения.'",
				ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка()));
		Возврат Ложь;	
		
	КонецЕсли;	
	
	
	Прокси = ПолучитьПрокси(НастройкаПриемаОтправки);
	
	// прочитаем XML файл в XDTO объект
	ТипОбъектаXDTO = Прокси.ФабрикаXDTO.Тип("http://www.1c.ru/medosigned", "Header");
	
	ЧтениеXML = Новый ЧтениеXML;
    ЧтениеXML.ОткрытьФайл(ИмяФайлаСПутем);
    ОбъектXDTO = Прокси.ФабрикаXDTO.ПрочитатьXML(ЧтениеXML, ТипОбъектаXDTO);
    ОбъектXDTO.Проверить();
	ЧтениеXML.Закрыть();
	
	Результат = Прокси.Put(ОбъектXDTO);
	
	Если ТипХраненияФайла = Перечисления.ТипыХраненияФайлов.ВИнформационнойБазе Тогда
		УдалитьФайлы(ИмяФайлаСПутем);
	КонецЕсли;
	
	Если Результат.errorQuantity = 0 Тогда
		Возврат Истина;
	Иначе
		
		Для Каждого AckResult Из Результат.message.Acknowledgement.AckResult Цикл
			
			ТекстОшибки = AckResult.__content;
			
			ЗаписьЖурналаРегистрации(
				НСтр("ru = 'Отправка исходящих сообщений СВД'",
					ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка()),
				УровеньЖурналаРегистрации.Ошибка,
				Метаданные.Документы.ИсходящееСообщениеСВД,
				ИсходящееСообщениеСВД, 
				ТекстОшибки);
				
		КонецЦикла;	
		
		ИмяВременногоФайла = ПолучитьИмяВременногоФайла("xml");
		
		ЗаписьXML = Новый ЗаписьXML;
		ЗаписьXML.ОткрытьФайл(ИмяВременногоФайла, "UTF-8");
		Прокси.ФабрикаXDTO.ЗаписатьXML(ЗаписьXML, Результат.message);
		ЗаписьXML.Закрыть();
		
		РаботаССВД.СоздатьВходящееСообщениеСВДИзXML(Транспорт, ИмяВременногоФайла);
		
		УдалитьФайлы(ИмяВременногоФайла);
		
		Возврат Ложь;
		
	КонецЕсли;	
	
КонецФункции

// Отправить сообщения СВД
Функция ОтправитьСообщения(НастройкаПриемаОтправки, Транспорт) Экспорт
	
	Выборка = РаботаССВД.ПолучитьИсходящиеСообщенияДляОтправкиПоТранспорту(Транспорт);
	
	Пока Выборка.Следующий() Цикл
		
		ИсходящееСообщениеСВД = Выборка.Ссылка;
		ИсходящееСообщениеСВДОбъект = Выборка.Ссылка.ПолучитьОбъект();
		
		Попытка
						
			Если ОтправитьСообщение(НастройкаПриемаОтправки, Транспорт, ИсходящееСообщениеСВД) Тогда
								
				ОтправляемыйДокумент = ИсходящееСообщениеСВДОбъект.Документ;			
				
				// если это не уведомление - запишем в историю
				Если ЗначениеЗаполнено(ОтправляемыйДокумент) 
					И (ИсходящееСообщениеСВД.ВидСообщения = Перечисления.ВидыСообщенийСВД.ОсновнойДокумент
					Или ИсходящееСообщениеСВД.ВидСообщения = Перечисления.ВидыСообщенийСВД.ДокументОтвет) Тогда
					РаботаССВД.ЗаписатьВИсториюСостоянийСВД(ОтправляемыйДокумент, 
						ИсходящееСообщениеСВД, Справочники.ВидыСостоянийДокументовВСВД.Отправлен,
						ИсходящееСообщениеСВДОбъект.ИдентификаторСообщения);
						
					РаботаССВД.ЗафиксироватьФактОтправкиДокумента(ОтправляемыйДокумент, ИсходящееСообщениеСВДОбъект.Получатель);
				КонецЕсли;
				
				ИсходящееСообщениеСВДОбъект.ДатаОтправки = ТекущаяДатаСеанса();
				ИсходящееСообщениеСВДОбъект.Отправлено = Истина;
				ИсходящееСообщениеСВДОбъект.Записать();
				
			КонецЕсли;
						
		Исключение
			
			СообщениеОбОшибке = ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
			ЗаписьЖурналаРегистрации(
				НСтр("ru = 'СВД. Отправка на сервер'", ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка()),
				УровеньЖурналаРегистрации.Ошибка,
				Метаданные.Документы.ИсходящееСообщениеСВД,
				ИсходящееСообщениеСВД,
				СообщениеОбОшибке);
				
			ОтправляемыйДокумент = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(
				ИсходящееСообщениеСВД, "Документ");
			
			// если это не уведомление - запишем в историю
			Если ЗначениеЗаполнено(ОтправляемыйДокумент) Тогда
				
				РаботаССВД.ЗаписатьВИсториюСостоянийСВД(
					ОтправляемыйДокумент, 
					ИсходящееСообщениеСВД, 
					Справочники.ВидыСостоянийДокументовВСВД.Ошибка,
					ИсходящееСообщениеСВДОбъект.ИдентификаторСообщения,
					СообщениеОбОшибке);
					
			КонецЕсли;
			
		КонецПопытки;	
			
	КонецЦикла;
	
	Возврат Истина;
	
КонецФункции

// Получить сообщения СВД
Функция ПолучитьСообщения(НастройкаПриемаОтправки, Транспорт) Экспорт
	
	Прокси = ПолучитьПрокси(НастройкаПриемаОтправки);
	
	// В цикле получаем сообщения с веб сервиса и записываем их как ВходящееСообщениеСВД
	
	Пока Истина Цикл
		
		Результат = Прокси.Get();
		
		Если Результат.messagesQuantity = 0 Тогда
			Прервать;
		КонецЕсли;	
		
		Попытка
			
			ИмяВременногоФайла = ПолучитьИмяВременногоФайла("xml");
			
			ЗаписьXML = Новый ЗаписьXML;
			ЗаписьXML.ОткрытьФайл(ИмяВременногоФайла, "UTF-8");
			Прокси.ФабрикаXDTO.ЗаписатьXML(ЗаписьXML, Результат.message);
			ЗаписьXML.Закрыть();
			
			РаботаССВД.СоздатьВходящееСообщениеСВДИзXML(Транспорт, ИмяВременногоФайла);
			
			УдалитьФайлы(ИмяВременногоФайла);
			
		Исключение
			
			СообщениеОбОшибке = ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
			ЗаписьЖурналаРегистрации(
				НСтр("ru = 'СВД. Получение сообщения с сервера. Веб-сервис'",
					ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка()),
				УровеньЖурналаРегистрации.Ошибка,
				НастройкаПриемаОтправки.Метаданные(),
				НастройкаПриемаОтправки,
				СообщениеОбОшибке);
				
		КонецПопытки;
			
	КонецЦикла;
	
	
	Возврат Истина;
	
КонецФункции

// Возвращает формат сообщений в данном виде доставки транспорта
Функция ФорматСообщенияСВД() Экспорт
	
	Возврат Справочники.ФорматыСообщенийСВД.Сообщение1СДокументооборот;
	
КонецФункции	

// Возвращает Истина, если в данном виде доставки транспорта требуется заполнить участников
Функция ТребуетсяЗаполнитьСписокУчастников() Экспорт
	
	Возврат Истина;
	
КонецФункции	

// Получить наименование контрагента в СВД
Функция ПолучитьНаименованиеКонтрагентаВСВД(Контрагент, Транспорт) Экспорт
	
	Возврат РаботаССВД.ПолучитьНаименованиеКонтрагентаВСВДКлиентСервер(Контрагент, Транспорт);
	
КонецФункции	

// Получить наименование организации в СВД
Функция ПолучитьНаименованиеОрганизацииВСВД(ОрганизацияДокумента, Транспорт) Экспорт
	
	Возврат РаботаССВД.ПолучитьНаименованиеОрганизацииВСВДКлиентСервер(ОрганизацияДокумента, Транспорт);
	
КонецФункции	

#КонецЕсли