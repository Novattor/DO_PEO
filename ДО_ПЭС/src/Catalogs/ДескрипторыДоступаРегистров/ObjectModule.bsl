
Процедура ПриЗаписи(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	// Если это очистка устаревших дескрипторов, пересчет прав не нужен
	Если ПометкаУдаления Тогда
		Возврат;
	КонецЕсли;
	
	Справочники.ДескрипторыДоступаРегистров.ОбновитьПрава(
		ЭтотОбъект.Ссылка,
		Неопределено,  // Протокол
		Истина);       // Немедленно
	
КонецПроцедуры
