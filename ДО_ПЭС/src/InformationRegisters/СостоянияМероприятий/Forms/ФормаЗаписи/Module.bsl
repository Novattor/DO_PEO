#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Запись.Установил = Неопределено Тогда 
		Запись.Установил = ПользователиКлиентСервер.ТекущийПользователь();
	КонецЕсли;	
	
	Если Не РольДоступна("ПолныеПрава") Тогда 
		Если (ТипЗнч(Запись.Установил) <> Тип("СправочникСсылка.Пользователи"))
		 Или (Запись.Установил <> ПользователиКлиентСервер.ТекущийПользователь()) Тогда 
			ЭтаФорма.ТолькоПросмотр = Истина;
		КонецЕсли;
		
		ЭтаФорма.Элементы.Установил.ТолькоПросмотр = Истина;
		ЭтаФорма.Элементы.Мероприятие.ТолькоПросмотр = Истина;
	КонецЕсли;	
	
КонецПроцедуры

#КонецОбласти