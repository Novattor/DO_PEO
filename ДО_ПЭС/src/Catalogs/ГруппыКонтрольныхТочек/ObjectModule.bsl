#Область ОбработчикиСобытий

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка)
	
	Ответственный = ПользователиКлиентСервер.ТекущийПользователь();	
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если Предопределенный Тогда
		ОписаниеОшибки = НСтр("ru = 'Изменение предопределенного элемента справочника запрещено'");
		ВызватьИсключение ОписаниеОшибки;
	КонецЕсли;
		
КонецПроцедуры

#КонецОбласти