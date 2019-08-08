////////////////////////////////////////////////////////////////////////////////
// Подсистема "Напоминания пользователя".
//
////////////////////////////////////////////////////////////////////////////////

#Область СлужебныйПрограммныйИнтерфейс

// Объявляет события подсистемы НапоминанияПользователя:
//
// Серверные события:
//   ПриЗаполненииСпискаРеквизитовИсточникаСДатамиДляНапоминания.
//
// См. описание этой же процедуры в модуле СтандартныеПодсистемыСервер.
Процедура ПриДобавленииСлужебныхСобытий(КлиентскиеСобытия, СерверныеСобытия) Экспорт
	
	// СЕРВЕРНЫЕ СОБЫТИЯ.
	
	// Переопределяет массив реквизитов объекта, относительно которых разрешается устанавливать время напоминания.
	// Например, можно скрыть те реквизиты с датами, которые являются служебными или не имеют смысла для 
	// установки напоминаний: дата документа или задачи и прочие.
	// 
// Параметры:
	//  Источник - Любая ссылка - Ссылка на объект, для которого формируется массив реквизитов с датами.
	//  МассивРеквизитов - Массив - Массив имен реквизитов (из метаданных), содержащих даты.
	//
	// Синтаксис:
	// Процедура ПриЗаполненииСпискаРеквизитовИсточникаСДатамиДляНапоминания(Источник, МассивРеквизитов) Экспорт
	//
	// (То же, что
	// НапоминанияПользователяКлиентСерверПереопределяемый.ПриЗаполненииСпискаРеквизитовИсточникаСДатамиДляНапоминания).
	//
	СерверныеСобытия.Добавить("СтандартныеПодсистемы.НапоминанияПользователя\ПриЗаполненииСпискаРеквизитовИсточникаСДатамиДляНапоминания");
	
КонецПроцедуры

// См. описание этой же процедуры в модуле СтандартныеПодсистемыСервер.
Процедура ПриДобавленииОбработчиковСлужебныхСобытий(КлиентскиеОбработчики, СерверныеОбработчики) Экспорт
	
	// КЛИЕНТСКИЕ ОБРАБОТЧИКИ.
	
	КлиентскиеОбработчики[
		"СтандартныеПодсистемы.БазоваяФункциональность\ПослеНачалаРаботыСистемы"].Добавить(
			"НапоминанияПользователяКлиент");
	
	// СЕРВЕРНЫЕ ОБРАБОТЧИКИ.
	
	СерверныеОбработчики[
		"СтандартныеПодсистемы.БазоваяФункциональность\ПриДобавленииПараметровРаботыКлиентаПриЗапуске"].Добавить(
		"НапоминанияПользователяСлужебный");
	
	СерверныеОбработчики[
		"СтандартныеПодсистемы.БазоваяФункциональность\ПриДобавленииПараметровРаботыКлиента"].Добавить(
		"НапоминанияПользователяСлужебный");
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Возвращает стандартные расписания для периодических напоминаний.
Функция ПолучитьСтандартныеРасписанияДляНапоминания() Экспорт
	
	Результат = Новый Соответствие;
		
	// по понедельникам в 9:00
	Расписание = Новый РасписаниеРегламентногоЗадания;
	Расписание.ПериодПовтораДней = 1;
	Расписание.ПериодНедель = 1;
	Расписание.ВремяНачала = '00010101090000';
	ДниНедели = Новый Массив;
	ДниНедели.Добавить(1);
	Расписание.ДниНедели = ДниНедели;
	Результат.Вставить(НСтр("ru = 'по понедельникам, в 9:00'"), Расписание);
	
	// по пятницам в 15:00
	Расписание = Новый РасписаниеРегламентногоЗадания;
	Расписание.ПериодПовтораДней = 1;
	Расписание.ПериодНедель = 1;
	Расписание.ВремяНачала = '00010101150000';
	ДниНедели = Новый Массив;
	ДниНедели.Добавить(5);
	Расписание.ДниНедели = ДниНедели;
	Результат.Вставить(НСтр("ru = 'по пятницам, в 15:00'"), Расписание);
	
	// каждый день в 9:00
	Расписание = Новый РасписаниеРегламентногоЗадания;
	Расписание.ПериодПовтораДней = 1;
	Расписание.ПериодНедель = 1;
	Расписание.ВремяНачала = '00010101090000';
	Результат.Вставить(НСтр("ru = 'каждый день, в 9:00'"), Расписание);
	
	// для изменения списка
	НапоминанияПользователяКлиентСерверПереопределяемый.ПриПолученииСтандартныхРасписанийДляНапоминания(Результат);
	
	Возврат Результат;
	
КонецФункции

// Возвращает структуру настроек напоминаний пользователя.
Функция ПолучитьНастройкиНапоминаний()
	
	Результат = Новый Структура;
	Результат.Вставить("ИспользоватьНапоминания", ЕстьПравоИспользованияНапоминаний() И ПолучитьФункциональнуюОпцию("ИспользоватьНапоминанияПользователя"));
	Результат.Вставить("ИнтервалПроверкиНапоминаний", ПолучитьИнтервалПроверкиНапоминаний());
	
	Возврат Результат;
	
КонецФункции

// Проверяет наличие права изменения РС НапоминанияПользователя.
//
// Возвращаемое значение:
//  Булево - Истина, если право есть.
Функция ЕстьПравоИспользованияНапоминаний()
	Возврат ПравоДоступа("Изменение", Метаданные.РегистрыСведений.НапоминанияПользователя); 
КонецФункции

// Возвращает ближайшую дату по расписанию относительно даты, переданной в параметре.
//
// Параметры:
//  Расписание - РасписаниеРегламентногоЗадания - любое расписание.
//  ПредыдущаяДата - Дата - дата предыдущего события по расписанию.
//
// Возвращаемое значение:
//   Дата - дата и время следующего события по расписанию.
//
Функция ПолучитьБлижайшуюДатуСобытияПоРасписанию(Расписание, ПредыдущаяДата = '000101010000') Экспорт

	Результат = Неопределено;
	
	ДатаОтсчета = ПредыдущаяДата;
	Если Не ЗначениеЗаполнено(ДатаОтсчета) Тогда
		ДатаОтсчета = ТекущаяДатаСеанса();
	КонецЕсли;

	Календарь = ПолучитьКалендарьНаБудущее(365*4+1, ДатаОтсчета, Расписание.ДатаНачала, Расписание.ПериодПовтораДней, Расписание.ПериодНедель);
	
	ДниНедели = Расписание.ДниНедели;
	Если ДниНедели.Количество() = 0 Тогда
		ДниНедели = Новый Массив;
		Для День = 1 По 7 Цикл
			ДниНедели.Добавить(День);
		КонецЦикла;
	КонецЕсли;
	
	Месяцы = Расписание.Месяцы;
	Если Месяцы.Количество() = 0 Тогда
		Месяцы = Новый Массив;
		Для Месяц = 1 По 12 Цикл
			Месяцы.Добавить(Месяц);
		КонецЦикла;
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	
	Запрос.Текст = "ВЫБРАТЬ * ПОМЕСТИТЬ Календарь ИЗ &Календарь КАК Календарь";
	Запрос.УстановитьПараметр("Календарь", Календарь);
	Запрос.Выполнить();
	
	Запрос.УстановитьПараметр("ДатаНачала",			Расписание.ДатаНачала);
	Запрос.УстановитьПараметр("ДатаКонца",			Расписание.ДатаКонца);
	Запрос.УстановитьПараметр("ДниНедели",			ДниНедели);
	Запрос.УстановитьПараметр("Месяцы",				Месяцы);
	Запрос.УстановитьПараметр("ДеньВМесяце",		Расписание.ДеньВМесяце);
	Запрос.УстановитьПараметр("ДеньНеделиВМесяце",	Расписание.ДеньНеделиВМесяце);
	Запрос.УстановитьПараметр("ПериодПовтораДней",	?(Расписание.ПериодПовтораДней = 0,1,Расписание.ПериодПовтораДней));
	Запрос.УстановитьПараметр("ПериодНедель",		?(Расписание.ПериодНедель = 0,1,Расписание.ПериодНедель));
	
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	Календарь.Дата,
	|	Календарь.НомерМесяца,
	|	Календарь.НомерДняНеделиВМесяце,
	|	Календарь.НомерДняНеделиСКонцаМесяца,
	|	Календарь.НомерДняВМесяце,
	|	Календарь.НомерДняВМесяцеСКонцаМесяца,
	|	Календарь.НомерДняВНеделе,
	|	Календарь.НомерДняВПериоде,
	|	Календарь.НомерНеделиВПериоде
	|ИЗ
	|	Календарь КАК Календарь
	|ГДЕ
	|	ВЫБОР
	|			КОГДА &ДатаНачала = ДАТАВРЕМЯ(1, 1, 1, 0, 0, 0)
	|				ТОГДА ИСТИНА
	|			ИНАЧЕ Календарь.Дата >= &ДатаНачала
	|		КОНЕЦ
	|	И ВЫБОР
	|			КОГДА &ДатаКонца = ДАТАВРЕМЯ(1, 1, 1, 0, 0, 0)
	|				ТОГДА ИСТИНА
	|			ИНАЧЕ Календарь.Дата <= &ДатаКонца
	|		КОНЕЦ
	|	И Календарь.НомерДняВНеделе В(&ДниНедели)
	|	И Календарь.НомерМесяца В(&Месяцы)
	|	И ВЫБОР
	|			КОГДА &ДеньВМесяце = 0
	|				ТОГДА ИСТИНА
	|			ИНАЧЕ ВЫБОР
	|					КОГДА &ДеньВМесяце > 0
	|						ТОГДА Календарь.НомерДняВМесяце = &ДеньВМесяце
	|					ИНАЧЕ Календарь.НомерДняВМесяцеСКонцаМесяца = -&ДеньВМесяце
	|				КОНЕЦ
	|		КОНЕЦ
	|	И ВЫБОР
	|			КОГДА &ДеньНеделиВМесяце = 0
	|				ТОГДА ИСТИНА
	|			ИНАЧЕ ВЫБОР
	|					КОГДА &ДеньНеделиВМесяце > 0
	|						ТОГДА Календарь.НомерДняНеделиВМесяце = &ДеньНеделиВМесяце
	|					ИНАЧЕ Календарь.НомерДняНеделиСКонцаМесяца = -&ДеньНеделиВМесяце
	|				КОНЕЦ
	|		КОНЕЦ
	|	И Календарь.НомерДняВПериоде = &ПериодПовтораДней
	|	И Календарь.НомерНеделиВПериоде = &ПериодНедель";
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Если Выборка.Следующий() Тогда
		БлижайшаяДата = Выборка.Дата;
		
		ВремяОтсчета = '00010101';
		Если НачалоДня(БлижайшаяДата) = НачалоДня(ТекущаяДатаСеанса()) Тогда
			ВремяОтсчета = ВремяОтсчета + (ТекущаяДатаСеанса()-НачалоДня(ТекущаяДатаСеанса()));
		КонецЕсли;
		
		БлижайшееВремя = ПолучитьБлижайшееВремяИзРасписания(Расписание, ВремяОтсчета);
		Если БлижайшееВремя <> Неопределено Тогда
			Результат = БлижайшаяДата + (БлижайшееВремя - '00010101');
		Иначе
			Если Выборка.Следующий() Тогда
				Время = ПолучитьБлижайшееВремяИзРасписания(Расписание);
				Результат = Выборка.Дата + (Время - '00010101');
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

Функция ПолучитьКалендарьНаБудущее(КоличествоДнейКалендаря, ДатаОтсчета, Знач ДатаНачалаПериодичности = Неопределено, Знач ПериодДней = 1, Знач ПериодНедель = 1) 
	
	Если ПериодНедель = 0 Тогда 
		ПериодНедель = 1;
	КонецЕсли;
	
	Если ПериодДней = 0 Тогда
		ПериодДней = 1;
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(ДатаНачалаПериодичности) Тогда
		ДатаНачалаПериодичности = ДатаОтсчета;
	КонецЕсли;
	
	Календарь = Новый ТаблицаЗначений;
	Календарь.Колонки.Добавить("Дата", Новый ОписаниеТипов("Дата",,,Новый КвалификаторыДаты()));
	Календарь.Колонки.Добавить("НомерМесяца", Новый ОписаниеТипов("Число",Новый КвалификаторыЧисла(2,0,ДопустимыйЗнак.Неотрицательный)));
	Календарь.Колонки.Добавить("НомерДняНеделиВМесяце", Новый ОписаниеТипов("Число",Новый КвалификаторыЧисла(1,0,ДопустимыйЗнак.Неотрицательный)));
	Календарь.Колонки.Добавить("НомерДняНеделиСКонцаМесяца", Новый ОписаниеТипов("Число",Новый КвалификаторыЧисла(1,0,ДопустимыйЗнак.Неотрицательный)));
	Календарь.Колонки.Добавить("НомерДняВМесяце", Новый ОписаниеТипов("Число",Новый КвалификаторыЧисла(2,0,ДопустимыйЗнак.Неотрицательный)));
	Календарь.Колонки.Добавить("НомерДняВМесяцеСКонцаМесяца", Новый ОписаниеТипов("Число",Новый КвалификаторыЧисла(2,0,ДопустимыйЗнак.Неотрицательный)));
	Календарь.Колонки.Добавить("НомерДняВНеделе", Новый ОписаниеТипов("Число",Новый КвалификаторыЧисла(2,0,ДопустимыйЗнак.Неотрицательный)));	
	Календарь.Колонки.Добавить("НомерДняВПериоде", Новый ОписаниеТипов("Число",Новый КвалификаторыЧисла(3,0,ДопустимыйЗнак.Неотрицательный)));	
	Календарь.Колонки.Добавить("НомерНеделиВПериоде", Новый ОписаниеТипов("Число",Новый КвалификаторыЧисла(3,0,ДопустимыйЗнак.Неотрицательный)));
	
	Дата = НачалоДня(ДатаОтсчета);
	ДатаНачалаПериодичности = НачалоДня(ДатаНачалаПериодичности);
	НомерДняВПериоде = 0;
	НомерНеделиВПериоде = 0;
	
	Если ДатаНачалаПериодичности <= Дата Тогда
		КоличествоДней = (Дата - ДатаНачалаПериодичности)/60/60/24;
		НомерДняВПериоде = КоличествоДней - Цел(КоличествоДней/ПериодДней)*ПериодДней;
		
		КоличествоНедель = Цел(КоличествоДней / 7);
		НомерНеделиВПериоде = КоличествоНедель - Цел(КоличествоНедель/ПериодНедель)*ПериодНедель;
	КонецЕсли;
	
	Если НомерДняВПериоде = 0 Тогда 
		НомерДняВПериоде = ПериодДней;
	КонецЕсли;
	
	Если НомерНеделиВПериоде = 0 Тогда 
		НомерНеделиВПериоде = ПериодНедель;
	КонецЕсли;
	
	Для Счетчик = 0 По КоличествоДнейКалендаря - 1 Цикл
		
		Дата = НачалоДня(ДатаОтсчета) + Счетчик * 60*60*24;
		НоваяСтрока = Календарь.Добавить();
		НоваяСтрока.Дата = Дата;
		НоваяСтрока.НомерМесяца = Месяц(Дата);
		НоваяСтрока.НомерДняНеделиВМесяце = Цел((Дата - НачалоМесяца(Дата))/60/60/24/7) + 1;
		НоваяСтрока.НомерДняНеделиСКонцаМесяца = Цел((КонецМесяца(НачалоДня(Дата)) - Дата)/60/60/24/7) + 1;
		НоваяСтрока.НомерДняВМесяце = День(Дата);
		НоваяСтрока.НомерДняВМесяцеСКонцаМесяца = День(КонецМесяца(НачалоДня(Дата))) - День(Дата) + 1;
		НоваяСтрока.НомерДняВНеделе = ДеньНедели(Дата);
		
		Если ДатаНачалаПериодичности <= Дата Тогда
			НоваяСтрока.НомерДняВПериоде = НомерДняВПериоде;
			НоваяСтрока.НомерНеделиВПериоде = НомерНеделиВПериоде;
			
			НомерДняВПериоде = ?(НомерДняВПериоде+1 > ПериодДней, 1, НомерДняВПериоде+1);
			
			Если НоваяСтрока.НомерДняВНеделе = 1 Тогда
				НомерНеделиВПериоде = ?(НомерНеделиВПериоде+1 > ПериодНедель, 1, НомерНеделиВПериоде+1);
			КонецЕсли;
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат Календарь;
	
КонецФункции

Функция ПолучитьБлижайшееВремяИзРасписания(Расписание, Знач ВремяОтсчета = '000101010000')
	
	Результат = Неопределено;
	
	СписокЗначений = Новый СписокЗначений;
	
	Если Расписание.ДетальныеРасписанияДня.Количество() = 0 Тогда
		СписокЗначений.Добавить(Расписание.ВремяНачала);
	Иначе
		Для Каждого РасписаниеДня Из Расписание.ДетальныеРасписанияДня Цикл
			СписокЗначений.Добавить(РасписаниеДня.ВремяНачала);
		КонецЦикла;
	КонецЕсли;
	
	СписокЗначений.СортироватьПоЗначению(НаправлениеСортировки.Возр);
	
	Для Каждого ВремяДня Из СписокЗначений Цикл
		Если ВремяОтсчета <= ВремяДня.Значение Тогда
			Результат = ВремяДня.Значение;
			Прервать;
		КонецЕсли;
	КонецЦикла;
	
	Возврат Результат;
	
КонецФункции

// Возвращает интервал времени в минутах, через который необходимо повторять проверку текущих напоминаний.
Функция ПолучитьИнтервалПроверкиНапоминаний(Пользователь = Неопределено)
	Интервал = ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить(
									"НастройкиНапоминаний", 
									"ИнтервалПроверкиНапоминаний", 
									1,
									,
									ПолучитьИмяПользователяИБ(Пользователь));
	Возврат Макс(Интервал, 1);
КонецФункции

// Конвертирует таблицу в массив структур.
//
// Параметры:
//  ТаблицаЗначений - произвольная таблица значений, у которой есть имена колонок.
//
// Возвращаемое значение
//  Массив - массив структур, содержащих значения строк таблицы.
Функция ПолучитьМассивСтруктурИзТаблицы(ТаблицаЗначений) Экспорт
	Результат = Новый Массив;
	Для Каждого Строка Из ТаблицаЗначений Цикл
		СтруктураСтроки = Новый Структура;
		Для Каждого Колонка Из ТаблицаЗначений.Колонки Цикл
			СтруктураСтроки.Вставить(Колонка.Имя, Строка[Колонка.Имя]);
		КонецЦикла;
		Результат.Добавить(СтруктураСтроки);
	КонецЦикла;
	Возврат Результат;			
КонецФункции

Функция ПолучитьИмяПользователяИБ(Пользователь)
	Если Не ЗначениеЗаполнено(Пользователь) Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Истина);
	
	ПользовательИБ = ПользователиИнформационнойБазы.НайтиПоУникальномуИдентификатору(ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Пользователь, "ИдентификаторПользователяИБ"));
	Если ПользовательИБ = Неопределено Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	Возврат ПользовательИБ.Имя;
КонецФункции

// Получает значение реквизита для любого объекта ссылочного типа.
Функция ПолучитьЗначениеРеквизитаПредмета(СсылкаНаПредмет, ИмяРеквизита) Экспорт
	
	Результат = Неопределено;
	
	Запрос = Новый Запрос;
	
	ТекстЗапроса =
	"ВЫБРАТЬ 
	|	Таблица.&Реквизит КАК Реквизит
	|ИЗ
	|	&ИмяТаблицы КАК Таблица
	|ГДЕ
	|	Таблица.Ссылка = &Ссылка";

	ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "&ИмяТаблицы", СсылкаНаПредмет.Метаданные().ПолноеИмя());
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "&Реквизит", ИмяРеквизита);
	
	Запрос.Текст = ТекстЗапроса;
	
	Запрос.УстановитьПараметр("Ссылка", СсылкаНаПредмет);

	Результат = Запрос.Выполнить();

	Выборка = Результат.Выбрать();

	Если Выборка.Следующий() Тогда
		Результат = Выборка.Реквизит;
	КонецЕсли;

	Возврат Результат;
	
КонецФункции

// Проверяет изменения реквизитов предметов, на которые есть пользовательская подписка,
// изменяет срок напоминания в случае необходимости.
Процедура ПроверитьИзмененияДатВПредмете(Предмет)
	
	УстановитьПривилегированныйРежим(Истина);
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	Напоминания.Пользователь,
	|	Напоминания.ВремяСобытия,
	|	Напоминания.Источник,
	|	Напоминания.СрокНапоминания,
	|	Напоминания.Описание,
	|	Напоминания.СпособУстановкиВремениНапоминания,
	|	Напоминания.ИнтервалВремениНапоминания,
	|	Напоминания.ИмяРеквизитаИсточника,
	|	Напоминания.Расписание
	|ИЗ
	|	РегистрСведений.НапоминанияПользователя КАК Напоминания
	|ГДЕ
	|	Напоминания.СпособУстановкиВремениНапоминания = ЗНАЧЕНИЕ(Перечисление.СпособыУстановкиВремениНапоминания.ОтносительноВремениПредмета)
	|	И Напоминания.Источник = &Источник";
	
	Запрос.УстановитьПараметр("Источник", Предмет);
	
	ТаблицаРезультата = Запрос.Выполнить().Выгрузить();
	
	Для Каждого СтрокаТаблицы Из ТаблицаРезультата Цикл
		ДатаПредмета = ПолучитьЗначениеРеквизитаПредмета(СтрокаТаблицы.Источник, СтрокаТаблицы.ИмяРеквизитаИсточника);
		Если (ДатаПредмета - СтрокаТаблицы.ИнтервалВремениНапоминания) <> СтрокаТаблицы.ВремяСобытия Тогда
			ОтключитьНапоминание(СтрокаТаблицы);
			СтрокаТаблицы.СрокНапоминания = ДатаПредмета - СтрокаТаблицы.ИнтервалВремениНапоминания;
			СтрокаТаблицы.ВремяСобытия = ДатаПредмета;
			ПодключитьНапоминание(СтрокаТаблицы);
		КонецЕсли;
	КонецЦикла;
КонецПроцедуры

// Обработчик подписки на событие ПриЗаписи объекта, по поводу которого можно создавать напоминания.
Процедура ПроверитьИзмененияДатВПредметеПриЗаписи(Источник, Отказ) Экспорт
	
	Если Источник.ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если СтандартныеПодсистемыСервер.ЭтоИдентификаторОбъектаМетаданных(Источник) Тогда
		Возврат;
	КонецЕсли;
	
	Если ПолучитьФункциональнуюОпцию("ИспользоватьНапоминанияПользователя") Тогда
		ПроверитьИзмененияДатВПредмете(Источник.Ссылка);
	КонецЕсли;
	
КонецПроцедуры

// Создает напоминание пользователя. Если по объекту уже есть напоминание, то перезаписывает его.
Процедура ПодключитьНапоминание(ПараметрыНапоминания, ОбновитьСрокНапоминания = Ложь) Экспорт
	
	НаборЗаписей = РегистрыСведений.НапоминанияПользователя.СоздатьНаборЗаписей();
	НаборЗаписей.Отбор.Пользователь.Установить(ПараметрыНапоминания.Пользователь);
	НаборЗаписей.Отбор.Источник.Установить(ПараметрыНапоминания.Источник);
	НаборЗаписей.Отбор.ВремяСобытия.Установить(ПараметрыНапоминания.ВремяСобытия);
	
	НаборЗаписей.Прочитать();
	
	Если НаборЗаписей.Количество() = 0 Тогда
		Если Не ОбновитьСрокНапоминания Тогда
			НоваяЗапись = НаборЗаписей.Добавить();
			ЗаполнитьЗначенияСвойств(НоваяЗапись, ПараметрыНапоминания);
		КонецЕсли;
	Иначе
		Для Каждого Запись Из НаборЗаписей Цикл
			ЗаполнитьЗначенияСвойств(Запись, ПараметрыНапоминания,,?(ОбновитьСрокНапоминания,"","СрокНапоминания"));
		КонецЦикла;
	КонецЕсли;
	
	НаборЗаписей.Записать();
	
КонецПроцедуры

// Отключает напоминание, если оно есть. Если напоминание периодическое, подключает его на ближайшую дату по расписанию.
Процедура ОтключитьНапоминание(ПараметрыНапоминания, ПодключатьПоРасписанию = Истина) Экспорт
	
	// ищем существующую запись
	Запрос = Новый Запрос;
	
	ТекстЗапроса = 
	"ВЫБРАТЬ
	|	НапоминанияПользователя.Пользователь,
	|	НапоминанияПользователя.ВремяСобытия,
	|	НапоминанияПользователя.Источник,
	|	НапоминанияПользователя.СрокНапоминания,
	|	НапоминанияПользователя.Описание,
	|	НапоминанияПользователя.СпособУстановкиВремениНапоминания,
	|	НапоминанияПользователя.Расписание
	|ИЗ
	|	РегистрСведений.НапоминанияПользователя КАК НапоминанияПользователя
	|ГДЕ
	|	НапоминанияПользователя.Пользователь = &Пользователь
	|	И НапоминанияПользователя.ВремяСобытия = &ВремяСобытия
	|	И НапоминанияПользователя.Источник = &Источник";
	
	Запрос.УстановитьПараметр("Пользователь", ПараметрыНапоминания.Пользователь);
	Запрос.УстановитьПараметр("ВремяСобытия", ПараметрыНапоминания.ВремяСобытия);
	Запрос.УстановитьПараметр("Источник", ПараметрыНапоминания.Источник);
	
	Запрос.Текст = ТекстЗапроса;
	РезультатЗапроса = Запрос.Выполнить().Выгрузить();
	Напоминание = Неопределено;
	Если РезультатЗапроса.Количество() > 0 Тогда
		Напоминание = РезультатЗапроса[0];
	КонецЕсли;
	
	// Удаляем существующую запись.
	НаборЗаписей = РегистрыСведений.НапоминанияПользователя.СоздатьНаборЗаписей();
	НаборЗаписей.Отбор.Пользователь.Установить(ПараметрыНапоминания.Пользователь);
	НаборЗаписей.Отбор.Источник.Установить(ПараметрыНапоминания.Источник);
	НаборЗаписей.Отбор.ВремяСобытия.Установить(ПараметрыНапоминания.ВремяСобытия);
	
	НаборЗаписей.Очистить();
	НаборЗаписей.Записать();
	
	СледующаяДатаПоРасписанию = Неопределено;
	ОпределенаСледующаяДатаПоРасписанию = Ложь;
	
	// Подключаем следующее напоминание по расписанию.
	Если ПодключатьПоРасписанию И Напоминание <> Неопределено Тогда
		Если Напоминание.СпособУстановкиВремениНапоминания = ПредопределенноеЗначение("Перечисление.СпособыУстановкиВремениНапоминания.Периодически") Тогда
			Расписание = Напоминание.Расписание.Получить();
			Если Расписание.ПериодПовтораДней > 0 Тогда
				СледующаяДатаПоРасписанию = ПолучитьБлижайшуюДатуСобытияПоРасписанию(Расписание);
			КонецЕсли;
			ОпределенаСледующаяДатаПоРасписанию = СледующаяДатаПоРасписанию <> Неопределено;
		КонецЕсли;
		
		Если ОпределенаСледующаяДатаПоРасписанию Тогда
			Напоминание.ВремяСобытия = СледующаяДатаПоРасписанию;
			Напоминание.СрокНапоминания = Напоминание.ВремяСобытия;
			ПодключитьНапоминание(Напоминание);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

// Создает новое напоминание на указанное время.
Функция ПодключитьНапоминаниеВУказанноеВремя(Текст, Время, Предмет = Неопределено) Экспорт
	ПараметрыНапоминания = Новый Структура;
	ПараметрыНапоминания.Вставить("Описание", Текст);
	ПараметрыНапоминания.Вставить("ВремяСобытия", Время);
	ПараметрыНапоминания.Вставить("Источник", Предмет);
	
	Напоминание = СоздатьНапоминание(ПараметрыНапоминания);
	ПодключитьНапоминание(Напоминание);
	
	Возврат Напоминание;
КонецФункции

// Создает новое напоминание на время, рассчитанное относительно времени в предмете.
Функция ПодключитьНапоминаниеДоВремениПредмета(Текст, Интервал, Предмет, ИмяРеквизита) Экспорт
	ПараметрыНапоминания = Новый Структура;
	ПараметрыНапоминания.Вставить("Описание", Текст);
	ПараметрыНапоминания.Вставить("Источник", Предмет);
	ПараметрыНапоминания.Вставить("ИмяРеквизитаИсточника", ИмяРеквизита);
	ПараметрыНапоминания.Вставить("ИнтервалВремениНапоминания", Интервал);
	
	Напоминание = СоздатьНапоминание(ПараметрыНапоминания);
	ПодключитьНапоминание(Напоминание);
	
	Возврат Напоминание;
КонецФункции

// Возвращает структуру нового напоминания для последующего подключения.
Функция СоздатьНапоминание(ПараметрыНапоминания)
	
	Напоминание = НапоминанияПользователяКлиентСервер.ПолучитьСтруктуруНапоминания(ПараметрыНапоминания, Истина);
	
	Если Не ЗначениеЗаполнено(Напоминание.Пользователь) Тогда
		Напоминание.Пользователь = ПользователиКлиентСервер.ТекущийПользователь();
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(Напоминание.СпособУстановкиВремениНапоминания) Тогда
		Если ЗначениеЗаполнено(Напоминание.Источник) И Не ПустаяСтрока(Напоминание.ИмяРеквизитаИсточника) Тогда
			Напоминание.СпособУстановкиВремениНапоминания = Перечисления.СпособыУстановкиВремениНапоминания.ОтносительноВремениПредмета;
		Иначе
			Напоминание.СпособУстановкиВремениНапоминания = Перечисления.СпособыУстановкиВремениНапоминания.ВУказанноеВремя;
		КонецЕсли;
	КонецЕсли;
	
	Если Напоминание.СпособУстановкиВремениНапоминания = Перечисления.СпособыУстановкиВремениНапоминания.ОтносительноВремениПредмета Тогда
		Напоминание.ВремяСобытия = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Напоминание.Источник, Напоминание.ИмяРеквизитаИсточника);
		Напоминание.СрокНапоминания = Напоминание.ВремяСобытия - ?(ЗначениеЗаполнено(Напоминание.ВремяСобытия), Напоминание.ИнтервалВремениНапоминания, 0);
	ИначеЕсли Напоминание.СпособУстановкиВремениНапоминания = Перечисления.СпособыУстановкиВремениНапоминания.ОтносительноТекущегоВремени Тогда
		Напоминание.СпособУстановкиВремениНапоминания = Перечисления.СпособыУстановкиВремениНапоминания.ВУказанноеВремя;
		Напоминание.ВремяСобытия = ТекущаяДатаСеанса() + Напоминание.ИнтервалВремениНапоминания;
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(Напоминание.СрокНапоминания) Тогда
		Напоминание.СрокНапоминания = Напоминание.ВремяСобытия;
	КонецЕсли;
	
	Возврат Напоминание;
	
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// Обработчики служебных событий подсистем БСП.

// Заполняет структуру параметров, необходимых для работы клиентского кода
// при запуске конфигурации. 
//
// Параметры:
//   Параметры - Структура - структура параметров запуска.
//
Процедура ПриДобавленииПараметровРаботыКлиентаПриЗапуске(Параметры) Экспорт
	
	Параметры.Вставить("НастройкиНапоминаний", 
		Новый ФиксированнаяСтруктура("ИспользоватьНапоминания", ПолучитьНастройкиНапоминаний().ИспользоватьНапоминания));
		
КонецПроцедуры 

// Заполняет структуру параметров, необходимых для работы клиентского кода
// конфигурации.
//
// Параметры:
//   Параметры   - Структура - структура параметров.
//
Процедура ПриДобавленииПараметровРаботыКлиента(Параметры) Экспорт
	
	Параметры.Вставить("НастройкиНапоминаний", 
		Новый ФиксированнаяСтруктура(ПолучитьНастройкиНапоминаний()));
	
КонецПроцедуры

#КонецОбласти
