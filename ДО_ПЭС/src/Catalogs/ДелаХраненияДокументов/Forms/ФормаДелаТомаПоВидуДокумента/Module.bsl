
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ВидыДокументов = Новый Массив;
			
	врВидДокумента = Параметры.ВидДокумента;
	Пока ЗначениеЗаполнено(врВидДокумента) Цикл
		ВидыДокументов.Добавить(врВидДокумента);
		врВидДокумента = врВидДокумента.Родитель;
	КонецЦикла;
	
	Список.Параметры.УстановитьЗначениеПараметра("ВидыДокументов", ВидыДокументов);
	
КонецПроцедуры
