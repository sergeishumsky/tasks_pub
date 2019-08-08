////////////////////////////////////////////////////////////////////////////////
// Подсистема "Завершение работы пользователей".
//
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

////////////////////////////////////////////////////////////////////////////////
// Блокировка и завершение соединений с ИБ.

// Устанавливает блокировку соединений ИБ.
// Если вызывается из сеанса с установленными значениями разделителей,
// то устанавливает блокировку сеансов области данных.
//
// Параметры:
//  ТекстСообщения  - Строка - текст, который будет частью сообщения об ошибке
//                             при попытке установки соединения с заблокированной
//                             информационной базой.
// 
//  КодРазрешения - Строка -   строка, которая должна быть добавлена к параметру
//                             командной строки "/uc" или к параметру строки
//                             соединения "uc", чтобы установить соединение с
//                             информационной базой несмотря на блокировку.
//                             Не применимо для блокировки сеансов области данных.
//
// Возвращаемое значение:
//   Булево   - Истина, если блокировка установлена успешно.
//              Ложь, если для выполнения блокировки недостаточно прав.
//
Функция УстановитьБлокировкуСоединений(Знач ТекстСообщения = "",
	Знач КодРазрешения = "КодРазрешения") Экспорт
	
	Если ОбщегоНазначенияПовтИсп.РазделениеВключено() И ОбщегоНазначенияПовтИсп.ДоступноИспользованиеРазделенныхДанных() Тогда
		
		Если Не Пользователи.ЭтоПолноправныйПользователь() Тогда
			Возврат Ложь;
		КонецЕсли;
		
		Блокировка = НовыеПараметрыБлокировкиСоединений();
		Блокировка.Установлена = Истина;
		Блокировка.Начало = ТекущаяДатаСеанса();
		Блокировка.Сообщение = СформироватьСообщениеБлокировки(ТекстСообщения, КодРазрешения);
		Блокировка.Эксклюзивная = Пользователи.ЭтоПолноправныйПользователь(, Истина);
		УстановитьБлокировкуСеансовОбластиДанных(Блокировка);
		Возврат Истина;
	Иначе
		Если Не Пользователи.ЭтоПолноправныйПользователь(, Истина) Тогда
			Возврат Ложь;
		КонецЕсли;
		
		Блокировка = Новый БлокировкаСеансов;
		Блокировка.Установлена = Истина;
		Блокировка.Начало = ТекущаяДатаСеанса();
		Блокировка.КодРазрешения = КодРазрешения;
		Блокировка.Сообщение = СформироватьСообщениеБлокировки(ТекстСообщения, КодРазрешения);
		УстановитьБлокировкуСеансов(Блокировка);
		Возврат Истина;
	КонецЕсли;
	
КонецФункции

// Определить, установлена ли блокировка соединений при пакетном 
// обновлении конфигурации информационной базы.
//
// Параметры:
//	ПараметрыБлокировки - Структура - параметры блокировки сеансов. См. описание в
//	                                  СтруктураПараметровБлокировкиСеансов().
//
// Возвращаемое значение:
//	Булево - Истина, если установлена, ложь - Иначе.
//
Функция УстановленаБлокировкаСоединений(ПараметрыБлокировки = Неопределено) Экспорт
	
	Если ПараметрыБлокировки = Неопределено Тогда
		ПараметрыБлокировки = СтруктураПараметровБлокировкиСеансов();
	КонецЕсли;
	
	Возврат ПараметрыБлокировки.УстановленаБлокировкаСоединений;
		
КонецФункции

// Получить параметры блокировки соединений ИБ для использования на стороне клиента.
//
// Параметры:
//	ПолучитьКоличествоСеансов - Булево - если Истина, то в возвращаемой структуре
//                                       заполняется поле КоличествоСеансов.
//	ПараметрыБлокировки - Структура - параметры блокировки сеансов. См. описание в
//	                                  СтруктураПараметровБлокировкиСеансов().
//
// Возвращаемое значение:
//   Структура - со свойствами:
//     * Установлена       - Булево - Истина, если установлена блокировка, Ложь - Иначе. 
//     * Начало            - Дата   - дата начала блокировки. 
//     * Конец             - Дата   - дата окончания блокировки. 
//     * Сообщение         - Строка - сообщение пользователю. 
//     * ИнтервалОжиданияЗавершенияРаботыПользователей - Число - интервал в секундах.
//     * КоличествоСеансов - Число  - 0, если параметр ПолучитьКоличествоСеансов = Ложь.
//     * ТекущаяДатаСеанса - Дата   - текущая дата сеанса.
//
Функция ПараметрыБлокировкиСеансов(Знач ПолучитьКоличествоСеансов = Ложь, ПараметрыБлокировки = Неопределено) Экспорт
	
	Если ПараметрыБлокировки = Неопределено Тогда
		ПараметрыБлокировки = СтруктураПараметровБлокировкиСеансов();
	КонецЕсли;
	
	Если ПараметрыБлокировки.УстановленаБлокировкаСоединенийИБНаДату Тогда
		ТекущийРежим = ПараметрыБлокировки.ТекущийРежимИБ;
	ИначеЕсли ПараметрыБлокировки.УстановленаБлокировкаСоединенийОбластиДанныхНаДату Тогда
		ТекущийРежим = ПараметрыБлокировки.ТекущийРежимОбластиДанных;
	ИначеЕсли ПараметрыБлокировки.ТекущийРежимИБ.Установлена Тогда
		ТекущийРежим = ПараметрыБлокировки.ТекущийРежимИБ;
	Иначе
		ТекущийРежим = ПараметрыБлокировки.ТекущийРежимОбластиДанных;
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Истина);
	
	Результат = Новый Структура;
	Результат.Вставить("Установлена", ТекущийРежим.Установлена);
	Результат.Вставить("Начало", ТекущийРежим.Начало);
	Результат.Вставить("Конец", ТекущийРежим.Конец);
	Результат.Вставить("Сообщение", ТекущийРежим.Сообщение);
	Результат.Вставить("ИнтервалОжиданияЗавершенияРаботыПользователей", 15 * 60);
	Результат.Вставить("КоличествоСеансов", ?(ПолучитьКоличествоСеансов, КоличествоСеансовИнформационнойБазы(), 0));
	Результат.Вставить("ТекущаяДатаСеанса", ПараметрыБлокировки.ТекущаяДата);
	Результат.Вставить("ПерезапуститьПриЗавершении", Истина);
	
	СоединенияИБПереопределяемый.ПриОпределенииПараметровБлокировкиСеансов(Результат);
	
	Возврат Результат;
	
КонецФункции

// Снять блокировку информационной базы.
//
// Возвращаемое значение:
//   Булево   - Истина, если операция выполнена успешно.
//              Ложь, если для выполнения операции недостаточно прав.
//
Функция РазрешитьРаботуПользователей() Экспорт
	
	Если ОбщегоНазначенияПовтИсп.РазделениеВключено() И ОбщегоНазначенияПовтИсп.ДоступноИспользованиеРазделенныхДанных() Тогда
		
		Если Не Пользователи.ЭтоПолноправныйПользователь() Тогда
			Возврат Ложь;
		КонецЕсли;
		
		ТекущийРежим = ПолучитьБлокировкуСеансовОбластиДанных();
		Если ТекущийРежим.Установлена Тогда
			НовыйРежим = НовыеПараметрыБлокировкиСоединений();
			НовыйРежим.Установлена = Ложь;
			УстановитьБлокировкуСеансовОбластиДанных(НовыйРежим);
		КонецЕсли;
		Возврат Истина;
		
	Иначе
		Если НЕ Пользователи.ЭтоПолноправныйПользователь(, Истина) Тогда
			Возврат Ложь;
		КонецЕсли;
		
		ТекущийРежим = ПолучитьБлокировкуСеансов();
		Если ТекущийРежим.Установлена Тогда
			НовыйРежим = Новый БлокировкаСеансов;
			НовыйРежим.Установлена = Ложь;
			УстановитьБлокировкуСеансов(НовыйРежим);
		КонецЕсли;
		Возврат Истина;
	КонецЕсли;
	
КонецФункции	

////////////////////////////////////////////////////////////////////////////////
// Блокировка сеансов областей данных.

// Получить пустую структуру с параметрами блокировки сеансов области данных.
// 
// Возвращаемое значение:
//   Структура        - с полями:
//     Начало         - Дата   - время начала действия блокировки.
//     Конец          - Дата   - время завершения действия блокировки.
//     Сообщение      - Строка - сообщения для пользователей, выполняющих вход в заблокированную область данных.
//     Установлена    - Булево - признак того, что блокировка установлена.
//     Эксклюзивная   - Булево - блокировка не может быть изменена администратором приложения.
//
Функция НовыеПараметрыБлокировкиСоединений() Экспорт
	
	Результат = Новый Структура;
	Результат.Вставить("Конец", Дата(1,1,1));
	Результат.Вставить("Начало", Дата(1,1,1));
	Результат.Вставить("Сообщение", "");
	Результат.Вставить("Установлена", Ложь);
	Результат.Вставить("Эксклюзивная", Ложь);
	
	Возврат Результат;
	
КонецФункции

// Установить блокировку сеансов области данных.
// 
// Параметры:
//   Параметры         - Структура - см. НовыеПараметрыБлокировкиСоединений.
//   ПоМестномуВремени - Булево - время начала и окончания блокировки указаны в местном времени сеанса.
//                                Если Ложь, то в универсальном времени.
//   ОбластьДанных - Число(7,0) - номер области данных, для которой устанавливается блокировка.
//     При вызове из сеанса, в котором заданы значения разделителей, может быть передано только значение,
//       совпадающее со значением разделителя в сеансе (или опущено).
//     При вызове из сеанса, в котором не заданы значения разделителей, значение параметра не может быть опущено.
//
Процедура УстановитьБлокировкуСеансовОбластиДанных(Параметры, Знач ПоМестномуВремени = Истина, Знач ОбластьДанных = -1) Экспорт
	
	Если Не Пользователи.ЭтоПолноправныйПользователь() Тогда
		ВызватьИсключение НСтр("ru ='Недостаточно прав для выполнения операции'");
	КонецЕсли;
	
	Эксклюзивная = Ложь;
	Если Не Параметры.Свойство("Эксклюзивная", Эксклюзивная) Тогда
		Эксклюзивная = Ложь;
	КонецЕсли;
	Если Эксклюзивная И Не Пользователи.ЭтоПолноправныйПользователь(, Истина) Тогда
		ВызватьИсключение НСтр("ru ='Недостаточно прав для выполнения операции'");
	КонецЕсли;
	
	Если ОбщегоНазначенияПовтИсп.ДоступноИспользованиеРазделенныхДанных() Тогда
		
		Если ОбластьДанных = -1 Тогда
			ОбластьДанных = ОбщегоНазначения.ЗначениеРазделителяСеанса();
		ИначеЕсли ОбластьДанных <> ОбщегоНазначения.ЗначениеРазделителяСеанса() Тогда
			ВызватьИсключение НСтр("ru = 'Из сеанса с используемыми значениями разделителей нельзя установить блокировку сеансов области данных, отличной от используемой в сеансе!'");
		КонецЕсли;
		
	Иначе
		
		Если ОбластьДанных = -1 Тогда
			ВызватьИсключение НСтр("ru = 'Невозможно установить блокировку сеансов области данных - не указана область данных!'");
		КонецЕсли;
		
	КонецЕсли;
	
	СтруктураНастроек = Параметры;
	Если ТипЗнч(Параметры) = Тип("БлокировкаСеансов") Тогда
		СтруктураНастроек = НовыеПараметрыБлокировкиСоединений();
		ЗаполнитьЗначенияСвойств(СтруктураНастроек, Параметры);
	КонецЕсли;

	УстановитьПривилегированныйРежим(Истина);
	НаборБлокировок = РегистрыСведений.БлокировкиСеансовОбластейДанных.СоздатьНаборЗаписей();
	НаборБлокировок.Отбор.ОбластьДанныхВспомогательныеДанные.Установить(ОбластьДанных);
	НаборБлокировок.Прочитать();
	НаборБлокировок.Очистить();
	Если Параметры.Установлена Тогда 
		Блокировка = НаборБлокировок.Добавить();
		Блокировка.ОбластьДанныхВспомогательныеДанные = ОбластьДанных;
		Блокировка.НачалоБлокировки = ?(ПоМестномуВремени И ЗначениеЗаполнено(СтруктураНастроек.Начало), 
			УниверсальноеВремя(СтруктураНастроек.Начало), СтруктураНастроек.Начало);
		Блокировка.КонецБлокировки = ?(ПоМестномуВремени И ЗначениеЗаполнено(СтруктураНастроек.Конец), 
			УниверсальноеВремя(СтруктураНастроек.Конец), СтруктураНастроек.Конец);
		Блокировка.СообщениеБлокировки = СтруктураНастроек.Сообщение;
		Блокировка.Эксклюзивная = СтруктураНастроек.Эксклюзивная;
	КонецЕсли;
	НаборБлокировок.Записать();
	
КонецПроцедуры

// Получить информацию о блокировке сеансов области данных.
// 
// Параметры:
//   ПоМестномуВремени - Булево - время начала и окончания блокировки необходимо вернуть 
//                                в местном времени сеанса. Если Ложь, то 
//                                возвращается в универсальном времени.
//
// Возвращаемое значение:
//   Структура - см. НовыеПараметрыБлокировкиСоединений.
//
Функция ПолучитьБлокировкуСеансовОбластиДанных(Знач ПоМестномуВремени = Истина) Экспорт
	
	Результат = НовыеПараметрыБлокировкиСоединений();
	Если Не ОбщегоНазначенияПовтИсп.РазделениеВключено() Или Не ОбщегоНазначенияПовтИсп.ДоступноИспользованиеРазделенныхДанных() Тогда
		Возврат Результат;
	КонецЕсли;
	
	Если Не Пользователи.ЭтоПолноправныйПользователь() Тогда
		ВызватьИсключение НСтр("ru ='Недостаточно прав для выполнения операции'");
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Истина);
	НаборБлокировок = РегистрыСведений.БлокировкиСеансовОбластейДанных.СоздатьНаборЗаписей();
	НаборБлокировок.Отбор.ОбластьДанныхВспомогательныеДанные.Установить(ОбщегоНазначения.ЗначениеРазделителяСеанса());
	НаборБлокировок.Прочитать();
	Если НаборБлокировок.Количество() = 0 Тогда
		Возврат Результат;
	КонецЕсли;
	Блокировка = НаборБлокировок[0];
	Результат.Начало = ?(ПоМестномуВремени И ЗначениеЗаполнено(Блокировка.НачалоБлокировки), 
		МестноеВремя(Блокировка.НачалоБлокировки), Блокировка.НачалоБлокировки);
	Результат.Конец = ?(ПоМестномуВремени И ЗначениеЗаполнено(Блокировка.КонецБлокировки), 
		МестноеВремя(Блокировка.КонецБлокировки), Блокировка.КонецБлокировки);
	Результат.Сообщение = Блокировка.СообщениеБлокировки;
	Результат.Эксклюзивная = Блокировка.Эксклюзивная;
	ТекущаяДата = ТекущаяДатаСеанса();
	Результат.Установлена = Истина;
	// Уточняем результат по периоду блокировки.
	Результат.Установлена = Не ЗначениеЗаполнено(Блокировка.КонецБлокировки) 
		Или Блокировка.КонецБлокировки >= ТекущаяДата 
		Или УстановленаБлокировкаСоединенийНаДату(Результат, ТекущаяДата);
	Возврат Результат;
	
КонецФункции

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

// Возвращает текстовую строку со списком активных соединений ИБ.
// Названия соединений разделены символом переноса строки.
//
// Параметры:
//	Сообщение - Строка - передаваемая строка.
//
// Возвращаемое значение:
//   Строка - названия соединений.
//
Функция СообщениеОНеотключенныхСеансах() Экспорт
	
	Сообщение = НСтр("ru = 'Не удалось отключить сеансы:'");
	НомерТекущегоСеанса = НомерСеансаИнформационнойБазы();
	Для Каждого Сеанс Из ПолучитьСеансыИнформационнойБазы() Цикл
		Если Сеанс.НомерСеанса <> НомерТекущегоСеанса Тогда
			Сообщение = Сообщение + Символы.ПС + "• " + Сеанс;
		КонецЕсли;
	КонецЦикла;
	
	Возврат Сообщение;
	
КонецФункции

// Получить число активных сеансов ИБ.
//
// Параметры:
//   УчитыватьКонсоль - Булево - если Ложь, то исключить сеансы консоли кластера серверов.
//                               Сеансы консоли кластера серверов не препятствуют выполнению 
//                               административных операций (установке монопольного режима и т.п.).
//
// Возвращаемое значение:
//   Число - количество активных сеансов ИБ.
//
Функция КоличествоСеансовИнформационнойБазы(УчитыватьКонсоль = Истина, УчитыватьФоновыеЗадания = Истина) Экспорт
	
	СеансыИБ = ПолучитьСеансыИнформационнойБазы();
	Если УчитыватьКонсоль И УчитыватьФоновыеЗадания Тогда
		Возврат СеансыИБ.Количество();
	КонецЕсли;
	
	Результат = 0;
	
	Для Каждого СеансИБ Из СеансыИБ Цикл
		
		Если Не УчитыватьКонсоль И СеансИБ.ИмяПриложения = "SrvrConsole"
			Или Не УчитыватьФоновыеЗадания И СеансИБ.ИмяПриложения = "BackgroundJob" Тогда
			Продолжить;
		КонецЕсли;
		
		Результат = Результат + 1;
		
	КонецЦикла;
	
	Возврат Результат;
	
КонецФункции

// Определяет количество сеансов информационной базы и наличие сеансов,
// которые не могут быть отключены принудительно. Формирует текст сообщения
// об ошибке.
//
Функция ИнформацияОБлокирующихСеансах(ТекстСообщения = "") Экспорт
	
	ИнформацияОБлокирующихСеансах = Новый Структура;
	
	НомерТекущегоСеанса = НомерСеансаИнформационнойБазы();
	СеансыИнформационнойБазы = ПолучитьСеансыИнформационнойБазы();
	
	ИмеютсяБлокирующиеСеансы = Ложь;
	Если ОбщегоНазначения.ИнформационнаяБазаФайловая() Тогда
		ИменаАктивныхСеансов = "";
		Для Каждого Сеанс Из СеансыИнформационнойБазы Цикл
			Если Сеанс.НомерСеанса <> НомерТекущегоСеанса
				И Сеанс.ИмяПриложения <> "1CV8"
				И Сеанс.ИмяПриложения <> "1CV8C"
				И Сеанс.ИмяПриложения <> "WebClient" Тогда
				ИменаАктивныхСеансов = ИменаАктивныхСеансов + Символы.ПС + "• " + Сеанс;
				ИмеютсяБлокирующиеСеансы = Истина;
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	
	ИнформацияОБлокирующихСеансах.Вставить("ИмеютсяБлокирующиеСеансы", ИмеютсяБлокирующиеСеансы);
	ИнформацияОБлокирующихСеансах.Вставить("КоличествоСеансов", СеансыИнформационнойБазы.Количество());
	
	Если ИмеютсяБлокирующиеСеансы Тогда
		Сообщение = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Имеются активные сеансы работы с программой,
			|которые не могут быть завершены принудительно:
			|%1
			|%2'"),
			ИменаАктивныхСеансов, ТекстСообщения);
		ИнформацияОБлокирующихСеансах.Вставить("ТекстСообщения", Сообщение);
		
	КонецЕсли;
	
	Возврат ИнформацияОБлокирующихСеансах;
	
КонецФункции

// Возвращает информацию о текущих соединениях с информационной базой.
// При необходимости записывает сообщение в журнал регистрации.
//
Функция ИнформацияОСоединениях(ПолучатьСтрокуСоединения = Ложь,
	СообщенияДляЖурналаРегистрации = Неопределено, ПортКластера = 0) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	Результат = Новый Структура();
	Результат.Вставить("НаличиеАктивныхСоединений", Ложь);
	Результат.Вставить("НаличиеCOMСоединений", Ложь);
	Результат.Вставить("НаличиеСоединенияКонфигуратором", Ложь);
	Результат.Вставить("ЕстьАктивныеПользователи", Ложь);
	
	Если ПользователиИнформационнойБазы.ПолучитьПользователей().Количество() > 0 Тогда
		Результат.ЕстьАктивныеПользователи = Истина;
	КонецЕсли;
	
	Если ПолучатьСтрокуСоединения Тогда
		Результат.Вставить("СтрокаСоединенияИнформационнойБазы",
			СоединенияИБКлиентСервер.ПолучитьСтрокуСоединенияИнформационнойБазы());
	КонецЕсли;
		
	ЖурналРегистрации.ЗаписатьСобытияВЖурналРегистрации(СообщенияДляЖурналаРегистрации);
	
	МассивСеансов = ПолучитьСеансыИнформационнойБазы();
	Если МассивСеансов.Количество() = 1 Тогда
		Возврат Результат;
	КонецЕсли;
	
	Результат.НаличиеАктивныхСоединений = Истина;
	
	Для Каждого Сеанс Из МассивСеансов Цикл
		Если ВРег(Сеанс.ИмяПриложения) = ВРег("COMConnection") Тогда // COM соединение
			Результат.НаличиеCOMСоединений = Истина;
		ИначеЕсли ВРег(Сеанс.ИмяПриложения) = ВРег("Designer") Тогда // Конфигуратор
			Результат.НаличиеСоединенияКонфигуратором = Истина;
		КонецЕсли;
	КонецЦикла;
	
	Возврат Результат;
	
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// Объявление служебных событий, к которым можно добавлять обработчики.

// Объявляет события подсистемы ЗавершениеРаботыПользователей:
//
// Клиентские события:
//   ПриЗавершенииСеанса.
//
// См. описание этой же процедуры в модуле СтандартныеПодсистемыСервер.
Процедура ПриДобавленииСлужебныхСобытий(КлиентскиеСобытия, СерверныеСобытия) Экспорт
	
	// КЛИЕНТСКИЕ СОБЫТИЯ.
	
	// Вызывается при завершении сеанса средствами подсистемы ЗавершениеРаботыПользователей.
	// 
	// Параметры:
	//  ФормаВладелец - УправляемаяФорма, из которой выполняется завершение сеанса,
	//  НомерСеанса - Число (8,0,+) - номер сеанса, который будет завершен,
	//  СтандартнаяОбработка - Булево, флаг выполнения стандартной обработки завершения сеанса
	//    (подключение к агенту сервера через COM-соединение или сервер администрирования с
	//    запросом параметров подключения к кластеру у текущего пользователя). Может быть
	//    установлен в значение Ложь внутри обработчика события, в этом случае стандартная
	//    обработка завершения сеанса выполняться не будет,
	//  ОповещениеПослеЗавершенияСеанса - ОписаниеОповещения - описание оповещения, которое должно
	//    быть вызвано после завершения сеанса (для автоматического обновления списка активных
	//    пользователей). При установке значения параметра СтандартнаяОбработка равным Ложь,
	//    после успешного завершения сеанса, для переданного описания оповещения должна быть
	//    выполнена обработка с помощью метода ВыполнитьОбработкуОповещения (в качестве значения
	//    параметра Результат следует передавать КодВозвратаДиалога.ОК при успешном завершении
	//    сеанса). Параметр может быть опущен - в этом случае выполнять обработку оповещения не
	//    следует.
	//
	// Синтаксис:
	// Процедура ПриЗавершенииСеанса(ФормаВладелец, Знач НомерСеанса, СтандартнаяОбработка, Знач ОповещениеПослеЗавершенияСеанса = Неопределено) Экспорт
	//
	КлиентскиеСобытия.Добавить("СтандартныеПодсистемы.ЗавершениеРаботыПользователей\ПриЗавершенииСеанса");
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Добавление обработчиков событий.

// См. описание этой же процедуры в модуле СтандартныеПодсистемыСервер.
Процедура ПриДобавленииОбработчиковСлужебныхСобытий(КлиентскиеОбработчики, СерверныеОбработчики) Экспорт
	
	// КЛИЕНТСКИЕ ОБРАБОТЧИКИ.
	
	КлиентскиеОбработчики[
		"СтандартныеПодсистемы.БазоваяФункциональность\ПослеНачалаРаботыСистемы"].Добавить(
			"СоединенияИБКлиент");
	
	КлиентскиеОбработчики[
		"СтандартныеПодсистемы.БазоваяФункциональность\ПриОбработкеПараметровЗапуска"].Добавить(
			"СоединенияИБКлиент");
	
	// СЕРВЕРНЫЕ ОБРАБОТЧИКИ.
	
	СерверныеОбработчики[
		"СтандартныеПодсистемы.БазоваяФункциональность\ПриДобавленииПараметровРаботыКлиентаПриЗапуске"].Добавить(
		"СоединенияИБ");
	
	СерверныеОбработчики[
		"СтандартныеПодсистемы.БазоваяФункциональность\ПриДобавленииПараметровРаботыКлиента"].Добавить(
		"СоединенияИБ");
	
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.РаботаВМоделиСервиса") Тогда
		СерверныеОбработчики["СтандартныеПодсистемы.РаботаВМоделиСервиса\ПриЗаполненииТаблицыПараметровИБ"].Добавить(
			"СоединенияИБ");
	КонецЕсли;
	
	СерверныеОбработчики["СтандартныеПодсистемы.ОбновлениеВерсииИБ\ПриДобавленииОбработчиковОбновления"].Добавить(
		"СоединенияИБ");
	
	Если ОбщегоНазначения.ПодсистемаСуществует("ТехнологияСервиса.ВыгрузкаЗагрузкаДанных") Тогда
		СерверныеОбработчики[
			"ТехнологияСервиса.ВыгрузкаЗагрузкаДанных\ПриЗаполненииТиповИсключаемыхИзВыгрузкиЗагрузки"].Добавить(
				"СоединенияИБ");
	КонецЕсли;
	
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.ТекущиеДела") Тогда
		СерверныеОбработчики["СтандартныеПодсистемы.ТекущиеДела\ПриЗаполненииСпискаТекущихДел"].Добавить(
			"СоединенияИБ");
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

////////////////////////////////////////////////////////////////////////////////
// Обработчики событий подсистем БСП.

// Формирует список параметров ИБ.
//
// Параметры:
// ТаблицаПараметров - ТаблицаЗначений - таблица описания параметров.
// Описание состав колонок - см. РаботаВМоделиСервиса.ПолучитьТаблицуПараметровИБ().
//
Процедура ПриЗаполненииТаблицыПараметровИБ(Знач ТаблицаПараметров) Экспорт
	
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.РаботаВМоделиСервиса") Тогда
		МодульРаботаВМоделиСервиса = ОбщегоНазначения.ОбщийМодуль("РаботаВМоделиСервиса");
		МодульРаботаВМоделиСервиса.ДобавитьКонстантуВТаблицуПараметровИБ(ТаблицаПараметров, "СообщениеБлокировкиПриОбновленииКонфигурации");
	КонецЕсли;
	
КонецПроцедуры

// Заполнить структуру параметров, необходимых для работы клиентского кода
// данной подсистемы при запуске конфигурации, т.е. в обработчиках событий.
// - ПередНачаломРаботыСистемы,
// - ПриНачалеРаботыСистемы.
//
// Параметры:
//   Параметры - Структура - структура параметров запуска.
//
Процедура ПриДобавленииПараметровРаботыКлиентаПриЗапуске(Параметры) Экспорт
	
	ПараметрыБлокировки = СтруктураПараметровБлокировкиСеансов();
	Параметры.Вставить("ПараметрыБлокировкиСеансов", Новый ФиксированнаяСтруктура(ПараметрыБлокировкиСеансов(, ПараметрыБлокировки)));
	
	Если Не ПараметрыБлокировки.УстановленаБлокировкаСоединений
		Или Не ОбщегоНазначенияПовтИсп.РазделениеВключено()
		Или Не ОбщегоНазначенияПовтИсп.ДоступноИспользованиеРазделенныхДанных() Тогда
		Возврат;
	КонецЕсли;
	
	// Дальнейший код актуален только для области данных с установленной блокировкой.
	Если ОбновлениеИнформационнойБазы.ВыполняетсяОбновлениеИнформационнойБазы() 
		И Пользователи.ЭтоПолноправныйПользователь() Тогда
		// Администратор приложения может входить, несмотря на незавершенное обновление области (и блокировку области данных).
		// При этом он инициирует обновление области.
		Возврат; 
	КонецЕсли;	
	
	ТекущийРежим = ПараметрыБлокировки.ТекущийРежимОбластиДанных;
	
	Если ЗначениеЗаполнено(ТекущийРежим.Конец) Тогда
		ПериодБлокировки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = 'на период с %1 по %2'"), ТекущийРежим.Начало, ТекущийРежим.Конец);
	Иначе
		ПериодБлокировки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = 'с %1'"), ТекущийРежим.Начало);
	КонецЕсли;
	Если ЗначениеЗаполнено(ТекущийРежим.Сообщение) Тогда
		ПричинаБлокировки = НСтр("ru = 'по причине:'") + Символы.ПС + ТекущийРежим.Сообщение;
	Иначе
		ПричинаБлокировки = НСтр("ru = 'для проведения регламентных работ'");
	КонецЕсли;
	ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		НСтр("ru = 'Администратором приложения установлена блокировка работы пользователей %1 %2.
			|
			|Приложение временно недоступно.'"), ПериодБлокировки, ПричинаБлокировки);
	Параметры.Вставить("СеансыОбластиДанныхЗаблокированы", ТекстСообщения);
	ТекстСообщения = "";
	Если Пользователи.ЭтоПолноправныйПользователь() Тогда
		ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Администратором приложения установлена блокировка работы пользователей %1 %2.
				|
				|Войти в заблокированное приложение?'"),
			ПериодБлокировки, ПричинаБлокировки);
	КонецЕсли;
	Параметры.Вставить("ПредложениеВойти", ТекстСообщения);
	Если (Пользователи.ЭтоПолноправныйПользователь() И Не ТекущийРежим.Эксклюзивная) 
		Или Пользователи.ЭтоПолноправныйПользователь(, Истина) Тогда
		
		Параметры.Вставить("ВозможноСнятьБлокировку", Истина);
	Иначе
		Параметры.Вставить("ВозможноСнятьБлокировку", Ложь);
	КонецЕсли;
			
КонецПроцедуры

// Заполняет структуру параметров, необходимых для работы клиентского кода
// конфигурации.
//
// Параметры:
//   Параметры   - Структура - структура параметров.
//
Процедура ПриДобавленииПараметровРаботыКлиента(Параметры) Экспорт
	
	Параметры.Вставить("ПараметрыБлокировкиСеансов", Новый ФиксированнаяСтруктура(ПараметрыБлокировкиСеансов()));
	
КонецПроцедуры

// Добавляет процедуры-обработчики обновления, необходимые данной подсистеме.
//
// Параметры:
//  Обработчики - ТаблицаЗначений - см. описание функции НоваяТаблицаОбработчиковОбновления
//                                  общего модуля ОбновлениеИнформационнойБазы.
// 
Процедура ПриДобавленииОбработчиковОбновления(Обработчики) Экспорт
	
	Обработчик = Обработчики.Добавить();
	Обработчик.Версия = "2.1.3.9";
	Обработчик.Процедура = "СоединенияИБ.ПеренестиБлокировкиСеансовОбластейДанныхВоВспомогательныеДанные";
	Обработчик.ОбщиеДанные = Истина;
	
КонецПроцедуры

// Заполняет массив типов, исключаемых из выгрузки и загрузки данных.
//
// Параметры:
//  Типы - Массив(Типы).
//
Процедура ПриЗаполненииТиповИсключаемыхИзВыгрузкиЗагрузки(Типы) Экспорт
	
	Типы.Добавить(Метаданные.РегистрыСведений.БлокировкиСеансовОбластейДанных);
	
КонецПроцедуры

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
	Если Не ПравоДоступа("АдминистрированиеДанных", Метаданные)
		Или МодульТекущиеДелаСервер.ДелоОтключено("БлокировкаСеансов") Тогда
		Возврат;
	КонецЕсли;
	
	// Процедура вызывается только при наличии подсистемы "Текущие дела", поэтому здесь
	// не делается проверка существования подсистемы.
	Разделы = МодульТекущиеДелаСервер.РазделыДляОбъекта(Метаданные.Обработки.БлокировкаРаботыПользователей.ПолноеИмя());
	
	ПараметрыБлокировки = ПараметрыБлокировкиСеансов(Ложь);
	ТекущаяДатаСеанса = ТекущаяДатаСеанса();
	
	Если ПараметрыБлокировки.Установлена Тогда
		Если ТекущаяДатаСеанса < ПараметрыБлокировки.Начало Тогда
			Если ПараметрыБлокировки.Конец <> Дата(1, 1, 1) Тогда
				Сообщение = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = 'Запланирована с %1 по %2'"),
					Формат(ПараметрыБлокировки.Начало, "ДЛФ=DT"), Формат(ПараметрыБлокировки.Конец, "ДЛФ=DT"));
			Иначе
				Сообщение = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = 'Запланирована с %1'"), Формат(ПараметрыБлокировки.Начало, "ДЛФ=DT"));
			КонецЕсли;
			Важность = Ложь;
		ИначеЕсли ПараметрыБлокировки.Конец <> Дата(1, 1, 1) И ТекущаяДатаСеанса > ПараметрыБлокировки.Конец И ПараметрыБлокировки.Начало <> Дата(1, 1, 1) Тогда
			Важность = Ложь;
			Сообщение = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = 'Не действует (истек срок %1)'"), Формат(ПараметрыБлокировки.Конец, "ДЛФ=DT"));
		Иначе
			Если ПараметрыБлокировки.Конец <> Дата(1, 1, 1) Тогда
				Сообщение = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = 'с %1 по %2'"),
					Формат(ПараметрыБлокировки.Начало, "ДЛФ=DT"), Формат(ПараметрыБлокировки.Конец, "ДЛФ=DT"));
			Иначе
				Сообщение = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = 'с %1'"), 
					Формат(ПараметрыБлокировки.Начало, "ДЛФ=DT"));
			КонецЕсли;
			Важность = Истина;
		КонецЕсли;
	Иначе
		Сообщение = НСтр("ru = 'Не действует'");
		Важность = Ложь;
	КонецЕсли;

	
	Для Каждого Раздел Из Разделы Цикл
		
		ИдентификаторДела = "БлокировкаСеансов" + СтрЗаменить(Раздел.ПолноеИмя(), ".", "");
		
		Дело = ТекущиеДела.Добавить();
		Дело.Идентификатор  = ИдентификаторДела;
		Дело.ЕстьДела       = ПараметрыБлокировки.Установлена;
		Дело.Представление  = НСтр("ru = 'Блокировка работы пользователей'");
		Дело.Форма          = "Обработка.БлокировкаРаботыПользователей.Форма";
		Дело.Важное         = Важность;
		Дело.Владелец       = Раздел;
		
		Дело = ТекущиеДела.Добавить();
		Дело.Идентификатор  = "БлокировкаСеансовПодробности";
		Дело.ЕстьДела       = ПараметрыБлокировки.Установлена;
		Дело.Представление  = Сообщение;
		Дело.Владелец       = ИдентификаторДела; 
		
	КонецЦикла;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ ОБНОВЛЕНИЯ ИНФОРМАЦИОННОЙ БАЗЫ

// Переносит данные из регистра сведений УдалитьБлокировкиСеансаОбластейДанных в регистр
//  сведений БлокировкиСеансовОбластейДанных.
Процедура ПеренестиБлокировкиСеансовОбластейДанныхВоВспомогательныеДанные() Экспорт
	
	Если Не ОбщегоНазначенияПовтИсп.РазделениеВключено() Тогда
		Возврат;
	КонецЕсли;
	
	НачатьТранзакцию();
	
	Попытка
		
		Блокировка = Новый БлокировкаДанных();
		БлокировкаРегистра = Блокировка.Добавить("РегистрСведений.БлокировкиСеансовОбластейДанных");
		БлокировкаРегистра.Режим = РежимБлокировкиДанных.Исключительный;
		Блокировка.Заблокировать();
		
		ТекстЗапроса =
		"ВЫБРАТЬ
		|	ЕСТЬNULL(БлокировкиСеансовОбластейДанных.ОбластьДанныхВспомогательныеДанные, УдалитьБлокировкиСеансовОбластиДанных.ОбластьДанных) КАК ОбластьДанныхВспомогательныеДанные,
		|	ЕСТЬNULL(БлокировкиСеансовОбластейДанных.НачалоБлокировки, УдалитьБлокировкиСеансовОбластиДанных.НачалоБлокировки) КАК НачалоБлокировки,
		|	ЕСТЬNULL(БлокировкиСеансовОбластейДанных.КонецБлокировки, УдалитьБлокировкиСеансовОбластиДанных.КонецБлокировки) КАК КонецБлокировки,
		|	ЕСТЬNULL(БлокировкиСеансовОбластейДанных.СообщениеБлокировки, УдалитьБлокировкиСеансовОбластиДанных.СообщениеБлокировки) КАК СообщениеБлокировки,
		|	ЕСТЬNULL(БлокировкиСеансовОбластейДанных.Эксклюзивная, УдалитьБлокировкиСеансовОбластиДанных.Эксклюзивная) КАК Эксклюзивная
		|ИЗ
		|	РегистрСведений.УдалитьБлокировкиСеансовОбластиДанных КАК УдалитьБлокировкиСеансовОбластиДанных
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.БлокировкиСеансовОбластейДанных КАК БлокировкиСеансовОбластейДанных
		|		ПО УдалитьБлокировкиСеансовОбластиДанных.ОбластьДанных = БлокировкиСеансовОбластейДанных.ОбластьДанныхВспомогательныеДанные";
		Запрос = Новый Запрос(ТекстЗапроса);
		
		Набор = РегистрыСведений.БлокировкиСеансовОбластейДанных.СоздатьНаборЗаписей();
		Набор.Загрузить(Запрос.Выполнить().Выгрузить());
		ОбновлениеИнформационнойБазы.ЗаписатьДанные(Набор);
		
		ЗафиксироватьТранзакцию();
		
	Исключение
		
		ОтменитьТранзакцию();
		ВызватьИсключение;
		
	КонецПопытки;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Прочее.

// Возвращает текст сообщения блокировки сеансов.
//
// Параметры:
//	Сообщение - Строка - сообщение для блокировки.
//  КодРазрешения - Строка - код разрешения для входа в информационную базу.
//
// Возвращаемое значение:
//   Строка - сообщение блокировки.
//
Функция СформироватьСообщениеБлокировки(Знач Сообщение, Знач КодРазрешения) Экспорт
	
	ПараметрыАдминистрирования = СтандартныеПодсистемыСервер.ПараметрыАдминистрирования();
	ПризнакФайловогоРежима = Ложь;
	ПутьКИБ = СоединенияИБКлиентСервер.ПутьКИнформационнойБазе(ПризнакФайловогоРежима, ПараметрыАдминистрирования.ПортКластера);
	СтрокаПутиКИнформационнойБазе = ?(ПризнакФайловогоРежима = Истина, "/F", "/S") + ПутьКИБ;
	ТекстСообщения = "";
	Если НЕ ПустаяСтрока(Сообщение) Тогда
		ТекстСообщения = Сообщение + Символы.ПС + Символы.ПС;
	КонецЕсли;
	
	Если ОбщегоНазначенияПовтИсп.РазделениеВключено() И ОбщегоНазначенияПовтИсп.ДоступноИспользованиеРазделенныхДанных() Тогда
		ТекстСообщения = ТекстСообщения + НСтр("ru = '%1
			|Для разрешения работы пользователей можно открыть приложение с параметром РазрешитьРаботуПользователей. Например:
			|http://<веб-адрес сервера>/?C=РазрешитьРаботуПользователей'");
		ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстСообщения, СоединенияИБКлиентСервер.ТекстДляАдминистратора());
	Иначе
		ТекстСообщения = ТекстСообщения + НСтр("ru = '%1
			|Для того чтобы разрешить работу пользователей, воспользуйтесь консолью кластера серверов или запустите ""1С:Предприятие"" с параметрами:
			|ENTERPRISE %2 /CРазрешитьРаботуПользователей /UC%3'");
		ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстСообщения, СоединенияИБКлиентСервер.ТекстДляАдминистратора(),
			СтрокаПутиКИнформационнойБазе, НСтр("ru = '<код разрешения>'"));
	КонецЕсли;
	
	Возврат ТекстСообщения;
	
КонецФункции

// Возвращает установлена ли блокировка соединений на конкретную дату.
//
// Параметры:
//	ТекущийРежим - БлокировкаСеансов - блокировка сеансов.
//	ТекущаяДата - Дата - дата, на которую необходимо проверить.
//
// Возвращаемое значение:
//	Булево - Истина, если установлена.
//
Функция УстановленаБлокировкаСоединенийНаДату(ТекущийРежим, ТекущаяДата)
	
	Возврат (ТекущийРежим.Установлена И ТекущийРежим.Начало <= ТекущаяДата 
		И (Не ЗначениеЗаполнено(ТекущийРежим.Конец) Или ТекущаяДата <= ТекущийРежим.Конец));
		
КонецФункции

Функция СтруктураПараметровБлокировкиСеансов()
	
	УстановитьПривилегированныйРежим(Истина);
	
	ТекущаяДата = ТекущаяДатаСеанса();
	ТекущийРежимИБ = ПолучитьБлокировкуСеансов();
	ТекущийРежимОбластиДанных = ПолучитьБлокировкуСеансовОбластиДанных();
	УстановленаБлокировкаСоединенийИБНаДату = УстановленаБлокировкаСоединенийНаДату(ТекущийРежимИБ, ТекущаяДата);
	УстановленаБлокировкаСоединенийОбластиДанныхНаДату = УстановленаБлокировкаСоединенийНаДату(ТекущийРежимОбластиДанных, ТекущаяДата);
	
	ПараметрыБлокировкиСеансов = Новый Структура;
	ПараметрыБлокировкиСеансов.Вставить("ТекущаяДата", ТекущаяДата);
	ПараметрыБлокировкиСеансов.Вставить("ТекущийРежимИБ", ТекущийРежимИБ);
	ПараметрыБлокировкиСеансов.Вставить("ТекущийРежимОбластиДанных", ТекущийРежимОбластиДанных);
	ПараметрыБлокировкиСеансов.Вставить("УстановленаБлокировкаСоединенийИБНаДату", УстановленаБлокировкаСоединенийНаДату(ТекущийРежимИБ, ТекущаяДата));
	ПараметрыБлокировкиСеансов.Вставить("УстановленаБлокировкаСоединенийОбластиДанныхНаДату", УстановленаБлокировкаСоединенийНаДату(ТекущийРежимОбластиДанных, ТекущаяДата));
	ПараметрыБлокировкиСеансов.Вставить("УстановленаБлокировкаСоединений", УстановленаБлокировкаСоединенийИБНаДату Или УстановленаБлокировкаСоединенийОбластиДанныхНаДату);
	
	Возврат ПараметрыБлокировкиСеансов;
	
КонецФункции

#КонецОбласти
