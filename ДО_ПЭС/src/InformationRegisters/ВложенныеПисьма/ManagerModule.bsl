#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
	
#Область СлужебныеПроцедурыИФункции

// Записывает вложение письма
//
// Параметры:
// - Владелец – ДокументСсылка.ИсходящееПисьмо – письмо-владелец
// - Вложение -  ДокументСсылка.ВходящееПисьмо, ДокументСсылка.ИсходящееПисьмо - вложенное письмо
//
Процедура ЗаписатьВложение(Владелец, Вложение) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	МенеджерЗаписи = РегистрыСведений.ВложенныеПисьма.СоздатьМенеджерЗаписи();
	
	МенеджерЗаписи.Владелец = Владелец;
	МенеджерЗаписи.Вложение = Вложение;
	
	МенеджерЗаписи.Записать();
	
КонецПроцедуры

// Получает вложения письма
//
// Параметры:
// - Владелец – ДокументСсылка.ИсходящееПисьмо – письмо-владелец
//
// Возвращаемое значение:
// Массив структур - массив 
// с полями вложенных писем (Письмо Представление ИмяФайла ИндексКартинки Размер РазмерПредставление ПометкаУдаления Редактирует РедактируетТекущийПользователь)
//  - для заполнения реквизита Вложения в карточке письма или форме списка писем.
//
Функция ПолучитьВложенныеПисьма(Владелец) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	Результат = Новый Массив;
	
	Запрос = Новый Запрос(
		"ВЫБРАТЬ
		|	ВложенныеПисьма.Вложение КАК Письмо
		|ИЗ
		|	РегистрСведений.ВложенныеПисьма КАК ВложенныеПисьма
		|ГДЕ
		|	ВложенныеПисьма.Владелец = &Владелец");
		
	Запрос.УстановитьПараметр("Владелец", Владелец);
	Выборка = Запрос.Выполнить().Выбрать();
	
	Пока Выборка.Следующий() Цикл
		
		Письмо = Выборка.Письмо;
		ПараметрыПисьма = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Письмо,
			"Тема, Размер, ПометкаУдаления");
		
		ИндексКартинки = 32;
		
		ФайлИнфо = Новый Структура;
		ФайлИнфо.Вставить("Письмо", Письмо);
		ФайлИнфо.Вставить("Представление", ПараметрыПисьма.Тема);
		ФайлИнфо.Вставить("ИмяФайла", ПараметрыПисьма.Тема);
		ФайлИнфо.Вставить("ИндексКартинки", ИндексКартинки);
		ФайлИнфо.Вставить("Размер", ПараметрыПисьма.Размер);
		ФайлИнфо.Вставить("РазмерПредставление", РаботаСоСтроками.ПолучитьРазмерСтрокой(ПараметрыПисьма.Размер));
		ФайлИнфо.Вставить("ПометкаУдаления", ПараметрыПисьма.ПометкаУдаления);
		ФайлИнфо.Вставить("Редактирует", Неопределено);
		ФайлИнфо.Вставить("РедактируетТекущийПользователь", Ложь);
		
		Результат.Добавить(ФайлИнфо);
		
	КонецЦикла;
	
	Возврат Результат;
	
КонецФункции

// Стирает информацию о вложениях письма
//
// Параметры:
// - Владелец – ДокументСсылка.ИсходящееПисьмо – письмо-владелец
//
Процедура СтеретьЗаписиПоВладельцу(Владелец) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	НаборЗаписей = РегистрыСведений.ВложенныеПисьма.СоздатьНаборЗаписей();
	НаборЗаписей.Отбор.Владелец.Установить(Владелец);
	НаборЗаписей.Записать();
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли