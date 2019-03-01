
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	КоличествоВсехИнструкций = РаботаСИнструкциями.КоличествоТиповыхИнструкций();
	КоличествоИнструкцийДляЗагрузки = РаботаСИнструкциями.КоличествоТиповыхИнструкцийДляЗагрузки();
	
	ПрописьЧисла = ЧислоПрописью(КоличествоВсехИнструкций, "Л = ru_RU", НСтр("ru = ',,,,,,,,0'"));
	ПрописьЧислаИПредмета = ЧислоПрописью(КоличествоВсехИнструкций, "Л = ru_RU", 
		НСтр("ru = 'типовая инструкция,типовые инструкции,типовых инструкций,ж,,,,,0'"));
	КоличествоВсехИнструкцийПрописью = СтрЗаменить(ПрописьЧислаИПредмета, ПрописьЧисла, 
		Формат(КоличествоВсехИнструкций, "ЧГ=") + " ");
	
	Элементы.ДекорацияВопрос.Заголовок = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		НСтр("ru = 'Будет загружено %1 из %2 по работе с документами, процессами, задачами и электронной подписью.'"),
		КоличествоИнструкцийДляЗагрузки, КоличествоВсехИнструкцийПрописью
		);
	
КонецПроцедуры

&НаКлиенте
Процедура Загрузить(Команда)
	
	Состояние(НСтр("ru = 'Загрузка типовых инструкций.'"));
	РаботаСИнструкциями.ЗагрузитьТиповыеИнструкции();
	Состояние(НСтр("ru = 'Загрузка типовых инструкций завершена.'"));
	Оповестить("Запись_Инструкции");
	ЭтаФорма.Закрыть();

КонецПроцедуры

&НаКлиенте
Процедура ДекорацияПодробнееНажатие(Элемент)
	
	ИнструкцииДляЗагрузки = РаботаСИнструкциями.ТиповыеИнструкцииДляЗагрузки();
	ТекстСообщения = "- " + СтрСоединить(ИнструкцииДляЗагрузки, Символы.ПС + "- ");
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("Заголовок", НСтр("ru = 'Инструкции для загрузки'"));
	ПараметрыФормы.Вставить("ТекстСообщения", ТекстСообщения);
	ОткрытьФорму("ОбщаяФорма.Сообщение", ПараметрыФормы, ЭтаФорма,,,,, РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Если КоличествоИнструкцийДляЗагрузки = 0 Тогда
		ТекстПредупреждения = НСтр("ru = 'Все типовые инструкции уже загружены'");
		ПоказатьПредупреждение(Неопределено, ТекстПредупреждения);
		Отказ = Истина;
	КонецЕсли;

КонецПроцедуры
