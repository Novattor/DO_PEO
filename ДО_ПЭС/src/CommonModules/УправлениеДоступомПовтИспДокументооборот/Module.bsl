
// Только для внутреннего использования
Функция ТаблицаПустогоНабораЗаписей(ПолноеИмяРегистра) Экспорт
	
	Менеджер = ОбщегоНазначения.МенеджерОбъектаПоПолномуИмени(ПолноеИмяРегистра);
	
	Возврат Менеджер.СоздатьНаборЗаписей().Выгрузить();
	
КонецФункции
