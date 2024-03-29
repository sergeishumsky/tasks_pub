#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Если Параметры.Свойство("АвтоТест") Тогда 
		Возврат;
	КонецЕсли;
	Если Объект.Ссылка.Пустая() Тогда
		ОшибкаОткрытия = НСтр("ru = 'Новый вариант отчета можно создать только из формы отчета'");
		Возврат;
	КонецЕсли;
	Если Параметры.Свойство("ПараметрыОткрытияФормыОтчета", ПараметрыОткрытияФормыОтчета) Тогда
		Возврат;
	КонецЕсли;
	
	Доступен = ?(Объект.ТолькоДляАвтора, "1", "2");
	
	// Чтение свойств предопределенного;
	// Заполнение реквизитов, связанных с предопределенным объектом при открытии.
	ПрочитатьСвойстваПредопределенного(Истина);
	
	ПолныеПраваНаВарианты = ВариантыОтчетов.ПолныеПраваНаВарианты();
	ПравоНаЭтотВариант = ПолныеПраваНаВарианты Или Объект.Автор = Пользователи.АвторизованныйПользователь();
	Если Не ПравоНаЭтотВариант Тогда
		ТолькоПросмотр = Истина;
		Элементы.ДеревоПодсистем.ТолькоПросмотр = Истина;
	КонецЕсли;
	
	Если Объект.ПометкаУдаления Тогда
		Элементы.ДеревоПодсистем.ТолькоПросмотр = Истина;
	КонецЕсли;
	
	Если Не Объект.Пользовательский Тогда
		Элементы.Наименование.ТолькоПросмотр = Истина;
		Элементы.Доступен.ТолькоПросмотр = Истина;
		Элементы.Автор.ТолькоПросмотр = Истина;
		Элементы.Автор.АвтоОтметкаНезаполненного = Ложь;
	КонецЕсли;
	
	ЭтоВнешний = (Объект.ТипОтчета = Перечисления.ТипыОтчетов.Внешний);
	Если ЭтоВнешний Тогда
		Элементы.ДеревоПодсистем.ТолькоПросмотр = Истина;
	КонецЕсли;
	
	Элементы.Доступен.ТолькоПросмотр = Не ПолныеПраваНаВарианты;
	Элементы.Автор.ТолькоПросмотр = Не ПолныеПраваНаВарианты;
	Элементы.ТехническаяИнформация.Видимость = ПолныеПраваНаВарианты;
	
	// Заполнение имени отчета для команды "Просмотр".
	Если Объект.ТипОтчета = Перечисления.ТипыОтчетов.Внутренний
		Или Объект.ТипОтчета = Перечисления.ТипыОтчетов.Расширение Тогда
		ИмяОтчета = Объект.Отчет.Имя;
	ИначеЕсли Объект.ТипОтчета = Перечисления.ТипыОтчетов.Дополнительный Тогда
		ИмяОтчета = Объект.Отчет.ИмяОбъекта;
	Иначе
		ИмяОтчета = Объект.Отчет;
	КонецЕсли;
	
	ПерезаполнитьДерево(Ложь);
	
	ВариантыОтчетов.ДеревоПодсистемДобавитьУсловноеОформление(ЭтотОбъект);
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	Если Не ПустаяСтрока(ОшибкаОткрытия) Тогда
		Если Объект.Ссылка.Пустая() Тогда
			Отказ = Истина;
		Иначе
			ТолькоПросмотр = Истина;
		КонецЕсли;
		ПоказатьПредупреждение(, ОшибкаОткрытия);
	ИначеЕсли ПараметрыОткрытияФормыОтчета <> Неопределено Тогда
		Отказ = Истина;
		ВариантыОтчетовКлиент.ОткрытьФормуОтчета(Неопределено, ПараметрыОткрытияФормыОтчета);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	Если Источник <> ЭтотОбъект
		И (ИмяСобытия = ВариантыОтчетовКлиентСервер.ИмяСобытияИзменениеВарианта()
			Или ИмяСобытия = "Запись_НаборКонстант") Тогда
		ПерезаполнитьДерево(Истина);
		Элементы.ДеревоПодсистем.Развернуть(ДеревоПодсистем.ПолучитьЭлементы()[0].ПолучитьИдентификатор(), Истина);
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	// Запись свойств, связанных с предопределенным вариантом отчета.
	Если ТипЗнч(СвойстваПредопределенного) = Тип("ФиксированнаяСтруктура") Тогда
		ТекущийОбъект.ВидимостьПоУмолчаниюПереопределена = 
			Объект.ВидимостьПоУмолчанию <> СвойстваПредопределенного.ВидимостьПоУмолчанию;
		
		Если Не ПустаяСтрока(Объект.Описание) И НРег(СокрЛП(Объект.Описание)) = НРег(СокрЛП(СвойстваПредопределенного.Описание)) Тогда
			ТекущийОбъект.Описание = "";
		КонецЕсли;
	КонецЕсли;
	
	// Запись дерева подсистем.
	ВариантыОтчетов.ДеревоПодсистемЗаписать(ЭтотОбъект, ТекущийОбъект);
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	ПерезаполнитьДерево(Ложь);
	ПрочитатьСвойстваПредопределенного(Ложь);
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	ПараметрОповещения = Новый Структура("Ссылка, Наименование, Автор, Описание");
	ЗаполнитьЗначенияСвойств(ПараметрОповещения, Объект);
	Оповестить(ВариантыОтчетовКлиентСервер.ИмяСобытияИзменениеВарианта(), ПараметрОповещения, ЭтотОбъект);
	РазворачиваемыйУзел = Новый Структура("ИмяТаблицы, Идентификатор, СПодчиненными");
	РазворачиваемыйУзел.ИмяТаблицы = "ДеревоПодсистем";
	РазворачиваемыйУзел.Идентификатор = "*";
	РазворачиваемыйУзел.СПодчиненными = Истина;
	СтандартныеПодсистемыКлиент.РазвернутьУзлыДерева(ЭтотОбъект, РазворачиваемыйУзел);
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ОписаниеНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	ВариантыОтчетовКлиент.РедактироватьМногострочныйТекст(ЭтотОбъект, Элемент.ТекстРедактирования, Объект, "Описание", НСтр("ru = 'Описание'"));
КонецПроцедуры

&НаКлиенте
Процедура ДоступенПриИзменении(Элемент)
	Объект.ТолькоДляАвтора = (ЭтотОбъект.Доступен = "1");
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыДеревоПодсистем

&НаКлиенте
Процедура ДеревоПодсистемИспользованиеПриИзменении(Элемент)
	ВариантыОтчетовКлиент.ДеревоПодсистемИспользованиеПриИзменении(ЭтотОбъект, Элемент);
КонецПроцедуры

&НаКлиенте
Процедура ДеревоПодсистемВажностьПриИзменении(Элемент)
	ВариантыОтчетовКлиент.ДеревоПодсистемВажностьПриИзменении(ЭтотОбъект, Элемент);
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Функция ПерезаполнитьДерево(Прочитать)
	ВыделенныеСтроки = ОтчетыСервер.ЗапомнитьВыделенныеСтроки(ЭтотОбъект, "ДеревоПодсистем", "Ссылка");
	Если Прочитать Тогда
		ЭтотОбъект.Прочитать();
	КонецЕсли;
	ДеревоПриемник = ВариантыОтчетов.ДеревоПодсистемСформировать(ЭтотОбъект, Объект);
	ЗначениеВРеквизитФормы(ДеревоПриемник, "ДеревоПодсистем");
	ОтчетыСервер.ВосстановитьВыделенныеСтроки(ЭтотОбъект, "ДеревоПодсистем", ВыделенныеСтроки);
	Возврат Истина;
КонецФункции

&НаСервере
Процедура ПрочитатьСвойстваПредопределенного(ПервоеЧтение)
	Если ПервоеЧтение Тогда
		Если Не Объект.Пользовательский
			И (Объект.ТипОтчета = Перечисления.ТипыОтчетов.Внутренний
				Или Объект.ТипОтчета = Перечисления.ТипыОтчетов.Расширение)
			И ЗначениеЗаполнено(Объект.ПредопределенныйВариант) Тогда // Чтение настроек предопределенного.
			Сведения = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Объект.ПредопределенныйВариант, "ВидимостьПоУмолчанию, Описание");
			СвойстваПредопределенного = Новый ФиксированнаяСтруктура(Сведения);
		Иначе
			Возврат; // Не предопределенный.
		КонецЕсли;
	Иначе
		Если ТипЗнч(СвойстваПредопределенного) <> Тип("ФиксированнаяСтруктура") Тогда
			Возврат; // Не предопределенный.
		КонецЕсли;
	КонецЕсли;
	
	Если Объект.ВидимостьПоУмолчаниюПереопределена = Ложь Тогда
		Объект.ВидимостьПоУмолчанию = СвойстваПредопределенного.ВидимостьПоУмолчанию;
	КонецЕсли;
	
	Если ПустаяСтрока(Объект.Описание) Тогда
		Объект.Описание = СвойстваПредопределенного.Описание;
	КонецЕсли;
КонецПроцедуры

#КонецОбласти
