////////////////////////////////////////////////////////////////////////////////
// Интеграция подсистем друг с другом.
//
////////////////////////////////////////////////////////////////////////////////

#Область СлужебныйПрограммныйИнтерфейс

////////////////////////////////////////////////////////////////////////////////
// Интеграция с подсистемой "БазоваяФункциональность".

// См. описание в процедуре ЗаполнитьВсеПараметрыРаботыРасширений
// общего модуля СтандартныеПодсистемы.
//
Процедура ПриЗаполненииВсехПараметровРаботыРасширений() Экспорт
	
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.ВариантыОтчетов") Тогда
		МодульВариантыОтчетов = ОбщегоНазначения.ОбщийМодуль("ВариантыОтчетов");
		МодульВариантыОтчетов.ПриЗаполненииВсехПараметровРаботыРасширений();
	КонецЕсли;
	
КонецПроцедуры

// См. описание в процедуре ОчиститьВсеПараметрыРаботыРасширений
// общего модуля СтандартныеПодсистемы.
//
Процедура ПриОчисткеВсехПараметровРаботыРасширений() Экспорт
	
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.ВариантыОтчетов") Тогда
		МодульВариантыОтчетов = ОбщегоНазначения.ОбщийМодуль("ВариантыОтчетов");
		МодульВариантыОтчетов.ПриОчисткеВсехПараметровРаботыРасширений();
	КонецЕсли;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Интеграция с подсистемой "Групповое изменение объектов".

// Определить объекты метаданных, в модулях менеджеров которых ограничивается возможность 
// редактирования реквизитов при групповом изменении.
//
// Параметры:
//   Объекты - Соответствие - в качестве ключа указать полное имя объекта метаданных,
//                            подключенного к подсистеме "Групповое изменение объектов".
//                            Дополнительно в значении могут быть перечислены имена экспортных функций:
//                            "РеквизитыНеРедактируемыеВГрупповойОбработке",
//                            "РеквизитыРедактируемыеВГрупповойОбработке".
//                            Каждое имя должно начинаться с новой строки.
//                            Если указана пустая строка, значит в модуле менеджера определены обе функции.
//
Процедура ПриОпределенииОбъектовСРедактируемымиРеквизитами(Объекты) Экспорт
	
	СтандартныеПодсистемыСервер.ПриОпределенииОбъектовСРедактируемымиРеквизитами(Объекты);
	
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.Анкетирование") Тогда
		МодульАнкетирование = ОбщегоНазначения.ОбщийМодуль("Анкетирование");
		МодульАнкетирование.ПриОпределенииОбъектовСРедактируемымиРеквизитами(Объекты);
	КонецЕсли;
	
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.Банки") Тогда
		МодульРаботаСБанками = ОбщегоНазначения.ОбщийМодуль("РаботаСБанками");
		МодульРаботаСБанками.ПриОпределенииОбъектовСРедактируемымиРеквизитами(Объекты);
	КонецЕсли;
	
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.БизнесПроцессыИЗадачи") Тогда
		МодульБизнесПроцессыИЗадачиСервер = ОбщегоНазначения.ОбщийМодуль("БизнесПроцессыИЗадачиСервер");
		МодульБизнесПроцессыИЗадачиСервер.ПриОпределенииОбъектовСРедактируемымиРеквизитами(Объекты);
	КонецЕсли;
	
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.Взаимодействия") Тогда
		МодульВзаимодействия = ОбщегоНазначения.ОбщийМодуль("Взаимодействия");
		МодульВзаимодействия.ПриОпределенииОбъектовСРедактируемымиРеквизитами(Объекты);
	КонецЕсли;
	
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.Валюты") Тогда
		МодульРаботаСКурсамиВалют = ОбщегоНазначения.ОбщийМодуль("РаботаСКурсамиВалют");
		МодульРаботаСКурсамиВалют.ПриОпределенииОбъектовСРедактируемымиРеквизитами(Объекты);
	КонецЕсли;
	
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.ВариантыОтчетов") Тогда
		МодульВариантыОтчетов = ОбщегоНазначения.ОбщийМодуль("ВариантыОтчетов");
		МодульВариантыОтчетов.ПриОпределенииОбъектовСРедактируемымиРеквизитами(Объекты);
	КонецЕсли;
	
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.ДополнительныеОтчетыИОбработки") Тогда
		МодульДополнительныеОтчетыИОбработки = ОбщегоНазначения.ОбщийМодуль("ДополнительныеОтчетыИОбработки");
		МодульДополнительныеОтчетыИОбработки.ПриОпределенииОбъектовСРедактируемымиРеквизитами(Объекты);
	КонецЕсли;
		
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.ЗаметкиПользователя") Тогда
		МодульЗаметкиПользователяСлужебный = ОбщегоНазначения.ОбщийМодуль("ЗаметкиПользователяСлужебный");
		МодульЗаметкиПользователяСлужебный.ПриОпределенииОбъектовСРедактируемымиРеквизитами(Объекты);
	КонецЕсли;
	
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.КонтактнаяИнформация") Тогда
		МодульУправлениеКонтактнойИнформациейСлужебный = ОбщегоНазначения.ОбщийМодуль("УправлениеКонтактнойИнформациейСлужебный");
		МодульУправлениеКонтактнойИнформациейСлужебный.ПриОпределенииОбъектовСРедактируемымиРеквизитами(Объекты);
	КонецЕсли;
	
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.ОбменДанными") Тогда
		МодульОбменДаннымиСервер = ОбщегоНазначения.ОбщийМодуль("ОбменДаннымиСервер");
		МодульОбменДаннымиСервер.ПриОпределенииОбъектовСРедактируемымиРеквизитами(Объекты);
	КонецЕсли;
	
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.Организации") Тогда
		МодульОрганизацииСлужебный = ОбщегоНазначения.ОбщийМодуль("ОрганизацииСлужебный");
		МодульОрганизацииСлужебный.ПриОпределенииОбъектовСРедактируемымиРеквизитами(Объекты);
	КонецЕсли;
	
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.Пользователи") Тогда
		МодульПользователиСлужебный = ОбщегоНазначения.ОбщийМодуль("ПользователиСлужебный");
		МодульПользователиСлужебный.ПриОпределенииОбъектовСРедактируемымиРеквизитами(Объекты);
	КонецЕсли;
	
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.РаботаСФайлами") Тогда
		МодульРаботаСФайламиСлужебный = ОбщегоНазначения.ОбщийМодуль("РаботаСФайламиСлужебный");
		МодульРаботаСФайламиСлужебный.ПриОпределенииОбъектовСРедактируемымиРеквизитами(Объекты);
	КонецЕсли;
	
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.РассылкаОтчетов") Тогда
		МодульРассылкаОтчетов = ОбщегоНазначения.ОбщийМодуль("РассылкаОтчетов");
		МодульРассылкаОтчетов.ПриОпределенииОбъектовСРедактируемымиРеквизитами(Объекты);
	КонецЕсли;
	
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.РаботаСПочтовымиСообщениями") Тогда
		МодульРаботаСПочтовымиСообщениямиСлужебный = ОбщегоНазначения.ОбщийМодуль("РаботаСПочтовымиСообщениямиСлужебный");
		МодульРаботаСПочтовымиСообщениямиСлужебный.ПриОпределенииОбъектовСРедактируемымиРеквизитами(Объекты);
	КонецЕсли;
	
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.Свойства") Тогда
		МодульУправлениеСвойствамиСлужебный = ОбщегоНазначения.ОбщийМодуль("УправлениеСвойствамиСлужебный");
		МодульУправлениеСвойствамиСлужебный.ПриОпределенииОбъектовСРедактируемымиРеквизитами(Объекты);
	КонецЕсли;
	
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.РаботаВМоделиСервиса.ОбменСообщениями") Тогда
		МодульОбменСообщениями = ОбщегоНазначения.ОбщийМодуль("ОбменСообщениями");
		МодульОбменСообщениями.ПриОпределенииОбъектовСРедактируемымиРеквизитами(Объекты);
	КонецЕсли;

	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.УправлениеДоступом") Тогда
		МодульУправлениеДоступомСлужебный = ОбщегоНазначения.ОбщийМодуль("УправлениеДоступомСлужебный");
		МодульУправлениеДоступомСлужебный.ПриОпределенииОбъектовСРедактируемымиРеквизитами(Объекты);
	КонецЕсли;
	
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.ФайловыеФункции") Тогда
		МодульФайловыеФункцииСлужебный = ОбщегоНазначения.ОбщийМодуль("ФайловыеФункцииСлужебный");
		МодульФайловыеФункцииСлужебный.ПриОпределенииОбъектовСРедактируемымиРеквизитами(Объекты);
	КонецЕсли;
	
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.ЭлектроннаяПодпись") Тогда
		МодульЭлектроннаяПодписьСлужебный = ОбщегоНазначения.ОбщийМодуль("ЭлектроннаяПодписьСлужебный");
		МодульЭлектроннаяПодписьСлужебный.ПриОпределенииОбъектовСРедактируемымиРеквизитами(Объекты);
	КонецЕсли;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Интеграция с подсистемой "Даты запрета изменения".

// Содержит описание таблиц и полей объектов для проверки запретов изменения данных.
//
// Параметры:
//  ИсточникиДанных - ТаблицаЗначений - с колонками:
//   * Таблица     - Строка - полное имя объекта метаданных,
//                   например, Метаданные.Документы.ПриходнаяНакладная.ПолноеИмя().
//   * ПолеДаты    - Строка - имя реквизита объекта или табличной части,
//                   например "Дата", "Товары.ДатаОтгрузки".
//   * Раздел      - Строка - имя предопределенного элемента
//                   "ПланВидовХарактеристикСсылка.РазделыДатЗапрета".
//   * ПолеОбъекта - Строка - имя реквизита объекта или реквизита табличной части,
//                   например "Организация", "Товары.Склад".
//
//  Для добавления строки имеется процедура ДобавитьСтроку в общем модуле ДатыЗапретаИзменения.
//
Процедура ПриЗаполненииИсточниковДанныхДляПроверкиЗапретаИзменения(ИсточникиДанных) Экспорт
	
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.ЗащитаПерсональныхДанных") Тогда
		Модуль = ОбщегоНазначения.ОбщийМодуль("ЗащитаПерсональныхДанных");
		Модуль.ПриЗаполненииИсточниковДанныхДляПроверкиЗапретаИзменения(ИсточникиДанных);
	КонецЕсли;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Интеграция с подсистемой "Загрузка данных из файла".

// Определить список справочников, доступных для загрузки с помощью подсистемы "Загрузка данных из файла".
//
// Параметры:
//  Обработчики - ТаблицаЗначений - список справочников, в которые возможна загрузка данных.
//      * ПолноеИмя          - Строка - полное имя справочника (как в метаданных).
//      * Представление      - Строка - представление справочника в списке выбора.
//      * ПрикладнаяЗагрузка - Булево - если Истина, значит справочник использует собственный алгоритм загрузки и
//                                      в модуле менеджера справочника определены функции.
//
Процедура ПриОпределенииСправочниковДляЗагрузкиДанных(ЗагружаемыеСправочники) Экспорт
	
	СтандартныеПодсистемыСервер.ПриОпределенииСправочниковДляЗагрузкиДанных(ЗагружаемыеСправочники);
	
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.КонтактнаяИнформация") Тогда
		МодульУправлениеКонтактнойИнформациейСлужебный = ОбщегоНазначения.ОбщийМодуль("УправлениеКонтактнойИнформациейСлужебный");
		МодульУправлениеКонтактнойИнформациейСлужебный.ПриОпределенииСправочниковДляЗагрузкиДанных(ЗагружаемыеСправочники);
	КонецЕсли;
	
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.Валюты") Тогда
		МодульРаботаСКурсамиВалют = ОбщегоНазначения.ОбщийМодуль("РаботаСКурсамиВалют");
		МодульРаботаСКурсамиВалют.ПриОпределенииСправочниковДляЗагрузкиДанных(ЗагружаемыеСправочники);
	КонецЕсли;
	
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.Пользователи") Тогда
		МодульПользователиСлужебный = ОбщегоНазначения.ОбщийМодуль("ПользователиСлужебный");
		МодульПользователиСлужебный.ПриОпределенииСправочниковДляЗагрузкиДанных(ЗагружаемыеСправочники);
	КонецЕсли;

	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.БизнесПроцессыИЗадачи") Тогда
		МодульБизнесПроцессыИЗадачиСервер = ОбщегоНазначения.ОбщийМодуль("БизнесПроцессыИЗадачиСервер");
		МодульБизнесПроцессыИЗадачиСервер.ПриОпределенииСправочниковДляЗагрузкиДанных(ЗагружаемыеСправочники);
	КонецЕсли;
	
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.Банки") Тогда
		МодульРаботаСБанками = ОбщегоНазначения.ОбщийМодуль("РаботаСБанками");
		МодульРаботаСБанками.ПриОпределенииСправочниковДляЗагрузкиДанных(ЗагружаемыеСправочники);
	КонецЕсли;
	
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.РаботаВМоделиСервиса.ОчередьЗаданий") Тогда
		МодульОчередьЗаданийСлужебный = ОбщегоНазначения.ОбщийМодуль("ОчередьЗаданийСлужебный");
		МодульОчередьЗаданийСлужебный.ПриОпределенииСправочниковДляЗагрузкиДанных(ЗагружаемыеСправочники);
	КонецЕсли;
	
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.РаботаВМоделиСервиса.БазоваяФункциональностьВМоделиСервиса") Тогда
		МодульРаботаВМоделиСервиса = ОбщегоНазначения.ОбщийМодуль("РаботаВМоделиСервиса");
		МодульРаботаВМоделиСервиса.ПриОпределенииСправочниковДляЗагрузкиДанных(ЗагружаемыеСправочники);
	КонецЕсли;
	
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.ВариантыОтчетов") Тогда
		МодульВариантыОтчетов = ОбщегоНазначения.ОбщийМодуль("ВариантыОтчетов");
		МодульВариантыОтчетов.ПриОпределенииСправочниковДляЗагрузкиДанных(ЗагружаемыеСправочники);
	КонецЕсли;
	
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.ЭлектроннаяПодпись") Тогда
		МодульЭлектроннаяПодписьСлужебный = ОбщегоНазначения.ОбщийМодуль("ЭлектроннаяПодписьСлужебный");
		МодульЭлектроннаяПодписьСлужебный.ПриОпределенииСправочниковДляЗагрузкиДанных(ЗагружаемыеСправочники);
	КонецЕсли;

	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.Взаимодействия") Тогда
		МодульВзаимодействия = ОбщегоНазначения.ОбщийМодуль("Взаимодействия");
		МодульВзаимодействия.ПриОпределенииСправочниковДляЗагрузкиДанных(ЗагружаемыеСправочники);
	КонецЕсли;
	
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.ФайловыеФункции") Тогда
		МодульФайловыеФункцииСлужебный = ОбщегоНазначения.ОбщийМодуль("ФайловыеФункцииСлужебный");
		МодульФайловыеФункцииСлужебный.ПриОпределенииСправочниковДляЗагрузкиДанных(ЗагружаемыеСправочники);
	КонецЕсли;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Интеграция с подсистемой "Запрет редактирования реквизитов объектов".

// Определить объекты метаданных, в модулях менеджеров которых ограничивается возможность редактирования реквизитов
// с помощью экспортной функции ПолучитьБлокируемыеРеквизитыОбъекта.
//
// Параметры:
//   Объекты - Соответствие - в качестве ключа указать полное имя объекта метаданных,
//                            подключенного к подсистеме "Запрет редактирования реквизитов объектов". 
//                            В качестве значения - пустую строку.
//
Процедура ПриОпределенииОбъектовСЗаблокированнымиРеквизитами(Объекты) Экспорт 
	
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.КонтактнаяИнформация") Тогда
		МодульУправлениеКонтактнойИнформациейСлужебный = ОбщегоНазначения.ОбщийМодуль("УправлениеКонтактнойИнформациейСлужебный");
		МодульУправлениеКонтактнойИнформациейСлужебный.ПриОпределенииОбъектовСЗаблокированнымиРеквизитами(Объекты);
	КонецЕсли;
	
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.Свойства") Тогда
		МодульУправлениеСвойствамиСлужебный = ОбщегоНазначения.ОбщийМодуль("УправлениеСвойствамиСлужебный");
		МодульУправлениеСвойствамиСлужебный.ПриОпределенииОбъектовСЗаблокированнымиРеквизитами(Объекты);
	КонецЕсли;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Интеграция с подсистемой "Пользователи".

// См. одноименную процедуру в общем модуле ПользователиПереопределяемый.
Процедура ПриОпределенииНастроек(Настройки) Экспорт
	
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.УправлениеДоступом") Тогда
		МодульУправлениеДоступомСлужебный = ОбщегоНазначения.ОбщийМодуль("УправлениеДоступомСлужебный");
		МодульУправлениеДоступомСлужебный.ПриОпределенииНастроек(Настройки);
	КонецЕсли;
	
КонецПроцедуры

// См. одноименную процедуру в общем модуле ПользователиПереопределяемый.
Процедура ПриОпределенииНазначенияРолей(НазначениеРолей) Экспорт
	
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.АдресныйКлассификатор") Тогда
		МодульАдресныйКлассификаторСлужебный = ОбщегоНазначения.ОбщийМодуль("АдресныйКлассификаторСлужебный");
		МодульАдресныйКлассификаторСлужебный.ПриОпределенииНазначенияРолей(НазначениеРолей);
	КонецЕсли;
	
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.Анкетирование") Тогда
		МодульАнкетирование = ОбщегоНазначения.ОбщийМодуль("Анкетирование");
		МодульАнкетирование.ПриОпределенииНазначенияРолей(НазначениеРолей);
	КонецЕсли;
	
	СтандартныеПодсистемыСервер.ПриОпределенииНазначенияРолей(НазначениеРолей);
	
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.Банки") Тогда
		МодульРаботаСБанками = ОбщегоНазначения.ОбщийМодуль("РаботаСБанками");
		МодульРаботаСБанками.ПриОпределенииНазначенияРолей(НазначениеРолей);
	КонецЕсли;
	
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.Валюты") Тогда
		МодульРаботаСКурсамиВалют = ОбщегоНазначения.ОбщийМодуль("РаботаСКурсамиВалют");
		МодульРаботаСКурсамиВалют.ПриОпределенииНазначенияРолей(НазначениеРолей);
	КонецЕсли;
	
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.ВариантыОтчетов") Тогда
		МодульВариантыОтчетов = ОбщегоНазначения.ОбщийМодуль("ВариантыОтчетов");
		МодульВариантыОтчетов.ПриОпределенииНазначенияРолей(НазначениеРолей);
	КонецЕсли;
	
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.ГрафикиРаботы") Тогда
		МодульГрафикиРаботы = ОбщегоНазначения.ОбщийМодуль("ГрафикиРаботы");
		МодульГрафикиРаботы.ПриОпределенииНазначенияРолей(НазначениеРолей);
	КонецЕсли;
	
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.ДополнительныеОтчетыИОбработки") Тогда
		МодульДополнительныеОтчетыИОбработки = ОбщегоНазначения.ОбщийМодуль("ДополнительныеОтчетыИОбработки");
		МодульДополнительныеОтчетыИОбработки.ПриОпределенииНазначенияРолей(НазначениеРолей);
	КонецЕсли;
	
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.КалендарныеГрафики") Тогда
		МодульКалендарныеГрафики = ОбщегоНазначения.ОбщийМодуль("КалендарныеГрафики");
		МодульКалендарныеГрафики.ПриОпределенииНазначенияРолей(НазначениеРолей);
	КонецЕсли;
	
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.ОценкаПроизводительности") Тогда
		МодульОценкаПроизводительностиСлужебный = ОбщегоНазначения.ОбщийМодуль("ОценкаПроизводительностиСлужебный");
		МодульОценкаПроизводительностиСлужебный.ПриОпределенииНазначенияРолей(НазначениеРолей);
	КонецЕсли;
	
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.ТекущиеДела") Тогда
		МодульТекущиеДелаСлужебный = ОбщегоНазначения.ОбщийМодуль("ТекущиеДелаСлужебный");
		МодульТекущиеДелаСлужебный.ПриОпределенииНазначенияРолей(НазначениеРолей);
	КонецЕсли;
	
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.УправлениеДоступом") Тогда
		МодульУправлениеДоступомСлужебный = ОбщегоНазначения.ОбщийМодуль("УправлениеДоступомСлужебный");
		МодульУправлениеДоступомСлужебный.ПриОпределенииНазначенияРолей(НазначениеРолей);
	КонецЕсли;
	
КонецПроцедуры

// См. процедуру ИзменитьДействияВФорме в общем модуле ПользователиПереопределяемый.
Процедура ПриОпределенииДействийВФорме(Ссылка, ДействияВФорме) Экспорт
	
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.УправлениеДоступом") Тогда
		МодульУправлениеДоступомСлужебный = ОбщегоНазначения.ОбщийМодуль("УправлениеДоступомСлужебный");
		МодульУправлениеДоступомСлужебный.ПриОпределенииДействийВФорме(Ссылка, ДействияВФорме);
	КонецЕсли;
	
КонецПроцедуры

// Переопределяет текст комментария при авторизации пользователя ИБ,
// созданного в конфигураторе с административными правами.
//  Вызывается из Пользователи.АвторизоватьТекущегоПользователя().
//  Комментарий записывается в журнал регистрации.
// 
// Параметры:
//  Комментарий  - Строка - начальное значение задано.
//
Процедура ПослеЗаписиАдминистратораПриАвторизации(Комментарий) Экспорт
	
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.УправлениеДоступом") Тогда
		МодульУправлениеДоступомСлужебный = ОбщегоНазначения.ОбщийМодуль("УправлениеДоступомСлужебный");
		МодульУправлениеДоступомСлужебный.ПослеЗаписиАдминистратораПриАвторизации(Комментарий);
	КонецЕсли;
	
КонецПроцедуры

// Доопределяет действия, необходимые после установки пользователя
// информационной базы у пользователя или внешнего пользователя,
// т.е. при изменении реквизита ИдентификаторПользователяИБ на не пустой.
//
// Например, можно обновить роли.
// 
// Параметры:
//  Ссылка - СправочникСсылка.Пользователи, СправочникСсылка.ВнешниеПользователи - пользователь.
//
Процедура ПослеУстановкиПользователяИБ(Ссылка, ПарольПользователяСервиса) Экспорт
	
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.УправлениеДоступом") Тогда
		МодульУправлениеДоступомСлужебный = ОбщегоНазначения.ОбщийМодуль("УправлениеДоступомСлужебный");
		МодульУправлениеДоступомСлужебный.ПослеУстановкиПользователяИБ(Ссылка, ПарольПользователяСервиса);
	КонецЕсли;
	
КонецПроцедуры

// Позволяет переопределить текст вопроса перед записью первого администратора.
//  Вызывается из обработчика ПередЗаписью формы пользователя.
//  Вызов выполняется если установлен ЗапретРедактированияРолей() и
// количество пользователей информационной базы равно нулю.
// 
// Параметры:
//  ТекстВопроса - Строка - текст вопроса, который можно переопределить.
//
Процедура ПриОпределенииТекстаВопросаПередЗаписьюПервогоАдминистратора(ТекстВопроса) Экспорт
	
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.УправлениеДоступом") Тогда
		МодульУправлениеДоступомСлужебный = ОбщегоНазначения.ОбщийМодуль("УправлениеДоступомСлужебный");
		МодульУправлениеДоступомСлужебный.ПриОпределенииТекстаВопросаПередЗаписьюПервогоАдминистратора(ТекстВопроса);
	КонецЕсли;
	
КонецПроцедуры

// Доопределяет действия при создании администратора в подсистеме Пользователи.
// 
// Параметры:
//  Администратор - СправочникСсылка.Пользователи (изменение объекта запрещено).
//  Уточнение     - Строка - поясняет при каких условиях был создан администратор.
//
Процедура ПриСозданииАдминистратора(Администратор, Уточнение) Экспорт
	
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.УправлениеДоступом") Тогда
		МодульУправлениеДоступомСлужебный = ОбщегоНазначения.ОбщийМодуль("УправлениеДоступомСлужебный");
		МодульУправлениеДоступомСлужебный.ПриСозданииАдминистратора(Администратор, Уточнение);
	КонецЕсли;
	
КонецПроцедуры

// Доопределяет действия, необходимые после добавления или изменения пользователя,
// группы пользователей, внешнего пользователя, группы внешних пользователей.
//
// Параметры:
//  Ссылка     - СправочникСсылка.Пользователи,
//               СправочникСсылка.ГруппыПользователей,
//               СправочникСсылка.ВнешниеПользователи,
//               СправочникСсылка.ГруппыВнешнихПользователей - измененный объект.
//
//  ЭтоНовый   - Булево, если Истина, объект был добавлен, иначе изменен.
//
Процедура ПослеДобавленияИзмененияПользователяИлиГруппы(Ссылка, ЭтоНовый) Экспорт
	
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.УправлениеДоступом") Тогда
		МодульУправлениеДоступомСлужебный = ОбщегоНазначения.ОбщийМодуль("УправлениеДоступомСлужебный");
		МодульУправлениеДоступомСлужебный.ПослеДобавленияИзмененияПользователяИлиГруппы(Ссылка, ЭтоНовый);
	КонецЕсли;
	
КонецПроцедуры

// Доопределяет действия, необходимые после завершения обновления
// связей в регистре СоставыГруппПользователей.
//
// Параметры:
//  УчастникиИзменений - Массив значений типов:
//                       - СправочникСсылка.Пользователи.
//                       - СправочникСсылка.ВнешниеПользователи.
//                       Пользователи которые участвовали в изменении состава групп.
//
//  ИзмененныеГруппы   - Массив значений типов:
//                       - СправочникСсылка.ГруппыПользователей.
//                       - СправочникСсылка.ГруппыВнешнихПользователей.
//                       Группы, состав которых был изменен.
//
Процедура ПослеОбновленияСоставовГруппПользователей(УчастникиИзменений, ИзмененныеГруппы) Экспорт
	
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.УправлениеДоступом") Тогда
		МодульУправлениеДоступомСлужебный = ОбщегоНазначения.ОбщийМодуль("УправлениеДоступомСлужебный");
		МодульУправлениеДоступомСлужебный.ПослеОбновленияСоставовГруппПользователей(УчастникиИзменений, ИзмененныеГруппы);
	КонецЕсли;
	
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.ДатыЗапретаИзменения") Тогда
		МодульДатыЗапретаИзмененияСлужебный = ОбщегоНазначения.ОбщийМодуль("ДатыЗапретаИзмененияСлужебный");
		МодульДатыЗапретаИзмененияСлужебный.ПослеОбновленияСоставовГруппПользователей(УчастникиИзменений, ИзмененныеГруппы);
	КонецЕсли;
	
КонецПроцедуры

// Доопределяет действия, необходимые после изменении объекта авторизации внешнего пользователя.
// 
// Параметры:
//  ВнешнийПользователь     - СправочникСсылка.ВнешниеПользователи - внешний пользователь.
//  СтарыйОбъектАвторизации - NULL - при добавлении внешнего пользователя.
//                          - ОпределяемыйТип.ВнешнийПользователь - тип объекта авторизации.
//  НовыйОбъектАвторизации  - ОпределяемыйТип.ВнешнийПользователь - тип объекта авторизации.
//
Процедура ПослеИзмененияОбъектаАвторизацииВнешнегоПользователя(ВнешнийПользователь,
                                                               СтарыйОбъектАвторизации,
                                                               НовыйОбъектАвторизации) Экспорт
	
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.УправлениеДоступом") Тогда
		МодульУправлениеДоступомСлужебный = ОбщегоНазначения.ОбщийМодуль("УправлениеДоступомСлужебный");
		МодульУправлениеДоступомСлужебный.ПослеИзмененияОбъектаАвторизацииВнешнегоПользователя(
			ВнешнийПользователь, СтарыйОбъектАвторизации, НовыйОбъектАвторизации);
	КонецЕсли;
	
КонецПроцедуры

// Получает варианты переданного отчета и их представления.
//
// Параметры:
//  ОтчетМетаданные                - Объект метаданных - отчет, для которого получаются варианты отчета.
//  ПользовательИнформационнойБазы - Строка - имя пользователя информационной базы.
//  СведенияОВариантахОтчетов      - ТаблицаЗначений - таблица, в которую сохраняется информация о варианте отчета.
//       * КлючОбъекта          - Строка - ключ отчета вида "Отчет.НазваниеОтчета".
//       * КлючВарианта         - Строка - ключ варианта отчета.
//       * Представление        - Строка - представление варианта отчета.
//       * СтандартнаяОбработка - Булево - если Истина - вариант отчета сохранен в стандартном хранилище.
//  СтандартнаяОбработка           - Булево - если Истина - вариант отчета сохранен в стандартном хранилище.
//
Процедура ПриПолученииПользовательскихВариантовОтчетов(ОтчетМетаданные, ПользовательИнформационнойБазы, СведенияОВариантахОтчетов, СтандартнаяОбработка) Экспорт
	
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.ВариантыОтчетов") Тогда
		МодульВариантыОтчетов = ОбщегоНазначения.ОбщийМодуль("ВариантыОтчетов");
		МодульВариантыОтчетов.ПользовательскиеВариантыОтчетов(ОтчетМетаданные, ПользовательИнформационнойБазы,
			СведенияОВариантахОтчетов, СтандартнаяОбработка);
	КонецЕсли;
	
КонецПроцедуры

// Удаляет переданный вариант отчета из хранилища вариантов отчетов.
//
// Параметры:
//  СведенияОВариантахОтчетов      - ТаблицаЗначений - таблица, в которой сохранена информация о варианте отчета.
//       * КлючОбъекта          - Строка - ключ отчета вида "Отчет.НазваниеОтчета".
//       * КлючВарианта         - Строка - ключ варианта отчета.
//       * Представление        - Строка - представление варианта отчета.
//       * СтандартнаяОбработка - Булево - если Истина - вариант отчета сохранен в стандартном хранилище.
//  ПользовательИнформационнойБазы - Строка - имя пользователя информационной базы у которого очищается вариант отчета.
//  СтандартнаяОбработка           - Булево - если Истина - вариант отчета сохранен в стандартном хранилище.
//
Процедура ПриУдаленииПользовательскихВариантовОтчета(СведенияОВариантеОтчета, ПользовательИнформационнойБазы, СтандартнаяОбработка) Экспорт
	
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.ВариантыОтчетов") Тогда
		МодульВариантыОтчетов = ОбщегоНазначения.ОбщийМодуль("ВариантыОтчетов");
		МодульВариантыОтчетов.УдалитьПользовательскийВариантОтчета(СведенияОВариантеОтчета,
			ПользовательИнформационнойБазы, СтандартнаяОбработка);
	КонецЕсли;
	
КонецПроцедуры

// См. одноименную процедуру в общем модуле ПользователиПереопределяемый.
Процедура ПриПолученииПрочихНастроек(СведенияОПользователе, Настройки) Экспорт
	
	// Добавление настроек дополнительных отчетов и обработок.
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.ДополнительныеОтчетыИОбработки") Тогда
		МодульДополнительныеОтчетыИОбработки = ОбщегоНазначения.ОбщийМодуль("ДополнительныеОтчетыИОбработки");
		МодульДополнительныеОтчетыИОбработки.ПриПолученииПрочихНастроек(СведенияОПользователе, Настройки);
	КонецЕсли;
	
КонецПроцедуры

// См. одноименную процедуру в общем модуле ПользователиПереопределяемый.
Процедура ПриСохраненииПрочихНастроек(СведенияОПользователе, Настройки) Экспорт
	
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.ДополнительныеОтчетыИОбработки") Тогда
		МодульДополнительныеОтчетыИОбработки = ОбщегоНазначения.ОбщийМодуль("ДополнительныеОтчетыИОбработки");
		МодульДополнительныеОтчетыИОбработки.ПриСохраненииПрочихНастроек(СведенияОПользователе, Настройки);
	КонецЕсли;
	
КонецПроцедуры

// См. одноименную процедуру в общем модуле ПользователиПереопределяемый.
Процедура ПриУдаленииПрочихНастроек(СведенияОПользователе, Настройки) Экспорт
	
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.ДополнительныеОтчетыИОбработки") Тогда
		МодульДополнительныеОтчетыИОбработки = ОбщегоНазначения.ОбщийМодуль("ДополнительныеОтчетыИОбработки");
		МодульДополнительныеОтчетыИОбработки.ПриУдаленииПрочихНастроек(СведенияОПользователе, Настройки);
	КонецЕсли;
	
КонецПроцедуры

// Формирует запрос на изменение адреса электронной почты пользователя сервиса.
//
// Параметры:
//  НоваяПочта                - Строка - новый адрес электронной почты пользователя.
//  Пользователь              - СправочникСсылка.Пользователи - пользователь, которому требуется изменить
//                                                              адрес электронной почты.
//  ПарольПользователяСервиса - Строка - пароль текущего пользователя для доступа к менеджеру сервиса.
//
Процедура ПриСозданииЗапросаНаСменуПочты(Знач НоваяПочта, Знач Пользователь, Знач ПарольПользователяСервиса) Экспорт
	
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.РаботаВМоделиСервиса.ПользователиВМоделиСервиса") Тогда
		МодульПользователиСлужебныйВМоделиСервиса = ОбщегоНазначения.ОбщийМодуль("ПользователиСлужебныйВМоделиСервиса");
		МодульПользователиСлужебныйВМоделиСервиса.СоздатьЗапросНаСменуПочты(НоваяПочта, Пользователь, ПарольПользователяСервиса);
	КонецЕсли;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Интеграция с подсистемой "Регламентные задания".

// См. описание одноименной процедуры в общем модуле РегламентныеЗаданияПереопределяемый.
Процедура ПриОпределенииНастроекРегламентныхЗаданий(Настройки) Экспорт
	
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.Банки") Тогда
		МодульРаботаСБанками = ОбщегоНазначения.ОбщийМодуль("РаботаСБанками");
		МодульРаботаСБанками.ПриОпределенииНастроекРегламентныхЗаданий(Настройки);
	КонецЕсли;
	
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.БизнесПроцессыИЗадачи") Тогда
		МодульБизнесПроцессыИЗадачиСервер = ОбщегоНазначения.ОбщийМодуль("БизнесПроцессыИЗадачиСервер");
		МодульБизнесПроцессыИЗадачиСервер.ПриОпределенииНастроекРегламентныхЗаданий(Настройки);
	КонецЕсли;
	
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.Валюты") Тогда
		МодульРаботаСКурсамиВалют = ОбщегоНазначения.ОбщийМодуль("РаботаСКурсамиВалют");
		МодульРаботаСКурсамиВалют.ПриОпределенииНастроекРегламентныхЗаданий(Настройки);
	КонецЕсли;
	
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.ВерсионированиеОбъектов") Тогда
		МодульВерсионированиеОбъектовСобытия = ОбщегоНазначения.ОбщийМодуль("ВерсионированиеОбъектовСобытия");
		МодульВерсионированиеОбъектовСобытия.ПриОпределенииНастроекРегламентныхЗаданий(Настройки);
	КонецЕсли;
	
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.Взаимодействия") Тогда
		МодульВзаимодействия = ОбщегоНазначения.ОбщийМодуль("Взаимодействия");
		МодульВзаимодействия.ПриОпределенииНастроекРегламентныхЗаданий(Настройки);
	КонецЕсли;
	
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.ОбменДанными") Тогда
		МодульОбменДаннымиСервер = ОбщегоНазначения.ОбщийМодуль("ОбменДаннымиСервер");
		МодульОбменДаннымиСервер.ПриОпределенииНастроекРегламентныхЗаданий(Настройки);
	КонецЕсли;
	
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.ОценкаПроизводительности") Тогда
		МодульОценкаПроизводительностиСлужебный = ОбщегоНазначения.ОбщийМодуль("ОценкаПроизводительностиСлужебный");
		МодульОценкаПроизводительностиСлужебный.ПриОпределенииНастроекРегламентныхЗаданий(Настройки);
	КонецЕсли;
	
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.ПолнотекстовыйПоиск") Тогда
		МодульПолнотекстовыйПоискСервер = ОбщегоНазначения.ОбщийМодуль("ПолнотекстовыйПоискСервер");
		МодульПолнотекстовыйПоискСервер.ПриОпределенииНастроекРегламентныхЗаданий(Настройки);
	КонецЕсли;
	
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.РассылкаОтчетов") Тогда
		МодульРассылкаОтчетов = ОбщегоНазначения.ОбщийМодуль("РассылкаОтчетов");
		МодульРассылкаОтчетов.ПриОпределенииНастроекРегламентныхЗаданий(Настройки);
	КонецЕсли;
	
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.УправлениеДоступом") Тогда
		МодульУправлениеДоступомСлужебный = ОбщегоНазначения.ОбщийМодуль("УправлениеДоступомСлужебный");
		МодульУправлениеДоступомСлужебный.ПриОпределенииНастроекРегламентныхЗаданий(Настройки);
	КонецЕсли;
	
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.ФайловыеФункции") Тогда
		МодульФайловыеФункцииСлужебный = ОбщегоНазначения.ОбщийМодуль("ФайловыеФункцииСлужебный");
		МодульФайловыеФункцииСлужебный.ПриОпределенииНастроекРегламентныхЗаданий(Настройки);
	КонецЕсли;
	
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.ЦентрМониторинга") Тогда
		МодульЦентрМониторингаСлужебный = ОбщегоНазначения.ОбщийМодуль("ЦентрМониторингаСлужебный");
		МодульЦентрМониторингаСлужебный.ПриОпределенииНастроекРегламентныхЗаданий(Настройки);
	КонецЕсли;
	
	
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Интеграция с подсистемой "Управление доступом".

// Возвращает менеджер временных таблиц, содержащий временную таблицу пользователей
// некоторых дополнительных групп пользователей, например, пользователей групп
// исполнителей задач, которые соответствуют ключам адресации
// (РольИсполнителя + ОсновнойОбъектАдресации + ДополнительныйОбъектАдресации).
//
//  При изменении состава дополнительных групп пользователей, необходимо вызвать
// процедуру ОбновитьПользователейГруппИсполнителей в модуле УправлениеДоступом,
// чтобы применить изменения к внутренним данным подсистемы.
//
// Параметры:
//  МенеджерВременныхТаблиц - МенеджерВременныхТаблиц, в который можно поместить таблицу:
//                            ТаблицаГруппИсполнителей с полями:
//                              ГруппаИсполнителей - Например,
//                                                   СправочникСсылка.ГруппыИсполнителейЗадач.
//                              Пользователь       - СправочникСсылка.Пользователи,
//                                                   СправочникСсылка.ВнешниеПользователи.
//
//  СодержаниеПараметра     - Неопределено - параметр не указан, вернуть все данные.
//                            Строка, когда
//                              "ГруппыИсполнителей" требуется вернуть
//                               только составы указанных групп исполнителей.
//                              "Исполнители" требуется вернуть
//                               только составы групп исполнителей, которые
//                               в которые входят указанные исполнители.
//
//  ЗначениеПараметра       - Неопределено, когда СодержаниеПараметра = Неопределено,
//                          - Например, СправочникСсылка.ГруппыИсполнителейЗадач,
//                            когда СодержаниеПараметра = "ГруппыИсполнителей".
//                          - СправочникСсылка.Пользователи,
//                            СправочникСсылка.ВнешниеПользователи,
//                            когда СодержаниеПараметра = "Исполнители".
//                            Массив указанных выше типов.
//
//  НетГруппИсполнителей    - Булево, если Ложь, МенеджерВременныхТаблиц содержит временную таблицу, иначе нет.
//
Процедура ПриОпределенииГруппИсполнителей(МенеджерВременныхТаблиц, СодержаниеПараметра,
				ЗначениеПараметра, НетГруппИсполнителей) Экспорт
	
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.БизнесПроцессыИЗадачи") Тогда
		МодульБизнесПроцессыИЗадачиСервер = ОбщегоНазначения.ОбщийМодуль("БизнесПроцессыИЗадачиСервер");
		МодульБизнесПроцессыИЗадачиСервер.ПриОпределенииГруппИсполнителей(МенеджерВременныхТаблиц,
			СодержаниеПараметра, ЗначениеПараметра, НетГруппИсполнителей);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
