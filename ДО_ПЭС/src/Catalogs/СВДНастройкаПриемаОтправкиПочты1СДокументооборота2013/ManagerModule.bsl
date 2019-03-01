#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

Функция ОтправитьСообщение(НастройкаПриемаОтправки, Транспорт, ИсходящееСообщениеСВД) Экспорт
	
	Попытка
		
		УчетнаяЗапись = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(НастройкаПриемаОтправки, "УчетнаяЗаписьПочты");
		ПараметрыОтправки = Новый Структура();
		
		// Тема
		ПараметрыОтправки.Вставить("Тема", ИсходящееСообщениеСВД.ИдентификаторСообщения);
		
		// Текст
		ПараметрыОтправки.Вставить("Текст", Строка(ТекущаяДатаСеанса()));
		
		// Кому
		ПараметрыОтправки.Вставить(
		"Кому", ОбщегоНазначения.ЗначениеРеквизитаОбъекта(НастройкаПриемаОтправки, "АдресОтправки"));
		
		// Вставка вложений
		МассивВложений = Новый Массив;
		МассивФайлов = РаботаСФайламиВызовСервера.ПолучитьВсеПодчиненныеФайлы(ИсходящееСообщениеСВД);
		Для каждого ФайлСсылка Из МассивФайлов Цикл
			
			ДвоичныеДанныеФайла = РаботаСФайламиВызовСервера.ПолучитьДвоичныеДанныеФайла(ФайлСсылка);
			
			АдресВоВременномХранилище = ПоместитьВоВременноеХранилище(ДвоичныеДанныеФайла);
			
			СтруктураВложения = Новый Структура();
			СтруктураВложения.Вставить("Адрес", АдресВоВременномХранилище);
			СтруктураВложения.Вставить("ИмяФайла", ФайлСсылка.Наименование + "." + ФайлСсылка.ТекущаяВерсияРасширение);
			МассивВложений.Добавить(СтруктураВложения);
			
		КонецЦикла;
		ПараметрыОтправки.Вставить("Вложения", МассивВложений);
		
		ЛегкаяПочтаСервер.ОтправитьИнтернетПочта(ПараметрыОтправки, УчетнаяЗапись);	
		
		Возврат Истина;
		
	Исключение
		
		Информация = ИнформацияОбОшибке();
		ЗаписьЖурналаРегистрации(
			НСтр("ru = 'СВД. Отправка почты'", ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка()),
			УровеньЖурналаРегистрации.Ошибка,
			ИсходящееСообщениеСВД.Метаданные(),
			ИсходящееСообщениеСВД,
			НСтр("ru = 'Невозможно отправить сообщение. '", ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка())
			+ ПодробноеПредставлениеОшибки(Информация));
		
		Возврат Ложь;
		
	КонецПопытки;
	
КонецФункции

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

Функция ПолучитьСообщения(НастройкаПриемаОтправки, Транспорт) Экспорт
	
	МассивСообщенийСВД = Новый Массив;
	УчетнаяЗапись = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(НастройкаПриемаОтправки, "УчетнаяЗаписьПочты");
	СообщениеОбОшибке = "";
	Соединение = Почта.ИнтернетПочтаУстановитьСоединение(УчетнаяЗапись, , СообщениеОбОшибке);
	Если Соединение = Неопределено Тогда
		
		ЗаписьЖурналаРегистрации(
			НСтр("ru = 'СВД. Получение сообщения с сервера. Получение почты'",
			ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка()), 
			УровеньЖурналаРегистрации.Ошибка,
			НастройкаПриемаОтправки.Метаданные(),
			НастройкаПриемаОтправки,
			НСтр("ru = 'Невозможно подключиться к почтовому серверу.'",
			ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка()));
		Возврат МассивСообщенийСВД;
		
	КонецЕсли;
	
	ПараметрыЗагрузки = Почта.СформироватьСтруктуруПараметровЗагрузки();
	
	ПротоколВходящейПочты = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(УчетнаяЗапись, 
	"ПротоколВходящейПочты");
	
	ПараметрыОтбора = Неопределено;
	Если ПротоколВходящейПочты = "IMAP" Тогда
		
		ПараметрыЗагрузки.ПараметрыОтбора.Вставить("ПослеДатыОтправления", ТекущаяДата() - 7 * 86400);
		ПараметрыЗагрузки.ПараметрыОтбора.Вставить("Удаленные", Ложь);
		
		ПараметрыЗагрузки.Идентификаторы = 
		Соединение.ПолучитьИдентификаторы(ПараметрыЗагрузки.Идентификаторы, 
		ПараметрыЗагрузки.ПараметрыОтбора);
		
	КонецЕсли;	
	
	СообщениеОбОшибке = "";
	Сообщения = Почта.ПолучитьВходящиеСообщения(Соединение, ПараметрыЗагрузки, СообщениеОбОшибке);
	
	Если Сообщения <> Неопределено Тогда
		ИдентификаторыЗагруженныхСообщений = Новый Массив;
		Для каждого Сообщение Из Сообщения Цикл
			Если Сообщение.Вложения.Количество() = 0 Тогда
				ИдентификаторыЗагруженныхСообщений.Добавить(Сообщение.Идентификатор[0]);
				Продолжить;
			КонецЕсли;
			ИмяВременногоОсновногоФайла = "";ИмяКорневогоЭлемента="";
			ТаблицаВложенний = РаботаССВД.СоздатьТаблицуВложений(Сообщение.Вложения,ИмяВременногоОсновногоФайла,ИмяКорневогоЭлемента);
			
			НачатьТранзакцию(); 
			Попытка
				
				Если не ПустаяСтрока(ИмяВременногоОсновногоФайла) Тогда 
					РаботаССВД.СоздатьВходящееСообщениеСВДИзXML(Транспорт, ИмяВременногоОсновногоФайла,ТаблицаВложенний,ИмяКорневогоЭлемента);
				КонецЕсли;
				ИдентификаторыЗагруженныхСообщений.Добавить(Сообщение.Идентификатор[0]);
				ЗафиксироватьТранзакцию();
			Исключение
				ОтменитьТранзакцию();
				ВызватьИсключение;  
			КонецПопытки;
			
		КонецЦикла;
		
		СообщениеОбОшибке = "";
		Если ИдентификаторыЗагруженныхСообщений.Количество() > 0 
			и  Не Почта.УдалитьСообщенияВПочтовомЯщике(
			Соединение,
			ИдентификаторыЗагруженныхСообщений,
			СообщениеОбОшибке) Тогда	
			
			ЗаписьЖурналаРегистрации(
				НСтр("ru = 'СВД. Получение сообщения с сервера. Получение почты'",
				ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка()),
				УровеньЖурналаРегистрации.Ошибка,
				НастройкаПриемаОтправки.Метаданные(),
				НастройкаПриемаОтправки,
				НСтр("ru = 'Невозможно удалить полученные сообщения. '", ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка())
					+ СообщениеОбОшибке);
			
		КонецЕсли;
	Иначе
		
		ЗаписьЖурналаРегистрации(
			НСтр("ru = 'СВД. Получение сообщения с сервера. Получение почты'",
			ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка()), 
			УровеньЖурналаРегистрации.Ошибка,
			НастройкаПриемаОтправки.Метаданные(),
			НастройкаПриемаОтправки,   	
			НСтр("ru = 'Невозможно загрузить сообщения. '", ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка())
				+ СообщениеОбОшибке);
		
	КонецЕсли;
	
	Соединение.Отключиться();
	
КонецФункции

// Возвращает формат сообщений в данном виде доставки транспорта
Функция ФорматСообщенияСВД() Экспорт
	
	Возврат Справочники.ФорматыСообщенийСВД.СообщениеПоГОСТ538982013ВложенныеФайлы;
	
КонецФункции	

// Возвращает Истина, если в данном виде доставки транспорта требуется заполнить участников
Функция ТребуетсяЗаполнитьСписокУчастников() Экспорт
	
	Возврат Истина;
	
КонецФункции	

Функция ПолучитьНаименованиеКонтрагентаВСВД(Контрагент, Транспорт) Экспорт
	
	Возврат РаботаССВД.ПолучитьНаименованиеКонтрагентаВСВДКлиентСервер(Контрагент, Транспорт);
	
КонецФункции	

Функция ПолучитьНаименованиеОрганизацииВСВД(ОрганизацияДокумента, Транспорт) Экспорт
	
	Возврат РаботаССВД.ПолучитьНаименованиеОрганизацииВСВДКлиентСервер(ОрганизацияДокумента, Транспорт);
	
КонецФункции	

#КонецОбласти

#КонецЕсли