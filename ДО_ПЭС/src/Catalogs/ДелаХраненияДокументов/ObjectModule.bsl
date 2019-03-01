#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	УстановитьПривилегированныйРежим(Истина);
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	Дела.Ссылка КАК Ссылка
	|ИЗ
	|	Справочник.ДелаХраненияДокументов КАК Дела
	|ГДЕ
	|	Дела.НомерТома = &НомерТома
	|	И Дела.НоменклатураДел = &НоменклатураДел
	|	И Дела.Ссылка <> &Ссылка";
	
	Запрос.УстановитьПараметр("НомерТома", НомерТома);
	Запрос.УстановитьПараметр("НоменклатураДел", НоменклатураДел);
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	
	Результат = Запрос.Выполнить();
	Если Не Результат.Пустой() Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			НСтр("ru = 'Дело с указанным номером тома уже существует!'"), 
			ЭтотОбъект, 
			"НомерТома",, 
			Отказ);
		Возврат;	
	КонецЕсли;	
	
	Если ДелоЗакрыто Тогда 
		ПроверяемыеРеквизиты.Добавить("ДатаНачала");
		ПроверяемыеРеквизиты.Добавить("ДатаОкончания");
	КонецЕсли;	
	
	Если ПолучитьФункциональнуюОпцию("ОбязательныйУчетПоМестамХранения") Тогда 
		ПроверяемыеРеквизиты.Добавить("МестоХраненияДел");
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ДатаНачала) И ЗначениеЗаполнено(ДатаОкончания) 
		И ДатаНачала > ДатаОкончания Тогда 
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			НСтр("ru = 'Дата окончания дела меньше, чем дата начала.'"),
			ЭтотОбъект,
			"ДатаОкончания",, 
			Отказ);
	КонецЕсли;
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ)
	
	Если ОбменДанными.Загрузка Тогда 
		
		Если Не ДополнительныеСвойства.Свойство("ЗагрузкаИзДО20") Тогда 
			Возврат;
		КонецЕсли;	
		
	КонецЕсли;
	
	РеквизитыНоменклатурыДел = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(НоменклатураДел,
		"Наименование, Организация, Раздел.Подразделение");
	Наименование = РеквизитыНоменклатурыДел.Наименование + " "
		+ СтрШаблон(НСтр("ru = '(том №%1)'"),
			Формат(НомерТома, "ЧГ="));
		
	Организация = РеквизитыНоменклатурыДел.Организация;
	Подразделение = РеквизитыНоменклатурыДел.РазделПодразделение;
	
	ОтноситсяКНоменклатуреДел.Очистить();
	НоваяСтрока = ОтноситсяКНоменклатуреДел.Добавить();
	НоваяСтрока.НоменклатураДел = НоменклатураДел;
	
	МассивНоменклатурПоПериоду = Делопроизводство.ПолучитьМассивНоменклатурЗаПериод(
		НоменклатураДел, ДатаНачала, ДатаОкончания);
		
	Для Каждого Номенклатура Из МассивНоменклатурПоПериоду Цикл 
		НоваяСтрока = ОтноситсяКНоменклатуреДел.Добавить();
		НоваяСтрока.НоменклатураДел = Номенклатура;
	КонецЦикла;
	
КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)
	
	ДелоЗакрыто = Ложь;
	КоличествоЛистов = 0;
	ДатаОкончания = '00010101';
	
	ОтноситсяКНоменклатуреДел.Очистить();
	
КонецПроцедуры

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка)
	
	Если Не ЗначениеЗаполнено(Организация) Тогда 
		Организация = РаботаСОрганизациями.ПолучитьОрганизациюПоУмолчанию();
	КонецЕсли;
	
КонецПроцедуры

#КонецЕсли
