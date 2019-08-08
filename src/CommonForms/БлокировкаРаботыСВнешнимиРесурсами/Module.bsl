
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	СтрокаСоединения = СтрокаСоединенияИнформационнойБазы();
	СохраненныеПараметры = Константы.ПараметрыБлокировкиРаботыСВнешнимиРесурсами.Получить().Получить();
	ПараметрыБлокировки = РегламентныеЗаданияСлужебный.ПараметрыБлокировкиРаботыСВнешнимиРесурсами();
	ЗаполнитьЗначенияСвойств(ПараметрыБлокировки, СохраненныеПараметры);
	ТекстСнятияБлокировки = РегламентныеЗаданияСлужебный.ЗначениеНастройки("РасположениеКомандыСнятияБлокировки");
	РазделениеВключено = ОбщегоНазначенияПовтИсп.РазделениеВключено();
	ИзменилосьРазделение = ПараметрыБлокировки.РазделениеВключено <> РазделениеВключено;
	
	Если Не РазделениеВключено И Не ИзменилосьРазделение Тогда
		СохраненнаяСтрокаСоединения = ПараметрыБлокировки.СтрокаСоединения;
		ПараметрыСохраненнойСтрокиСоединения = СтроковыеФункцииКлиентСервер.ПолучитьПараметрыИзСтроки(СохраненнаяСтрокаСоединения);
		Если ПараметрыСохраненнойСтрокиСоединения.Свойство("File") Тогда
			СохраненнаяСтрокаСоединения = ПараметрыСохраненнойСтрокиСоединения.File;
		КонецЕсли;
		ТекущаяСтрокаСоединения = СтрокаСоединения;
		ПараметрыТекущейСтрокиСоединения = СтроковыеФункцииКлиентСервер.ПолучитьПараметрыИзСтроки(ТекущаяСтрокаСоединения);
		Если ПараметрыТекущейСтрокиСоединения.Свойство("File") Тогда
			ТекущаяСтрокаСоединения = ПараметрыТекущейСтрокиСоединения.File;
		КонецЕсли;
		ЗаголовокНадписи = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Размещение информационной базы изменилось с
				|<b>%1</b>
				|на 
				|<b>%2</b>
				|
				|<a href = ""ЖурналРегистрации"">Техническая информация о причине блокировки</a>
				|
				|* Если информационная база будет использоваться для ведения учета, нажмите <b>Информационная база перемещена</b>.
				|* При выборе варианта <b>Это копия информационной базы</b> работа со всеми внешними ресурсами
				|  (синхронизация данных, отправка почты и т.п.), выполняемая по расписанию,
				|  будет заблокирована для предотвращения конфликтов с основой информационной базой.
				|
				|%3'"), СохраненнаяСтрокаСоединения, ТекущаяСтрокаСоединения, ТекстСнятияБлокировки);
	ИначеЕсли Не РазделениеВключено И ИзменилосьРазделение Тогда
		ЗаголовокНадписи = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Информационная база была загружена из приложения в Интернете
				|
				|* Если информационная база будет использоваться для ведения учета, нажмите <b>Информационная база перемещена</b>.
				|* При выборе варианта <b>Это копия информационной базы</b> работа со всеми внешними ресурсами
				|  (синхронизация данных, отправка почты и т.п.), выполняемая по расписанию,
				|  будет заблокирована для предотвращения конфликтов с приложением в Интернете.
				|
				|%1'"), ТекстСнятияБлокировки);
	ИначеЕсли РазделениеВключено И Не ИзменилосьРазделение Тогда
		ЗаголовокНадписи = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр(" ru = 'Приложение было перемещено
				|
				|* Если приложение будет использоваться для ведения учета, нажмите <b>Приложение перемещено</b>.
				|* При выборе варианта <b>Это копия приложения</b> работа со всеми внешними ресурсами
				|  (синхронизация данных, отправка почты и т.п.), выполняемая по расписанию,
				|  будет заблокирована для предотвращения конфликтов с приложением в Интернете.
				|
				|%1'"), ТекстСнятияБлокировки);
		Элементы.ИнформационнаяБазаПеремещена.Заголовок = НСтр("ru = 'Приложение перемещено'");
		Элементы.ЭтоКопияИнформационнойБазы.Заголовок = НСтр("ru = 'Это копия приложения'");
		Заголовок = НСтр("ru = 'Приложение было перемещено или восстановлено из резервной копии'");
	Иначе // Если РазделениеВключено И ИзменилосьРазделение
		ЗаголовокНадписи = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр(" ru = 'Приложение было загружено из локальной версии
				|
				|* Если приложение будет использоваться для ведения учета, нажмите <b>Приложение перемещено</b>.
				|* При выборе варианта <b>Это копия приложения</b> работа со всеми внешними ресурсами
				|  (синхронизация данных, отправка почты и т.п.), выполняемая по расписанию,
				|  будет заблокирована для предотвращения конфликтов с локальной версией.
				|
				|%1'"), ТекстСнятияБлокировки);
		Элементы.ИнформационнаяБазаПеремещена.Заголовок = НСтр("ru = 'Приложение перемещено'");
		Элементы.ЭтоКопияИнформационнойБазы.Заголовок = НСтр("ru = 'Это копия приложения'");
		Заголовок = НСтр("ru = 'Приложение было перемещено или восстановлено из резервной копии'");
	КонецЕсли;
	
	Элементы.НадписьПредупреждение.Заголовок = СтроковыеФункцииКлиентСервер.ФорматированнаяСтрока(ЗаголовокНадписи);
	
	Если ОбщегоНазначения.ИнформационнаяБазаФайловая(СтрокаСоединения) Тогда
		Элементы.ФормаГруппаЕще.Видимость = Ложь;
	Иначе
		Элементы.ФормаПроверятьИмяСервера.Пометка = ПараметрыБлокировки.ПроверятьИмяСервера;
		Элементы.ФормаСправка.Видимость = Ложь;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура НадписьПредупреждениеОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("СобытиеЖурналаРегистрации",
		НСтр("ru = 'Работа с внешними ресурсами заблокирована'",
		ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка()));
	ОткрытьФорму("Обработка.ЖурналРегистрации.Форма.ЖурналРегистрации", ПараметрыФормы);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ИнформационнаяБазаПеремещена(Команда)
	ИнформационнаяБазаПеремещенаНаСервере();
	Закрыть();
КонецПроцедуры

&НаКлиенте
Процедура ЭтоКопияИнформационнойБазы(Команда)
	ЭтоКопияИнформационнойБазыНаСервере();
	Закрыть();
КонецПроцедуры

&НаКлиенте
Процедура ПроверятьИмяСервера(Команда)
	ПараметрыБлокировки.ПроверятьИмяСервера = Не ПараметрыБлокировки.ПроверятьИмяСервера;
	Элементы.ФормаПроверятьИмяСервера.Пометка = ПараметрыБлокировки.ПроверятьИмяСервера;
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ИнформационнаяБазаПеремещенаНаСервере()
	
	РегламентныеЗаданияСлужебный.РазрешитьРаботуСВнешнимиРесурсами(ПараметрыБлокировки);
	
КонецПроцедуры

&НаСервере
Процедура ЭтоКопияИнформационнойБазыНаСервере()
	
	ЗависимостиЗаданий = РегламентныеЗаданияСлужебный.РегламентныеЗаданияЗависимыеОтФункциональныхОпций();
	НайденныеСтроки = ЗависимостиЗаданий.НайтиСтроки(Новый Структура("РаботаетСВнешнимиРесурсами", Истина));
	ОбработанныеЗадания = Новый Соответствие;
	Для Каждого СтрокаЗадания Из НайденныеСтроки Цикл
		Если ОбработанныеЗадания.Получить(СтрокаЗадания.РегламентноеЗадание) <> Неопределено Тогда
			Продолжить; // Задание уже было отключено.
		КонецЕсли;
		ОбработанныеЗадания.Вставить(СтрокаЗадания.РегламентноеЗадание);
		Если ОбщегоНазначенияПовтИсп.РазделениеВключено() Тогда
			Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.РаботаВМоделиСервиса.ОчередьЗаданий") Тогда
				ПараметрыЗадания = Новый Структура;
				ПараметрыЗадания.Вставить("ОбластьДанных", ОбщегоНазначения.ЗначениеРазделителяСеанса());
				ПараметрыЗадания.Вставить("ИмяМетода", СтрокаЗадания.РегламентноеЗадание.ИмяМетода);
				ПараметрыЗадания.Вставить("Использование", Истина);
				МодульОчередьЗаданий = ОбщегоНазначения.ОбщийМодуль("ОчередьЗаданий");
				СписокЗаданий = МодульОчередьЗаданий.ПолучитьЗадания(ПараметрыЗадания);
				
				ПараметрыЗадания = Новый Структура("Использование", Ложь);
				Для Каждого Задание Из СписокЗаданий Цикл
					МодульОчередьЗаданий.ИзменитьЗадание(Задание.Идентификатор, ПараметрыЗадания);
					ПараметрыБлокировки.ОтключенныеЗадания.Добавить(Задание.Идентификатор);
				КонецЦикла;
			КонецЕсли;
		Иначе
			Отбор = Новый Структура;
			Отбор.Вставить("Метаданные", СтрокаЗадания.РегламентноеЗадание);
			Отбор.Вставить("Использование", Истина);
			МассивЗаданий = РегламентныеЗадания.ПолучитьРегламентныеЗадания(Отбор);
			Для Каждого Задание Из МассивЗаданий Цикл
				Задание.Использование = Ложь;
				Задание.Записать();
				ПараметрыБлокировки.ОтключенныеЗадания.Добавить(Задание.УникальныйИдентификатор);
			КонецЦикла;
		КонецЕсли;
	КонецЦикла;
	ПараметрыБлокировки.РаботаСВнешнимиРесурсамиЗаблокирована = Истина;
	ХранилищеЗначения = Новый ХранилищеЗначения(ПараметрыБлокировки);
	Константы.ПараметрыБлокировкиРаботыСВнешнимиРесурсами.Установить(ХранилищеЗначения);
	
	// Если это копия информационной базы, то необходимо обновить идентификатор.
	ИдентификаторИнформационнойБазы = Новый УникальныйИдентификатор();
	Константы.ИдентификаторИнформационнойБазы.Установить(Строка(ИдентификаторИнформационнойБазы));
	
КонецПроцедуры

#КонецОбласти
