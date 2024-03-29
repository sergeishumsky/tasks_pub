
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	// Значения реквизитов формы
	РежимРаботы = ОбщегоНазначенияПовтИсп.РежимРаботыПрограммы();
	РежимРаботы = Новый ФиксированнаяСтруктура(РежимРаботы);
	
	Если Параметры.Свойство("ВладелецФайла") Тогда
		ТекущийВладелецФайла = ОбщегоНазначения.ИдентификаторОбъектаМетаданных(ТипЗнч(Параметры.ВладелецФайла));
		ВладелецФайла = Параметры.ВладелецФайла;
	КонецЕсли;
	
	ЗаполнитьТипыОбъектовВДеревеЗначений();
	
	АвтоматическиСинхронизироватьФайлы = АвтоматическаяСинхронизацияВключена();
	Элементы.Расписание.Заголовок      = ТекущееРасписание();
	
	Элементы.Расписание.Доступность = АвтоматическиСинхронизироватьФайлы;
	Элементы.НастроитьРасписание.Доступность = АвтоматическиСинхронизироватьФайлы;
	
	Если РежимРаботы.МодельСервиса Тогда
		Элементы.НастроитьРасписание.Видимость = Ложь;
		Элементы.Расписание.Видимость = Ложь;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура АвтоматическиСинхронизироватьФайлыПриИзменении(Элемент)
	
	УстановитьПараметрРегламентногоЗадания("Использование", АвтоматическиСинхронизироватьФайлы);
	Элементы.Расписание.Доступность = АвтоматическиСинхронизироватьФайлы;
	Элементы.НастроитьРасписание.Доступность = АвтоматическиСинхронизироватьФайлы;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаВыбора(ВыбранноеЗначение, ИсточникВыбора)
	
	Если ИсточникВыбора.ИмяФормы = "РегистрСведений.НастройкиСинхронизацииФайлов.Форма.ФормаЗаписиНастройки" Тогда
		ДобавитьНастройкиПоВладельцу(ВыбранноеЗначение);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыДеревоОбъектовМетаданных

&НаКлиенте
Процедура ДеревоОбъектовМетаданныхСинхронизироватьПриИзменении(Элемент)
	
	ТекущиеДанные = Элементы.ДеревоОбъектовМетаданных.ТекущиеДанные;
	
	Если Не ЗначениеЗаполнено(ТекущиеДанные.УчетнаяЗапись) Тогда
		ТекущиеДанные.Синхронизировать = Ложь;
		ОткрытьФормуНастроек();
		Возврат;
	КонецЕсли;
	
	Если ТекущиеДанные.ПолучитьЭлементы().Количество() > 0 Тогда
		УстановитьЗначениеСинхронизацииПодчиненнымОбъектам(ТекущиеДанные.Синхронизировать);
	Иначе
		ЗаписатьТекущиеНастройки();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ДеревоОбъектовМетаданныхВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	Если Поле.Имя = "ДеревоОбъектовМетаданныхПравилоОтбора" Тогда
		СтандартнаяОбработка = Ложь;
		ОткрытьФормуНастроек();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ДеревоОбъектовМетаданныхПравилоОтбораНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ОткрытьФормуНастроек();
	
КонецПроцедуры

&НаКлиенте
Процедура ДеревоОбъектовМетаданныхОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ДобавитьНастройкиПоВладельцу(ВыбранноеЗначение);

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура НастроитьРасписание(Команда)
	ДиалогРасписания = Новый ДиалогРасписанияРегламентногоЗадания(ТекущееРасписание());
	ОписаниеОповещения = Новый ОписаниеОповещения("НастроитьРасписаниеЗавершение", ЭтотОбъект);
	ДиалогРасписания.Показать(ОписаниеОповещения);
КонецПроцедуры

&НаКлиенте
Процедура СинхронизацияЭлемента(Команда)
	
	СтрокаДерева = Элементы.ДеревоОбъектовМетаданных.ТекущиеДанные;
	Если Не СтрокаДерева.ВозможностьДетализации Тогда
		ТекстСообщения = НСтр("ru = 'Добавление настройки возможно только для иерархических справочников'");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения);
		Возврат;
	КонецЕсли;
	
	ПараметрыФормыВыбора = Новый Структура;
	
	ПараметрыФормыВыбора.Вставить("ВыборГруппИЭлементов", ИспользованиеГруппИЭлементов.ГруппыИЭлементы);
	ПараметрыФормыВыбора.Вставить("ЗакрыватьПриВыборе", Истина);
	ПараметрыФормыВыбора.Вставить("ЗакрыватьПриЗакрытииВладельца", Истина);
	ПараметрыФормыВыбора.Вставить("МножественныйВыбор", Истина);
	ПараметрыФормыВыбора.Вставить("РежимВыбора", Истина);
	
	ПараметрыФормыВыбора.Вставить("РежимОткрытияОкна", РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	ПараметрыФормыВыбора.Вставить("ВыборГрупп", Истина);
	ПараметрыФормыВыбора.Вставить("ВыборГруппПользователей", Истина);
	
	ПараметрыФормыВыбора.Вставить("РасширенныйПодбор", Истина);
	ПараметрыФормыВыбора.Вставить("ЗаголовокФормыПодбора", НСтр("ru = 'Подбор элементов настроек'"));
	
	// Исключим из списка выбора уже существующие настройки.
	СуществующиеНастройки = СтрокаДерева.ПолучитьЭлементы();
	ФиксированныеНастройки = Новый НастройкиКомпоновкиДанных;
	ЭлементНастройки = ФиксированныеНастройки.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ЭлементНастройки.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Ссылка");
	ЭлементНастройки.ВидСравнения = ВидСравненияКомпоновкиДанных.НеВСписке;
	СписокСуществующих = Новый Массив;
	Для Каждого Настройка Из СуществующиеНастройки Цикл
		СписокСуществующих.Добавить(Настройка.ВладелецФайла);
	КонецЦикла;
	ЭлементНастройки.ПравоеЗначение = СписокСуществующих;
	ЭлементНастройки.Использование = Истина;
	ЭлементНастройки.РежимОтображения = РежимОтображенияЭлементаНастройкиКомпоновкиДанных.Недоступный;
	ПараметрыФормыВыбора.Вставить("ФиксированныеНастройки", ФиксированныеНастройки);
	
	ОткрытьФорму(ПутьФормыВыбора(СтрокаДерева.ВладелецФайла), ПараметрыФормыВыбора, Элементы.ДеревоОбъектовМетаданных);
	
КонецПроцедуры

&НаКлиенте
Процедура УдалитьНастройку(Команда)
	
	ОчиститьДанныеНастройки();
	
КонецПроцедуры

&НаКлиенте
Процедура Синхронизировать(Команда)
	
	ПрерватьФоновоеЗадание();
	ЗапуститьРегламентноеЗадание();
	УстановитьВидимостьКомандыСинхронизировать();
	ПодключитьОбработчикОжидания("ПроверитьВыполнениеФоновогоЗадания", 2, Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура ИзменитьНастройкуСинхронизации(Команда)
	
	ОткрытьФормуНастроек();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура НастроитьРасписаниеЗавершение(Расписание, ДополнительныеПараметры) Экспорт
	
	Если Расписание = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	УстановитьПараметрРегламентногоЗадания("Расписание", Расписание);
	Элементы.Расписание.Заголовок = Расписание;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьТипыОбъектовВДеревеЗначений()
	
	НастройкиСинхронизации = РегистрыСведений.НастройкиСинхронизацииФайлов.ТекущиеНастройкиСинхронизации();
	
	ДеревоОМ = РеквизитФормыВЗначение("ДеревоОбъектовМетаданных");
	ДеревоОМ.Строки.Очистить();
	
	МетаданныеСправочники = Метаданные.Справочники;
	
	ТаблицаТипов = Новый ТаблицаЗначений;
	ТаблицаТипов.Колонки.Добавить("ВладелецФайла");
	ТаблицаТипов.Колонки.Добавить("ТипВладельцаФайла");
	ТаблицаТипов.Колонки.Добавить("ЭтоФайл", Новый ОписаниеТипов("Булево"));
	ТаблицаТипов.Колонки.Добавить("ВозможностьДетализации"  , Новый ОписаниеТипов("Булево"));
	
	ВидИерархииГруппИЭлементов = Метаданные.СвойстваОбъектов.ВидИерархии.ИерархияГруппИЭлементов;
	МассивИсключений = ФайловыеФункцииСлужебный.ПриОпределенииОбъектовИсключенияСинхронизацииФайлов();
	
	Для Каждого Справочник Из МетаданныеСправочники Цикл
		Если Справочник.Реквизиты.Найти("ВладелецФайла") <> Неопределено Тогда
			ТипыВладельцевФайлов = Справочник.Реквизиты.ВладелецФайла.Тип.Типы();
			Для Каждого ТипВладельца Из ТипыВладельцевФайлов Цикл
				
				Если МассивИсключений.Найти(Справочник) <> Неопределено Тогда
					Продолжить;
				КонецЕсли;

				НоваяСтрока = ТаблицаТипов.Добавить();
				НоваяСтрока.ВладелецФайла = ТипВладельца;
				НоваяСтрока.ТипВладельцаФайла = Справочник;
				МетаданныеВладельца = Метаданные.НайтиПоТипу(ТипВладельца);
				Если МетаданныеСправочники.Найти(МетаданныеВладельца.Имя) <> Неопределено Тогда
					НоваяСтрока.ВозможностьДетализации = Истина;
				КонецЕсли;
				Если Не СтрЗаканчиваетсяНа(Справочник.Имя, "ПрисоединенныеФайлы") Тогда
					НоваяСтрока.ЭтоФайл = Истина;
				КонецЕсли;
			КонецЦикла;
		КонецЕсли;
	КонецЦикла;
	
	ВсеСправочники = Справочники.ТипВсеСсылки();
	
	ВсеДокументы = Документы.ТипВсеСсылки();
	УзелСправочники = Неопределено;
	УзелДокументы = Неопределено;
	УзелБизнесПроцессы = Неопределено;
	Для Каждого Тип Из ТаблицаТипов Цикл
		НастройкаИмеетГлобальныеПравила = Ложь;
		Если ВсеСправочники.СодержитТип(Тип.ВладелецФайла) Тогда
			Если УзелСправочники = Неопределено Тогда
				УзелСправочники = ДеревоОМ.Строки.Добавить();
				УзелСправочники.СинонимНаименованияОбъекта = НСтр("ru = 'Справочники'");
			КонецЕсли;
			НоваяСтрокаТаблицы = УзелСправочники.Строки.Добавить();
			
			ИдентификаторОбъекта = ОбщегоНазначения.ИдентификаторОбъектаМетаданных(Тип.ВладелецФайла);
			ДетализированныеНастройки = НастройкиСинхронизации.НайтиСтроки(Новый Структура(
				"ВладелецФайла",
				ИдентификаторОбъекта));
			Если ДетализированныеНастройки.Количество() > 1 Тогда
				НастройкаИмеетГлобальныеПравила = Истина;
				Для Каждого Настройка Из ДетализированныеНастройки Цикл
					ПравилоОтбора = Настройка.ПравилоОтбора.Получить();
					ДетализированнаяНастройка = НоваяСтрокаТаблицы.Строки.Добавить();
					ДетализированнаяНастройка.ВладелецФайла = Настройка.ВладелецФайла;
					ДетализированнаяНастройка.ТипВладельцаФайла = Настройка.ТипВладельцаФайла;
					ЕстьПравилоОтбора = Ложь;
					Если ПравилоОтбора <> Неопределено Тогда
						ЕстьПравилоОтбора = ПравилоОтбора.Отбор.Элементы.Количество() > 0;
					КонецЕсли;
					Если Не ПустаяСтрока(Настройка.Наименование) Тогда
						ДетализированнаяНастройка.СинонимНаименованияОбъекта = Настройка.Наименование;
					Иначе
						ДетализированнаяНастройка.СинонимНаименованияОбъекта = Настройка.ВладелецФайла.Синоним;
					КонецЕсли;
					ДетализированнаяНастройка.Синхронизировать = Настройка.Синхронизировать;
					ДетализированнаяНастройка.УчетнаяЗапись = Настройка.УчетнаяЗапись;
					ДетализированнаяНастройка.ПравилоОтбора =
						?(ЕстьПравилоОтбора, НСтр("ru = 'Выбранные файлы'"), НСтр("ru = 'Все файлы'"));
					ДетализированнаяНастройка.ЭтоФайл = Настройка.ЭтоФайл;
				КонецЦикла;
			КонецЕсли;
			
			ИдентификаторОбъекта = ОбщегоНазначения.ИдентификаторОбъектаМетаданных(Тип.ВладелецФайла);
			ДетализированныеНастройки = НастройкиСинхронизации.НайтиСтроки(Новый Структура(
				"ИдентификаторВладельца",
				ИдентификаторОбъекта));
			Если ДетализированныеНастройки.Количество() > 0 Тогда
				Для Каждого Настройка Из ДетализированныеНастройки Цикл
					ПравилоОтбора = Настройка.ПравилоОтбора.Получить();
					ДетализированнаяНастройка = НоваяСтрокаТаблицы.Строки.Добавить();
					ДетализированнаяНастройка.ВладелецФайла = Настройка.ВладелецФайла;
					ДетализированнаяНастройка.ТипВладельцаФайла = Настройка.ТипВладельцаФайла;
					ЕстьПравилоОтбора = Ложь;
					Если ПравилоОтбора <> Неопределено Тогда
						ЕстьПравилоОтбора = ПравилоОтбора.Отбор.Элементы.Количество() > 0;
					КонецЕсли;
					Если Не ПустаяСтрока(Настройка.Наименование) Тогда
						ДетализированнаяНастройка.СинонимНаименованияОбъекта = Настройка.Наименование;
					Иначе
						ДетализированнаяНастройка.СинонимНаименованияОбъекта = Настройка.ВладелецФайла;
					КонецЕсли;
					ЕстьПравилоОтбора = Ложь;
					Если ПравилоОтбора <> Неопределено Тогда
						ЕстьПравилоОтбора = ПравилоОтбора.Отбор.Элементы.Количество() > 0;
					КонецЕсли;
					ДетализированнаяНастройка.Синхронизировать = Настройка.Синхронизировать;
					ДетализированнаяНастройка.УчетнаяЗапись = Настройка.УчетнаяЗапись;
					ДетализированнаяНастройка.ПравилоОтбора =
						?(ЕстьПравилоОтбора, НСтр("ru = 'Выбранные файлы'"), НСтр("ru = 'Все файлы'"));
					ДетализированнаяНастройка.ЭтоФайл = Настройка.ЭтоФайл;
				КонецЦикла;
			КонецЕсли;
		ИначеЕсли ВсеДокументы.СодержитТип(Тип.ВладелецФайла) Тогда
			Если УзелДокументы = НеОпределено Тогда
				УзелДокументы = ДеревоОМ.Строки.Добавить();
				УзелДокументы.СинонимНаименованияОбъекта = НСтр("ru = 'Документы'");
			КонецЕсли;
			НоваяСтрокаТаблицы = УзелДокументы.Строки.Добавить();
		ИначеЕсли БизнесПроцессы.ТипВсеСсылки().СодержитТип(Тип.ВладелецФайла) Тогда
			Если УзелБизнесПроцессы = Неопределено Тогда
				УзелБизнесПроцессы = ДеревоОМ.Строки.Добавить();
				УзелБизнесПроцессы.СинонимНаименованияОбъекта = НСтр("ru = 'Бизнес-процессы'");
			КонецЕсли;
			НоваяСтрокаТаблицы = УзелБизнесПроцессы.Строки.Добавить();
		КонецЕсли;
		МетаданныеОбъекта = Метаданные.НайтиПоТипу(Тип.ВладелецФайла);
		НоваяСтрокаТаблицы.ВладелецФайла = ОбщегоНазначения.ИдентификаторОбъектаМетаданных(Тип.ВладелецФайла);
		НоваяСтрокаТаблицы.ТипВладельцаФайла = ОбщегоНазначения.ИдентификаторОбъектаМетаданных(Тип.ТипВладельцаФайла);
		НоваяСтрокаТаблицы.СинонимНаименованияОбъекта = МетаданныеОбъекта.Синоним;
		НоваяСтрокаТаблицы.ЭтоФайл = Тип.ЭтоФайл;
		НоваяСтрокаТаблицы.ВозможностьДетализации = Тип.ВозможностьДетализации;
		
		Если Не НастройкаИмеетГлобальныеПравила Тогда
			НайденныеНастройки = НастройкиСинхронизации.НайтиСтроки(Новый Структура("ВладелецФайла", НоваяСтрокаТаблицы.ВладелецФайла));
			Если НайденныеНастройки.Количество() > 0 Тогда
				ПравилоОтбора = НайденныеНастройки[0].ПравилоОтбора.Получить();
				ЕстьПравилоОтбора = Ложь;
				Если ПравилоОтбора <> Неопределено Тогда
					ЕстьПравилоОтбора = ПравилоОтбора.Отбор.Элементы.Количество() > 0;
				КонецЕсли;
				НоваяСтрокаТаблицы.Синхронизировать = НайденныеНастройки[0].Синхронизировать;
				НоваяСтрокаТаблицы.УчетнаяЗапись =    НайденныеНастройки[0].УчетнаяЗапись;
				НоваяСтрокаТаблицы.ПравилоОтбора =    ?(ЕстьПравилоОтбора, НСтр("ru = 'Выбранные файлы'"), НСтр("ru = 'Все файлы'"));
			Иначе
				НоваяСтрокаТаблицы.Синхронизировать = Перечисления.ВариантыОчисткиФайлов.НеОчищать;
				НоваяСтрокаТаблицы.ПравилоОтбора = НСтр("ru = 'Все файлы'");
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	
	Для Каждого УзелВерхнегоУровня Из ДеревоОМ.Строки Цикл
		УзелВерхнегоУровня.Строки.Сортировать("СинонимНаименованияОбъекта");
	КонецЦикла;
	ЗначениеВРеквизитФормы(ДеревоОМ, "ДеревоОбъектовМетаданных");
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаписатьТекущиеНастройки()
	
	ТекущиеДанные = Элементы.ДеревоОбъектовМетаданных.ТекущиеДанные;
	ЗаписатьТекущиеНастройкиПоОбъекту(
		ТекущиеДанные.ВладелецФайла,
		ТекущиеДанные.ТипВладельцаФайла,
		ТекущиеДанные.Синхронизировать,
		ТекущиеДанные.УчетнаяЗапись,
		ТекущиеДанные.ЭтоФайл);
	
КонецПроцедуры

&НаСервере
Процедура ДобавитьНастройкиПоВладельцу(ВыбранноеЗначение)
	
	Если ВыбранноеЗначение = Неопределено Тогда
		Возврат
	КонецЕсли;
	
	СтрокаВладелец = ДеревоОбъектовМетаданных.НайтиПоИдентификатору(Элементы.ДеревоОбъектовМетаданных.ТекущаяСтрока);
	
	Если ВыбранноеЗначение.НоваяНастройка Тогда
		ЭлементВладелец = СтрокаВладелец.ПолучитьЭлементы();
		ОбновляемаяСтрока = ЭлементВладелец.Добавить();
	Иначе
		ОбновляемаяСтрока = СтрокаВладелец;
	КонецЕсли;
	
	ПравилоОтбора = ВыбранноеЗначение.Правило.Получить();
	ЕстьПравилоОтбора = Ложь;
	Если ПравилоОтбора <> Неопределено Тогда
		ЕстьПравилоОтбора = ПравилоОтбора.Отбор.Элементы.Количество() > 0;
	КонецЕсли;
	ЗаполнитьЗначенияСвойств(ОбновляемаяСтрока, ВыбранноеЗначение);
	ОбновляемаяСтрока.ПравилоОтбора =
		?(ЕстьПравилоОтбора, НСтр("ru = 'Выбранные файлы'"), НСтр("ru = 'Все файлы'"));
	Если ЗначениеЗаполнено(ВыбранноеЗначение.Наименование) Тогда
		ОбновляемаяСтрока.СинонимНаименованияОбъекта = ВыбранноеЗначение.Наименование;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьЗначениеСинхронизацииПодчиненнымОбъектам(Знач Синхронизировать)
	
	Для Каждого ИдентификаторСтроки Из Элементы.ДеревоОбъектовМетаданных.ВыделенныеСтроки Цикл
		ЭлементДерева = ДеревоОбъектовМетаданных.НайтиПоИдентификатору(ИдентификаторСтроки);
		Если ЭлементДерева.ПолучитьРодителя() = Неопределено Тогда 
			Для Каждого ПодчиненныйЭлементДерева Из ЭлементДерева.ПолучитьЭлементы() Цикл
				УстановитьЗначениеСинхронизацииОбъекта(ПодчиненныйЭлементДерева, Синхронизировать);
			КонецЦикла;
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьЗначениеСинхронизацииОбъекта(ВыбранныйОбъект, Знач Синхронизировать)
	
	ВыбранныйОбъект.Синхронизировать = Синхронизировать;
	ЗаписатьТекущиеНастройкиПоОбъекту(
		ВыбранныйОбъект.ВладелецФайла,
		ВыбранныйОбъект.ТипВладельцаФайла,
		Синхронизировать,
		ВыбранныйОбъект.УчетнаяЗапись,
		ВыбранныйОбъект.ЭтоФайл);
	
КонецПроцедуры

&НаСервере
Процедура ЗаписатьТекущиеНастройкиПоОбъекту(ВладелецФайла, ТипВладельцаФайла, Синхронизировать, УчетнаяЗапись, ЭтоФайл)
	Настройка = РегистрыСведений.НастройкиСинхронизацииФайлов.СоздатьМенеджерЗаписи();
	Настройка.ВладелецФайла = ВладелецФайла;
	Настройка.ТипВладельцаФайла = ТипВладельцаФайла;
	Настройка.Синхронизировать = Синхронизировать;
	Настройка.УчетнаяЗапись = УчетнаяЗапись;
	Настройка.ЭтоФайл = ЭтоФайл;
	Настройка.Записать();
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьФормуНастроек();
	
	ТекущиеДанные = Элементы.ДеревоОбъектовМетаданных.ТекущиеДанные;
	
	Если Не ЗначениеЗаполнено(ТекущиеДанные.ВладелецФайла)
		Или Не ЗначениеЗаполнено(ТекущиеДанные.ТипВладельцаФайла) Тогда
		Возврат;
	КонецЕсли;
	
	Отбор = Новый Структура;
	Отбор.Вставить("ВладелецФайла", ТекущиеДанные.ВладелецФайла);
	Отбор.Вставить("ТипВладельцаФайла", ТекущиеДанные.ТипВладельцаФайла);
	Отбор.Вставить("УчетнаяЗапись", ТекущиеДанные.УчетнаяЗапись);
	
	Если ЗначениеЗаполнено(ТекущиеДанные.УчетнаяЗапись) Тогда
		
		ТипЗначения = Тип("РегистрСведенийКлючЗаписи.НастройкиСинхронизацииФайлов");
		ПараметрыЗаписи = Новый Массив(1);
		ПараметрыЗаписи[0] = Отбор;
		
		КлючЗаписи = Новый(ТипЗначения, ПараметрыЗаписи);
		
		ПараметрыЗаписи = Новый Структура;
		ПараметрыЗаписи.Вставить("Ключ", КлючЗаписи);
	Иначе
		ПараметрыЗаписи = Отбор;
		ПараметрыЗаписи.Вставить("ЭтоФайл", ТекущиеДанные.ЭтоФайл);
	КонецЕсли;
	
	ОткрытьФорму("РегистрСведений.НастройкиСинхронизацииФайлов.Форма.ФормаЗаписиНастройки", ПараметрыЗаписи, ЭтотОбъект);
	
КонецПроцедуры

&НаСервере
Функция ПутьФормыВыбора(ВладелецФайла)
	
	ОбъектМетаданных = ОбщегоНазначения.ОбъектМетаданныхПоИдентификатору(ВладелецФайла);
	Возврат ОбъектМетаданных.ПолноеИмя() + ".ФормаВыбора";
	
КонецФункции

&НаСервере
Процедура ОчиститьДанныеНастройки()
	
	НастройкаДляУдаления = ДеревоОбъектовМетаданных.НайтиПоИдентификатору(Элементы.ДеревоОбъектовМетаданных.ТекущаяСтрока);
	
	МенеджерЗаписи = РегистрыСведений.НастройкиСинхронизацииФайлов.СоздатьМенеджерЗаписи();
	МенеджерЗаписи.ВладелецФайла = НастройкаДляУдаления.ВладелецФайла;
	МенеджерЗаписи.ТипВладельцаФайла = НастройкаДляУдаления.ТипВладельцаФайла;
	МенеджерЗаписи.УчетнаяЗапись = НастройкаДляУдаления.УчетнаяЗапись;
	МенеджерЗаписи.Прочитать();
	МенеджерЗаписи.Удалить();
	
	РодительЭлементаНастроек = НастройкаДляУдаления.ПолучитьРодителя();
	Если РодительЭлементаНастроек <> Неопределено Тогда
		РодительЭлементаНастроек.ПолучитьЭлементы().Удалить(НастройкаДляУдаления);
	Иначе
		ДеревоОбъектовМетаданных.ПолучитьЭлементы().Удалить(НастройкаДляУдаления);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СоздатьСинхронизациюФайлов(Команда)
	
	СтрокаДерева = Элементы.ДеревоОбъектовМетаданных.ТекущиеДанные;
	Если Не СтрокаДерева.ВозможностьДетализации Тогда
		ТекстСообщения = НСтр("ru = 'Добавление настройки возможно только для справочников'");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения);
		Возврат;
	КонецЕсли;
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("ВладелецФайла", СтрокаДерева.ВладелецФайла);
	ПараметрыФормы.Вставить("ТипВладельцаФайла", СтрокаДерева.ТипВладельцаФайла);
	ПараметрыФормы.Вставить("ЭтоФайл", СтрокаДерева.ЭтоФайл);
	ПараметрыФормы.Вставить("НоваяНастройка", Истина);
	
	ОткрытьФорму("РегистрСведений.НастройкиСинхронизацииФайлов.Форма.ФормаЗаписиНастройки", ПараметрыФормы, ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ПрерватьФоновоеЗадание()
	ОтменитьВыполнениеЗадания(ИдентификаторФоновогоЗадания);
	ОтключитьОбработчикОжидания("ПроверитьВыполнениеФоновогоЗадания");
	ТекущееФоновоеЗадание = "";
	ИдентификаторФоновогоЗадания = "";
КонецПроцедуры

&НаСервереБезКонтекста
Процедура ОтменитьВыполнениеЗадания(ИдентификаторФоновогоЗадания)
	ДлительныеОперации.ОтменитьВыполнениеЗадания(ИдентификаторФоновогоЗадания);
КонецПроцедуры

&НаКлиенте
Процедура ПроверитьВыполнениеФоновогоЗадания()
	Если Не ЗаданиеВыполнено(ИдентификаторФоновогоЗадания) Тогда
		ПодключитьОбработчикОжидания("ПроверитьВыполнениеФоновогоЗадания", 5, Истина);
	Иначе
		ИдентификаторФоновогоЗадания = "";
		ТекущееФоновоеЗадание = "";
		УстановитьВидимостьКомандыСинхронизировать();
	КонецЕсли;
КонецПроцедуры

&НаСервереБезКонтекста
Функция ЗаданиеВыполнено(ИдентификаторФоновогоЗадания)
	Возврат ДлительныеОперации.ЗаданиеВыполнено(ИдентификаторФоновогоЗадания);
КонецФункции

&НаСервере
Процедура ЗапуститьРегламентноеЗадание()
	
	РегламентноеЗаданиеМетаданные = Метаданные.РегламентныеЗадания.СинхронизацияФайлов;
	
	Отбор = Новый Структура;
	ИмяМетода = РегламентноеЗаданиеМетаданные.ИмяМетода;
	Отбор.Вставить("ИмяМетода", ИмяМетода);
	Отбор.Вставить("Состояние", СостояниеФоновогоЗадания.Активно);
	ФоновыеЗаданияОчистки = ФоновыеЗадания.ПолучитьФоновыеЗадания(Отбор);
	Если ФоновыеЗаданияОчистки.Количество() > 0 Тогда
		ИдентификаторФоновогоЗадания = ФоновыеЗаданияОчистки[0].УникальныйИдентификатор;
	Иначе
		НаименованиеФоновогоЗадания = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = 'Запуск вручную: %1'"), РегламентноеЗаданиеМетаданные.Синоним);
		ФоновоеЗадание = ФоновыеЗадания.Выполнить(РегламентноеЗаданиеМетаданные.ИмяМетода, , , НаименованиеФоновогоЗадания);
		ИдентификаторФоновогоЗадания = ФоновоеЗадание.УникальныйИдентификатор;
	КонецЕсли;
	
	ТекущееФоновоеЗадание = "Синхронизация";
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьВидимостьКомандыСинхронизировать()
	
	ПодчиненныеСтраницы = Элементы.СинхронизацияФайлов.ПодчиненныеЭлементы;
	Если ПустаяСтрока(ТекущееФоновоеЗадание) Тогда
		Элементы.СинхронизацияФайлов.ТекущаяСтраница = ПодчиненныеСтраницы.Синхронизация;
	Иначе
		Элементы.СинхронизацияФайлов.ТекущаяСтраница = ПодчиненныеСтраницы.СтатусФоновогоЗадания;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьПараметрРегламентногоЗадания(ИмяПараметра, ЗначениеПараметра)
	
	ПараметрыЗадания = Новый Структура;
	ПараметрыЗадания.Вставить("Метаданные", Метаданные.РегламентныеЗадания.СинхронизацияФайлов);
	Если Не ОбщегоНазначенияПовтИсп.РазделениеВключено() Тогда
		ПараметрыЗадания.Вставить("ИмяМетода", Метаданные.РегламентныеЗадания.СинхронизацияФайлов.ИмяМетода);
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Истина);
	
	СписокЗаданий = РегламентныеЗаданияСервер.НайтиЗадания(ПараметрыЗадания);
	Если СписокЗаданий.Количество() = 0 Тогда
		ПараметрыЗадания.Вставить(ИмяПараметра, ЗначениеПараметра);
		РегламентныеЗаданияСервер.ДобавитьЗадание(ПараметрыЗадания);
	Иначе
		ПараметрыЗадания = Новый Структура(ИмяПараметра, ЗначениеПараметра);
		Для Каждого Задание Из СписокЗаданий Цикл
			РегламентныеЗаданияСервер.ИзменитьЗадание(Задание, ПараметрыЗадания);
		КонецЦикла;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция ПолучитьПараметрРегламентногоЗадания(ИмяПараметра, ЗначениеПоУмолчанию)
	
	ПараметрыЗадания = Новый Структура;
	ПараметрыЗадания.Вставить("Метаданные", Метаданные.РегламентныеЗадания.СинхронизацияФайлов);
	Если Не ОбщегоНазначенияПовтИсп.РазделениеВключено() Тогда
		ПараметрыЗадания.Вставить("ИмяМетода", Метаданные.РегламентныеЗадания.СинхронизацияФайлов.ИмяМетода);
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Истина);
	
	СписокЗаданий = РегламентныеЗаданияСервер.НайтиЗадания(ПараметрыЗадания);
	Для Каждого Задание Из СписокЗаданий Цикл
		Возврат Задание[ИмяПараметра];
	КонецЦикла;
	
	Возврат ЗначениеПоУмолчанию;
	
КонецФункции

&НаСервере
Функция ТекущееРасписание()
	Возврат ПолучитьПараметрРегламентногоЗадания("Расписание", Новый РасписаниеРегламентногоЗадания);
КонецФункции

&НаСервере
Функция АвтоматическаяСинхронизацияВключена()
	Возврат ПолучитьПараметрРегламентногоЗадания("Использование", Ложь);
КонецФункции

#КонецОбласти