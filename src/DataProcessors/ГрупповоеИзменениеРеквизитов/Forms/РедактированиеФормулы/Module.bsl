
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	Формула         = Параметры.Формула;
	ИсходнаяФормула = Параметры.Формула;
	
	Параметры.Свойство("СтроковаяФормула", СтроковаяФормула);
	Параметры.Свойство("ИспользуетсяДеревоОперандов", ИспользуетсяДеревоОперандов);
	
	Элементы.ГруппаОперандыСтраницы.ТекущаяСтраница = Элементы.СтраницаЧисловыхОперандов;
	Операнды.Загрузить(ПолучитьИзВременногоХранилища(Параметры.Операнды));
	Для Каждого ТекСтрока Из Операнды Цикл
		Если ТекСтрока.ПометкаУдаления Тогда
			ТекСтрока.ИндексКартинки = 3;
		Иначе
			ТекСтрока.ИндексКартинки = 2;
		КонецЕсли;
	КонецЦикла;
	
	ДеревоОператоров = ПолучитьСтандартноеДеревоОператоров();
	ЗначениеВРеквизитФормы(ДеревоОператоров, "Операторы");
	
	Если Параметры.Свойство("ОперандыЗаголовок") Тогда
		Элементы.ГруппаОперанды.Заголовок = Параметры.ОперандыЗаголовок;
		Элементы.ГруппаОперанды.Подсказка = Параметры.ОперандыЗаголовок;
	КонецЕсли;
	
	УстановитьСвойствоЭлементаФормы(
			Элементы,
			"Операнды",
			"ИзменятьСоставСтрок",
			Ложь);
	
	УстановитьВидимость();

КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	Если Модифицированность И ЗначениеЗаполнено(ИсходнаяФормула) И ИсходнаяФормула <> Формула Тогда
		Отказ = Истина;
		Ответ = Неопределено;

		ПоказатьВопрос(Новый ОписаниеОповещения("ПередЗакрытиемЗавершение", ЭтотОбъект), НСтр("ru='Данные были изменены. Сохранить изменения?'"), РежимДиалогаВопрос.ДаНетОтмена);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытиемЗавершение(РезультатВопроса, ДополнительныеПараметры) Экспорт
	
	Ответ = РезультатВопроса;
	Если Ответ = КодВозвратаДиалога.Да Тогда
		Если ПроверитьФормулу(Формула, ПолучитьМассивОперандов(), "Формула", СтроковаяФормула) Тогда
			Модифицированность = Ложь;
			Закрыть(Формула);
		КонецЕсли;
	ИначеЕсли Ответ = КодВозвратаДиалога.Нет Тогда
		Модифицированность = Ложь;
		Закрыть(Неопределено);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура КомпоновщикНастроекНастройкиВыборДоступныеПоляВыбораВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	ТекстСтроки = Строка(КомпоновщикНастроек.Настройки.ДоступныеПоляПорядка.ПолучитьОбъектПоИдентификатору(ВыбраннаяСтрока).Поле);
	Операнд = ОбработатьТекстОперанда(ТекстСтроки);
	ВставитьТекстВФормулу(Операнд);
	
КонецПроцедуры

&НаКлиенте
Процедура КомпоновщикНастроекНачалоПеретаскивания(Элемент, ПараметрыПеретаскивания, Выполнение)
	
	ТекстЭлемента = Строка(КомпоновщикНастроек.Настройки.ДоступныеПоляПорядка.ПолучитьОбъектПоИдентификатору(Элементы.КомпоновщикНастроек.ТекущаяСтрока).Поле);
	ПараметрыПеретаскивания.Значение = ОбработатьТекстОперанда(ТекстЭлемента);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыОперанды

&НаКлиенте
Процедура ОперандыВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	Если Поле.Имя = "ОперандыЗначение" Тогда
		Возврат;
	КонецЕсли;
	
	Если Элемент.ТекущиеДанные.ПометкаУдаления Тогда
		
		ПоказатьВопрос(
			Новый ОписаниеОповещения("ОперандыВыборЗавершение", ЭтотОбъект), 
			НСтр("ru = 'Выбранный элемент помечен на удаление. 
				|Продолжить?'"), 
			РежимДиалогаВопрос.ДаНет);
		СтандартнаяОбработка = Ложь;
		Возврат;
	КонецЕсли;
	
	СтандартнаяОбработка = Ложь;
	ВставитьОперандВФормулу();
	
КонецПроцедуры

&НаКлиенте
Процедура ОперандыВыборЗавершение(РезультатВопроса, ДополнительныеПараметры) Экспорт
	
	Если РезультатВопроса = КодВозвратаДиалога.Да Тогда
		ВставитьОперандВФормулу();
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ОперандыНачалоПеретаскивания(Элемент, ПараметрыПеретаскивания, СтандартнаяОбработка)
	
	ПараметрыПеретаскивания.Значение = ПолучитьТекстОперандаДляВставки(Элемент.ТекущиеДанные.Идентификатор);
	
КонецПроцедуры

&НаКлиенте
Процедура ОперандыОкончаниеПеретаскивания(Элемент, ПараметрыПеретаскивания, СтандартнаяОбработка)
	
	Если Элемент.ТекущиеДанные.ПометкаУдаления Тогда
		Ответ = Неопределено;
		ПоказатьВопрос(Новый ОписаниеОповещения("ОперандыОкончаниеПеретаскиванияЗавершение", ЭтотОбъект), НСтр("ru = 'Выбранный элемент помечен на удаление'") + Символы.ПС + НСтр("ru = 'Продолжить?'"), РежимДиалогаВопрос.ДаНет);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОперандыОкончаниеПеретаскиванияЗавершение(РезультатВопроса, ДополнительныеПараметры) Экспорт
	
	Ответ = РезультатВопроса;
	
	Если Ответ = КодВозвратаДиалога.Нет Тогда
		
		НачалоСтроки  = 0;
		НачалоКолонки = 0;
		КонецСтроки   = 0;
		КонецКолонки  = 0;
		
		Элементы.Формула.ПолучитьГраницыВыделения(НачалоСтроки, НачалоКолонки, КонецСтроки, КонецКолонки);
		Элементы.Формула.ВыделенныйТекст = "";
		Элементы.Формула.УстановитьГраницыВыделения(НачалоСтроки, НачалоКолонки, НачалоСтроки, НачалоКолонки);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ДеревоОперандовВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	ТекущиеДанные = Элементы.ДеревоОперандов.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	СтрокаРодитель = ТекущиеДанные.ПолучитьРодителя();
	Если СтрокаРодитель = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ВставитьТекстВФормулу(ПолучитьТекстОперандаДляВставки(
		СтрокаРодитель.Идентификатор + "." + ТекущиеДанные.Идентификатор));
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыДеревоОперандов

&НаКлиенте
Процедура ДеревоОперандовНачалоПеретаскивания(Элемент, ПараметрыПеретаскивания, Выполнение)
	
	Если ПараметрыПеретаскивания.Значение = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	СтрокаДерева = ДеревоОперандов.НайтиПоИдентификатору(ПараметрыПеретаскивания.Значение);
	СтрокаРодитель = СтрокаДерева.ПолучитьРодителя();
	Если СтрокаРодитель = Неопределено Тогда
		Выполнение = Ложь;
		Возврат;
	Иначе
		ПараметрыПеретаскивания.Значение = 
		   ПолучитьТекстОперандаДляВставки(СтрокаРодитель.Идентификатор +"." + СтрокаДерева.Идентификатор);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыОператоры

&НаКлиенте
Процедура ОператорыВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ВставитьОператорВФормулу();
	
КонецПроцедуры

&НаКлиенте
Процедура ОператорыНачалоПеретаскивания(Элемент, ПараметрыПеретаскивания, СтандартнаяОбработка)
	
	Если ЗначениеЗаполнено(Элемент.ТекущиеДанные.Оператор) Тогда
		ПараметрыПеретаскивания.Значение = Элемент.ТекущиеДанные.Оператор;
	Иначе
		СтандартнаяОбработка = Ложь;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОператорыОкончаниеПеретаскивания(Элемент, ПараметрыПеретаскивания, СтандартнаяОбработка)
	
	Если Элемент.ТекущиеДанные.Оператор = "Формат(,)" Тогда
		ФорматСтроки = Новый КонструкторФорматнойСтроки;
		ФорматСтроки.Показать(Новый ОписаниеОповещения("ОператорыОкончаниеПеретаскиванияЗавершение", ЭтотОбъект, Новый Структура("ФорматСтроки", ФорматСтроки)));
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОператорыОкончаниеПеретаскиванияЗавершение(Текст, ДополнительныеПараметры) Экспорт
	
	ФорматСтроки = ДополнительныеПараметры.ФорматСтроки;
	
	
	Если ЗначениеЗаполнено(ФорматСтроки.Текст) Тогда
		ТекстДляВставки = "Формат( , """ + ФорматСтроки.Текст + """)";
		Элементы.Формула.ВыделенныйТекст = ТекстДляВставки;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОК(Команда)
	
	ОчиститьСообщения();
	
	Если ПроверитьФормулу(Формула, ПолучитьМассивОперандов(), "Формула", СтроковаяФормула) Тогда
		Закрыть(Формула);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура Проверить(Команда)
	
	ОчиститьСообщения();
	ПроверитьФормулуИнтерактивно(Формула, ПолучитьМассивОперандов(), "Формула", СтроковаяФормула);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ВставитьТекстВФормулу(ТекстДляВставки, Сдвиг = 0)
	
	СтрокаНач = 0;
	СтрокаКон = 0;
	КолонкаНач = 0;
	КолонкаКон = 0;
	
	Элементы.Формула.ПолучитьГраницыВыделения(СтрокаНач, КолонкаНач, СтрокаКон, КолонкаКон);
	
	Если (КолонкаКон = КолонкаНач) И (КолонкаКон + СтрДлина(ТекстДляВставки)) > Элементы.Формула.Ширина / 8 Тогда
		Элементы.Формула.ВыделенныйТекст = "";
	КонецЕсли;
		
	Элементы.Формула.ВыделенныйТекст = ТекстДляВставки;
	
	Если Не Сдвиг = 0 Тогда
		Элементы.Формула.ПолучитьГраницыВыделения(СтрокаНач, КолонкаНач, СтрокаКон, КолонкаКон);
		Элементы.Формула.УстановитьГраницыВыделения(СтрокаНач, КолонкаНач - Сдвиг, СтрокаКон, КолонкаКон - Сдвиг);
	КонецЕсли;
		
	ТекущийЭлемент = Элементы.Формула;
	
КонецПроцедуры

&НаКлиенте
Процедура ВставитьОперандВФормулу()
	
	ВставитьТекстВФормулу(ПолучитьТекстОперандаДляВставки(Элементы.Операнды.ТекущиеДанные.Идентификатор));
	
КонецПроцедуры

&НаКлиенте
Функция ПолучитьМассивОперандов()
	
	МассивОперандов = Новый Массив();
	Для Каждого ТекСтрока Из Операнды Цикл
		МассивОперандов.Добавить(ТекСтрока.Идентификатор);
	КонецЦикла;
	
	Возврат МассивОперандов;
	
КонецФункции

&НаКлиенте
Процедура ВставитьОператорВФормулу()
	
	Если Элементы.Операторы.ТекущиеДанные.Наименование = "Формат" Тогда
		ФорматСтроки = Новый КонструкторФорматнойСтроки;
		ФорматСтроки.Показать(Новый ОписаниеОповещения("ВставитьОператорВФормулуЗавершение", ЭтотОбъект, Новый Структура("ФорматСтроки", ФорматСтроки)));
		Возврат;
	Иначе	
		ВставитьТекстВФормулу(Элементы.Операторы.ТекущиеДанные.Оператор, Элементы.Операторы.ТекущиеДанные.Сдвиг);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВставитьОператорВФормулуЗавершение(Текст, ДополнительныеПараметры) Экспорт
	
	ФорматСтроки = ДополнительныеПараметры.ФорматСтроки;
	
	Если ЗначениеЗаполнено(ФорматСтроки.Текст) Тогда
		ТекстДляВставки = "Формат( , """ + ФорматСтроки.Текст + """)";
		ВставитьТекстВФормулу(ТекстДляВставки, Элементы.Операторы.ТекущиеДанные.Сдвиг);
	Иначе	
		ВставитьТекстВФормулу(Элементы.Операторы.ТекущиеДанные.Оператор, Элементы.Операторы.ТекущиеДанные.Сдвиг);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Функция ОбработатьТекстОперанда(ТекстОперанда)
	
	ТекстСтроки = ТекстОперанда;
	ТекстСтроки = СтрЗаменить(ТекстСтроки, "[", "");
	ТекстСтроки = СтрЗаменить(ТекстСтроки, "]", "");
	Операнд = "[" + СтрЗаменить(ТекстСтроки, 
		?(НаборСвойств.НаборСвойствНоменклатуры, "Номенклатура.", 
			?(НЕ НаборСвойств.Свойство("НаборСвойствХарактеристик") ИЛИ НаборСвойств.НаборСвойствХарактеристик, "ХарактеристикаНоменклатуры.", "СерияНоменклатуры.")), "") + "]";
	
	Возврат Операнд
	
КонецФункции

&НаКлиенте
Процедура ФормулаПриИзменении(Элемент)
	
	Если Расширенный Тогда
		Представление = "";
	КонецЕсли;
	
	Если ВключитьЗначение Тогда
		УстановитьПредставлениеВычисленияПоФормуле(Формула, Операнды, Вычисление);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьВидимость()

	УстановитьСвойствоЭлементаФормы(
		Элементы,
		"ОперандыИдентификатор",
		"Видимость",
		Не Расширенный);
	
	УстановитьСвойствоЭлементаФормы(
		Элементы,
		"ОперандыПредставление",
		"Видимость",
		Расширенный);
	
	УстановитьСвойствоЭлементаФормы(
		Элементы,
		"ОперандыЗначение",
		"Видимость",
		ВключитьЗначение);
		
	УстановитьСвойствоЭлементаФормы(
		Элементы,
		"Вычисление",
		"Видимость",
		ВключитьЗначение);
		
	УстановитьСвойствоЭлементаФормы(
		Элементы,
		"ДекорацияАвтоСумма",
		"Видимость",
		ВключитьЗначение);
		
	УстановитьСвойствоЭлементаФормы(
		Элементы,
		"Операнды",
		"Шапка",
		ВключитьЗначение);
		
	УстановитьСвойствоЭлементаФормы(
		Элементы,
		"Операторы",
		"Шапка",
		ВключитьЗначение);
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьПредставлениеВычисленияПоФормуле(Знач РасчетнаяФормула, Операнды, Представление)
	
	Если Не ЗначениеЗаполнено(РасчетнаяФормула) Тогда
		Представление = "";
		Возврат;
	КонецЕсли;
	
	РасчетнаяФормула = УдалениеНезначимыхСимволов(РасчетнаяФормула);
	ВыводитьПромежуточныеВычисления = Ложь;
	
	МассивОперандов = ПолучитьМассивОперандовТекстовойФормулы(РасчетнаяФормула);
	
	Для каждого Операнд Из МассивОперандов Цикл
		НайденныйСтроки = Операнды.НайтиСтроки(Новый Структура("Идентификатор", Операнд));
		Если НайденныйСтроки.Количество() = 1 Тогда
			Если НЕ ВыводитьПромежуточныеВычисления Тогда
				ВыводитьПромежуточныеВычисления = НЕ ПустаяСтрока(УдалениеНезначимыхСимволов(СтрЗаменить(РасчетнаяФормула, "["+Операнд+"]", "")));
			КонецЕсли;
			РасчетнаяФормула = СтрЗаменить(РасчетнаяФормула, "["+Операнд+"]", Формат(НайденныйСтроки[0].Значение, "ЧРД=.; ЧН=0; ЧГ=0"));
		КонецЕсли;
	КонецЦикла;
	
	Попытка
		РезультатВычисления = Формат(Вычислить(РасчетнаяФормула),"ЧЦ=15; ЧДЦ=3; ЧН=0");
	Исключение
		Возврат;
	КонецПопытки;
	
	Представление = ?(ВыводитьПромежуточныеВычисления, РасчетнаяФормула, "") + ?(ЗначениеЗаполнено(РасчетнаяФормула), " = ", "") + РезультатВычисления;
	
	Представление = УдалениеНезначимыхСимволов(Представление);
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Функция УдалениеНезначимыхСимволов(Знач ВходящаяСтрока)
	
	ВходящаяСтрока = СокрЛП(ВходящаяСтрока);
	ДлинаСтроки = СтрДлина(ВходящаяСтрока);
	КонечнаяСтрока = Строка("");
	
	Пока ДлинаСтроки > 0 Цикл 
		
		ПервыйСимвол = Лев(ВходящаяСтрока, 1);
		
		Если Не ПустаяСтрока(ПервыйСимвол) Тогда
			КонечнаяСтрока = КонечнаяСтрока + ПервыйСимвол;
			ДлинаСтроки = ДлинаСтроки - 1;
			Отступ = 2;
		Иначе
			КонечнаяСтрока = КонечнаяСтрока + " ";
			ВходящаяСтрока = СокрЛ(ВходящаяСтрока);
			ДлинаСтроки = СтрДлина(ВходящаяСтрока);
			Отступ = 1;
		КонецЕсли;
		
		Если ДлинаСтроки > 1 Тогда
			ВходящаяСтрока = Сред(ВходящаяСтрока, Отступ, ДлинаСтроки);
		Иначе
			КонечнаяСтрока = КонечнаяСтрока + Сред(ВходящаяСтрока, Отступ, 1);
			ДлинаСтроки = 0; 
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат КонечнаяСтрока;
	
КонецФункции

&НаСервере
Функция ПолучитьПустоеДеревоОператоров()
	
	Дерево = Новый ДеревоЗначений();
	Дерево.Колонки.Добавить("Наименование");
	Дерево.Колонки.Добавить("Оператор");
	Дерево.Колонки.Добавить("Сдвиг", Новый ОписаниеТипов("Число"));
	
	Возврат Дерево;
	
КонецФункции

&НаСервере
Функция ДобавитьГруппуОператоров(Дерево, Наименование)
	
	НоваяГруппа = Дерево.Строки.Добавить();
	НоваяГруппа.Наименование = Наименование;
	
	Возврат НоваяГруппа;
	
КонецФункции

&НаСервере
Функция ДобавитьОператор(Дерево, Родитель, Наименование, Оператор = Неопределено, Сдвиг = 0)
	
	НоваяСтрока = ?(Родитель <> Неопределено, Родитель.Строки.Добавить(), Дерево.Строки.Добавить());
	НоваяСтрока.Наименование = Наименование;
	НоваяСтрока.Оператор = ?(ЗначениеЗаполнено(Оператор), Оператор, Наименование);
	НоваяСтрока.Сдвиг = Сдвиг;
	
	Возврат НоваяСтрока;
	
КонецФункции

&НаСервере
Функция ПолучитьСтандартноеДеревоОператоров()
	
	Дерево = ПолучитьПустоеДеревоОператоров();
	
	ГруппаОператоров = ДобавитьГруппуОператоров(Дерево, НСтр("ru='Разделители'"));
	
	ДобавитьОператор(Дерево, ГруппаОператоров, "/", " + ""/"" + ");
	ДобавитьОператор(Дерево, ГруппаОператоров, "\", " + ""\"" + ");
	ДобавитьОператор(Дерево, ГруппаОператоров, "|", " + ""|"" + ");
	ДобавитьОператор(Дерево, ГруппаОператоров, "_", " + ""_"" + ");
	ДобавитьОператор(Дерево, ГруппаОператоров, ",", " + "", "" + ");
	ДобавитьОператор(Дерево, ГруппаОператоров, ".", " + "". "" + ");
	ДобавитьОператор(Дерево, ГруппаОператоров, НСтр("ru='Пробел'"), " + "" "" + ");
	ДобавитьОператор(Дерево, ГруппаОператоров, "(", " + "" ("" + ");
	ДобавитьОператор(Дерево, ГруппаОператоров, ")", " + "") "" + ");
	ДобавитьОператор(Дерево, ГруппаОператоров, """", " + """""""" + ");
	
	ГруппаОператоров = ДобавитьГруппуОператоров(Дерево, НСтр("ru='Операторы'"));
	
	ДобавитьОператор(Дерево, ГруппаОператоров, "+", " + ");
	ДобавитьОператор(Дерево, ГруппаОператоров, "-", " - ");
	ДобавитьОператор(Дерево, ГруппаОператоров, "*", " * ");
	ДобавитьОператор(Дерево, ГруппаОператоров, "/", " / ");
	
	ГруппаОператоров = ДобавитьГруппуОператоров(Дерево, НСтр("ru='Логические операторы и константы'"));
	ДобавитьОператор(Дерево, ГруппаОператоров, "<", " < ");
	ДобавитьОператор(Дерево, ГруппаОператоров, ">", " > ");
	ДобавитьОператор(Дерево, ГруппаОператоров, "<=", " <= ");
	ДобавитьОператор(Дерево, ГруппаОператоров, ">=", " >= ");
	ДобавитьОператор(Дерево, ГруппаОператоров, "=", " = ");
	ДобавитьОператор(Дерево, ГруппаОператоров, "<>", " <> ");
	ДобавитьОператор(Дерево, ГруппаОператоров, НСтр("ru='И'"),      " " + НСтр("ru='И'")      + " ");
	ДобавитьОператор(Дерево, ГруппаОператоров, НСтр("ru='Или'"),    " " + НСтр("ru='Или'")    + " ");
	ДобавитьОператор(Дерево, ГруппаОператоров, НСтр("ru='Не'"),     " " + НСтр("ru='Не'")     + " ");
	ДобавитьОператор(Дерево, ГруппаОператоров, НСтр("ru='ИСТИНА'"), " " + НСтр("ru='ИСТИНА'") + " ");
	ДобавитьОператор(Дерево, ГруппаОператоров, НСтр("ru='ЛОЖЬ'"),   " " + НСтр("ru='ЛОЖЬ'")   + " ");
	
	ГруппаОператоров = ДобавитьГруппуОператоров(Дерево, НСтр("ru='Числовые функции'"));
	
	ДобавитьОператор(Дерево, ГруппаОператоров, НСтр("ru='Максимум'"),    НСтр("ru='Макс(,)'"), 2);
	ДобавитьОператор(Дерево, ГруппаОператоров, НСтр("ru='Минимум'"),     НСтр("ru='Мин(,)'"),  2);
	ДобавитьОператор(Дерево, ГруппаОператоров, НСтр("ru='Округление'"),  НСтр("ru='Окр(,)'"),  2);
	ДобавитьОператор(Дерево, ГруппаОператоров, НСтр("ru='Целая часть'"), НСтр("ru='Цел()'"),   1);
	
	ГруппаОператоров = ДобавитьГруппуОператоров(Дерево, НСтр("ru='Строковые функции'"));
	
	ДобавитьОператор(Дерево, ГруппаОператоров, НСтр("ru='Строка'"), НСтр("ru='Строка()'"));
	ДобавитьОператор(Дерево, ГруппаОператоров, НСтр("ru='ВРег'"), НСтр("ru='ВРег()'"));
	ДобавитьОператор(Дерево, ГруппаОператоров, НСтр("ru='Лев'"), НСтр("ru='Лев()'"));
	ДобавитьОператор(Дерево, ГруппаОператоров, НСтр("ru='НРег'"), НСтр("ru='НРег()'"));
	ДобавитьОператор(Дерево, ГруппаОператоров, НСтр("ru='Прав'"), НСтр("ru='Прав()'"));
	ДобавитьОператор(Дерево, ГруппаОператоров, НСтр("ru='СокрЛ'"), НСтр("ru='СокрЛ()'"));
	ДобавитьОператор(Дерево, ГруппаОператоров, НСтр("ru='СокрЛП'"), НСтр("ru='СокрЛП()'"));
	ДобавитьОператор(Дерево, ГруппаОператоров, НСтр("ru='СокрП'"), НСтр("ru='СокрП()'"));
	ДобавитьОператор(Дерево, ГруппаОператоров, НСтр("ru='ТРег'"), НСтр("ru='ТРег()'"));
	ДобавитьОператор(Дерево, ГруппаОператоров, НСтр("ru='СтрЗаменить'"), НСтр("ru='СтрЗаменить(,,)'"));
	ДобавитьОператор(Дерево, ГруппаОператоров, НСтр("ru='СтрДлина'"), НСтр("ru='СтрДлина()'"));
	
	ГруппаОператоров = ДобавитьГруппуОператоров(Дерево, НСтр("ru='Прочие функции'"));
	
	ДобавитьОператор(Дерево, ГруппаОператоров, НСтр("ru='Условие'"), "?(,,)", 3);
	ДобавитьОператор(Дерево, ГруппаОператоров, НСтр("ru='Предопределенное значение'"), НСтр("ru='ПредопределенноеЗначение()'"));
	ДобавитьОператор(Дерево, ГруппаОператоров, НСтр("ru='Значение заполнено'"), НСтр("ru='ЗначениеЗаполнено()'"));
	ДобавитьОператор(Дерево, ГруппаОператоров, НСтр("ru='Формат'"), НСтр("ru='Формат(,)'"));
	
	Возврат Дерево;
	
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Функция ПолучитьТекстОперандаДляВставки(Операнд)
	
	Возврат "[" + Операнд + "]";
	
КонецФункции

&НаКлиенте
Функция ПроверитьФормулу(Формула, Операнды, Знач Поле = "", СтроковаяФормула = Ложь)
	
	ПутьКДанным = "";
	Результат = Истина;
	ВыводитьСообщения = Истина;
	
	Если ЗначениеЗаполнено(Формула) Тогда
		
		Если СтроковаяФормула Тогда
			ТекстРасчета = """Строка"" + " + Формула;
			ЗначениеЗамены = """1""";
		Иначе
			ЗначениеЗамены = 1;
			ТекстРасчета = Формула;
		КонецЕсли;
		
		Для Каждого Операнд Из Операнды Цикл
			ТекстРасчета = СтрЗаменить(ТекстРасчета, ПолучитьТекстОперандаДляВставки(Операнд), ЗначениеЗамены);
		КонецЦикла;
		
		Если СтрНачинаетсяС(ТекстРасчета, "=") Тогда
			ТекстРасчета = Сред(ТекстРасчета, 2);
		КонецЕсли;
			
		Попытка
			РезультатРасчета = Вычислить(ТекстРасчета);
			
			Если СтроковаяФормула Тогда
				ТекстПроверки = СтрЗаменить(Формула, " ", "");
				ОтсутствиеРазделителей = СтрНайти(ТекстПроверки, "][");
				Если ОтсутствиеРазделителей > 0 Тогда
					СообщитьПользователю(
						НСтр("ru='В формуле обнаружены ошибки. Между операндами должен присутствовать оператор или разделитель'"),
						Поле,
						ПутьКДанным);
					Результат = Ложь;
				КонецЕсли;
			КонецЕсли;
		Исключение
			Результат = Ложь;
			СообщитьПользователю(
				НСтр("ru='В формуле обнаружены ошибки. Проверьте формулу. Формулы должны составляться по правилам написания выражений на встроенном языке 1С:Предприятия.'"),
				Поле,
				ПутьКДанным);
		КонецПопытки;
		
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции 

&НаКлиентеНаСервереБезКонтекста
Функция ПолучитьМассивОперандовТекстовойФормулы(Формула)
	
	МассивОперандов = Новый Массив();
	
	ТекстФормулы = СокрЛП(Формула);
	Если СтрЧислоВхождений(ТекстФормулы, "[") <> СтрЧислоВхождений(ТекстФормулы, "]") Тогда
		ЕстьОперанды = Ложь;
	Иначе
		ЕстьОперанды = Истина;
	КонецЕсли;
	
	Пока ЕстьОперанды = Истина Цикл
		НачалоОперанда = СтрНайти(ТекстФормулы, "[");
		КонецОперанда = СтрНайти(ТекстФормулы, "]");
		
		Если НачалоОперанда = 0
			Или КонецОперанда = 0
			Или НачалоОперанда > КонецОперанда Тогда
			ЕстьОперанды = Ложь;
			Прервать;
			
		КонецЕсли;
		
		ИмяОперанда = Сред(ТекстФормулы, НачалоОперанда + 1, КонецОперанда - НачалоОперанда - 1);
		МассивОперандов.Добавить(ИмяОперанда);
		ТекстФормулы = СтрЗаменить(ТекстФормулы, "[" + ИмяОперанда + "]", "");
		КонецПрошлогоОперанда = КонецОперанда;
		
	КонецЦикла;
	
	Возврат МассивОперандов
	
КонецФункции


&НаКлиенте
Процедура ПроверитьФормулуИнтерактивно(Формула, Операнды, Знач Поле, СтроковаяФормула = Ложь)
	
	Если ЗначениеЗаполнено(Формула) Тогда
		Если ПроверитьФормулу(Формула, Операнды, Поле, СтроковаяФормула) Тогда
			ПоказатьОповещениеПользователя(
				НСтр("ru = 'В формуле ошибок не обнаружено'"),
				,
				,
				КартинкаИнформация32());
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция КартинкаИнформация32()
	Если ВерсияБСПСоответствуетТребованиям() Тогда
		Возврат БиблиотекаКартинок["Информация32"];
	Иначе
		Возврат Новый Картинка;
	КонецЕсли;
КонецФункции

&НаСервере
Функция ВерсияБСПСоответствуетТребованиям()
	ОбработкаОбъект = РеквизитФормыВЗначение("Объект");
	Возврат ОбработкаОбъект.ВерсияБСПСоответствуетТребованиям();
КонецФункции

&НаСервере
Процедура УстановитьСвойствоЭлементаФормы(ЭлементыФормы, ИмяЭлемента, ИмяСвойства, Значение)
	
	ЭлементФормы = ЭлементыФормы.Найти(ИмяЭлемента);
	Если ЭлементФормы <> Неопределено И ЭлементФормы[ИмяСвойства] <> Значение Тогда
		ЭлементФормы[ИмяСвойства] = Значение;
	КонецЕсли;
	
КонецПроцедуры 

&НаКлиенте
Процедура СообщитьПользователю(Знач ТекстСообщенияПользователю, Знач Поле = "", Знач ПутьКДанным = "")
	Сообщение = Новый СообщениеПользователю;
	Сообщение.Текст = ТекстСообщенияПользователю;
	Сообщение.Поле = Поле;
	
	Если НЕ ПустаяСтрока(ПутьКДанным) Тогда
		Сообщение.ПутьКДанным = ПутьКДанным;
	КонецЕсли;
		
	Сообщение.Сообщить();
КонецПроцедуры

#КонецОбласти
