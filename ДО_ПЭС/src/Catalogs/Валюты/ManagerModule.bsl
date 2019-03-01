#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

////////////////////////////////////////////////////////////////////////////////
// Групповое изменение объектов.

// Возвращает реквизиты объекта, которые разрешается редактировать
// с помощью обработки группового изменения реквизитов.
//
// Возвращаемое значение:
//  Массив - список имен реквизитов объекта.
Функция РеквизитыРедактируемыеВГрупповойОбработке() Экспорт
	
	Результат = Новый Массив;
	Результат.Добавить("СпособУстановкиКурса");
	Результат.Добавить("Наценка");
	Результат.Добавить("ОсновнаяВалюта");
	Результат.Добавить("ФормулаРасчетаКурса");
	Возврат Результат;
	
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// Загрузка данных из файла

// Запрещает загрузку данных в этот справочник из подсистемы "ЗагрузкаДанныхИзФайла".
// Т.к. справочник реализует свой метод обновления данных.
//
Функция ИспользоватьЗагрузкуДанныхИзФайла() Экспорт
	Возврат Ложь;
КонецФункции

#КонецОбласти

#КонецЕсли