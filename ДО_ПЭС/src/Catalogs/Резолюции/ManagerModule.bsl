#Область ПрограммныйИнтерфейс

// Возвращает массив имен ключевых реквизитов
Функция ПолучитьИменаКлючевыхРеквизитов(Версия = Неопределено) Экспорт
	
	МассивИмен = Новый Массив;
	
	Если Версия = 1 Тогда
		МассивИмен.Добавить("Документ");
		МассивИмен.Добавить("АвторРезолюции");
		МассивИмен.Добавить("ВнесРезолюцию");
		МассивИмен.Добавить("ДатаРезолюции");
		МассивИмен.Добавить("ТекстРезолюции");
		МассивИмен.Добавить("Наименование");
	Иначе
		МассивИмен.Добавить("Документ");
		МассивИмен.Добавить("АвторРезолюции");
		МассивИмен.Добавить("ВнесРезолюцию");
		МассивИмен.Добавить("ДатаРезолюции");
		МассивИмен.Добавить("ТекстРезолюции");
	КонецЕсли;
	
	Возврат МассивИмен;
	
КонецФункции

#КонецОбласти