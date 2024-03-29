#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныйПрограммныйИнтерфейс

Процедура ЗарегистрироватьУстранениеПроблемы(Источник, ТипПроблемы) Экспорт
	
	Если Источник.ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если Источник.ЭтоНовый() Тогда
		Возврат;
	КонецЕсли;
	
	Если ОбщегоНазначенияПовтИсп.ДоступноИспользованиеРазделенныхДанных() Тогда
		
		СсылкаНаИсточник = Источник.Ссылка;
		
		НовоеЗначениеПометкиУдаления = Источник.ПометкаУдаления;
		
		ОбменДаннымиВызовСервера.ЗарегистрироватьУстранениеПроблемы(СсылкаНаИсточник, ТипПроблемы, НовоеЗначениеПометкиУдаления);
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ЗарегистрироватьОшибкуПроверкиОбъекта(Ссылка, УзелИнформационнойБазы, Причина, ТипПроблемы) Экспорт
	
	НаборЗаписейКонфликта = РегистрыСведений.РезультатыОбменаДанными.СоздатьНаборЗаписей();
	НаборЗаписейКонфликта.Отбор.ПроблемныйОбъект.Установить(Ссылка);
	НаборЗаписейКонфликта.Отбор.ТипПроблемы.Установить(ТипПроблемы);
	
	НаборЗаписейКонфликта.Прочитать();
	НаборЗаписейКонфликта.Очистить();
	
	ЗаписьКонфликта = НаборЗаписейКонфликта.Добавить();
	ЗаписьКонфликта.ПроблемныйОбъект = Ссылка;
	ЗаписьКонфликта.ТипПроблемы = ТипПроблемы;
	ЗаписьКонфликта.УзелИнформационнойБазы = УзелИнформационнойБазы;
	ЗаписьКонфликта.ДатаВозникновения = ТекущаяДатаСеанса();
	ЗаписьКонфликта.Причина = СокрЛП(Причина);
	ЗаписьКонфликта.Пропущена = Ложь;
	ЗаписьКонфликта.ПометкаУдаления = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Ссылка, "ПометкаУдаления");
	
	Если ТипПроблемы = Перечисления.ТипыПроблемОбменаДанными.НепроведенныйДокумент Тогда
		
		ЗаписьКонфликта.НомерДокумента = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Ссылка, "Номер");
		ЗаписьКонфликта.ДатаДокумента = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Ссылка, "Дата");
		
	КонецЕсли;
	
	НаборЗаписейКонфликта.Записать();
	
КонецПроцедуры

Процедура Игнорировать(Ссылка, ТипПроблемы, Игнорировать) Экспорт
	
	НаборЗаписейКонфликта = РегистрыСведений.РезультатыОбменаДанными.СоздатьНаборЗаписей();
	НаборЗаписейКонфликта.Отбор.ПроблемныйОбъект.Установить(Ссылка);
	НаборЗаписейКонфликта.Отбор.ТипПроблемы.Установить(ТипПроблемы);
	НаборЗаписейКонфликта.Прочитать();
	НаборЗаписейКонфликта[0].Пропущена = Игнорировать;
	НаборЗаписейКонфликта.Записать();
	
КонецПроцедуры

Функция КоличествоПроблем(УзлыОбмена = Неопределено, ТипПроблемы = Неопределено, УчитыватьПроигнорированные = Ложь, Период = Неопределено, СтрокаПоиска = "") Экспорт
	
	Количество = 0;
	
	ТекстЗапроса = "ВЫБРАТЬ
	|	КОЛИЧЕСТВО(РезультатыОбменаДанными.ПроблемныйОбъект) КАК КоличествоПроблем
	|ИЗ
	|	РегистрСведений.РезультатыОбменаДанными КАК РезультатыОбменаДанными
	|ГДЕ
	|	РезультатыОбменаДанными.Пропущена <> &ОтборПоПропущенным
	|	[ОтборПоУзлу]
	|	[ОтборПоТипу]
	|	[ОтборПоПериоду]
	|	[ОтборПоПричине]";
	
	Запрос = Новый Запрос;
	
	ОтборПоПропущенным = ?(УчитыватьПроигнорированные, Неопределено, Истина);
	Запрос.УстановитьПараметр("ОтборПоПропущенным", ОтборПоПропущенным);
	
	Если ТипПроблемы = Неопределено Тогда
		СтрокаОтбора = "";
	Иначе
		СтрокаОтбора = "И РезультатыОбменаДанными.ТипПроблемы = &ТипПроблемы";
		Запрос.УстановитьПараметр("ТипПроблемы", ТипПроблемы);
	КонецЕсли;
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "[ОтборПоТипу]", СтрокаОтбора);
	
	Если УзлыОбмена = Неопределено Тогда
		СтрокаОтбора = "";
	ИначеЕсли ПланыОбмена.ТипВсеСсылки().СодержитТип(ТипЗнч(УзлыОбмена)) Тогда
		СтрокаОтбора = "И РезультатыОбменаДанными.УзелИнформационнойБазы = &УзелИнформационнойБазы";
		Запрос.УстановитьПараметр("УзелИнформационнойБазы", УзлыОбмена);
	Иначе
		СтрокаОтбора = "И РезультатыОбменаДанными.УзелИнформационнойБазы В (&УзлыОбмена)";
		Запрос.УстановитьПараметр("УзлыОбмена", УзлыОбмена);
	КонецЕсли;
	
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "[ОтборПоУзлу]", СтрокаОтбора);
	
	Если ЗначениеЗаполнено(Период) Тогда
		
		СтрокаОтбора = "И (РезультатыОбменаДанными.ДатаВозникновения >= &ДатаНачала
		| И РезультатыОбменаДанными.ДатаВозникновения <= &ДатаОкончания)";
		Запрос.УстановитьПараметр("ДатаНачала", Период.ДатаНачала);
		Запрос.УстановитьПараметр("ДатаОкончания", Период.ДатаОкончания);
		
	Иначе
		
		СтрокаОтбора = "";
		
	КонецЕсли;
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "[ОтборПоПериоду]", СтрокаОтбора);
	
	Если ЗначениеЗаполнено(СтрокаПоиска) Тогда
		
		СтрокаОтбора = "И РезультатыОбменаДанными.Причина ПОДОБНО &Причина";
		Запрос.УстановитьПараметр("Причина", "%" + СтрокаПоиска + "%");
		
	Иначе
		
		СтрокаОтбора = "";
		
	КонецЕсли;
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "[ОтборПоПричине]", СтрокаОтбора);
	
	Запрос.Текст = ТекстЗапроса;
	Результат = Запрос.Выполнить();
	
	Если Не Результат.Пустой() Тогда
		
		Выборка = Результат.Выбрать();
		Выборка.Следующий();
		Количество = Выборка.КоличествоПроблем;
		
	КонецЕсли;
	
	Возврат Количество;
	
КонецФункции

Процедура ОчиститьСсылкиНаУзелИнформационнойБазы(Знач УзелИнформационнойБазы) Экспорт
	
	Если Не ОбщегоНазначенияПовтИсп.ДоступноИспользованиеРазделенныхДанных() Тогда
		Возврат;
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	|	РезультатыОбменаДанными.ПроблемныйОбъект,
	|	РезультатыОбменаДанными.ТипПроблемы,
	|	НЕОПРЕДЕЛЕНО КАК УзелИнформационнойБазы,
	|	РезультатыОбменаДанными.ДатаВозникновения,
	|	РезультатыОбменаДанными.Причина,
	|	РезультатыОбменаДанными.Пропущена,
	|	РезультатыОбменаДанными.ПометкаУдаления,
	|	РезультатыОбменаДанными.НомерДокумента,
	|	РезультатыОбменаДанными.ДатаДокумента
	|ИЗ
	|	РегистрСведений.РезультатыОбменаДанными КАК РезультатыОбменаДанными
	|ГДЕ
	|	РезультатыОбменаДанными.УзелИнформационнойБазы = &УзелИнформационнойБазы";
	
	Запрос.УстановитьПараметр("УзелИнформационнойБазы", УзелИнформационнойБазы);
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Пока Выборка.Следующий() Цикл
		
		НаборЗаписей = РегистрыСведений.РезультатыОбменаДанными.СоздатьНаборЗаписей();
		
		НаборЗаписей.Отбор["ПроблемныйОбъект"].Установить(Выборка["ПроблемныйОбъект"]);
		НаборЗаписей.Отбор["ТипПроблемы"].Установить(Выборка["ТипПроблемы"]);
		
		ЗаполнитьЗначенияСвойств(НаборЗаписей.Добавить(), Выборка);
		
		НаборЗаписей.Записать();
		
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли