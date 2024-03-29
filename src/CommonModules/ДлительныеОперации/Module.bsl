////////////////////////////////////////////////////////////////////////////////
// Подсистема "Базовая функциональность".
// Поддержка работы длительных серверных операций в веб-клиенте.
//  
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Запустить выполнение процедуры в фоновом задании.
// 
// Параметры:
//  ИмяПроцедуры           - Строка    - имя экспортной процедуры, которую необходимо выполнить в фоне.
//                                       У процедуры может быть два или три формальных параметра:
//                                        * Параметры       - Структура - произвольные параметры ПараметрыПроцедуры. Обязательно;
//                                        * АдресРезультата - Строка    - адрес временного хранилища, в которое нужно
//                                          поместить результат работы процедуры. Обязательно;
//                                        * АдресДополнительногоРезультата - Строка - если в ПараметрыВыполнения установлен 
//                                          параметр ДополнительныйРезультат, то содержит адрес дополнительного временного хранилища,
//                                          в которое нужно поместить результат работы процедуры. Опционально.
//  ПараметрыПроцедуры     - Структура - произвольные параметры вызова процедуры ИмяПроцедуры.
//  ПараметрыВыполнения    - Структура - см. функцию ПараметрыВыполненияВФоне.
//
// Возвращаемое значение:
//  Структура              - параметры выполнения задания: 
//   * Статус               - Строка - "Выполняется", если задание еще не завершилось;
//                                     "Выполнено", если задание было успешно выполнено;
//                                     "Ошибка", если задание завершено с ошибкой;
//                                     "Отменено", если задание отменено пользователем или администратором.
//   * ИдентификаторЗадания - УникальныйИдентификатор - если Статус = "Выполняется", то содержит 
//                                     идентификатор запущенного фонового задания.
//   * АдресРезультата       - Строка - адрес временного хранилища, в которое будет
//                                     помещен (или уже помещен) результат работы процедуры.
//   * АдресДополнительногоРезультата - Строка - если установлен параметр ДополнительныйРезультат, 
//                                     содержит адрес дополнительного временного хранилища,
//                                     в которое будет помещен (или уже помещен) результат работы процедуры.
//   * КраткоеПредставлениеОшибки   - Строка - краткая информация об исключении, если Статус = "Ошибка".
//   * ПодробноеПредставлениеОшибки - Строка - подробная информация об исключении, если Статус = "Ошибка".
// 
Функция ВыполнитьВФоне(Знач ИмяПроцедуры, Знач ПараметрыПроцедуры, Знач ПараметрыВыполнения) Экспорт
	
	АдресРезультата = ?(ПараметрыВыполнения.АдресРезультата <> Неопределено,
	    ПараметрыВыполнения.АдресРезультата,
		ПоместитьВоВременноеХранилище(Неопределено, ПараметрыВыполнения.ИдентификаторФормы));
	
	Результат = Новый Структура;
	Результат.Вставить("Статус",    "Выполняется");
	Результат.Вставить("ИдентификаторЗадания", Неопределено);
	Результат.Вставить("АдресРезультата", АдресРезультата);
	Результат.Вставить("АдресДополнительногоРезультата", "");
	Результат.Вставить("КраткоеПредставлениеОшибки", "");
	Результат.Вставить("ПодробноеПредставлениеОшибки", "");
	
	ПараметрыЭкспортнойПроцедуры = Новый Массив;
	ПараметрыЭкспортнойПроцедуры.Добавить(ПараметрыПроцедуры);
	ПараметрыЭкспортнойПроцедуры.Добавить(АдресРезультата);
	
	Если ПараметрыВыполнения.ДополнительныйРезультат Тогда
		Результат.АдресДополнительногоРезультата = ПоместитьВоВременноеХранилище(Неопределено, ПараметрыВыполнения.ИдентификаторФормы);
		ПараметрыЭкспортнойПроцедуры.Добавить(Результат.АдресДополнительногоРезультата);
	КонецЕсли;
	
	ЗапущеноЗаданийВФайловойИБ = 0;
	Если ОбщегоНазначения.ИнформационнаяБазаФайловая()
		И Не ОбновлениеИнформационнойБазы.НеобходимоОбновлениеИнформационнойБазы() Тогда
		Отбор = Новый Структура;
		Отбор.Вставить("Состояние", СостояниеФоновогоЗадания.Активно);
		ЗапущеноЗаданийВФайловойИБ = ФоновыеЗадания.ПолучитьФоновыеЗадания(Отбор).Количество();
	КонецЕсли;
	
	// Выполнить в основном потоке.
	Если ОбщегоНазначенияКлиентСервер.РежимОтладки() Или ЗапущеноЗаданийВФайловойИБ > 0 Тогда
		Попытка
			РаботаВБезопасномРежиме.ВыполнитьМетодКонфигурации(ИмяПроцедуры, ПараметрыЭкспортнойПроцедуры);
			Результат.Статус = "Выполнено";
		Исключение
			Результат.Статус = "Ошибка";
			Результат.КраткоеПредставлениеОшибки = КраткоеПредставлениеОшибки(ИнформацияОбОшибке());
			Результат.ПодробноеПредставлениеОшибки = ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
		КонецПопытки;
		Возврат Результат;
	КонецЕсли;
		
	// Выполнить в фоне.
	Попытка
		Задание = ЗапуститьФоновоеЗаданиеСКонтекстомКлиента(ИмяПроцедуры, ПараметрыЭкспортнойПроцедуры, 
			ПараметрыВыполнения.КлючФоновогоЗадания, ПараметрыВыполнения.НаименованиеФоновогоЗадания);
	Исключение
		Результат.Статус = "Ошибка";
		Если Задание <> Неопределено И Задание.ИнформацияОбОшибке <> Неопределено Тогда
			Результат.КраткоеПредставлениеОшибки = КраткоеПредставлениеОшибки(Задание.ИнформацияОбОшибке);
			Результат.ПодробноеПредставлениеОшибки = ПодробноеПредставлениеОшибки(Задание.ИнформацияОбОшибке);
		Иначе
			Результат.КраткоеПредставлениеОшибки = КраткоеПредставлениеОшибки(ИнформацияОбОшибке());
			Результат.ПодробноеПредставлениеОшибки = ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
		КонецЕсли;
		Возврат Результат;
	КонецПопытки;
	
	Результат.ИдентификаторЗадания = Задание.УникальныйИдентификатор;
	Если ПараметрыВыполнения.ОжидатьЗавершение <> 0 Тогда
		Попытка
			Задание.ОжидатьЗавершения(ПараметрыВыполнения.ОжидатьЗавершение);
		Исключение
			// Специальная обработка не требуется, возможно исключение вызвано истечением времени ожидания.
		КонецПопытки;
	КонецЕсли;
	
	ЗаполнитьЗначенияСвойств(Результат, ОперацияВыполнена(Задание.УникальныйИдентификатор));
	Возврат Результат;
	
КонецФункции

// Возвращает новую структуру для параметра ПараметрыВыполнения функции ВыполнитьВФоне.
//
// Параметры:
//   ИдентификаторФормы - УникальныйИдентификатор - уникальный идентификатор формы, 
//                               во временное хранилище которой надо поместить результат выполнения процедуры.
//
// Возвращаемое значение:
//   Структура - со свойствами:
//     * ИдентификаторФормы      - УникальныйИдентификатор - уникальный идентификатор формы, 
//                               во временное хранилище которой надо поместить результат выполнения процедуры.
//     * ДополнительныйРезультат - Булево     - признак использования дополнительного временного хранилища для передачи 
//                                 результата из фонового задания в родительский сеанс. По умолчанию - Ложь.
//     * ОжидатьЗавершение       - Число, Неопределено - таймаут в секундах ожидания завершения фонового задания. 
//                               Если задано Неопределено, то ждать до момента завершения задания. 
//                               Если задано 0, то ждать завершения задания не требуется. 
//                               По умолчанию - 2 секунды; а для низкой скорости соединения - 4. 
//     * НаименованиеФоновогоЗадания - Строка - описание фонового задания. По умолчанию - имя процедуры.
//     * КлючФоновогоЗадания      - Строка    - уникальный ключ для активных фоновых заданий, имеющих такое же имя процедуры.
//                                              По умолчанию, не задан.
//     * АдресРезультата          - Строка - адрес временного хранилища, в которое должен быть помещен результат
//                                           работы процедуры. Если не задан, адрес формируется автоматически.
//
Функция ПараметрыВыполненияВФоне(Знач ИдентификаторФормы) Экспорт
	
	Результат = Новый Структура;
	Результат.Вставить("ИдентификаторФормы", ИдентификаторФормы); 
	Результат.Вставить("ДополнительныйРезультат", Ложь);
	Результат.Вставить("ОжидатьЗавершение", ?(ПолучитьСкоростьКлиентскогоСоединения() = СкоростьКлиентскогоСоединения.Низкая, 4, 2));
	Результат.Вставить("НаименованиеФоновогоЗадания", "");
	Результат.Вставить("КлючФоновогоЗадания", "");
	Результат.Вставить("АдресРезультата", Неопределено);
	Возврат Результат;
	
КонецФункции

// Регистрирует информацию о ходе выполнения фонового задания.
// В дальнейшем ее можно считать при помощи функции ПрочитатьПрогресс.
//
// Параметры:
//  Процент - Число  - Необязательный. Процент выполнения.
//  Текст   - Строка - Необязательный. Информация о текущей операции.
//  ДополнительныеПараметры - Произвольный - Необязательный. Любая дополнительная информация,
//      которую необходимо передать на клиент. Значение должно быть простым (сериализуемым в XML строку).
//
Процедура СообщитьПрогресс(Знач Процент = Неопределено, Знач Текст = Неопределено, Знач ДополнительныеПараметры = Неопределено) Экспорт
	
	ПередаваемоеЗначение = Новый Структура;
	Если Процент <> Неопределено Тогда
		ПередаваемоеЗначение.Вставить("Процент", Процент);
	КонецЕсли;
	Если Текст <> Неопределено Тогда
		ПередаваемоеЗначение.Вставить("Текст", Текст);
	КонецЕсли;
	Если ДополнительныеПараметры <> Неопределено Тогда
		ПередаваемоеЗначение.Вставить("ДополнительныеПараметры", ДополнительныеПараметры);
	КонецЕсли;
	
	ПередаваемыйТекст = ОбщегоНазначения.ЗначениеВСтрокуXML(ПередаваемоеЗначение);
	
	Текст = "{" + ИмяПодсистемы() + "}" + ПередаваемыйТекст;
	ОбщегоНазначенияКлиентСервер.СообщитьПользователю(Текст);
	
	ПолучитьСообщенияПользователю(Истина); // Удаление предыдущих сообщений.
	
КонецПроцедуры

// Считывает информацию о ходе выполнения фонового задания.
//
// Возвращаемое значение:
//   Структура - информация о ходе выполнения фонового задания, записанная процедурой СообщитьПрогресс:
//    * Процент - Число  - Необязательный. Процент выполнения.
//    * Текст   - Строка - Необязательный. Информация о текущей операции.
//    * ДополнительныеПараметры - Произвольный - Необязательный. Любая дополнительная информация.
//
Функция ПрочитатьПрогресс(Знач ИдентификаторЗадания) Экспорт
	Перем Результат;
	
	Задание = ФоновыеЗадания.НайтиПоУникальномуИдентификатору(ИдентификаторЗадания);
	Если Задание = Неопределено Тогда
		Возврат Результат;
	КонецЕсли;
	
	МассивСообщений = Задание.ПолучитьСообщенияПользователю(Истина);
	Если МассивСообщений = Неопределено Тогда
		Возврат Результат;
	КонецЕсли;
	
	Количество = МассивСообщений.Количество();
	
	Для Номер = 1 По Количество Цикл
		ОбратныйИндекс = Количество - Номер;
		Сообщение = МассивСообщений[ОбратныйИндекс];
		
		Если СтрНачинаетсяС(Сообщение.Текст, "{") Тогда
			Позиция = СтрНайти(Сообщение.Текст, "}");
			Если Позиция > 2 Тогда
				ИдентификаторМеханизма = Сред(Сообщение.Текст, 2, Позиция - 2);
				Если ИдентификаторМеханизма = ИмяПодсистемы() Тогда
					ПолученныйТекст = Сред(Сообщение.Текст, Позиция + 1);
					Результат = ОбщегоНазначения.ЗначениеИзСтрокиXML(ПолученныйТекст);
					Прервать;
				КонецЕсли;
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	
	Возврат Результат;
КонецФункции

// ------------------------------

// Запускает выполнение процедуры в фоновом задании.
// 
// Параметры:
//  ИдентификаторФормы     - УникальныйИдентификатор - идентификатор формы, 
//                           из которой выполняется запуск длительной операции. 
//  ИмяЭкспортнойПроцедуры - Строка - имя экспортной процедуры, 
//                           которую необходимо выполнить в фоне.
//  Параметры              - Структура - все необходимые параметры для 
//                           выполнения процедуры ИмяЭкспортнойПроцедуры.
//  НаименованиеЗадания    - Строка - наименование фонового задания. 
//                           Если не задано, то будет равно ИмяЭкспортнойПроцедуры. 
//  ИспользоватьДополнительноеВременноеХранилище - Булево - признак использования
//                           дополнительного временного хранилища для передачи данных
//                           в родительский сеанс из фонового задания. По умолчанию - Ложь.
//
// Возвращаемое значение:
//  Структура              - параметры выполнения задания: 
//   * АдресХранилища  - Строка     - адрес временного хранилища, в которое будет
//                                    помещен результат работы задания;
//   * АдресХранилищаДополнительный - Строка - адрес дополнительного временного хранилища,
//                                    в которое будет помещен результат работы задания (доступно только если 
//                                    установлен параметр ИспользоватьДополнительноеВременноеХранилище);
//   * ИдентификаторЗадания - УникальныйИдентификатор - уникальный идентификатор запущенного фонового задания;
//   * ЗаданиеВыполнено - Булево - Истина если задание было успешно выполнено за время вызова функции.
// 
Функция ЗапуститьВыполнениеВФоне(Знач ИдентификаторФормы, Знач ИмяЭкспортнойПроцедуры, Знач Параметры,
	Знач НаименованиеЗадания = "", ИспользоватьДополнительноеВременноеХранилище = Ложь) Экспорт
	
	АдресХранилища = ПоместитьВоВременноеХранилище(Неопределено, ИдентификаторФормы);
	
	Результат = Новый Структура;
	Результат.Вставить("АдресХранилища",       АдресХранилища);
	Результат.Вставить("ЗаданиеВыполнено",     Ложь);
	Результат.Вставить("ИдентификаторЗадания", Неопределено);
	
	Если Не ЗначениеЗаполнено(НаименованиеЗадания) Тогда
		НаименованиеЗадания = ИмяЭкспортнойПроцедуры;
	КонецЕсли;
	
	ПараметрыЭкспортнойПроцедуры = Новый Массив;
	ПараметрыЭкспортнойПроцедуры.Добавить(Параметры);
	ПараметрыЭкспортнойПроцедуры.Добавить(АдресХранилища);
	
	Если ИспользоватьДополнительноеВременноеХранилище Тогда
		АдресХранилищаДополнительный = ПоместитьВоВременноеХранилище(Неопределено, ИдентификаторФормы);
		ПараметрыЭкспортнойПроцедуры.Добавить(АдресХранилищаДополнительный);
	КонецЕсли;
	
	ЗапущеноЗаданий = 0;
	Если ОбщегоНазначения.ИнформационнаяБазаФайловая()
		И Не ОбновлениеИнформационнойБазы.НеобходимоОбновлениеИнформационнойБазы() Тогда
		Отбор = Новый Структура;
		Отбор.Вставить("Состояние", СостояниеФоновогоЗадания.Активно);
		ЗапущеноЗаданий = ФоновыеЗадания.ПолучитьФоновыеЗадания(Отбор).Количество();
	КонецЕсли;
	
	Если ОбщегоНазначенияКлиентСервер.РежимОтладки()
		Или ЗапущеноЗаданий > 0 Тогда
		РаботаВБезопасномРежиме.ВыполнитьМетодКонфигурации(ИмяЭкспортнойПроцедуры, ПараметрыЭкспортнойПроцедуры);
		Результат.ЗаданиеВыполнено = Истина;
	Иначе
		ВремяОжидания = ?(ПолучитьСкоростьКлиентскогоСоединения() = СкоростьКлиентскогоСоединения.Низкая, 4, 2);
		Задание = ЗапуститьФоновоеЗаданиеСКонтекстомКлиента(ИмяЭкспортнойПроцедуры,	ПараметрыЭкспортнойПроцедуры,, НаименованиеЗадания);
		Попытка
			Задание.ОжидатьЗавершения(ВремяОжидания);
		Исключение
			// Специальная обработка не требуется, возможно исключение вызвано истечением времени ожидания.
		КонецПопытки;
		
		Результат.ЗаданиеВыполнено = ЗаданиеВыполнено(Задание.УникальныйИдентификатор);
		Результат.ИдентификаторЗадания = Задание.УникальныйИдентификатор;
	КонецЕсли;
	
	Если ИспользоватьДополнительноеВременноеХранилище Тогда
		Результат.Вставить("АдресХранилищаДополнительный", АдресХранилищаДополнительный);
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

// Отменяет выполнение фонового задания по переданному идентификатору.
// 
// Параметры:
//  ИдентификаторЗадания - УникальныйИдентификатор - идентификатор фонового задания. 
// 
Процедура ОтменитьВыполнениеЗадания(Знач ИдентификаторЗадания) Экспорт 
	
	Если Не ЗначениеЗаполнено(ИдентификаторЗадания) Тогда
		Возврат;
	КонецЕсли;
	
	Задание = НайтиЗаданиеПоИдентификатору(ИдентификаторЗадания);
	Если Задание = Неопределено
		ИЛИ Задание.Состояние <> СостояниеФоновогоЗадания.Активно Тогда
		
		Возврат;
	КонецЕсли;
	
	Попытка
		Задание.Отменить();
	Исключение
		// Возможно задание как раз в этот момент закончилось и ошибки нет.
		ЗаписьЖурналаРегистрации(НСтр("ru = 'Длительные операции.Отмена выполнения фонового задания'", ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка()),
			УровеньЖурналаРегистрации.Предупреждение, , , ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
	КонецПопытки;
	
КонецПроцедуры

// Проверяет состояние фонового задания по переданному идентификатору.
// При аварийном завершении задания вызывает исключение.
//
// Параметры:
//  ИдентификаторЗадания - УникальныйИдентификатор - идентификатор фонового задания. 
//
// Возвращаемое значение:
//  Булево - состояние выполнения задания.
// 
Функция ЗаданиеВыполнено(Знач ИдентификаторЗадания) Экспорт
	
	Задание = НайтиЗаданиеПоИдентификатору(ИдентификаторЗадания);
	
	Если Задание <> Неопределено
		И Задание.Состояние = СостояниеФоновогоЗадания.Активно Тогда
		Возврат Ложь;
	КонецЕсли;
	
	ОперацияНеВыполнена = Истина;
	ПоказатьПолныйТекстОшибки = Ложь;
	Если Задание = Неопределено Тогда
		ЗаписьЖурналаРегистрации(НСтр("ru = 'Длительные операции.Фоновое задание не найдено'", ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка()),
			УровеньЖурналаРегистрации.Ошибка, , , Строка(ИдентификаторЗадания));
	Иначе
		Если Задание.Состояние = СостояниеФоновогоЗадания.ЗавершеноАварийно Тогда
			ОшибкаЗадания = Задание.ИнформацияОбОшибке;
			Если ОшибкаЗадания <> Неопределено Тогда
				ПоказатьПолныйТекстОшибки = Истина;
			КонецЕсли;
		ИначеЕсли Задание.Состояние = СостояниеФоновогоЗадания.Отменено Тогда
			ЗаписьЖурналаРегистрации(
				НСтр("ru = 'Длительные операции.Фоновое задание отменено администратором'", ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка()),
				УровеньЖурналаРегистрации.Ошибка,
				,
				,
				НСтр("ru = 'Задание завершилось с неизвестной ошибкой.'"));
		Иначе
			Возврат Истина;
		КонецЕсли;
	КонецЕсли;
	
	Если ПоказатьПолныйТекстОшибки Тогда
		ТекстОшибки = КраткоеПредставлениеОшибки(ПричинаОшибки(Задание.ИнформацияОбОшибке));
		ВызватьИсключение(ТекстОшибки);
	ИначеЕсли ОперацияНеВыполнена Тогда
		ВызватьИсключение(НСтр("ru = 'Не удалось выполнить данную операцию. 
		                             |Подробности см. в Журнале регистрации.'"));
	КонецЕсли;
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ОперацияВыполнена(Знач ИдентификаторЗадания, Знач ИсключениеПриОшибке = Ложь, Знач ВыводитьПрогрессВыполнения = Ложь, 
	Знач ВыводитьСообщения = Ложь) Экспорт
	
	Результат = Новый Структура;
	Результат.Вставить("Статус", "Выполняется");
	Результат.Вставить("КраткоеПредставлениеОшибки", Неопределено);
	Результат.Вставить("ПодробноеПредставлениеОшибки", Неопределено);
	Результат.Вставить("Прогресс", Неопределено);
	Результат.Вставить("Сообщения", Неопределено);
	
	Задание = НайтиЗаданиеПоИдентификатору(ИдентификаторЗадания);
	Если Задание = Неопределено Тогда
		ЗаписьЖурналаРегистрации(НСтр("ru = 'Длительные операции'", ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка()),
			УровеньЖурналаРегистрации.Ошибка, , , НСтр("ru = 'Фоновое задание не найдено:'") + " " + Строка(ИдентификаторЗадания));
		Если ИсключениеПриОшибке Тогда
			ВызватьИсключение(НСтр("ru = 'Не удалось выполнить данную операцию.'"));
		КонецЕсли;	
		Результат.Статус = "Ошибка";
		Возврат Результат;
	КонецЕсли;
	
	Если ВыводитьПрогрессВыполнения Тогда
		Результат.Прогресс = ПрочитатьПрогресс(ИдентификаторЗадания);
	ИначеЕсли ВыводитьСообщения Тогда
		Результат.Сообщения = Задание.ПолучитьСообщенияПользователю(Истина);
	КонецЕсли;
	
	Если Задание.Состояние = СостояниеФоновогоЗадания.Активно Тогда
		Возврат Результат;
	КонецЕсли;
	
	Если Задание.Состояние = СостояниеФоновогоЗадания.Отменено Тогда
		Результат.Статус = "Отменено";
		Возврат Результат;
	КонецЕсли;
	
	Если Задание.Состояние = СостояниеФоновогоЗадания.ЗавершеноАварийно 
		Или Задание.Состояние = СостояниеФоновогоЗадания.Отменено Тогда
		
		Результат.Статус = "Ошибка";
		ОшибкаЗадания = Задание.ИнформацияОбОшибке;
		Если ОшибкаЗадания <> Неопределено Тогда
			ИнформацияОбОшибке = ПричинаОшибки(ОшибкаЗадания);
			Если ИнформацияОбОшибке <> Неопределено Тогда
				Результат.КраткоеПредставлениеОшибки = КраткоеПредставлениеОшибки(ИнформацияОбОшибке);
				Результат.ПодробноеПредставлениеОшибки = ПодробноеПредставлениеОшибки(ИнформацияОбОшибке);
			КонецЕсли;
		КонецЕсли;
		Если ИсключениеПриОшибке Тогда
			Если Не ПустаяСтрока(Результат.КраткоеПредставлениеОшибки) Тогда
				ТекстСообщения = Результат.КраткоеПредставлениеОшибки;
			Иначе
				ТекстСообщения = НСтр("ru = 'Не удалось выполнить данную операцию.'");
			КонецЕсли;	
			ВызватьИсключение ТекстСообщения;
		КонецЕсли;	
		Возврат Результат;
	КонецЕсли;
	
	Результат.Статус = "Выполнено";
	Возврат Результат;
	
КонецФункции

Функция ОперацииВыполнены(Знач Задания) Экспорт
	
	Результат = Новый Соответствие;
	Для каждого Задание Из Задания Цикл
		Результат.Вставить(Задание.ИдентификаторЗадания, 
			ОперацияВыполнена(Задание.ИдентификаторЗадания, Ложь, Задание.ВыводитьПрогрессВыполнения, Задание.ВыводитьСообщения));
	КонецЦикла;
	Возврат Результат;
	
КонецФункции

// Запуск фонового задания с контекстом клиента. Например, передаются ПараметрыКлиентаНаСервере.
// Запуск выполняется с помощью процедуры ВыполнитьМетодКонфигурации общего модуля РаботаВБезопасномРежиме.
//
// Параметры:
//  ИмяМетода    - Строка - как в функции Выполнить менеджера фоновых заданий.
//  Параметры    - Массив - как в функции Выполнить менеджера фоновых заданий.
//  Ключ         - Строка - как в функции Выполнить менеджера фоновых заданий.
//  Наименование - Строка - как в функции Выполнить менеджера фоновых заданий.
//
// Возвращаемое значение:
//  ФоновоеЗадание.
//
Функция ЗапуститьФоновоеЗаданиеСКонтекстомКлиента(ИмяПроцедуры, ПараметрыПроцедуры = Неопределено, 
	КлючФоновогоЗадания = "", НаименованиеФоновогоЗадания = "") Экспорт
	
	Если ТекущийРежимЗапуска() = Неопределено Тогда
		
		Возврат ФоновыеЗадания.Выполнить(ИмяПроцедуры, ПараметрыПроцедуры, КлючФоновогоЗадания, 
			?(ПустаяСтрока(НаименованиеФоновогоЗадания), ИмяПроцедуры, НаименованиеФоновогоЗадания));
			
	КонецЕсли;
	
	ВсеПараметры = Новый Структура;
	ВсеПараметры.Вставить("ИмяПроцедуры",       ИмяПроцедуры);
	ВсеПараметры.Вставить("ПараметрыПроцедуры", ПараметрыПроцедуры);
	ВсеПараметры.Вставить("ПараметрыКлиентаНаСервере", СтандартныеПодсистемыСервер.ПараметрыКлиентаНаСервере());
	
	ПараметрыПроцедурыФоновогоЗадания = Новый Массив;
	ПараметрыПроцедурыФоновогоЗадания.Добавить(ВсеПараметры);
	
	Возврат ФоновыеЗадания.Выполнить("ДлительныеОперации.ВыполнитьСКонтекстомКлиента",
		ПараметрыПроцедурыФоновогоЗадания, КлючФоновогоЗадания, 
		?(ПустаяСтрока(НаименованиеФоновогоЗадания), ИмяПроцедуры, НаименованиеФоновогоЗадания));
	
КонецФункции

// Продолжение процедуры ЗапуститьФоновоеЗаданиеСКонтекстомКлиента.
Процедура ВыполнитьСКонтекстомКлиента(ВсеПараметры) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	Если ПравоДоступа("Установка", Метаданные.ПараметрыСеанса.ПараметрыКлиентаНаСервере) Тогда
		ПараметрыСеанса.ПараметрыКлиентаНаСервере = ВсеПараметры.ПараметрыКлиентаНаСервере;
	КонецЕсли;
	Справочники.ВерсииРасширений.ЗарегистрироватьИспользованиеВерсииРасширений();
	УстановитьПривилегированныйРежим(Ложь);
	
	РаботаВБезопасномРежиме.ВыполнитьМетодКонфигурации(ВсеПараметры.ИмяПроцедуры, ВсеПараметры.ПараметрыПроцедуры);
	
КонецПроцедуры

Функция НайтиЗаданиеПоИдентификатору(Знач ИдентификаторЗадания)
	
	Если ТипЗнч(ИдентификаторЗадания) = Тип("Строка") Тогда
		ИдентификаторЗадания = Новый УникальныйИдентификатор(ИдентификаторЗадания);
	КонецЕсли;
	
	Задание = ФоновыеЗадания.НайтиПоУникальномуИдентификатору(ИдентификаторЗадания);
	Возврат Задание;
	
КонецФункции

Функция ПричинаОшибки(ИнформацияОбОшибке)
	
	Результат = ИнформацияОбОшибке;
	Если ИнформацияОбОшибке <> Неопределено Тогда
		Если ИнформацияОбОшибке.Причина <> Неопределено Тогда
			Результат = ПричинаОшибки(ИнформацияОбОшибке.Причина);
		КонецЕсли;
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

Процедура ВыполнитьПроцедуруМодуляОбъектаОбработки(Параметры, АдресХранилища) Экспорт 
	
	ИмяМетода = Параметры.ИмяМетода;
	ВременнаяСтруктура = Новый Структура;
	Попытка
		ВременнаяСтруктура.Вставить(ИмяМетода);
	Исключение
		ЗаписьЖурналаРегистрации(НСтр("ru = 'Безопасное выполнение метода обработки'", ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка()),
			УровеньЖурналаРегистрации.Ошибка, , , ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
		ВызватьИсключение СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru='Имя метода ""%1"" не соответствует требованиям образования имен переменных.'"), ИмяМетода);
	КонецПопытки;
	
	ПараметрыВыполнения = Параметры.ПараметрыВыполнения;
	Если Параметры.ЭтоВнешняяОбработка Тогда
		Если ЗначениеЗаполнено(Параметры.ДополнительнаяОбработкаСсылка) И ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.ДополнительныеОтчетыИОбработки") Тогда
			МодульДополнительныеОтчетыИОбработки = ОбщегоНазначения.ОбщийМодуль("ДополнительныеОтчетыИОбработки");
			Обработка = МодульДополнительныеОтчетыИОбработки.ПолучитьОбъектВнешнейОбработки(Параметры.ДополнительнаяОбработкаСсылка);
		Иначе
			Обработка = ВнешниеОбработки.Создать(Параметры.ИмяОбработки);
		КонецЕсли;
	Иначе
		Обработка = Обработки[Параметры.ИмяОбработки].Создать();
	КонецЕсли;
	
	Выполнить("Обработка." + ИмяМетода + "(ПараметрыВыполнения, АдресХранилища)");
	
КонецПроцедуры

Функция ИмяПодсистемы()
	Возврат "СтандартныеПодсистемы.ДлительныеОперации";
КонецФункции

Процедура ВыполнитьКомандуОтчетаИлиОбработки(ПараметрыКоманды, АдресРезультата) Экспорт
	
	Если ПараметрыКоманды.Свойство("ДополнительнаяОбработкаСсылка")
		И ЗначениеЗаполнено(ПараметрыКоманды.ДополнительнаяОбработкаСсылка)
		И ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.ДополнительныеОтчетыИОбработки") Тогда
		
		МодульДополнительныеОтчетыИОбработки = ОбщегоНазначения.ОбщийМодуль("ДополнительныеОтчетыИОбработки");
		МодульДополнительныеОтчетыИОбработки.ВыполнитьКоманду(ПараметрыКоманды, АдресРезультата);
		
	Иначе
		
		Объект = ОбщегоНазначения.ОбъектПоПолномуИмени(ПараметрыКоманды.ПолноеИмяОбъекта);
		Объект.ВыполнитьКоманду(ПараметрыКоманды, АдресРезультата);
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
