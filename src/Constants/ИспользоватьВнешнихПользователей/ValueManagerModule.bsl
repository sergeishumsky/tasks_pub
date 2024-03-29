#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

Перем ЗначениеИзменено;

#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	ЗначениеИзменено = Значение <> Константы.ИспользоватьВнешнихПользователей.Получить();
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если ЗначениеИзменено Тогда
		ПользователиСлужебный.ОбновитьРолиВнешнихПользователей();
		Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.УправлениеДоступом") Тогда
			МодульУправлениеДоступом = ОбщегоНазначения.ОбщийМодуль("УправлениеДоступом");
			МодульУправлениеДоступом.ОбновитьРолиПользователей(Тип("СправочникСсылка.ВнешниеПользователи"));
		КонецЕсли;
		Если Значение Тогда
			ОчиститьРеквизитПоказыватьВСпискеВыбораУВсехПользователейИБ();
		Иначе
			ОчиститьРеквизитВходВПрограммуРазрешенУВсехВнешнихПользователей();
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// У всех пользователей ИБ очищает реквизит ПризнакПоказыватьВСписке.
Процедура ОчиститьРеквизитПоказыватьВСпискеВыбораУВсехПользователейИБ() Экспорт
	
	ПользователиИБ = ПользователиИнформационнойБазы.ПолучитьПользователей();
	Для Каждого ПользовательИБ Из ПользователиИБ Цикл
		Если ПользовательИБ.ПоказыватьВСпискеВыбора Тогда
			ПользовательИБ.ПоказыватьВСпискеВыбора = Ложь;
			ПользовательИБ.Записать();
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

// У всех пользователей ИБ очищает реквизит ПризнакПоказыватьВСписке.
Процедура ОчиститьРеквизитВходВПрограммуРазрешенУВсехВнешнихПользователей()
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ВнешниеПользователи.ИдентификаторПользователяИБ КАК Идентификатор
	|ИЗ
	|	Справочник.ВнешниеПользователи КАК ВнешниеПользователи";
	Идентификаторы = Запрос.Выполнить().Выгрузить();
	Идентификаторы.Индексы.Добавить("Идентификатор");
	
	ПользователиИБ = ПользователиИнформационнойБазы.ПолучитьПользователей();
	Для Каждого ПользовательИБ Из ПользователиИБ Цикл
		
		Если Идентификаторы.Найти(ПользовательИБ.УникальныйИдентификатор, "Идентификатор") <> Неопределено
		   И Пользователи.ВходВПрограммуРазрешен(ПользовательИБ) Тогда
			
			ПользовательИБ.АутентификацияСтандартная = Ложь;
			ПользовательИБ.АутентификацияОС          = Ложь;
			ПользовательИБ.АутентификацияOpenID      = Ложь;
			ПользовательИБ.Записать();
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли
