Функция ВычислитьТекстовоеОписаниеСпискаЗначений(ВидУсловия, СписокЗначений) Экспорт
	
	Представление = "";
	Если СписокЗначений.Количество() = 0
		Или (Не ЗначениеЗаполнено(СписокЗначений[0].Значение)
		И ВидУсловия <> Перечисления.ВидыУсловийОтбораИсходящихПисем.ОтправленоВТечениеУказанногоПериода) Тогда
		Возврат Представление;
	КонецЕсли;
	Если ВидУсловия = Перечисления.ВидыУсловийОтбораИсходящихПисем.ТемаСодержитУказанныеСлова
		ИЛИ ВидУсловия = Перечисления.ВидыУсловийОтбораИсходящихПисем.ТемаНачинаетсяС
		ИЛИ ВидУсловия = Перечисления.ВидыУсловийОтбораИсходящихПисем.ТекстСодержитУказанныеСлова
		ИЛИ ВидУсловия = Перечисления.ВидыУсловийОтбораИсходящихПисем.ОтправленоНаУказанныеАдреса 
		ИЛИ ВидУсловия = Перечисления.ВидыУсловийОтбораИсходящихПисем.ТолькоДляПользователей 
		ИЛИ ВидУсловия = Перечисления.ВидыУсловийОтбораИсходящихПисем.ПолучательВходитВГруппы Тогда
		
		Для Каждого ЭлементСписка Из СписокЗначений Цикл
			Если Не ЗначениеЗаполнено(Представление) Тогда
				Представление = Строка(ЭлементСписка.Значение);
			Иначе
				Представление = Представление + ";" + Строка(ЭлементСписка.Значение);
			КонецЕсли;
		КонецЦикла;		
	ИначеЕсли ВидУсловия = Перечисления.ВидыУсловийОтбораИсходящихПисем.ОтправленоВТечениеУказанногоПериода Тогда	
		
		Если СписокЗначений.Количество() = 2 Тогда
			ДатаПосле = СписокЗначений[0].Значение;
			ДатаДо = СписокЗначений[1].Значение;
			
			Если ЗначениеЗаполнено(ДатаПосле) Тогда
			Представление = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'С %1'"),
				Формат(ДатаПосле, "ДФ='dd.MM.yyyy HH:mm'"));
			Конецесли;
			
			Если ЗначениеЗаполнено(ДатаДо) Тогда
				Если ЗначениеЗаполнено(Представление) Тогда
					Представление = Представление + 
						СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
							НСтр("ru = ' и по %1'"),
							Формат(ДатаДо, "ДФ='dd.MM.yyyy HH:mm'"));
				Иначе
					Представление = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
						НСтр("ru = 'По %1'"),
						Формат(ДатаДо, "ДФ='dd.MM.yyyy HH:mm'"));	
				КонецЕсли;
			Конецесли;
		КонецЕсли;	
	Иначе
		Представление = Строка(СписокЗначений[0].Значение);						
	КонецЕсли;

	Возврат Представление;
	
КонецФункции

Функция ОтрицаниеУсловия(ВидУсловия) Экспорт
	
	Если ВидУсловия = Перечисления.ВидыУсловийОтбораИсходящихПисем.ОтправленоНаУказанныеАдреса Тогда
		Возврат НСтр("ru = 'Адрес получателя НЕ содержит:'");
	ИначеЕсли ВидУсловия = Перечисления.ВидыУсловийОтбораИсходящихПисем.ТемаСодержитУказанныеСлова Тогда
		Возврат НСтр("ru = 'Тема НЕ содержит текст:'");
	ИначеЕсли ВидУсловия = Перечисления.ВидыУсловийОтбораИсходящихПисем.ТемаСодержитУказанныеСлова Тогда
		Возврат НСтр("ru = 'Тема НЕ начинается с:'");
	ИначеЕсли ВидУсловия = Перечисления.ВидыУсловийОтбораИсходящихПисем.ТекстСодержитУказанныеСлова Тогда
		Возврат НСтр("ru = 'Текст НЕ содержит:'");
	ИначеЕсли ВидУсловия = Перечисления.ВидыУсловийОтбораИсходящихПисем.ИмеетВложения Тогда
		Возврат НСтр("ru = 'НЕ имеет вложений'");	
	ИначеЕсли ВидУсловия = Перечисления.ВидыУсловийОтбораВходящихПисем.ПолученоВТечениеУказанногоПериода Тогда
		Возврат НСтр("ru = 'Отправлено НЕ в течение указанного периода:'");	
	ИначеЕсли ВидУсловия = Перечисления.ВидыУсловийОтбораИсходящихПисем.ТолькоДляПользователей Тогда
		Возврат НСтр("ru = 'НЕ для пользователей:'");
	ИначеЕсли ВидУсловия = Перечисления.ВидыУсловийОтбораИсходящихПисем.ПересылаетВходящееПисьмо Тогда
		Возврат НСтр("ru = 'НЕ пересылает входящее письмо'");
	ИначеЕсли ВидУсловия = Перечисления.ВидыУсловийОтбораИсходящихПисем.ПересылаетИсходящееПисьмо Тогда
		Возврат НСтр("ru = 'НЕ пересылает исходящее письмо'");
	ИначеЕсли ВидУсловия = Перечисления.ВидыУсловийОтбораИсходящихПисем.ЯвляетсяОтветомНаПисьмо Тогда
		Возврат НСтр("ru = 'НЕ является ответом на письмо'");
	КонецЕсли;
	
	Возврат СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		Нстр("ru = 'НЕ %1'"),
		Строка(ВидУсловия));
	
КонецФункции