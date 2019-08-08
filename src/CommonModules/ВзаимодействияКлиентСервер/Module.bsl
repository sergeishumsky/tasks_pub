
////////////////////////////////////////////////////////////////////////////////
// Подсистема "Взаимодействия"
// 
////////////////////////////////////////////////////////////////////////////////

#Область СлужебныеПроцедурыИФункции

////////////////////////////////////////////////////////////////////////////////
// Определение типа ссылки

// Определяет, является ли переданная в функцию ссылка контактом.
//
// Параметры:
//  ОбъектСсылка  - Ссылка - для которой выполняется проверка.
//
// Возвращаемое значение:
//   Булево  - истина, если является контактом, ложь в обратном случае.
//
Функция ЯвляетсяКонтактом(ОбъектСсылка) Экспорт
	
	ОписаниеТиповВозможныхКонтактов =  Новый ОписаниеТипов(ПолучитьМассивВозможныхТиповКонтактов());
	
	Возврат ОписаниеТиповВозможныхКонтактов.СодержитТип(ТипЗнч(ОбъектСсылка));
	
КонецФункции

// Определяет, является ли переданная в функцию ссылка взаимодействием.
//
// Параметры:
//  ОбъектСсылка  - Ссылка - для которой необходимо выполняется проверка.
//
// Возвращаемое значение:
//   Булево   - истина, если переданная ссылка является взаимодействием.
//
Функция ЯвляетсяВзаимодействием(ОбъектСсылка) Экспорт
	
	Возврат ТипЗнч(ОбъектСсылка) = Тип("ДокументСсылка.Встреча")
	ИЛИ ТипЗнч(ОбъектСсылка) = Тип("ДокументСсылка.ЗапланированноеВзаимодействие")
	ИЛИ ТипЗнч(ОбъектСсылка) = Тип("ДокументСсылка.ТелефонныйЗвонок")
	ИЛИ ТипЗнч(ОбъектСсылка) = Тип("ДокументСсылка.ЭлектронноеПисьмоВходящее")
	ИЛИ ТипЗнч(ОбъектСсылка) = Тип("ДокументСсылка.ЭлектронноеПисьмоИсходящее")
	ИЛИ ТипЗнч(ОбъектСсылка) = Тип("ДокументСсылка.СообщениеSMS");
	
КонецФункции

// Определяет, является ли переданная в функцию ссылка присоединенным файлом взаимодействий.
//
// Параметры:
//  ОбъектСсылка  - Ссылка - для которой необходимо выполняется проверка.
//
// Возвращаемое значение:
//   Булево   - истина, если переданная ссылка является присоединенным файлом взаимодействий.
//
Функция ЯвляетсяПрисоединеннымФайломВзаимодействий(ОбъектСсылка) Экспорт
	
	Возврат ТипЗнч(ОбъектСсылка) = Тип("СправочникСсылка.ВстречаПрисоединенныеФайлы")
		ИЛИ ТипЗнч(ОбъектСсылка) = Тип("СправочникСсылка.ЗапланированноеВзаимодействиеПрисоединенныеФайлы")
		ИЛИ ТипЗнч(ОбъектСсылка) = Тип("СправочникСсылка.ТелефонныйЗвонокПрисоединенныеФайлы")
		ИЛИ ТипЗнч(ОбъектСсылка) = Тип("СправочникСсылка.ЭлектронноеПисьмоВходящееПрисоединенныеФайлы")
		ИЛИ ТипЗнч(ОбъектСсылка) = Тип("СправочникСсылка.ЭлектронноеПисьмоИсходящееПрисоединенныеФайлы")
		ИЛИ ТипЗнч(ОбъектСсылка) = Тип("СправочникСсылка.СообщениеSMSПрисоединенныеФайлы");
	
КонецФункции

// Определяет, является ли переданная в функцию ссылка взаимодействием.
//
// Параметры:
//  ОбъектСсылка  - Ссылка - для которой необходимо выполняется проверка.
//
// Возвращаемое значение:
//   Булево   - истина, если переданная ссылка является взаимодействием.
//
Функция ЯвляетсяЭлектроннымПисьмом(ОбъектСсылка) Экспорт
	
	Возврат ТипЗнч(ОбъектСсылка) = Тип("ДокументСсылка.ЭлектронноеПисьмоВходящее")
		ИЛИ ТипЗнч(ОбъектСсылка) = Тип("ДокументСсылка.ЭлектронноеПисьмоИсходящее");
	
КонецФункции

// Проверяет, является ли переданная ссылка предметом взаимодействий.
//
// Параметры:
//  ОбъектСсылка - Ссылка - ссылка, для которой выполняется проверка,
//                          является ли она ссылкой на предмет взаимодействий.
//
// Возвращаемое значение:
//   Булево   - Истина если является, Ложь в обратном случае.
//
Функция ЯвляетсяПредметом(ОбъектСсылка) Экспорт
	
	МассивТиповПредметов = ВзаимодействияКлиентСерверПовтИспПереопределяемый.ПолучитьМассивТиповПредметов();
	
	Для каждого ЭлементМассива Из МассивТиповПредметов Цикл
		
		Если ТипЗнч(ОбъектСсылка) = Тип(ЭлементМассива) Тогда
			
			Возврат Истина;
			
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат Ложь;
	
КонецФункции 

////////////////////////////////////////////////////////////////////////////////
// Прочее

// Устанавливает состояние "Исходящее" для документа сообщение SMS и всех входящих в него сообщений.
//
// Параметры:
//  Объект       - Документ.СообщениеSMS - документ, для которого устанавливается состояние.
//
Процедура УстановитьСостояниеИсходящееДокументСообщениеSMS(Объект) Экспорт
	
	Для каждого Адресат Из Объект.Адресаты Цикл
		
		Адресат.СостояниеСообщения = ПредопределенноеЗначение("Перечисление.СостоянияСообщенияSMS.Исходящее");
		
	КонецЦикла;
	
	Объект.Состояние = ПредопределенноеЗначение("Перечисление.СостоянияДокументаСообщениеSMS.Исходящее");
	
КонецПроцедуры

// Определяет, корректно ли введен номер телефона для сообщения SMS.
//
// Параметры:
//  СтруктураПолей  - Структура - структура описывающая контактную информацию типа Телефон или МобильныйТелефон.
//
// Возвращаемое значение:
//   Булево   - Истина, если номер введен правильно, Ложь в обратном случае.
//
Функция КорректноВведенНомерТелефона(СтруктураПолей) Экспорт
	
	Если НЕ ПустаяСтрока(СтруктураПолей.КодСтраны) Тогда
		КодСтраны = СокрЛП(КодСтраны);
		Если СтрНачинаетсяС(КодСтраны, "+") Тогда
			КодСтраны = Прав(КодСтраны, СтрДлина(СтруктураПолей.КодСтраны)-1);
		КонецЕсли;
		Если НЕ СтроковыеФункцииКлиентСервер.ТолькоЦифрыВСтроке(КодСтраны) Тогда
			Возврат Ложь;
		КонецЕсли;
	Иначе
		Возврат Ложь;
	КонецЕсли;
	
	Если НЕ ПустаяСтрока(СтруктураПолей.КодГорода) Тогда
		Если НЕ СтроковыеФункцииКлиентСервер.ТолькоЦифрыВСтроке(СтруктураПолей.КодГорода) Тогда
			Возврат Ложь;
		КонецЕсли;
	Иначе
		Возврат Ложь;
	КонецЕсли;
	
	Если НЕ ПустаяСтрока(СтруктураПолей.НомерТелефона) Тогда
		Если НЕ СтроковыеФункцииКлиентСервер.ТолькоЦифрыВСтроке(СтруктураПолей.НомерТелефона) Тогда
			Возврат Ложь;
		КонецЕсли;
	Иначе
		Возврат Ложь;
	КонецЕсли;
	
	Если СтрДлина(СтруктураПолей.КодГорода) + СтрДлина(СтруктураПолей.НомерТелефона) <> 10 Тогда
		 Возврат Ложь;
	КонецЕсли;
	
	Возврат Истина;
	
КонецФункции

// Формирует структуру полей контактной информации типа Телефон или МобильныйТелефон по представлению телефона.
//
// Параметры:
//  Представление  - Строка - строковая информация с номером телефона.
//
// Возвращаемое значение:
//   Структура   - сформированная структура.
//
Функция СтруктураПолейПоПредставлениюТелефона(Представление) Экспорт
	
	текСтр = СокрЛП(Представление);
	
	// Вырежем добавочный номер с комментарием.
	ПозДоб = СтрНайти(ВРЕГ(текСтр), "ДОБ.");
	Если ПозДоб <> 0 Тогда
		ДобавочныйСКомментарием = СокрЛП(Сред(текСтр, ПозДоб+4));
		
		текСтр = СокрЛП(Лев(текСтр, ПозДоб-1));
		
		Если СтрЗаканчиваетсяНа(текСтр, ",") Тогда
			текСтр = Лев(текСтр, СтрДлина(текСтр)-1);
		КонецЕсли;
		
		ПозДоб = СтрНайти(ВРЕГ(ДобавочныйСКомментарием), ", ");
		
		Если ПозДоб <> 0 Тогда
			Добавочный = СокрЛП(Лев(ДобавочныйСКомментарием, ПозДоб-1));
			Комментарий = СокрЛП(Сред(ДобавочныйСКомментарием, ПозДоб+2));
		Иначе
			Добавочный = ДобавочныйСКомментарием;
		КонецЕсли;
		
	КонецЕсли;
	
	// вырежем код города
	Поз = СтрНайти(текСтр, "(");
	Если Поз <> 0 Тогда
		КодСтраны = СокрЛП(Лев(текСтр, Поз-1));
		
		текСтр = СокрЛП(Сред(текСтр, Поз+1));
		Поз = СтрНайти(текСтр, ")");
		
		Если Поз <> 0 Тогда
			КодГорода = СокрЛП(Лев(текСтр, Поз-1));
			текСтр = СокрЛП(Сред(текСтр, Поз+1));
		КонецЕсли;
	КонецЕсли;
	
	Поз = СтрНайти(текСтр, ", ");
	// Если добавочного номера нет - ориентируемся по номеру телефона и комментарию.
	Если ПозДоб = 0 И Поз <> 0 Тогда
		// вырежем комментарий
		НомерТелефона = СокрЛП(Лев(текСтр, Поз-1));
		Комментарий = СокрЛП(Сред(текСтр, Поз+2));
	Иначе
		// все оставшееся это номер
		НомерТелефона = текСтр;
	КонецЕсли;
	
	Результат = Новый Структура;
	Результат.Вставить("КодСтраны", КодСтраны);
	Результат.Вставить("КодГорода", КодГорода);
	Результат.Вставить("НомерТелефона", НомерТелефона);
	Результат.Вставить("Добавочный", Добавочный);
	Результат.Вставить("Комментарий", Комментарий);
	
	Возврат Результат;
	
КонецФункции

// Формирует тему по тексту сообщения на основании первых трех слов.
//
// Параметры:
//  ТекстСообщения  - Строка - текст сообщения, на основании которого формируется тема.
//
// Возвращаемое значение:
//   Строка   - сформированная тема сообщения.
//
Функция ТемаПоТекстуСообщения(ТекстСообщения) Экспорт

	МассивСтрок = СтрРазделить(ТекстСообщения," ", Ложь);
	Тема = "";
	Для Инд = 0 По МассивСтрок.Количество() - 1 Цикл
		Если Инд > 2 Тогда
			Прервать;
		КонецЕсли;
		Тема = Тема + МассивСтрок[Инд] + " ";
	КонецЦикла;
	
	Возврат Лев(Тема, СтрДлина(Тема) - 1);

КонецФункции

// Формирует информационную строку о количестве сообщений и оставшихся символах.
//
// Параметры:
//  ОтправлятьВТранслите  - Булево - признак, того что сообщение при отправке будет автоматически 
//                                   преобразовано в латинские символы.
//  ТекстСообщения  - Строка       - текст сообщения, для которого формируется сообщение.
//
// Возвращаемое значение:
//   Строка   - сформированное информационное сообщение.
//
Функция СформироватьИнформационнуюНадписьКоличествоСимволовСообщений(ОтправлятьВТранслите, ТекстСообщения) Экспорт

	СимволовВСообщении = ?(ОтправлятьВТранслите, 140, 50);
	ЧислоСимволов = СтрДлина(ТекстСообщения);
	КоличествоСообщений   = Цел(ЧислоСимволов / СимволовВСообщении) + 1;
	ОсталосьСимволов      = СимволовВСообщении - ЧислоСимволов % СимволовВСообщении;
	ШаблонТекстаСообщения = НСтр("ru = 'Сообщение - %1, осталось символов - %2'");
	Возврат СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ШаблонТекстаСообщения, КоличествоСообщений, ОсталосьСимволов);

КонецФункции

// Функция возвращает таблицу имен кодировок.
//
// Параметры:
//  НЕТ
//
// Возвращаемое значение:
//  Таблица значений
//
Функция ПолучитьСписокКодировок() Экспорт
	
	СписокКодировок = Новый СписокЗначений;
	
	СписокКодировок.Добавить("ibm852",       НСтр("ru = 'ibm852 (Центральноевропейская DOS)'"));
	СписокКодировок.Добавить("ibm866",       НСтр("ru = 'ibm866 (Кириллица DOS)'"));
	СписокКодировок.Добавить("iso-8859-1",   НСтр("ru = 'iso-8859-1 (Западноевропейская ISO)'"));
	СписокКодировок.Добавить("iso-8859-2",   НСтр("ru = 'iso-8859-2 (Центральноевропейская ISO)'"));
	СписокКодировок.Добавить("iso-8859-3",   НСтр("ru = 'iso-8859-3 (Латиница 3 ISO)'"));
	СписокКодировок.Добавить("iso-8859-4",   НСтр("ru = 'iso-8859-4 (Балтийская ISO)'"));
	СписокКодировок.Добавить("iso-8859-5",   НСтр("ru = 'iso-8859-5 (Кириллица ISO)'"));
	СписокКодировок.Добавить("iso-8859-7",   НСтр("ru = 'iso-8859-7 (Греческая ISO)'"));
	СписокКодировок.Добавить("iso-8859-9",   НСтр("ru = 'iso-8859-9 (Турецкая ISO)'"));
	СписокКодировок.Добавить("iso-8859-15",  НСтр("ru = 'iso-8859-15 (Латиница 9 ISO)'"));
	СписокКодировок.Добавить("koi8-r",       НСтр("ru = 'koi8-r (Кириллица KOI8-R)'"));
	СписокКодировок.Добавить("koi8-u",       НСтр("ru = 'koi8-u (Кириллица KOI8-U)'"));
	СписокКодировок.Добавить("us-ascii",     НСтр("ru = 'us-ascii США'"));
	СписокКодировок.Добавить("utf-8",        НСтр("ru = 'utf-8 (Юникод UTF-8)'"));
	СписокКодировок.Добавить("windows-1250", НСтр("ru = 'windows-1250 (Центральноевропейская Windows)'"));
	СписокКодировок.Добавить("windows-1251", НСтр("ru = 'windows-1251 (Кириллица Windows)'"));
	СписокКодировок.Добавить("windows-1252", НСтр("ru = 'windows-1252 (Западноевропейская Windows)'"));
	СписокКодировок.Добавить("windows-1253", НСтр("ru = 'windows-1253 (Греческая Windows)'"));
	СписокКодировок.Добавить("windows-1254", НСтр("ru = 'windows-1254 (Турецкая Windows)'"));
	СписокКодировок.Добавить("windows-1257", НСтр("ru = 'windows-1257 (Балтийская Windows)'"));
	
	Возврат СписокКодировок;

КонецФункции

// Получает расширение для переданного имени файла.
//
// Параметры:
//  ИмяФайла  - Строка - имя файла, для которого необходимо получить расширение.
//
// Возвращаемое значение:
//   Строка   - расширение, полученное из переданного имени файла.
//
Функция ПолучитьРасширениеФайла(Знач ИмяФайла) Экспорт
	
	РасширениеФайла = "";
	МассивСтрок = СтрРазделить(ИмяФайла, ".", Ложь);
	Если МассивСтрок.Количество() > 1 Тогда
		РасширениеФайла = МассивСтрок[МассивСтрок.Количество() - 1];
	КонецЕсли;
	
	Возврат РасширениеФайла;
	
КонецФункции

// Получает каталог и имя файла для переданного полного имени файла.
//
// Параметры:
//  ПолноеИмяФайла  - Строка - полное имя файла, из которого будут получены имя каталога и имя файла.
//  ИмяКаталога     - Строка - в данную переменную будет помещено полученное имя каталога.
//  ИмяФайла        - Строка - в данную переменную будет помещено полученное имя файла.
//
Процедура ПолучитьКаталогИИмяФайла(Знач ПолноеИмяФайла, ИмяКаталога, ИмяФайла) Экспорт
	
	ИмяФайла = ПолноеИмяФайла;
	ИмяКаталога = "";
	
	Пока Истина Цикл
		
		Позиция = Макс(СтрНайти(ИмяФайла, "\"), СтрНайти(ИмяФайла, "/"));
		Если Позиция = 0 Тогда
			Возврат;
		КонецЕсли;
		
		ИмяКаталога = ИмяКаталога + Лев(ИмяФайла, Позиция);
		ИмяФайла = Сред(ИмяФайла, Позиция+1);
		
	КонецЦикла;
	
КонецПроцедуры

// Получает массив описания возможных контактов и формирует из него массив типов.
//
// Возвращаемое значение:
//   Массив   - содержит возможные типы контактов.
//
Функция ПолучитьМассивВозможныхТиповКонтактов() Экспорт
	
	МассивОписанияВозможныхКонтактов = ПолучитьМассивОписанияВозможныхКонтактов();
	
	МассивВозможныхТиповКонтактов = Новый Массив;
	
	Для каждого ЭлементМассиваОписания Из МассивОписанияВозможныхКонтактов Цикл
		
		МассивВозможныхТиповКонтактов.Добавить(ЭлементМассиваОписания.Тип);
		
	КонецЦикла;
	
	Возврат МассивВозможныхТиповКонтактов;
	
КонецФункции

// Добавляет элемент в массив структур контакта.
//
// Параметры:
//  МассивОписания                     - Массив - массив, в который будут добавлена структура описания контакта.
//  Тип                                - Тип    - тип ссылки контакта.
//  ВозможностьИнтерактивногоСоздания  - Булево - признак возможности интерактивного создания контакта из документов -
//                                                взаимодействий.
//  Имя                                 - Строка - имя типа контакта , как оно определено в метаданных.
//  Представление                       - Строка - представление типа контакта для отображения пользователю.
//  Иерархический                       - Булево - признак того, является ли справочник иерархическим.
//  ЕстьВладелец                        - Булево - признак того, что у контакта есть владелец.
//  ИмяВладельца                        - Строка - имя владельца контакта, как оно определено в метаданных.
//  ИскатьПоДомену                      - Булево - признак того, что по данному типу контакта будет осуществляться
//                                                 поиск по домену.
//  Связь                               - Строка - описывает возможную связь данного контакта с другим контактом, в
//                                                 случае когда текущий контакт является реквизитом другого контакта.
//                                                 Описывается следующей строкой "ИмяТаблицы.ИмяРеквизита".
//  ИмяРеквизитаПредставлениеКонтакта   - Строка - имя реквизита контакта, из которого будет получено представление контакта.
//
Процедура ДобавитьЭлементМассиваОписанияВозможныхТиповКонтактов(
	МассивОписания,
	Тип,
	ВозможностьИнтерактивногоСоздания,
	Имя,
	Представление,
	Иерархический,
	ЕстьВладелец,
	ИмяВладельца,
	ИскатьПоДомену,
	Связь,
	ИмяРеквизитаПредставлениеКонтакта = "Наименование") Экспорт
	
	СтруктураОписания = Новый Структура;
	СтруктураОписания.Вставить("Тип",                               Тип);
	СтруктураОписания.Вставить("ВозможностьИнтерактивногоСоздания", ВозможностьИнтерактивногоСоздания);
	СтруктураОписания.Вставить("Имя",                               Имя);
	СтруктураОписания.Вставить("Представление",                     Представление);
	СтруктураОписания.Вставить("Иерархический",                     Иерархический);
	СтруктураОписания.Вставить("ЕстьВладелец",                      ЕстьВладелец);
	СтруктураОписания.Вставить("ИмяВладельца",                      ИмяВладельца);
	СтруктураОписания.Вставить("ИскатьПоДомену",                    ИскатьПоДомену);
	СтруктураОписания.Вставить("Связь",                             Связь);
	СтруктураОписания.Вставить("ИмяРеквизитаПредставлениеКонтакта", ИмяРеквизитаПредставлениеКонтакта);

	
	МассивОписания.Добавить(СтруктураОписания);
	
КонецПроцедуры

// Возвращает описания возможных типов контактов.
// Используется, если в конфигурации определен хотя бы один тип контактов взаимодействий,
// помимо справочника Пользователи.
//
// Возвращаемое значение:
//   Массив   - массив структур, в котором описываются возможные типы контактов.
//              Каждая структура содержит описание одного типа контактов.   
//              Описание полей структуры см. в комментарии к функции.
//              ДобавитьЭлементМассиваОписанияВозможныхТиповКонтактов общего модуля.
//              ВзаимодействияКлиентСервер.
//
Функция ПолучитьМассивОписанияВозможныхКонтактов() Экспорт

	МассивВозможныеКонтакты = Новый Массив();
	ДобавитьЭлементМассиваОписанияВозможныхТиповКонтактов(МассивВозможныеКонтакты,
		Тип("СправочникСсылка.Пользователи"),Ложь,"Пользователи","Пользователи",Ложь,Ложь,"",Ложь,"");
		
	//+ #103 Дзеса Ігор
	ДобавитьЭлементМассиваОписанияВозможныхТиповКонтактов(МассивВозможныеКонтакты,
		Тип("СправочникСсылка.узКонтрагенты"),Ложь,"узКонтрагенты","Контрагенты",Ложь,Ложь,"",Ложь,"");
	//- #103 Дзеса Ігор
	ВзаимодействияКлиентСерверПовтИспПереопределяемый.ДополнитьМассивОписанияВозможныхКонтактов(МассивВозможныеКонтакты);
	
	Возврат МассивВозможныеКонтакты;

КонецФункции

// Проверяет заполнение контактов в документе взаимодействий и обновляет форму документа взаимодействий//
// Параметры:
//  Объект - ДокументОбъект - документ взаимодействий, для которой выполняется проверка.
//  Форма - УправляемаяФорма - форма документа взаимодействий.
//  ВидДокумента - Строка - строковое имя документа взаимодействий.
//
Процедура ПроверитьЗаполнениеКонтактов(Объект,Форма,ВидДокумента) Экспорт
	
	КонтактыЗаполнены = КонтактыЗаполнены(Объект,ВидДокумента);
	
	Если КонтактыЗаполнены Тогда
		Форма.Элементы.СтраницыУказаныКонтакты.ТекущаяСтраница = Форма.Элементы.СтраницаКонтактыЗаполнены;
	Иначе
		Форма.Элементы.СтраницыУказаныКонтакты.ТекущаяСтраница = Форма.Элементы.СтраницаКонтактыНеЗаполнены;
	КонецЕсли;
	
КонецПроцедуры

// Получает строковое представление размера файла.
//
// Параметры:
//  РазмерВБайтах - Число - размер в байтах вложенного файла электронного письма.
//
// Возвращаемое значение:
//   Строка   - строковое представление размера вложенного файла электронного письма.
//
Функция ПолучитьСтроковоеПредставлениеРазмераФайла(РазмерВБайтах) Экспорт
	
	РазмерМб = РазмерВБайтах / (1024*1024);
	Если РазмерМб > 1 Тогда
		СтрокаРазмер = Формат(РазмерМб,"ЧДЦ=1") + " " + НСтр("ru = 'Мб'");
	Иначе
		СтрокаРазмер = Формат(РазмерВБайтах /1024,"ЧДЦ=0; ЧН=0") + " " + НСтр("ru = 'Кб'");
	КонецЕсли;
	
	Возврат СтрокаРазмер;
	
КонецФункции

// Обрабатывает изменение быстрого отбора динамического списка документов взаимодействий.
//
// Параметры:
//  Форма - УправляемаяФорма - форма, для которой выполняется действий.
//  ИмяОтбора - Строка - имя изменяемого отбора.
//  ОтборПоПредмету - Булево - признак того, что форма списка параметрическая и на нее наложен отбор по предмету.
//
Процедура БыстрыйОтборСписокПриИзменении(Форма, ИмяОтбора, ОтборПоПредмету = Истина) Экспорт
	
	Отбор = ОтборДинамическогоСписка(Форма.Список);
	
	Если ИмяОтбора = "Статус" Тогда
		
		// очистить связанные отборы
		ОбщегоНазначенияКлиентСервер.УдалитьЭлементыГруппыОтбора(Отбор, "РассмотретьПосле");
		ОбщегоНазначенияКлиентСервер.УдалитьЭлементыГруппыОтбора(Отбор, "Рассмотрено");
		Если НЕ ОтборПоПредмету Тогда
			ОбщегоНазначенияКлиентСервер.УдалитьЭлементыГруппыОтбора(Отбор, "Предмет");
		КонецЕсли;
		
		// Установить отборы для режима.
		Если Форма[ИмяОтбора] = "КРассмотрению" Тогда
			
			#Если Сервер Или ВнешнееСоединение Тогда
				ДатаДляОтбора = ТекущаяДатаСеанса();
			#Иначе
				ДатаДляОтбора = ОбщегоНазначенияКлиент.ДатаСеанса();
			#КонецЕсли
			ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(Отбор, "Рассмотрено", Ложь,,, Истина);
			ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(
				Отбор, "РассмотретьПосле", ДатаДляОтбора, ВидСравненияКомпоновкиДанных.МеньшеИлиРавно,, Истина);
			
		ИначеЕсли Форма[ИмяОтбора] = "Отложенные" Тогда
			ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(Отбор, "Рассмотрено", Ложь,,, Истина);
			ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(
			Отбор, "РассмотретьПосле", , ВидСравненияКомпоновкиДанных.Заполнено,, Истина);
		ИначеЕсли Форма[ИмяОтбора] = "Рассмотренные" Тогда
			ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(Отбор, "Рассмотрено", Истина,,, Истина);
		КонецЕсли;
		
	Иначе
		
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(
			Отбор,ИмяОтбора,Форма[ИмяОтбора],,, ЗначениеЗаполнено(Форма[ИмяОтбора]));
		
	КонецЕсли;
	
КонецПроцедуры

// Обрабатывает изменение быстрого отбора по типу взаимодействий динамического списка документов взаимодействий.
//
// Параметры:
//  Форма - УправляемаяФорма - Содержит динамический список, в котором расположен изменяемый отбор.
//  ТипВзаимодействия - Строка - имя накладываемого отбора.
//
Процедура ПриИзмененииОтбораТипВзаимодействий(Форма,ТипВзаимодействия) Экспорт
	
	Отбор = ОтборДинамическогоСписка(Форма.Список);
	
	// очистить связанные отборы
	ГруппаОтбора = ОбщегоНазначенияКлиентСервер.СоздатьГруппуЭлементовОтбора(
		Отбор.Элементы,"Отбор по типу взаимодействий",ТипГруппыЭлементовОтбораКомпоновкиДанных.ГруппаИ);
	
	// установить отборы для типа
	Если ТипВзаимодействия = "ВсеПисьма" Тогда
		
		СписокТипыПисьма = Новый СписокЗначений;
		СписокТипыПисьма.Добавить(Тип("ДокументСсылка.ЭлектронноеПисьмоВходящее"));
		СписокТипыПисьма.Добавить(Тип("ДокументСсылка.ЭлектронноеПисьмоИсходящее"));
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(
			ГруппаОтбора, "Тип", СписокТипыПисьма, ВидСравненияКомпоновкиДанных.ВСписке,, Истина);
		
	ИначеЕсли ТипВзаимодействия = "ВходящиеПисьма" Тогда
		
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(ГруппаОтбора,
			"Тип", Тип("ДокументСсылка.ЭлектронноеПисьмоВходящее"), ВидСравненияКомпоновкиДанных.Равно,, Истина);
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(ГруппаОтбора,
			"ПометкаУдаления", Ложь, ВидСравненияКомпоновкиДанных.Равно, , Истина);
		
	ИначеЕсли ТипВзаимодействия = "ПисьмаЧерновики" Тогда
		
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(ГруппаОтбора,
			"Тип", Тип("ДокументСсылка.ЭлектронноеПисьмоИсходящее"), ВидСравненияКомпоновкиДанных.Равно, , Истина);
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(
			ГруппаОтбора, "ПометкаУдаления", Ложь, ВидСравненияКомпоновкиДанных.Равно, , Истина);
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(ГруппаОтбора,
			"СтатусИсходящегоПисьма", ПредопределенноеЗначение("Перечисление.СтатусыИсходящегоЭлектронногоПисьма.Черновик"),
			ВидСравненияКомпоновкиДанных.Равно,, Истина);
		
	ИначеЕсли ТипВзаимодействия = "ИсходящиеПисьма" Тогда
		
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(ГруппаОтбора,
		"Тип", Тип("ДокументСсылка.ЭлектронноеПисьмоИсходящее"),ВидСравненияКомпоновкиДанных.Равно,, Истина);
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(ГруппаОтбора,
			"ПометкаУдаления", Ложь,ВидСравненияКомпоновкиДанных.Равно,, Истина);
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(ГруппаОтбора,
			"СтатусИсходящегоПисьма", ПредопределенноеЗначение("Перечисление.СтатусыИсходящегоЭлектронногоПисьма.Исходящее"),ВидСравненияКомпоновкиДанных.Равно,, Истина);
		
	ИначеЕсли ТипВзаимодействия = "Отправленные" Тогда
		
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(ГруппаОтбора,
			"Тип", Тип("ДокументСсылка.ЭлектронноеПисьмоИсходящее"),ВидСравненияКомпоновкиДанных.Равно,, Истина);
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(ГруппаОтбора,
			"ПометкаУдаления", Ложь,ВидСравненияКомпоновкиДанных.Равно,, Истина);
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(ГруппаОтбора,
			"СтатусИсходящегоПисьма", ПредопределенноеЗначение("Перечисление.СтатусыИсходящегоЭлектронногоПисьма.Отправлено"),
			ВидСравненияКомпоновкиДанных.Равно,, Истина);
		
	ИначеЕсли ТипВзаимодействия = "УдаленныеПисьма" Тогда
		
		СписокТипыПисьма = Новый СписокЗначений;
		СписокТипыПисьма.Добавить(Тип("ДокументСсылка.ЭлектронноеПисьмоВходящее"));
		СписокТипыПисьма.Добавить(Тип("ДокументСсылка.ЭлектронноеПисьмоИсходящее"));
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(ГруппаОтбора,
			"Тип", СписокТипыПисьма, ВидСравненияКомпоновкиДанных.ВСписке,, Истина);
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(ГруппаОтбора,
			"ПометкаУдаления", Истина,ВидСравненияКомпоновкиДанных.Равно,, Истина);
		
	ИначеЕсли ТипВзаимодействия = "Встречи" Тогда
		
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(ГруппаОтбора, 
			"Тип", Тип("ДокументСсылка.Встреча"),ВидСравненияКомпоновкиДанных.Равно,, Истина);
		
	ИначеЕсли ТипВзаимодействия = "ЗапланированныеВзаимодействия" Тогда
		
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(ГруппаОтбора,
			"Тип", Тип("ДокументСсылка.ЗапланированноеВзаимодействие"),ВидСравненияКомпоновкиДанных.Равно,, Истина);
		
	ИначеЕсли ТипВзаимодействия = "ТелефонныеЗвонки" Тогда
		
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(ГруппаОтбора, 
			"Тип", Тип("ДокументСсылка.ТелефонныйЗвонок"),ВидСравненияКомпоновкиДанных.Равно,, Истина);
		
	ИначеЕсли ТипВзаимодействия = "ИсходящиеЗвонки" Тогда
		
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(ГруппаОтбора,
			"Тип", Тип("ДокументСсылка.ТелефонныйЗвонок"),ВидСравненияКомпоновкиДанных.Равно,, Истина);
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(ГруппаОтбора, 
			"Входящий",Ложь,ВидСравненияКомпоновкиДанных.Равно,, Истина);
		
	ИначеЕсли ТипВзаимодействия = "ВходящиеЗвонки" Тогда
		
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(ГруппаОтбора, 
			"Тип", Тип("ДокументСсылка.ТелефонныйЗвонок"),ВидСравненияКомпоновкиДанных.Равно,, Истина);
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(ГруппаОтбора,
			"Входящий", Истина, ВидСравненияКомпоновкиДанных.Равно,, Истина);
			
	ИначеЕсли ТипВзаимодействия = "СообщенияSMS" Тогда
		
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(ГруппаОтбора, 
			"Тип", Тип("ДокументСсылка.СообщениеSMS"),ВидСравненияКомпоновкиДанных.Равно,, Истина);
	Иначе
			
		Отбор.Элементы.Удалить(ГруппаОтбора);
		
	КонецЕсли;
	
КонецПроцедуры

// Формирует представление адресата электронной почты.
//
// Параметры:
//  Имя     - Строка - имя адресата.
//  Адрес   - Строка - адрес электронной почты адресата.
//  Контакт - СправочникСсылка - контакт, которому принадлежит имя и адрес почты.
//
// Возвращаемое значение:
//   Строка - сформированное представление адресата электронной почты.
//
Функция ПолучитьПредставлениеАдресата(Имя, Адрес, Контакт) Экспорт
	
	Результат = ?(Имя = Адрес ИЛИ Имя = "", Адрес,?(ПустаяСтрока(Адрес),Имя, ?(СтрНайти(Имя, Адрес) > 0, Имя, Имя + " <" + Адрес + ">")));
	Если ЗначениеЗаполнено(Контакт) И ТипЗнч(Контакт) <> Тип("Строка") Тогда
		Результат = Результат + " [" + ПолучитьПредставлениеКонтакта(Контакт) + "]";
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

// Формирует представление списка адресатов электронной почты для коллекции адресатов.
//
// Параметры:
//  ТаблицаАдресатов    - ТаблицаЗначений - таблица с данным адресатов.
//  ВключатьИмяКонтакта - Булево - признак необходимости включения в представление данных контакта.
//  Контакт             - СправочникСсылка - контакт, которому принадлежит имя и адрес почты.
//
// Возвращаемое значение:
//  Строка - сформированное представление списка адресатов электронной почты.
//
Функция ПолучитьПредставлениеСпискаАдресатов(ТаблицаАдресатов, ВключатьИмяКонтакта = Истина) Экспорт

	Представление = "";
	Для Каждого СтрокаТаблицы Из ТаблицаАдресатов Цикл
		Представление = Представление 
	              + ПолучитьПредставлениеАдресата(СтрокаТаблицы.Представление,
	                                              СтрокаТаблицы.Адрес, 
	                                             ?(ВключатьИмяКонтакта, СтрокаТаблицы.Контакт, "")) + "; ";
	КонецЦикла;

	Возврат Представление;

КонецФункции

// Проверяет заполнение контактов в документах взаимодействий.
//
// Параметры:
//  ВзаимодействиеОбъект    - ДокументОбъект - документ взаимодействий для которого выполняется проверка.
//  ВидДокумента - Строка - имя документа.
//
// Возвращаемое значение:
//  Булево - Истина если заполнены и Ложь в обратном случае.
//
Функция КонтактыЗаполнены(ВзаимодействиеОбъект,ВидДокумента)
	
	МассивТабличныхЧастей = Новый Массив;
	
	Если ВидДокумента = "ЭлектронноеПисьмоИсходящее" Тогда
		
		МассивТабличныхЧастей.Добавить("ПолучателиПисьма");
		МассивТабличныхЧастей.Добавить("ПолучателиКопий");
		МассивТабличныхЧастей.Добавить("ПолучателиОтвета");
		МассивТабличныхЧастей.Добавить("ПолучателиСкрытыхКопий");
		
	ИначеЕсли ВидДокумента = "ЭлектронноеПисьмоВходящее" Тогда
		
		Если НЕ ЗначениеЗаполнено(ВзаимодействиеОбъект.ОтправительКонтакт) Тогда
			Возврат Ложь;
		КонецЕсли;
		
		МассивТабличныхЧастей.Добавить("ПолучателиПисьма");
		МассивТабличныхЧастей.Добавить("ПолучателиКопий");
		МассивТабличныхЧастей.Добавить("ПолучателиОтвета");
		
	ИначеЕсли ВидДокумента = "Встреча" 
		ИЛИ ВидДокумента = "ЗапланированноеВзаимодействие" Тогда
				
		МассивТабличныхЧастей.Добавить("Участники");
		
	ИначеЕсли ВидДокумента = "СообщениеSMS" Тогда
		
		МассивТабличныхЧастей.Добавить("Адресаты");
		
	ИначеЕсли ВидДокумента = "ТелефонныйЗвонок" Тогда
		
		Если НЕ ЗначениеЗаполнено(ВзаимодействиеОбъект.АбонентКонтакт) Тогда
			Возврат Ложь;
		КонецЕсли;
		
	КонецЕсли;
	
	Для каждого ИмяТабличнойЧасти Из МассивТабличныхЧастей Цикл
		Для каждого СтрокаТабличнойЧасти Из ВзаимодействиеОбъект[ИмяТабличнойЧасти] Цикл
			
			Если НЕ ЗначениеЗаполнено(СтрокаТабличнойЧасти.Контакт) Тогда
				Возврат Ложь;
			КонецЕсли;
			
		КонецЦикла;
	КонецЦикла;
	
	Возврат Истина;
	
КонецФункции

// Устанавливает значение свойства для всех подчиненных элементов группы.
Процедура УстановитьСвойствоЭлементовГруппы(ГруппаЭлементов, ИмяСвойства, ЗначениеСвойства) Экспорт
	
	Для каждого ПодчиненныйЭлемент Из ГруппаЭлементов.ПодчиненныеЭлементы Цикл
		
		Если ТипЗнч(ПодчиненныйЭлемент) = Тип("ГруппаФормы") Тогда
			
			УстановитьСвойствоЭлементовГруппы(ПодчиненныйЭлемент, ИмяСвойства, ЗначениеСвойства);
			
		Иначе
			
			ПодчиненныйЭлемент[ИмяСвойства] = ЗначениеСвойства;
			
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

Функция ПолучитьПредставлениеКонтакта(Контакт)

	Возврат Строка(Контакт);

КонецФункции

// Определяет отбор динамического списка в зависимости от наличия режима совместимости.
//
// Параметры:
//  Список  - ДинамическийСписок - список, для которого надо определить отбор.
//
// Возвращаемое значение:
//   Отбор   - требуемый отбор.
//
Функция ОтборДинамическогоСписка(Список) Экспорт

	Возврат Список.КомпоновщикНастроек.ФиксированныеНастройки.Отбор;

КонецФункции

// Формирует структуру для записи в регистр сведений ПредметыПапкиВзаимодействий.
//
// Параметры:
//  Папка       - Справочник.ПапкиЭлектронныхПисем - папка, имеет смысл для документов "Электронное письмо входящее"
//               и "Электронное письмо исходящее".
//  Предмет          - СправочникСсылка, ДокументСсылка, указывает на предмет взаимодействия.
//  Рассмотрено      - Булево - признак рассмотрения взаимодействия.
//  РассмотретьПосле - ДатаВремя - дата, до которой отложено рассмотрение взаимодействия.
//  РассчитыватьРассмотрено - Булево - признак необходимости расчета состояний папки и предмета.
//
// Возвращаемое значение:
//   Структура   - сформированная структура.
//
Функция СтруктураРеквизитовВзаимодействияДляЗаписи(Папка = Неопределено, Предмет = Неопределено, Рассмотрено = Неопределено,
	                                               РассмотретьПосле = Неопределено, РассчитыватьРассмотрено = Истина) Экспорт
	
	СтруктураВозврата = ПустаяСтруктураРеквизитыВзаимодействия();
	
	Если Папка <> Неопределено Тогда
		СтруктураВозврата.Папка = Папка;
	КонецЕсли;
	
	Если Предмет <> Неопределено Тогда
		СтруктураВозврата.Предмет = Предмет;
	КонецЕсли;
	
	Если Рассмотрено <> Неопределено Тогда
		СтруктураВозврата.Рассмотрено = Рассмотрено;
	КонецЕсли;
	
	Если РассмотретьПосле <> Неопределено Тогда
		СтруктураВозврата.РассмотретьПосле = РассмотретьПосле;
	КонецЕсли;
	СтруктураВозврата.РассчитыватьРассмотрено = РассчитыватьРассмотрено;
	
	Возврат СтруктураВозврата;
	
КонецФункции

// Формирует пустую структуру для записи в регистр сведений ПредметыПапкиВзаимодействий.
//
Функция ПустаяСтруктураРеквизитыВзаимодействия() Экспорт

	СтруктураВозврата = Новый Структура;
	СтруктураВозврата.Вставить("Предмет"                ,Неопределено);
	СтруктураВозврата.Вставить("Папка"                  ,Неопределено);
	СтруктураВозврата.Вставить("Рассмотрено"            ,Неопределено);
	СтруктураВозврата.Вставить("РассмотретьПосле"       ,Неопределено);
	СтруктураВозврата.Вставить("РассчитыватьРассмотрено",Истина);
	
	Возврат СтруктураВозврата;
	
КонецФункции

Функция СписокСтатусов() Экспорт
	
	СписокСтатусов = Новый СписокЗначений;
	СписокСтатусов.Добавить("Все", НСтр("ru = 'Все'"));
	СписокСтатусов.Добавить("КРассмотрению", НСтр("ru = 'К рассмотрению'"));
	СписокСтатусов.Добавить("Отложенные", НСтр("ru = 'Отложенные'"));
	СписокСтатусов.Добавить("Рассмотренные", НСтр("ru = 'Рассмотренные'"));
	
	Возврат СписокСтатусов;
	
КонецФункции

Функция СтатусПоИмениКоманды(ИмяКоманды) Экспорт
	
	НайденнаяПозиция = СтрНайти(ИмяКоманды, "_");
	Если НайденнаяПозиция = 0 Тогда
		Возврат "Все";
	КонецЕсли;
	
	СтрокаСтатус = Прав(ИмяКоманды, СтрДлина(ИмяКоманды) - НайденнаяПозиция);
	Если СписокСтатусов().НайтиПоЗначению(СтрокаСтатус) = Неопределено Тогда
		Возврат "Все";
	КонецЕсли;
	
	Возврат СтрокаСтатус;
	
КонецФункции

Функция ТипВзаимодействияПоИмениКоманды(ИмяКоманды, ТолькоПочта) Экспорт
	
	НайденнаяПозиция = СтрНайти(ИмяКоманды, "_");
	Если НайденнаяПозиция = 0 Тогда
		Возврат "Все";
	КонецЕсли;
	
	СтрокаТипВзаимодействия = Прав(ИмяКоманды, СтрДлина(ИмяКоманды) - НайденнаяПозиция);
	Если СписокОтборовПоТипуВзаимодействий(ТолькоПочта).НайтиПоЗначению(СтрокаТипВзаимодействия) = Неопределено Тогда
		Возврат "Все";
	КонецЕсли;
	
	Возврат СтрокаТипВзаимодействия;
	
КонецФункции

Функция СписокОтборовПоТипуВзаимодействий(ТолькоПочта) Экспорт
	
	СписокОтборов = Новый СписокЗначений;
	
	СписокОтборов.Добавить("Все", НСтр("ru = 'Все'"));
	СписокОтборов.Добавить("ВсеПисьма", НСтр("ru = 'Все письма'"));
	Если Не ТолькоПочта Тогда
		СписокОтборов.Добавить("Встречи", НСтр("ru = 'Встречи'"));
		СписокОтборов.Добавить("ТелефонныеЗвонки", НСтр("ru = 'Телефонные звонки'"));
		СписокОтборов.Добавить("ЗапланированныеВзаимодействия", НСтр("ru = 'Запланированные взаимодействия'"));
		СписокОтборов.Добавить("СообщенияSMS", НСтр("ru = 'Сообщения SMS'"));
	КонецЕсли;
	СписокОтборов.Добавить("ВходящиеПисьма", НСтр("ru = 'Входящие'"));
	СписокОтборов.Добавить("ПисьмаЧерновики", НСтр("ru = 'Черновики'"));
	СписокОтборов.Добавить("ИсходящиеПисьма", НСтр("ru = 'Исходящие'"));
	СписокОтборов.Добавить("Отправленные", НСтр("ru = 'Отправленные'"));
	СписокОтборов.Добавить("УдаленныеПисьма", НСтр("ru = 'Удаленные'"));
	Если Не ТолькоПочта Тогда
		СписокОтборов.Добавить("ИсходящиеЗвонки", НСтр("ru = 'Исходящие звонки'"));
		СписокОтборов.Добавить("ВходящиеЗвонки", НСтр("ru = 'Входящие звонки'"));
	КонецЕсли;
	
	Возврат СписокОтборов;
	
КонецФункции

Процедура ОбработкаПолученияПредставления(МенеджерОбъекта, Данные, Представление, СтандартнаяОбработка) Экспорт
	
	Тема = ?(ПустаяСтрока(Данные.Тема), НСтр("ru = 'Без темы'"), Данные.Тема);
	Дата = Формат(Данные.Дата, "ДЛФ=D");
	ТипДокумента = "";
	Если ТипЗнч(МенеджерОбъекта) = Тип("ДокументМенеджер.Встреча") Тогда
		ТипДокумента = НСтр("ru = 'Встреча'");
	ИначеЕсли ТипЗнч(МенеджерОбъекта) = Тип("ДокументМенеджер.ЗапланированноеВзаимодействие") Тогда
		ТипДокумента = НСтр("ru = 'Запланированное взаимодействие'");
	ИначеЕсли ТипЗнч(МенеджерОбъекта) = Тип("ДокументМенеджер.СообщениеSMS") Тогда
		ТипДокумента = НСтр("ru = 'SMS'");
	ИначеЕсли ТипЗнч(МенеджерОбъекта) = Тип("ДокументМенеджер.ТелефонныйЗвонок") Тогда
		ТипДокумента = НСтр("ru = 'Телефонный звонок'");
	ИначеЕсли ТипЗнч(МенеджерОбъекта) = Тип("ДокументМенеджер.ЭлектронноеПисьмоВходящее") Тогда
		ТипДокумента = НСтр("ru = 'Входящее письмо'");
	ИначеЕсли ТипЗнч(МенеджерОбъекта) = Тип("ДокументМенеджер.ЭлектронноеПисьмоИсходящее") Тогда
		ТипДокумента = НСтр("ru = 'Исходящее письмо'");
	КонецЕсли;
	
	ШаблонПредставления = НСтр("ru = '%1 от %2 (%3)'");
	Представление = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ШаблонПредставления, Тема, Дата, ТипДокумента);
	
	СтандартнаяОбработка = Ложь;
	 
КонецПроцедуры

Процедура ОбработкаПолученияПолейПредставления(МенеджерОбъекта, Поля, СтандартнаяОбработка) Экспорт
	
	Поля.Добавить("Тема");
	Поля.Добавить("Дата");
	СтандартнаяОбработка = Ложь;

КонецПроцедуры

Функция ПолучитьКартинкуСтраницыПодписи(ПоказыватьКартинку) Экспорт

	Возврат ?( ПоказыватьКартинку, БиблиотекаКартинок.КоличествоРассмотрено, Новый Картинка);

КонецФункции 

#КонецОбласти
