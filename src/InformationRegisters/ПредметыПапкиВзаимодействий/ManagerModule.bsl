
#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныеПроцедурыИФункции

////////////////////////////////////////////////////////////////////////////////
// Обработчики обновления

// Процедура обновления ИБ для версии БСП 2.2.
// Переносит Рассмотрено и РассмотретьПосле из реквизитов документов взаимодействий в регистр сведений
// ПредметыПапкиВзаимодействий.
//
Процедура ОбновитьХранениеРассмотреноРассмотретьПосле_2_2_0_0(Параметры) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст = "
	|ВЫБРАТЬ ПЕРВЫЕ 1000
	|	Встреча.Ссылка,
	|	Встреча.Удалить_Рассмотрено КАК Рассмотрено,
	|	Встреча.Удалить_РассмотретьПосле КАК РассмотретьПосле
	|ИЗ
	|	Документ.Встреча КАК Встреча
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.ПредметыПапкиВзаимодействий КАК ПредметыПапкиВзаимодействий
	|		ПО (ПредметыПапкиВзаимодействий.Взаимодействие = Встреча.Ссылка)
	|ГДЕ
	|	НЕ (НЕ Встреча.Удалить_Рассмотрено <> ПредметыПапкиВзаимодействий.Рассмотрено
	|			И НЕ Встреча.Удалить_РассмотретьПосле <> ПредметыПапкиВзаимодействий.РассмотретьПосле)
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	ЗапланированноеВзаимодействие.Ссылка,
	|	ЗапланированноеВзаимодействие.Удалить_Рассмотрено,
	|	ЗапланированноеВзаимодействие.Удалить_РассмотретьПосле
	|ИЗ
	|	Документ.ЗапланированноеВзаимодействие КАК ЗапланированноеВзаимодействие
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.ПредметыПапкиВзаимодействий КАК ПредметыПапкиВзаимодействий
	|		ПО (ПредметыПапкиВзаимодействий.Взаимодействие = ЗапланированноеВзаимодействие.Ссылка)
	|ГДЕ
	|	НЕ (НЕ ЗапланированноеВзаимодействие.Удалить_Рассмотрено <> ПредметыПапкиВзаимодействий.Рассмотрено
	|			И НЕ ЗапланированноеВзаимодействие.Удалить_РассмотретьПосле <> ПредметыПапкиВзаимодействий.РассмотретьПосле)
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	ТелефонныйЗвонок.Ссылка,
	|	ТелефонныйЗвонок.Удалить_Рассмотрено,
	|	ТелефонныйЗвонок.Удалить_РассмотретьПосле
	|ИЗ
	|	Документ.ТелефонныйЗвонок КАК ТелефонныйЗвонок
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.ПредметыПапкиВзаимодействий КАК ПредметыПапкиВзаимодействий
	|		ПО (ПредметыПапкиВзаимодействий.Взаимодействие = ТелефонныйЗвонок.Ссылка)
	|ГДЕ
	|	НЕ (НЕ ТелефонныйЗвонок.Удалить_Рассмотрено <> ПредметыПапкиВзаимодействий.Рассмотрено
	|			И НЕ ТелефонныйЗвонок.Удалить_РассмотретьПосле <> ПредметыПапкиВзаимодействий.РассмотретьПосле)
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	ЭлектронноеПисьмоВходящее.Ссылка,
	|	ЭлектронноеПисьмоВходящее.Удалить_Рассмотрено,
	|	ЭлектронноеПисьмоВходящее.Удалить_РассмотретьПосле
	|ИЗ
	|	Документ.ЭлектронноеПисьмоВходящее КАК ЭлектронноеПисьмоВходящее
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.ПредметыПапкиВзаимодействий КАК ПредметыПапкиВзаимодействий
	|		ПО (ПредметыПапкиВзаимодействий.Взаимодействие = ЭлектронноеПисьмоВходящее.Ссылка)
	|ГДЕ
	|	НЕ (НЕ ЭлектронноеПисьмоВходящее.Удалить_Рассмотрено <> ПредметыПапкиВзаимодействий.Рассмотрено
	|			И НЕ ЭлектронноеПисьмоВходящее.Удалить_РассмотретьПосле <> ПредметыПапкиВзаимодействий.РассмотретьПосле)
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	ЭлектронноеПисьмоИсходящее.Ссылка,
	|	ЭлектронноеПисьмоИсходящее.Удалить_Рассмотрено,
	|	ЭлектронноеПисьмоИсходящее.Удалить_РассмотретьПосле
	|ИЗ
	|	Документ.ЭлектронноеПисьмоИсходящее КАК ЭлектронноеПисьмоИсходящее
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.ПредметыПапкиВзаимодействий КАК ПредметыПапкиВзаимодействий
	|		ПО (ПредметыПапкиВзаимодействий.Взаимодействие = ЭлектронноеПисьмоИсходящее.Ссылка)
	|ГДЕ
	|	НЕ (НЕ ЭлектронноеПисьмоИсходящее.Удалить_Рассмотрено <> ПредметыПапкиВзаимодействий.Рассмотрено
	|			И НЕ ЭлектронноеПисьмоИсходящее.Удалить_РассмотретьПосле <> ПредметыПапкиВзаимодействий.РассмотретьПосле)
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	СообщениеSMS.Ссылка,
	|	СообщениеSMS.Удалить_Рассмотрено,
	|	СообщениеSMS.Удалить_РассмотретьПосле
	|ИЗ
	|	Документ.СообщениеSMS КАК СообщениеSMS
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.ПредметыПапкиВзаимодействий КАК ПредметыПапкиВзаимодействий
	|		ПО (ПредметыПапкиВзаимодействий.Взаимодействие = СообщениеSMS.Ссылка)
	|ГДЕ
	|	НЕ (НЕ СообщениеSMS.Удалить_Рассмотрено <> ПредметыПапкиВзаимодействий.Рассмотрено
	|			И НЕ СообщениеSMS.Удалить_РассмотретьПосле <> ПредметыПапкиВзаимодействий.РассмотретьПосле)";
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Пока Выборка.Следующий() Цикл
		
		Реквизиты = ВзаимодействияКлиентСервер.СтруктураРеквизитовВзаимодействияДляЗаписи( , , Выборка.Рассмотрено, Выборка.РассмотретьПосле);
		НаборЗаписей = РегистрыСведений.ПредметыПапкиВзаимодействий.СоздатьНаборЗаписей();
		НаборЗаписей.Отбор.Взаимодействие.Установить(Выборка.Ссылка);
		ВзаимодействияВызовСервера.ЗаписьРегистрРеквизитыВзаимодействия(Выборка.Ссылка, Реквизиты, НаборЗаписей);
		ОбновлениеИнформационнойБазы.ЗаписатьДанные(НаборЗаписей);
	
	КонецЦикла;
	
	Параметры.ОбработкаЗавершена = (Выборка.Количество() = 0);

КонецПроцедуры

#КонецОбласти

#КонецЕсли
