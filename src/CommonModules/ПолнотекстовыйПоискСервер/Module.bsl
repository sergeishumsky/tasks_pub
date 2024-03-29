////////////////////////////////////////////////////////////////////////////////
// Подсистема "Полнотекстовый поиск".
//
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Обновляет индекс полнотекстового поиска.
Процедура ОбновлениеИндексаППД() Экспорт
	
	ОбновитьИндекс(НСтр("ru = 'Обновление индекса ППД'"), Ложь, Истина);
	
КонецПроцедуры

// Выполняет слияние индексов полнотекстового поиска.
Процедура СлияниеИндексаППД() Экспорт
	
	ОбновитьИндекс(НСтр("ru = 'Слияние индекса ППД'"), Истина);
	
КонецПроцедуры

// Возвращает, актуален ли индекс полнотекстового поиска.
//   Проверка функциональной опции "ИспользоватьПолнотекстовыйПоиск" выполняется в вызывающем коде.
//
Функция ИндексПоискаАктуален() Экспорт
	
	Возврат (
		// Операции не разрешены,
		// или индекс полностью соответствует текущему состоянию информационной базы,
		// или индекс обновлялся менее 5 минут назад.
		НЕ ОперацииРазрешены()
		ИЛИ ПолнотекстовыйПоиск.ИндексАктуален()
		ИЛИ ТекущаяДата() < ПолнотекстовыйПоиск.ДатаАктуальности() + 300); // Исключение из правила ТекущаяДатаСеанса().
	
КонецФункции

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

////////////////////////////////////////////////////////////////////////////////
// Добавление обработчиков служебных событий (подписок).

// См. описание этой же процедуры в модуле СтандартныеПодсистемыСервер.
Процедура ПриДобавленииОбработчиковСлужебныхСобытий(КлиентскиеОбработчики, СерверныеОбработчики) Экспорт
	
	// СЕРВЕРНЫЕ ОБРАБОТЧИКИ.
	
	СерверныеОбработчики["СтандартныеПодсистемы.ОбновлениеВерсииИБ\ПриДобавленииОбработчиковОбновления"].Добавить(
		"ПолнотекстовыйПоискСервер");
	
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.ТекущиеДела") Тогда
		СерверныеОбработчики["СтандартныеПодсистемы.ТекущиеДела\ПриЗаполненииСпискаТекущихДел"].Добавить(
			"ПолнотекстовыйПоискСервер");
	КонецЕсли;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Обработчики служебных событий.

// Заполняет список текущих дел пользователя.
//
// Параметры:
//  ТекущиеДела - ТаблицаЗначений - таблица значений с колонками:
//    * Идентификатор - Строка - внутренний идентификатор дела, используемый механизмом "Текущие дела".
//    * ЕстьДела      - Булево - если Истина, дело выводится в списке текущих дел пользователя.
//    * Важное        - Булево - если Истина, дело будет выделено красным цветом.
//    * Представление - Строка - представление дела, выводимое пользователю.
//    * Количество    - Число  - количественный показатель дела, выводится в строке заголовка дела.
//    * Форма         - Строка - полный путь к форме, которую необходимо открыть при нажатии на гиперссылку
//                               дела на панели "Текущие дела".
//    * ПараметрыФормы- Структура - параметры, с которыми нужно открывать форму показателя.
//    * Владелец      - Строка, объект метаданных - строковый идентификатор дела, которое будет владельцем для текущего
//                      или объект метаданных подсистема.
//    * Подсказка     - Строка - текст подсказки.
//
Процедура ПриЗаполненииСпискаТекущихДел(ТекущиеДела) Экспорт
	МодульТекущиеДелаСервер = ОбщегоНазначения.ОбщийМодуль("ТекущиеДелаСервер");
	Если Не ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.НастройкиПрограммы")
		Или Не Пользователи.ЭтоПолноправныйПользователь()
		Или Не ПолучитьФункциональнуюОпцию("ИспользоватьПолнотекстовыйПоиск")
		Или МодульТекущиеДелаСервер.ДелоОтключено("ПолнотекстовыйПоискВДанных") Тогда
		Возврат;
	КонецЕсли;
	
	ДатаАктуальностиИндекса = ПолнотекстовыйПоиск.ДатаАктуальности();
	// Исключение, должна использоваться ТекущаяДата().
	Если ДатаАктуальностиИндекса > ТекущаяДата() Тогда
		Интервал = НСтр("ru = 'менее одного дня'");
	Иначе
		// Исключение, должна использоваться ТекущаяДата().
		Интервал = ОбщегоНазначения.ИнтервалВремениСтрокой(ДатаАктуальностиИндекса, ТекущаяДата());
	КонецЕсли;
	// Исключение, должна использоваться ТекущаяДата().
	ДнейСПоследнегоОбновления = Цел((ТекущаяДата() - ДатаАктуальностиИндекса)/60/60/24);
	
	Раздел = Метаданные.Подсистемы["Администрирование"];
	ИдентификаторПолнотекстовыйПоиск = "ПолнотекстовыйПоискВДанных" + СтрЗаменить(Раздел.ПолноеИмя(), ".", "");
	Дело = ТекущиеДела.Добавить();
	Дело.Идентификатор  = ИдентификаторПолнотекстовыйПоиск;
	Дело.ЕстьДела       = (ДнейСПоследнегоОбновления >= 1 И Не ПолнотекстовыйПоиск.ИндексАктуален());
	Дело.Представление  = НСтр("ru = 'Индекс полнотекстового поиска устарел'");
	Дело.Форма          = "Обработка.ПанельАдминистрированияБСП.Форма.УправлениеПолнотекстовымПоискомИИзвлечениемТекстов";
	Дело.Подсказка      = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		НСтр("ru = 'Последнее обновление %1 назад'"), Интервал);
	Дело.Владелец       = Раздел;
	
КонецПроцедуры

// Добавляет процедуры-обработчики обновления, необходимые данной подсистеме.
//
// Параметры:
//   Обработчики - ТаблицаЗначений - см. описание функции НоваяТаблицаОбработчиковОбновления
//                                  общего модуля ОбновлениеИнформационнойБазы.
// 
Процедура ПриДобавленииОбработчиковОбновления(Обработчики) Экспорт
	
	Обработчик = Обработчики.Добавить();
	Обработчик.НачальноеЗаполнение = Истина;
	Обработчик.Процедура = "ПолнотекстовыйПоискСервер.ИнициализироватьФункциональнуюОпциюПолнотекстовыйПоиск";
	Обработчик.Версия = "1.0.0.1";
	Обработчик.ОбщиеДанные = Истина;
	
КонецПроцедуры

// Устанавливает значение константы ИспользоватьПолнотекстовыйПоиск.
//   Используется для синхронизации значения
//   функциональной опции "ИспользоватьПолнотекстовыйПоиск"
//   с "ПолнотекстовыйПоиск.ПолучитьРежимПолнотекстовогоПоиска()".
//
Процедура ИнициализироватьФункциональнуюОпциюПолнотекстовыйПоиск() Экспорт
	
	ЗначениеКонстанты = ОперацииРазрешены();
	Константы.ИспользоватьПолнотекстовыйПоиск.Установить(ЗначениеКонстанты);
	
КонецПроцедуры

// Возвращает разрешены ли операции полнотекстового поиска: обновление индексов, очистка индексов, поиск.
Функция ОперацииРазрешены() Экспорт
	
	Возврат ПолнотекстовыйПоиск.ПолучитьРежимПолнотекстовогоПоиска() = РежимПолнотекстовогоПоиска.Разрешить;
	
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// Обработчики условных вызовов.

// См. описание одноименной процедуры в общем модуле РегламентныеЗаданияПереопределяемый.
//
Процедура ПриОпределенииНастроекРегламентныхЗаданий(Зависимости) Экспорт
	Зависимость = Зависимости.Добавить();
	Зависимость.РегламентноеЗадание = Метаданные.РегламентныеЗадания.ОбновлениеИндексаППД;
	Зависимость.ФункциональнаяОпция = Метаданные.ФункциональныеОпции.ИспользоватьПолнотекстовыйПоиск;
	
	Зависимость = Зависимости.Добавить();
	Зависимость.РегламентноеЗадание = Метаданные.РегламентныеЗадания.СлияниеИндексаППД;
	Зависимость.ФункциональнаяОпция = Метаданные.ФункциональныеОпции.ИспользоватьПолнотекстовыйПоиск;
КонецПроцедуры

Функция ИспользоватьПолнотекстовыйПоиск() Экспорт
	
	Возврат Метаданные.ФункциональныеОпции.ИспользоватьПолнотекстовыйПоиск;
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Обработчик регламентного задания.
Процедура ОбновлениеИндексаППДПоРасписанию() Экспорт
	
	ОбщегоНазначения.ПриНачалеВыполненияРегламентногоЗадания(Метаданные.РегламентныеЗадания.ОбновлениеИндексаППД);
	
	РегламентноеЗадание = Метаданные.РегламентныеЗадания.СлияниеИндексаППД;
	
	Отбор = Новый Структура;
	Отбор.Вставить("ИмяМетода", РегламентноеЗадание.ИмяМетода);
	Отбор.Вставить("Состояние", СостояниеФоновогоЗадания.Активно);
	ФоновыеЗаданияСлияниеИндексаППД = ФоновыеЗадания.ПолучитьФоновыеЗадания(Отбор);
	Если ФоновыеЗаданияСлияниеИндексаППД.Количество() > 0 Тогда
		Возврат;
	КонецЕсли;
	
	ОбновлениеИндексаППД();
	
КонецПроцедуры

// Обработчик регламентного задания.
Процедура СлияниеИндексаППДПоРасписанию() Экспорт
	
	ОбщегоНазначения.ПриНачалеВыполненияРегламентногоЗадания(Метаданные.РегламентныеЗадания.СлияниеИндексаППД);
	
	РегламентноеЗадание = Метаданные.РегламентныеЗадания.ОбновлениеИндексаППД;
	
	Отбор = Новый Структура;
	Отбор.Вставить("ИмяМетода", РегламентноеЗадание.ИмяМетода);
	Отбор.Вставить("Состояние", СостояниеФоновогоЗадания.Активно);
	ФоновыеЗаданияОбновлениеИндексаППД = ФоновыеЗадания.ПолучитьФоновыеЗадания(Отбор);
	Если ФоновыеЗаданияОбновлениеИндексаППД.Количество() > 0 Тогда
		Возврат;
	КонецЕсли;
	
	СлияниеИндексаППД();
	
КонецПроцедуры

// Общая процедура для обновления и слияния индекса ППД.
Процедура ОбновитьИндекс(ПредставлениеПроцедуры, РазрешитьСлияние = Ложь, Порциями = Ложь)
	
	Если НЕ ОперацииРазрешены() Тогда
		Возврат;
	КонецЕсли;
	
	ОбщегоНазначения.ПриНачалеВыполненияРегламентногоЗадания();
	
	ЗаписьЖурнала(Неопределено, НСтр("ru = 'Запуск процедуры ""%1"".'"), , ПредставлениеПроцедуры);
	
	Попытка
		ПолнотекстовыйПоиск.ОбновитьИндекс(РазрешитьСлияние, Порциями);
		ЗаписьЖурнала(Неопределено, НСтр("ru = 'Успешное завершение процедуры ""%1"".'"), , ПредставлениеПроцедуры);
	Исключение
		ЗаписьЖурнала(Неопределено, НСтр("ru = 'Ошибка выполнения процедуры ""%1"":'"), ИнформацияОбОшибке(), ПредставлениеПроцедуры);
	КонецПопытки;
	
КонецПроцедуры

// Создает запись в журнале регистрации и сообщениях пользователю;
//
// Параметры:
//   УровеньЖурнала - УровеньЖурналаРегистрации - Важность сообщения для администратора.
//   КомментарийСПараметрами - Строка - Комментарий, который может содержать параметры %1.
//   ИнформацияОбОшибке - ИнформацияОбОшибке, Строка - Информация об ошибке, которая будет размещена после комментария.
//   Параметр - Строка - Для подстановки в КомментарийСПараметрами вместо %1.
//
Процедура ЗаписьЖурнала(УровеньЖурнала, КомментарийСПараметрами, ИнформацияОбОшибке = Неопределено, Параметр = Неопределено)
	
	// Определение уровня журнала регистрации на основе типа переданного сообщения об ошибке.
	Если ТипЗнч(УровеньЖурнала) <> Тип("УровеньЖурналаРегистрации") Тогда
		Если ТипЗнч(ИнформацияОбОшибке) = Тип("ИнформацияОбОшибке") Тогда
			УровеньЖурнала = УровеньЖурналаРегистрации.Ошибка;
		ИначеЕсли ТипЗнч(ИнформацияОбОшибке) = Тип("Строка") Тогда
			УровеньЖурнала = УровеньЖурналаРегистрации.Предупреждение;
		Иначе
			УровеньЖурнала = УровеньЖурналаРегистрации.Информация;
		КонецЕсли;
	КонецЕсли;
	
	// Комментарий для журнала регистрации.
	ТекстДляЖурнала = КомментарийСПараметрами;
	Если Параметр <> Неопределено Тогда
		ТекстДляЖурнала = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстДляЖурнала, Параметр);
	КонецЕсли;
	Если ТипЗнч(ИнформацияОбОшибке) = Тип("ИнформацияОбОшибке") Тогда
		ТекстДляЖурнала = ТекстДляЖурнала + Символы.ПС + ПодробноеПредставлениеОшибки(ИнформацияОбОшибке);
	ИначеЕсли ТипЗнч(ИнформацияОбОшибке) = Тип("Строка") Тогда
		ТекстДляЖурнала = ТекстДляЖурнала + Символы.ПС + ИнформацияОбОшибке;
	КонецЕсли;
	ТекстДляЖурнала = СокрЛП(ТекстДляЖурнала);
	
	// Запись в журнал регистрации.
	ЗаписьЖурналаРегистрации(
		НСтр("ru = 'Полнотекстовое индексирование'", ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка()), 
		УровеньЖурнала, , , 
		ТекстДляЖурнала);
	
КонецПроцедуры

#КонецОбласти
