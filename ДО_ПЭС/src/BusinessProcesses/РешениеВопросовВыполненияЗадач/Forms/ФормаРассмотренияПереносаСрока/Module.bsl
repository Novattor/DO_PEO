
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	// Запись истории по данной задаче
	БизнесПроцессыИЗадачиВызовСервера.ЗаписатьСобытиеОткрытаКарточкаИОбращениеКОбъекту(Объект.Ссылка);
	
	ПраваПоОбъекту = ДокументооборотПраваДоступа.ПолучитьПраваПоОбъекту(Объект.Ссылка);
	Если Не ПраваПоОбъекту.Изменение Тогда
		ТолькоПросмотр = Истина;
		Элементы.КомандаРассмотрено.Доступность = Ложь;
		Элементы.КомандаНеПереносить.Доступность = Ложь;
		Элементы.ФормаПринятьКИсполнению.Доступность = Ложь;
		Элементы.ФормаОтменитьПринятиеКИсполнению.Доступность = Ложь;
	КонецЕсли;	
	
	// Общие действия при создании карточки задачи
	РаботаСБизнесПроцессамиВызовСервера.ФормаЗадачиПриСозданииНаСервере(ЭтаФорма, Объект);
	
	// Инициализация учета времени
	УчетВремени.ПроинициализироватьПараметрыУчетаВремени(
		ДатаНачалаХронометража,
		ДатаКонцаХронометража,
		ВключенХронометраж,
		ОпцияИспользоватьУчетВремени,
		Объект.Ссылка,
		ВидыРабот,
		СпособУказанияВремени,
		ЭтаФорма.Команды.ПереключитьХронометраж,
		ЭтаФорма.Элементы.ПереключитьХронометраж,
		ЭтаФорма.Элементы.УказатьТрудозатраты);
	
	// Инициализация реквизитов карточки
	ИспользоватьВремяВСрокахЗадач = ПолучитьФункциональнуюОпцию("ИспользоватьДатуИВремяВСрокахЗадач");
	Элементы.НовыйСрокВремя.Видимость = ИспользоватьВремяВСрокахЗадач;
	Если ИспользоватьВремяВСрокахЗадач Тогда
		Элементы.СтарыйСрок.Формат = "ДФ='dd.MM.yyyy ЧЧ:мм'";
	КонецЕсли;
	
	РеквизитыЗаявкиПереносаСрока = 
		ОбщегоНазначенияДокументооборот.ЗначенияРеквизитовОбъектаВПривилегированномРежиме(
			Объект.БизнесПроцесс, "ПредметРассмотрения, НовыйСрок");
	
	ПредметРассмотрения = РеквизитыЗаявкиПереносаСрока.ПредметРассмотрения;
	
	НовыйСрок = РеквизитыЗаявкиПереносаСрока.НовыйСрок;
	
	РеквизитыПредметаРассмотрения = ОбщегоНазначенияДокументооборот.ЗначенияРеквизитовОбъектаВПривилегированномРежиме(
		ПредметРассмотрения, "БизнесПроцесс, СрокИсполнения, ТекущийИсполнитель, Дата");
	
	БизнесПроцессПредметаРассмотрения = РеквизитыПредметаРассмотрения.БизнесПроцесс;
	ИсполнительПредметаРассмотрения = РеквизитыПредметаРассмотрения.ТекущийИсполнитель;
	
	СтарыйСрок = РеквизитыПредметаРассмотрения.СрокИсполнения;
	
	ТекущийПользователь = ПользователиКлиентСервер.ТекущийПользователь();
	
	ДлительностьПереноса = 
		ПереносСроковВыполненияЗадачВызовСервера.ПолучитьПодписьДлительностьПереноса(
			ИсполнительПредметаРассмотрения,
			СтарыйСрок,
			НовыйСрок);
	
	ОпределитьНеобходимостьРучногоИзмененияСроков();
	
	ИмяФормыДляОткрытияКарточкиПроцесса = "БизнесПроцесс."
		+ БизнесПроцессПредметаРассмотрения.Метаданные().Имя
		+ ".ФормаОбъекта";
	
	Если ТребуетсяРучноеИзменениеСрока Тогда
		Элементы.НовыйСрокДата.ТолькоПросмотр = Истина;
		Элементы.НовыйСрокВремя.ТолькоПросмотр = Истина;
		Элементы.КомандаРассмотрено.Заголовок = НСтр("ru = 'Срок перенесен'");
	Иначе
		Элементы.КомандаРассмотрено.Заголовок = НСтр("ru = 'Перенести срок'");
	КонецЕсли;
	
	Если ТребуетсяРучноеИзменениеСрока Тогда
		Элементы.ГруппаИнфо.Видимость = Истина;
		Элементы.Декорация_Инфо_РучноеИзменениеВДругомУзлеРИБ.Видимость = Истина;
		Элементы.Декорация_Инфо_ЗадачаСозданаСИстекшимСроком.Видимость = Ложь;
	ИначеЕсли РеквизитыПредметаРассмотрения.Дата >= РеквизитыПредметаРассмотрения.СрокИсполнения Тогда
		Элементы.ГруппаИнфо.Видимость = Истина;
		Элементы.Декорация_Инфо_РучноеИзменениеВДругомУзлеРИБ.Видимость = Ложь;
		Элементы.Декорация_Инфо_ЗадачаСозданаСИстекшимСроком.Видимость = Истина;
	Иначе
		Элементы.ГруппаИнфо.Видимость = Ложь;
	КонецЕсли;
	
	// Инициализация списка файлов
	Файлы.Параметры.УстановитьЗначениеПараметра("ВладелецФайла", Объект.БизнесПроцесс.Ссылка);
	Файлы.Параметры.УстановитьЗначениеПараметра("ТекущийПользователь", ПользователиКлиентСервер.ТекущийПользователь());
	РаботаСФайламиВызовСервера.ЗаполнитьУсловноеОформлениеСпискаФайлов(Файлы);
	ОбновитьВидимостьТаблицыФайлов(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Оповестить("ОбновитьСписокПоследних");
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если УправлениеСвойствамиКлиент.ОбрабатыватьОповещения(ЭтаФорма, ИмяСобытия, Параметр) Тогда
		// Подсистема "Свойства"
		ОбновитьЭлементыДополнительныхРеквизитов();
	ИначеЕсли ИмяСобытия = "Запись_Файл" И Параметр.Событие = "СозданФайл" Тогда
		Элементы.Файлы.Обновить();
		ОбновитьВидимостьТаблицыФайлов(ЭтаФорма);
		Если ТипЗнч(Параметр) = Тип("Структура") Тогда
			Элементы.Файлы.ТекущаяСтрока = Параметр.Файл;
		КонецЕсли;	
	ИначеЕсли ИмяСобытия = "Запись_Файл" И Параметр.Событие = "ДанныеФайлаИзменены" Тогда
		ВладелецФайла = Неопределено;
		Если ТипЗнч(Параметр) = Тип("Структура") И Параметр.Свойство("Владелец")
			 И ЗначениеЗаполнено(Параметр.Владелец)  Тогда
			ВладелецФайла = Параметр.Владелец;
		Иначе	
			ВладелецФайла = ОбщегоНазначенияДокументооборотВызовСервера.ЗначениеРеквизитаОбъекта(Источник, "ВладелецФайла");
		КонецЕсли;	
		Если ВладелецФайла = Объект.Ссылка Тогда
			Элементы.Файлы.Обновить();
			ОбновитьДоступностьКомандСпискаФайлов();
			ОбновитьВидимостьТаблицыФайлов(ЭтаФорма);
		КонецЕсли;
		
	ИначеЕсли ИмяСобытия = "ИзменилсяФлаг"
		И Источник <> ЭтаФорма
		И Параметр.Найти(Объект.Ссылка) <> Неопределено Тогда
		
		РаботаСФлагамиОбъектовКлиентСервер.ОтобразитьФлагВФормеОбъекта(ЭтаФорма);
		
	ИначеЕсли ИмяСобытия = "ЗадачаИзменена" И Источник <> ЭтаФорма Тогда
		
		ПрочитатьДанныеЗадачиВФорму = Ложь;
		
		Если ТипЗнч(Параметр) = Тип("Массив") Тогда
			ПрочитатьДанныеЗадачиВФорму = Параметр.Найти(Объект.Ссылка) <> Неопределено;
		Иначе
			ПрочитатьДанныеЗадачиВФорму = (Параметр = Объект.Ссылка);
		КонецЕсли;
		
		Если ПрочитатьДанныеЗадачиВФорму Тогда
			Прочитать();
		КонецЕсли;
		
		КомандыРаботыСБизнесПроцессамиКлиент.ОбновитьДоступностьКомандПринятияКИсполнению(ЭтаФорма);
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	РаботаСФлагамиОбъектовСервер.ОтобразитьФлагВФормеОбъекта(ЭтаФорма);
	
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	РаботаСБизнесПроцессами.ФормаЗадачиПередЗаписьюНаСервере(
		ЭтаФорма, Отказ, ТекущийОбъект, ПараметрыЗаписи);
	
	ВыполнитьЗадачу = ПараметрыЗаписи.Свойство("ВыполнитьЗадачу") И ПараметрыЗаписи.ВыполнитьЗадачу;
	ВыполнитьЗадачуФоново = ПараметрыЗаписи.Свойство("ВыполнитьЗадачуФоново") И ПараметрыЗаписи.ВыполнитьЗадачуФоново;
	
	// Обновление нового срока в процессе-заявке на перенос срока
	Если Не ТребуетсяРучноеИзменениеСрока
		И ТекущийОбъект.БизнесПроцесс.НовыйСрок <> НовыйСрок
		И ВыполнитьЗадачу Или ВыполнитьЗадачуФоново Тогда
		
		ЗаблокироватьДанныеДляРедактирования(ТекущийОбъект.БизнесПроцесс);
		ПроцессОбъект = ТекущийОбъект.БизнесПроцесс.ПолучитьОбъект();
		ПроцессОбъект.НовыйСрок = НовыйСрок;
		УстановитьПривилегированныйРежим(Истина);
		РаботаСБизнесПроцессами.ЗаписатьПроцесс(ПроцессОбъект, "ПростаяЗапись");
		УстановитьПривилегированныйРежим(Ложь);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПриЗаписиНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	ПараметрыФоновогоВыполнения = Новый Структура;
	
	Если ПараметрыЗаписи.Свойство("ВыполнитьЗадачуФоново")
		И ПараметрыЗаписи.ВыполнитьЗадачуФоново Тогда
		
		ПараметрыФоновогоВыполнения.Вставить("ПереносСрока", ПараметрыЗаписи.ПереносСрока);
		ПараметрыФоновогоВыполнения.Вставить("НовыйСрок", НовыйСрок);
		ПараметрыФоновогоВыполнения.Вставить("РезультатВыполнения", Объект.РезультатВыполнения);
	КонецЕсли;
	
	РаботаСБизнесПроцессами.ФормаЗадачиПриЗаписиНаСервере(
		ЭтаФорма, Отказ, ТекущийОбъект, ПараметрыЗаписи, ПараметрыФоновогоВыполнения);
	
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	ЗначениеПараметра = Файлы.Параметры.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных("ВладелецФайла"));
	Если Не ЗначениеЗаполнено(ЗначениеПараметра.Значение) Тогда 
		Файлы.Параметры.УстановитьЗначениеПараметра("ВладелецФайла", Объект.Ссылка);
	КонецЕсли;
	
	Если ПараметрыЗаписи.Свойство("ЭтоНовыйОбъект") И ПараметрыЗаписи.ЭтоНовыйОбъект = Истина Тогда
		РаботаСФлагамиОбъектовСервер.СохранитьФлагОбъектаИзФормы(ЭтаФорма);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	Оповестить("ЗадачаИзменена", Объект.Ссылка, ЭтаФорма);
	
КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствами.ОбработкаПроверкиЗаполнения(ЭтаФорма, Отказ, ПроверяемыеРеквизиты);
	// Конец СтандартныеПодсистемы.Свойства
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ПредставлениеHTMLПриНажатии(Элемент, ДанныеСобытия, СтандартнаяОбработка)
	
	ОбзорЗадачКлиент.ПредставлениеHTMLПриНажатии(Элемент, ДанныеСобытия, СтандартнаяОбработка, ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура НовыйСрокДатаПриИзменении(Элемент)
	
	ПриИзмененииНовогоСрока(Истина);

КонецПроцедуры

&НаКлиенте
Процедура НовыйСрокВремяПриИзменении(Элемент)
	
	ПриИзмененииНовогоСрока(Ложь);

КонецПроцедуры

&НаКлиенте
Процедура БизнесПроцессПредметаРассмотренияНажатие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ПараметрыФормы = Новый Структура();
	ПараметрыФормы.Вставить("Ключ", БизнесПроцессПредметаРассмотрения);
	ПараметрыФормы.Вставить("ЗаявкаНаПереносСрока", Объект.БизнесПроцесс);
	ОткрытьФорму(ИмяФормыДляОткрытияКарточкиПроцесса, ПараметрыФормы);
	
КонецПроцедуры

&НаКлиенте
Процедура Декорация_Инфо_ОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка)
	
	Если НавигационнаяСсылкаФорматированнойСтроки = "ОткрытьБизнесПроцессПредметаРассмотрения" Тогда
		СтандартнаяОбработка = Ложь;
		ПараметрыФормы = Новый Структура();
		ПараметрыФормы.Вставить("Ключ", БизнесПроцессПредметаРассмотрения);
		ПараметрыФормы.Вставить("ЗаявкаНаПереносСрока", Объект.БизнесПроцесс);
		ОткрытьФорму(ИмяФормыДляОткрытияКарточкиПроцесса, ПараметрыФормы);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура РезультатВыполненияНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	РаботаСБизнесПроцессамиКлиент.ВыбратьШаблонТекстаРеализация(ЭтаФорма, "РезультатВыполнения",
		ПредопределенноеЗначение("Перечисление.ОбластиПримененияШаблоновТекстов.ЗадачаРешениеВопросовПереносСрока"));
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормы_Файлы

&НаКлиенте
Процедура СписокФайловВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	КакОткрывать = ФайловыеФункцииКлиентПовтИсп.ПолучитьПерсональныеНастройкиРаботыСФайлами().ДействиеПоДвойномуЩелчкуМыши;
	Если КакОткрывать = "ОткрыватьКарточку" Тогда
		ПоказатьЗначение(, ВыбраннаяСтрока);
		Возврат;
	КонецЕсли;
	
	ДанныеФайла = РаботаСФайламиВызовСервера.ДанныеФайлаДляОткрытия(
	ВыбраннаяСтрока, Неопределено, ЭтаФорма.УникальныйИдентификатор);
	
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
	
	Обработчик = Новый ОписаниеОповещения("ОбновитьДоступностьКомандСпискаФайлов", ЭтотОбъект, ПараметрыВыполнения);
	
	Если Результат = РезультатРедактировать Тогда
		РаботаСФайламиКлиент.РедактироватьФайл(Обработчик, ПараметрыВыполнения.ДанныеФайла);
	ИначеЕсли Результат = РезультатОткрыть Тогда
		РаботаСФайламиКлиент.ОткрытьФайлСОповещением(Неопределено, ПараметрыВыполнения.ДанныеФайла, УникальныйИдентификатор); 
	ИначеЕсли Результат = РезультатОткрытьКарточку Тогда
		ПоказатьЗначение(, ПараметрыВыполнения.ДанныеФайла.Ссылка);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ФайлыПриАктивизацииСтроки(Элемент)
	ОбновитьДоступностьКомандСпискаФайлов();
КонецПроцедуры

&НаКлиенте
Процедура ФайлыПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа)
	
	Отказ = Истина;
	
	ДобавитьФайл(Копирование);
	
КонецПроцедуры

&НаКлиенте
Процедура ФайлыПроверкаПеретаскивания(Элемент, ПараметрыПеретаскивания, СтандартнаяОбработка, Строка, Поле)
	СтандартнаяОбработка = Ложь;
КонецПроцедуры

&НаКлиенте
Процедура ФайлыПеретаскивание(Элемент, ПараметрыПеретаскивания, СтандартнаяОбработка, Строка, Поле)
	
	СтандартнаяОбработка = Ложь;
	
	Если Элементы.Файлы.ТолькоПросмотр Тогда 
		Возврат;
	КонецЕсли;
	
	Если Объект.Ссылка.Пустая() Тогда 
		Если Не Записать() Тогда 
			Возврат;
		КонецЕсли;
		
		ПоказатьОповещениеПользователя(
			"Создание:", 
			ПолучитьНавигационнуюСсылку(Объект.Ссылка),
			Строка(Объект.Ссылка),
			БиблиотекаКартинок.Информация32);
	КонецЕсли;
	
	ВладелецФайлаСписка = Объект.БизнесПроцесс;
	НеОткрыватьКарточкуПослеСозданияИзФайла = Истина;	
	РаботаСФайламиКлиент.ОбработкаПеретаскиванияВЛинейныйСписок(ПараметрыПеретаскивания, ВладелецФайлаСписка, ЭтаФорма, НеОткрыватьКарточкуПослеСозданияИзФайла);
	Элементы.Файлы.Обновить();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ЗаписатьИЗакрытьВыполнить()
	
	ОчиститьСообщения();
	Если Записать() Тогда
		ПоказатьОповещениеПользователя(
			"Изменение:", 
			ПолучитьНавигационнуюСсылку(Объект.Ссылка),
			Строка(Объект.Ссылка),
			БиблиотекаКартинок.Информация32);
		
		Закрыть();	
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаписатьВыполнить(Команда)
	
	Если Записать() Тогда
		ПоказатьОповещениеПользователя(
			"Изменение:", 
			ПолучитьНавигационнуюСсылку(Объект.Ссылка),
			Строка(Объект.Ссылка),
			БиблиотекаКартинок.Информация32);
	КонецЕсли;	
	
КонецПроцедуры

&НаКлиенте
Процедура ПринятьКИсполнению(Команда)
	
	КомандыРаботыСБизнесПроцессамиКлиент.ПринятьЗадачуКИсполнению(ЭтаФорма, ТекущийПользователь);	
	
КонецПроцедуры

&НаКлиенте
Процедура ОтменитьПринятиеКИсполнению(Команда)
	
	КомандыРаботыСБизнесПроцессамиКлиент.ОтменитьПринятиеЗадачиКИсполнению(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьБизнесПроцесс(Команда)
	
	ПоказатьЗначение(, Объект.БизнесПроцесс);
	
КонецПроцедуры

&НаКлиенте
Процедура ПереключитьХронометраж(Команда)
	
	КомандыРаботыСБизнесПроцессамиКлиент.ПереключитьХронометраж(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура УказатьТрудозатраты(Команда)
	
	ДатаОтчета = ТекущаяДата();
	Если Объект.Выполнена Тогда
		ДатаОтчета = Объект.ДатаИсполнения;
	КонецЕсли;	
	
	УчетВремениКлиент.ДобавитьВОтчетКлиент(
		ДатаОтчета,
		ВключенХронометраж, 
		ДатаНачалаХронометража, 
		ДатаКонцаХронометража, 
		ВидыРабот, 
		Объект.Ссылка,
		СпособУказанияВремени,
		ЭтаФорма.Элементы.ПереключитьХронометраж,
		Объект.Выполнена,
		ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ИзменитьДатуВыполнения(Команда)
	
	РаботаСБизнесПроцессамиКлиент.ИзменитьДатуВыполнения(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура СформироватьУведомлениеДляИсполненияЗадачиПоПочте(Команда)
	
	ВыполнениеЗадачПоПочтеКлиент.СформироватьУведомлениеДляИсполненияЗадачиПоПочте(Объект.Ссылка);
	
КонецПроцедуры

&НаКлиенте
Процедура ПраваДоступа(Команда)
	
	ДокументооборотПраваДоступаКлиент.ОткрытьФормуПравДоступа(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура КомандаПеренести(Команда)
	
	ОписаниеОповещения = Новый ОписаниеОповещения(
		"ПродолжениеВыполненияЗадачиПеренестиПослеВыбораФактическогоИсполнителя", ЭтаФорма);
	
	РаботаСБизнесПроцессамиКлиент.ВыбратьИсполнителяЗадачи(
		ЭтаФорма,
		Объект.Исполнитель,
		ТекущийПользователь,
		ФактическийИсполнительЗадачи,
		ОписаниеОповещения);
	
КонецПроцедуры

&НаКлиенте
Процедура ПродолжениеВыполненияЗадачиПеренестиПослеВыбораФактическогоИсполнителя(
	ВыбранныйФактическийИсполнитель, ДопПараметры) Экспорт
	
	Если ВыбранныйФактическийИсполнитель = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если ВыбранныйФактическийИсполнитель <> Объект.Исполнитель Тогда
		ФактическийИсполнительЗадачи = ВыбранныйФактическийИсполнитель;
	КонецЕсли;
	
	ОчиститьСообщения();
	
	КоличествоПереносовПоЗадаче = 
		ПереносСроковВыполненияЗадачВызовСервера.КоличествоПереносовСрокаПоЗадачеИЗаявкеНаПеренос(
			ПредметРассмотрения,
			Объект.БизнесПроцесс);
	
	Если ТребуетсяРучноеИзменениеСрока И КоличествоПереносовПоЗадаче = 0 Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			НСтр("ru = 'Необходимо вручную изменить срок на карточке процесса'"),,
			"БизнесПроцессПредметаРассмотрения");
			
		Возврат;
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(НовыйСрок) Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			НСтр("ru = 'Не указан новый срок исполнения.'"),,
			"НовыйСрок");
			
		Возврат;
	КонецЕсли;
	
	ОписаниеОповещения = Новый ОписаниеОповещения(
			"ПродолжитьВыполнениеЗадачиПослеПодтвержденияПереносаСрокаПроцесса",
			ЭтаФорма, КоличествоПереносовПоЗадаче);
	
	Если КоличествоПереносовПоЗадаче = 0 Тогда
		
		СтарыйСрокПроцесса = Дата(1,1,1);
		НовыйСрокПроцесса = Дата(1,1,1);
		
		ПереносСроковВыполненияЗадачВызовСервера.ОпределитьСрокПроцессаПриИзмененииСрокаЗадачи(
			ПредметРассмотрения, НовыйСрок,
			БизнесПроцессПредметаРассмотрения, СтарыйСрокПроцесса, НовыйСрокПроцесса);
		
		Если СтарыйСрокПроцесса <> НовыйСрокПроцесса Тогда
			
			ПараметрыФормы = Новый Структура;
			ПараметрыФормы.Вставить("Процесс", БизнесПроцессПредметаРассмотрения);
			ПараметрыФормы.Вставить("НовыйСрокИсполнения", НовыйСрокПроцесса);
			ПараметрыФормы.Вставить("СформироватьДеревоВышестоящихПроцессовСНовымиСроками", Истина);
			
			ОткрытьФорму("ОбщаяФорма.ПодтверждениеПереносаСрока",
				ПараметрыФормы,
				ЭтаФорма,,,,
				ОписаниеОповещения,
				РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
			
			Возврат;
		КонецЕсли;
		
	КонецЕсли;
	
	ВыполнитьОбработкуОповещения(ОписаниеОповещения, Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура ПродолжитьВыполнениеЗадачиПослеПодтвержденияПереносаСрокаПроцесса(
	Результат, КоличествоПереносовПоЗадаче) Экспорт
	
	Если Результат = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ПараметрыЗаписи = Новый Структура;
	ПараметрыЗаписи.Вставить("ПереносСрока", Истина);
	
	Если ИспользоватьФоновоеВыполнениеЗадач
		И СостояниеВыполнения = ПредопределенноеЗначение("Перечисление.СостоянияЗадачДляВыполнения.ПустаяСсылка") Тогда
		
		ПараметрыЗаписи.Вставить("ВыполнитьЗадачуФоново", Истина);
		
		Если Не ВыполнениеЗадачКлиент.ВыполнитьЗадачуИзФормы(ЭтаФорма, ПараметрыЗаписи) Тогда
			Возврат;
		КонецЕсли;
	Иначе
		ПараметрыЗаписи.Вставить("ВыполнитьЗадачу", Истина);
		ПараметрыЗаписи.Вставить("КоличествоПереносовПоЗадаче", КоличествоПереносовПоЗадаче);
		Если Не ЗаписатьЗадачуНаСервере(ПараметрыЗаписи) Тогда
			Возврат;
		КонецЕсли;
		Оповестить("ПереносСрокаИсполненияПроцесса", БизнесПроцессПредметаРассмотрения, ЭтаФорма);
	КонецЕсли;
	
	ОписаниеОповещения = Новый ОписаниеОповещения(
		"ПродолжениеВыполненияЗадачиПослеВводаВремени",
		ЭтотОбъект);
	
	УчетВремениКлиент.ДобавитьВОтчетПослеВыполненияЗадачи(ОпцияИспользоватьУчетВремени,
		Объект.ДатаИсполнения, Объект.Ссылка, ВключенХронометраж, 
		ДатаНачалаХронометража, ДатаКонцаХронометража,
		ВидыРабот, СпособУказанияВремени, ОписаниеОповещения);
	
КонецПроцедуры

&НаКлиенте
Процедура ПродолжениеВыполненияЗадачиПослеВводаВремени(Результат, Параметры) Экспорт
	
	ПоказатьОповещениеПользователя(
		НСтр("ru = 'Выполнение:'"),
		ПолучитьНавигационнуюСсылку(Объект.Ссылка),
		Строка(Объект.Ссылка),
		БиблиотекаКартинок.Информация32);
	
	Оповестить("ЗадачаВыполнена", Объект.Ссылка);
	Закрыть();
	
КонецПроцедуры

&НаКлиенте
Процедура КомандаНеПереносить(Команда)
	
	ОписаниеОповещения = Новый ОписаниеОповещения(
		"ПродолжениеВыполненияЗадачиНеПереноситьПослеВыбораФактическогоИсполнителя", ЭтаФорма);
	
	РаботаСБизнесПроцессамиКлиент.ВыбратьИсполнителяЗадачи(
		ЭтаФорма,
		Объект.Исполнитель,
		ТекущийПользователь,
		ФактическийИсполнительЗадачи,
		ОписаниеОповещения);
	
КонецПроцедуры

&НаКлиенте
Процедура ПродолжениеВыполненияЗадачиНеПереноситьПослеВыбораФактическогоИсполнителя(
	ВыбранныйФактическийИсполнитель, ДопПараметры) Экспорт
	
	Если ВыбранныйФактическийИсполнитель = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если ВыбранныйФактическийИсполнитель <> Объект.Исполнитель Тогда
		ФактическийИсполнительЗадачи = ВыбранныйФактическийИсполнитель;
	КонецЕсли; 
	
	// Проверка на заполнение обязательного комментария при отказе перенести срок
	Если Не ЗначениеЗаполнено(Объект.РезультатВыполнения) Тогда
		ОчиститьСообщения();
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			НСтр("ru = 'Не заполнено поле ""Комментарий"".'"),,
			"Объект.РезультатВыполнения");
		Возврат;
	КонецЕсли;
	
	ПараметрыЗаписи = Новый Структура;
	ПараметрыЗаписи.Вставить("ПереносСрока", Ложь);
	
	Если Не ВыполнениеЗадачКлиент.ВыполнитьЗадачуИзФормы(ЭтаФорма, ПараметрыЗаписи) Тогда
		Возврат;
	КонецЕсли;
	
	ОписаниеОповещения = Новый ОписаниеОповещения(
		"ПродолжениеВыполненияЗадачиПослеВводаВремени",
		ЭтотОбъект);
		
	УчетВремениКлиент.ДобавитьВОтчетПослеВыполненияЗадачи(ОпцияИспользоватьУчетВремени,
		Объект.ДатаИсполнения, Объект.Ссылка, ВключенХронометраж, 
		ДатаНачалаХронометража, ДатаКонцаХронометража,
		ВидыРабот, СпособУказанияВремени, ОписаниеОповещения);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы_Подзадачи

&НаКлиенте
Процедура ПроцессСогласование(Команда)
	
	РаботаСБизнесПроцессамиКлиент.ОткрытьПомощникСозданияОсновныхПроцессов(
		"Согласование", Объект.Ссылка, ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ПроцессУтверждение(Команда)
	
	РаботаСБизнесПроцессамиКлиент.ОткрытьПомощникСозданияОсновныхПроцессов(
		"Утверждение", Объект.Ссылка, ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ПроцессРегистрация(Команда)
	
	РаботаСБизнесПроцессамиКлиент.ОткрытьПомощникСозданияОсновныхПроцессов(
		"Регистрация", Объект.Ссылка, ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ПроцессРассмотрение(Команда)
	
	РаботаСБизнесПроцессамиКлиент.ОткрытьПомощникСозданияОсновныхПроцессов(
		"Рассмотрение", Объект.Ссылка, ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ПроцессИсполнение(Команда)
	
	РаботаСБизнесПроцессамиКлиент.ОткрытьПомощникСозданияОсновныхПроцессов(
		"Исполнение", Объект.Ссылка, ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ПроцессОзнакомление(Команда)
	
	РаботаСБизнесПроцессамиКлиент.ОткрытьПомощникСозданияОсновныхПроцессов(
		"Ознакомление", Объект.Ссылка, ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ПроцессПриглашение(Команда)
	
	РаботаСБизнесПроцессамиКлиент.ОткрытьПомощникСозданияОсновныхПроцессов(
		"Приглашение", Объект.Ссылка, ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ПроцессОбработка(Команда)
	
	РаботаСБизнесПроцессамиКлиент.ОткрытьПомощникСозданияОсновныхПроцессов(
		"КомплексныйПроцесс", Объект.Ссылка, ЭтаФорма);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы_РаботаСФлагами

&НаКлиенте
Процедура КрасныйФлаг(Команда)
	
	РаботаСФлагамиОбъектовКлиент.УстановитьФлагВФормеОбъекта(
		ЭтаФорма,
		ПредопределенноеЗначение("Перечисление.ФлагиОбъектов.Красный"),
		БиблиотекаКартинок.КрасныйФлаг);
	
КонецПроцедуры

&НаКлиенте
Процедура СинийФлаг(Команда)
	
	РаботаСФлагамиОбъектовКлиент.УстановитьФлагВФормеОбъекта(
		ЭтаФорма,
		ПредопределенноеЗначение("Перечисление.ФлагиОбъектов.Синий"),
		БиблиотекаКартинок.СинийФлаг);
	
КонецПроцедуры

&НаКлиенте
Процедура ЖелтыйФлаг(Команда)
	
	РаботаСФлагамиОбъектовКлиент.УстановитьФлагВФормеОбъекта(
		ЭтаФорма,
		ПредопределенноеЗначение("Перечисление.ФлагиОбъектов.Желтый"),
		БиблиотекаКартинок.ЖелтыйФлаг);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗеленыйФлаг(Команда)
	
	РаботаСФлагамиОбъектовКлиент.УстановитьФлагВФормеОбъекта(
		ЭтаФорма,
		ПредопределенноеЗначение("Перечисление.ФлагиОбъектов.Зеленый"),
		БиблиотекаКартинок.ЗеленыйФлаг);
	
КонецПроцедуры

&НаКлиенте
Процедура ОранжевыйФлаг(Команда)
	
	РаботаСФлагамиОбъектовКлиент.УстановитьФлагВФормеОбъекта(
		ЭтаФорма,
		ПредопределенноеЗначение("Перечисление.ФлагиОбъектов.Оранжевый"),
		БиблиотекаКартинок.ОранжевыйФлаг);
	
КонецПроцедуры

&НаКлиенте
Процедура ЛиловыйФлаг(Команда)
	
	РаботаСФлагамиОбъектовКлиент.УстановитьФлагВФормеОбъекта(
		ЭтаФорма,
		ПредопределенноеЗначение("Перечисление.ФлагиОбъектов.Лиловый"),
		БиблиотекаКартинок.ЛиловыйФлаг);
	
КонецПроцедуры

&НаКлиенте
Процедура ОчиститьФлаг(Команда)
	
	РаботаСФлагамиОбъектовКлиент.УстановитьФлагВФормеОбъекта(
		ЭтаФорма,
		ПредопределенноеЗначение("Перечисление.ФлагиОбъектов.ПустаяСсылка"),
		БиблиотекаКартинок.ПустойФлаг);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы_Файлы

&НаКлиенте
Процедура КомандаДобавитьФайл(Команда)
	
	ДобавитьФайл();
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьФайл(Команда)
	
	Если Элементы.Файлы.ТекущаяСтрока = Неопределено Тогда 
		Возврат;
	КонецЕсли;
	
	ДанныеФайла = РаботаСФайламиВызовСервера.ДанныеФайлаДляОткрытия(Элементы.Файлы.ТекущаяСтрока, Неопределено, ЭтаФорма.УникальныйИдентификатор);
	КомандыРаботыСФайламиКлиент.Открыть(ДанныеФайла);
	
КонецПроцедуры

&НаКлиенте
Процедура СохранитьКак(Команда)
	
	Если Элементы.Файлы.ТекущаяСтрока = Неопределено Тогда 
		Возврат;
	КонецЕсли;
	
	ДанныеФайла = РаботаСФайламиВызовСервера.ДанныеФайлаДляСохранения(Элементы.Файлы.ТекущаяСтрока, Неопределено, ЭтаФорма.УникальныйИдентификатор);
	КомандыРаботыСФайламиКлиент.СохранитьКак(ДанныеФайла, УникальныйИдентификатор);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьИзФайлаНаДиске(Команда)
	
	Если Элементы.Файлы.ТекущаяСтрока = Неопределено Тогда 
		Возврат;
	КонецЕсли;
	
	ДанныеФайла = РаботаСФайламиВызовСервера.ДанныеФайлаИРабочийКаталог(Элементы.Файлы.ТекущаяСтрока);
	
	Обработчик = Новый ОписаниеОповещения("ОбновитьДоступностьКомандСпискаФайлов", ЭтотОбъект);
	РаботаСФайламиКлиент.ОбновитьИзФайлаНаДискеСОповещением(
		Обработчик,
		ДанныеФайла, ЭтаФорма.УникальныйИдентификатор);
	
КонецПроцедуры

&НаКлиенте
Процедура Редактировать(Команда)
	
	Если Объект.Ссылка.Пустая()
		И Элементы.ФайлыДобавленные.ТекущаяСтрока <> Неопределено Тогда
		Если ЭтоАдресВременногоХранилища(Элементы.ФайлыДобавленные.ТекущиеДанные.ПолныйПуть) Тогда 
			ТекущийФайлВСпискеДобавленных = ПолучитьИзВременногоХранилища(Элементы.ФайлыДобавленные.ТекущиеДанные.ПолныйПуть).Ссылка;
			Записать();
		Иначе			
			РаботаСФайламиКлиент.ЗапуститьПриложениеПоИмениФайла(
				Элементы.ФайлыДобавленные.ТекущиеДанные.ПолныйПуть);
		КонецЕсли;	
	Иначе
		Если Элементы.Файлы.ТекущаяСтрока = Неопределено Тогда 
			Возврат;
		КонецЕсли;
		
		Обработчик = Новый ОписаниеОповещения("ОбновитьДоступностьКомандСпискаФайлов", ЭтотОбъект);
		РаботаСФайламиКлиент.РедактироватьСОповещением(Обработчик, Элементы.Файлы.ТекущаяСтрока);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗакончитьРедактирование(Команда)
	
	Если Элементы.Файлы.ТекущаяСтрока = Неопределено Тогда 
		Возврат;
	КонецЕсли;
	
	Обработчик = Новый ОписаниеОповещения("ОбновитьДоступностьКомандСпискаФайлов", ЭтотОбъект);
	
	ТекущиеДанные = Элементы.Файлы.ТекущиеДанные;
		
	ПараметрыОбновленияФайла = РаботаСФайламиКлиент.ПараметрыОбновленияФайла(Обработчик, 
		Элементы.Файлы.ТекущаяСтрока, ЭтаФорма.УникальныйИдентификатор);
	ПараметрыОбновленияФайла.ХранитьВерсии = ТекущиеДанные.ХранитьВерсии;
	ПараметрыОбновленияФайла.РедактируетТекущийПользователь = ТекущиеДанные.РедактируетТекущийПользователь;
	ПараметрыОбновленияФайла.Редактирует = ТекущиеДанные.Редактирует;
	РаботаСФайламиКлиент.ЗакончитьРедактированиеСОповещением(ПараметрыОбновленияФайла);
	
КонецПроцедуры

&НаКлиенте
Процедура Занять(Команда)
	
	Если Элементы.Файлы.ТекущаяСтрока = Неопределено Тогда 
		Возврат;
	КонецЕсли;	
	
	Обработчик = Новый ОписаниеОповещения("ОбновитьДоступностьКомандСпискаФайлов", ЭтотОбъект);
	РаботаСФайламиКлиент.ЗанятьСОповещением(Обработчик, Элементы.Файлы.ТекущаяСтрока);	
	
КонецПроцедуры

&НаКлиенте
Процедура Освободить(Команда)
	
	Если Элементы.Файлы.ТекущаяСтрока = Неопределено Тогда 
		Возврат;
	КонецЕсли;
	
	Обработчик = Новый ОписаниеОповещения("ОбновитьДоступностьКомандСпискаФайлов", ЭтотОбъект);
	
	ТекущиеДанные = Элементы.Файлы.ТекущиеДанные;
		
	ПараметрыОсвобожденияФайла = РаботаСФайламиКлиент.ПараметрыОсвобожденияФайла(Обработчик, 
		Элементы.Файлы.ТекущаяСтрока);
	ПараметрыОсвобожденияФайла.ХранитьВерсии = ТекущиеДанные.ХранитьВерсии;	
	ПараметрыОсвобожденияФайла.РедактируетТекущийПользователь = ТекущиеДанные.РедактируетТекущийПользователь;	
	ПараметрыОсвобожденияФайла.Редактирует = ТекущиеДанные.Редактирует;	
	РаботаСФайламиКлиент.ОсвободитьФайлСОповещением(ПараметрыОсвобожденияФайла);
	
КонецПроцедуры

&НаКлиенте
Процедура СохранитьИзменения(Команда)
	
	Если Элементы.Файлы.ТекущаяСтрока = Неопределено Тогда 
		Возврат;
	КонецЕсли;
	
	Обработчик = Новый ОписаниеОповещения("ОбновитьДоступностьКомандСпискаФайлов", ЭтотОбъект);
	
	РаботаСФайламиКлиент.СохранитьИзмененияФайлаСОповещением(
		Обработчик,
		Элементы.Файлы.ТекущаяСтрока, 
		ЭтаФорма.УникальныйИдентификатор);
	
КонецПроцедуры

&НаКлиенте
Процедура ОтображатьУдаленныеФайлы(Команда)
	ОтображатьУдаленныеФайлыСервер();
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ОпределитьНеобходимостьРучногоИзмененияСроков()
	
	УстановитьПривилегированныйРежим(Истина);
	
	УзелОбменаПредметаРассмотрения =
		ОбщегоНазначения.ЗначениеРеквизитаОбъекта(БизнесПроцессПредметаРассмотрения, "УзелОбмена");
		
	УзелОбменаЗаявки = 
		ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Объект.БизнесПроцесс, "УзелОбмена");
		
	// Если заявка на перенос срока создана в другом узле, то
	// перенос срока процесса (предмета рассмотрения) возможен только в карточке процесса
	ТребуетсяРучноеИзменениеСрока = УзелОбменаПредметаРассмотрения <> УзелОбменаЗаявки;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриИзмененииНовогоСрока(ИзмененаДата)
	
	// Если в поле "Новый срок" вводится только время, то в дату проставляется текущая дата.
	// При вводе только времени дата автоматически принимает значение 01.01.0001 <Время>. Это значение исправляется.
	Если ЗначениеЗаполнено(НовыйСрок) и НовыйСрок < Дата(1,1,2) Тогда
		ДатаНачалаДня = НачалоДня(ТекущаяДата());
		ГодНачалаДня = Год(ДатаНачалаДня);
		МесяцНачалаДня = Месяц(ДатаНачалаДня);
		ДеньНачалаДня = День(ДатаНачалаДня);
		ЧасДаты = Час(НовыйСрок);
		МинутаДаты = Минута(НовыйСрок);
		СекундаДаты = Секунда(НовыйСрок);
		НовыйСрок = Дата(
			ГодНачалаДня,
			МесяцНачалаДня,
			ДеньНачалаДня,
			ЧасДаты,
			МинутаДаты,
			СекундаДаты);	
	КонецЕсли;
	Если ИзмененаДата И НовыйСрок < КонецДня(НовыйСрок)
		ИЛИ НЕ ИспользоватьВремяВСрокахЗадач Тогда
		НовыйСрок = КонецДня(НовыйСрок);
	КонецЕсли;
	
	Если ЗначениеЗаполнено(НовыйСрок) Тогда
		ДлительностьПереноса = 
			ПереносСроковВыполненияЗадачВызовСервера.ПолучитьПодписьДлительностьПереноса(
				ИсполнительПредметаРассмотрения, 
				СтарыйСрок, 
				НовыйСрок);	
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(СтарыйСрок) Тогда
		ДлительностьПереноса = "";
	КонецЕсли;	
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_РедактироватьСоставСвойств()
	
	УправлениеСвойствамиКлиент.РедактироватьСоставСвойств(ЭтаФорма, Объект.Ссылка);
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьЭлементыДополнительныхРеквизитов()
	
	УправлениеСвойствами.ОбновитьЭлементыДополнительныхРеквизитов(ЭтаФорма,
	РеквизитФормыВЗначение("Объект"));
	
КонецПроцедуры

&НаСервере
Функция ЗаписатьЗадачуНаСервере(ПараметрыЗаписи)
	
	НачатьТранзакцию();
	
	Если ПараметрыЗаписи.КоличествоПереносовПоЗадаче = 0 Тогда
		ПереносСроковВыполненияЗадач.ПеренестиСрокЗадачиПоЗаявке(
			НовыйСрок, Объект.Описание, Объект.БизнесПроцесс);
	КонецЕсли;
	
	Если Не Записать(ПараметрыЗаписи) Тогда
		ОтменитьТранзакцию();
		Возврат Ложь;
	КонецЕсли;
	
	ЗафиксироватьТранзакцию();
	
	Возврат Истина;
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции_Файлы

&НаКлиенте
Процедура ОбновитьДоступностьКомандСпискаФайлов(Результат = Неопределено, ПараметрыВыполнения = Неопределено) Экспорт
	
	УстановитьДоступностьКоманд(Элементы.Файлы.ТекущиеДанные);
	
КонецПроцедуры	

&НаКлиенте
Процедура УстановитьДоступностьКоманды(Команда, Доступность)
	
	Команда.Доступность = Доступность;
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьДоступностьКоманд(ТекущиеДанные)
	
	Если ТекущиеДанные = Неопределено Тогда 
		
		УстановитьДоступностьКоманды(Элементы.ФайлыКонтекстноеМенюОткрытьФайл, Ложь);
		УстановитьДоступностьКоманды(Элементы.ФайлыКонтекстноеМенюРедактировать, Ложь);
		УстановитьДоступностьКоманды(Элементы.ФайлыКонтекстноеМенюЗакончитьРедактирование, Ложь);
		УстановитьДоступностьКоманды(Элементы.ФайлыКонтекстноеМенюЗанять, Ложь);
		УстановитьДоступностьКоманды(Элементы.ФайлыКонтекстноеМенюСохранитьИзменения, Ложь);
		УстановитьДоступностьКоманды(Элементы.ФайлыКонтекстноеМенюСохранитьКак, Ложь);
		УстановитьДоступностьКоманды(Элементы.ФайлыКонтекстноеМенюОсвободить, Ложь);
		УстановитьДоступностьКоманды(Элементы.ФайлыКонтекстноеМенюОбновитьИзФайлаНаДиске, Ложь);	
	Иначе	
		РедактируетТекущийПользователь = ТекущиеДанные.РедактируетТекущийПользователь;
		Редактирует = ТекущиеДанные.Редактирует;
		
		УстановитьДоступностьКоманды(Элементы.ФайлыКонтекстноеМенюОткрытьФайл, Истина);
		УстановитьДоступностьКоманды(Элементы.ФайлыКонтекстноеМенюРедактировать, НЕ ТекущиеДанные.ПодписанЭП);
		УстановитьДоступностьКоманды(Элементы.ФайлыКонтекстноеМенюЗакончитьРедактирование, РедактируетТекущийПользователь);
		УстановитьДоступностьКоманды(Элементы.ФайлыКонтекстноеМенюЗанять, Редактирует.Пустая());
		УстановитьДоступностьКоманды(Элементы.ФайлыКонтекстноеМенюСохранитьИзменения, РедактируетТекущийПользователь);
		УстановитьДоступностьКоманды(Элементы.ФайлыКонтекстноеМенюСохранитьКак, Истина);
		УстановитьДоступностьКоманды(Элементы.ФайлыКонтекстноеМенюОсвободить, Не Редактирует.Пустая());
		УстановитьДоступностьКоманды(Элементы.ФайлыКонтекстноеМенюОбновитьИзФайлаНаДиске, Истина);		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ОтображатьУдаленныеФайлыСервер()
	
	РаботаСБизнесПроцессамиВызовСервера.ФормаБизнесПроцессаОтображатьУдаленныеФайлы(ЭтаФорма);
	ОбновитьВидимостьТаблицыФайлов(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ДобавитьФайл(Копирование = Ложь)
	
	Если Объект.Ссылка.Пустая() Тогда 
		Если Не Записать() Тогда 
			Возврат;
		КонецЕсли;
		
		ПоказатьОповещениеПользователя(
			"Создание:", 
			ПолучитьНавигационнуюСсылку(Объект.Ссылка),
			Строка(Объект.Ссылка),
			БиблиотекаКартинок.Информация32);
	КонецЕсли;
	
	ВладелецФайла = Объект.БизнесПроцесс;
	ФайлОснование = Элементы.Файлы.ТекущаяСтрока;
	
	Если Не Копирование Тогда
		Попытка
			РежимСоздания = 1;
			РаботаСФайламиКлиент.ДобавитьФайл(Неопределено, ВладелецФайла, ЭтаФорма, РежимСоздания, Истина);
		Исключение
			Инфо = ИнформацияОбОшибке();
			ПоказатьПредупреждение(,СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Ошибка создания нового файла: %1'"),
				КраткоеПредставлениеОшибки(Инфо)));
		КонецПопытки;
	Иначе
		РаботаСФайламиКлиент.СкопироватьФайл(ВладелецФайла, ФайлОснование);
	КонецЕсли;
	Элементы.Файлы.Обновить();
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура ОбновитьВидимостьТаблицыФайлов(Форма)
	
	Параметр = Форма.Файлы.Параметры.Элементы.Найти("ОтображатьУдаленные");
	ОтображатьУдаленные = Параметр.Значение И Параметр.Использование;
	
	КоличествоФайлов = КоличествоФайлов(Форма.Объект.БизнесПроцесс, ОтображатьУдаленные);
	
	Если КоличествоФайлов > 0 Тогда
		Форма.Элементы.Файлы.Видимость = Истина;
	Иначе
		Форма.Элементы.Файлы.Видимость = Ложь;
	КонецЕсли;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция КоличествоФайлов(ВладелецФайла, ОтображатьУдаленные)
	
	УстановитьПривилегированныйРежим(Истина);
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	Файлы.Ссылка
		|ИЗ
		|	Справочник.Файлы КАК Файлы
		|ГДЕ
		|	Файлы.ВладелецФайла = &ВладелецФайла
		|	И (&ОтображатьУдаленные
		|			ИЛИ НЕ Файлы.ПометкаУдаления)";
	Запрос.УстановитьПараметр("ВладелецФайла", ВладелецФайла);
	Запрос.УстановитьПараметр("ОтображатьУдаленные", ОтображатьУдаленные);
	
	Возврат Запрос.Выполнить().Выбрать().Количество();
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции_Хронометраж

&НаСервере
Процедура ПереключитьХронометражСервер(ПараметрыОповещения) Экспорт
	
	УчетВремени.ПереключитьХронометражСервер(
		ПараметрыОповещения,
		ДатаНачалаХронометража,
		ДатаКонцаХронометража,
		ВключенХронометраж,
		Объект.Ссылка,
		ВидыРабот,
		ЭтаФорма.Команды.ПереключитьХронометраж,
		ЭтаФорма.Элементы.ПереключитьХронометраж);
	
КонецПроцедуры

&НаСервере
Процедура ДобавитьВОтчетИОбновитьФорму(ПараметрыОтчета, ПараметрыОповещения) Экспорт
	
	УчетВремени.ДобавитьВОтчетИОбновитьФорму(
	    ПараметрыОтчета, 
		ПараметрыОповещения,
		ДатаНачалаХронометража,
		ДатаКонцаХронометража,
		ВключенХронометраж,
		ЭтаФорма.Команды.ПереключитьХронометраж,
		ЭтаФорма.Элементы.ПереключитьХронометраж);
	
КонецПроцедуры

&НаСервере
Процедура ОтключитьХронометражСервер() Экспорт
	
	УчетВремени.ОтключитьХронометражСервер(
		ДатаНачалаХронометража,
		ДатаКонцаХронометража,
		ВключенХронометраж,
		Объект.Ссылка,
		ЭтаФорма.Команды.ПереключитьХронометраж,
		ЭтаФорма.Элементы.ПереключитьХронометраж);
	
КонецПроцедуры

#КонецОбласти
