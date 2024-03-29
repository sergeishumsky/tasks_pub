////////////////////////////////////////////////////////////////////////////////
// Подсистема "Файловые функции".
//
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

////////////////////////////////////////////////////////////////////////////////
// Процедуры и функция для работы со сканером.

// Открывает форму настройки сканирования.
Процедура ОткрытьФормуНастройкиСканирования() Экспорт
	
	Если ОбщегоНазначенияКлиентСервер.ЭтоLinuxКлиент() Тогда
		ТекстСообщения = НСтр("ru = 'Сканирование не поддерживается в клиенте под управлением ОС Linux.'");
		ПоказатьПредупреждение(, ТекстСообщения);
		Возврат;
	КонецЕсли;
	
	Если ОбщегоНазначенияКлиентСервер.ЭтоВебКлиент() Тогда
		ТекстСообщения = НСтр("ru = 'Сканирование не поддерживается в веб-клиенте.'");
		ПоказатьПредупреждение(, ТекстСообщения);
		Возврат;
	КонецЕсли;
	
	КомпонентаУстановлена = ФайловыеФункцииСлужебныйКлиент.ПроинициализироватьКомпоненту();
	
	Если Не КомпонентаУстановлена Тогда
		ТекстВопроса = НСтр("ru = 'Для продолжения работы необходимо установить компоненту сканирования. 
							|Установить компоненту?'");
		Обработчик = Новый ОписаниеОповещения("ПоказатьВопросУстановкиКомпонентыСканирования", ЭтотОбъект, КомпонентаУстановлена);
		ПоказатьВопрос(Обработчик, ТекстВопроса, РежимДиалогаВопрос.ДаНет);
		Возврат;
	КонецЕсли;
	
	ОткрытьФормуНастройкиСканированияЗавершение(КомпонентаУстановлена, Неопределено);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ПоказатьВопросУстановкиКомпонентыСканирования(Результат, КомпонентаУстановлена) Экспорт
	
	Если Результат = КодВозвратаДиалога.Да Тогда
		Обработчик = Новый ОписаниеОповещения("ОткрытьФормуНастройкиСканированияЗавершение", ЭтотОбъект);
		ФайловыеФункцииСлужебныйКлиент.УстановитьКомпоненту(Обработчик);
	КонецЕсли;
	
КонецФункции

Процедура ОткрытьФормуНастройкиСканированияЗавершение(КомпонентаУстановлена, ПараметрыВыполнения) Экспорт
	
	Если Не КомпонентаУстановлена Тогда
		Возврат;
	КонецЕсли;
	
	СистемнаяИнформация = Новый СистемнаяИнформация();
	ИдентификаторКлиента = СистемнаяИнформация.ИдентификаторКлиента;
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("КомпонентаУстановлена", КомпонентаУстановлена);
	ПараметрыФормы.Вставить("ИдентификаторКлиента",  ИдентификаторКлиента);
	
	ОткрытьФорму("Обработка.Сканирование.Форма.НастройкаСканирования", ПараметрыФормы);
	
КонецПроцедуры

#КонецОбласти
