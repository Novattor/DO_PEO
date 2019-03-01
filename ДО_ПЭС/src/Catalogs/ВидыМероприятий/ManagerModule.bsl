#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Возвращает структуру полей вида мероприятия
//
// Возвращаемое значение:
//   Структура
//     Наименование
//     ПротокольноеМероприятие
//     АвтоматическиВестиСоставУчастниковРабочейГруппы
//     ОбязательноеЗаполнениеРабочихГруппДокументов
//     Комментарий
//
Функция ПолучитьСтруктуруВидаМероприятия() Экспорт
	
	СтруктураВидаМероприятия = Новый Структура;
	СтруктураВидаМероприятия.Вставить("Наименование");
	СтруктураВидаМероприятия.Вставить("ПротокольноеМероприятие");
	СтруктураВидаМероприятия.Вставить("АвтоматическиВестиСоставУчастниковРабочейГруппы");
	СтруктураВидаМероприятия.Вставить("ОбязательноеЗаполнениеРабочихГруппДокументов");
	СтруктураВидаМероприятия.Вставить("Комментарий");
	
	Возврат СтруктураВидаМероприятия;
	
КонецФункции

// Создает и записывает в БД вид мероприятия
//
// Параметры:
//   СтруктураВидаМероприятия - Структура - структура полей вида мероприятия.
//
// Возвращаемое значение:
//   СправочникСсылка.ВидыМероприятий
//
Функция СоздатьВидМероприятия(СтруктураВидаМероприятия) Экспорт
	
	НовыйВидМероприятия = СоздатьЭлемент();
	ЗаполнитьЗначенияСвойств(НовыйВидМероприятия, СтруктураВидаМероприятия);
	НовыйВидМероприятия.Записать();
	
	Возврат НовыйВидМероприятия.Ссылка;
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции_УправлениеДоступом

Функция ПолучитьПоляДоступа() Экспорт
	
	Возврат "Ссылка";
	
КонецФункции

// Заполняет переданный дескриптор доступа 
Процедура ЗаполнитьОсновнойДескриптор(ОбъектДоступа, ДескрипторДоступа) Экспорт
	
	ДескрипторДоступа.ВидОбъекта = ОбъектДоступа.Ссылка;
	
КонецПроцедуры

// Возвращает признак того, что менеджер содержит метод ЗапросДляРасчетаПрав()
// 
Функция ЕстьМетодЗапросДляРасчетаПрав() Экспорт
	
	Возврат Истина;
	
КонецФункции

// Возвращает запрос для расчета прав доступа по дескрипторам объекта
// 
// Параметры:
//  
//  Дескрипторы - Массив - массив дескрипторов, чьи права нужно рассчитать
//  ИдОбъекта - Ссылка - идентификатор объекта метаданных, назначенный переданным дескрипторам
//  МенеджерОбъектаДоступа - СправочникМенеджер, ДокументМенеджер - менеджер объекта доступа
// 
// Возвращаемое значение - Запрос - запрос, который выберет права доступа для переданного массива дескрипторов
// 
Функция ЗапросДляРасчетаПрав(Дескрипторы, ИдОбъекта, МенеджерОбъектаДоступа) Экспорт
	
	Запрос = Справочники.ДескрипторыДоступаОбъектов.ЗапросДляСтандартногоРасчетаПрав(
		Дескрипторы, ИдОбъекта, МенеджерОбъектаДоступа, Ложь, Истина);
	Запрос.Текст = ДокументооборотПраваДоступаПовтИсп.ТекстЗапросаДляРасчетаПравРазрезаДоступа();
	
	Возврат Запрос;
	
КонецФункции

// Заполняет протокол расчета прав дескрипторов
// 
// Параметры:
//  
//  ПротоколРасчетаПрав - Массив - протокол для заполнения
//  ЗапросПоПравам - Запрос - запрос, который использовался для расчета прав дескрипторов
//  Дескрипторы - Массив - массив дескрипторов, чьи права были рассчитаны
//  
Процедура ЗаполнитьПротоколРасчетаПрав(ПротоколРасчетаПрав, ЗапросПоПравам) Экспорт
	
	Справочники.ДескрипторыДоступаОбъектов.ЗаполнитьПротоколРасчетаПравСтандартно(
		ПротоколРасчетаПрав, ЗапросПоПравам);
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли