////////////////////////////////////////////////////////////////////////////////
// Подсистема "Пользователи".
//
////////////////////////////////////////////////////////////////////////////////

#Область СлужебныйПрограммныйИнтерфейс

// Содержит сохраненные параметры, используемые подсистемой.
Функция Параметры() Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	СохраненныеПараметры = СтандартныеПодсистемыСервер.ПараметрыРаботыПрограммы(
		"ПараметрыРаботыПользователей");
	УстановитьПривилегированныйРежим(Ложь);
	
	СтандартныеПодсистемыСервер.ПроверитьОбновлениеПараметровРаботыПрограммы(
		"ПараметрыРаботыПользователей",
		"НазначениеРолей,
		|ВсеРоли");
	
	ПредставлениеПараметра = "";
	
	Если НЕ СохраненныеПараметры.Свойство("НазначениеРолей") Тогда
		ПредставлениеПараметра = НСтр("ru = 'Недоступные роли'");
		
	ИначеЕсли НЕ СохраненныеПараметры.Свойство("ВсеРоли") Тогда
		ПредставлениеПараметра = НСтр("ru = 'Все роли'");
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ПредставлениеПараметра) Тогда
		ВызватьИсключение СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Ошибка обновления информационной базы.
			           |Не заполнен параметр работы пользователей:
			           |""%1"".'")
			+ СтандартныеПодсистемыСервер.УточнениеОшибкиПараметровРаботыПрограммыДляРазработчика(),
			ПредставлениеПараметра);
	КонецЕсли;
	
	Возврат СохраненныеПараметры;
	
КонецФункции

// Возвращает роли, недоступные для указанного назначения (с учетом или без учета модели сервиса).
//
// Параметры:
//  Назначение - Строка - "ДляАдминистраторов", "ДляПользователей", "ДляВнешнихПользователей",
//                        "СовместноДляПользователейИВнешнихПользователей".
//     
//  Сервис     - Неопределено - определить текущий режим автоматически.
//             - Булево       - Ложь   - для локального режима (недоступные роли только для назначения),
//                              Истина - для модели сервиса (включая роли неразделенных пользователей).
//
// Возвращаемое значение:
//  Соответствие - со свойствами:
//   * Ключ     - Строка - имя роли.
//   * Значение - Булево - Истина.
//
Функция НедоступныеРоли(Назначение = "ДляПользователей", Сервис = Неопределено) Экспорт
	
	ПроверитьНазначение(Назначение,
		НСтр("ru = 'Ошибка в функции НедоступныеРоли общего модуля ПользователиСлужебныйПовтИсп.'"));
	
	Если Сервис = Неопределено Тогда
		Сервис = ОбщегоНазначенияПовтИсп.РазделениеВключено();
	КонецЕсли;
	
	НазначениеРолей = ПользователиСлужебныйПовтИсп.Параметры().НазначениеРолей;
	НедоступныеРоли = Новый Соответствие;
	
	Для Каждого Роль Из Метаданные.Роли Цикл
		Если Назначение <> "ДляАдминистраторов"
		   И НазначениеРолей.ТолькоДляАдминистраторовСистемы.Получить(Роль.Имя) <> Неопределено
		 // Для внешних пользователей.
		 Или Назначение = "ДляВнешнихПользователей"
		   И НазначениеРолей.ТолькоДляВнешнихПользователей.Получить(Роль.Имя) = Неопределено
		   И НазначениеРолей.СовместноДляПользователейИВнешнихПользователей.Получить(Роль.Имя) = Неопределено
		 // Для пользователей.
		 Или (Назначение = "ДляПользователей" Или Назначение = "ДляАдминистраторов")
		   И НазначениеРолей.ТолькоДляВнешнихПользователей.Получить(Роль.Имя) <> Неопределено
		 // Совместно для пользователей и внешних пользователей.
		 Или Назначение = "СовместноДляПользователейИВнешнихПользователей"
		   И Не НазначениеРолей.СовместноДляПользователейИВнешнихПользователей.Получить(Роль.Имя) <> Неопределено
		 // С учетом модели сервиса.
		 Или Сервис
		   И НазначениеРолей.ТолькоДляПользователейСистемы.Получить(Роль.Имя) <> Неопределено Тогда
			
			НедоступныеРоли.Вставить(Роль.Имя, Истина);
		КонецЕсли;
	КонецЦикла;
	
	Возврат НедоступныеРоли;
	
КонецФункции

// См. комментарий к одноименной процедуре в модуле ПользователиКлиентСервер.
Функция ЭтоСеансВнешнегоПользователя() Экспорт
	
	Если ОбщегоНазначенияПовтИсп.РазделениеВключено()
	   И ОбщегоНазначенияПовтИсп.СеансЗапущенБезРазделителей() Тогда
		// Неразделенные пользователи не могут быть внешними.
		Возврат Ложь;
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Истина);
	
	ПользовательИБ = ПользователиИнформационнойБазы.ТекущийПользователь();
	ИдентификаторПользователяИБ = ПользовательИБ.УникальныйИдентификатор;
	
	Пользователи.НайтиНеоднозначныхПользователейИБ(Неопределено, ИдентификаторПользователяИБ);
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ИдентификаторПользователяИБ", ИдентификаторПользователяИБ);
	
	Запрос.Текст =
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	ИСТИНА КАК ЗначениеИстина
	|ИЗ
	|	Справочник.ВнешниеПользователи КАК ВнешниеПользователи
	|ГДЕ
	|	ВнешниеПользователи.ИдентификаторПользователяИБ = &ИдентификаторПользователяИБ";
	
	// Пользователь, который не найден в справочнике ВнешниеПользователи не может быть внешним.
	Возврат Не Запрос.Выполнить().Пустой();
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Настройки работы подсистемы Пользователи.
// См. также описание процедуры ПриОпределенииНастроек в общем модуле ПользователиПереопределяемый.
//
// Возвращаемое значение:
//  Структура - со свойствами:
//   * ОбщиеНастройкиВхода - Булево - если Ложь,
//          тогда в панели администрирования "Настройки прав и пользователей" возможность
//          открытия формы настроек входа будет скрыта, как и поле СрокДействия в карточках
//          пользователя и внешнего пользователя.
//
//   * РедактированиеРолей - Булево - если Ложь, тогда
//          интерфейс изменения ролей в карточках пользователя, внешнего пользователя и
//          группы внешних пользователей будет скрыт (в том числе для администратора).
//
//   * ВнешниеПользователи - Структура - со свойствами, как у свойства Пользователи (см. далее).
//   * Пользователи - Структура - со свойствами:
//
//     * ПарольДолженОтвечатьТребованиямСложности   - Булево - проверять сложность нового пароля.
//     * МинимальнаяДлинаПароля                     - Число - проверять длину нового пароля.
//
//     * МаксимальныйСрокДействияПароля             - Число - дней после первого входа с новым паролем, после
//                                                            которого пользователю потребуется сменить пароль.
//     * МинимальныйСрокДействияПароля              - Число - дней после первого входа с новым паролем, в течение
//                                                            которого пользователь не сможет сменить пароль.
//     * ЗапретитьПовторениеПароляСредиПоследних    - Число - паролей, хеши которых будут храниться для проверки.
//
//     * ПросрочкаРаботыВПрограммеДоЗапрещенияВхода - Число - дней относительно последней активности пользователя,
//                                                            после которых вход в программу будет запрещен.
//     * ПросрочкаРаботыВПрограммеДатаВключения     - Дата  - момент записи ненулевого количества дней
//                                                            просрочки вместо нулевого.
//
Функция Настройки() Экспорт
	
	Настройки = Новый Структура;
	Настройки.Вставить("ОбщиеНастройкиВхода", Истина);
	Настройки.Вставить("РедактированиеРолей", Истина);
	
	ИнтеграцияСтандартныхПодсистем.ПриОпределенииНастроек(Настройки);
	ПользователиПереопределяемый.ПриОпределенииНастроек(Настройки);
	
	Если ОбщегоНазначенияПовтИсп.РазделениеВключено()
	 Или СтандартныеПодсистемыСервер.ЭтоБазоваяВерсияКонфигурации()
	 Или ОбщегоНазначенияПовтИсп.ЭтоАвтономноеРабочееМесто() Тогда
		
		Настройки.Вставить("ОбщиеНастройкиВхода", Ложь);
	КонецЕсли;
	
	ВсеНастройки = ПользователиСлужебный.НастройкиВхода();
	ВсеНастройки.Вставить("ОбщиеНастройкиВхода", Настройки.ОбщиеНастройкиВхода);
	ВсеНастройки.Вставить("РедактированиеРолей", Настройки.РедактированиеРолей);
	
	Возврат ВсеНастройки;
	
КонецФункции

// Возвращает дерево ролей с подсистемами или без них.
// Если роль не принадлежит ни одной подсистеме она добавляется "в корень".
// 
// Параметры:
//  ПоПодсистемам - Булево, если Ложь, все роли добавляются в "корень".
//  Назначение    - Строка - "ДляАдминистраторов", "ДляПользователей", "ДляВнешнихПользователей",
//                           "СовместноДляПользователейИВнешнихПользователей".
// 
// Возвращаемое значение:
//  ДеревоЗначений с колонками:
//    ЭтоРоль - Булево
//    Имя     - Строка - имя     роли или подсистемы.
//    Синоним - Строка - синоним роли или подсистемы.
//    Роль       - СправочникСсылка.ИдентификаторыОбъектовМетаданных,
//                 для подсистемы - пустая ссылка
//
Функция ДеревоРолей(ПоПодсистемам = Истина, Назначение = "ДляПользователей") Экспорт
	
	ПроверитьНазначение(Назначение,
		НСтр("ru = 'Ошибка в функции ДеревоРолей общего модуля ПользователиСлужебныйПовтИсп.'"));
	
	НедоступныеРоли = ПользователиСлужебныйПовтИсп.НедоступныеРоли(Назначение);
	
	Дерево = Новый ДеревоЗначений;
	Дерево.Колонки.Добавить("ЭтоРоль", Новый ОписаниеТипов("Булево"));
	Дерево.Колонки.Добавить("Имя",     Новый ОписаниеТипов("Строка"));
	Дерево.Колонки.Добавить("Синоним", Новый ОписаниеТипов("Строка", , Новый КвалификаторыСтроки(1000)));
	Дерево.Колонки.Добавить("Роль",    Новый ОписаниеТипов("СправочникСсылка.ИдентификаторыОбъектовМетаданных"));
	
	Если ПоПодсистемам Тогда
		ЗаполнитьПодсистемыИРоли(Дерево.Строки, , НедоступныеРоли);
	КонецЕсли;
	
	// Добавление ненайденных ролей.
	Для Каждого Роль Из Метаданные.Роли Цикл
		
		Если НедоступныеРоли.Получить(Роль.Имя) <> Неопределено
		 Или ВРег(Лев(Роль.Имя, СтрДлина("Удалить"))) = ВРег("Удалить") Тогда
			
			Продолжить;
		КонецЕсли;
		
		Отбор = Новый Структура("ЭтоРоль, Имя", Истина, Роль.Имя);
		Если Дерево.Строки.НайтиСтроки(Отбор, Истина).Количество() = 0 Тогда
			СтрокаДерева = Дерево.Строки.Добавить();
			СтрокаДерева.ЭтоРоль       = Истина;
			СтрокаДерева.Имя           = Роль.Имя;
			СтрокаДерева.Синоним       = ?(ЗначениеЗаполнено(Роль.Синоним), Роль.Синоним, Роль.Имя);
			СтрокаДерева.Роль		   = ОбщегоНазначения.ИдентификаторОбъектаМетаданных(Роль);
		КонецЕсли;
	КонецЦикла;
	
	Дерево.Строки.Сортировать("ЭтоРоль Убыв, Синоним Возр", Истина);
	
	Возврат Дерево;
	
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// Вспомогательные процедуры и функции.

Процедура ЗаполнитьПодсистемыИРоли(КоллекцияСтрокДерева, Подсистемы, НедоступныеРоли, ВсеРоли = Неопределено)
	
	Если Подсистемы = Неопределено Тогда
		Подсистемы = Метаданные.Подсистемы;
	КонецЕсли;
	
	Если ВсеРоли = Неопределено Тогда
		ВсеРоли = Новый Соответствие;
		Для Каждого Роль Из Метаданные.Роли Цикл
			
			Если НедоступныеРоли.Получить(Роль.Имя) <> Неопределено
			 Или ВРег(Лев(Роль.Имя, СтрДлина("Удалить"))) = ВРег("Удалить") Тогда
			
				Продолжить;
			КонецЕсли;
			ВсеРоли.Вставить(Роль, Истина);
		КонецЦикла;
	КонецЕсли;
	
	Для Каждого Подсистема Из Подсистемы Цикл
		
		ОписаниеПодсистемы = КоллекцияСтрокДерева.Добавить();
		ОписаниеПодсистемы.Имя     = Подсистема.Имя;
		ОписаниеПодсистемы.Синоним = ?(ЗначениеЗаполнено(Подсистема.Синоним), Подсистема.Синоним, Подсистема.Имя);
		
		ЗаполнитьПодсистемыИРоли(ОписаниеПодсистемы.Строки, Подсистема.Подсистемы, НедоступныеРоли, ВсеРоли);
		
		Для Каждого ОбъектМетаданных Из Подсистема.Состав Цикл
			Если ВсеРоли[ОбъектМетаданных] = Неопределено Тогда
				Продолжить;
			КонецЕсли;
			Роль = ОбъектМетаданных;
			ОписаниеРоли = ОписаниеПодсистемы.Строки.Добавить();
			ОписаниеРоли.ЭтоРоль = Истина;
			ОписаниеРоли.Имя     = Роль.Имя;
			ОписаниеРоли.Синоним = ?(ЗначениеЗаполнено(Роль.Синоним), Роль.Синоним, Роль.Имя);
			ОписаниеРоли.Роль    = ОбщегоНазначения.ИдентификаторОбъектаМетаданных(Роль);
		КонецЦикла;
		
		Отбор = Новый Структура("ЭтоРоль", Истина);
		Если ОписаниеПодсистемы.Строки.НайтиСтроки(Отбор, Истина).Количество() = 0 Тогда
			КоллекцияСтрокДерева.Удалить(ОписаниеПодсистемы);
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

Процедура ПроверитьНазначение(Назначение, ЗаголовокОшибки)
	
	Если Назначение <> "ДляАдминистраторов"
	   И Назначение <> "ДляПользователей"
	   И Назначение <> "ДляВнешнихПользователей"
	   И Назначение <> "СовместноДляПользователейИВнешнихПользователей" Тогда
		
		ВызватьИсключение ЗаголовокОшибки + Символы.ПС + Символы.ПС + СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Параметр Назначение ""%1"" указан некорректно.
			           |
			           |Допустимы только следующие значения:
			           |- ""ДляАдминистраторов"",
			           |- ""ДляПользователей"",
			           |- ""ДляВнешнихПользователей"",
			           |- ""СовместноДляПользователейИВнешнихПользователей"".'"),
			Назначение);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
