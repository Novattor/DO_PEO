#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ПротоколированиеРаботыПользователей.ЗаписатьОткрытие(Объект.Ссылка);
	
	Если Объект.Ссылка.Пустая() Тогда
		Если ЗначениеЗаполнено(Объект.НоменклатураДел) Тогда 
			ЗаполнитьРеквизиты();
		Иначе
			Объект.НомерТома = 1;
		КонецЕсли;	
	КонецЕсли;	
	
	ДелоУничтожено = Ложь;
	
	Если Не Объект.Ссылка.Пустая() Тогда
		МестоХраненияПриОткрытии = Объект.МестоХраненияДел;
		
		Запрос = Новый Запрос;
		Запрос.Текст = 
		"ВЫБРАТЬ
		|	СостоянияДелХраненияДокументов.Состояние КАК Состояние,
		|	СостоянияДелХраненияДокументов.Период КАК Период,
		|	СостоянияДелХраненияДокументов.Регистратор КАК Регистратор
		|ИЗ
		|	РегистрСведений.СостоянияДелХраненияДокументов.СрезПоследних(, ДелоХраненияДокументов = &Дело) КАК СостоянияДелХраненияДокументов";
		Запрос.УстановитьПараметр("Дело", Объект.Ссылка);
		
		Результат = Запрос.Выполнить();
		Если Не Результат.Пустой() Тогда 
			Выборка = Результат.Выбрать();
			Выборка.Следующий();
			Регистратор = Выборка.Регистратор;
			
			Если Выборка.Состояние = Перечисления.СостоянияДелХраненияДокументов.ПереданоВАрхив Тогда 
				Состояние = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
					НСтр("ru = 'Дело передано в архив %1'"), Формат(Выборка.Период, "ДФ=dd.MM.yyyy"));
				Элементы.ДелоЗакрыто.Доступность = Ложь;
			ИначеЕсли Выборка.Состояние = Перечисления.СостоянияДелХраненияДокументов.Уничтожено Тогда 
				Состояние = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
					НСтр("ru = 'Дело уничтожено %1'"), Формат(Выборка.Период, "ДФ=dd.MM.yyyy"));
				Элементы.ДелоЗакрыто.Доступность = Ложь;
				ДелоУничтожено = Истина;
			КонецЕсли;
		КонецЕсли;	
	КонецЕсли;	
	
	Если Параметры.Свойство("МестоХранения") И ЗначениеЗаполнено(Параметры.МестоХранения) Тогда
		Объект.МестоХраненияДел = Параметры.МестоХранения;
	КонецЕсли;
	
	СостояниеДела = ЗначениеЗаполнено(Состояние);
	Элементы.Состояние.Видимость = СостояниеДела;
	
	Элементы.ГруппаМестоХранения.Видимость = Не ДелоУничтожено;
	Элементы.ДекорацияМестаХранения.Видимость = ДелоУничтожено;
	
	//Планы помещений
	ИспользоватьСхемыПомещений = ПолучитьФункциональнуюОпцию("ИспользоватьСхемыПомещений");
	МестоХраненияТекст = ДелопроизводствоКлиентСервер.ПолучитьПолныйПутьКМестуХранения(
		Объект.МестоХраненияДел, ИспользоватьСхемыПомещений);
		
	Если Не ПравоДоступа("Изменение", Метаданные.Справочники.ДелаХраненияДокументов) Тогда 
		Элементы.МестоХраненияТекст.ТолькоПросмотр = Истина;
		Элементы.МестоХраненияТекст.КнопкаВыбора = Ложь;
	КонецЕсли;
	Если ПолучитьФункциональнуюОпцию("ОбязательныйУчетПоМестамХранения") Тогда 
		Элементы.МестоХраненияТекст.АвтоОтметкаНезаполненного = Истина;
	КонецЕсли;
	
	Если ИспользоватьСхемыПомещений И ЗначениеЗаполнено(Объект.МестоХраненияДел) Тогда
		ПланПомещения = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Объект.МестоХраненияДел, "ТерриторияПомещение");
		
		Если ЗначениеЗаполнено(ПланПомещения) Тогда 
			Элементы.ПосмотретьНаСхеме.Видимость = Истина;
		Иначе 
			Элементы.ПосмотретьНаСхеме.Видимость = Ложь;
		КонецЕсли;
	Иначе 
		ПланПомещения = Неопределено;
		Элементы.ПосмотретьНаСхеме.Видимость = Ложь;
	КонецЕсли;
	
	// Обработчик подсистемы "Дополнительные отчеты и обработки"
	ДополнительныеОтчетыИОбработки.ПриСозданииНаСервере(ЭтаФорма);
	
	РаботаСПоследнимиОбъектами.ЗаписатьОбращениеКОбъекту(Объект.Ссылка);
	
	// Инструкции
	ПоказыватьИнструкции = ПолучитьФункциональнуюОпцию("ИспользоватьИнструкции");
	ПолучитьИнструкции();
	
	// СтандартныеПодсистемы.Печать
	УправлениеПечатью.ПриСозданииНаСервере(ЭтаФорма);
	// Конец СтандартныеПодсистемы.Печать
	

	// СтандартныеПодсистемы.БазоваяФункциональность
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.БазоваяФункциональность
	
	ТекущаяДатаНачала = Объект.ДатаНачала;
	ТекущаяДатаОкончания = Объект.ДатаОкончания;
	
	Если РольДоступна("ПолныеПрава") Или РольДоступна("ДобавлениеИзменениеНСИ") Тогда 
		Элементы.ГруппаОтноситсяКНоменклатуреДел.Видимость = Истина;
	Иначе 
		Элементы.ГруппаОтноситсяКНоменклатуреДел.Видимость = Ложь;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Оповестить("ОбновитьСписокПоследних");
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "ИзмененаНоменклатураДел" И Параметр = Объект.НоменклатураДел Тогда 
		Прочитать();
	КонецЕсли;	
	
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	ПараметрыЗаписи.Вставить("ЭтоНовыйОбъект", НЕ ЗначениеЗаполнено(ТекущийОбъект.Ссылка));
	ПараметрыЗаписи.Вставить("МестоХранения", МестоХраненияПриОткрытии);
		
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	ПротоколированиеРаботыПользователей.ЗаписатьСоздание(Объект.Ссылка, ПараметрыЗаписи.ЭтоНовыйОбъект);
	ПротоколированиеРаботыПользователей.ЗаписатьИзменение(Объект.Ссылка);
	
	Если ПараметрыЗаписи.Свойство("ЭтоНовыйОбъект") И ПараметрыЗаписи.ЭтоНовыйОбъект = Истина Тогда
		РаботаСПоследнимиОбъектами.ЗаписатьОбращениеКОбъекту(Объект.Ссылка);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	Если ПараметрыЗаписи.Свойство("МестоХранения") 
		И ПараметрыЗаписи.МестоХранения <> Объект.МестоХраненияДел Тогда
		Оповестить("ИзменилосьМестоХраненияДела");
		МестоХраненияПриОткрытии = Объект.МестоХраненияДел;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПриЗагрузкеДанныхИзНастроекНаСервере(Настройки)
	
	Если Настройки["ПоказыватьИнструкции"] <> Неопределено
		И ПолучитьФункциональнуюОпцию("ИспользоватьИнструкции") Тогда
		ПолучитьИнструкции();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура МестоХраненияТекстПриИзменении(Элемент)
	
	Если Не ЗначениеЗаполнено(МестоХраненияТекст) Тогда 
		Объект.МестоХраненияДел = Неопределено;
		МестоХраненияТекст = Неопределено;
	КонецЕсли;
	
	Если ИспользоватьСхемыПомещений И ЗначениеЗаполнено(Объект.МестоХраненияДел) Тогда
		ПланПомещения = ОбщегоНазначенияДокументооборотВызовСервера.ЗначениеРеквизитаОбъекта(
			Объект.МестоХраненияДел, "ТерриторияПомещение");
		
		Если ЗначениеЗаполнено(ПланПомещения) Тогда 
			Элементы.ПосмотретьНаСхеме.Видимость = Истина;
		Иначе 
			Элементы.ПосмотретьНаСхеме.Видимость = Ложь;
		КонецЕсли;
	Иначе 
		ПланПомещения = Неопределено;
		Элементы.ПосмотретьНаСхеме.Видимость = Ложь;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура МестоХраненияТекстНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("ТекущаяСтрока", Объект.МестоХраненияДел);
	ПараметрыФормы.Вставить("Подразделение", Объект.Подразделение);
	ПараметрыФормы.Вставить("Организация", Объект.Организация);
	
	ОткрытьФорму("Справочник.МестаХраненияДел.ФормаВыбора", ПараметрыФормы, 
		Элемент,,,,, РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

&НаКлиенте
Процедура МестоХраненияТекстОчистка(Элемент, СтандартнаяОбработка)
	
	Объект.МестоХраненияДел = Неопределено;
	МестоХраненияТекст = Неопределено;
	
КонецПроцедуры

&НаКлиенте
Процедура МестоХраненияТекстОткрытие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Если ЗначениеЗаполнено(МестоХраненияТекст) Тогда
		ПоказатьЗначение(, Объект.МестоХраненияДел);
	КонецЕсли;	
	
КонецПроцедуры

&НаКлиенте
Процедура МестоХраненияТекстОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	Если ТипЗнч(ВыбранноеЗначение) = Тип("СправочникСсылка.МестаХраненияДел") Тогда 
		
		СтандартнаяОбработка = Ложь;
		Объект.МестоХраненияДел = ВыбранноеЗначение;
		Модифицированность = Истина;
		
		Если ЗначениеЗаполнено(Объект.МестоХраненияДел) Тогда 
			МестоХраненияТекст = ДелопроизводствоКлиентСервер.ПолучитьПолныйПутьКМестуХранения(
				Объект.МестоХраненияДел, ИспользоватьСхемыПомещений);
		Иначе 
			МестоХраненияТекст = Неопределено;
		КонецЕсли;
		
		Если ИспользоватьСхемыПомещений И ЗначениеЗаполнено(Объект.МестоХраненияДел) Тогда
			ПланПомещения = ОбщегоНазначенияДокументооборотВызовСервера.ЗначениеРеквизитаОбъекта(
				Объект.МестоХраненияДел, "ТерриторияПомещение");
			
			Если ЗначениеЗаполнено(ПланПомещения) Тогда 
				Элементы.ПосмотретьНаСхеме.Видимость = Истина;
			Иначе 
				Элементы.ПосмотретьНаСхеме.Видимость = Ложь;
			КонецЕсли;
		Иначе 
			ПланПомещения = Неопределено;
			Элементы.ПосмотретьНаСхеме.Видимость = Ложь;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура МестоХраненияТекстАвтоПодбор(Элемент, Текст, ДанныеВыбора, Ожидание, СтандартнаяОбработка)
	
	Если ЗначениеЗаполнено(Текст) Тогда
		СтандартнаяОбработка = Ложь;
		ДанныеВыбора = Делопроизводство.СформироватьДанныеВыбораМестХранения(
			Текст, Объект.Организация, Объект.Подразделение);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура МестоХраненияТекстОкончаниеВводаТекста(Элемент, Текст, ДанныеВыбора, СтандартнаяОбработка)
	
	Если ЗначениеЗаполнено(Текст) Тогда
		СтандартнаяОбработка = Ложь;
		ДанныеВыбора = Делопроизводство.СформироватьДанныеВыбораМестХранения(
			Текст, Объект.Организация, Объект.Подразделение);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура НоменклатураДелПриИзменении(Элемент)
	
	ЗаполнитьРеквизиты();
	
КонецПроцедуры

&НаКлиенте
Процедура НоменклатураДелНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("ТекущаяСтрока", Объект.НоменклатураДел);
	
	Если ЗначениеЗаполнено(Объект.ДатаНачала) Тогда
		ПараметрыФормы.Вставить("Год", Год(Объект.ДатаНачала));
	Иначе
		ПараметрыФормы.Вставить("Год", Год(ТекущаяДата()));
	КонецЕсли;	
	ОткрытьФорму("Справочник.НоменклатураДел.ФормаВыбора", ПараметрыФормы, Элемент);
	
КонецПроцедуры

&НаКлиенте
Процедура ДелоЗакрытоПриИзменении(Элемент)
	
	Если Объект.ДелоЗакрыто Тогда 
		ЗакрытьДело();
	КонецЕсли;	
	
КонецПроцедуры

&НаКлиенте
Процедура СостояниеНажатие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ПоказатьЗначение(, Регистратор);
	
КонецПроцедуры

&НаКлиенте
Процедура ДатаОкончанияПриИзменении(Элемент)
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ПериодПриИзменении", ЭтаФорма,
		Новый Структура("ДатаНачала", Ложь));
	
	Если Не Объект.Ссылка.Пустая() И ЗначениеЗаполнено(Объект.ДатаОкончания)
		И ЕстьДокументыЗаПериодом(Объект.Ссылка, Объект.ДатаОкончания) Тогда 
		ТекстВопроса =  НСтр("ru = 'В деле хранятся документы выходящие за указанный интервал! Продолжить?'");
		ПоказатьВопрос(ОписаниеОповещения, ТекстВопроса, РежимДиалогаВопрос.ДаНет);
		Возврат;
	КонецЕсли;
	
	ВыполнитьОбработкуОповещения(ОписаниеОповещения, КодВозвратаДиалога.Да);
	
КонецПроцедуры

&НаКлиенте
Процедура ДатаНачалаПриИзменении(Элемент)
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ПериодПриИзменении", ЭтаФорма,
		Новый Структура("ДатаНачала", Истина));
	
	Если Не Объект.Ссылка.Пустая() И ЗначениеЗаполнено(Объект.ДатаНачала)  
		И ЕстьДокументыЗаПериодом(Объект.Ссылка, Объект.ДатаНачала, Ложь) Тогда 
		ТекстВопроса =  НСтр("ru = 'В деле хранятся документы выходящие за указанный интервал! Продолжить?'");
		ПоказатьВопрос(ОписаниеОповещения, ТекстВопроса, РежимДиалогаВопрос.ДаНет);
		Возврат;
	КонецЕсли;
	
	ВыполнитьОбработкуОповещения(ОписаниеОповещения, КодВозвратаДиалога.Да);
	
КонецПроцедуры

&НаКлиенте
Процедура ИнструкцияПриНажатии(Элемент, ДанныеСобытия, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	РаботаСИнструкциямиКлиент.ОткрытьСсылку(ДанныеСобытия.Href, ДанныеСобытия.Element, Элемент.Документ);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыОтноситсяКНоменклатуреДел

&НаКлиенте
Процедура ОтноситсяКНоменклатуреДелВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ТекущиеДанные = Элементы.ОтноситсяКНоменклатуреДел.ТекущиеДанные;
	Если ТекущиеДанные <> Неопределено Тогда 
		ПоказатьЗначение(, ТекущиеДанные.НоменклатураДел);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ПоказыватьИнструкции(Команда)
	
	ПоказыватьИнструкции = Не ПоказыватьИнструкции;
	ПолучитьИнструкции();
	
КонецПроцедуры

&НаКлиенте
Процедура ПереносДокументовДела(Команда)
	
	ПараметрыФормы = Новый Структура("ПеренестиИзДела", Объект.Ссылка);
	Открытьформу("Справочник.ДелаХраненияДокументов.Форма.ФормаПереносаДокументовДела", ПараметрыФормы, ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ПосмотретьНаСхеме(Команда)
	
	Если ЗначениеЗаполнено(ПланПомещения) Тогда
		ПараметрыФормы = Новый Структура("Ключ", ПланПомещения);
		ОткрытьФорму("Справочник.ТерриторииИПомещения.Форма.ФормаЭлемента", ПараметрыФормы);
	КонецЕсли;	
	
КонецПроцедуры

// СтандартныеПодсистемы.Печать
&НаКлиенте
Процедура Подключаемый_ВыполнитьКомандуПечати(Команда)
	
	УправлениеПечатьюКлиент.ВыполнитьПодключаемуюКомандуПечати(Команда, ЭтаФорма, Объект);
	
КонецПроцедуры
// Конец СтандартныеПодсистемы.Печать

// СтандартныеПодсистемы.ДополнительныеОтчетыИОбработки
&НаКлиенте
Процедура Подключаемый_ВыполнитьНазначаемуюКоманду(Команда)
	
	Если НЕ ДополнительныеОтчетыИОбработкиКлиент.ВыполнитьНазначаемуюКомандуНаКлиенте(ЭтаФорма, Команда.Имя) Тогда
		РезультатВыполнения = Неопределено;
		ДополнительныеОтчетыИОбработкиВыполнитьНазначаемуюКомандуНаСервере(Команда.Имя, РезультатВыполнения);
	КонецЕсли;
	
КонецПроцедуры
// Конец СтандартныеПодсистемы.ДополнительныеОтчетыИОбработки

// СтандартныеПодсистемы.БазоваяФункциональность
&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
	ПодключаемыеКомандыКлиент.ВыполнитьКоманду(ЭтотОбъект, Команда, Объект);
КонецПроцедуры

&НаСервере
Процедура Подключаемый_ВыполнитьКомандуНаСервере(Контекст, Результат)
	ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, Контекст, Объект, Результат);
КонецПроцедуры
// Конец СтандартныеПодсистемы.БазоваяФункциональность

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ЗаполнитьРеквизиты()
	
	Если Не ЗначениеЗаполнено(Объект.НоменклатураДел) Тогда 
		Возврат;
	КонецЕсли;
	
	РеквизитыНоменклатуры = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Объект.НоменклатураДел,
		"Индекс, Организация, Год, Раздел.Подразделение"); 
	Объект.Организация = РеквизитыНоменклатуры.Организация;
	Объект.Подразделение = РеквизитыНоменклатуры.РазделПодразделение;
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	Дела.НомерТома КАК НомерТома,
	|	Дела.ДатаНачала,
	|	Дела.ДатаОкончания
	|ИЗ
	|	Справочник.ДелаХраненияДокументов КАК Дела
	|ГДЕ
	|	НЕ Дела.ПометкаУдаления
	|	И Дела.НоменклатураДел.Индекс = &Индекс
	|	И Дела.Организация = &Организация
	|	И ГОД(Дела.ДатаНачала) <= &Год
	|	И (Дела.ДатаОкончания = ДАТАВРЕМЯ(1, 1, 1)
	|			ИЛИ Дела.ДатаОкончания <> ДАТАВРЕМЯ(1, 1, 1)
	|				И ГОД(Дела.ДатаОкончания) >= &Год)
	|
	|УПОРЯДОЧИТЬ ПО
	|	НомерТома УБЫВ";
	
	Запрос.УстановитьПараметр("Индекс", РеквизитыНоменклатуры.Индекс);
	Запрос.УстановитьПараметр("Организация", РеквизитыНоменклатуры.Организация);
	Запрос.УстановитьПараметр("Год", РеквизитыНоменклатуры.Год);
	
	Результат = Запрос.Выполнить();
	Если Результат.Пустой() Тогда 
		Объект.НомерТома = 1;
		Объект.ДатаНачала = Дата(РеквизитыНоменклатуры.Год, 1, 1);
		Возврат;
	КонецЕсли;
	
	Выборка = Результат.Выбрать();
	Выборка.Следующий();
		
	Объект.НомерТома = Выборка.НомерТома + 1;
	Если ЗначениеЗаполнено(Выборка.ДатаОкончания) Тогда 
		Объект.ДатаНачала = Выборка.ДатаОкончания + 3600 * 24;
	Иначе 
		Объект.ДатаНачала = Дата(РеквизитыНоменклатуры.Год, 1, 1);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ЗакрытьДело()
	
	Если Объект.Ссылка.Пустая() Тогда 
		Возврат;
	КонецЕсли;	
	
	УстановитьПривилегированныйРежим(Истина);
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ЕСТЬNULL(МАКСИМУМ(ДокументыВДелеТоме.Ссылка.ДатаРегистрации), ДАТАВРЕМЯ(1, 1, 1)) КАК ДатаОкончания,
	|	ЕСТЬNULL(СУММА(ДокументыВДелеТоме.Ссылка.КоличествоЛистов), 0) КАК КоличествоЛистов,
	|	ЕСТЬNULL(СУММА(ДокументыВДелеТоме.Ссылка.ЛистовВПриложениях), 0) КАК ЛистовВПриложениях
	|ИЗ
	|	КритерийОтбора.ДокументыВДелеТоме(&ЗначениеОтбора) КАК ДокументыВДелеТоме
	|ГДЕ
	|	(НЕ ДокументыВДелеТоме.Ссылка.ПометкаУдаления)";
	Запрос.УстановитьПараметр("ЗначениеОтбора", Объект.Ссылка);
	
	Результат = Запрос.Выполнить();
	Если Результат.Пустой() Тогда 
		Возврат;
	КонецЕсли;	
	Выборка = Результат.Выбрать();
	Выборка.Следующий();
	
	Если Не ЗначениеЗаполнено(Объект.ДатаОкончания) Тогда
		Объект.ДатаОкончания = Выборка.ДатаОкончания;
	КонецЕсли;	
	
	Если Не ЗначениеЗаполнено(Объект.КоличествоЛистов) Тогда
		Объект.КоличествоЛистов = Выборка.КоличествоЛистов + Выборка.ЛистовВПриложениях;
	КонецЕсли;	
	
КонецПроцедуры	

&НаКлиенте
Процедура ПериодПриИзменении(Результат, Параметры) Экспорт 
	
	Если Результат <> КодВозвратаДиалога.Да Тогда 
		Если Параметры.ДатаНачала Тогда 
			Объект.ДатаНачала = ТекущаяДатаНачала;
		Иначе 
			Объект.ДатаОкончания = ТекущаяДатаОкончания;
		КонецЕсли;
	КонецЕсли;
	
	ТекущаяДатаНачала = Объект.ДатаНачала;
	ТекущаяДатаОкончания = Объект.ДатаОкончания;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ЕстьДокументыЗаПериодом(Дело, ПроверяемаяДата, ЭтоДатаОкончания = Истина)
	
	УстановитьПривилегированныйРежим(Истина);
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ОбщиеРеквизитыДокументов.Документ
	|ИЗ
	|	РегистрСведений.ОбщиеРеквизитыДокументов КАК ОбщиеРеквизитыДокументов
	|ГДЕ
	|	ОбщиеРеквизитыДокументов.Документ.Дело = &Дело
	|	И НЕ ОбщиеРеквизитыДокументов.Документ.ПометкаУдаления
	|	И ОбщиеРеквизитыДокументов.ДатаСортировки < &ПроверяемаяДата";
		
	Если ЭтоДатаОкончания Тогда 
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "<", ">");
		ПроверяемаяДата = КонецДня(ПроверяемаяДата);
	КонецЕсли;
	
	Запрос.Параметры.Вставить("Дело", Дело);
	Запрос.Параметры.Вставить("ПроверяемаяДата", ПроверяемаяДата);
	
	Возврат Не Запрос.Выполнить().Пустой();
	
КонецФункции

&НаСервере
Процедура ПолучитьИнструкции()
	
	РаботаСИнструкциями.ПолучитьИнструкции(ЭтаФорма, 65, 95);
	
КонецПроцедуры

// СтандартныеПодсистемы.ДополнительныеОтчетыИОбработки
&НаСервере
Процедура ДополнительныеОтчетыИОбработкиВыполнитьНазначаемуюКомандуНаСервере(ИмяЭлемента, РезультатВыполнения)
	
	ДополнительныеОтчетыИОбработки.ВыполнитьНазначаемуюКомандуНаСервере(ЭтаФорма, ИмяЭлемента, РезультатВыполнения);
	
КонецПроцедуры
// Конец СтандартныеПодсистемы.ДополнительныеОтчетыИОбработки

#КонецОбласти
