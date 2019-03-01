Процедура ЗаписатьСообщениеСВД(ВидТранспортаСсылка, СообщениеСВД) Экспорт
	
	Возврат;
	
КонецПроцедуры

Функция ПолучитьНеобходимостьПересылкиСообщенияПолучателю(Получатель) Экспорт 
	
	МенеджерЗаписиРегистра = РегистрыСведений.ПравилаПересылкиСообщений.СоздатьМенеджерЗаписи();
	МенеджерЗаписиРегистра.Пользователь = Получатель;
	МенеджерЗаписиРегистра.Прочитать();
	
	Возврат МенеджерЗаписиРегистра.Выбран();
	
КонецФункции

Процедура ТранспортПриемкиОтправкиПриСозданииНаСервере(Объект) Экспорт
	
	Если Не ЗначениеЗаполнено(Объект.Ссылка) Тогда
		Запрос = Новый Запрос;
		Запрос.Текст = 
			"ВЫБРАТЬ
			|	КОЛИЧЕСТВО(ФорматыСообщенийСВД.Ссылка) КАК КоличествоФорматов
			|ИЗ
			|	Справочник.ФорматыСообщенийСВД КАК ФорматыСообщенийСВД
			|ГДЕ
			|	ФорматыСообщенийСВД.ПометкаУдаления = Ложь";
		Выборка = Запрос.Выполнить().Выбрать();
		Выборка.Следующий();
		Если Выборка.КоличествоФорматов = 1 Тогда
			Выборка = Справочники.ФорматыСообщенийСВД.Выбрать();
			Пока Выборка.Следующий() Цикл
				Если НЕ Выборка.ПометкаУдаления Тогда
					Объект.ФорматСообщения = Выборка.Ссылка;
					Прервать;
				КонецЕсли;
			КонецЦикла;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры