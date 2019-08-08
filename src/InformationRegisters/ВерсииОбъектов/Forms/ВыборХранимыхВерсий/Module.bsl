#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	УстановитьУсловноеОформление();
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	Ссылка = Параметры.Ссылка;
	
	Если ВерсионированиеОбъектов.НомерПоследнейВерсии(Ссылка) = 0 Тогда
		Элементы.ОсновнаяСтраница.ТекущаяСтраница = Элементы.ВерсииДляСравненияОтсутствуют;
		Элементы.НетВерсий.Заголовок = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = 'Предыдущие версии отсутствуют: ""%1"".'"), Строка(Ссылка));
	КонецЕсли;
	
	ОбновитьСписокВерсий();
	
	ПереходНаВерсиюРазрешен = Пользователи.ЭтоПолноправныйПользователь();
	Элементы.ПерейтиНаВерсию.Видимость = ПереходНаВерсиюРазрешен;
	Элементы.ТехническиеСведенияОбИзмененииОбъекта.Видимость = ПереходНаВерсиюРазрешен;
	
	Реквизиты = НСтр("ru = 'Все'")
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	УстановитьДоступность();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура РеквизитыНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	ОписаниеОповещения = Новый ОписаниеОповещения("ПриВыбореРеквизитов", ЭтотОбъект);
	ОткрытьФорму("РегистрСведений.ВерсииОбъектов.Форма.ВыборРеквизитовОбъекта", Новый Структура(
		"Ссылка,Отбор", Ссылка, Отбор.ВыгрузитьЗначения()), , , , , ОписаниеОповещения);
КонецПроцедуры

&НаКлиенте
Процедура ЖурналРегистрацииНажатие(Элемент)
	ЖурналРегистрацииКлиент.ОткрытьЖурналРегистрации();
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСписокВерсий

&НаКлиенте
Процедура ДеревоВерсийВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	ОткрытьОтчетПоВерсииОбъекта();
КонецПроцедуры

&НаКлиенте
Процедура ДеревоВерсийПриАктивизацииСтроки(Элемент)
	УстановитьДоступность();
КонецПроцедуры

&НаКлиенте
Процедура ДеревоВерсийКомментарийПриИзменении(Элемент)
	ТекущиеДанные = Элементы.ДеревоВерсий.ТекущиеДанные;
	Если ТекущиеДанные <> Неопределено Тогда
		ДобавитьКомментарийКВерсии(Ссылка, ТекущиеДанные.НомерВерсии, ТекущиеДанные.Комментарий);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ДеревоВерсийПередНачаломИзменения(Элемент, Отказ)
	Если Не РедактированиеКомментарияРазрешено(Элемент.ТекущиеДанные.АвторВерсии) Тогда
		Отказ = Истина;
	КонецЕсли;
КонецПроцедуры


#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОткрытьВерсиюОбъекта(Команда)
	
	ОткрытьОтчетПоВерсииОбъекта();
	
КонецПроцедуры

&НаКлиенте
Процедура ПерейтиНаВерсию(Команда)
	
	ВыполнитьПереходНаВыбраннуюВерсию();
	
КонецПроцедуры

&НаКлиенте
Процедура СформироватьОтчетПоИзменениям(Команда)
	
	ВыделенныеСтроки = Элементы.ДеревоВерсий.ВыделенныеСтроки;
	СравниваемыеВерсии = СформироватьСписокВыбранныхВерсий(ВыделенныеСтроки);
	
	Если СравниваемыеВерсии.Количество() < 2 Тогда
		ПоказатьПредупреждение(, НСтр("ru = 'Для формирования отчета по изменениям необходимо выбрать хотя бы две версии.'"));
		Возврат;
	КонецЕсли;
	
	ОткрытьФормуОтчета(СравниваемыеВерсии);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Функция СформироватьТаблицуВерсий()
	
	Если ВерсионированиеОбъектов.ЕстьПравоЧтенияДанныхВерсийОбъектов() Тогда
		УстановитьПривилегированныйРежим(Истина);
	КонецЕсли;
	
	НомераВерсий = Новый Массив;
	Если Отбор.Количество() > 0 Тогда
		НомераВерсий = НомераВерсийСИзменениямиВВыбранныхРеквизитах();
	КонецЕсли;
	
	ТекстЗапроса = 
	"ВЫБРАТЬ
	|	ВерсииОбъектов.НомерВерсии КАК НомерВерсии,
	|	ВерсииОбъектов.АвторВерсии КАК АвторВерсии,
	|	ВерсииОбъектов.ДатаВерсии КАК ДатаВерсии,
	|	ВерсииОбъектов.Комментарий КАК Комментарий,
	|	ВерсииОбъектов.КонтрольнаяСумма,
	|	ВерсииОбъектов.ЕстьДанныеВерсии,
	|	&БезОтбора
	|		ИЛИ ВерсииОбъектов.НомерВерсии В (&НомераВерсий) КАК СоответствуетОтбору,
	|	ВерсииОбъектов.ВерсияВладелец,
	|	ВерсииОбъектов.ТипВерсииОбъекта,
	|	ВерсииОбъектов.Узел
	|ИЗ
	|	РегистрСведений.ВерсииОбъектов КАК ВерсииОбъектов
	|ГДЕ
	|	ВерсииОбъектов.Объект = &Ссылка
	|
	|УПОРЯДОЧИТЬ ПО
	|	НомерВерсии УБЫВ";
	
	Запрос = Новый Запрос(ТекстЗапроса);
	Запрос.УстановитьПараметр("БезОтбора", Отбор.Количество() = 0);
	Запрос.УстановитьПараметр("НомераВерсий", НомераВерсий);
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	
	ТаблицаВерсий = Запрос.Выполнить().Выгрузить();
	
	ТаблицаВерсий.Колонки.Добавить("ТекущаяВерсия", Новый ОписаниеТипов("Булево"));
	
	ПользовательскиеВерсии = ТаблицаВерсий.НайтиСтроки(Новый Структура("ТипВерсииОбъекта", Перечисления.ТипыВерсийОбъекта.ИзмененоПользователем));
	Если ПользовательскиеВерсии.Количество() > 0 Тогда
		ПользовательскиеВерсии[0].ЕстьДанныеВерсии = Истина;
		ПользовательскиеВерсии[0].ТекущаяВерсия = Истина;
		НомерТекущейВерсии = ПользовательскиеВерсии[0].НомерВерсии;
	КонецЕсли;
	
	Для Индекс = 1 По ПользовательскиеВерсии.Количество() - 1 Цикл
		Если Не ПользовательскиеВерсии[Индекс].ЕстьДанныеВерсии Тогда
			Если ПустаяСтрока(ПользовательскиеВерсии[Индекс].КонтрольнаяСумма) Или ПользовательскиеВерсии[Индекс].КонтрольнаяСумма = ПользовательскиеВерсии[Индекс-1].КонтрольнаяСумма Тогда
				ПользовательскиеВерсии[Индекс].ЕстьДанныеВерсии = ПользовательскиеВерсии[Индекс-1].ЕстьДанныеВерсии;
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	
	ИмяЭтойИнформационнойБазы = ИмяЭтойИнформационнойБазы();
	Для Каждого Версия Из ТаблицаВерсий Цикл
		Если ПустаяСтрока(Версия.Узел) Тогда
			Версия.Узел = ИмяЭтойИнформационнойБазы;
		КонецЕсли;
	КонецЦикла;
	
	Результат = ТаблицаВерсий.Скопировать(ТаблицаВерсий.НайтиСтроки(Новый Структура("СоответствуетОтбору", Истина)),
		"НомерВерсии, АвторВерсии, ДатаВерсии, Комментарий, ЕстьДанныеВерсии, ВерсияВладелец, Узел, ТекущаяВерсия");
		
	Возврат Результат;
	
КонецФункции

&НаКлиенте
Процедура ВыполнитьПереходНаВыбраннуюВерсию(ОтменятьПроведение = Ложь)
	
	ТекущиеДанные = Элементы.ДеревоВерсий.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ПредставлениеНомераВерсии = ТекущиеДанные.ПредставлениеНомераВерсии;
	Результат = ПерейтиНаВерсиюСервер(Ссылка, ТекущиеДанные.НомерВерсии, ПредставлениеНомераВерсии, ОтменятьПроведение);
	
	Если Результат = "ОшибкаВосстановления" Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщенияОбОшибке);
	ИначеЕсли Результат = "ОшибкаПроведения" Тогда
		ТекстВопроса = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Переход на версию не был выполнен по причине:
				|%1
				|Перейти на выбранную версию с отменой проведения?'"),
			ТекстСообщенияОбОшибке);
			
		ОписаниеОповещения = Новый ОписаниеОповещения("ВыполнитьПереходНаВыбраннуюВерсиюВопросЗадан", ЭтотОбъект);
		Кнопки = Новый СписокЗначений;
		Кнопки.Добавить("Перейти", НСтр("ru = 'Перейти'"));
		Кнопки.Добавить(КодВозвратаДиалога.Отмена);
		ПоказатьВопрос(ОписаниеОповещения, ТекстВопроса, Кнопки);
	Иначе //Результат = "ВосстановлениеВыполнено"
		ОповеститьОбИзменении(Ссылка);
		Если ВладелецФормы <> Неопределено Тогда
			Попытка
				ВладелецФормы.Прочитать();
			Исключение
				// Ничего не делаем, если у формы нет метода Прочитать().
			КонецПопытки;
		КонецЕсли;
		ПоказатьОповещениеПользователя(
			СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = 'Восстановлена версия № %1.'"), ПредставлениеНомераВерсии),
			ПолучитьНавигационнуюСсылку(Ссылка),
			Строка(Ссылка),
			БиблиотекаКартинок.Информация32);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВыполнитьПереходНаВыбраннуюВерсиюВопросЗадан(РезультатВопроса, ДополнительныеПараметры) Экспорт
	Если РезультатВопроса <> "Перейти" Тогда
		Возврат;
	КонецЕсли;
	
	ВыполнитьПереходНаВыбраннуюВерсию(Истина);
КонецПроцедуры

&НаСервере
Функция ПерейтиНаВерсиюСервер(Ссылка, НомерВерсии, ПользовательскоеПредставлениеНомера, ОтменаПроведения = Ложь)
	
	Информация = ВерсионированиеОбъектов.СведенияОВерсииОбъекта(Ссылка, НомерВерсии);
	ДополнительныеРеквизиты = Неопределено;
	Если ТипЗнч(Информация.ВерсияОбъекта) = Тип("Структура") Тогда
		Если Информация.ВерсияОбъекта.Свойство("ДополнительныеРеквизиты", ДополнительныеРеквизиты) Тогда
			НайденныеРеквизиты = ДополнительныеРеквизиты.НайтиСтроки(Новый Структура("Идентификатор", Неопределено));
			Для Каждого Реквизит Из НайденныеРеквизиты Цикл
				ДополнительныеРеквизиты.Удалить(Реквизит);
			КонецЦикла;
		КонецЕсли;
	КонецЕсли;
	
	ТекстСообщенияОбОшибке = "";
	Объект = ВерсионированиеОбъектов.ВосстановитьОбъектПоXML(Информация.ВерсияОбъекта, ТекстСообщенияОбОшибке);
	
	Если Не ПустаяСтрока(ТекстСообщенияОбОшибке) Тогда
		Возврат "ОшибкаВосстановления";
	КонецЕсли;
	
	Объект.ДополнительныеСвойства.Вставить("ВерсионированиеОбъектовКомментарийКВерсии",
		СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = 'Выполнен переход к версии №%1 от %2'"),
			ПользовательскоеПредставлениеНомера,
			Формат(Информация.ДатаВерсии, "ДЛФ=DT")));
			
	НачатьТранзакцию();
	
	РежимЗаписи = Неопределено;
	ИдентификаторОшибки = "ОшибкаВосстановления";
	
	Если ОбщегоНазначения.ЭтоДокумент(Объект.Метаданные()) Тогда
		Если Объект.Проведен И Не ОтменаПроведения Тогда
			РежимЗаписи = РежимЗаписиДокумента.Проведение;
		Иначе
			РежимЗаписи = РежимЗаписиДокумента.ОтменаПроведения;
		КонецЕсли;
		ИдентификаторОшибки = "ОшибкаПроведения";
	КонецЕсли;
	
	ВерсионированиеОбъектов.ЗаписатьДанныеТекущейВерсии(Ссылка);
	ВерсионированиеОбъектов.ВыполняетсяЗаписьОбъекта(Истина);
	Попытка
		Если ЗначениеЗаполнено(РежимЗаписи) Тогда
			Объект.Записать(РежимЗаписи);
		Иначе
			Объект.Записать();
		КонецЕсли;
		Если ЗначениеЗаполнено(ДополнительныеРеквизиты) Тогда
			Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.Свойства") Тогда
				МодульУправлениеСвойствамиСлужебный = ОбщегоНазначения.ОбщийМодуль("УправлениеСвойствамиСлужебный");
				МодульУправлениеСвойствамиСлужебный.ПриВосстановленииВерсииОбъекта(Объект, ДополнительныеРеквизиты);
			КонецЕсли;
			ВерсионированиеОбъектовПереопределяемый.ПриВосстановленииВерсииОбъекта(Объект, ДополнительныеРеквизиты);
		КонецЕсли;
		ВерсионированиеОбъектов.ВыполняетсяЗаписьОбъекта(Ложь);
		ВерсионированиеОбъектов.ЗаписатьВерсиюОбъекта(Объект);
		ЗафиксироватьТранзакцию();
	Исключение
		ВерсионированиеОбъектов.ВыполняетсяЗаписьОбъекта(Ложь);
		ОтменитьТранзакцию();
		ТекстСообщенияОбОшибке = КраткоеПредставлениеОшибки(ИнформацияОбОшибке());
		Возврат ИдентификаторОшибки;
	КонецПопытки;
	
	ОбновитьСписокВерсий();
	Возврат "ВосстановлениеВыполнено";
	
КонецФункции

&НаКлиенте
Процедура ОткрытьОтчетПоВерсииОбъекта()
	
	СравниваемыеВерсии = Новый СписокЗначений;
	СравниваемыеВерсии.Добавить(Элементы.ДеревоВерсий.ТекущиеДанные.НомерВерсии, Элементы.ДеревоВерсий.ТекущиеДанные.ПредставлениеНомераВерсии);
	ОткрытьФормуОтчета(СравниваемыеВерсии);
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьФормуОтчета(СравниваемыеВерсии)
	
	ПараметрыОтчета = Новый Структура;
	ПараметрыОтчета.Вставить("Ссылка", Ссылка);
	ПараметрыОтчета.Вставить("СравниваемыеВерсии", СравниваемыеВерсии);
	
	ОткрытьФорму("РегистрСведений.ВерсииОбъектов.Форма.ОтчетПоВерсиямОбъекта",
		ПараметрыОтчета,
		ЭтотОбъект,
		УникальныйИдентификатор);
	
КонецПроцедуры

&НаКлиенте
Функция СформироватьСписокВыбранныхВерсий(ВыделенныеСтроки)
	
	СравниваемыеВерсии = Новый СписокЗначений;
	
	Для Каждого НомерВыделеннойСтроки Из ВыделенныеСтроки Цикл
		ДанныеСтроки = Элементы.ДеревоВерсий.ДанныеСтроки(НомерВыделеннойСтроки);
		СравниваемыеВерсии.Добавить(ДанныеСтроки.НомерВерсии, ДанныеСтроки.ПредставлениеНомераВерсии);
	КонецЦикла;
	
	СравниваемыеВерсии.СортироватьПоЗначению(НаправлениеСортировки.Возр);
	
	Если СравниваемыеВерсии.Количество() = 1 Тогда
		Если СравниваемыеВерсии.НайтиПоЗначению(НомерТекущейВерсии) = Неопределено Тогда
			СравниваемыеВерсии.Добавить(НомерТекущейВерсии);
		КонецЕсли;
	КонецЕсли;
	
	Возврат СравниваемыеВерсии;
	
КонецФункции

&НаКлиенте
Процедура УстановитьДоступность()
	
	ВыбранаОднаВерсия = Элементы.ДеревоВерсий.ВыделенныеСтроки.Количество() = 1;
	ВыбраноНесколькоВерсий = Элементы.ДеревоВерсий.ВыделенныеСтроки.Количество() > 1;
	
	Элементы.ОткрытьВерсиюОбъекта.Доступность = ВыбранаОднаВерсия;
	Элементы.ДеревоВерсийКонтекстноеМенюОткрытьВерсию.Доступность = ВыбранаОднаВерсия;
	
	Элементы.ПерейтиНаВерсию.Доступность = ВыбранаОднаВерсия;
	Элементы.ДеревоВерсийКонтекстноеМенюПерейтиНаВерсию.Доступность = ВыбранаОднаВерсия;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриВыбореРеквизитов(РезультатВыбора, ДополнительныеПараметры) Экспорт
	Если РезультатВыбора = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Реквизиты = РезультатВыбора.ПредставлениеВыбранных;
	Отбор.ЗагрузитьЗначения(РезультатВыбора.ВыбранныеРеквизиты);
	ОбновитьСписокВерсий();
КонецПроцедуры

&НаСервере
Процедура ОбновитьСписокВерсий()
	
	ТаблицаВерсий = СформироватьТаблицуВерсий();
	
	ТаблицаВерсий.Сортировать("ВерсияВладелец Возр, НомерВерсии Убыв");
	
	ИерархияВерсий = РеквизитФормыВЗначение("ДеревоВерсий");
	ИерархияВерсий.Строки.Очистить();
	
	ЗаполнитьИерархиюВерсий(ИерархияВерсий, ТаблицаВерсий);
	ПронумероватьВерсии(ИерархияВерсий.Строки);
	
	ЗначениеВРеквизитФормы(ИерархияВерсий, "ДеревоВерсий");
	
	ТаблицаВерсий.Свернуть("Узел");
	Элементы.ДеревоВерсийУзел.Видимость = ТаблицаВерсий.Количество() > 1 Или ТаблицаВерсий.Количество() = 1 И ТаблицаВерсий[0].Узел <> ИмяЭтойИнформационнойБазы();
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьИерархиюВерсий(ИерархияВерсий, СписокВерсий)
	
	ПропущенныеВерсии = Новый Массив;
	Для Каждого ОписаниеВерсии Из СписокВерсий Цикл
		Если ОписаниеВерсии.ВерсияВладелец = 0 Тогда
			Элемент = ИерархияВерсий.Строки.Добавить();
		Иначе
			НайденнаяВерсия = ИерархияВерсий.Строки.Найти(ОписаниеВерсии.ВерсияВладелец, "НомерВерсии", Истина);
			Если НайденнаяВерсия <> Неопределено Тогда
				Элемент = НайденнаяВерсия.Строки.Добавить();
				НайденнаяВерсия.Отклонена = Истина;
			Иначе
				ПропущенныеВерсии.Добавить(ОписаниеВерсии);
				Продолжить;
			КонецЕсли;
		КонецЕсли;
		ЗаполнитьЗначенияСвойств(Элемент, ОписаниеВерсии);
	КонецЦикла;
	
	Если ПропущенныеВерсии.Количество() > 0 Тогда
		Если СписокВерсий.Количество() = ПропущенныеВерсии.Количество() Тогда
			ВызватьИсключение НСтр("ru = 'Не удалось сформировать полный список версий. Часть вложенных версий пропущена.'");
		КонецЕсли;
		ЗаполнитьИерархиюВерсий(ИерархияВерсий, ПропущенныеВерсии);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПронумероватьВерсии(КоллекцияВерсий)
	
	ТекущийНомерВерсии = КоллекцияВерсий.Количество();
	Для Каждого Версия Из КоллекцияВерсий Цикл
		ПрефиксНомера = "";
		Если Версия.Родитель <> Неопределено И Не ПустаяСтрока(Версия.Родитель.ПредставлениеНомераВерсии) Тогда
			ПрефиксНомера = Версия.Родитель.ПредставлениеНомераВерсии + ".";
		КонецЕсли;
		
		Версия.ПредставлениеНомераВерсии = ПрефиксНомера + Формат(ТекущийНомерВерсии, "ЧГ=0");
		ПронумероватьВерсии(Версия.Строки);
		ТекущийНомерВерсии = ТекущийНомерВерсии - 1;
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура РеквизитыОчистка(Элемент, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	Реквизиты = НСтр("ru = 'Все'");
	Отбор.Очистить();
	ОбновитьСписокВерсий();
КонецПроцедуры

&НаСервере
Функция НомераВерсийСИзменениямиВВыбранныхРеквизитах()
	ТекстЗапроса =
	"ВЫБРАТЬ
	|	ВерсииОбъектов.НомерВерсии КАК НомерВерсии,
	|	ВерсииОбъектов.ЕстьДанныеВерсии,
	|	ВерсииОбъектов.ВерсияОбъекта КАК Данные
	|ИЗ
	|	РегистрСведений.ВерсииОбъектов КАК ВерсииОбъектов
	|ГДЕ
	|	ВерсииОбъектов.ТипВерсииОбъекта = ЗНАЧЕНИЕ(Перечисление.ТипыВерсийОбъекта.ИзмененоПользователем)
	|	И ВерсииОбъектов.Объект = &Ссылка
	|
	|УПОРЯДОЧИТЬ ПО
	|	НомерВерсии УБЫВ";
	
	Запрос = Новый Запрос(ТекстЗапроса);
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	ХранимыеВерсии = Запрос.Выполнить().Выгрузить();
	
	ДанныеВерсии = Новый ХранилищеЗначения(ВерсионированиеОбъектов.СериализоватьОбъект(Ссылка.ПолучитьОбъект()), Новый СжатиеДанных(9));
	ТекущаяВерсия = ХранимыеВерсии[0];
	ТекущаяВерсия.Данные = ДанныеВерсии;
	ТекущаяВерсия.НомерВерсии = ВерсионированиеОбъектов.НомерПоследнейВерсии(Ссылка);
	ТекущаяВерсия.ЕстьДанныеВерсии = Истина;
	
	Для Каждого ОписаниеВерсии Из ХранимыеВерсии Цикл
		Если Не ОписаниеВерсии.ЕстьДанныеВерсии Тогда
			ОписаниеВерсии.Данные = ДанныеВерсии;
		Иначе
			ДанныеВерсии = ОписаниеВерсии.Данные;
		КонецЕсли;
	КонецЦикла;
	
	Результат = Новый Массив;
	Результат.Добавить(ХранимыеВерсии[ХранимыеВерсии.Количество() - 1].НомерВерсии);
	
	ДанныеОбъекта = ХранимыеВерсии[0].Данные.Получить();
	Если ТипЗнч(ДанныеОбъекта) = Тип("Структура") Тогда
		ДанныеОбъекта = ДанныеОбъекта.Объект;
	КонецЕсли;
	ТекущаяВерсия = ВерсионированиеОбъектов.РазборПредставленияОбъектаXML(ДанныеОбъекта, Ссылка);
	Для НомерСтроки = 1 По ХранимыеВерсии.Количество() - 1 Цикл
		ОписаниеВерсии = ХранимыеВерсии[НомерСтроки];
		
		ДанныеОбъекта = ОписаниеВерсии.Данные.Получить();
		Если ТипЗнч(ДанныеОбъекта) = Тип("Структура") Тогда
			ДанныеОбъекта = ДанныеОбъекта.Объект;
		КонецЕсли;
		ПредыдущаяВерсия = ВерсионированиеОбъектов.РазборПредставленияОбъектаXML(ДанныеОбъекта, Ссылка);
		
		Если ЕстьИзменениеРеквизитов(ТекущаяВерсия, ПредыдущаяВерсия, Отбор.ВыгрузитьЗначения()) Тогда
			Результат.Добавить(ХранимыеВерсии[НомерСтроки - 1].НомерВерсии);
		КонецЕсли;
		ТекущаяВерсия =ПредыдущаяВерсия;
	КонецЦикла;
	
	Возврат Результат;
КонецФункции

&НаСервере
Функция ЕстьИзменениеРеквизитов(ТекущаяВерсия, ПредыдущаяВерсия, СписокРеквизитов)
	Для Каждого Реквизит Из СписокРеквизитов Цикл
		ИмяТабличнойЧасти = Неопределено;
		ИмяРеквизита = Реквизит;
		Если СтрНайти(ИмяРеквизита, ".") > 0 Тогда
			ЧастиИмени = СтрРазделить(ИмяРеквизита, ".", Ложь);
			Если ЧастиИмени.Количество() > 1 Тогда
				ИмяТабличнойЧасти = ЧастиИмени[0];
				ИмяРеквизита = ЧастиИмени[1];
			КонецЕсли;
		КонецЕсли;
		
		// Проверка изменения реквизита табличной части.
		Если ИмяТабличнойЧасти <> Неопределено Тогда
			ТекущаяТабличнаяЧасть = ТекущаяВерсия.ТабличныеЧасти[ИмяТабличнойЧасти];
			ПредыдущаяТабличнаяЧасть = ПредыдущаяВерсия.ТабличныеЧасти[ИмяТабличнойЧасти];
			
			// Табличная часть отсутствует.
			Если ТекущаяТабличнаяЧасть = Неопределено Или ПредыдущаяТабличнаяЧасть = Неопределено Тогда
				Возврат Не ТекущаяТабличнаяЧасть = Неопределено И ПредыдущаяТабличнаяЧасть = Неопределено;
			КонецЕсли;
			
			// Если изменилось количество строк ТЧ.
			Если ТекущаяТабличнаяЧасть.Количество() <> ПредыдущаяТабличнаяЧасть.Количество() Тогда
				Возврат Истина;
			КонецЕсли;
			
			// реквизит отсутствует
			ТекущийРеквизитСуществует = ТекущаяТабличнаяЧасть.Колонки.Найти(ИмяРеквизита) <> Неопределено;
			ПредыдущийРеквизитСуществует = ПредыдущаяТабличнаяЧасть.Колонки.Найти(ИмяРеквизита) <> Неопределено;
			Если ТекущийРеквизитСуществует <> ПредыдущийРеквизитСуществует Тогда
				Возврат Истина;
			КонецЕсли;
			Если Не ТекущийРеквизитСуществует Тогда
				Возврат Ложь;
			КонецЕсли;
			
			// сравнение по строкам
			Для НомерСтроки = 0 По ТекущаяТабличнаяЧасть.Количество() - 1 Цикл
				Если ТекущаяТабличнаяЧасть[НомерСтроки][ИмяРеквизита] <> ПредыдущаяТабличнаяЧасть[НомерСтроки][ИмяРеквизита] Тогда
					Возврат Истина;
				КонецЕсли;
			КонецЦикла;
			
			Возврат Ложь;
		КонецЕсли;
		
		// проверка реквизита шапки
		
		ТекущийРеквизит = ТекущаяВерсия.Реквизиты.Найти(ИмяРеквизита, "НаименованиеРеквизита");
		ТекущийРеквизитСуществует = ТекущийРеквизит <> Неопределено;
		ЗначениеТекущегоРеквизита = Неопределено;
		Если ТекущийРеквизитСуществует Тогда
			ЗначениеТекущегоРеквизита = ТекущийРеквизит.ЗначениеРеквизита;
		КонецЕсли;
		
		ПредыдущийРеквизит = ПредыдущаяВерсия.Реквизиты.Найти(ИмяРеквизита, "НаименованиеРеквизита");
		ПредыдущийРеквизитСуществует = ПредыдущийРеквизит <> Неопределено;
		ЗначениеПредыдущегоРеквизита = Неопределено;
		Если ПредыдущийРеквизитСуществует Тогда
			ЗначениеПредыдущегоРеквизита = ПредыдущийРеквизит.ЗначениеРеквизита;
		КонецЕсли;
		
		Если ТекущийРеквизитСуществует <> ПредыдущийРеквизитСуществует
			Или ЗначениеТекущегоРеквизита <> ЗначениеПредыдущегоРеквизита Тогда
			Возврат Истина;
		КонецЕсли;
	КонецЦикла;
	
	Возврат Ложь;
КонецФункции

&НаСервереБезКонтекста
Процедура ДобавитьКомментарийКВерсии(СсылкаНаОбъект, НомерВерсии, Комментарий);
	ВерсионированиеОбъектов.ДобавитьКомментарийКВерсии(СсылкаНаОбъект, НомерВерсии, Комментарий);
КонецПроцедуры

&НаСервере
Функция РедактированиеКомментарияРазрешено(АвторВерсии)
	Возврат Пользователи.ЭтоПолноправныйПользователь()
		Или АвторВерсии = Пользователи.ТекущийПользователь();
КонецФункции

&НаСервере
Процедура УстановитьУсловноеОформление()
	
	УсловноеОформление.Элементы.Очистить();
	
	// Отсутствующие данные у версий
	Элемент = УсловноеОформление.Элементы.Добавить();
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ДеревоВерсий.ЕстьДанныеВерсии");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Ложь;
	
	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.ТекстЗапрещеннойЯчейкиЦвет);
	
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ДеревоВерсий.Имя);
	
	
	// Отклоненные версии
	
	Элемент = УсловноеОформление.Элементы.Добавить();
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ДеревоВерсий.Отклонена");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Истина;
	
	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.ТекстЗапрещеннойЯчейкиЦвет);
	
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ДеревоВерсий.Имя);
	
	// Текущая версия
	
	Элемент = УсловноеОформление.Элементы.Добавить();
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ДеревоВерсий.ТекущаяВерсия");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Истина;
	
	Шрифт = Новый Шрифт(Элементы.ДеревоВерсийПредставлениеНомераВерсии.Шрифт, , , Истина, , , , );
	
	Элемент.Оформление.УстановитьЗначениеПараметра("Шрифт", Шрифт);
	
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ДеревоВерсий.Имя);
	
КонецПроцедуры

&НаСервере
Функция ИмяЭтойИнформационнойБазы()
	Возврат НСтр("ru = 'Эта программа'");
КонецФункции

#КонецОбласти
