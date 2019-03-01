////////////////////////////////////////////////////////////////////////////////
// Модуль для работы с мероприятиями.
//
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Получает кто установил состояние мероприятия.
//
// Параметры:
//  Мероприятие - СправочникСсылка.Мероприятия - Мероприятие, состояние которого будет получено.
//  Состояния - Массив - Состояния, установка которых интересует.
//
// Возвращаемое значение:
//  Установил - БизнесПроцессСсылка, СправочникСсылка.Пользователи - Кто установил состояние.
//
Функция ПолучитьУстановилСостояниеМероприятия(Мероприятие, Состояния) Экспорт
	
	Возврат УправлениеМероприятиями.ПолучитьУстановилСостояниеМероприятия(Мероприятие, Состояния);
	
КонецФункции

// По части наименования формирует список для выбора участника мероприятия.
//
// Параметры:
//  Текст - часть наименования, по которому выполняется поиск.
//
// Возвращает:
//  СписокЗначений - Список значений, содержащий ссылки на найденные по части наименования объекты
//
Функция СформироватьДанныеВыбораУчастника(Текст) Экспорт
	
	Возврат УправлениеМероприятиями.СформироватьДанныеВыбораУчастника(Текст);
	
КонецФункции

// По части наименования формирует список для выбора организатора мероприятия.
//
// Параметры:
//  Параметры - Параметры автоподбора.
//
// Возвращает:
//  СписокЗначений - Список значений, содержащий ссылки на найденные по части наименования объекты
//
Функция СформироватьДанныеВыбораОрганизатора(Параметры) Экспорт
	
	Возврат УправлениеМероприятиями.СформироватьДанныеВыбораОрганизатора(Параметры);
	
КонецФункции

// Меняет папку для массива мероприятий на новую.
//
// Параметры:
//  МассивМероприятий - Массив - Мероприятия, у которых необходимо изменить папку.
//  НоваяПапка - СправочникСсылка.ПапкиМероприятий - Новая папка мероприятий.
//
// Возвращаемое значение:
//  Булево - Успешное изменение папки мероприятий.
//
Функция ИзменитьПапкуМероприятий(МассивМероприятий, НоваяПапка) Экспорт
	
	Возврат УправлениеМероприятиями.ИзменитьПапкуМероприятий(МассивМероприятий, НоваяПапка);
	
КонецФункции

// Останавливает исполнение по всем пунктам протокола мероприятия.
//
// Параметры:
//  Мероприятие - СправочникСсылка.Мероприятия - Мероприятие.
//
Процедура ОстановитьИсполнениеПротокола(Мероприятие) Экспорт
	
	УправлениеМероприятиями.ОстановитьИсполнениеПротокола(Мероприятие);
	
КонецПроцедуры

// Продолжает исполнение по всем пунктам протокола мероприятия.
//
// Параметры:
//  Мероприятие - СправочникСсылка.Мероприятия - Мероприятие.
//
Процедура ПродолжитьИсполнениеПротокола(Мероприятие) Экспорт
	
	УправлениеМероприятиями.ПродолжитьИсполнениеПротокола(Мероприятие);
	
КонецПроцедуры

// Прерывает исполнение по всем пунктам протокола мероприятия.
//
// Параметры:
//  Мероприятие			 - СправочникСсылка.Мероприятия	 - Мероприятие.
//  ПричинаПрерывания	 - Строка						 - Описание причины прерывания.
//
Процедура ПрерватьИсполнениеПротокола(Мероприятие, ПричинаПрерывания) Экспорт
	
	УправлениеМероприятиями.ПрерватьИсполнениеПротокола(Мероприятие, ПричинаПрерывания);
	
КонецПроцедуры

// Определяет состояние исполнения протокола мероприятия.
//
// Параметры:
//  Мероприятие - СправочникСсылка.Мероприятие - Мероприятие.
//  ПараметрыИсполнения - Структура - Параметры исполнения протокола.
//
// Возвращаемое значение:
//  Строка - Состояние исполнения протокола.
//
Функция ОпределитьСостояниеИсполненияПротокола(Мероприятие, ПараметрыИсполнения) Экспорт
	
	Возврат УправлениеМероприятиями.ОпределитьСостояниеИсполненияПротокола(Мероприятие, ПараметрыИсполнения);
	
КонецФункции

// Направляет протокол мероприятия на исполнение.
//
// Параметры:
//  ПараметрыИсполнения - Структура - Параметры исполнения протокола.
//
Процедура НаправитьПротоколМероприятияНаИсполнение(ПараметрыИсполнения) Экспорт
	
	УправлениеМероприятиями.НаправитьПротоколМероприятияНаИсполнение(ПараметрыИсполнения);
	
КонецПроцедуры

// По части наименования формирует список для выбора места проведения.
//
// Параметры:
//  Параметры - Параметры получения данных.
//
// Возвращает:
//  СписокЗначений - Список значений, содержащий ссылки на найденные по части наименования объекты.
//
Функция СформироватьДанныеВыбораМестаПроведения(Параметры) Экспорт
	
	Возврат УправлениеМероприятиями.СформироватьДанныеВыбораМестаПроведения(Параметры);
	
КонецФункции

// Заполняет протокол мероприятия на основании программы.
// Если протокол уже заполнен, то он будет очищен.
//
// Параметры:
//  Мероприятие - СправочникСсылка.Мероприятия - Мероприятие.
//
Процедура ЗаполнитьПротокол(Мероприятие) Экспорт
	
	УправлениеМероприятиями.ЗаполнитьПротокол(Мероприятие);
	
КонецПроцедуры

// Заполняет протокол мероприятия на основании протокола предыдущего мероприятия.
//
// Параметры:
//  Мероприятие - СправочникСсылка.Мероприятия - Мероприятие.
//
Процедура ЗаполнитьПротоколНаОснованииПредыдущего(Мероприятие) Экспорт
	
	УправлениеМероприятиями.ЗаполнитьПротоколНаОснованииПредыдущего(Мероприятие);
	
КонецПроцедуры

#КонецОбласти