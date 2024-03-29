&НаКлиенте
Перем ОбновитьИнтерфейс;

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	// Значения реквизитов формы
	РежимРаботы = ОбщегоНазначенияПовтИсп.РежимРаботыПрограммы();
	РежимРаботы = Новый ФиксированнаяСтруктура(РежимРаботы);
	
	// СтандартныеПодсистемы.УдалениеПомеченныхОбъектов
	РегламентноеЗадание = РегламентныеЗаданияНайтиПредопределенное("УдалениеПомеченных");
	ВидимостьФлажка = (РегламентноеЗадание <> Неопределено);
	Если ВидимостьФлажка Тогда
		УдалениеПомеченныхИдентификатор = РегламентноеЗадание.УникальныйИдентификатор;
		УдалениеПомеченныхИспользование = РегламентноеЗадание.Использование;
		УдалениеПомеченныхРасписание    = РегламентноеЗадание.Расписание;
	КонецЕсли;
	ВидимостьРасписания = ВидимостьФлажка И Не РежимРаботы.МодельСервиса И РежимРаботы.ЭтоАдминистраторСистемы;
	Элементы.УдалениеПомеченныхИспользование.Видимость           = ВидимостьФлажка;
	Элементы.УдалениеПомеченныхНастроитьРасписание.Видимость     = ВидимостьРасписания;
	Элементы.УдалениеПомеченныхПредставлениеРасписания.Видимость = ВидимостьРасписания;
	// Конец СтандартныеПодсистемы.УдалениеПомеченныхОбъектов
	
	// СтандартныеПодсистемы.РегламентныеЗадания
	Элементы.ГруппаБлокировкаРаботыСВнешнимиРесурсами.Видимость = РегламентныеЗаданияСервер.РаботаСВнешнимиРесурсамиЗаблокирована();
	// Конец СтандартныеПодсистемы.РегламентныеЗадания
	
	// СтандартныеПодсистемы.РегламентныеЗадания
	Элементы.ГруппаОбработкаРегламентныеИФоновыеЗадания.Видимость = РежимРаботы.ЭтоАдминистраторСистемы;
	// Конец СтандартныеПодсистемы.РегламентныеЗадания
	
	// СтандартныеПодсистемы.УправлениеИтогамиИАгрегатами
	Элементы.ГруппаОбработкаУправлениеИтогамиИАгрегатамиОткрыть.Видимость = РежимРаботы.ЭтоАдминистраторПрограммы
		И (РежимРаботы.Локальный Или РежимРаботы.Автономный);
	// Конец СтандартныеПодсистемы.УправлениеИтогамиИАгрегатами
	
	// СтандартныеПодсистемы.ПолнотекстовыйПоиск
	Элементы.ГруппаУправлениеПолнотекстовымПоискомИИзвлечениемТекстов.Видимость = РежимРаботы.ЭтоАдминистраторСистемы;
	// Конец СтандартныеПодсистемы.ПолнотекстовыйПоиск
	
	// СтандартныеПодсистемы.РезервноеКопированиеИБ
	Элементы.ГруппаРезервноеКопированиеИВосстановление.Видимость = ((РежимРаботы.Локальный Или РежимРаботы.Автономный) И РежимРаботы.ЭтоАдминистраторСистемы
		И Не РежимРаботы.ЭтоВебКлиент И Не РежимРаботы.ЭтоLinuxКлиент);
	ОбновитьНастройкиРезервногоКопирования();
	// Конец СтандартныеПодсистемы.РезервноеКопированиеИБ
	
	Элементы.ГруппаКлассификаторы.Видимость = РежимРаботы.Локальный Или РежимРаботы.Автономный;
	
	// СтандартныеПодсистемы.ОценкаПроизводительности
	ОценкаПроизводительностиСуществует = ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.ОценкаПроизводительности");
	Элементы.ГруппаОценкаПроизводительности.Видимость = (РежимРаботы.ЭтоАдминистраторСистемы И ОценкаПроизводительностиСуществует);
	// Конец СтандартныеПодсистемы.ОценкаПроизводительности
	
	// СтандартныеПодсистемы.Валюты
	Элементы.ГруппаОбработкаЗагрузкаКурсовВалют.Видимость = РежимРаботы.Локальный;
	// Конец СтандартныеПодсистемы.Валюты
	
	// СтандартныеПодсистемы.Банки
	Элементы.ГруппаЗагрузитьКлассификаторБанков.Видимость = РежимРаботы.Локальный И РежимРаботы.ЭтоАдминистраторСистемы;
	// Конец СтандартныеПодсистемы.Банки
	
	// СтандартныеПодсистемы.ЗащитаПерсональныхДанных
	Элементы.ГруппаОткрытьНастройкиРегистрацииСобытийДоступаКПерсональнымДанным.Видимость = РежимРаботы.ЭтоАдминистраторСистемы;
	// Конец СтандартныеПодсистемы.ЗащитаПерсональныхДанных
	
	// СтандартныеПодсистемы.ГрупповоеИзменениеОбъектов
	Элементы.ГруппаОбработкаГрупповоеИзменениеОбъектов.Видимость = РежимРаботы.ЭтоАдминистраторПрограммы;
	// Конец СтандартныеПодсистемы.ГрупповоеИзменениеОбъектов
	
	// СтандартныеПодсистемы.ДополнительныеОтчетыИОбработки
	Элементы.ГруппаДополнительныеОтчетыПоАдминистрированию.Видимость = НаборКонстант.ИспользоватьДополнительныеОтчетыИОбработки;
	Элементы.ГруппаДополнительныеОбработкиПоАдминистрированию.Видимость = НаборКонстант.ИспользоватьДополнительныеОтчетыИОбработки;
	// Конец СтандартныеПодсистемы.ДополнительныеОтчетыИОбработки
	
	//// СтандартныеПодсистемы.АдресныйКлассификатор
	//ВидимостьГруппы = РежимРаботы.Локальный Или РежимРаботы.Автономный;
	//Элементы.ГруппаАдресныйКлассификаторНастройки.Видимость = ВидимостьГруппы;
	//Элементы.ГруппаАдресныйКлассификаторКоманды.Видимость   = ВидимостьГруппы;
	//// Конец СтандартныеПодсистемы.АдресныйКлассификатор
	
	//// СтандартныеПодсистемы.РаботаСКонтрагентами
	//Элементы.ГруппаПроверкаКонтрагентов.Видимость = РежимРаботы.ЭтоАдминистраторСистемы;
	//	
	//Если Элементы.ГруппаПроверкаКонтрагентов.Видимость Тогда
	//	
	//	ПроверкаКонтрагентов.УстановитьВидимостьИЗаголовокПредупрежденияПроТестовыйРежим(
	//		Элементы.ПредупреждениеПроТестовыйРежимПроверкиКонтрагента);
	//
	//КонецЕсли;
	//// Конец СтандартныеПодсистемы.РаботаСКонтрагентами
	
	// СтандартныеПодсистемы.ЦентрМониторинга
	ЦентрМониторингаСуществует = ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.ЦентрМониторинга");
	Элементы.ГруппаЦентрМониторинга.Видимость = (РежимРаботы.ЭтоАдминистраторСистемы И ЦентрМониторингаСуществует);
	
	Если (РежимРаботы.ЭтоАдминистраторСистемы И ЦентрМониторингаСуществует) Тогда
		ПараметрыЦентраМониторинга = ПолучитьПараметрыЦентраМониторинга();
		ЦентрМониторингаРазрешитьОтправлятьДанные = ПолучитьПереключательОтправкиДанных(ПараметрыЦентраМониторинга.ВключитьЦентрМониторинга, ПараметрыЦентраМониторинга.ЦентрОбработкиИнформацииОПрограмме);
		
		ПараметрыСервиса = Новый Структура("Сервер, АдресРесурса, Порт");
		Если ЦентрМониторингаРазрешитьОтправлятьДанные = 0 Тогда
			ПараметрыСервиса.Сервер = ПараметрыЦентраМониторинга.СерверПоУмолчанию;
			ПараметрыСервиса.АдресРесурса = ПараметрыЦентраМониторинга.АдресРесурсаПоУмолчанию;
			ПараметрыСервиса.Порт = ПараметрыЦентраМониторинга.ПортПоУмолчанию;
		ИначеЕсли ЦентрМониторингаРазрешитьОтправлятьДанные = 1 Тогда
			ПараметрыСервиса.Сервер = ПараметрыЦентраМониторинга.Сервер;
			ПараметрыСервиса.АдресРесурса = ПараметрыЦентраМониторинга.АдресРесурса;
			ПараметрыСервиса.Порт = ПараметрыЦентраМониторинга.Порт;
		ИначеЕсли ЦентрМониторингаРазрешитьОтправлятьДанные = 2 Тогда
			ПараметрыСервиса = Неопределено;	
		КонецЕсли;
		
		Если ПараметрыСервиса <> Неопределено Тогда
			Если ПараметрыСервиса.Порт = 80 Тогда
				Схема = "http://";
				Порт = "";
			ИначеЕсли ПараметрыСервиса.Порт = 443 Тогда
				Схема = "https://";
				Порт = "";
			Иначе
				Схема = "http://";
				Порт = ":" + Формат(ПараметрыСервиса.Порт, "ЧН=0; ЧГ=");
			КонецЕсли;
			
			ЦентрМониторингаАдресСервиса = Схема + ПараметрыСервиса.Сервер + Порт + "/" + ПараметрыСервиса.АдресРесурса;
		Иначе
			ЦентрМониторингаАдресСервиса = "";
		КонецЕсли;
		
		УстановитьДоступностьЦентрМониторингаНаСервере(ЦентрМониторингаРазрешитьОтправлятьДанные);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.ЦентрМониторинга
	
	// Обновление состояния элементов.
	УстановитьДоступность();
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	// СтандартныеПодсистемы.РезервноеКопированиеИБ
	Если ИмяСобытия = "ЗакрытаФормаНастройкиРезервногоКопирования" Тогда
		ОбновитьНастройкиРезервногоКопирования();
	КонецЕсли;
	// Конец СтандартныеПодсистемы.РезервноеКопированиеИБ
	
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии()
	ОбновитьИнтерфейсПрограммы();
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

// СтандартныеПодсистемы.УдалениеПомеченныхОбъектов
&НаКлиенте
Процедура УдалениеПомеченныхИспользованиеПриИзменении(Элемент)
	РегламентныеЗаданияИспользованиеПриИзменении("УдалениеПомеченных");
КонецПроцедуры
// Конец СтандартныеПодсистемы.УдалениеПомеченныхОбъектов

// СтандартныеПодсистемы.ВерсионированиеОбъектов
&НаКлиенте
Процедура ИспользоватьВерсионированиеОбъектовПриИзменении(Элемент)
	Подключаемый_ПриИзмененииРеквизита(Элемент);
КонецПроцедуры
// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов

// СтандартныеПодсистемы.РезервноеКопированиеИБ
&НаКлиенте
Процедура РезервноеКопированиеПрограммыНажатие(Элемент)
	
	ОткрытьФорму("Обработка.РезервноеКопированиеИБ.Форма", , ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура НастройкаРезервногоКопированияНажатие(Элемент)
	
	ОткрытьФорму(РезервноеКопированиеИБКлиент.ИмяФормыНастроекРезервногоКопирования(),, ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ВосстановлениеИзРезервнойКопииНажатие(Элемент)
	
	ОткрытьФорму("Обработка.РезервноеКопированиеИБ.Форма.ВосстановлениеДанныхИзРезервнойКопии", , ЭтотОбъект);
	
КонецПроцедуры
// Конец СтандартныеПодсистемы.РезервноеКопированиеИБ

// СтандартныеПодсистемы.ОценкаПроизводительности
&НаКлиенте
Процедура ВыполнятьЗамерыПроизводительностиПриИзменении(Элемент)
	Подключаемый_ПриИзмененииРеквизита(Элемент);
КонецПроцедуры
// Конец СтандартныеПодсистемы.ОценкаПроизводительности

// СтандартныеПодсистемы.ОбновлениеВерсииИБ
&НаКлиенте
Процедура ДетализироватьОбновлениеИБВЖурналеРегистрацииПриИзменении(Элемент)
	Подключаемый_ПриИзмененииРеквизита(Элемент);
КонецПроцедуры
// Конец СтандартныеПодсистемы.ОбновлениеВерсииИБ

//// СтандартныеПодсистемы.АдресныйКлассификатор
//&НаКлиенте
//Процедура АдресныйКлассификаторПриИзменении(Элемент)
//	
//	Подключаемый_ПриИзмененииРеквизита(Элемент, Ложь);
//	
//КонецПроцедуры
//// Конец СтандартныеПодсистемы.АдресныйКлассификатор

//// СтандартныеПодсистемы.РаботаСКонтрагентами
//&НаКлиенте
//Процедура ИспользоватьПроверкуКонтрагентовПриИзменении(Элемент)
//	
//	Подключаемый_ПриИзмененииРеквизита(Элемент);
//	
//КонецПроцедуры
//// Конец СтандартныеПодсистемы.РаботаСКонтрагентами

// СтандартныеПодсистемы.ЦентрМониторинга
&НаКлиенте
Процедура РазрешитьОтправлятьДанныеПриИзменении(Элемент)
	УстановитьДоступностьЦентрМониторингаНаКлиенте(ЦентрМониторингаРазрешитьОтправлятьДанные);
	Если ЦентрМониторингаРазрешитьОтправлятьДанные = 2 Тогда
		ПараметрыЦентраМониторингаЗапись = Новый Структура("ВключитьЦентрМониторинга, ЦентрОбработкиИнформацииОПрограмме", Ложь, Ложь);
	ИначеЕсли ЦентрМониторингаРазрешитьОтправлятьДанные = 1 Тогда
		ПараметрыЦентраМониторингаЗапись = Новый Структура("ВключитьЦентрМониторинга, ЦентрОбработкиИнформацииОПрограмме", Ложь, Истина);
	ИначеЕсли ЦентрМониторингаРазрешитьОтправлятьДанные = 0 Тогда
		ПараметрыЦентраМониторингаЗапись = Новый Структура("ВключитьЦентрМониторинга, ЦентрОбработкиИнформацииОПрограмме", Истина, Ложь);
	КонецЕсли;
	ЦентрМониторингаАдресСервиса = ПолучитьАдресСервиса();
	РазрешитьОтправлятьДанныеПриИзмененииНаСервере(ПараметрыЦентраМониторингаЗапись);
КонецПроцедуры
// Конец СтандартныеПодсистемы.ЦентрМониторинга

// СтандартныеПодсистемы.ЦентрМониторинга
&НаКлиенте
Процедура ЦентрМониторингаАдресСервисаПриИзменении(Элемент)
	Попытка
		СтруктураАдреса = ОбщегоНазначенияКлиентСервер.СтруктураURI(ЦентрМониторингаАдресСервиса);
		
		Если СтруктураАдреса.Схема = "http" Тогда
			СтруктураАдреса.Вставить("ЗащищенноеСоединение", Ложь);
		ИначеЕсли СтруктураАдреса.Схема = "https" Тогда
			СтруктураАдреса.Вставить("ЗащищенноеСоединение", Истина);
		КонецЕсли;
		
		Если НЕ ЗначениеЗаполнено(СтруктураАдреса.Порт) Тогда
			Если СтруктураАдреса.Схема = "http" Тогда
				СтруктураАдреса.Порт = 80;
			ИначеЕсли СтруктураАдреса.Схема = "https" Тогда
				СтруктураАдреса.Порт = 443;
			КонецЕсли;
		КонецЕсли;
	Исключение
		// Внимание, формат адреса должен соответствовать RFC 3986 
		// см. описание функции ОбщегоНазначенияКлиентСервер.СтруктураURI.
		ОписаниеОшибки = НСтр("ru = 'Адрес сервиса'") + " "
			+ ЦентрМониторингаАдресСервиса + " "
			+ НСтр("ru = 'не является допустимым адресом веб-сервиса для отправки отчетов об использовании программы.'"); 
		ВызватьИсключение(ОписаниеОшибки);
	КонецПопытки;
	
	ЦентрМониторингаАдресСервисаПриИзмененииНаСервере(СтруктураАдреса);
КонецПроцедуры
// Конец СтандартныеПодсистемы.ЦентрМониторинга
#КонецОбласти

#Область ОбработчикиКомандФормы

// СтандартныеПодсистемы.УдалениеПомеченныхОбъектов
&НаКлиенте
Процедура УдалениеПомеченныхНастроитьРасписание(Команда)
	РегламентныеЗаданияГиперссылкаНажатие("УдалениеПомеченных");
КонецПроцедуры
// Конец СтандартныеПодсистемы.УдалениеПомеченныхОбъектов

// СтандартныеПодсистемы.ПоискИУдалениеДублей
&НаКлиенте
Процедура ПоискИУдалениеДублей(Команда)
	
	ОткрытьФорму("Обработка.ПоискИУдалениеДублей.Форма.ПоискДублей");
	
КонецПроцедуры
// Конец СтандартныеПодсистемы.ПоискИУдалениеДублей

// СтандартныеПодсистемы.РегламентныеЗадания
&НаКлиенте
Процедура РазблокироватьРаботуСВнешнимиРесурсами(Команда)
	РазблокироватьРаботуСВнешнимиРесурсамиНаСервере();
КонецПроцедуры
// Конец СтандартныеПодсистемы.РегламентныеЗадания

// СтандартныеПодсистемы.ВерсионированиеОбъектов
&НаКлиенте
Процедура РегистрСведенийНастройкиВерсионированияОбъектов(Команда)
	
	ОткрытьФорму("РегистрСведений.НастройкиВерсионированияОбъектов.ФормаСписка", , ЭтотОбъект);
	
КонецПроцедуры
// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов

// СтандартныеПодсистемы.Валюты
&НаКлиенте
Процедура ОбработкаЗагрузкаКурсовВалют(Команда)
	
	ОткрытьФорму("Обработка.ЗагрузкаКурсовВалют.Форма");
	
КонецПроцедуры
// Конец СтандартныеПодсистемы.Валюты

// СтандартныеПодсистемы.Банки
&НаКлиенте
Процедура ЗагрузитьКлассификаторБанков(Команда)
	
	ОткрытьФорму("Справочник.КлассификаторБанковРФ.Форма.ЗагрузкаКлассификатора");
	
КонецПроцедуры
// Конец СтандартныеПодсистемы.Банки

// СтандартныеПодсистемы.ПолнотекстовыйПоиск
&НаКлиенте
Процедура ОбработкаУправлениеПолнотекстовымПоиском(Команда)
	
	ОткрытьФорму("Обработка.ПанельАдминистрированияБСП.Форма.УправлениеПолнотекстовымПоискомИИзвлечениемТекстов", , ЭтотОбъект);
	
КонецПроцедуры
// Конец СтандартныеПодсистемы.ПолнотекстовыйПоиск

//// СтандартныеПодсистемы.РаботаСКонтрагентами
//&НаКлиенте
//Процедура ПроверитьДоступКСервису(Команда)
//	
//	ПроверкаКонтрагентовКлиент.ПроверитьДоступКСервису();
//	
//КонецПроцедуры
//// Конец СтандартныеПодсистемы.РаботаСКонтрагентами

// СтандартныеПодсистемы.ОбновлениеВерсииИБ
&НаКлиенте
Процедура ОтложеннаяОбработкаДанных(Команда)
	ПараметрыФормы = Новый Структура("ОткрытиеИзПанелиАдминистрирования", Истина);
	ОткрытьФорму("Обработка.РезультатыОбновленияПрограммы.Форма.ИндикацияХодаОтложенногоОбновленияИБ", ПараметрыФормы);
КонецПроцедуры
// Конец СтандартныеПодсистемы.ОбновлениеВерсииИБ

// СтандартныеПодсистемы.ДатыЗапретаИзменения
&НаКлиенте
Процедура НастроитьДатыЗапретаИзменения(Команда)
	
	ОткрытьФорму("РегистрСведений.ДатыЗапретаИзменения.Форма.ДатыЗапретаИзменения");
	
КонецПроцедуры
// Конец СтандартныеПодсистемы.ДатыЗапретаИзменения

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

////////////////////////////////////////////////////////////////////////////////
// Клиент

&НаКлиенте
Процедура Подключаемый_ПриИзмененииРеквизита(Элемент, НеобходимоОбновлятьИнтерфейс = Истина)
	
	КонстантаИмя = ПриИзмененииРеквизитаСервер(Элемент.Имя);
	
	ОбновитьПовторноИспользуемыеЗначения();
	
	Если НеобходимоОбновлятьИнтерфейс Тогда
		ОбновитьИнтерфейс = Истина;
		ПодключитьОбработчикОжидания("ОбновитьИнтерфейсПрограммы", 2, Истина);
	КонецЕсли;
	
	Если КонстантаИмя <> "" Тогда
		Оповестить("Запись_НаборКонстант", Новый Структура, КонстантаИмя);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьИнтерфейсПрограммы()
	
	Если ОбновитьИнтерфейс = Истина Тогда
		ОбновитьИнтерфейс = Ложь;
		ОбщегоНазначенияКлиент.ОбновитьИнтерфейсПрограммы();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура РегламентныеЗаданияИспользованиеПриИзменении(ПрефиксРеквизитов)
	ИмяРеквизитаИспользование = ПрефиксРеквизитов + "Использование";
	Идентификатор = ЭтотОбъект[ПрефиксРеквизитов + "Идентификатор"];
	Если ЭтотОбъект[ИмяРеквизитаИспользование] Тогда
		ЭлементПредставление = Элементы.Найти(ПрефиксРеквизитов + "ПредставлениеРасписания");
		Если ЭлементПредставление = Неопределено Или ЭлементПредставление.Видимость Тогда
			ПараметрыВыполнения = Новый Структура;
			ПараметрыВыполнения.Вставить("Идентификатор", Идентификатор);
			ПараметрыВыполнения.Вставить("ИмяРеквизитаРасписание", ПрефиксРеквизитов + "Расписание");
			ПараметрыВыполнения.Вставить("ИмяРеквизитаИспользование", ИмяРеквизитаИспользование);
			РегламентныеЗаданияИзменитьРасписание(ПараметрыВыполнения);
			Возврат;
		КонецЕсли;
	КонецЕсли;
	Изменения = Новый Структура("Использование", ЭтотОбъект[ИмяРеквизитаИспользование]);
	РегламентныеЗаданияСохранить(Идентификатор, Изменения, ИмяРеквизитаИспользование);
КонецПроцедуры

&НаКлиенте
Процедура РегламентныеЗаданияГиперссылкаНажатие(ПрефиксРеквизитов)
	ПараметрыВыполнения = Новый Структура;
	ПараметрыВыполнения.Вставить("Идентификатор", ЭтотОбъект[ПрефиксРеквизитов + "Идентификатор"]);
	ПараметрыВыполнения.Вставить("ИмяРеквизитаРасписание", ПрефиксРеквизитов + "Расписание");
	
	РегламентныеЗаданияИзменитьРасписание(ПараметрыВыполнения);
КонецПроцедуры

&НаКлиенте
Процедура РегламентныеЗаданияИзменитьРасписание(ПараметрыВыполнения)
	Обработчик = Новый ОписаниеОповещения("РегламентныеЗаданияПослеИзмененияРасписания", ЭтотОбъект, ПараметрыВыполнения);
	Диалог = Новый ДиалогРасписанияРегламентногоЗадания(ЭтотОбъект[ПараметрыВыполнения.ИмяРеквизитаРасписание]);
	Диалог.Показать(Обработчик);
КонецПроцедуры

&НаКлиенте
Процедура РегламентныеЗаданияПослеИзмененияРасписания(Расписание, ПараметрыВыполнения) Экспорт
	Если Расписание = Неопределено Тогда
		Если ПараметрыВыполнения.Свойство("ИмяРеквизитаИспользование") Тогда
			ЭтотОбъект[ПараметрыВыполнения.ИмяРеквизитаИспользование] = Ложь;
		КонецЕсли;
		Возврат;
	КонецЕсли;
	
	ЭтотОбъект[ПараметрыВыполнения.ИмяРеквизитаРасписание] = Расписание;
	
	Изменения = Новый Структура("Расписание", Расписание);
	Если ПараметрыВыполнения.Свойство("ИмяРеквизитаИспользование") Тогда
		ЭтотОбъект[ПараметрыВыполнения.ИмяРеквизитаИспользование] = Истина;
		Изменения.Вставить("Использование", Истина);
	КонецЕсли;
	РегламентныеЗаданияСохранить(ПараметрыВыполнения.Идентификатор, Изменения, ПараметрыВыполнения.ИмяРеквизитаРасписание);
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Вызов сервера

&НаСервере
Функция ПриИзмененииРеквизитаСервер(ИмяЭлемента)
	
	РеквизитПутьКДанным = Элементы[ИмяЭлемента].ПутьКДанным;
	
	КонстантаИмя = СохранитьЗначениеРеквизита(РеквизитПутьКДанным);
	
	УстановитьДоступность(РеквизитПутьКДанным);
	
	ОбновитьПовторноИспользуемыеЗначения();
	
	Возврат КонстантаИмя;
	
КонецФункции

&НаСервере
Процедура РегламентныеЗаданияСохранить(УникальныйИдентификатор, Изменения, РеквизитПутьКДанным)
	РегламентныеЗаданияСервер.ИзменитьЗадание(УникальныйИдентификатор, Изменения);
	Если РеквизитПутьКДанным <> Неопределено Тогда
		УстановитьДоступность(РеквизитПутьКДанным);
	КонецЕсли;
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Сервер

&НаСервере
Функция СохранитьЗначениеРеквизита(РеквизитПутьКДанным)
	
	// Сохранение значений реквизитов, не связанных с константами напрямую.
	Если РеквизитПутьКДанным = "" Тогда
		Возврат "";
	КонецЕсли;
	
	// Определение имени константы.
	КонстантаИмя = "";
	Если НРег(Лев(РеквизитПутьКДанным, 14)) = НРег("НаборКонстант.") Тогда
		// Если путь к данным реквизита указан через "НаборКонстант".
		КонстантаИмя = Сред(РеквизитПутьКДанным, 15);
	Иначе
		// Определение имени и запись значения реквизита в соответствующей константе из "НаборКонстант".
		// Используется для тех реквизитов формы, которые связаны с константами напрямую (в отношении один-к-одному).
	КонецЕсли;
	
	// Сохранения значения константы.
	Если НРег(Лев(РеквизитПутьКДанным, 14)) = НРег("НаборКонстант.") Тогда
		КонстантаМенеджер = Константы[КонстантаИмя];
		КонстантаЗначение = НаборКонстант[КонстантаИмя];
		
		Если КонстантаМенеджер.Получить() <> КонстантаЗначение Тогда
			
			Если КонстантаИмя = "ИспользоватьПроверкуКонтрагентов" Тогда
				
				//// СтандартныеПодсистемы.РаботаСКонтрагентами
				//ВключитьПроверку = КонстантаЗначение = 1;
				//ПроверкаКонтрагентовВызовСервера.ПриВключенииВыключенииПроверки(ВключитьПроверку);
				//// Конец СтандартныеПодсистемы.РаботаСКонтрагентами

			Иначе
				КонстантаМенеджер.Установить(КонстантаЗначение);
			КонецЕсли;
			
		КонецЕсли;
	КонецЕсли;
	
	Возврат КонстантаИмя;
	
КонецФункции

&НаСервере
Процедура УстановитьДоступность(РеквизитПутьКДанным = "")
	
	Если Не РежимРаботы.ЭтоАдминистраторСистемы Тогда
		Возврат;
	КонецЕсли;
	
	// СтандартныеПодсистемы.ДатыЗапретаИзменения
	Если РеквизитПутьКДанным = "НаборКонстант.ИспользоватьДатыЗапретаИзменения"
	 Или РеквизитПутьКДанным = "" Тогда
		
		Элементы.ГруппаДатыЗапретаИзмененияНастройка.Доступность =
			НаборКонстант.ИспользоватьДатыЗапретаИзменения;
	КонецЕсли;
	// Конец СтандартныеПодсистемы.ДатыЗапретаИзменения
	
	// СтандартныеПодсистемы.ОценкаПроизводительности
	Если РеквизитПутьКДанным = "НаборКонстант.ВыполнятьЗамерыПроизводительности"
		Или РеквизитПутьКДанным = "" Тогда
			ЭлементОбработкаОценкаПроизводительности = Элементы.Найти("ОбработкаОценкаПроизводительности");
			ЭлементОбработкаНастройкиОценкиПроизводительности = Элементы.Найти("ОбработкаНастройкиОценкиПроизводительности");
			Если (ЭлементОбработкаОценкаПроизводительности <> Неопределено И ЭлементОбработкаНастройкиОценкиПроизводительности <> Неопределено И НаборКонстант.Свойство("ВыполнятьЗамерыПроизводительности")) Тогда
				ЭлементОбработкаОценкаПроизводительности.Доступность = НаборКонстант.ВыполнятьЗамерыПроизводительности;
				ЭлементОбработкаНастройкиОценкиПроизводительности.Доступность = НаборКонстант.ВыполнятьЗамерыПроизводительности;
			КонецЕсли;
	КонецЕсли;
	// Конец СтандартныеПодсистемы.ОценкаПроизводительности
	
	// СтандартныеПодсистемы.УдалениеПомеченныхОбъектов
	Если Элементы.УдалениеПомеченныхНастроитьРасписание.Видимость
		И (РеквизитПутьКДанным = "УдалениеПомеченныхРасписание"
			Или РеквизитПутьКДанным = "УдалениеПомеченныхИспользование"
			Или РеквизитПутьКДанным = "") Тогда
		Элементы.УдалениеПомеченныхНастроитьРасписание.Доступность   = УдалениеПомеченныхИспользование;
		Элементы.УдалениеПомеченныхПредставлениеРасписания.Видимость = УдалениеПомеченныхИспользование;
		Если УдалениеПомеченныхИспользование Тогда
			РасписаниеПредставление = Строка(УдалениеПомеченныхРасписание);
			Представление = ВРег(Лев(РасписаниеПредставление, 1)) + Сред(РасписаниеПредставление, 2);
		Иначе
			Представление = НСтр("ru = '<Отключено>'");
		КонецЕсли;
		Элементы.УдалениеПомеченныхПредставлениеРасписания.Заголовок = Представление;
	КонецЕсли;
	// Конец СтандартныеПодсистемы.УдалениеПомеченныхОбъектов
	
	// СтандартныеПодсистемы.ВерсионированиеОбъектов
	Если РеквизитПутьКДанным = "НаборКонстант.ИспользоватьВерсионированиеОбъектов"
	 Или РеквизитПутьКДанным = "" Тогда
		
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
			Элементы,
			"РегистрСведенийНастройкиВерсионированияОбъектов",
			"Доступность",
			НаборКонстант.ИспользоватьВерсионированиеОбъектов);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов
	
	//// СтандартныеПодсистемы.АдресныйКлассификатор
	//Если РеквизитПутьКДанным = "НаборКонстант.ИсточникДанныхАдресногоКлассификатора"
	// Или РеквизитПутьКДанным = "" Тогда
	// 
	//	Элементы.ГруппаАдресныйКлассификаторКоманды.Доступность = ПустаяСтрока(НаборКонстант.ИсточникДанныхАдресногоКлассификатора);
	//	
	//КонецЕсли; 
	//// Конец СтандартныеПодсистемы.АдресныйКлассификатор
	
КонецПроцедуры

// СтандартныеПодсистемы.РезервноеКопированиеИБ
&НаСервере
Процедура ОбновитьНастройкиРезервногоКопирования()
	
	Если (РежимРаботы.Локальный Или РежимРаботы.Автономный) И РежимРаботы.ЭтоАдминистраторСистемы Тогда
		Элементы.ПояснениеНастройкаРезервногоКопирования.Заголовок = РезервноеКопированиеИБСервер.ТекущаяНастройкаРезервногоКопирования();
	КонецЕсли;
	
КонецПроцедуры
// Конец СтандартныеПодсистемы.РезервноеКопированиеИБ

&НаСервере
Функция РегламентныеЗаданияНайтиПредопределенное(ИмяПредопределенного)
	Фильтр = Новый Структура("Метаданные", ИмяПредопределенного);
	Найденные = РегламентныеЗаданияСервер.НайтиЗадания(Фильтр);
	Задание = ?(Найденные.Количество() = 0, Неопределено, Найденные[0]);
	Если ТипЗнч(Задание) = Тип("СтрокаТаблицыЗначений") Тогда
		Задание.Владелец().Колонки.Идентификатор.Имя = "УникальныйИдентификатор";
	КонецЕсли;
	Возврат Задание;
КонецФункции

// СтандартныеПодсистемы.ЦентрМониторинга
&НаСервереБезКонтекста
Функция ПолучитьПереключательОтправкиДанных(ВключитьЦентрМониторинга, ЦентрОбработкиИнформацииОПрограмме)
	Состояние = ?(ВключитьЦентрМониторинга, "1", "0") + ?(ЦентрОбработкиИнформацииОПрограмме, "1", "0");
	
	Если Состояние = "00" Тогда
		Результат = 2;
	ИначеЕсли Состояние = "01" Тогда
		Результат = 1;
	ИначеЕсли Состояние = "10" Тогда
		Результат = 0;
	ИначеЕсли Состояние = "11" Тогда
		// А такого быть не может...
	КонецЕсли;
	
	Возврат Результат;
КонецФункции
// Конец СтандартныеПодсистемы.ЦентрМониторинга

// СтандартныеПодсистемы.ЦентрМониторинга
&НаСервере
Процедура УстановитьДоступностьЦентрМониторингаНаСервере(Параметр)
	Если Параметр = 0 Тогда
		Элементы.ЦентрМониторингаАдресСервиса.Доступность = Ложь;
	ИначеЕсли Параметр = 1 Тогда
		Элементы.ЦентрМониторингаАдресСервиса.Доступность = Истина;
	ИначеЕсли Параметр = 2 Тогда
		Элементы.ЦентрМониторингаАдресСервиса.Доступность = Ложь;
	КонецЕсли;
КонецПроцедуры
// Конец СтандартныеПодсистемы.ЦентрМониторинга

// СтандартныеПодсистемы.ЦентрМониторинга
&НаКлиенте
Процедура УстановитьДоступностьЦентрМониторингаНаКлиенте(Параметр)
	Если Параметр = 0 Тогда
		Элементы.ЦентрМониторингаАдресСервиса.Доступность = Ложь;
	ИначеЕсли Параметр = 1 Тогда
		Элементы.ЦентрМониторингаАдресСервиса.Доступность = Истина;
	ИначеЕсли Параметр = 2 Тогда
		Элементы.ЦентрМониторингаАдресСервиса.Доступность = Ложь;
	КонецЕсли;
КонецПроцедуры
// Конец СтандартныеПодсистемы.ЦентрМониторинга

// СтандартныеПодсистемы.ЦентрМониторинга
&НаКлиенте
Функция ПолучитьАдресСервиса()
	
	ПараметрыЦентраМониторинга = ПолучитьПараметрыЦентраМониторинга();
			
	ПараметрыСервиса = Новый Структура("Сервер, АдресРесурса, Порт");
	
	Если ЦентрМониторингаРазрешитьОтправлятьДанные = 0 Тогда
		ПараметрыСервиса.Сервер = ПараметрыЦентраМониторинга.СерверПоУмолчанию;
		ПараметрыСервиса.АдресРесурса = ПараметрыЦентраМониторинга.АдресРесурсаПоУмолчанию;
		ПараметрыСервиса.Порт = ПараметрыЦентраМониторинга.ПортПоУмолчанию;
	ИначеЕсли ЦентрМониторингаРазрешитьОтправлятьДанные = 1 Тогда
		ПараметрыСервиса.Сервер = ПараметрыЦентраМониторинга.Сервер;
		ПараметрыСервиса.АдресРесурса = ПараметрыЦентраМониторинга.АдресРесурса;
		ПараметрыСервиса.Порт = ПараметрыЦентраМониторинга.Порт;
	ИначеЕсли ЦентрМониторингаРазрешитьОтправлятьДанные = 2 Тогда
		ПараметрыСервиса = Неопределено;	
	КонецЕсли;
	
	Если ПараметрыСервиса <> Неопределено Тогда
		Если ПараметрыСервиса.Порт = 80 Тогда
			Схема = "http://";
			Порт = "";
		ИначеЕсли ПараметрыСервиса.Порт = 443 Тогда
			Схема = "https://";
			Порт = "";
		Иначе
			Схема = "http://";
			Порт = ":" + Формат(ПараметрыСервиса.Порт, "ЧН=0; ЧГ=");
		КонецЕсли;
		
		АдресСервиса = Схема + ПараметрыСервиса.Сервер + Порт + "/" + ПараметрыСервиса.АдресРесурса;
	Иначе
		АдресСервиса = "";
	КонецЕсли;
	
	Возврат АдресСервиса;
КонецФункции
// Конец СтандартныеПодсистемы.ЦентрМониторинга

// СтандартныеПодсистемы.ЦентрМониторинга
&НаСервереБезКонтекста
Функция ПолучитьПараметрыЦентраМониторинга()
	МодульЦентрМониторингаСлужебный = ОбщегоНазначения.ОбщийМодуль("ЦентрМониторингаСлужебный");
	ПараметрыЦентраМониторинга = МодульЦентрМониторингаСлужебный.ПолучитьПараметрыЦентраМониторингаВнешнийВызов();
	
	ПараметрыСервисаПоУмолчанию = МодульЦентрМониторингаСлужебный.ПолучитьПараметрыПоУмолчаниюВнешнийВызов();
	ПараметрыЦентраМониторинга.Вставить("СерверПоУмолчанию", ПараметрыСервисаПоУмолчанию.Сервер);
	ПараметрыЦентраМониторинга.Вставить("АдресРесурсаПоУмолчанию", ПараметрыСервисаПоУмолчанию.АдресРесурса);
	ПараметрыЦентраМониторинга.Вставить("ПортПоУмолчанию", ПараметрыСервисаПоУмолчанию.Порт);
	
	Возврат ПараметрыЦентраМониторинга;
КонецФункции
// Конец СтандартныеПодсистемы.ЦентрМониторинга

// СтандартныеПодсистемы.ЦентрМониторинга
&НаСервереБезКонтекста
Процедура РазрешитьОтправлятьДанныеПриИзмененииНаСервере(ПараметрыЦентраМониторинга)
	МодульЦентрМониторингаСлужебный = ОбщегоНазначения.ОбщийМодуль("ЦентрМониторингаСлужебный");
	МодульЦентрМониторингаСлужебный.УстановитьПараметрыЦентраМониторингаВнешнийВызов(ПараметрыЦентраМониторинга);
	
	ВключитьЦентрМониторинга = ПараметрыЦентраМониторинга.ВключитьЦентрМониторинга;
	ЦентрОбработкиИнформацииОПрограмме = ПараметрыЦентраМониторинга.ЦентрОбработкиИнформацииОПрограмме;
	
	Результат = ПолучитьПереключательОтправкиДанных(ВключитьЦентрМониторинга, ЦентрОбработкиИнформацииОПрограмме);
	
	Если Результат = 0 Тогда
		РегЗадание = МодульЦентрМониторингаСлужебный.ПолучитьРегламентноеЗаданиеВнешнийВызов("СборИОтправкаСтатистики", Истина);
		МодульЦентрМониторингаСлужебный.УстановитьРасписаниеПоУмолчаниюВнешнийВызов(РегЗадание);
	ИначеЕсли Результат = 1 Тогда
		РегЗадание = МодульЦентрМониторингаСлужебный.ПолучитьРегламентноеЗаданиеВнешнийВызов("СборИОтправкаСтатистики", Истина);
		МодульЦентрМониторингаСлужебный.УстановитьРасписаниеПоУмолчаниюВнешнийВызов(РегЗадание);
	ИначеЕсли Результат = 2 Тогда
		МодульЦентрМониторингаСлужебный.УдалитьРегламентноеЗаданиеВнешнийВызов("СборИОтправкаСтатистики");
	КонецЕсли;
КонецПроцедуры
// Конец СтандартныеПодсистемы.ЦентрМониторинга

// СтандартныеПодсистемы.ЦентрМониторинга
&НаСервереБезКонтекста
Процедура ЦентрМониторингаАдресСервисаПриИзмененииНаСервере(СтруктураАдреса)
	ПараметрыЦентраМониторинга = Новый Структура();
	ПараметрыЦентраМониторинга.Вставить("Сервер", СтруктураАдреса.Хост);
	ПараметрыЦентраМониторинга.Вставить("АдресРесурса", СтруктураАдреса.ПутьНаСервере);
	ПараметрыЦентраМониторинга.Вставить("Порт", СтруктураАдреса.Порт);
	ПараметрыЦентраМониторинга.Вставить("ЗащищенноеСоединение", СтруктураАдреса.ЗащищенноеСоединение);
	
	МодульЦентрМониторингаСлужебный = ОбщегоНазначения.ОбщийМодуль("ЦентрМониторингаСлужебный");
	МодульЦентрМониторингаСлужебный.УстановитьПараметрыЦентраМониторингаВнешнийВызов(ПараметрыЦентраМониторинга);
КонецПроцедуры
// Конец СтандартныеПодсистемы.ЦентрМониторинга

// СтандартныеПодсистемы.РегламентныеЗадания
&НаСервере
Процедура РазблокироватьРаботуСВнешнимиРесурсамиНаСервере()
	Элементы.ГруппаБлокировкаРаботыСВнешнимиРесурсами.Видимость = Ложь;
	РегламентныеЗаданияСлужебный.РазрешитьРаботуСВнешнимиРесурсами();
КонецПроцедуры
// Конец СтандартныеПодсистемы.РегламентныеЗадания

#КонецОбласти
