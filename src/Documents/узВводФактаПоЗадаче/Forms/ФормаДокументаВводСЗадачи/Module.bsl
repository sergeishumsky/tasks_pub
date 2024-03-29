
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Объект.Дата = ТекущаяДата();
	//Павлюков
	ДатаОкончания = Объект.Дата;
	
	Если Параметры.Свойство("Задача") Тогда 
		Объект.Задача = Параметры.Задача;
	КонецЕсли;
	
	Если Параметры.Свойство("Исполнитель") Тогда 
		Объект.Исполнитель = Параметры.Исполнитель;
	КонецЕсли;
	
	Спринт = Справочники.узСпринты.ПолучитьТекущийСпринтДляЗадачи(КонецДня(Объект.Дата), Объект.Задача);
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
	
	ЗаполнитьРеквизитыЗадачиНаСервере();
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьРеквизитыЗадачиНаСервере()
	
	СтрокаДанных = Объект.Данные.Добавить();
	СтрокаДанных.Спринт = Спринт;
	СтрокаДанных.ДатаНачала = ДатаНачала;
	СтрокаДанных.ДатаОкончания = ДатаОкончания;
	СтрокаДанных.Факт = Факт;
	СтрокаДанных.Примечание = Примечание;
	
КонецПроцедуры

&НаКлиенте
Процедура ФактПриИзменении(Элемент)
	
	Если Не ЗначениеЗаполнено(ДатаНачала) Тогда
		
		ДатаНачала = ДатаОкончания - Факт * 3600;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	Оповестить("узВводФактаПоЗадачеЗаписан");
КонецПроцедуры

// +++ 79Vlad  25.10.2018
&НаКлиенте
Процедура ДатаНачалаОткрытие(Элемент, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	ДатаНачала = НачалоМинуты(ТекущаяДата());  
	Если НЕ ЗначениеЗаполнено(ДатаОкончания)
		ИЛИ ДатаНачала > ДатаОкончания Тогда
		ДатаОкончания = ПолучитьДатаОкончания(ДатаНачала);
	Конецесли;
	ИзменитьЧасыФактДляСтроки();

КонецПроцедуры
// --- 79Vlad  25.10.2018

// +++ 79Vlad  25.10.2018
&НаКлиенте
Функция ПолучитьДатаОкончания(ОтДаты) 
	пДатаОкончания = НачалоМинуты(КонецМинуты(ОтДаты)+1);		
	Возврат пДатаОкончания;
КонецФункции
// --- 79Vlad  25.10.2018

// +++ 79Vlad  25.10.2018
&НаКлиенте
Функция ПолучитьКоличествоЧасовПоРазностиДат(ДатаНач, ДатаКон)
	Часов = 0;
	
	Если ДатаКон > ДатаНач Тогда
		Часов = (ДатаКон - ДатаНач) / 3600;
	КонецЕсли; 
	
	Возврат Часов;
КонецФункции
// --- 79Vlad  25.10.2018

// +++ 79Vlad  25.10.2018
&НаКлиенте
Процедура ИзменитьЧасыФактДляСтроки()
	Факт = ПолучитьКоличествоЧасовПоРазностиДат(ДатаНачала, ДатаОкончания);	
КонецПроцедуры
// --- 79Vlad  25.10.2018

// +++ 79Vlad  25.10.2018
&НаКлиенте
Процедура ДатаОкончанияОткрытие(Элемент, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	
	ДатаОкончания = ПолучитьДатаОкончания(ТекущаяДата());  
	ИзменитьЧасыФактДляСтроки();
КонецПроцедуры
// --- 79Vlad  25.10.2018
