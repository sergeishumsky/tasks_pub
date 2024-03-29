
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	СтатусОтправки = НСтр("ru = 'Сообщение отправляется...'");
	ТекстСообщения = Параметры.Текст;
	Если ТипЗнч(Параметры.НомераПолучателей) = Тип("Массив") Тогда
		Разделитель = "";
		Для каждого НомерТелефона Из Параметры.НомераПолучателей Цикл 
			НомераПолучателей = НомераПолучателей + Разделитель + НомерТелефона;
			Разделитель = ",";
		КонецЦикла;
	ИначеЕсли ТипЗнч(Параметры.НомераПолучателей) = Тип("СписокЗначений") Тогда
		Разделитель = "";
		Для каждого ИнформацияОТелефоне Из Параметры.НомераПолучателей Цикл 
			НомераПолучателей = НомераПолучателей + Разделитель + ИнформацияОТелефоне.Значение;
			Разделитель = ",";
		КонецЦикла;
	Иначе
		НомераПолучателей = Строка(Параметры.НомераПолучателей);
	КонецЕсли;
	
	Заголовок = НСтр("ru = 'Отправка SMS на телефон'") + " " + НомераПолучателей;
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	ДлинаСообщенияСимволов = 0;
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ДобавлятьОтправителяПриИзменении(Элемент)
	Элементы.ИмяОтправителя.Доступность = ДобавлятьОтправителя;
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Отправить(Команда)
	
	Если СтрДлина(ТекстСообщения) = 0 Тогда
		ПоказатьПредупреждение(, НСтр("ru = 'Необходимо ввести текст сообщения'"));
		Возврат;
	КонецЕсли;
	
	Если НЕ ОтправкаSMSНастроена() Тогда
		ОткрытьФорму("ОбщаяФорма.НастройкаОтправкиSMS");
		Возврат;
	КонецЕсли;
	
	Элементы.Страницы.ТекущаяСтраница = Элементы.СтраницаСтатус;
	
	Если Элементы.Найти("НастройкаОтправкиSMSОткрыть") <> Неопределено Тогда
		Элементы.НастройкаОтправкиSMSОткрыть.Видимость = Ложь;
	КонецЕсли;
	
	Элементы.Закрыть.Видимость = Истина;
	Элементы.Закрыть.КнопкаПоУмолчанию = Истина;
	Элементы.Отправить.Видимость = Ложь;
	
	// Отправка из серверного контекста.
	ОтправитьSMS();

	// проверка статуса отправки
	Если Не ПустаяСтрока(ИдентификаторСообщения) Тогда
		ПроверитьСтатусДоставки();
	Иначе
		Элементы.ДекорацияАнимация.Картинка = БиблиотекаКартинок.Ошибка32;
		СтатусОтправки = НСтр("ru = 'Сообщение не было отправлено (см. журнал регистрации).'");
		ОшибкаОтправкиСообщения();
	КонецЕсли;
	
КонецПроцедуры

&НаСервереБезКонтекста
Процедура ОшибкаОтправкиСообщения()
	ОписаниеОшибки = НСтр("ru = 'При попытке передать сообщение для отправки провайдеру SMS услуг возникла ошибка.'");
	ИмяСобытия = НСтр("ru = 'Ошибка отправки SMS отсутствует идентификатор сообщения.'", ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка());
	ЗаписьЖурналаРегистрации(ИмяСобытия, УровеньЖурналаРегистрации.Ошибка, , , ОписаниеОшибки);
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ОтправитьSMS()
	
	// Сброс отображаемого статуса доставки.
	ИдентификаторСообщения = "";
	
	// Подготовка номеров получателей.
	МассивНомеров = СтрокиТекстаВМассив(НомераПолучателей);
	
	// отправка
	РезультатОтправки = ОтправкаSMS.ОтправитьSMS(МассивНомеров, ТекстСообщения, ИмяОтправителя, ОтправлятьВТранслите);
	
	// Проверка доставки для первого получателя.
	Если РезультатОтправки.ОтправленныеСообщения.Количество() > 0 Тогда
		ИдентификаторСообщения = РезультатОтправки.ОтправленныеСообщения[0].ИдентификаторСообщения;
	КонецЕсли;
	
	// Вывод информации об ошибках в процессе отправки.
	Если Не ПустаяСтрока(РезультатОтправки.ОписаниеОшибки) Тогда 
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(РезультатОтправки.ОписаниеОшибки);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПроверитьСтатусДоставки()
	
	ОтключитьОбработчикОжидания("ПроверитьСтатусДоставки");;
	РезультатДоставки = СтатусДоставки(ИдентификаторСообщения);
	СтатусОтправки = РезультатДоставки.Описание;
	
	Если РезультатДоставки.Статус = "Отправляется" ИЛИ РезультатДоставки.Статус = "Отправлено" Тогда
		// Повтор проверки статуса доставки, если сообщение в процессе передачи абоненту.
		ПодключитьОбработчикОжидания("ПроверитьСтатусДоставки", 5, Истина);
	ИначеЕсли РезультатДоставки.Статус = "Доставлено" Тогда
		Элементы.ДекорацияАнимация.Картинка = БиблиотекаКартинок.Успешно32;
	Иначе
		Элементы.ДекорацияАнимация.Картинка = БиблиотекаКартинок.Ошибка32;
	КонецЕсли;

КонецПроцедуры

&НаСервереБезКонтекста
Функция СтатусДоставки(ИдентификаторСообщения)
	
	СтатусыДоставки = Новый Соответствие;
	СтатусыДоставки.Вставить("Ошибка", НСтр("ru = 'Произошла ошибка при подключении к провайдеру SMS'"));
	СтатусыДоставки.Вставить("НеОтправлялось", НСтр("ru = 'Сообщение не отправлялось.'"));
	СтатусыДоставки.Вставить("Отправляется", НСтр("ru = 'Отправка сообщения...'"));
	СтатусыДоставки.Вставить("Отправлено", НСтр("ru = 'Отправлено, ожидается подтверждение о доставке...'"));
	СтатусыДоставки.Вставить("НеОтправлено", НСтр("ru = 'Сообщение не отправлено'"));
	СтатусыДоставки.Вставить("Доставлено", НСтр("ru = 'Сообщение доставлено'"));
	СтатусыДоставки.Вставить("НеДоставлено", НСтр("ru = 'Не доставлено'"));
	
	РезультатДоставки = Новый Структура("Статус, Описание");
	РезультатДоставки.Статус = ОтправкаSMS.СтатусДоставки(ИдентификаторСообщения);
	РезультатДоставки.Описание = СтатусыДоставки.Получить(РезультатДоставки.Статус);
	Если РезультатДоставки.Описание  = Неопределено Тогда
		РезультатДоставки.Описание = СтатусыДоставки["НеДоставлено"];
	КонецЕсли;
	
	Возврат РезультатДоставки;
	
КонецФункции

&НаСервере
Функция СтрокиТекстаВМассив(Текст)
	
	Результат = Новый Массив;
	
	ТекстовыйДокумент = Новый ТекстовыйДокумент;
	ТекстовыйДокумент.УстановитьТекст(Текст);
	
	Для НомерСтроки = 1 По ТекстовыйДокумент.КоличествоСтрок() Цикл
		Строка = ТекстовыйДокумент.ПолучитьСтроку(НомерСтроки);
		Если Не ПустаяСтрока(Строка) Тогда
			Результат.Добавить(Строка);
		КонецЕсли;
	КонецЦикла;
	
	Возврат Результат;
	
КонецФункции

&НаКлиенте
Процедура ТекстИзменениеТекстаРедактирования(Элемент, Текст, СтандартнаяОбработка)
	ДлинаСообщенияСимволов = СтрДлина(Текст);
	СтандартнаяОбработка = Ложь;
КонецПроцедуры

&НаСервереБезКонтекста
Функция ОтправкаSMSНастроена()
 	Возврат ОтправкаSMS.НастройкаОтправкиSMSВыполнена();
КонецФункции

#КонецОбласти
