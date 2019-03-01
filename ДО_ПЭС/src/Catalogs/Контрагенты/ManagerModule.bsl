#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Возвращает строку, содержащую перечисление полей доступа через запятую
// Это перечисление используется в дальнейшем для передачи в метод 
// ОбщегоНазначения.ЗначенияРеквизитовОбъекта()
// 
Функция ПолучитьПоляДоступа() Экспорт
	
	Возврат "Ссылка, ЭтоГруппа, ГруппаДоступа";
	
КонецФункции

// Заполняет переданный дескриптор доступа
// 
Процедура ЗаполнитьОсновнойДескриптор(ОбъектДоступа, ДескрипторДоступа) Экспорт
	
	Если ЗначениеЗаполнено(ОбъектДоступа.ГруппаДоступа) Тогда
		Строка = ДескрипторДоступа.Контрагенты.Добавить();
		Строка.ГруппаДоступа = ОбъектДоступа.ГруппаДоступа;
	КонецЕсли;
	
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
	
	// Расчет по аналогии с разрезом доступа.
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

// Определяет список команд заполнения.
//
// Параметры:
//   КомандыЗаполнения - ТаблицаЗначений - Таблица с командами заполнения. Для изменения.
//       См. описание 1 параметра процедуры ЗаполнениеОбъектовПереопределяемый.ПередДобавлениемКомандЗаполнения().
//   Параметры - Структура - Вспомогательные параметры. Для чтения.
//       См. описание 2 параметра процедуры ЗаполнениеОбъектовПереопределяемый.ПередДобавлениемКомандЗаполнения().
//
Процедура ДобавитьКомандыЗаполнения(КомандыЗаполнения, Параметры) Экспорт
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытий

// Проверяет, подходит ли объект к шаблону бизнес-процесса
Функция ШаблонПодходитДляАвтозапускаБизнесПроцессаПоОбъекту(ШаблонСсылка, ПредметСсылка, Подписчик, ВидСобытия, Условие) Экспорт
	
	Возврат БизнесСобытияВызовСервера.ШаблонПодходитДляАвтозапускаБизнесПроцессаПоДокументу(ШаблонСсылка, 
		ПредметСсылка, Подписчик, ВидСобытия, Условие);
	
КонецФункции

// Возвращает имя предмета процесса по умолчанию
//
Функция ПолучитьИмяПредметаПоУмолчанию(Ссылка) Экспорт
	
	Возврат НСтр("ru='Контрагент'");
	
КонецФункции

// Вернет Истина, у этого объекта метаданных есть функция ПолучитьАдресФото
Функция ЕстьФункцияПолученияФото() Экспорт
	
	Возврат Истина;
	
КонецФункции	

// Прочитать фото и вернуть адрес (навигационную ссылку)
// Параметры:
//  Ссылка - ссылка на справочник, для которого надо показать фото
//  УникальныйИдентификатор - уникальный идентификатор формы, откуда идет вызов
//  ЕстьКартинка - возвращаемое значение - Булево - Истина, если в объекте есть картинка
//
// Возвращаемое значение:
//   Строка - навигационная ссылка - или "", если нет картинки
Функция ПолучитьАдресФото(Ссылка, УникальныйИдентификатор, ЕстьКартинка) Экспорт
	
	АдресКартинки = "";
	
	ФизЛицо = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Ссылка, "ФизЛицо");
	
	Если ЗначениеЗаполнено(ФизЛицо) Тогда
		
		Если УправлениеДоступом.ОграничиватьДоступНаУровнеЗаписей() 
			И Не ДокументооборотПраваДоступа.ПолучитьПраваПоОбъекту(ФизЛицо).Чтение Тогда
			Возврат АдресКартинки;
		КонецЕсли;
		
		АдресКартинки = РаботаСФотографиями.ПолучитьНавигационнуюСсылкуРеквизита(ФизЛицо, УникальныйИдентификатор, ЕстьКартинка);
		
	КонецЕсли;
	
	Возврат АдресКартинки;
	
КонецФункции

// Возвращает двоичные данные фото контрагента
//
Функция ПолучитьДвоичныеДанныеФото(Контрагент) Экспорт
	
	ФизЛицо = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Контрагент, "ФизЛицо");
	
	Если Не ЗначениеЗаполнено(ФизЛицо) Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	Если УправлениеДоступом.ОграничиватьДоступНаУровнеЗаписей()
		И Не ДокументооборотПраваДоступа.ПолучитьПраваПоОбъекту(ФизЛицо).Чтение Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	ДвоичныеДанные = РаботаСФотографиями.ПолучитьДвоичныеДанныеРеквизита(ФизЛицо, "ФайлФотографии");
	Если Не ЗначениеЗаполнено(ДвоичныеДанные) Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	Возврат ДвоичныеДанные;
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ОбработкаПолученияДанныхВыбора(ДанныеВыбора, Параметры, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Текст = Параметры.СтрокаПоиска;
	СловаПоиска = ОбщегоНазначенияДокументооборот.СловаПоиска(Текст);
	ДанныеВыбора = Новый СписокЗначений;
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ ПЕРВЫЕ 50
	|	Контрагенты.Ссылка,
	|	""Наименование"" КАК ПолеСовпадения,
	|	Контрагенты.Наименование КАК ЗначениеПоля,
	|	Контрагенты.Представление КАК Контрагент
	|ИЗ
	|	Справочник.Контрагенты КАК Контрагенты
	|ГДЕ
	|	Контрагенты.ПометкаУдаления = ЛОЖЬ
	|	И Контрагенты.Наименование ПОДОБНО &Текст
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ ПЕРВЫЕ 50
	|	Контрагенты.Ссылка,
	|	""ИНН"",
	|	Контрагенты.ИНН,
	|	Контрагенты.Представление
	|ИЗ
	|	Справочник.Контрагенты КАК Контрагенты
	|ГДЕ
	|	Контрагенты.ПометкаУдаления = ЛОЖЬ
	|	И Контрагенты.ИНН ПОДОБНО &Текст
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ ПЕРВЫЕ 50
	|	Контрагенты.Ссылка,
	|	""Регистрационный номер"",
	|	Контрагенты.РегистрационныйНомер,
	|	Контрагенты.Представление
	|ИЗ
	|	Справочник.Контрагенты КАК Контрагенты
	|ГДЕ
	|	Контрагенты.ПометкаУдаления = ЛОЖЬ
	|	И Контрагенты.РегистрационныйНомер ПОДОБНО &Текст";
	
	Запрос.УстановитьПараметр("Текст", "%" + Текст + "%");
	
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		
		Если Выборка.ПолеСовпадения = "Наименование" Тогда 
			ПредставлениеФорматированнаяСтрока = ОбщегоНазначенияДокументооборот.ФорматированныйРезультатПоиска(
				Выборка.Контрагент,
				СловаПоиска);
			
			ДобавкаТекста = СтрШаблон(НСтр("ru = ' (%1)'"), "Контрагент");
				
			ПредставлениеФорматированнаяСтрока = Новый ФорматированнаяСтрока(
				ПредставлениеФорматированнаяСтрока,
				Новый ФорматированнаяСтрока(ДобавкаТекста,
					, WebЦвета.Серый)
				);
						
		ИначеЕсли Выборка.ПолеСовпадения = "ИНН" ИЛИ Выборка.ПолеСовпадения = "Регистрационный номер" Тогда 
			ПредставлениеФорматированнаяСтрока = ОбщегоНазначенияДокументооборот.ФорматированныйРезультатПоиска(
				Выборка.ЗначениеПоля,
				СловаПоиска);
			
			ДобавкаТекста = СтрШаблон(НСтр("ru = ' (%1)'"), Выборка.Контрагент);
				
			ПредставлениеФорматированнаяСтрока = Новый ФорматированнаяСтрока(
				ПредставлениеФорматированнаяСтрока,
				Новый ФорматированнаяСтрока(ДобавкаТекста,
					, WebЦвета.Серый)
				);
				
		КонецЕсли;
				
		ДанныеВыбора.Добавить(Выборка.Ссылка, ПредставлениеФорматированнаяСтрока);
		
	КонецЦикла;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Интерфейс для работы с подсистемой Печать.

// Заполняет список команд печати.
// 
// Параметры:
//   КомандыПечати - ТаблицаЗначений - состав полей см. в функции УправлениеПечатью.СоздатьКоллекциюКомандПечати
//
Процедура ДобавитьКомандыПечати(КомандыПечати) Экспорт
	
	// Карточка
	КомандаПечати = КомандыПечати.Добавить();
	КомандаПечати.МенеджерПечати = "Справочник.Контрагенты";
	КомандаПечати.Идентификатор = "Карточка";
	КомандаПечати.Представление = НСтр("ru = 'Карточка'");
	
КонецПроцедуры

Процедура Печать(МассивОбъектов, ПараметрыПечати, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода) Экспорт
	
	Если УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "Карточка") Тогда
	
		// Формируем табличный документ и добавляем его в коллекцию печатных форм
		УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(
			КоллекцияПечатныхФорм,
			"Карточка", 
			"Карточка контрагента", 
			ПечатьКарточки(МассивОбъектов, ОбъектыПечати, ПараметрыПечати),
			,
			"Справочник.Контрагенты.ПФ_MXL_Карточка");
			
	КонецЕсли;
	
КонецПроцедуры

Функция ПечатьКарточки(МассивОбъектов, ОбъектыПечати, ПараметрыПечати)
	
	ИспользоватьДополнительныеРеквизитыИСведения = ПолучитьФункциональнуюОпцию("ИспользоватьДополнительныеРеквизитыИСведения");
	
	// Создаем табличный документ и устанавливаем имя параметров печати
	ТабличныйДокумент = Новый ТабличныйДокумент;
	ТабличныйДокумент.ИмяПараметровПечати = "ПараметрыПечати_КарточкаКонтрагента";
	
	Макет = УправлениеПечатью.МакетПечатнойФормы("Справочник.Контрагенты.ПФ_MXL_Карточка");
	ОбластьЗаголовок = Макет.ПолучитьОбласть("Заголовок");
	ОбластьОсновныеРеквизиты = Макет.ПолучитьОбласть("ОсновныеРеквизиты");
	
	ОбластьДополнительныеРеквизитыШапка = Макет.ПолучитьОбласть("ДополнительныеРеквизитыШапка");
	ОбластьДополнительныеРеквизитыСтрока = Макет.ПолучитьОбласть("ДополнительныеРеквизитыСтрока");

	ОбластьКонтактнаяИнформацияШапка = Макет.ПолучитьОбласть("КонтактнаяИнформацияШапка");
	ОбластьКонтактнаяИнформацияСтрока = Макет.ПолучитьОбласть("КонтактнаяИнформацияСтрока");
	
	ОбластьКонтактныеЛицаШапка = Макет.ПолучитьОбласть("КонтактныеЛицаШапка");
	ОбластьКонтактныеЛицаСтрока	= Макет.ПолучитьОбласть("КонтактныеЛицаСтрока");
	ОбластьКонтактныеЛицаКонтактыСтрока = Макет.ПолучитьОбласть("КонтактныеЛицаКонтактыСтрока");
	
	// Получаем запросом необходимые данные
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	Контрагенты.Ссылка,
		|	Контрагенты.Наименование,
		|	Контрагенты.ГруппаДоступа,
		|	Контрагенты.ИНН,
		|	Контрагенты.КодПоОКПО,
		|	Контрагенты.Комментарий,
		|	Контрагенты.КПП,
		|	Контрагенты.ОсновнойБанковскийСчет,
		|	Контрагенты.Ответственный,
		|	Контрагенты.НаименованиеПолное,
		|	Контрагенты.ЮрФизЛицо
		|ИЗ
		|	Справочник.Контрагенты КАК Контрагенты
		|ГДЕ
		|	Контрагенты.Ссылка В(&МассивОбъектов)";
	Запрос.УстановитьПараметр("МассивОбъектов", МассивОбъектов);
	ВыборкаКонтрагенты = Запрос.Выполнить().Выбрать();
	
	Если ИспользоватьДополнительныеРеквизитыИСведения Тогда
		ЗапросДопРеквизиты = Новый Запрос;
		ЗапросДопРеквизиты.Текст = 
			"ВЫБРАТЬ
			|	КонтрагентыДополнительныеРеквизиты.Ссылка КАК Ссылка,
			|	КонтрагентыДополнительныеРеквизиты.Свойство КАК Свойство,
			|	КонтрагентыДополнительныеРеквизиты.Значение КАК Значение,
			|	КонтрагентыДополнительныеРеквизиты.ТекстоваяСтрока КАК ТекстоваяСтрока
			|ИЗ
			|	Справочник.Контрагенты.ДополнительныеРеквизиты КАК КонтрагентыДополнительныеРеквизиты
			|ГДЕ
			|	КонтрагентыДополнительныеРеквизиты.Ссылка В(&МассивОбъектов)";
		ЗапросДопРеквизиты.УстановитьПараметр("МассивОбъектов", МассивОбъектов);
		ВыборкаДопРеквизиты = ЗапросДопРеквизиты.Выполнить().Выбрать();
	КонецЕсли;
	
	ЗапросКонтактнаяИнформация = Новый Запрос;
	ЗапросКонтактнаяИнформация.Текст = 
		"ВЫБРАТЬ
		|	КонтрагентыКонтактнаяИнформация.Ссылка КАК Ссылка,
		|	КонтрагентыКонтактнаяИнформация.Вид КАК Вид,
		|	КонтрагентыКонтактнаяИнформация.Представление КАК Значение
		|ИЗ
		|	Справочник.Контрагенты.КонтактнаяИнформация КАК КонтрагентыКонтактнаяИнформация
		|ГДЕ
		|	КонтрагентыКонтактнаяИнформация.Ссылка В(&МассивОбъектов)";
	ЗапросКонтактнаяИнформация.УстановитьПараметр("МассивОбъектов", МассивОбъектов);
	ВыборкаКонтактнаяИнформация = ЗапросКонтактнаяИнформация.Выполнить().Выбрать();
	
	ЗапросКонтактныеЛица = Новый Запрос;
	ЗапросКонтактныеЛица.Текст = 
		"ВЫБРАТЬ
		|	КонтактныеЛица.Владелец КАК Владелец,
		|	КонтактныеЛица.Ссылка КАК Ссылка, 
		|	КонтактныеЛица.Должность КАК Должность,
		|	КонтактныеЛица.Наименование КАК ФИО
		|ИЗ
		|	Справочник.КонтактныеЛица КАК КонтактныеЛица
		|ГДЕ
		|	КонтактныеЛица.Владелец В(&МассивОбъектов)";
	ЗапросКонтактныеЛица.УстановитьПараметр("МассивОбъектов", МассивОбъектов);
	ВыборкаКонтактныеЛица = ЗапросКонтактныеЛица.Выполнить().Выбрать();
	
		
	ПервыйДокумент = Истина;
	Пока ВыборкаКонтрагенты.Следующий() Цикл
		
		Если Не ПервыйДокумент Тогда
			ТабличныйДокумент.ВывестиГоризонтальныйРазделительСтраниц();
		КонецЕсли;
		ПервыйДокумент = Ложь;
		
		// Запомним номер строки с которой начали выводить текущий документ
		НомерСтрокиНачало = ТабличныйДокумент.ВысотаТаблицы + 1;
		
		ОбластьЗаголовок.Параметры.Заполнить(ВыборкаКонтрагенты);
		ТабличныйДокумент.Вывести(ОбластьЗаголовок);
		
		ОбластьОсновныеРеквизиты.Параметры.Заполнить(ВыборкаКонтрагенты);
		ТабличныйДокумент.Вывести(ОбластьОсновныеРеквизиты);

		// Дополнительные реквизиты
		Если ИспользоватьДополнительныеРеквизитыИСведения Тогда
			
			ПервыйПоискДопРеквизита = Истина;
			ВыборкаДопРеквизиты.Сбросить();
			Пока ВыборкаДопРеквизиты.НайтиСледующий(ВыборкаКонтрагенты.Ссылка, "Ссылка") Цикл
				
				Если ПервыйПоискДопРеквизита Тогда
					ТабличныйДокумент.Вывести(ОбластьДополнительныеРеквизитыШапка);
					ПервыйПоискДопРеквизита = Ложь;
				КонецЕсли;
				
				ОбластьДополнительныеРеквизитыСтрока.Параметры.Свойство = ВыборкаДопРеквизиты.Свойство;
				
				Если ЗначениеЗаполнено(ВыборкаДопРеквизиты.ТекстоваяСтрока) Тогда 
					ЗначениеСвойства = ВыборкаДопРеквизиты.ТекстоваяСтрока;
				Иначе
					ЗначениеСвойства = ВыборкаДопРеквизиты.Значение;
				КонецЕсли;	
								
				ОбластьДополнительныеРеквизитыСтрока.Параметры.Значение = ЗначениеСвойства;
				
				ТабличныйДокумент.Вывести(ОбластьДополнительныеРеквизитыСтрока);
			КонецЦикла;	
		КонецЕсли;	
		
		// Контактная информация
		ПервоеПолучениеКонтактнойИнформации = Истина;
		Пока ВыборкаКонтактнаяИнформация.НайтиСледующий(ВыборкаКонтрагенты.Ссылка, "Ссылка") Цикл
			Если ПервоеПолучениеКонтактнойИнформации Тогда
				ТабличныйДокумент.Вывести(ОбластьКонтактнаяИнформацияШапка);
				ПервоеПолучениеКонтактнойИнформации = Ложь;
			КонецЕсли;
			ОбластьКонтактнаяИнформацияСтрока.Параметры.Заполнить(ВыборкаКонтактнаяИнформация);
			ТабличныйДокумент.Вывести(ОбластьКонтактнаяИнформацияСтрока);
		КонецЦикла;
		
		//Контактные лица
		ПервоеПолучениеКонтактныхЛиц = Истина;
		Пока ВыборкаКонтактныеЛица.НайтиСледующий(ВыборкаКонтрагенты.Ссылка, "Владелец") Цикл
			Если ПервоеПолучениеКонтактныхЛиц Тогда
				ТабличныйДокумент.Вывести(ОбластьКонтактныеЛицаШапка);
				ПервоеПолучениеКонтактныхЛиц = Ложь;
			КонецЕсли;
			ОбластьКонтактныеЛицаСтрока.Параметры.Заполнить(ВыборкаКонтактныеЛица);
			ТабличныйДокумент.Вывести(ОбластьКонтактныеЛицаСтрока);
			
			ЗапросКонтактыКонтактныхЛиц = Новый Запрос;
			ЗапросКонтактыКонтактныхЛиц.Текст = 
				"ВЫБРАТЬ
				|	КонтактныеЛицаКонтактнаяИнформация.Ссылка,
				|	КонтактныеЛицаКонтактнаяИнформация.Вид КАК ВидКонтактнойИнформации,
				|	КонтактныеЛицаКонтактнаяИнформация.Представление КАК ЗначениеКонтактнойИнформации
				|ИЗ
				|	Справочник.КонтактныеЛица.КонтактнаяИнформация КАК КонтактныеЛицаКонтактнаяИнформация
				|ГДЕ
				|	КонтактныеЛицаКонтактнаяИнформация.Ссылка = &КонтактноеЛицо";
			ЗапросКонтактыКонтактныхЛиц.УстановитьПараметр("КонтактноеЛицо", ВыборкаКонтактныеЛица.Ссылка);
			ВыборкаКонтактыЛиц = ЗапросКонтактыКонтактныхЛиц.Выполнить().Выбрать();
			Пока ВыборкаКонтактыЛиц.Следующий() Цикл
				ОбластьКонтактныеЛицаКонтактыСтрока.Параметры.Заполнить(ВыборкаКонтактыЛиц);
				ТабличныйДокумент.Вывести(ОбластьКонтактныеЛицаКонтактыСтрока);
			КонецЦикла;	
		КонецЦикла;
		
		// В табличном документе зададим имя области в которую был 
		// выведен объект. Нужно для возможности печати по-комплектно.
		УправлениеПечатью.ЗадатьОбластьПечатиДокумента(ТабличныйДокумент, НомерСтрокиНачало, ОбъектыПечати, ВыборкаКонтрагенты.Ссылка);
		
	КонецЦикла;
	
	Возврат ТабличныйДокумент;
	
КонецФункции

// ВерсионированиеОбъектов
Процедура ПриОпределенииНастроекВерсионированияОбъектов(Настройки) Экспорт

КонецПроцедуры
// Конец ВерсионированиеОбъектов

#КонецОбласти

#КонецЕсли