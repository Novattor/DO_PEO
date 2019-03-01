
// Удаляет порцию устаревших данных.
// 
// Возвращаемое значение - Булево - Истина, если были найдены устаревшие данные, в противном случае Ложь.
// 
Функция УдалитьПорциюУстаревшихДанных() Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ РАЗЛИЧНЫЕ ПЕРВЫЕ 1000
		|	ПромежуточныеРезультатыПоискаПисем.ИдентификаторПоиска
		|ИЗ
		|	РегистрСведений.ПромежуточныеРезультатыПоискаПисем КАК ПромежуточныеРезультатыПоискаПисем
		|ГДЕ
		|	ПромежуточныеРезультатыПоискаПисем.ДатаПоиска < &ДатаПоиска";
	Запрос.УстановитьПараметр("ДатаПоиска", ТекущаяДатаСеанса() - 24 * 60 * 60); //Выбираем зависшие сутки назад
	
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		Набор = РегистрыСведений.ПромежуточныеРезультатыПоискаПисем.СоздатьНаборЗаписей();
		Набор.Отбор.ИдентификаторПоиска.Установить(Выборка.ИдентификаторПоиска);
		Набор.Записать(Истина);
	КонецЦикла;
	
	ЗаписьЖурналаРегистрации(
		НСтр("ru='Удаление устаревших данных'"), 
		УровеньЖурналаРегистрации.Информация,
		Метаданные.РегистрыСведений.ПромежуточныеРезультатыПоискаПисем,, 
		СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Процедура завершена успешно, обработано %1 записей'"), Выборка.Количество()));
	
	Возврат Выборка.Количество() > 0;
	
КонецФункции
