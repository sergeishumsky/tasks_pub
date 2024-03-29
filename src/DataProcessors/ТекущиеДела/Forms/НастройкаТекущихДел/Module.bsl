#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	НастройкиОтображения = ТекущиеДелаСлужебный.СохраненныеНастройкиОтображения();
	ЗаполнитьДеревоДел(НастройкиОтображения);
	УстановитьПорядокРазделов(НастройкиОтображения);
	
	НастройкиАвтообновления = ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить("ТекущиеДела", "НастройкиАвтообновления");
	Если ТипЗнч(НастройкиАвтообновления) = Тип("Структура") Тогда
		НастройкиАвтообновления.Свойство("АвтообновлениеВключено", ИспользоватьАвтообновление);
		НастройкиАвтообновления.Свойство("ПериодАвтообновления", ПериодОбновления);
	Иначе
		ПериодОбновления = 5;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовУправленияФормы

&НаКлиенте
Процедура ДеревоОтображаемыхДелПриИзменении(Элемент)
	
	Модифицированность = Истина;
	Если Элемент.ТекущиеДанные.ЭтоРаздел Тогда
		Для Каждого Дело Из Элемент.ТекущиеДанные.ПолучитьЭлементы() Цикл
			Дело.Пометка = Элемент.ТекущиеДанные.Пометка;
		КонецЦикла;
	ИначеЕсли Элемент.ТекущиеДанные.Пометка Тогда
		Элемент.ТекущиеДанные.ПолучитьРодителя().Пометка = Истина;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура КнопкаОК(Команда)
	
	СохранитьНастройки();
	
	Если АвтообновлениеВключено Тогда
		Оповестить("ТекущиеДела_ВключеноАвтообновление");
	ИначеЕсли АвтообновлениеВыключено Тогда
		Оповестить("ТекущиеДела_ВыключеноАвтообновление");
	КонецЕсли;
	
	Закрыть(Модифицированность);
	
КонецПроцедуры

&НаКлиенте
Процедура КнопкаОтмена(Команда)
	Закрыть(Ложь);
КонецПроцедуры

&НаКлиенте
Процедура ПереместитьВверх(Команда)
	
	Модифицированность = Истина;
	// Перемещение текущей строки на 1 позицию вверх.
	ТекущаяСтрокаДерева = Элементы.ДеревоОтображаемыхДел.ТекущиеДанные;
	
	Если ТекущаяСтрокаДерева.ЭтоРаздел Тогда
		РазделыДерева = ДеревоОтображаемыхДел.ПолучитьЭлементы();
	Иначе
		РодительДела = ТекущаяСтрокаДерева.ПолучитьРодителя();
		РазделыДерева= РодительДела.ПолучитьЭлементы();
	КонецЕсли;
	
	ИндексТекущейСтроки = ТекущаяСтрокаДерева.Индекс;
	Если ИндексТекущейСтроки = 0 Тогда
		Возврат; // Текущая строка вверху списка, не перемещаем.
	КонецЕсли;
	РазделыДерева.Сдвинуть(ТекущаяСтрокаДерева.Индекс, -1);
	ТекущаяСтрокаДерева.Индекс = ИндексТекущейСтроки - 1;
	// Изменение индекса предыдущей строки.
	ПредыдущаяСтрока = РазделыДерева.Получить(ИндексТекущейСтроки);
	ПредыдущаяСтрока.Индекс = ИндексТекущейСтроки;
	
КонецПроцедуры

&НаКлиенте
Процедура ПереместитьВниз(Команда)
	
	Модифицированность = Истина;
	// Перемещение текущей строки на 1 позицию вниз.
	ТекущаяСтрокаДерева = Элементы.ДеревоОтображаемыхДел.ТекущиеДанные;
	
	Если ТекущаяСтрокаДерева.ЭтоРаздел Тогда
		РазделыДерева = ДеревоОтображаемыхДел.ПолучитьЭлементы();
	Иначе
		РодительДела = ТекущаяСтрокаДерева.ПолучитьРодителя();
		РазделыДерева= РодительДела.ПолучитьЭлементы();
	КонецЕсли;
	
	ИндексТекущейСтроки = ТекущаяСтрокаДерева.Индекс;
	Если ИндексТекущейСтроки = (РазделыДерева.Количество() -1) Тогда
		Возврат; // Текущая строка внизу списка, не перемещаем.
	КонецЕсли;
	РазделыДерева.Сдвинуть(ТекущаяСтрокаДерева.Индекс, 1);
	ТекущаяСтрокаДерева.Индекс = ИндексТекущейСтроки + 1;
	// Изменение индекса следующей строки.
	СледующаяСтрока = РазделыДерева.Получить(ИндексТекущейСтроки);
	СледующаяСтрока.Индекс = ИндексТекущейСтроки;
	
КонецПроцедуры

&НаКлиенте
Процедура СнятьФлажки(Команда)
	
	Модифицированность = Истина;
	Для Каждого СтрокаРаздела Из ДеревоОтображаемыхДел.ПолучитьЭлементы() Цикл
		СтрокаРаздела.Пометка = Ложь;
		Для Каждого СтрокаДела Из СтрокаРаздела.ПолучитьЭлементы() Цикл
			СтрокаДела.Пометка = Ложь;
		КонецЦикла;
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьФлажки(Команда)
	
	Модифицированность = Истина;
	Для Каждого СтрокаРаздела Из ДеревоОтображаемыхДел.ПолучитьЭлементы() Цикл
		СтрокаРаздела.Пометка = Истина;
		Для Каждого СтрокаДела Из СтрокаРаздела.ПолучитьЭлементы() Цикл
			СтрокаДела.Пометка = Истина;
		КонецЦикла;
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ЗаполнитьДеревоДел(НастройкиОтображения)
	
	ТекущиеДела   = ПолучитьИзВременногоХранилища(Параметры.ТекущиеДела);
	ДеревоДел     = РеквизитФормыВЗначение("ДеревоОтображаемыхДел");
	ТекущийРаздел = "";
	Индекс        = 0;
	ИндексДела    = 0;
	
	Если НастройкиОтображения = Неопределено Тогда
		ТекущиеДелаСлужебный.УстановитьНачальныйПорядокРазделов(ТекущиеДела);
	КонецЕсли;
	
	Для Каждого Дело Из ТекущиеДела Цикл
		
		Если Дело.ЭтоРаздел
			И ТекущийРаздел <> Дело.ИдентификаторВладельца Тогда
			СтрокаДерева = ДеревоДел.Строки.Добавить();
			СтрокаДерева.Представление = Дело.ПредставлениеРаздела;
			СтрокаДерева.Идентификатор = Дело.ИдентификаторВладельца;
			СтрокаДерева.ЭтоРаздел     = Истина;
			СтрокаДерева.Пометка       = Истина;
			СтрокаДерева.Индекс        = Индекс;
			
			Если НастройкиОтображения <> Неопределено Тогда
				ВидимостьРаздела = НастройкиОтображения.ВидимостьРазделов[СтрокаДерева.Идентификатор];
				Если ВидимостьРаздела <> Неопределено Тогда
					СтрокаДерева.Пометка = ВидимостьРаздела;
				КонецЕсли;
			КонецЕсли;
			Индекс     = Индекс + 1;
			ИндексДела = 0;
			
		ИначеЕсли Не Дело.ЭтоРаздел Тогда
			ДелоРодитель = ДеревоДел.Строки.Найти(Дело.ИдентификаторВладельца, "Идентификатор", Истина);
			Если ДелоРодитель = Неопределено Тогда
				Продолжить;
			КонецЕсли;
			ДелоРодитель.РасшифровкаДела = ДелоРодитель.РасшифровкаДела + ?(ПустаяСтрока(ДелоРодитель.РасшифровкаДела), "", Символы.ПС) + Дело.Представление;
			Продолжить;
		КонецЕсли;
		
		СтрокаДела = СтрокаДерева.Строки.Добавить();
		СтрокаДела.Представление = Дело.Представление;
		СтрокаДела.Идентификатор = Дело.Идентификатор;
		СтрокаДела.ЭтоРаздел     = Ложь;
		СтрокаДела.Пометка       = Истина;
		СтрокаДела.Индекс        = ИндексДела;
		
		Если НастройкиОтображения <> Неопределено Тогда
			ВидимостьДела = НастройкиОтображения.ВидимостьДел[СтрокаДела.Идентификатор];
			Если ВидимостьДела <> Неопределено Тогда
				СтрокаДела.Пометка = ВидимостьДела;
			КонецЕсли;
		КонецЕсли;
		ИндексДела = ИндексДела + 1;
		
		ТекущийРаздел = Дело.ИдентификаторВладельца;
		
	КонецЦикла;
	
	ЗначениеВРеквизитФормы(ДеревоДел, "ДеревоОтображаемыхДел");
	
КонецПроцедуры

&НаСервере
Процедура СохранитьНастройки()
	
	СтарыеНастройкиОтображения = ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить("ТекущиеДела", "НастройкиОтображения");
	СвернутыеРазделы = Неопределено;
	Если ТипЗнч(СтарыеНастройкиОтображения) = Тип("Структура") Тогда
		СтарыеНастройкиОтображения.Свойство("СвернутыеРазделы", СвернутыеРазделы);
	КонецЕсли;
	
	Если СвернутыеРазделы = Неопределено Тогда
		СвернутыеРазделы = Новый Соответствие;
	КонецЕсли;
	
	// Сохранение положения и видимости разделов.
	ВидимостьРазделов = Новый Соответствие;
	ВидимостьДел      = Новый Соответствие;
	
	ДеревоДел = РеквизитФормыВЗначение("ДеревоОтображаемыхДел");
	Для Каждого Раздел Из ДеревоДел.Строки Цикл
		ВидимостьРазделов.Вставить(Раздел.Идентификатор, Раздел.Пометка);
		Для Каждого Дело Из Раздел.Строки Цикл
			ВидимостьДел.Вставить(Дело.Идентификатор, Дело.Пометка);
		КонецЦикла;
	КонецЦикла;
	
	Результат = Новый Структура;
	Результат.Вставить("ДеревоДел", ДеревоДел);
	Результат.Вставить("ВидимостьРазделов", ВидимостьРазделов);
	Результат.Вставить("ВидимостьДел", ВидимостьДел);
	Результат.Вставить("СвернутыеРазделы", СвернутыеРазделы);
	
	ОбщегоНазначения.ХранилищеОбщихНастроекСохранить("ТекущиеДела", "НастройкиОтображения", Результат);
	
	// Сохранение настроек автообновления.
	НастройкиАвтообновления = ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить("ТекущиеДела", "НастройкиАвтообновления");
	
	Если НастройкиАвтообновления = Неопределено Тогда
		НастройкиАвтообновления = Новый Структура;
	Иначе
		Если ИспользоватьАвтообновление Тогда
			АвтообновлениеВключено = НастройкиАвтообновления.АвтообновлениеВключено <> ИспользоватьАвтообновление;
		Иначе
			АвтообновлениеВыключено = НастройкиАвтообновления.АвтообновлениеВключено <> ИспользоватьАвтообновление;
		КонецЕсли;
	КонецЕсли;
	
	НастройкиАвтообновления.Вставить("АвтообновлениеВключено", ИспользоватьАвтообновление);
	НастройкиАвтообновления.Вставить("ПериодАвтообновления", ПериодОбновления);
	
	ОбщегоНазначения.ХранилищеОбщихНастроекСохранить("ТекущиеДела", "НастройкиАвтообновления", НастройкиАвтообновления);
	
КонецПроцедуры

&НаСервере
Процедура УстановитьПорядокРазделов(НастройкиОтображения)
	
	Если НастройкиОтображения = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ДеревоДел = РеквизитФормыВЗначение("ДеревоОтображаемыхДел");
	Разделы   = ДеревоДел.Строки;
	СохраненноеДеревоДел = НастройкиОтображения.ДеревоДел;
	Для Каждого СтрокаРаздела Из Разделы Цикл
		СохраненныйРаздел = СохраненноеДеревоДел.Строки.Найти(СтрокаРаздела.Идентификатор, "Идентификатор");
		Если СохраненныйРаздел = Неопределено Тогда
			Продолжить;
		КонецЕсли;
		СтрокаРаздела.Индекс = СохраненныйРаздел.Индекс;
		Дела = СтрокаРаздела.Строки;
		ИндексПоследнегоДела = Дела.Количество() - 1;
		Для Каждого СтрокаДело Из Дела Цикл
			СохраненноеДело = СохраненныйРаздел.Строки.Найти(СтрокаДело.Идентификатор, "Идентификатор");
			Если СохраненноеДело = Неопределено Тогда
				СтрокаДело.Индекс = ИндексПоследнегоДела;
				ИндексПоследнегоДела = ИндексПоследнегоДела - 1;
				Продолжить;
			КонецЕсли;
			СтрокаДело.Индекс = СохраненноеДело.Индекс;
		КонецЦикла;
		Дела.Сортировать("Индекс возр");
	КонецЦикла;
	
	Разделы.Сортировать("Индекс возр");
	ЗначениеВРеквизитФормы(ДеревоДел, "ДеревоОтображаемыхДел");
	
КонецПроцедуры

#КонецОбласти