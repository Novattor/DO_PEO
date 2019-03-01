#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	Если Не ЭлектроннаяПодпись.ИспользоватьЭлектронныеПодписи()
		И ЭлектроннаяПодпись.ИспользоватьШифрование() Тогда
		
		Элементы.ПодписанЭП.Видимость = Ложь;
	КонецЕсли;
	
	УсловноеОформление.Элементы.Очистить();
	РаботаСФайламиСлужебныйВызовСервера.ЗаполнитьУсловноеОформлениеСпискаФайлов(Список);
	
	Список.Параметры.УстановитьЗначениеПараметра("Проект", Параметры.Проект);
	
	ТекущийПользователь = ПользователиКлиентСервер.ТекущийПользователь();
	Список.Параметры.УстановитьЗначениеПараметра("ТекущийПользователь", ТекущийПользователь);
	
	ТекущаяПапка = Неопределено;
	Элементы.Папки.ТекущаяСтрока = ТекущаяПапка;
	Список.Параметры.УстановитьЗначениеПараметра("Владелец", Элементы.Папки.ТекущаяСтрока);
	
	ВидПросмотра = Перечисления.ВидыПросмотраСпискаОбъектов.Списком;
	ПереключитьВидПросмотра();
	
	ИзменитьОтображениеУдаленныхФайлов(ПоказыватьУдаленныеФайлы, Список, Папки, 
		Элементы.ФормаПоказыватьУдаленныеФайлы);
	
КонецПроцедуры

&НаСервере
Процедура ПриЗагрузкеДанныхИзНастроекНаСервере(Настройки)
	
	ТекущаяПапка = Настройки["ТекущаяПапка"];
	Элементы.Папки.ТекущаяСтрока = ТекущаяПапка;
	
	Если Элементы.Папки.ТекущаяСтрока <> Неопределено Тогда
		Список.Параметры.УстановитьЗначениеПараметра("Владелец", Элементы.Папки.ТекущаяСтрока);
	КонецЕсли;
	
	ВидПросмотра = Настройки["ВидПросмотра"];
	ПереключитьВидПросмотра();
	
	Если Настройки["ПоказыватьУдаленныеФайлы"] <> Неопределено Тогда
		
		ИзменитьОтображениеУдаленныхФайлов(ПоказыватьУдаленныеФайлы, Список, Папки, 
			Элементы.ФормаПоказыватьУдаленныеФайлы);
			
	КонецЕсли;	
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура ИзменитьОтображениеУдаленныхФайлов(ПоказыватьУдаленныеФайлы, Список, Папки,
	ЭлементФормаПоказыватьУдаленныеФайлы)
	
	Если Не ПоказыватьУдаленныеФайлы Тогда
		
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
			Список, "ПометкаУдаления", Ложь,
			ВидСравненияКомпоновкиДанных.Равно, , Не ПоказыватьУдаленныеФайлы);
			
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
			Папки, "ПометкаУдаления", Ложь,
			ВидСравненияКомпоновкиДанных.Равно, , Не ПоказыватьУдаленныеФайлы);
			
	Иначе		
		ОбщегоНазначенияКлиентСервер.УдалитьЭлементыГруппыОтбораДинамическогоСписка(Список, "ПометкаУдаления");
		ОбщегоНазначенияКлиентСервер.УдалитьЭлементыГруппыОтбораДинамическогоСписка(Папки, "ПометкаУдаления");
	КонецЕсли;	
	
	ЭлементФормаПоказыватьУдаленныеФайлы.Пометка = ПоказыватьУдаленныеФайлы;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "Запись_Файл" И Параметр.Событие = "СозданФайл" Тогда
		Элементы.Список.Обновить();
	КонецЕсли;
	
	Если ИмяСобытия = "ИмпортФайловЗавершен" Тогда
		Элементы.Список.Обновить();
		
		Если Параметр <> Неопределено Тогда
			Элементы.Список.ТекущаяСтрока = Параметр;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСписок
&НаКлиенте
Процедура СписокВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	Если ТипЗнч(ВыбраннаяСтрока) = Тип("СтрокаГруппировкиДинамическогоСписка") Тогда
		Возврат;
	КонецЕсли;	
	
	СтандартнаяОбработка = Ложь;
	
	КакОткрывать = ФайловыеФункцииКлиентПовтИсп.ПолучитьПерсональныеНастройкиРаботыСФайлами().ДействиеПоДвойномуЩелчкуМыши;
	
	Если КакОткрывать = "ОткрыватьКарточку" Тогда
		ПоказатьЗначение(,ВыбраннаяСтрока);
		Возврат;
	КонецЕсли;
	
	ФайловыеФункцииКлиент.ПроинициализироватьПутьКРабочемуКаталогу();
	ИмяКаталога = ФайловыеФункцииКлиентПовтИсп.ПолучитьПерсональныеНастройкиРаботыСФайлами().ПутьКЛокальномуКэшуФайлов;
	Если ИмяКаталога = Неопределено ИЛИ ПустаяСтрока(ИмяКаталога) Тогда
		Возврат;
	КонецЕсли;
	
	ДанныеФайла = РаботаСФайламиВызовСервера.ДанныеФайлаДляОткрытия(ВыбраннаяСтрока, 
		Неопределено, УникальныйИдентификатор, Неопределено, ПредыдущийАдресФайла);
	
	ПараметрыОбработчика = Новый Структура;
	ПараметрыОбработчика.Вставить("ДанныеФайла", ДанныеФайла);
	Обработчик = Новый ОписаниеОповещения("СписокВыборПослеВыбораРежимаРедактирования", ЭтотОбъект, ПараметрыОбработчика);
	
	РаботаСФайламиКлиент.ВыбратьРежимИРедактироватьФайл(Обработчик, ДанныеФайла, Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура СписокВыборПослеВыбораРежимаРедактирования(Результат, ПараметрыВыполнения) Экспорт
	
	РезультатОткрыть = "Открыть";
	РезультатРедактировать = "Редактировать";
	РезультатОткрытьКарточку = "ОткрытьКарточку";
	
	Если Результат = РезультатРедактировать Тогда
		Обработчик = Новый ОписаниеОповещения("СписокВыборПослеРедактированияФайла", ЭтотОбъект, ПараметрыВыполнения);
		РаботаСФайламиКлиент.РедактироватьФайл(Обработчик, ПараметрыВыполнения.ДанныеФайла);
	ИначеЕсли Результат = РезультатОткрыть Тогда
		РаботаСФайламиКлиент.ОткрытьФайлСОповещением(Неопределено, ПараметрыВыполнения.ДанныеФайла, УникальныйИдентификатор); 
	ИначеЕсли Результат = РезультатОткрытьКарточку Тогда
		ПоказатьЗначение(, ПараметрыВыполнения.ДанныеФайла.Ссылка);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СписокВыборПослеРедактированияФайла(Результат, ПараметрыВыполнения) Экспорт
	
	ОповеститьОбИзменении(ПараметрыВыполнения.ДанныеФайла.Ссылка);
	
КонецПроцедуры

&НаКлиенте
Процедура СписокПриАктивизацииСтроки(Элемент)
	
	УстановитьДоступностьФайловыхКоманд();
	
КонецПроцедуры

&НаКлиенте
Процедура СписокПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа)
	
	Отказ = Истина;
	
	Если ВидПросмотра = ПредопределенноеЗначение("Перечисление.ВидыПросмотраСпискаОбъектов.ПоПапкам") Тогда
		Если Не ЗначениеЗаполнено(Элементы.Папки.ТекущаяСтрока) Тогда
			Возврат;
		КонецЕсли;
		ВладелецФайла = Элементы.Папки.ТекущаяСтрока;
	ИначеЕсли Не Копирование Тогда
		РежимОткрытия = РежимОткрытияОкнаФормы.БлокироватьВесьИнтерфейс;
		Обработчик = Новый ОписаниеОповещения("СоздатьФайлПослеВыбораПапки", ЭтотОбъект);
		ОткрытьФорму("Справочник.ПапкиФайлов.ФормаВыбора", , ЭтаФорма,,,,Обработчик, РежимОткрытия);
		Возврат;
	КонецЕсли;

	Если Не Копирование Тогда
		Попытка
			РаботаСФайламиКлиент.ДобавитьФайл(Неопределено, ВладелецФайла, ЭтотОбъект);
		Исключение
			ПоказатьПредупреждение(, ФайловыеФункцииСлужебныйКлиентСервер.ОшибкаСозданияНовогоФайла(
				ИнформацияОбОшибке()));
		КонецПопытки;
	Иначе
		ФайлОснование = Элементы.Список.ТекущаяСтрока;
		РаботаСФайламиКлиент.СкопироватьФайл(ВладелецФайла, ФайлОснование);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СписокПередНачаломИзменения(Элемент, Отказ)
	
	Отказ = Истина;
	
	ПараметрыОткрытияФормы = Новый Структура("Ключ", Элемент.ТекущаяСтрока);
	ОткрытьФорму("Справочник.Файлы.ФормаОбъекта", ПараметрыОткрытияФормы);
	
КонецПроцедуры

&НаКлиенте
Процедура СписокПроверкаПеретаскивания(Элемент, ПараметрыПеретаскивания, СтандартнаяОбработка, Строка, Поле)
	
	СтандартнаяОбработка = Ложь;
	
КонецПроцедуры

&НаКлиенте
Процедура СписокПеретаскивание(Элемент, ПараметрыПеретаскивания, СтандартнаяОбработка, Строка, Поле)
	
	СтандартнаяОбработка = Ложь;
	Обработчик = Новый ОписаниеОповещения("СписокПеретаскиваниеПослеВыбораПапки", ЭтотОбъект,
		Новый Структура("ПараметрыПеретаскивания", ПараметрыПеретаскивания));
	
	Если ВидПросмотра = ПредопределенноеЗначение("Перечисление.ВидыПросмотраСпискаОбъектов.ПоПапкам") Тогда
		Если Не ЗначениеЗаполнено(Элементы.Папки.ТекущаяСтрока) Тогда
			Возврат;
		КонецЕсли;
		ВладелецФайла = Элементы.Папки.ТекущаяСтрока;
		ВыполнитьОбработкуОповещения(Обработчик, ВладелецФайла);
		
	Иначе
		РежимОткрытия = РежимОткрытияОкнаФормы.БлокироватьВесьИнтерфейс;
		ОткрытьФорму("Справочник.ПапкиФайлов.ФормаВыбора", , ЭтаФорма,,,,Обработчик, РежимОткрытия);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СоздатьФайлПослеВыбораПапки(РезультатВыполнения, ПараметрыВыполнения) Экспорт
	
	Если Не ЗначениеЗаполнено(РезультатВыполнения) Тогда
		НСтрока = НСтр("ru = 'Для создания файла необходимо выбрать папку.'");
		ПоказатьПредупреждение(,НСтрока);	
		Возврат;
	КонецЕсли;
				
	Попытка
		РаботаСФайламиКлиент.ДобавитьФайл(Неопределено, РезультатВыполнения, ЭтотОбъект);
	Исключение
		ПоказатьПредупреждение(, ФайловыеФункцииСлужебныйКлиентСервер.ОшибкаСозданияНовогоФайла(
			ИнформацияОбОшибке()));
	КонецПопытки;
	
КонецПроцедуры

&НаКлиенте
Процедура СписокПеретаскиваниеПослеВыбораПапки(РезультатВыполнения, ПараметрыВыполнения) Экспорт
	
	ВладелецФайлаСписка = РезультатВыполнения;
	
	Если ВладелецФайлаСписка = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	РаботаСФайламиКлиент.ОбработкаПеретаскиванияВЛинейныйСписок(ПараметрыВыполнения.ПараметрыПеретаскивания,
		ВладелецФайлаСписка, ЭтаФорма);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыПапки

&НаКлиенте
Процедура ПапкиПриАктивизацииСтроки(Элемент)
	
	Если ВидПросмотра = ПредопределенноеЗначение("Перечисление.ВидыПросмотраСпискаОбъектов.ПоПапкам") Тогда 
	
		Если Не ЗначениеЗаполнено(Элементы.Папки.ТекущаяСтрока) Тогда
			Элементы.СоздатьФайл.Доступность = Ложь;
		Иначе
			Элементы.СоздатьФайл.Доступность = Истина;
		КонецЕсли;
	
		Если ТекущаяПапка <> Элементы.Папки.ТекущаяСтрока Тогда
			ТекущаяПапка = Элементы.Папки.ТекущаяСтрока;
			ПодключитьОбработчикОжидания("ОбработкаОжидания", 0.2, Истина);
		КонецЕсли;
	
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОткрытьФайлВыполнить(Команда)
	
	ТекущаяСтрока = ПолучитьТекущуюСтроку();
	Если ТекущаяСтрока = Неопределено Тогда 
		Возврат;
	КонецЕсли;
	
	ДанныеФайла = РаботаСФайламиВызовСервера.ДанныеФайлаДляОткрытия(ТекущаяСтрока, 
		Неопределено, УникальныйИдентификатор, Неопределено, ПредыдущийАдресФайла);
	КомандыРаботыСФайламиКлиент.Открыть(ДанныеФайла);
	
КонецПроцедуры

&НаКлиенте
Процедура Редактировать(Команда)
	
	ТекущаяСтрока = ПолучитьТекущуюСтроку();
	Если ТекущаяСтрока = Неопределено Тогда 
		Возврат;
	КонецЕсли;
	
	Обработчик = Новый ОписаниеОповещения("УстановитьДоступностьФайловыхКоманд", ЭтотОбъект);
	РаботаСФайламиКлиент.РедактироватьСОповещением(Обработчик, ТекущаяСтрока);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗакончитьРедактирование(Команда)
	
	ТекущиеДанные = ПолучитьТекущиеДанные();
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Обработчик = Новый ОписаниеОповещения("УстановитьДоступностьФайловыхКоманд", ЭтотОбъект);
	
	ПараметрыОбновленияФайла = РаботаСФайламиКлиент.ПараметрыОбновленияФайла(Неопределено, 
		ТекущиеДанные.Ссылка, ЭтаФорма.УникальныйИдентификатор);
	ПараметрыОбновленияФайла.ХранитьВерсии = ТекущиеДанные.ХранитьВерсии;
	ПараметрыОбновленияФайла.РедактируетТекущийПользователь = ТекущиеДанные.РедактируетТекущийПользователь;
	ПараметрыОбновленияФайла.Редактирует = ТекущиеДанные.Редактирует;
	ПараметрыОбновленияФайла.Кодировка = ТекущиеДанные.Кодировка;
	ПараметрыОбновленияФайла.АвторТекущейВерсии = ТекущиеДанные.Автор;
	РаботаСФайламиКлиент.ЗакончитьРедактированиеСОповещением(ПараметрыОбновленияФайла);
		
КонецПроцедуры

&НаКлиенте
Процедура Напечатать(Команда)
	
	#Если ВебКлиент Тогда 
		ПоказатьПредупреждение(, НСтр("ru = 'В Веб-клиенте печать файлов не поддерживается.'"));
		Возврат;
	#КонецЕсли
	
	СистемнаяИнфо = Новый СистемнаяИнформация;
	Если СистемнаяИнфо.ТипПлатформы <> ТипПлатформы.Windows_x86 
	   И СистемнаяИнфо.ТипПлатформы <> ТипПлатформы.Windows_x86_64 Тогда
		ПоказатьПредупреждение(, НСтр("ru = 'Печать файлов возможна только в Windows.'"));
		Возврат;
	КонецЕсли;
	
	ТекущаяСтрока = ПолучитьТекущуюСтроку();
	Если ТекущаяСтрока = Неопределено Тогда 
		Возврат;
	КонецЕсли; 
	
	ВыделенныеСтроки = Элементы.Список.ВыделенныеСтроки;
	Если ВыделенныеСтроки.Количество() > 1 Тогда
		ДанныеФайлов = РаботаСФайламиВызовСервера.ДанныеФайловДляОткрытия(
			ВыделенныеСтроки, 
			ЭтаФорма.УникальныйИдентификатор);
				
		КомандыРаботыСФайламиКлиент.НапечататьФайлы(ДанныеФайлов);
	Иначе
		ДанныеФайла = РаботаСФайламиВызовСервера.ДанныеФайлаДляОткрытия(
			ТекущаяСтрока, 
			Неопределено, 
			УникальныйИдентификатор, 
			Неопределено, 
			ПредыдущийАдресФайла);
		
		КомандыРаботыСФайламиКлиент.НапечататьФайл(ДанныеФайла);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура Занять(Команда)
	
	ТекущаяСтрока = ПолучитьТекущуюСтроку();
	Если ТекущаяСтрока = Неопределено Тогда 
		Возврат;
	КонецЕсли;

	Обработчик = Новый ОписаниеОповещения("УстановитьДоступностьФайловыхКоманд", ЭтотОбъект);
	РаботаСФайламиКлиент.ЗанятьСОповещением(Обработчик, ТекущаяСтрока);
	
КонецПроцедуры

&НаКлиенте
Процедура Освободить(Команда)
	
	ТекущиеДанные = ПолучитьТекущиеДанные();
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Обработчик = Новый ОписаниеОповещения("УстановитьДоступностьФайловыхКоманд", ЭтотОбъект);
	
	ПараметрыОсвобожденияФайла = РаботаСФайламиКлиент.ПараметрыОсвобожденияФайла(Обработчик, 
		ТекущиеДанные.Ссылка);
	ПараметрыОсвобожденияФайла.ХранитьВерсии = ТекущиеДанные.ХранитьВерсии;	
	ПараметрыОсвобожденияФайла.РедактируетТекущийПользователь = ТекущиеДанные.РедактируетТекущийПользователь;	
	ПараметрыОсвобожденияФайла.Редактирует = ТекущиеДанные.Редактирует;	
	РаботаСФайламиКлиент.ОсвободитьФайлСОповещением(ПараметрыОсвобожденияФайла);

КонецПроцедуры

&НаКлиенте
Процедура СохранитьИзменения(Команда)
	
	ТекущаяСтрока = ПолучитьТекущуюСтроку();
	Если ТекущаяСтрока = Неопределено Тогда 
		Возврат;
	КонецЕсли;
	
	Обработчик = Новый ОписаниеОповещения("УстановитьДоступностьФайловыхКоманд", ЭтотОбъект);
	
	РаботаСФайламиКлиент.СохранитьИзмененияФайлаСОповещением(
		Обработчик,
		ТекущаяСтрока,
		УникальныйИдентификатор);
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьКаталогФайла(Команда)
	
	ТекущаяСтрока = ПолучитьТекущуюСтроку();
	Если ТекущаяСтрока = Неопределено Тогда 
		Возврат;
	КонецЕсли;
	
	ДанныеФайла = РаботаСФайламиВызовСервера.ДанныеФайлаДляОткрытия(
		ТекущаяСтрока, 
		Неопределено, 
		УникальныйИдентификатор, 
		Неопределено, 
		ПредыдущийАдресФайла);
		
	КомандыРаботыСФайламиКлиент.ОткрытьКаталогФайла(ДанныеФайла);
	
КонецПроцедуры

&НаКлиенте
Процедура СохранитьКак(Команда)
	
	ТекущаяСтрока = ПолучитьТекущуюСтроку();
	Если ТекущаяСтрока = Неопределено Тогда 
		Возврат;
	КонецЕсли; 
	
	ВыделенныеСтроки = Элементы.Список.ВыделенныеСтроки;
	Если ВыделенныеСтроки.Количество() > 1 Тогда
		
		СписокФайловДляВыгрузки = Новый СписокЗначений;
		Для Каждого ВыбраннаяСтрока Из ВыделенныеСтроки Цикл
			ДанныеСтроки = Элементы.Список.ДанныеСтроки(ВыбраннаяСтрока);	
			СписокФайловДляВыгрузки.Добавить(ДанныеСтроки.Ссылка);
		КонецЦикла;
		
		Если СписокФайловДляВыгрузки.Количество() > 0 Тогда
			РаботаСФайламиКлиент.СохранитьФайлыКак(СписокФайловДляВыгрузки, УникальныйИдентификатор);
		КонецЕсли;
		
	Иначе
		
		ДанныеФайла = РаботаСФайламиВызовСервера.ДанныеФайлаДляСохранения(
			ТекущаяСтрока, Неопределено, УникальныйИдентификатор);
		КомандыРаботыСФайламиКлиент.СохранитьКак(ДанныеФайла, УникальныйИдентификатор);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьИзФайлаНаДиске(Команда)
	
	ТекущаяСтрока = ПолучитьТекущуюСтроку();
	Если ТекущаяСтрока = Неопределено Тогда 
		Возврат;
	КонецЕсли; 
	
	ДанныеФайла = РаботаСФайламиВызовСервера.ДанныеФайлаИРабочийКаталог(ТекущаяСтрока);
	
	РаботаСФайламиКлиент.ОбновитьИзФайлаНаДискеСОповещением(
		Неопределено,
		ДанныеФайла,
		УникальныйИдентификатор);
	
КонецПроцедуры

&НаКлиенте
Процедура ПеренестиВПапку(Команда)
	
	ТекущаяСтрока = ПолучитьТекущуюСтроку();
	Если ТекущаяСтрока = Неопределено Тогда 
		Возврат;
	КонецЕсли; 
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("Заголовок",     НСтр("ru = 'Выбор папки'"));
	ПараметрыФормы.Вставить("ТекущаяПапка",  Элементы.Папки.ТекущаяСтрока);
	ПараметрыФормы.Вставить("РежимВыбора",   Истина);
	ПараметрыФормы.Вставить("ПереносВПапку", Истина);
	
	ОткрытьФорму("Справочник.ПапкиФайлов.ФормаВыбора", ПараметрыФормы, ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура Подписать(Команда)
	
	ТекущаяСтрока = ПолучитьТекущуюСтроку();
	Если ТекущаяСтрока = Неопределено Тогда 
		Возврат;
	КонецЕсли; 
	
	МассивФайлов = Новый Массив;
	МассивФайлов.Добавить(ТекущаяСтрока);
	
	РаботаСФайламиСлужебныйКлиент.ПодписатьФайл(МассивФайлов, УникальныйИдентификатор,
		Новый ОписаниеОповещения("ПодписатьЗавершение", ЭтотОбъект));
	
КонецПроцедуры

&НаКлиенте
Процедура ПодписатьЗавершение(Результат, ПараметрыВыполнения) Экспорт
	
	Если Не Результат Тогда
		Возврат;
	КонецЕсли;
	
	ОповеститьОбИзменении(ПараметрыВыполнения.ДанныеФайла.Ссылка);	
	Оповестить("ПрисоединенныйФайлПодписан", ПараметрыВыполнения.ДанныеФайла.Владелец);
	УстановитьДоступностьФайловыхКоманд();
	
КонецПроцедуры

&НаКлиенте
Процедура ДобавитьЭПИзФайла(Команда)
	
	ТекущаяСтрока = ПолучитьТекущуюСтроку();
	Если ТекущаяСтрока = Неопределено Тогда 
		Возврат;
	КонецЕсли; 
	
	РаботаСФайламиСлужебныйКлиент.ДобавитьПодписьИзФайла(
		ТекущаяСтрока,
		УникальныйИдентификатор,
		Новый ОписаниеОповещения("УстановитьДоступностьФайловыхКоманд", ЭтотОбъект));
	
КонецПроцедуры

&НаКлиенте
Процедура СохранитьВместеСЭП(Команда)
	
	ТекущаяСтрока = ПолучитьТекущуюСтроку();
	Если ТекущаяСтрока = Неопределено Тогда 
		Возврат;
	КонецЕсли; 
	
	РаботаСФайламиСлужебныйКлиент.СохранитьФайлВместеСПодписью(ТекущаяСтрока, УникальныйИдентификатор);
	
КонецПроцедуры

&НаКлиенте
Процедура Зашифровать(Команда)
	
	ТекущаяСтрока = ПолучитьТекущуюСтроку();
	Если ТекущаяСтрока = Неопределено Тогда 
		Возврат;
	КонецЕсли; 
	
	ОбъектСсылка = ТекущаяСтрока;
	ДанныеФайла = РаботаСФайламиВызовСервера.ПолучитьДанныеФайлаИКоличествоВерсий(ОбъектСсылка);
	
	ПараметрыОбработчика = Новый Структура;
	ПараметрыОбработчика.Вставить("ДанныеФайла", ДанныеФайла);
	ПараметрыОбработчика.Вставить("ОбъектСсылка", ОбъектСсылка);
	Обработчик = Новый ОписаниеОповещения("ЗашифроватьПослеШифрованияНаКлиенте", ЭтотОбъект, ПараметрыОбработчика);
	
	РаботаСФайламиСлужебныйКлиент.Зашифровать(Обработчик, ДанныеФайла, УникальныйИдентификатор);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗашифроватьПослеШифрованияНаКлиенте(Результат, ПараметрыВыполнения) Экспорт
	
	Если Не Результат.Успех Тогда
		Возврат;
	КонецЕсли;
	
	ФайловыеФункцииКлиент.ПроинициализироватьПутьКРабочемуКаталогу();
	ИмяРабочегоКаталога = ФайловыеФункцииКлиентПовтИсп.ПолучитьПерсональныеНастройкиРаботыСФайлами().ПутьКЛокальномуКэшуФайлов;
	
	МассивФайловВРабочемКаталогеДляУдаления = Новый Массив;
	ЕстьЗашифрованныеИлиЗанятыеФайлы = Неопределено;
	
	ЗашифроватьСервер(
		Результат.МассивДанныхДляЗанесенияВБазу,
		Результат.МассивОтпечатков,
		МассивФайловВРабочемКаталогеДляУдаления,
		ИмяРабочегоКаталога,
		ПараметрыВыполнения.ОбъектСсылка,
		ЕстьЗашифрованныеИлиЗанятыеФайлы);
	
	РаботаСФайламиКлиент.ИнформироватьОШифровании(
		МассивФайловВРабочемКаталогеДляУдаления,
		ПараметрыВыполнения.ДанныеФайла.Владелец,
		ПараметрыВыполнения.ОбъектСсылка,
		ЕстьЗашифрованныеИлиЗанятыеФайлы);
	
	УстановитьДоступностьФайловыхКоманд();
	
КонецПроцедуры

&НаСервере
Процедура ЗашифроватьСервер(МассивДанныхДляЗанесенияВБазу, МассивОтпечатков, 
	МассивФайловВРабочемКаталогеДляУдаления,
	ИмяРабочегоКаталога, ОбъектСсылка, ЕстьЗашифрованныеИлиЗанятыеФайлы)
	
	Зашифровать = Истина;
	РаботаСФайламиВызовСервера.ЗанестиИнформациюОШифровании(
		ОбъектСсылка,
		Зашифровать,
		МассивДанныхДляЗанесенияВБазу,
		Неопределено,  // УникальныйИдентификатор
		ИмяРабочегоКаталога,
		МассивФайловВРабочемКаталогеДляУдаления,
		МассивОтпечатков);
	
	СсылкаВладелецФайла = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ОбъектСсылка, "ВладелецФайла");
	ЕстьЗашифрованныеИлиЗанятыеФайлы = РаботаСФайламиВызовСервера.ЕстьЗашифрованныеИлиЗанятыеФайлы(СсылкаВладелецФайла);	

КонецПроцедуры

&НаКлиенте
Процедура Расшифровать(Команда)
	
	ТекущаяСтрока = ПолучитьТекущуюСтроку();
	Если ТекущаяСтрока = Неопределено Тогда 
		Возврат;
	КонецЕсли; 
	
	ОбъектСсылка = ТекущаяСтрока;
	ДанныеФайла = РаботаСФайламиВызовСервера.ПолучитьДанныеФайлаИКоличествоВерсий(ОбъектСсылка);
	
	ПараметрыОбработчика = Новый Структура;
	ПараметрыОбработчика.Вставить("ДанныеФайла", ДанныеФайла);
	ПараметрыОбработчика.Вставить("ОбъектСсылка", ОбъектСсылка);
	Обработчик = Новый ОписаниеОповещения("РасшифроватьПослеРасшифровкиНаКлиенте", ЭтотОбъект, ПараметрыОбработчика);
	
	РаботаСФайламиСлужебныйКлиент.Расшифровать(Обработчик, ДанныеФайла.Ссылка, УникальныйИдентификатор, ДанныеФайла);
	
КонецПроцедуры

&НаКлиенте
Процедура РасшифроватьПослеРасшифровкиНаКлиенте(Результат, ПараметрыВыполнения) Экспорт
	
	Если Не Результат.Успех Тогда
		Возврат;
	КонецЕсли;
	
	ФайловыеФункцииКлиент.ПроинициализироватьПутьКРабочемуКаталогу();
	ИмяРабочегоКаталога = ФайловыеФункцииКлиентПовтИсп.ПолучитьПерсональныеНастройкиРаботыСФайлами().ПутьКЛокальномуКэшуФайлов;
	
	ЕстьЗашифрованныеИлиЗанятыеФайлы = Неопределено;
	
	РасшифроватьСервер(
		Результат.МассивДанныхДляЗанесенияВБазу,
		ИмяРабочегоКаталога,
		ПараметрыВыполнения.ОбъектСсылка,
		ЕстьЗашифрованныеИлиЗанятыеФайлы);
	
	РаботаСФайламиКлиент.ИнформироватьОРасшифровке(
		ПараметрыВыполнения.ДанныеФайла.Владелец,
		ПараметрыВыполнения.ОбъектСсылка,
		ЕстьЗашифрованныеИлиЗанятыеФайлы);
	
	УстановитьДоступностьФайловыхКоманд();
	
КонецПроцедуры

&НаСервере
Процедура РасшифроватьСервер(МассивДанныхДляЗанесенияВБазу, 
	ИмяРабочегоКаталога, ОбъектСсылка, ЕстьЗашифрованныеИлиЗанятыеФайлы)
	
	Зашифровать = Ложь;
	МассивОтпечатков = Новый Массив;
	МассивФайловВРабочемКаталогеДляУдаления = Новый Массив;
	
	РаботаСФайламиВызовСервера.ЗанестиИнформациюОШифровании(
		ОбъектСсылка,
		Зашифровать,
		МассивДанныхДляЗанесенияВБазу,
		Неопределено,  // УникальныйИдентификатор
		ИмяРабочегоКаталога,
		МассивФайловВРабочемКаталогеДляУдаления,
		МассивОтпечатков);
	
КонецПроцедуры

&НаКлиенте
Процедура Обновить(Команда)
	
	Если ТекущийЭлемент = Элементы.Папки Тогда
		Элементы.Папки.Обновить();
	Иначе
		Элементы.Список.Обновить();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВключитьПросмотрПапками(Команда)
	
	Если ВидПросмотра <> ПредопределенноеЗначение("Перечисление.ВидыПросмотраСпискаОбъектов.ПоПапкам") Тогда
		ВидПросмотра = ПредопределенноеЗначение("Перечисление.ВидыПросмотраСпискаОбъектов.ПоПапкам");
		ПереключитьВидПросмотра();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВключитьПросмотрСписком(Команда)
	
	Если ВидПросмотра <> ПредопределенноеЗначение("Перечисление.ВидыПросмотраСпискаОбъектов.Списком") Тогда
		ВидПросмотра = ПредопределенноеЗначение("Перечисление.ВидыПросмотраСпискаОбъектов.Списком");
		ПереключитьВидПросмотра();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПоказыватьУдаленныеФайлы(Команда)
	
	ПоказыватьУдаленныеФайлы = Не ПоказыватьУдаленныеФайлы;
	ИзменитьОтображениеУдаленныхФайлов(ПоказыватьУдаленныеФайлы, Список, Папки, 
		Элементы.ФормаПоказыватьУдаленныеФайлы);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Функция ПолучитьТекущуюСтроку()
	
	Если ТипЗнч(Элементы.Список.ТекущаяСтрока) = Тип("СтрокаГруппировкиДинамическогоСписка") Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	Возврат Элементы.Список.ТекущаяСтрока;
	
КонецФункции	

&НаКлиенте
Функция ПолучитьТекущиеДанные()
	
	Если ТипЗнч(Элементы.Список.ТекущаяСтрока) = Тип("СтрокаГруппировкиДинамическогоСписка") Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	Возврат Элементы.Список.ТекущиеДанные;
	
КонецФункции	

&НаКлиенте
Процедура ОбработкаОжидания()
	
	Если Элементы.Папки.ТекущаяСтрока <> Неопределено Тогда
		Список.Параметры.УстановитьЗначениеПараметра("Владелец", Элементы.Папки.ТекущаяСтрока);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПереключитьВидПросмотра()
	
	Параметр = Список.Параметры.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных("Владелец"));
	Параметр.Использование = (ВидПросмотра = Перечисления.ВидыПросмотраСпискаОбъектов.ПоПапкам);
   	
	Элементы.ВключитьПросмотрПапками.Пометка = Ложь;
	Элементы.ВключитьПросмотрСписком.Пометка = Ложь;
	
	Элементы.Папки.Видимость = Ложь;
	
	Если ВидПросмотра = Перечисления.ВидыПросмотраСпискаОбъектов.Списком Тогда
		
        //Элементы.ВладелецФайла.Видимость = Истина;
		Элементы.СоздатьФайл.Доступность = Истина;
		Элементы.ВключитьПросмотрСписком.Пометка = Истина;

	ИначеЕсли ВидПросмотра = Перечисления.ВидыПросмотраСпискаОбъектов.ПоПапкам Тогда
		
		Элементы.Папки.Видимость = Истина;
		
		Если Элементы.Список.ТекущаяСтрока <> Неопределено Тогда 
			Элементы.Папки.ТекущаяСтрока = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(
				Элементы.Список.ТекущаяСтрока, "ВладелецФайла");
		КонецЕсли;	
		Если Элементы.Папки.ТекущаяСтрока <> Неопределено Тогда 
			Список.Параметры.УстановитьЗначениеПараметра("Владелец", Элементы.Папки.ТекущаяСтрока);
			ТекущаяПапка = Элементы.Папки.ТекущаяСтрока;
		КонецЕсли;
		
		//Элементы.ВладелецФайла.Видимость = Ложь;
		Если Не ЗначениеЗаполнено(Элементы.Папки.ТекущаяСтрока) Тогда
			Элементы.СоздатьФайл.Доступность = Ложь;
		Иначе
			Элементы.СоздатьФайл.Доступность = Истина;
		КонецЕсли;
		Элементы.ВключитьПросмотрПапками.Пометка = Истина;
		
	Иначе
		ВидПросмотра = Перечисления.ВидыПросмотраСпискаОбъектов.ПоПапкам;
		ПереключитьВидПросмотра();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СделатьКомандыНедоступными()
	
	Элементы.ЗакончитьРедактирование.Доступность = Ложь;
	Элементы.СохранитьИзменения.Доступность = Ложь;
	Элементы.Освободить.Доступность = Ложь;
	Элементы.Занять.Доступность = Ложь;
	Элементы.Редактировать.Доступность = Ложь;
	Элементы.ПеренестиВРаздел.Доступность = Ложь;
	Элементы.ФормаПодписать.Доступность = Ложь;
	Элементы.ФормаСохранитьВместеСЭП.Доступность = Ложь;
	Элементы.ФормаЗашифровать.Доступность = Ложь;
	Элементы.ФормаРасшифровать.Доступность = Ложь;
	Элементы.ФормаДобавитьЭПИзФайла.Доступность = Ложь;
	Элементы.ОбновитьИзФайлаНаДиске.Доступность = Ложь;
	Элементы.СохранитьКак.Доступность = Ложь;
	Элементы.ОткрытьКаталогФайла.Доступность = Ложь;
	Элементы.ОткрытьФайл.Доступность = Ложь;
	Элементы.Напечатать.Доступность = Ложь;
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьДоступностьКоманд(РедактируетТекущийПользователь, Редактирует, ПодписанЭП, Зашифрован)
	
	РедактируетДругой = Не Редактирует.Пустая() И Не РедактируетТекущийПользователь;
	
	Элементы.ЗакончитьРедактирование.Доступность = РедактируетТекущийПользователь;
	Элементы.СохранитьИзменения.Доступность = РедактируетТекущийПользователь;
	Элементы.Освободить.Доступность = Не Редактирует.Пустая();
	Элементы.Занять.Доступность = Редактирует.Пустая() И Не ПодписанЭП;
	Элементы.Редактировать.Доступность = Не ПодписанЭП И Не РедактируетДругой;
	Элементы.ОбновитьИзФайлаНаДиске.Доступность = Не ПодписанЭП;
	Элементы.ФормаПодписать.Доступность = Редактирует.Пустая() И Не Зашифрован;
	Элементы.ФормаДобавитьЭПИзФайла.Доступность = Редактирует.Пустая() И Не Зашифрован;
	Элементы.ФормаСохранитьВместеСЭП.Доступность = ПодписанЭП;
	Элементы.ФормаЗашифровать.Доступность = Редактирует.Пустая() И Не Зашифрован;
	Элементы.ФормаРасшифровать.Доступность = Зашифрован;
	Элементы.СохранитьКак.Доступность = Истина;
	Элементы.ОткрытьКаталогФайла.Доступность = Истина;
	Элементы.ОткрытьФайл.Доступность = Истина;
	Элементы.ПеренестиВРаздел.Доступность = Истина;
	Элементы.Напечатать.Доступность = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьДоступностьФайловыхКоманд(Результат = Неопределено, ПараметрыВыполнения = Неопределено) Экспорт
	
	ТекущиеДанные = ПолучитьТекущиеДанные();
	Если ТекущиеДанные <> Неопределено Тогда
		
		ТекущаяСтрока = ПолучитьТекущуюСтроку();
		Если ТекущаяСтрока <> Неопределено Тогда
			
			УстановитьДоступностьКоманд(
				ТекущиеДанные.РедактируетТекущийПользователь,
				ТекущиеДанные.Редактирует,
				ТекущиеДанные.ПодписанЭП,
				ТекущиеДанные.Зашифрован);
				
			Возврат;	
					
		КонецЕсли;	
			
	КонецЕсли;	
	
	СделатьКомандыНедоступными();
	
КонецПроцедуры

#КонецОбласти