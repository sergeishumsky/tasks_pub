////////////////////////////////////////////////////////////////////////////////
// Подсистема "Получение файлов из Интернета".
// 
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Возвращает объект ИнтернетПрокси для доступа в Интернет.
//
// Параметры:
//   URLИлиПротокол - Строка - url в формате [Протокол://]<Сервер>/<Путь к файлу на сервере>,
//                             либо идентификатор протокола (http, ftp, ...).
//
// Возвращаемое значение:
//   ИнтернетПрокси
//
Функция ПолучитьПрокси(Знач URLИлиПротокол) Экспорт
	
#Если Клиент Тогда
	НастройкаПроксиСервера = СтандартныеПодсистемыКлиентПовтИсп.ПараметрыРаботыКлиента().НастройкиПроксиСервера;
#Иначе
	НастройкаПроксиСервера = ПолучениеФайловИзИнтернета.НастройкиПроксиНаСервере();
#КонецЕсли
	Если СтрНайти(URLИлиПротокол, "://") > 0 Тогда
		Протокол = РазделитьURL(URLИлиПротокол).Протокол;
	Иначе
		Протокол = НРег(URLИлиПротокол);
	КонецЕсли;
	Возврат СформироватьИнтернетПрокси(НастройкаПроксиСервера, Протокол);
	
КонецФункции

// Разделяет URL по составным частям: протокол, сервер, путь к ресурсу.
//
// Параметры:
//  URL - Строка - ссылка на ресурс в сети Интернет.
//
// Возвращаемое значение:
//  Структура:
//             Протокол            - Строка - протокол доступа к ресурсу.
//             ИмяСервера          - Строка - сервер, на котором располагается ресурс.
//             ПутьКФайлуНаСервере - Строка - путь к ресурсу на сервере.
//
Функция РазделитьURL(Знач URL) Экспорт
	
	СтруктураURL = ОбщегоНазначенияКлиентСервер.СтруктураURI(URL);
	
	Результат = Новый Структура;
	Результат.Вставить("Протокол", ?(ПустаяСтрока(СтруктураURL.Схема), "http", СтруктураURL.Схема));
	Результат.Вставить("ИмяСервера", СтруктураURL.ИмяСервера);
	Результат.Вставить("ПутьКФайлуНаСервере", СтруктураURL.ПутьНаСервере);
	
	Возврат Результат;
	
КонецФункции

// Разбирает строку URI на составные части и возвращает в виде структуры.
//
Функция СтруктураURI(Знач СтрокаURI) Экспорт
	
	Возврат ОбщегоНазначенияКлиентСервер.СтруктураURI(СтрокаURI);
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

////////////////////////////////////////////////////////////////////////////////
// Экспортные служебные процедуры и функции.

// Функция для получения файла из сети Интернет.
//
// Параметры:
// URL           - строка - url файла в формате:
// НастройкиПолучения   - Структура со свойствами.
//     ПутьДляСохранения    - Строка - путь на сервере (включая имя файла), для сохранения скачанного файла.
//     Пользователь         - Строка - пользователь от имени которого установлено соединение.
//     Пароль               - Строка - пароль пользователя от которого установлено соединение.
//     Порт                 - Число  - порт сервера с которым установлено соединение.
//     Таймаут              - Число  - таймаут на получение файла, в секундах.
//     ЗащищенноеСоединение - Булево - для случая http загрузки флаг указывает,
//                                     что соединение должно производиться через https.
//     ПассивноеСоединение  - Булево - для случая ftp загрузки флаг указывает,
//                                     что соединение должно пассивным (или активным).
//     Заголовки            - Соответствие - см. описание параметра Заголовки объекта HTTPЗапрос.
//
// НастройкаСохранения - соответствие - содержит параметры для сохранения скачанного файла
//                 ключи:
//                 МестоХранения - строка - может содержать 
//                        "Клиент" - клиент,
//                        "Сервер" - сервер,
//                        "ВременноеХранилище" - временное хранилище.
//                 Путь - строка (необязательный параметр) - 
//                        путь к каталогу на клиенте либо на сервере либо адрес во временном хранилище
//                        если не задано будет сгенерировано автоматически.
//
// Возвращаемое значение:
// структура
// успех  - булево - успех или неудача операции
// строка - строка - в случае успеха либо строка-путь сохранения файла
//                   либо адрес во временном хранилище
//                   в случае неуспеха сообщение об ошибке.
//
Функция ПодготовитьПолучениеФайла(Знач URL, Знач НастройкиПолучения, Знач НастройкаСохранения, Знач ЗаписыватьОшибку = Истина) Экспорт
	
	НастройкаСоединения = Новый Соответствие;
	НастройкаСоединения.Вставить("Пользователь", НастройкиПолучения.Пользователь);
	НастройкаСоединения.Вставить("Пароль",       НастройкиПолучения.Пароль);
	НастройкаСоединения.Вставить("Порт",         НастройкиПолучения.Порт);
	НастройкаСоединения.Вставить("Таймаут",      НастройкиПолучения.Таймаут);
	НастройкаСоединения.Вставить("ЗащищенноеСоединение", НастройкиПолучения.ЗащищенноеСоединение);
	
	Протокол = РазделитьURL(URL).Протокол;
	
	Если Протокол = "ftp" Или Протокол = "ftps" Тогда
		НастройкаСоединения.Вставить("ПассивноеСоединение", НастройкиПолучения.ПассивноеСоединение);
	Иначе
		НастройкаСоединения.Вставить("Заголовки",    НастройкиПолучения.Заголовки);
	КонецЕсли;
	
#Если Клиент Тогда
	НастройкаПроксиСервера = СтандартныеПодсистемыКлиентПовтИсп.ПараметрыРаботыКлиента().НастройкиПроксиСервера;
#Иначе
	НастройкаПроксиСервера = ПолучениеФайловИзИнтернета.НастройкиПроксиНаСервере();
#КонецЕсли
	
	Возврат ПолучитьФайлИзИнтернет(URL, НастройкаСохранения, НастройкаСоединения,
		НастройкаПроксиСервера, ЗаписыватьОшибку);
	
КонецФункции

Функция СтруктураПараметровПолученияФайла() Экспорт
	
	ПараметрыПолучения = Новый Структура;
	ПараметрыПолучения.Вставить("ПутьДляСохранения", Неопределено);
	ПараметрыПолучения.Вставить("Пользователь", Неопределено);
	ПараметрыПолучения.Вставить("Пароль", Неопределено);
	ПараметрыПолучения.Вставить("Порт", Неопределено);
	ПараметрыПолучения.Вставить("Таймаут", Неопределено);
	ПараметрыПолучения.Вставить("ЗащищенноеСоединение", Неопределено);
	ПараметрыПолучения.Вставить("ПассивноеСоединение", Неопределено);
	ПараметрыПолучения.Вставить("Заголовки", Новый Соответствие());
	
	Возврат ПараметрыПолучения;
	
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// Локальные служебные процедуры и функции.

// Функция для получения файла из сети Интернет.
//
// Параметры:
// URL - строка - url файла в формате: [Протокол://]<Сервер>/<Путь к файлу на сервере>.
//
// НастройкаСоединения - Соответствие -
//		ЗащищенноеСоединение* - булево - соединение защищенное.
//		ПассивноеСоединение*  - булево - соединение защищенное.
//		Пользователь - строка - пользователь от имени которого установлено соединение.
//		Пароль       - строка - пароль пользователя от которого установлено соединение.
//		Порт         - число  - порт сервера с которым установлено соединение
//		* - взаимоисключающие ключи.
//
// НастройкиПрокси - Соответствие:
//		ИспользоватьПрокси - использовать ли прокси-сервер.
//		НеИспользоватьПроксиДляЛокальныхАдресов - использовать ли прокси-сервер для локальных адресов.
//		ИспользоватьСистемныеНастройки - использовать ли системные настройки прокси-сервера.
//		Сервер       - адрес прокси-сервера.
//		Порт         - порт прокси-сервера.
//		Пользователь - имя пользователя для авторизации на прокси-сервере.
//		Пароль       - пароль пользователя.
//
// НастройкаСохранения - соответствие - содержит параметры для сохранения скачанного файла.
//		МестоХранения - строка - может содержать 
//			"Клиент" - клиент,
//			"Сервер" - сервер,
//			"ВременноеХранилище" - временное хранилище.
//		Путь - строка (необязательный параметр) - путь к каталогу на клиенте либо на сервере, 
//			либо адрес во временном хранилище,  если не задано будет сгенерировано автоматически.
//
// Возвращаемое значение:
// структура
// успех  - булево - успех или неудача операции
// строка - строка - в случае успеха либо строка-путь сохранения файла
//                   либо адрес во временном хранилище
//                   в случае неуспеха сообщение об ошибке.
//
Функция ПолучитьФайлИзИнтернет(Знач URL, Знач НастройкаСохранения, Знач НастройкаСоединения = Неопределено,
	Знач НастройкиПрокси = Неопределено, Знач ЗаписыватьОшибку = Истина)
	
	// Объявление переменных перед первым использованием в качестве
	// параметра метода Свойство, при анализе параметров получения файлов
	// из ПараметрыПолучения. Содержат значения переданных параметров получения файла.
	Перем ИмяСервера, ИмяПользователя, Пароль, Порт,
	      ЗащищенноеСоединение,ПассивноеСоединение,
	      ПутьКФайлуНаСервере, Протокол;
	
	URLРазделенный = РазделитьURL(URL);
	
	ИмяСервера           = URLРазделенный.ИмяСервера;
	ПутьКФайлуНаСервере  = URLРазделенный.ПутьКФайлуНаСервере;
	Протокол             = URLРазделенный.Протокол;
	
	ЗащищенноеСоединение = НастройкаСоединения.Получить("ЗащищенноеСоединение");
	ПассивноеСоединение  = НастройкаСоединения.Получить("ПассивноеСоединение");
	
	ИмяПользователя      = НастройкаСоединения.Получить("Пользователь");
	ПарольПользователя   = НастройкаСоединения.Получить("Пароль");
	Порт                 = НастройкаСоединения.Получить("Порт");
	Таймаут              = НастройкаСоединения.Получить("Таймаут");
	Заголовки            = НастройкаСоединения.Получить("Заголовки");
	
	Если (Протокол = "https" Или Протокол = "ftps") И ЗащищенноеСоединение = Неопределено Тогда
		ЗащищенноеСоединение = Истина;
	КонецЕсли;
	
	Если ЗащищенноеСоединение = Истина Тогда
		ЗащищенноеСоединение = Новый ЗащищенноеСоединениеOpenSSL;
	ИначеЕсли ЗащищенноеСоединение = Ложь Тогда
		ЗащищенноеСоединение = Неопределено;
	// Иначе параметр ЗащищенноеСоединение был задан в явном виде.
	КонецЕсли;
	
	Если Порт = Неопределено Тогда
		ПолнаяСтруктураURL = ОбщегоНазначенияКлиентСервер.СтруктураURI(URL);
		Если НЕ ПустаяСтрока(ПолнаяСтруктураURL.Порт) Тогда
			ИмяСервера = ПолнаяСтруктураURL.Хост;
			Порт = ПолнаяСтруктураURL.Порт;
		КонецЕсли;
	КонецЕсли;
	
	Прокси = ?(НастройкиПрокси <> Неопределено, СформироватьИнтернетПрокси(НастройкиПрокси, Протокол), Неопределено);
	ИспользуетсяFTPПротокол = (Протокол = "ftp" Или Протокол = "ftps");
	
	Если ИспользуетсяFTPПротокол Тогда
		Попытка
			Соединение = Новый FTPСоединение(ИмяСервера, Порт, ИмяПользователя, ПарольПользователя,
				Прокси, ПассивноеСоединение, Таймаут, ЗащищенноеСоединение);
		Исключение
			ИнформацияОбОшибке = ИнформацияОбОшибке();
			СообщениеОбОшибке = НСтр("ru = 'Не удалось установить FTP-соединение с сервером %1:'") + Символы.ПС + "%2";
			
			ЗаписатьОшибкуВЖурналРегистрации(СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(СообщениеОбОшибке, ИмяСервера,
				ПодробноеПредставлениеОшибки(ИнформацияОбОшибке)));
			СообщениеОбОшибке = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(СообщениеОбОшибке, ИмяСервера, КраткоеПредставлениеОшибки(ИнформацияОбОшибке));
			Возврат СформироватьРезультат(Ложь, СообщениеОбОшибке);
		КонецПопытки;
		
	Иначе
		
		Попытка
			Соединение = Новый HTTPСоединение(ИмяСервера, Порт, ИмяПользователя, ПарольПользователя, Прокси, Таймаут, ЗащищенноеСоединение);
		Исключение
			ИнформацияОбОшибке = ИнформацияОбОшибке();
			СообщениеОбОшибке = НСтр("ru = 'Не удалось установить HTTP-соединение с сервером %1:
			|%2'");
			ЗаписатьОшибкуВЖурналРегистрации(СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(СообщениеОбОшибке, ИмяСервера, ПодробноеПредставлениеОшибки(ИнформацияОбОшибке)));
			СообщениеОбОшибке = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(СообщениеОбОшибке, ИмяСервера, КраткоеПредставлениеОшибки(ИнформацияОбОшибке));
			Возврат СформироватьРезультат(Ложь, СообщениеОбОшибке);
		КонецПопытки;
	КонецЕсли;
	
	Если НастройкаСохранения["Путь"] <> Неопределено Тогда
		ПутьДляСохранения = НастройкаСохранения["Путь"];
	Иначе
		#Если НЕ ВебКлиент Тогда
			ПутьДляСохранения = ПолучитьИмяВременногоФайла();
		#КонецЕсли
	КонецЕсли;
	
	HTTPОтвет = Неопределено;
	
	Попытка
		
		Если ИспользуетсяFTPПротокол Тогда
			Соединение.Получить(ПутьКФайлуНаСервере, ПутьДляСохранения);
		Иначе
			
			HTTPЗапрос = Новый HTTPЗапрос(ПутьКФайлуНаСервере, Заголовки);
			HTTPЗапрос.Заголовки.Вставить("Accept-Charset", "utf-8");
			HTTPОтвет = Соединение.Получить(HTTPЗапрос, ПутьДляСохранения);
			
			Если HTTPОтвет.КодСостояния = 301 Тогда
				НовыйURL = HTTPОтвет.Заголовки["Location"];
				Возврат ПолучитьФайлИзИнтернет(НовыйURL, НастройкаСохранения, НастройкаСоединения, НастройкиПрокси, ЗаписыватьОшибку);
			КонецЕсли;
			
			Если HTTPОтвет.КодСостояния < 200 Или HTTPОтвет.КодСостояния >= 300 Тогда
				ФайлОтвета = Новый ЧтениеТекста(ПутьДляСохранения, КодировкаТекста.UTF8);
				Если HTTPОтвет.КодСостояния = 304 
					И (HTTPЗапрос.Заголовки["If-Modified-Since"] <> Неопределено
					Или HTTPЗапрос.Заголовки["If-None-Match"] <> Неопределено) Тогда
						ЗаписыватьОшибку = Ложь;
				КонецЕсли;
				ВызватьИсключение СтроковыеФункцииКлиентСервер.ИзвлечьТекстИзHTML(ФайлОтвета.Прочитать(5 * 1024));
			КонецЕсли;
			
		КонецЕсли;
		
	Исключение
		ИнформацияОбОшибке = ИнформацияОбОшибке();
		СообщениеОбОшибке = НСтр("ru = 'Не удалось получить файл с сервера %1:'") + Символы.ПС + "%2";
		Если ЗаписыватьОшибку Тогда
			ЗаписатьОшибкуВЖурналРегистрации(
				СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(СообщениеОбОшибке, ИмяСервера, ПодробноеПредставлениеОшибки(ИнформацияОбОшибке)));
		КонецЕсли;
		Возврат СформироватьРезультат(Ложь, КраткоеПредставлениеОшибки(ИнформацияОбОшибке), HTTPОтвет);
	КонецПопытки;
	
	// Если сохраняем файл в соответствии с настройкой.
	Если НастройкаСохранения["МестоХранения"] = "ВременноеХранилище" Тогда
		КлючУникальности = Новый УникальныйИдентификатор;
		Адрес = ПоместитьВоВременноеХранилище (Новый ДвоичныеДанные(ПутьДляСохранения), КлючУникальности);
		Возврат СформироватьРезультат(Истина, Адрес, HTTPОтвет);
	ИначеЕсли НастройкаСохранения["МестоХранения"] = "Клиент"
	      ИЛИ НастройкаСохранения["МестоХранения"] = "Сервер" Тогда
		Возврат СформироватьРезультат(Истина, ПутьДляСохранения, HTTPОтвет);
	Иначе
		Возврат Неопределено;
	КонецЕсли;
	
КонецФункции

// Возвращает прокси по настройкам НастройкаПроксиСервера для заданного протокола Протокол.
//
// Параметры:
//   НастройкаПроксиСервера - Соответствие:
//		ИспользоватьПрокси - использовать ли прокси-сервер.
//		НеИспользоватьПроксиДляЛокальныхАдресов - использовать ли прокси-сервер для локальных адресов.
//		ИспользоватьСистемныеНастройки - использовать ли системные настройки прокси-сервера.
//		Сервер       - адрес прокси-сервера.
//		Порт         - порт прокси-сервера.
//		Пользователь - имя пользователя для авторизации на прокси-сервере.
//		Пароль       - пароль пользователя.
//   Протокол - строка - протокол для которого устанавливаются параметры прокси сервера, например "http", "https",
//                       "ftp".
// 
// Возвращаемое значение:
//   ИнтернетПрокси
// 
Функция СформироватьИнтернетПрокси(НастройкаПроксиСервера, Протокол)
	
	Если НастройкаПроксиСервера = Неопределено Тогда
		// Системные установки прокси-сервера.
		Возврат Неопределено;
	КонецЕсли;	
	
	ИспользоватьПрокси = НастройкаПроксиСервера.Получить("ИспользоватьПрокси");
	Если Не ИспользоватьПрокси Тогда
		// Не использовать прокси-сервер.
		Возврат Новый ИнтернетПрокси(Ложь);
	КонецЕсли;
	
	ИспользоватьСистемныеНастройки = НастройкаПроксиСервера.Получить("ИспользоватьСистемныеНастройки");
	Если ИспользоватьСистемныеНастройки Тогда
		// Системные настройки прокси-сервера.
		Возврат Новый ИнтернетПрокси(Истина);
	КонецЕсли;
			
	// Настройки прокси-сервера, заданные вручную.
	Прокси = Новый ИнтернетПрокси;
	
	// Определение адреса и порта прокси-сервера.
	ДополнительныеНастройки = НастройкаПроксиСервера.Получить("ДополнительныеНастройкиПрокси");
	ПроксиПоПротоколу = Неопределено;
	Если ТипЗнч(ДополнительныеНастройки) = Тип("Соответствие") Тогда
		ПроксиПоПротоколу = ДополнительныеНастройки.Получить(Протокол);
	КонецЕсли;
	
	Если ТипЗнч(ПроксиПоПротоколу) = Тип("Структура") Тогда
		Прокси.Установить(Протокол, ПроксиПоПротоколу.Адрес, ПроксиПоПротоколу.Порт,
			НастройкаПроксиСервера["Пользователь"], НастройкаПроксиСервера["Пароль"]);
	Иначе
		Прокси.Установить(Протокол, НастройкаПроксиСервера["Сервер"], НастройкаПроксиСервера["Порт"], 
			НастройкаПроксиСервера["Пользователь"], НастройкаПроксиСервера["Пароль"]);
	КонецЕсли;
	
	Прокси.НеИспользоватьПроксиДляЛокальныхАдресов = НастройкаПроксиСервера["НеИспользоватьПроксиДляЛокальныхАдресов"];
	
	АдресаИсключений = НастройкаПроксиСервера.Получить("НеИспользоватьПроксиДляАдресов");
	Если ТипЗнч(АдресаИсключений) = Тип("Массив") Тогда
		Для каждого АдресИсключения Из АдресаИсключений Цикл
			Прокси.НеИспользоватьПроксиДляАдресов.Добавить(АдресИсключения);
		КонецЦикла;
	КонецЕсли;
			
	Возврат Прокси;
	
КонецФункции

// Функция, заполняющая структуру по параметрам.
//
// Параметры:
// УспехОперации - булево - успех или неуспех операции.
// СообщениеПуть - строка - 
//
// Возвращаемое значение - структура:
//          поле успех - булево
//          поле путь  - строка.
//
Функция СформироватьРезультат(Знач Статус, Знач СообщениеПуть, HTTPОтвет = Неопределено)
	
	Результат = Новый Структура("Статус", Статус);
	
	Если Статус Тогда
		Результат.Вставить("Путь", СообщениеПуть);
	Иначе
		Результат.Вставить("СообщениеОбОшибке", СообщениеПуть);
	КонецЕсли;
	
	Если HTTPОтвет <> Неопределено Тогда
		ЗаголовкиОтвета = HTTPОтвет.Заголовки;
		Если ЗаголовкиОтвета <> Неопределено Тогда
			Результат.Вставить("Заголовки", ЗаголовкиОтвета);
		КонецЕсли;
		
		Результат.Вставить("КодСостояния", HTTPОтвет.КодСостояния);
		
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

// Записывает событие-ошибку в журнал регистрации. Имя события
// "Получение файлов из Интернета".
// Параметры:
//   СообщениеОбОшибке - строка сообщение об ошибке.
// 
Процедура ЗаписатьОшибкуВЖурналРегистрации(Знач СообщениеОбОшибке)
	
#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
	ЗаписьЖурналаРегистрации(
		СобытиеЖурналаРегистрации(),
		УровеньЖурналаРегистрации.Ошибка, , ,
		СообщениеОбОшибке);
#Иначе
	ЖурналРегистрацииКлиент.ДобавитьСообщениеДляЖурналаРегистрации(СобытиеЖурналаРегистрации(),
		"Ошибка", СообщениеОбОшибке,,Истина);
#КонецЕсли
	
КонецПроцедуры

Функция СобытиеЖурналаРегистрации() Экспорт
	
	Возврат НСтр("ru = 'Получение файлов из Интернета'", ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка());
	
КонецФункции

#КонецОбласти
