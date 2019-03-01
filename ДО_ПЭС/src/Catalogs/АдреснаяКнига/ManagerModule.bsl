
#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

Процедура ОбновитьДанныеОбъекта(Объект, Родитель, Раздел, ОбъектДоступа = Неопределено) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	Если Не ОбщегоНазначения.СсылкаСуществует(Объект) Тогда
		Возврат;
	КонецЕсли;
	
	// Определение родителя в адресной книге
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ ПЕРВЫЕ 1
		|	АдреснаяКнига.Ссылка
		|ИЗ
		|	Справочник.АдреснаяКнига КАК АдреснаяКнига
		|ГДЕ
		|	АдреснаяКнига.Объект = &Родитель
		|	И АдреснаяКнига.Ссылка В ИЕРАРХИИ(&Раздел)";
	Запрос.УстановитьПараметр("Родитель", Родитель);
	Запрос.УстановитьПараметр("Раздел", Раздел);
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда
		РодительВАдреснойКниге = Выборка.Ссылка;
	Иначе
		РодительВАдреснойКниге = Раздел;
	КонецЕсли;
	
	СсылкаНаОбъектВАдреснойКниге = ПолучитьСсылкуНаОбъектВАдреснойКниге(Объект, Родитель, Раздел);
	
	Если СсылкаНаОбъектВАдреснойКниге = РодительВАдреснойКниге Тогда
		РодительВАдреснойКниге = Неопределено;
	КонецЕсли;
	
	Если СсылкаНаОбъектВАдреснойКниге <> Неопределено Тогда
		
		ЗаблокироватьДанныеДляРедактирования(СсылкаНаОбъектВАдреснойКниге);
		ОбъектВАдреснойКниге = СсылкаНаОбъектВАдреснойКниге.ПолучитьОбъект();
		ОбъектВАдреснойКниге.Родитель = РодительВАдреснойКниге;
		ОбъектВАдреснойКниге.Объект = Объект;
		ОбъектВАдреснойКниге.ОбъектДоступа = ОбъектДоступа;
		УстановитьПорядокОбъектаВСписке(ОбъектВАдреснойКниге, Объект, Родитель);
		УстановитьПризнакОтображенияОбъектаВАдреснойКниге(ОбъектВАдреснойКниге, Объект);
		УстановитьПредставлениеОбъектаВАдреснойКниге(ОбъектВАдреснойКниге, Объект);
		ОбъектВАдреснойКниге.Записать();
		РазблокироватьДанныеДляРедактирования(СсылкаНаОбъектВАдреснойКниге);
		
	Иначе
		
		ОбъектВАдреснойКниге = СоздатьЭлемент();
		ОбъектВАдреснойКниге.Родитель = РодительВАдреснойКниге;
		ОбъектВАдреснойКниге.Объект = Объект;
		ОбъектВАдреснойКниге.ОбъектДоступа = ОбъектДоступа;
		УстановитьПорядокОбъектаВСписке(ОбъектВАдреснойКниге, Объект, Родитель);
		УстановитьПризнакОтображенияОбъектаВАдреснойКниге(ОбъектВАдреснойКниге, Объект);
		УстановитьПредставлениеОбъектаВАдреснойКниге(ОбъектВАдреснойКниге, Объект);
		ОбъектВАдреснойКниге.Записать();
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбновитьСписокПодчиненныхОбъектов(
	Объект, Родитель, Знач СписокПодчиненных, Раздел, ОбъектДоступа = Неопределено) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	Если Не ОбщегоНазначения.СсылкаСуществует(Объект) Тогда
		Возврат;
	КонецЕсли;
	
	НачатьТранзакцию();
	
	ОбъектАдреснойКниге = 
		ПолучитьСсылкуНаОбъектВАдреснойКниге(Объект, Родитель, Раздел);
		
	// Получение текущего списка подчиненных в адресной книге
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	АдреснаяКнига.Ссылка,
		|	АдреснаяКнига.Объект,
		|	АдреснаяКнига.ОбъектДоступа
		|ИЗ
		|	Справочник.АдреснаяКнига КАК АдреснаяКнига
		|ГДЕ
		|	АдреснаяКнига.РодительОбъекта = &РодительОбъекта";
	Запрос.УстановитьПараметр("РодительОбъекта", Объект);
	
	СписокПодчиненныхВАдреснойКниге = Запрос.Выполнить().Выгрузить();
	
	// Получение строк адресной книги к удалению
	СтрокиКУдалению = Новый Массив;
	СтрокиКОбновлениюОбъектаДоступа = Новый Массив;
	Для Каждого СтрАдреснойКниги ИЗ СписокПодчиненныхВАдреснойКниге Цикл
		Если СписокПодчиненных.Найти(СтрАдреснойКниги.Объект) = Неопределено Тогда
			СтрокиКУдалению.Добавить(СтрАдреснойКниги.Ссылка);
		ИначеЕсли СтрАдреснойКниги.ОбъектДоступа <> ОбъектДоступа Тогда
			СтрокиКОбновлениюОбъектаДоступа.Добавить(СтрАдреснойКниги.Ссылка);
		КонецЕсли;
	КонецЦикла;
	
	// Получение списка пользователей к добавлению
	НовыеПодчиненныеОбъекты = Новый Массив;
	Для Каждого Подчиненный ИЗ СписокПодчиненных Цикл
		
		Если Подчиненный = Неопределено Тогда
			Продолжить;
		КонецЕсли;
		
		Если СписокПодчиненныхВАдреснойКниге.Найти(Подчиненный, "Объект") = Неопределено Тогда
			НовыеПодчиненныеОбъекты.Добавить(Подчиненный);
		КонецЕсли;
	КонецЦикла;
	
	// Удаление старых пользователей
	Для Каждого УдаляемаяСтрока Из СтрокиКУдалению Цикл
		УдаляемаяСтрока.ПолучитьОбъект().Удалить();
	КонецЦикла;
	
	// Добавление новых пользователей
	Для Каждого Подчиненный Из НовыеПодчиненныеОбъекты Цикл
		НовыйПодчиненный = СоздатьЭлемент();
		НовыйПодчиненный.Родитель = ОбъектАдреснойКниге;
		НовыйПодчиненный.Объект = Подчиненный;
		НовыйПодчиненный.РодительОбъекта = Объект;
		НовыйПодчиненный.ОбъектДоступа = ОбъектДоступа;
		УстановитьПорядокОбъектаВСписке(НовыйПодчиненный, Подчиненный, Объект);
		УстановитьПризнакОтображенияОбъектаВАдреснойКниге(НовыйПодчиненный, Подчиненный);
		УстановитьПредставлениеОбъектаВАдреснойКниге(НовыйПодчиненный, Подчиненный);
		НовыйПодчиненный.Записать();
	КонецЦикла;
	
	// Обновление объекта доступа для старых подчиненных
	Для Каждого СтрДляОбновленияОбъектаДоступа Из СтрокиКОбновлениюОбъектаДоступа Цикл
		ПодчиненныйОбъект = СтрДляОбновленияОбъектаДоступа.ПолучитьОбъект();
		ПодчиненныйОбъект.ОбъектДоступа = ОбъектДоступа;
		ПодчиненныйОбъект.Записать();
	КонецЦикла;
	
	ЗафиксироватьТранзакцию();
	
КонецПроцедуры

Процедура ОбновитьДанныеОтображенияПодчиненногоОбъекта(Объект) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	Если Не ОбщегоНазначения.СсылкаСуществует(Объект) Тогда
		Возврат;
	КонецЕсли;
	
	Разделы = Новый Массив;
	Разделы.Добавить(Избранное);
	
	ТипОбъекта = ТипЗнч(Объект);
	Если ТипОбъекта = Тип("СправочникСсылка.Пользователи")
		Или ТипОбъекта = Тип("СправочникСсылка.РолиИсполнителей") Тогда
		
		Разделы.Добавить(Сотрудники);
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	АдреснаяКнига.Ссылка,
		|	АдреснаяКнига.Родитель,
		|	АдреснаяКнига.Родитель.Объект КАК РодительОбъект,
		|	АдреснаяКнига.Родитель.ТипДанныхОбъекта КАК ТипДанныхОбъекта
		|ИЗ
		|	Справочник.АдреснаяКнига КАК АдреснаяКнига
		|ГДЕ
		|	АдреснаяКнига.Объект = &Объект
		|	И АдреснаяКнига.Ссылка В ИЕРАРХИИ(&Разделы)";
		
	Запрос.УстановитьПараметр("Разделы", Разделы);
	Запрос.УстановитьПараметр("Объект", Объект);
	
	ТаблицаРодителей = Новый ТаблицаЗначений;
	ТаблицаРодителей.Колонки.Добавить("Объект");
	ТаблицаРодителей.Колонки.Добавить("ЭлементАдреснойКниги");
	
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		ЗаблокироватьДанныеДляРедактирования(Выборка.Ссылка);
		ЭлементАдреснойКниги = Выборка.Ссылка.ПолучитьОбъект();
		УстановитьПризнакОтображенияОбъектаВАдреснойКниге(ЭлементАдреснойКниги, Объект);
		УстановитьПредставлениеОбъектаВАдреснойКниге(ЭлементАдреснойКниги, Объект);
		ЭлементАдреснойКниги.Записать();
		РазблокироватьДанныеДляРедактирования(Выборка.Ссылка);
		
		Если Выборка.ТипДанныхОбъекта = Перечисления.ТипыДанныхАдреснойКниги.ГруппаКонтактовПользователей Тогда
			НоваяСтрРодитель = ТаблицаРодителей.Добавить();
			НоваяСтрРодитель.Объект = Выборка.РодительОбъект;
			НоваяСтрРодитель.ЭлементАдреснойКниги = Выборка.Родитель;
		КонецЕсли;
		
	КонецЦикла;
	
	ТаблицаРодителей.Свернуть("Объект, ЭлементАдреснойКниги");
	
	Для Каждого СтрРодитель Из ТаблицаРодителей Цикл
		ЗаблокироватьДанныеДляРедактирования(СтрРодитель.ЭлементАдреснойКниги);
		ЭлементАдреснойКниги = СтрРодитель.ЭлементАдреснойКниги.ПолучитьОбъект();
		УстановитьПредставлениеОбъектаВАдреснойКниге(ЭлементАдреснойКниги, СтрРодитель.Объект);
		ЭлементАдреснойКниги.Записать();
		РазблокироватьДанныеДляРедактирования(СтрРодитель.ЭлементАдреснойКниги);
	КонецЦикла;
	
КонецПроцедуры

Процедура ОбновитьСпискиАвтоподстановок() Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	АдреснаяКнига.Ссылка
		|ИЗ
		|	Справочник.АдреснаяКнига КАК АдреснаяКнига
		|ГДЕ
		|	(АдреснаяКнига.Родитель В ИЕРАРХИИ (ЗНАЧЕНИЕ(Справочник.АдреснаяКнига.АвтоподстановкиДляДокументов))
		|			ИЛИ АдреснаяКнига.Родитель В ИЕРАРХИИ (ЗНАЧЕНИЕ(Справочник.АдреснаяКнига.АвтоподстановкиДляПроцессов)))
		|	И АдреснаяКнига.Предопределенный = ЛОЖЬ";
		
	Выборка = Запрос.Выполнить().Выбрать();
	
	Пока Выборка.Следующий() Цикл
		ЗаблокироватьДанныеДляРедактирования(Выборка.Ссылка);
		
		ЭлементАдреснойКнигиОбъект = Выборка.Ссылка.ПолучитьОбъект();
		ЭлементАдреснойКнигиОбъект.Удалить();
		
	КонецЦикла;
	
	// Добавление автоподстановок документов
	АвтоподстановкиДокументов = ШаблоныДокументов.ПолучитьСписокДоступныхФункций();
	
	Для Каждого Автоподстановка Из АвтоподстановкиДокументов Цикл
		
		ЭлементАдреснойКнигиОбъект = СоздатьЭлемент();
		ЭлементАдреснойКнигиОбъект.Родитель = Справочники.АдреснаяКнига.АвтоподстановкиДляДокументов;
		ЭлементАдреснойКнигиОбъект.Объект = Автоподстановка.Представление;
		ЭлементАдреснойКнигиОбъект.ОтображатьВАдреснойКниге = Истина;
		ЭлементАдреснойКнигиОбъект.ПредставлениеОбъекта = ЭлементАдреснойКнигиОбъект.Объект;
		ЭлементАдреснойКнигиОбъект.ПорядокОбъектаВСписке = 3;
		ЭлементАдреснойКнигиОбъект.Записать();
		
	КонецЦикла;
	
	// Добавление автоподстановок процессов
	МассивПредметов = Новый Массив;
	МассивПредметов.Добавить("Предмет");
	АвтоподстановкиПроцессов = ШаблоныБизнесПроцессов.ПолучитьСписокДоступныхФункций(МассивПредметов);
	
	Для Каждого Автоподстановка Из АвтоподстановкиПроцессов Цикл
		
		ЭлементАдреснойКнигиОбъект = СоздатьЭлемент();
		ЭлементАдреснойКнигиОбъект.Родитель = Справочники.АдреснаяКнига.АвтоподстановкиДляПроцессов;
		ЭлементАдреснойКнигиОбъект.Объект = СтрЗаменить(Автоподстановка.Представление, "Предмет.", "");
		ЭлементАдреснойКнигиОбъект.ОтображатьВАдреснойКниге = Истина;
		ЭлементАдреснойКнигиОбъект.ПредставлениеОбъекта = ЭлементАдреснойКнигиОбъект.Объект;
		ЭлементАдреснойКнигиОбъект.ПорядокОбъектаВСписке = 3;
		ЭлементАдреснойКнигиОбъект.Записать();
		
	КонецЦикла;
	
КонецПроцедуры

// Добавляет в список пользователей роли, исполнителями которых
// являются пользователи из этого же списка.
//
Процедура РасширитьСписокПользователейРолями(СписокПользователей, ВключатьТолькоРолиПользователейИзСписка = Истина) Экспорт
	
	Запрос = Новый Запрос;
	Если ВключатьТолькоРолиПользователейИзСписка Тогда
		Запрос.Текст = 
			"ВЫБРАТЬ РАЗЛИЧНЫЕ
			|	ИсполнителиЗадач.РольИсполнителя.Владелец КАК Роль
			|ИЗ
			|	РегистрСведений.ИсполнителиЗадач КАК ИсполнителиЗадач
			|ГДЕ
			|	ИсполнителиЗадач.Исполнитель В(&СписокПользователей)";
		Запрос.УстановитьПараметр("СписокПользователей", СписокПользователей);
	Иначе
		Запрос.Текст = 
			"ВЫБРАТЬ
			|	РолиИсполнителей.Ссылка КАК Роль
			|ИЗ
			|	Справочник.РолиИсполнителей КАК РолиИсполнителей";
	КонецЕсли;
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Пока Выборка.Следующий() Цикл
		
		СписокПользователей.Добавить(Выборка.Роль);
		
	КонецЦикла;
	
КонецПроцедуры

Процедура УдалитьОбъект(Объект) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	Если Не ОбщегоНазначения.СсылкаСуществует(Объект) Тогда
		Возврат;
	КонецЕсли;
	
	НачатьТранзакцию();
	
	ОбъектВАдреснойКниге = 
		ПолучитьСсылкуНаОбъектВАдреснойКниге(Объект);
	
	ЗаблокироватьДанныеДляРедактирования(ОбъектВАдреснойКниге);
	ОбъектВАдреснойКниге = ОбъектВАдреснойКниге.ПолучитьОбъект();
	ОбъектВАдреснойКниге.Удалить();
	
	ЗафиксироватьТранзакцию();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ЗаполнитьПредопределенныеРазделы() Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	НачатьТранзакцию();
	
	// Начальное заполнение разделов		
	РазделАдреснойКниги = Справочники.АдреснаяКнига.Избранное.ПолучитьОбъект();
	РазделАдреснойКниги.Объект = НСтр("ru = 'Избранное'");
	РазделАдреснойКниги.ОтображатьВАдреснойКниге = Истина;
	РазделАдреснойКниги.ПредставлениеОбъекта = РазделАдреснойКниги.Объект;
	РазделАдреснойКниги.ПорядокОбъектаВСписке = -13;
	РазделАдреснойКниги.Записать();
	
	РазделАдреснойКниги = Справочники.АдреснаяКнига.Организации.ПолучитьОбъект();
	РазделАдреснойКниги.Объект = НСтр("ru = 'Организации'");
	РазделАдреснойКниги.ОтображатьВАдреснойКниге = Истина;
	РазделАдреснойКниги.ПредставлениеОбъекта = РазделАдреснойКниги.Объект;
	РазделАдреснойКниги.ПорядокОбъектаВСписке = -12;
	РазделАдреснойКниги.Записать();	
	
	РазделАдреснойКниги = Справочники.АдреснаяКнига.Сотрудники.ПолучитьОбъект();
	РазделАдреснойКниги.Объект = НСтр("ru = 'Сотрудники'");
	РазделАдреснойКниги.ОтображатьВАдреснойКниге = Истина;
	РазделАдреснойКниги.ПредставлениеОбъекта = РазделАдреснойКниги.Объект;
	РазделАдреснойКниги.ПорядокОбъектаВСписке = -11;
	РазделАдреснойКниги.Записать();
	
	РазделАдреснойКниги = Справочники.АдреснаяКнига.ПоСтруктуреПредприятия.ПолучитьОбъект();
	РазделАдреснойКниги.Объект = НСтр("ru = 'По подразделениям'");
	РазделАдреснойКниги.ОтображатьВАдреснойКниге = Истина;
	РазделАдреснойКниги.ПредставлениеОбъекта = РазделАдреснойКниги.Объект;
	РазделАдреснойКниги.ПорядокОбъектаВСписке = -10;
	РазделАдреснойКниги.Записать();
	
	РазделАдреснойКниги = Справочники.АдреснаяКнига.ПоРабочимГруппам.ПолучитьОбъект();
	РазделАдреснойКниги.Объект = НСтр("ru = 'По рабочим группам'");
	РазделАдреснойКниги.ОтображатьВАдреснойКниге = Истина;
	РазделАдреснойКниги.ПредставлениеОбъекта = РазделАдреснойКниги.Объект;
	РазделАдреснойКниги.ПорядокОбъектаВСписке = -9;
	РазделАдреснойКниги.Записать();
	
	РазделАдреснойКниги = Справочники.АдреснаяКнига.ПоМероприятиям.ПолучитьОбъект();
	РазделАдреснойКниги.Объект = НСтр("ru = 'По мероприятиям'");
	РазделАдреснойКниги.ОтображатьВАдреснойКниге = Истина;
	РазделАдреснойКниги.ПредставлениеОбъекта = РазделАдреснойКниги.Объект;
	РазделАдреснойКниги.ПорядокОбъектаВСписке = -8;
	РазделАдреснойКниги.Записать();
	
	РазделАдреснойКниги = Справочники.АдреснаяКнига.ПоПроектам.ПолучитьОбъект();
	РазделАдреснойКниги.Объект = НСтр("ru = 'По проектам'");
	РазделАдреснойКниги.ОтображатьВАдреснойКниге = Истина;
	РазделАдреснойКниги.ПредставлениеОбъекта = РазделАдреснойКниги.Объект;
	РазделАдреснойКниги.ПорядокОбъектаВСписке = -7;
	РазделАдреснойКниги.Записать();
	
	РазделАдреснойКниги = Справочники.АдреснаяКнига.АвтоподстановкиДляПроцессов.ПолучитьОбъект();
	РазделАдреснойКниги.Объект = НСтр("ru = 'Автоподстановки'");
	РазделАдреснойКниги.ОтображатьВАдреснойКниге = Истина;
	РазделАдреснойКниги.ПредставлениеОбъекта = РазделАдреснойКниги.Объект;
	РазделАдреснойКниги.ПорядокОбъектаВСписке = -6;
	РазделАдреснойКниги.Записать();
	
	РазделАдреснойКниги = Справочники.АдреснаяКнига.АвтоподстановкиДляДокументов.ПолучитьОбъект();
	РазделАдреснойКниги.Объект = НСтр("ru = 'Автоподстановки'");
	РазделАдреснойКниги.ОтображатьВАдреснойКниге = Истина;
	РазделАдреснойКниги.ПредставлениеОбъекта = РазделАдреснойКниги.Объект;
	РазделАдреснойКниги.ПорядокОбъектаВСписке = -5;
	РазделАдреснойКниги.Записать();
	
	РазделАдреснойКниги = Справочники.АдреснаяКнига.Роли.ПолучитьОбъект();
	РазделАдреснойКниги.Объект = НСтр("ru = 'Роли'");
	РазделАдреснойКниги.ОтображатьВАдреснойКниге = Истина;
	РазделАдреснойКниги.ПредставлениеОбъекта = РазделАдреснойКниги.Объект;
	РазделАдреснойКниги.ПорядокОбъектаВСписке = -4;
	РазделАдреснойКниги.Записать();
	
	РазделАдреснойКниги = Справочники.АдреснаяКнига.Контрагенты.ПолучитьОбъект();
	РазделАдреснойКниги.Объект = НСтр("ru = 'Контрагенты'");
	РазделАдреснойКниги.ОтображатьВАдреснойКниге = Истина;
	РазделАдреснойКниги.ПредставлениеОбъекта = РазделАдреснойКниги.Объект;
	РазделАдреснойКниги.ПорядокОбъектаВСписке = -3;
	РазделАдреснойКниги.Записать();
	
	РазделАдреснойКниги = Справочники.АдреснаяКнига.ЛичныеАдресаты.ПолучитьОбъект();
	РазделАдреснойКниги.Объект = НСтр("ru = 'Личные адресаты'");
	РазделАдреснойКниги.ОтображатьВАдреснойКниге = Истина;
	РазделАдреснойКниги.ПредставлениеОбъекта = РазделАдреснойКниги.Объект;
	РазделАдреснойКниги.ПорядокОбъектаВСписке = -2;
	РазделАдреснойКниги.Записать();
	
	РазделАдреснойКниги = Справочники.АдреснаяКнига.ВсеПользователи.ПолучитьОбъект();
	РазделАдреснойКниги.Объект = НСтр("ru = 'Все пользователи'");
	РазделАдреснойКниги.ОтображатьВАдреснойКниге = Истина;
	РазделАдреснойКниги.ПредставлениеОбъекта = РазделАдреснойКниги.Объект;
	РазделАдреснойКниги.ПорядокОбъектаВСписке = 0;
	РазделАдреснойКниги.Записать();
	
	ЗафиксироватьТранзакцию();
	
КонецПроцедуры

Процедура ЗаполнитьАдреснуюКнигу() Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	ЗаполнитьПредопределенныеРазделы();
	
	ОбновитьСпискиАвтоподстановок();
	
	// Избранное
	Выборка = Справочники.ГруппыКонтактовПользователей.ВыбратьИерархически();
	Пока Выборка.Следующий() Цикл
		
		Если Выборка.ОбщийСписокРассылки Тогда
			ОбъектДоступа = Выборка.Ссылка;
		Иначе
			ОбъектДоступа = Выборка.Автор;
		КонецЕсли;
		
		Если ЗначениеЗаполнено(Выборка.Родитель) Тогда
			ОбновитьДанныеОбъекта(
				Выборка.Ссылка,
				Выборка.Родитель,
				Справочники.АдреснаяКнига.Избранное,
				ОбъектДоступа);
		КонецЕсли;
		
		КонтактыГруппы = Новый Массив;
		Для Каждого СтрКонтакт Из Выборка.Контакты Цикл
			Если ЗначениеЗаполнено(СтрКонтакт.Контакт) Тогда
				КонтактыГруппы.Добавить(СтрКонтакт.Контакт);
			Иначе
				КонтактыГруппы.Добавить(СтрКонтакт.КонтактнаяИнформация);
			КонецЕсли;
		КонецЦикла;
		
		ОбновитьСписокПодчиненныхОбъектов(
			Выборка.Ссылка,
			Выборка.Родитель,
			КонтактыГруппы,
			Справочники.АдреснаяКнига.Избранное,
			ОбъектДоступа);
		
	КонецЦикла;
	Выборка = Неопределено;
	
	// По структуре предприятия
	Выборка = Справочники.СтруктураПредприятия.ВыбратьИерархически();
	Пока Выборка.Следующий() Цикл
		ОбновитьДанныеОбъекта(
			Выборка.Ссылка,
			Выборка.Родитель,
			Справочники.АдреснаяКнига.ПоСтруктуреПредприятия);
		
		ПользователиПодразделения = 
			РаботаСПользователями.ПолучитьПользователейПодразделения(Выборка.Ссылка,,Ложь);
		
		Справочники.АдреснаяКнига.РасширитьСписокПользователейРолями(ПользователиПодразделения);
		
		ОбновитьСписокПодчиненныхОбъектов(
			Выборка.Ссылка,
			Выборка.Родитель,
			ПользователиПодразделения,
			Справочники.АдреснаяКнига.ПоСтруктуреПредприятия);
		
	КонецЦикла;
	Выборка = Неопределено;
	
	// По рабочим группам
	Выборка = Справочники.РабочиеГруппы.ВыбратьИерархически();
	Пока Выборка.Следующий() Цикл
		ОбновитьДанныеОбъекта(
			Выборка.Ссылка,
			Выборка.Родитель,
			Справочники.АдреснаяКнига.ПоРабочимГруппам);
			
		Если Выборка.Ссылка = Справочники.РабочиеГруппы.ВсеПользователи Тогда
			Состав = РаботаСПользователями.ПолучитьВсехПользователей();
			ВключатьТолькоРолиПользователейИзСписка = Ложь;
		Иначе
			Состав = Выборка.Состав.ВыгрузитьКолонку("Пользователь");
			ВключатьТолькоРолиПользователейИзСписка = Истина;
		КонецЕсли;
		
		РасширитьСписокПользователейРолями(Состав, ВключатьТолькоРолиПользователейИзСписка);
		
		ОбновитьСписокПодчиненныхОбъектов(
			Выборка.Ссылка,
			Выборка.Родитель,
			Состав,
			Справочники.АдреснаяКнига.ПоРабочимГруппам);
	КонецЦикла;
	Выборка = Неопределено;
	
	// По мероприятиям
	Выборка = Справочники.ПапкиМероприятий.ВыбратьИерархически();
	Пока Выборка.Следующий() Цикл
		ОбновитьДанныеОбъекта(
			Выборка.Ссылка,
			Выборка.Родитель,
			Справочники.АдреснаяКнига.ПоМероприятиям,
			Выборка.Ссылка);
	КонецЦикла;
	Выборка = Неопределено;
	
	Выборка = Справочники.Мероприятия.ВыбратьИерархически();
	Пока Выборка.Следующий() Цикл
		
		Если Выборка.ЭтоГруппа Тогда
			Продолжить;
		КонецЕсли;
		
		ОбновитьДанныеОбъекта(
			Выборка.Ссылка,
			Выборка.Папка,
			Справочники.АдреснаяКнига.ПоМероприятиям,
			Выборка.Ссылка);
		
		Запрос = Новый Запрос;
		Запрос.Текст = 
			"ВЫБРАТЬ
			|	УчастникиМероприятия.Исполнитель
			|ИЗ
			|	РегистрСведений.УчастникиМероприятия КАК УчастникиМероприятия
			|ГДЕ
			|	УчастникиМероприятия.Мероприятие = &Мероприятие
			|
			|СГРУППИРОВАТЬ ПО
			|	УчастникиМероприятия.Исполнитель";
		Запрос.УстановитьПараметр("Мероприятие", Выборка.Ссылка);
		
		УчастникиМероприятия = Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Исполнитель");
		
		ИндексУчастника = УчастникиМероприятия.Количество() - 1;
		Пока ИндексУчастника >= 0 Цикл
			УчастникМероприятия = УчастникиМероприятия[ИндексУчастника];
			ТипУчастника = ТипЗнч(УчастникМероприятия);
			Если ТипУчастника <> Тип("СправочникСсылка.Пользователи")
				И ТипУчастника <> Тип("СправочникСсылка.РолиИсполнителей") Тогда
				
				УчастникиМероприятия.Удалить(ИндексУчастника);
			КонецЕсли;
			ИндексУчастника = ИндексУчастника - 1;
		КонецЦикла;
		
		ОбновитьСписокПодчиненныхОбъектов(
			Выборка.Ссылка,
			Выборка.Родитель,
			УчастникиМероприятия,
			Справочники.АдреснаяКнига.ПоМероприятиям,
			Выборка.Ссылка);
	КонецЦикла;
	Выборка = Неопределено;
	
	// По проектам
	Выборка = Справочники.ПапкиПроектов.ВыбратьИерархически();
	Пока Выборка.Следующий() Цикл
		ОбновитьДанныеОбъекта(
			Выборка.Ссылка,
			Выборка.Родитель,
			Справочники.АдреснаяКнига.ПоПроектам,
			Выборка.Ссылка);
	КонецЦикла;
	Выборка = Неопределено;
	
	Выборка = Справочники.Проекты.ВыбратьИерархически();
	Пока Выборка.Следующий() Цикл
		
		Если Выборка.ЭтоГруппа Тогда
			Продолжить;
		КонецЕсли;
		
		ОбновитьДанныеОбъекта(
			Выборка.Ссылка,
			Выборка.Папка,
			Справочники.АдреснаяКнига.ПоПроектам,
			Выборка.Ссылка);
		
		ПроектнаяКоманда = Выборка.ПроектнаяКоманда.ВыгрузитьКолонку("Исполнитель");
		
		ИндексУчастникаПроекта = ПроектнаяКоманда.Количество() - 1;
		Пока ИндексУчастникаПроекта >= 0 Цикл
			УчастникПроекта = ПроектнаяКоманда[ИндексУчастникаПроекта];
			ТипУчастника = ТипЗнч(УчастникПроекта);
			Если ТипУчастника <> Тип("СправочникСсылка.Пользователи")
				И ТипУчастника <> Тип("СправочникСсылка.РолиИсполнителей") Тогда
				
				ПроектнаяКоманда.Удалить(ИндексУчастникаПроекта);
			КонецЕсли;
			ИндексУчастникаПроекта = ИндексУчастникаПроекта - 1;
		КонецЦикла;
		
		ОбновитьСписокПодчиненныхОбъектов(
			Выборка.Ссылка,
			Выборка.Родитель,
			ПроектнаяКоманда,
			Справочники.АдреснаяКнига.ПоПроектам,
			Выборка.Ссылка);
		
	КонецЦикла;
	Выборка = Неопределено;
	
	// Роли
	Выборка = Справочники.РолиИсполнителей.Выбрать();
	Пока Выборка.Следующий() Цикл
		ОбновитьДанныеОбъекта(
			Выборка.Ссылка,
			Неопределено,
			Справочники.АдреснаяКнига.Роли);
	КонецЦикла;
	Выборка = Неопределено;
	
	// Контрагенты
	Выборка = Справочники.Контрагенты.ВыбратьИерархически();
	Пока Выборка.Следующий() Цикл
		ОбновитьДанныеОбъекта(
			Выборка.Ссылка,
			Выборка.Родитель,
			Справочники.АдреснаяКнига.Контрагенты,
			Выборка.Ссылка);
	КонецЦикла;
	Выборка = Неопределено;
	
	Выборка = Справочники.КонтактныеЛица.Выбрать();
	Пока Выборка.Следующий() Цикл
		ОбновитьДанныеОбъекта(
			Выборка.Ссылка,
			Выборка.Владелец,
			Справочники.АдреснаяКнига.Контрагенты,
			Выборка.Ссылка);
	КонецЦикла;
	Выборка = Неопределено;
	
	// Личные адресаты
	Выборка = Справочники.ГруппыЛичныхАдресатов.ВыбратьИерархически();
	Пока Выборка.Следующий() Цикл
		ОбновитьДанныеОбъекта(
			Выборка.Ссылка,
			Выборка.Родитель,
			Справочники.АдреснаяКнига.ЛичныеАдресаты,
			Выборка.Пользователь);
	КонецЦикла;
	Выборка = Неопределено;
	
	Выборка = Справочники.ЛичныеАдресаты.Выбрать();
	Пока Выборка.Следующий() Цикл
		ОбновитьДанныеОбъекта(
			Выборка.Ссылка,
			Выборка.Группа,
			Справочники.АдреснаяКнига.ЛичныеАдресаты,
			Выборка.Пользователь);
	КонецЦикла;
	Выборка = Неопределено;
	
	// Организации
	Выборка = Справочники.Организации.Выбрать();
	Пока Выборка.Следующий() Цикл
		ОбновитьДанныеОбъекта(
			Выборка.Ссылка,
			Неопределено,
			Справочники.АдреснаяКнига.Организации);
	КонецЦикла;
	Выборка = Неопределено;	
	
КонецПроцедуры

Процедура ОчиститьАдреснуюКнигу() Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	Выборка = Справочники.АдреснаяКнига.ВыбратьИерархически(Справочники.АдреснаяКнига.ПустаяСсылка(),);
	
	Пока Выборка.Следующий() Цикл
		
		Если Выборка.Предопределенный Тогда
			Продолжить;
		КонецЕсли;
		
		ОбъектАдреснойКниги = Выборка.Ссылка.ПолучитьОбъект();
		ОбъектАдреснойКниги.Удалить();
	КонецЦикла;
	
КонецПроцедуры

Процедура УстановитьПорядокОбъектаВСписке(ЭлементАдреснойКниги, Объект, РодительОбъекта)
	
	Если ЭлементАдреснойКниги.Предопределенный Тогда
		Возврат;
	КонецЕсли;
	
	ПорядокОбъектаВСписке = 99;
	
	ТипОбъекта = ТипЗнч(Объект);
	
	Если ТипОбъекта = Тип("СправочникСсылка.СтруктураПредприятия")
		ИЛИ ТипОбъекта = Тип("СправочникСсылка.РабочиеГруппы")
		ИЛИ ТипОбъекта = Тип("СправочникСсылка.ПапкиМероприятий")
		ИЛИ ТипОбъекта = Тип("СправочникСсылка.ПапкиПроектов")
		ИЛИ ТипОбъекта = Тип("СправочникСсылка.ГруппыКонтактовПользователей")
		ИЛИ ТипОбъекта = Тип("СправочникСсылка.ГруппыЛичныхАдресатов") Тогда
		
		ПорядокОбъектаВСписке = 1;
	ИначеЕсли ТипОбъекта = Тип("СправочникСсылка.Проекты")
		ИЛИ ТипОбъекта = Тип("СправочникСсылка.Мероприятия") Тогда
		ПорядокОбъектаВСписке = 3;
	ИначеЕсли ТипОбъекта = Тип("СправочникСсылка.РолиИсполнителей") Тогда
		ПорядокОбъектаВСписке = 4;
	ИначеЕсли ТипОбъекта = Тип("СправочникСсылка.Пользователи") Тогда
		ПорядокОбъектаВСписке = 5;
	ИначеЕсли ТипОбъекта = Тип("СправочникСсылка.Контрагенты") Тогда
		Если ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Объект, "ЭтоГруппа") Тогда
			ПорядокОбъектаВСписке = 1;
		Иначе
			ПорядокОбъектаВСписке = 2;
		КонецЕсли;
	ИначеЕсли ТипОбъекта = Тип("СправочникСсылка.ЛичныеАдресаты")
		ИЛИ ТипОбъекта = Тип("СправочникСсылка.КонтактныеЛица") Тогда
		ПорядокОбъектаВСписке = 6;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(РодительОбъекта) Тогда
		ТипРодителя = ТипЗнч(РодительОбъекта);
		Если ТипРодителя = Тип("СправочникСсылка.ГруппыКонтактовПользователей") Тогда
			Если ТипОбъекта = Тип("СправочникСсылка.СтруктураПредприятия") Тогда
				ПорядокОбъектаВСписке = 3;
			ИначеЕсли ТипОбъекта = Тип("СправочникСсылка.РабочиеГруппы") Тогда
				ПорядокОбъектаВСписке = 7;
			ИначеЕсли ТипОбъекта = Тип("Строка") Тогда
				СписокФункций = РаботаСАдреснойКнигой.ПолучитьСписокДоступныхФункций();
				ЭтоАвтоподстановка = Ложь;
				Для Инд = 0 По СписокФункций.Количество() - 1 Цикл
					Если СписокФункций[Инд].Представление = Объект Тогда 
						ЭтоАвтоподстановка = Истина;
						Прервать;
					КонецЕсли;
				КонецЦикла;
				Если ЭтоАвтоподстановка Тогда
					ПорядокОбъектаВСписке = 7;
				Иначе
					ПорядокОбъектаВСписке = 3;
				КонецЕсли;
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
	ЭлементАдреснойКниги.ПорядокОбъектаВСписке = ПорядокОбъектаВСписке;
	
КонецПроцедуры

Процедура УстановитьПризнакОтображенияОбъектаВАдреснойКниге(ЭлементАдреснойКниги, Объект)
	
	ТипОбъекта = ТипЗнч(Объект);
	
	Если ЭлементАдреснойКниги.Предопределенный
		ИЛИ ТипОбъекта = Тип("Строка") Тогда
		
		ЭлементАдреснойКниги.ОтображатьВАдреснойКниге = Истина;
		Возврат;
	КонецЕсли;
	
	Если ТипОбъекта = Тип("СправочникСсылка.Пользователи") Тогда
		РеквизитыОбъекта = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(
			Объект, "ПометкаУдаления, Недействителен, Служебный, Ссылка");
			
		Если РеквизитыОбъекта.Ссылка <> Неопределено Тогда
			ОтображатьОбъектВАдреснойКниге = НЕ РеквизитыОбъекта.ПометкаУдаления
				И НЕ РеквизитыОбъекта.Недействителен
				И НЕ РеквизитыОбъекта.Служебный;
		КонецЕсли;
		
	ИначеЕсли ТипОбъекта = Тип("СправочникСсылка.РабочиеГруппы") Тогда
		РеквизитыОбъекта = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(
			Объект, "ПометкаУдаления, Недействительна");
		ОтображатьОбъектВАдреснойКниге = 
			(РеквизитыОбъекта.ПометкаУдаления <> Истина)
			И (РеквизитыОбъекта.Недействительна <> Истина);
		
	Иначе
		ПометкаУдаления = ОбщегоНазначения.
			ЗначениеРеквизитаОбъекта(Объект, "ПометкаУдаления");
		Если ПометкаУдаления <> Неопределено Тогда
			ОтображатьОбъектВАдреснойКниге = НЕ ПометкаУдаления;
		КонецЕсли;
	КонецЕсли;
	
	Если ОтображатьОбъектВАдреснойКниге = Неопределено Тогда
		ОтображатьОбъектВАдреснойКниге = Истина;
	КонецЕсли;
	
	ЭлементАдреснойКниги.ОтображатьВАдреснойКниге = ОтображатьОбъектВАдреснойКниге;
	
КонецПроцедуры

Процедура УстановитьПредставлениеОбъектаВАдреснойКниге(ЭлементАдреснойКниги, Объект)
	
	ДополнительныеОписание = "";
	
	ТипДанныхРодителя = Неопределено;
	Если ЗначениеЗаполнено(ЭлементАдреснойКниги.Родитель) Тогда
		ТипДанныхРодителя = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(
			ЭлементАдреснойКниги.Родитель, "ТипДанныхОбъекта");
	КонецЕсли;
	
	Если ТипЗнч(Объект) = Тип("СправочникСсылка.ГруппыКонтактовПользователей") Тогда
		
		Запрос = Новый Запрос;
		Запрос.Текст = 
			"ВЫБРАТЬ
			|	ГруппыКонтактовПользователейКонтакты.Контакт
			|ИЗ
			|	Справочник.ГруппыКонтактовПользователей.Контакты КАК ГруппыКонтактовПользователейКонтакты
			|ГДЕ
			|	ГруппыКонтактовПользователейКонтакты.Ссылка = &Группа
			|	И ВЫБОР
			|			КОГДА ГруппыКонтактовПользователейКонтакты.Контакт ССЫЛКА Справочник.Пользователи
			|				ТОГДА ЕСТЬNULL(ГруппыКонтактовПользователейКонтакты.Контакт.ПометкаУдаления = ЛОЖЬ, ИСТИНА)
			|						И ЕСТЬNULL(ГруппыКонтактовПользователейКонтакты.Контакт.Служебный = ЛОЖЬ, ИСТИНА)
			|						И ЕСТЬNULL(ГруппыКонтактовПользователейКонтакты.Контакт.Недействителен = ЛОЖЬ, ИСТИНА)
			|			КОГДА ТИПЗНАЧЕНИЯ(ГруппыКонтактовПользователейКонтакты.Контакт) = ТИП(СТРОКА)
			|					ИЛИ ГруппыКонтактовПользователейКонтакты.Контакт = НЕОПРЕДЕЛЕНО
			|				ТОГДА ИСТИНА
			|			ИНАЧЕ ЕСТЬNULL(ГруппыКонтактовПользователейКонтакты.Контакт.ПометкаУдаления = ЛОЖЬ, ИСТИНА)
			|		КОНЕЦ";
			
		Запрос.УстановитьПараметр("Группа", Объект);
		Выборка = Запрос.Выполнить().Выбрать();
		КоличествоПодчиненных = Выборка.Количество();
		ДополнительныеОписание = " (" + КоличествоПодчиненных + ")";
		
	ИначеЕсли ТипЗнч(Объект) = Тип("СправочникСсылка.РабочиеГруппы")
		И (ТипДанныхРодителя = Перечисления.ТипыДанныхАдреснойКниги.ГруппаКонтактовПользователей
			Или ЭлементАдреснойКниги.Родитель = Справочники.АдреснаяКнига.Избранное) Тогда
		
		ДополнительныеОписание = НСтр("ru = ' (Рабочая группа)'");
		
	ИначеЕсли ТипЗнч(Объект) = Тип("СправочникСсылка.СтруктураПредприятия")
		И (ТипДанныхРодителя = Перечисления.ТипыДанныхАдреснойКниги.ГруппаКонтактовПользователей
			Или ЭлементАдреснойКниги.Родитель = Справочники.АдреснаяКнига.Избранное) Тогда
		
		ДополнительныеОписание = НСтр("ru = ' (Подразделение)'");
		
	КонецЕсли;
	
	Если ТипЗнч(Объект) = Тип("СправочникСсылка.Пользователи") Тогда
		ЭлементАдреснойКниги.ПредставлениеОбъекта = 
			ОбщегоНазначенияДокументооборот.ЗначениеРеквизитаОбъектаВПривилегированномРежиме(
				Объект, "ПредставлениеВПерепискеСРангом");
	Иначе
		ЭлементАдреснойКниги.ПредставлениеОбъекта = Строка(Объект) + ДополнительныеОписание;
	КонецЕсли;
	
КонецПроцедуры

Функция ПолучитьСсылкуНаОбъектВАдреснойКниге(
	Объект, Родитель = Неопределено, СсылкаНаРаздел = Неопределено) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	Если Объект = Справочники.РабочиеГруппы.ВсеПользователи Тогда
		Возврат Справочники.АдреснаяКнига.ВсеПользователи;
	ИначеЕсли ТипЗнч(Объект) = Тип("СправочникСсылка.ГруппыКонтактовПользователей")
		И НЕ ЗначениеЗаполнено(Родитель) Тогда
		
		Возврат Справочники.АдреснаяКнига.Избранное;
	КонецЕсли;
	
	Запрос = Новый Запрос;
	
	Если ЗначениеЗаполнено(СсылкаНаРаздел) Тогда
		УсловиеПоРазделу = "	И АдреснаяКнига.Ссылка В ИЕРАРХИИ(&СсылкаНаРаздел)";
		Запрос.УстановитьПараметр("СсылкаНаРаздел", СсылкаНаРаздел);
	Иначе
		УсловиеПоРазделу = "";
	КонецЕсли;
	
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	АдреснаяКнига.Ссылка
		|ИЗ
		|	Справочник.АдреснаяКнига КАК АдреснаяКнига
		|ГДЕ
		|	АдреснаяКнига.Объект = &Объект
		|" + УсловиеПоРазделу;
	Запрос.УстановитьПараметр("Объект", Объект);
	Выборка = Запрос.Выполнить().Выбрать();
	Выборка.Следующий();
	
	Возврат Выборка.Ссылка;
	
КонецФункции

#КонецОбласти

#КонецЕсли
