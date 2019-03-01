
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Перем ТипОбъектов;
	
	ЗаписатьКатегорииПриОК = Параметры.ЗаписатьКатегорииПриОК;
	
	Если ЗаписатьКатегорииПриОК Тогда
		Если ТипЗнч(Параметры.ОбъектыДляКатегорий) = Тип("Массив") Тогда 
			Если Параметры.ОбъектыДляКатегорий.Количество() = 1 Тогда
				Элементы.ФормаУстановитьСЗаменой.Видимость = Истина;
				Элементы.ФормаУстановитьДобавлением.Видимость = Ложь;
				Элементы.ФормаКомандаГотово.Видимость = Ложь;
				Элементы.ФормаУстановитьСЗаменой.КнопкаПоУмолчанию = Истина;
				
				Элементы.ФормаУстановитьСЗаменой.Заголовок = НСтр("ru = 'Установить'");
			Иначе				
				Элементы.ФормаУстановитьСЗаменой.Видимость = Истина;
				Элементы.ФормаУстановитьДобавлением.Видимость = Истина;
				Элементы.ФормаКомандаГотово.Видимость = Ложь;
				Элементы.ФормаУстановитьСЗаменой.КнопкаПоУмолчанию = Истина;
				Заголовок = НСтр("ru = 'Установка категорий'");
				АвтоЗаголовок = Ложь;
			КонецЕсли;
		КонецЕсли;
	Иначе
		Элементы.ФормаУстановитьСЗаменой.Видимость = Ложь;
		Элементы.ФормаУстановитьДобавлением.Видимость = Ложь;
		Элементы.ФормаКомандаГотово.Видимость = Истина;
		Элементы.ФормаКомандаГотово.КнопкаПоУмолчанию = Истина;
		Заголовок = НСтр("ru = 'Подбор категорий'");
		АвтоЗаголовок = Ложь;
	КонецЕсли;
	
	Если НЕ Параметры.Свойство("СписокКатегорий")
		И ТипЗнч(Параметры.ОбъектыДляКатегорий) = Тип("Массив") 
		И Параметры.ОбъектыДляКатегорий.Количество() = 1 Тогда
		
		Объект = Параметры.ОбъектыДляКатегорий[0]; 
		ТипОбъектов = Перечисления.ТипыОбъектов[Объект.Метаданные().Имя];
		
		ИнформацияОбОбъектеПодбора = Объект.Наименование;
		Если ЗаписатьКатегорииПриОК Тогда
			Заголовок = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Установка категорий: ""%1""'"),
				ИнформацияОбОбъектеПодбора);
			АвтоЗаголовок = Ложь;
		Иначе
			Заголовок = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Подбор категорий: ""%1""'"),
				ИнформацияОбОбъектеПодбора);
			АвтоЗаголовок = Ложь;
		КонецЕсли;
	КонецЕсли;
	
	ПостроитьДерево();
	
	Если НЕ Параметры.Свойство("СписокКатегорий") Тогда
		Если ТипЗнч(Параметры.ОбъектыДляКатегорий) = Тип("Массив")
			И Параметры.ОбъектыДляКатегорий.Количество() = 1 Тогда
			МассивКатегорий = РаботаСКатегориямиДанных.ПолучитьСписокКатегорийОбъекта(Параметры.ОбъектыДляКатегорий[0]);
			Для Каждого ВыбраннаяКатегория Из МассивКатегорий Цикл 
				Строка = ВыбранныеКатегории.Добавить();
				Строка.Ссылка = ВыбраннаяКатегория.Категория;
				Строка.ПолноеНаименование = ВыбраннаяКатегория.ПолноеНаименование;
			КонецЦикла;
		КонецЕсли;
	Иначе
		Для Каждого ВыбраннаяКатегория Из Параметры.СписокКатегорий Цикл 
			Строка = ВыбранныеКатегории.Добавить();
			Строка.Ссылка = ВыбраннаяКатегория.Значение;
			Строка.ПолноеНаименование = РаботаСКатегориямиДанных.ПолучитьПолныйПутьКатегорииДанных(ВыбраннаяКатегория.Значение);
		КонецЦикла;
	КонецЕсли;
	
	Если НЕ Параметры.Свойство("СписокКатегорий")
		И ТипЗнч(Параметры.ОбъектыДляКатегорий) = Тип("Массив") Тогда
		Для Каждого Объект Из Параметры.ОбъектыДляКатегорий Цикл
			ОбъектыДляКатегоризации.Добавить(Объект);
		КонецЦикла;
	КонецЕсли;
	
	Если Параметры.Свойство("ТолькоОбщиеКатегории") Тогда
		ПоказатьТолькоОбщиеКатегории(Параметры.ТолькоОбщиеКатегории);
	Иначе
		ПоказатьТолькоОбщиеКатегории(Ложь);	
	КонецЕсли;
	
	Параметры.Свойство("ТипОбъектаВладельца", ТипОбъектаВладельцаСпискаКатегорий);
	
	ВыбранныеКатегорииПриОткрытии = ХранилищеНастроекДанныхФорм.Загрузить("ФормаПодбораКатегорий", "ПоследниеВыбранныеКатегории");
	Если ВыбранныеКатегорииПриОткрытии <> Неопределено Тогда
		ПоследниеВыбранныеКатегории = ВыбранныеКатегорииПриОткрытии;
	КонецЕсли;
	Элементы.ГруппаПоследниеВыбранные.Заголовок = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		НСтр("ru = 'Недавно выбранные (%1)'"),
		Строка(ПоследниеВыбранныеКатегории.Количество()));
		
КонецПроцедуры

&НаСервере
Процедура ПоказатьТолькоОбщиеКатегории(Показать)
	
	ЭтаФорма.УсловноеОформление.Элементы[2].Использование = Показать;
	
КонецПроцедуры

&НаСервере
Процедура ПостроитьДерево()
		
	ДеревоКатегорийОбъект = РеквизитФормыВЗначение("ДеревоКатегорий");
	ДеревоКатегорийОбъект = РаботаСКатегориямиДанных.ПостроитьДеревоКатегорий(ДеревоКатегорийОбъект, , Истина, , Ложь, Ложь);
	ЗначениеВРеквизитФормы(ДеревоКатегорийОбъект, "ДеревоКатегорий");
	
КонецПроцедуры

&НаКлиенте
Процедура ДобавитьВыделенныеКатегорииКСпискуВыбранных()
	
	СписокНедавнихКатегорийМенялся = Истина;
	
	Если Элементы.ГруппаКатегорииДляВыбора.ТекущаяСтраница = Элементы.ГруппаВсеКатегории Тогда
		Для Каждого ВыделеннаяСтрока Из Элементы.ДеревоКатегорий.ВыделенныеСтроки Цикл
			Категория = ДеревоКатегорий.НайтиПоИдентификатору(ВыделеннаяСтрока);
			Отбор = Новый Структура("Ссылка", Категория.Ссылка);
			НайденныеСтроки = ВыбранныеКатегории.НайтиСтроки(Отбор);
			Если НайденныеСтроки.Количество() = 0 Тогда
				Строка = ВыбранныеКатегории.Добавить();
				Строка.Ссылка = Категория.Ссылка;
				Строка.ПолноеНаименование = Категория.ПолноеНаименование;
				
				//добавление выбранной категории в список недавних
				НайденныйЭлемент = ПоследниеВыбранныеКатегории.НайтиПоЗначению(Категория.Ссылка);
				Если НайденныйЭлемент = Неопределено Тогда
					Если ПоследниеВыбранныеКатегории.Количество() >= 10 Тогда
						Пока ПоследниеВыбранныеКатегории.Количество() >= 10 Цикл
							ПоследниеВыбранныеКатегории.Удалить(9);
						КонецЦикла;
					КонецЕсли;
					ПоследниеВыбранныеКатегории.Вставить(0, Категория.Ссылка, Категория.ПолноеНаименование);
				Иначе
					Индекс = ПоследниеВыбранныеКатегории.Индекс(НайденныйЭлемент);
					ПоследниеВыбранныеКатегории.Сдвинуть(НайденныйЭлемент, -1*Индекс);
				КонецЕсли;
			КонецЕсли;
		КонецЦикла;
	ИначеЕсли Элементы.ГруппаКатегорииДляВыбора.ТекущаяСтраница = Элементы.ГруппаПоследниеВыбранные Тогда
		Для Каждого ВыделеннаяСтрока Из Элементы.ПоследниеВыбранныеКатегории.ВыделенныеСтроки Цикл
			Категория = ПоследниеВыбранныеКатегории.НайтиПоИдентификатору(ВыделеннаяСтрока);
			Отбор = Новый Структура("Ссылка", Категория.Значение);
			НайденныеСтроки = ВыбранныеКатегории.НайтиСтроки(Отбор);
			Если НайденныеСтроки.Количество() = 0 Тогда
				Строка = ВыбранныеКатегории.Добавить();
				Строка.Ссылка = Категория.Значение;
				Строка.ПолноеНаименование = Категория.Представление;
				
				//добавление выбранной категории в список недавних
				НайденныйЭлемент = ПоследниеВыбранныеКатегории.НайтиПоЗначению(Категория.Значение);
				Если НайденныйЭлемент = Неопределено Тогда
					Если ПоследниеВыбранныеКатегории.Количество() >= 10 Тогда
						Пока ПоследниеВыбранныеКатегории.Количество() >= 10 Цикл
							ПоследниеВыбранныеКатегории.Удалить(9);
						КонецЦикла;
					КонецЕсли;
					ПоследниеВыбранныеКатегории.Вставить(0, Категория.Значение, Категория.ПолноеНаименование);
				Иначе
					Индекс = ПоследниеВыбранныеКатегории.Индекс(НайденныйЭлемент);
					ПоследниеВыбранныеКатегории.Сдвинуть(НайденныйЭлемент, -1*Индекс);
				КонецЕсли;
				
			КонецЕсли;
			
		КонецЦикла;
	КонецЕсли;
	
	Элементы.ГруппаПоследниеВыбранные.Заголовок = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		НСтр("ru = 'Недавно выбранные (%1)'"),
		Строка(ПоследниеВыбранныеКатегории.Количество()));		
	
КонецПроцедуры

&НаКлиенте
Процедура ДобавитьКСпискуВыбранных(Команда)
	
	ДобавитьВыделенныеКатегорииКСпискуВыбранных();
		
КонецПроцедуры

&НаКлиенте
Процедура ЗакрытьФорму(Команда)
	
	ВозвращаемыеКатегории = Новый Массив();
	Для Каждого Строка Из ВыбранныеКатегории Цикл
		ДанныеОКатегории = Новый Структура("ПолноеНаименование, Значение", Строка.ПолноеНаименование, Строка.Ссылка);
		ВозвращаемыеКатегории.Добавить(ДанныеОКатегории);
	КонецЦикла;
		
	Если Команда.Имя = "УстановитьСЗаменой" Тогда
		
		ЗаписатьКатегорииУОбъектов(ОбъектыДляКатегоризации,ВозвращаемыеКатегории, Истина); 
		Закрыть(ВозвращаемыеКатегории.Количество());
		
	ИначеЕсли Команда.Имя = "УстановитьДобавлением" Тогда
		
		ЗаписатьКатегорииУОбъектов(ОбъектыДляКатегоризации,ВозвращаемыеКатегории, Ложь); 
		Закрыть(ВозвращаемыеКатегории.Количество());
		
	ИначеЕсли Команда.Имя = "КомандаГотово" Тогда
		
		Закрыть(ВозвращаемыеКатегории);
		
	ИначеЕсли Команда.Имя = "Отмена" Тогда
		
		Закрыть(Неопределено);
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ЗаписатьКатегорииУОбъектов(Объекты, СписокКатегорий, Замена)
	
	НачатьТранзакцию();
	Попытка
		Для Каждого Объект Из Объекты Цикл
			Если Не Замена Тогда
				Для Каждого Категория Из СписокКатегорий Цикл
					РаботаСКатегориямиДанных.УстановитьКатегориюУОбъекта(
						ПользователиКлиентСервер.ТекущийПользователь(),
						Категория.Значение, 
						Объект.Значение);
				КонецЦикла;
			Иначе
				РаботаСКатегориямиДанных.ЗаписатьСписокКатегорийУОбъекта(СписокКатегорий, Объект.Значение);
			КонецЕсли;
		КонецЦикла;
		ЗафиксироватьТранзакцию();
	Исключение
		ОтменитьТранзакцию();
		ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'При попытке присвоить категории объекту ""%1"" произошла ошибка%2""%3""%4Групповая операция присвоения категорий отменена.'"),
			Объект.Значение.Наименование,
			Символы.ПС,
			ИнформацияОбОшибке(),
			Символы.ПС);
		ВызватьИсключение(ТекстСообщения);
	КонецПопытки;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьДеревья()
	
	СписокРаскрытыхКатегорий.Очистить();
	РаботаСКатегориямиДанныхКлиент.ПолучитьМассивРаскрытыхКатегорий(Элементы.ДеревоКатегорий, ДеревоКатегорий.ПолучитьЭлементы(), СписокРаскрытыхКатегорий);
	Если Элементы.ДеревоКатегорий.ТекущиеДанные <> Неопределено Тогда
		ТекущаяКатегория = Элементы.ДеревоКатегорий.ТекущиеДанные.Ссылка;
	КонецЕсли;
	
	ПостроитьДерево();
	
	РаботаСКатегориямиДанныхКлиент.УстановитьРазвернутостьЭлементовДерева(Элементы.ДеревоКатегорий, ДеревоКатегорий, СписокРаскрытыхКатегорий);
	РаботаСКатегориямиДанныхКлиентСервер.УстановитьТекущуюКатегориюВДеревеПоСсылке(Элементы.ДеревоКатегорий, ДеревоКатегорий, ТекущаяКатегория);
		
КонецПроцедуры

&НаКлиенте
Процедура ДеревоПередНачаломИзменения(Элемент, Отказ)
	
	ТекущаяКатегория = Элемент.ТекущиеДанные.Ссылка;
	Если Элемент.ТекущийЭлемент.Вид <> ВидПоляФормы.ПолеФлажка Тогда	
		ОписаниеОповещения = Новый ОписаниеОповещения(
			"ДеревоПередНачаломИзмененияПродолжение",
			ЭтотОбъект,
			Новый Структура("ТекущаяКатегория", ТекущаяКатегория));

		ПараметрыФормы = Новый Структура("Ключ", ТекущаяКатегория);
		ОткрытьФорму("Справочник.КатегорииДанных.ФормаОбъекта", ПараметрыФормы, Элемент,,,,
			ОписаниеОповещения, РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
		Отказ = Истина;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ДеревоПередНачаломИзмененияПродолжение(Результат, Параметры) Экспорт 

	ОбновитьДеревья();
	ОбновитьСписокВыбранныхКатегорий(Параметры.ТекущаяКатегория);
		
КонецПроцедуры
	
&НаКлиенте
Процедура ОбновитьСписокВыбранныхКатегорий(ТекущаяКатегория)
	
	Для Каждого ВыбраннаяКатегория Из ВыбранныеКатегории Цикл
		Если ВыбраннаяКатегория.Ссылка = ТекущаяКатегория Тогда
			ВыбраннаяКатегория.ПолноеНаименование = РаботаСКатегориямиДанных.ПолучитьПолныйПутьКатегорииДанных(ТекущаяКатегория);
			Прервать;
		КонецЕсли;
	КонецЦикла;
		
КонецПроцедуры

&НаКлиенте
Процедура УдалитьКатегорииИзСпискаВыбранных(Команда)
	
	МассивСтрокДляУдаления = Новый Массив;
	Для Каждого ВыделеннаяСтрока Из Элементы.ВыбранныеКатегории.ВыделенныеСтроки Цикл
		МассивСтрокДляУдаления.Добавить(ВыбранныеКатегории.НайтиПоИдентификатору(ВыделеннаяСтрока));
	КонецЦикла;
	Для Каждого СтрокаДляУдаления Из МассивСтрокДляУдаления Цикл
		ВыбранныеКатегории.Удалить(СтрокаДляУдаления);
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ВыбранныеКатегорииПеретаскивание(Элемент, ПараметрыПеретаскивания, СтандартнаяОбработка, Строка, Поле)
	
	ДобавитьВыделенныеКатегорииКСпискуВыбранных();
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "РедактироваласьКатегория"
		И (Источник.ВладелецФормы = Неопределено
		ИЛИ Источник.ВладелецФормы.Имя <> "ДеревоКатегорий") Тогда
		ОбновитьДеревья();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ДеревоКатегорийВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ДобавитьВыделенныеКатегорииКСпискуВыбранных();
	
КонецПроцедуры

&НаКлиенте
Процедура ДеревоКатегорийПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа)
	
	Отказ = Истина;
	ПараметрыФормы = Новый Структура();
	ТекущаяКатегория = ?(Элементы.ДеревоКатегорий.ТекущиеДанные = Неопределено, Неопределено, Элементы.ДеревоКатегорий.ТекущиеДанные.Ссылка);
	ТекущаяСтрока = Элементы.ДеревоКатегорий.ТекущаяСтрока;
	Если НЕ Копирование Тогда
		ЗначенияЗаполнения = Новый Структура;
		ЗначенияЗаполнения.Вставить("Родитель", ТекущаяКатегория);
	    ЗначенияЗаполнения.Вставить("Персональная", Истина);		
		ПараметрыФормы.Вставить("ЗначенияЗаполнения", ЗначенияЗаполнения);
	Иначе
		ПараметрыФормы.Вставить("ЗначениеКопирования", ТекущаяКатегория);	
   	КонецЕсли;
	ОткрытьФорму("Справочник.КатегорииДанных.ФормаОбъекта", ПараметрыФормы, Элемент);

КонецПроцедуры

&НаКлиенте
Процедура ДеревоКатегорийПередНачаломИзменения(Элемент, Отказ)
	
	ДеревоПередНачаломИзменения(Элемент, Отказ);
	
КонецПроцедуры

&НаКлиенте
Процедура ДеревоКатегорийПередУдалением(Элемент, Отказ)
	
	Отказ = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура ДеревоКатегорийОбработкаЗаписиНового(НовыйОбъект, Источник, СтандартнаяОбработка)
	
	ОбновитьДеревья();
	СтандартнаяОбработка = Ложь;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)
	
	Если ОбщегоНазначенияДокументооборотКлиент.ПриЗакрытии(ЗавершениеРаботы) Тогда
		Возврат;
	КонецЕсли;
	
	Если Не СписокНедавнихКатегорийМенялся Тогда
		Возврат;
	КонецЕсли;
	ПриЗакрытииСервер();
	
КонецПроцедуры

&НаСервере
Процедура ПриЗакрытииСервер()
	
	ХранилищеНастроекДанныхФорм.Сохранить("ФормаПодбораКатегорий", "ПоследниеВыбранныеКатегории", ПоследниеВыбранныеКатегории);
	
КонецПроцедуры

&НаКлиенте
Процедура ПоследниеВыбранныеКатегорииВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ДобавитьВыделенныеКатегорииКСпискуВыбранных();
	
КонецПроцедуры

&НаКлиенте
Процедура ВыбранныеКатегорииВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	УдалитьКатегорииИзСпискаВыбранных(Неопределено);	
КонецПроцедуры

