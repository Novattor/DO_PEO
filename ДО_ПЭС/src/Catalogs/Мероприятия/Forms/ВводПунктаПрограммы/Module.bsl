#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	Реквизиты = 
		"НомерПункта,
		|Исполнитель, 
		|Содержание,
		|ВремяПлан,
		|ВремяФакт,
		|Начало,
		|Окончание,
		|ТребуетПринятияРешения,
		|ВидМероприятия,
		|Комментарий";
		
	ЗаполнитьЗначенияСвойств(ЭтаФорма, Параметры, Реквизиты);
	
	УстановитьПараметрыФункциональныхОпцийФормы(Новый Структура("ВидМероприятия", ВидМероприятия));
	
	Если Не ЗначениеЗаполнено(ВремяПлан) Тогда 
		ВремяПланСтр = "  :  ";
	Иначе	
		ВремяПланСтр = УчетВремениКлиентСервер.ЧислоВСтроку(ВремяПлан);
	КонецЕсли;	
	
	Если Не ЗначениеЗаполнено(ВремяФакт) Тогда 
		ВремяФактСтр = "  :  ";
	Иначе	
		ВремяФактСтр = УчетВремениКлиентСервер.ЧислоВСтроку(ВремяФакт);
	КонецЕсли;	
	
	Если ЗначениеЗаполнено(Начало) Тогда 
		Элементы.Начало.ТолькоПросмотр = Истина;
		Если Не ЗначениеЗаполнено(Окончание) Тогда
			Окончание = Начало;
		КонецЕсли;
	Иначе
		Элементы.Начало.Видимость = Ложь;
		Элементы.Окончание.Видимость = Ложь;
	КонецЕсли;	
	
	Заголовок = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		НСтр("ru = 'Пункт программы №%1'"),
		НомерПункта);
	
КонецПроцедуры

&НаКлиенте
Процедура Записать(Команда)
	
	Если Не ПроверитьЗаполнение() Тогда 
		Возврат;
	КонецЕсли;
	
	Если ВремяПлан = 0 Тогда 
		Начало = '00010101';
		Окончание = '00010101';
	КонецЕсли;	
	
	Результат = Новый Структура( 
		"НомерПункта,
		|Исполнитель, 
		|Содержание,
		|ТребуетПринятияРешения,
		|Начало,
		|Окончание,
		|ВремяПлан,
		|ВремяФакт,
		|Комментарий");
		
	ЗаполнитьЗначенияСвойств(Результат, ЭтаФорма);
	
	Закрыть(Результат);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ИсполнительНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ДанныеВыбораУчастника = СформироватьДанныеВыбораУчастника();
	
	Если ДанныеВыбораУчастника.Количество() > 10 Тогда 
		ОписаниеОповещения = Новый ОписаниеОповещения("ИсполнительНачалоВыбораЗавершение", ЭтотОбъект);
		ДанныеВыбораУчастника.ПоказатьВыборЭлемента(ОписаниеОповещения, "Укажите ответственного", Исполнитель);
	Иначе
		ДанныеВыбора = ДанныеВыбораУчастника;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ИсполнительНачалоВыбораЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Исполнитель = Результат.Значение;
	
КонецПроцедуры

&НаКлиенте
Процедура ИсполнительАвтоПодбор(Элемент, Текст, ДанныеВыбора, Ожидание, СтандартнаяОбработка)
	
	Если ЗначениеЗаполнено(Текст) Тогда
		СтандартнаяОбработка = Ложь;
		ДанныеВыбора = СформироватьДанныеВыбораУчастника(Текст);
	Иначе
		ИсполнительНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ИсполнительОкончаниеВводаТекста(Элемент, Текст, ДанныеВыбора, СтандартнаяОбработка)
	
	Если ЗначениеЗаполнено(Текст) Тогда 
		ДанныеВыбораУчастника = СформироватьДанныеВыбораУчастника(Текст);
		Если ДанныеВыбораУчастника.Количество() = 1 Тогда 
			Исполнитель = ДанныеВыбораУчастника[0].Значение;
		Иначе
			СтандартнаяОбработка = Ложь;
			ДанныеВыбора = ДанныеВыбораУчастника;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВремяПланСтрПриИзменении(Элемент)
	
	Если Не УчетВремениКлиентСервер.ПроверитьФормат(ВремяПланСтр) Тогда
		ВремяПланСтр = "  :  ";
	КонецЕсли;
	ВремяПлан = УчетВремениКлиентСервер.ЧислоИзСтроки(ВремяПланСтр);
	
	Если ЗначениеЗаполнено(Начало) Тогда 
		Окончание = Начало + ВремяПлан;
	КонецЕсли;	
	
КонецПроцедуры

&НаКлиенте
Процедура ВремяПланСтрНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ДанныеВыбора = Элемент.СписокВыбора;
	
КонецПроцедуры

&НаКлиенте
Процедура ВремяФактСтрПриИзменении(Элемент)
	
	Если Не УчетВремениКлиентСервер.ПроверитьФормат(ВремяФактСтр) Тогда
		ВремяФактСтр = "  :  ";
	КонецЕсли;
	ВремяФакт = УчетВремениКлиентСервер.ЧислоИзСтроки(ВремяФактСтр);
	
КонецПроцедуры

&НаКлиенте
Процедура ВремяФактСтрНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ДанныеВыбора = Элемент.СписокВыбора;
	
КонецПроцедуры

&НаКлиенте
Процедура НачалоПриИзменении(Элемент)
	
	Окончание = Начало + ВремяПлан;
	
КонецПроцедуры

&НаКлиенте
Процедура НачалоНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
КонецПроцедуры

&НаКлиенте
Процедура ОкончаниеПриИзменении(Элемент)
	
	Если Окончание < Начало Тогда 
		Окончание = Начало;
	КонецЕсли;	
	
	ВремяПлан = (Окончание - Начало);
	ВремяПланСтр = УчетВремениКлиентСервер.ЧислоВСтроку(ВремяПлан);
	
КонецПроцедуры

&НаКлиенте
Процедура ОкончаниеНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Функция СформироватьДанныеВыбораУчастника(Текст = "")
	
	Участники = ЭтаФорма.ВладелецФормы.Участники;
	
	ДанныеВыбора = Новый СписокЗначений;
	Для Каждого Строка Из Участники Цикл
		Если Не ЗначениеЗаполнено(Строка.Исполнитель) Тогда 
			Продолжить;
		КонецЕсли;
		Если Текст <> "" И НРег(Лев(Строка.Исполнитель, СтрДлина(Текст))) <> НРег(Текст) Тогда 
			Продолжить;
		КонецЕсли;
		ДанныеВыбора.Добавить(Строка.Исполнитель, Строка(Строка.Исполнитель));
	КонецЦикла;	
	
	Возврат ДанныеВыбора;
	
КонецФункции

#КонецОбласти