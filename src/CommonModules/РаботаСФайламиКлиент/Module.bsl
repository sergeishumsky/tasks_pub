////////////////////////////////////////////////////////////////////////////////
// Подсистема "Работа с файлами".
//
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

////////////////////////////////////////////////////////////////////////////////
// Команды работы с файлами

// Открывает файл для просмотра.
//
// Параметры:
//  ДанныеФайла - Структура - структура с данными файла.
//
Процедура Открыть(ДанныеФайла) Экспорт
	
	РаботаСФайламиСлужебныйКлиент.ОткрытьФайлСОповещением(Неопределено, ДанныеФайла);
	
КонецПроцедуры

// Открывает каталог на локальном компьютере в котором размещен этот файл.
//
// Параметры:
//  ДанныеФайла - Структура - структура с данными файла.
//
Процедура ОткрытьКаталогФайла(ДанныеФайла) Экспорт
	
	РаботаСФайламиСлужебныйКлиент.КаталогФайла(Неопределено, ДанныеФайла);
	
КонецПроцедуры

// Создает новый файл интерактивно.
//
// Параметры:
//   ОбработчикРезультата - ОписаниеОповещения - Описание процедуры, принимающей
//                          результат работы метода.
//
//   ВладелецФайла - ЛюбаяСсылка - определяет группу, в которой создается Элемент.
//
//   ФормаВладелец - УправляемаяФорма - форма, из которой вызвано создание файла.
//
//   РежимСоздания - режим создания файла:
//       - Неопределено - значение по умолчанию. Показать диалог выбора режима создания файла.
//       - Число - Создать файл указанным способом:
//           * 1 - из шаблона (копированием другого файла),
//           * 2 - с диска (из файловой системы клиента),
//           * 3 - со сканера.
//
//   НеОткрыватьКарточку - Булево - действие после создания:
//       * Ложь - Значение по умолчанию. Открывать карточку файла после создания.
//       * Истина - Не открывать карточку файла после создания.
//
Процедура ДобавитьФайл(ОбработчикРезультата,
	ВладелецФайла,
	ФормаВладелец,
	РежимСоздания = Неопределено,
	НеОткрыватьКарточку = Ложь) Экспорт
	
	Если РежимСоздания = Неопределено Тогда
		РаботаСФайламиСлужебныйКлиент.ДобавитьФайл(ОбработчикРезультата, ВладелецФайла, ФормаВладелец, , НеОткрыватьКарточку);
	Иначе
		ПараметрыВыполнения = Новый Структура;
		ПараметрыВыполнения.Вставить("ОбработчикРезультата", ОбработчикРезультата);
		ПараметрыВыполнения.Вставить("ВладелецФайла", ВладелецФайла);
		ПараметрыВыполнения.Вставить("ФормаВладелец", ФормаВладелец);
		ПараметрыВыполнения.Вставить("НеОткрыватьКарточкуПослеСозданияИзФайла", НеОткрыватьКарточку);
		РаботаСФайламиСлужебныйКлиент.ДобавитьПослеВыбораРежимаСоздания(РежимСоздания, ПараметрыВыполнения);
	КонецЕсли;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Дополнительные процедуры и функции для работы с файлами.

// Открывает форму для настройки рабочего каталога.
Процедура ОткрытьФормуНастройкиРабочегоКаталога() Экспорт
	
	ОткрытьФорму("ОбщаяФорма.НастройкаОсновногоРабочегоКаталога");
	
КонецПроцедуры

// Задает вопрос о продолжении закрытия формы если в форме остались захваченные файлы.
// Вызывается из ПередЗакрытием форм с файлами.
//
// По ссылке объекта проверяет остались ли захваченные файлы.
// Если захваченные файлы остались:
// - В параметре Отказ устанавливается значение Истина,
// - Пользователю задается вопрос.
// Если пользователь ответил утвердительно, тогда форма снова закрывается.
//
// Параметры:
//   Форма        - УправляемаяФорма - форма, в которой можно редактировать файл.
//   Отказ        - Булево - параметр события ПередЗакрытием.
//   ОбъектСсылка - ЛюбаяСсылка - ссылка на владельца файла.
//   ИмяРеквизита - Строка - имя реквизита типа Булево, в котором хранится признак того,
//                  что вопрос уже выводился.
//
// Пример:
//	&НаКлиенте
//	Процедура ПередЗакрытием(Отказ, СтандартнаяОбработка)
//		РаботаСФайламиКлиент.ПоказатьПодтверждениеЗакрытияФормыСФайлами(ЭтотОбъект, Отказ, Объект.Ссылка);
//		// <Если есть другой код:>.
//		Если Отказ Тогда
//			Возврат;
//		КонецЕсли;
//		// <Другой прикладной код...>.
//	КонецПроцедуры
//
Процедура ПоказатьПодтверждениеЗакрытияФормыСФайлами(Форма, Отказ, ОбъектСсылка, ИмяРеквизита = "МожноЗакрытьФормуСФайлами") Экспорт
	
	Если Форма[ИмяРеквизита] Тогда
		Возврат;
	КонецЕсли;
	
	Количество = РаботаСФайламиСлужебныйВызовСервера.КоличествоФайловЗанятыхТекущимПользователем(ОбъектСсылка);
	Если Количество = 0 Тогда
		Возврат;
	КонецЕсли;
	
	Отказ = Истина;
	ТекстВопроса = НСтр("ru = 'Один или несколько файлов заняты вами для редактирования.
	                          |
	                          |Продолжить?'");
	ОбщегоНазначенияКлиент.ПоказатьПодтверждениеЗакрытияПроизвольнойФормы(Форма, Отказ, ТекстВопроса, ИмяРеквизита);
	
КонецПроцедуры

// Копирует существующий файл.
//
// Параметры:
//  ВладелецФайла - ЛюбаяСсылка - владелец файла.
//  ФайлОснование - СправочникСсылка - откуда копируется Файл.
//
Процедура СкопироватьФайл(ВладелецФайла, ФайлОснование) Экспорт
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("ФайлОснование", ФайлОснование);
	ПараметрыФормы.Вставить("ВладелецФайла", ВладелецФайла);
	
	ОткрытьФорму("Справочник.Файлы.ФормаОбъекта", ПараметрыФормы);
	
КонецПроцедуры

// Выполняет печать файлов.
//
// Параметры:
//  ДанныеФайлов       - Массив - массив структур с данными файлов.
//  ИдентификаторФормы - УникальныйИдентификатор - идентификатор управляемой формы.
//
Процедура НапечататьФайлы(ДанныеФайлов, УникальныйИдентификатор = Неопределено) Экспорт
	
	ПараметрыВыполнения = Новый Структура;
	ПараметрыВыполнения.Вставить("НомерФайла", 0);
	ПараметрыВыполнения.Вставить("ДанныеФайлов", ДанныеФайлов);
	ПараметрыВыполнения.Вставить("УникальныйИдентификатор", УникальныйИдентификатор);
	Обработчик = Новый ОписаниеОповещения("НапечататьФайлыВыполнение", ЭтотОбъект, ПараметрыВыполнения);
	ВыполнитьОбработкуОповещения(Обработчик);
	
КонецПроцедуры

// Процедура печати Файла
//
// Параметры:
//  ОбработчикРезультата - ОписаниеОповещения для дальнейшего вызова.
//  ПараметрыВыполнения  - Структура - со свойствами:
//        * НомерФайла               - Число - номер текущего файла,
//        * ДанныеФайла              - Структура - данные файла,
//        * УникальныйИдентификатор  - УникальныйИдентификатор.
//
Процедура НапечататьФайлыВыполнение(ОбработчикРезультата, ПараметрыВыполнения) Экспорт
	
	ОбработкаПрерыванияПользователя();
	
	Если ПараметрыВыполнения.НомерФайла >= ПараметрыВыполнения.ДанныеФайлов.Количество() Тогда
		Возврат;
	КонецЕсли;
	ДанныеФайла = ПараметрыВыполнения.ДанныеФайлов[ПараметрыВыполнения.НомерФайла];
	
	Обработчик = Новый ОписаниеОповещения("НапечататьФайлПослеПолученияВерсииВРабочийКаталог", ЭтотОбъект, ПараметрыВыполнения);
	РаботаСФайламиСлужебныйКлиент.ПолучитьФайлВерсииВРабочийКаталог(
		Обработчик,
		ДанныеФайла,
		"",
		ПараметрыВыполнения.УникальныйИдентификатор);
	
КонецПроцедуры

// Процедура печати Файла после получения на диск
//
// Параметры:
//  ПараметрыВыполнения  - Структура - со свойствами:
//        * НомерФайла               - Число - номер текущего файла,
//        * ДанныеФайла              - Структура - данные файла,
//        * УникальныйИдентификатор  - УникальныйИдентификатор.
//
Процедура НапечататьФайлПослеПолученияВерсииВРабочийКаталог(Результат, ПараметрыВыполнения) Экспорт

	Если Результат.ФайлПолучен Тогда
		
		Если ПараметрыВыполнения.НомерФайла >= ПараметрыВыполнения.ДанныеФайлов.Количество() Тогда
			Возврат;
		КонецЕсли;
		ДанныеФайла = ПараметрыВыполнения.ДанныеФайлов[ПараметрыВыполнения.НомерФайла];
	
		НапечататьФайлПриложением(ДанныеФайла, Результат.ПолноеИмяФайла);
		
	КонецЕсли;

	// переходим к печати следующего файла
	ПараметрыВыполнения.НомерФайла = ПараметрыВыполнения.НомерФайла + 1;
	Обработчик = Новый ОписаниеОповещения("НапечататьФайлыВыполнение", ЭтотОбъект, ПараметрыВыполнения);
	ВыполнитьОбработкуОповещения(Обработчик);
	
КонецПроцедуры

// Выполняет печать файла внешним приложением.
//
// Параметры
//  ИмяОткрываемогоФайла - Строка - полное имя файла.
//
Процедура НапечататьИзПриложенияПоИмениФайла(ИмяОткрываемогоФайла) Экспорт
	
	Если Не ЗначениеЗаполнено(ИмяОткрываемогоФайла) Тогда
		Возврат;
	КонецЕсли;
		
	СистемнаяИнфо = Новый СистемнаяИнформация;
	Если СистемнаяИнфо.ТипПлатформы = ТипПлатформы.Windows_x86 
	 Или СистемнаяИнфо.ТипПлатформы = ТипПлатформы.Windows_x86_64 Тогда
		
		Shell = Новый COMОбъект("Shell.Application");
		Shell.ShellExecute(ИмяОткрываемогоФайла, "", "", "print", 1);
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Процедура предназначена для печати файла соответствующим приложением
//
// Параметры
//  ДанныеФайла          - Структура - данные файла.
//  ИмяОткрываемогоФайла - Строка - полное имя файла.
//
Процедура НапечататьФайлПриложением(ДанныеФайла, ИмяОткрываемогоФайла)
	
	РасширенияИсключения = 
	" m3u, m4a, mid, midi, mp2, mp3, mpa, rmi, wav, wma, 
	| 3g2, 3gp, 3gp2, 3gpp, asf, asx, avi, m1v, m2t, m2ts, m2v, m4v, mkv, mov, mp2v, mp4, mp4v, mpe, mpeg, mts, vob, wm, wmv, wmx, wvx,
	| 7z, zip, rar, arc, arh, arj, ark, p7m, pak, package, 
	| app, com, exe, jar, dll, res, iso, isz, mdf, mds,
	| cf, dt, epf, erf";
	
	Расширение = НРег(ДанныеФайла.Расширение);
	Если СтрНайти(РасширенияИсключения, " "+Расширение+",") > 0 Тогда 
		
		Возврат;
	
	ИначеЕсли Расширение = "grs" Тогда
		
		Схема = Новый ГрафическаяСхема; 
		Схема.Прочитать(ИмяОткрываемогоФайла);
		Схема.Напечатать();;
		
	ИначеЕсли Расширение = "mxl" Тогда
		
		ТабличныйДокумент = Новый ТабличныйДокумент;
		ТабличныйДокумент.Прочитать(ИмяОткрываемогоФайла);
		ТабличныйДокумент.Напечатать();
		
	Иначе
		
		Попытка
			
			СистемнаяИнфо = Новый СистемнаяИнформация;
			Если СистемнаяИнфо.ТипПлатформы = ТипПлатформы.Windows_x86 
				Или СистемнаяИнфо.ТипПлатформы = ТипПлатформы.Windows_x86_64 Тогда
				ИмяОткрываемогоФайла = СтрЗаменить(ИмяОткрываемогоФайла, "/", "\");
			КонецЕсли;
			
			НапечататьИзПриложенияПоИмениФайла(ИмяОткрываемогоФайла);
			
		Исключение
			
			Инфо = ИнформацияОбОшибке();
			ПоказатьПредупреждение(,СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Описание=""%1""'"),
				КраткоеПредставлениеОшибки(Инфо))); 
			
		КонецПопытки;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
