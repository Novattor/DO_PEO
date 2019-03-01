
&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("ТипШаблонаДокумента", "ШаблоныВнутреннихДокументов");
	ПараметрыФормы.Вставить("ВозможностьСозданияПустогоДокумента", Истина);
	
	РежимОткрытияФормы = РежимОткрытияОкнаФормы.БлокироватьВесьИнтерфейс;
	ОповещениеОЗакрытииФормыСозданиеДокументаПоШаблону = Новый ОписаниеОповещения(
		"СозданиеДокументаПоШаблонуЗавершение", ЭтотОбъект, ПараметрыВыполненияКоманды);
	
	Попытка
		
		ОткрытьФорму(
			"ОбщаяФорма.СозданиеДокументаПоШаблону",
			ПараметрыФормы,,,,,
			ОповещениеОЗакрытииФормыСозданиеДокументаПоШаблону,
			РежимОткрытияФормы);
			
		Возврат;
		
	Исключение
		
		Инфо = ИнформацияОбОшибке();
		Если Инфо.Описание = "СоздатьПустойДокумент" Тогда
			ВыполнитьОбработкуОповещения(ОповещениеОЗакрытииФормыСозданиеДокументаПоШаблону,
				"СоздатьПустойДокумент");
		Иначе
			ВызватьИсключение;
		КонецЕсли;
		
	КонецПопытки;
	
КонецПроцедуры

&НаКлиенте
Процедура СозданиеДокументаПоШаблонуЗавершение(Результат, Параметры) Экспорт
	
	Если НЕ ЗначениеЗаполнено(Результат) ИЛИ Результат = "ПрерватьОперацию" Тогда
		Возврат;
	КонецЕсли;
	
	КлючеваяОперация = "ВнутренниеДокументыВыполнениеКомандыСоздать";
	ОценкаПроизводительностиКлиентСервер.НачатьЗамерВремени(КлючеваяОперация);
	
	Если (ТипЗнч(Результат) <> Тип("Строка")) Тогда 
		ШаблонДокумента = Результат.ШаблонДокумента;
	Иначе
		ШаблонДокумента = Результат;
	КонецЕсли;
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("ШаблонДокумента", ШаблонДокумента);
	
	Открытьформу(
		"Справочник.ВнутренниеДокументы.ФормаОбъекта",
		ПараметрыФормы,
		Параметры.Источник);
	
КонецПроцедуры
