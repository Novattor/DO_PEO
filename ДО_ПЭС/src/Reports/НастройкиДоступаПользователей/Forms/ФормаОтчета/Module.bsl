
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Параметры.СформироватьПриОткрытии = ЗначениеЗаполнено(Параметры.ВладелецНастроек);
	
КонецПроцедуры

&НаСервере
Процедура ПередЗагрузкойВариантаНаСервере(Настройки)
	
	ПредметыДоступа = Новый СписокЗначений;
	ПредметыДоступаСРазрезами = ДокументооборотПраваДоступаПереопределяемый.ПредметыДоступаСРазрезами();
	Для Каждого СтрОбъекта Из ПредметыДоступаСРазрезами Цикл
		Если Не СтрОбъекта.НеЯвляетсяСамостоятельнымПредметомДоступа Тогда
			ПредметыДоступа.Добавить(СтрОбъекта.ОбъектМетаданных);
		КонецЕсли;
	КонецЦикла;
	
	// Установка параметров.
	Настройки.ПараметрыДанных.УстановитьЗначениеПараметра(
		Новый ПараметрКомпоновкиДанных("ПредметыДоступа"), ПредметыДоступа);
	
    Настройки.ПараметрыДанных.УстановитьЗначениеПараметра(
		Новый ПараметрКомпоновкиДанных("ВладелецНастроек"), Параметры.ВладелецНастроек);
	
    Настройки.ПараметрыДанных.УстановитьЗначениеПараметра(
		Новый ПараметрКомпоновкиДанных("ВнутренниеДокументы"),
		ОбщегоНазначения.ИдентификаторОбъектаМетаданных(Метаданные.Справочники.ВнутренниеДокументы));
	
    Настройки.ПараметрыДанных.УстановитьЗначениеПараметра(
		Новый ПараметрКомпоновкиДанных("ВходящиеДокументы"),
		ОбщегоНазначения.ИдентификаторОбъектаМетаданных(Метаданные.Справочники.ВходящиеДокументы));
	
    Настройки.ПараметрыДанных.УстановитьЗначениеПараметра(
		Новый ПараметрКомпоновкиДанных("ИсходящиеДокументы"),
		ОбщегоНазначения.ИдентификаторОбъектаМетаданных(Метаданные.Справочники.ИсходящиеДокументы));
	
    Настройки.ПараметрыДанных.УстановитьЗначениеПараметра(
		Новый ПараметрКомпоновкиДанных("РольРегистрацияВнутренних"),
		ОбщегоНазначения.ИдентификаторОбъектаМетаданных(Метаданные.Роли.РегистрацияВнутреннихДокументов));
	
    Настройки.ПараметрыДанных.УстановитьЗначениеПараметра(
		Новый ПараметрКомпоновкиДанных("РольРегистрацияВходящих"),
		ОбщегоНазначения.ИдентификаторОбъектаМетаданных(Метаданные.Роли.РегистрацияВходящихДокументов));
	
    Настройки.ПараметрыДанных.УстановитьЗначениеПараметра(
		Новый ПараметрКомпоновкиДанных("РольРегистрацияИсходящих"),
		ОбщегоНазначения.ИдентификаторОбъектаМетаданных(Метаданные.Роли.РегистрацияИсходящихДокументов));
	
КонецПроцедуры

&НаСервере
Процедура ПриЗагрузкеПользовательскихНастроекНаСервере(Настройки)
	
	Если ЗначениеЗаполнено(Параметры.ВладелецНастроек) Тогда
		ПараметрыДанных = Отчет.КомпоновщикНастроек.Настройки.ПараметрыДанных.Элементы;
		ИДПараметра = ПараметрыДанных.Найти("ВладелецНастроек").ИдентификаторПользовательскойНастройки;
		Параметр = Отчет.КомпоновщикНастроек.ПользовательскиеНастройки.Элементы.Найти(ИДПараметра);
		Параметр.Значение = Параметры.ВладелецНастроек;
	КонецЕсли;
	
КонецПроцедуры
