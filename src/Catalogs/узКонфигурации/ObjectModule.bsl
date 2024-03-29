
Процедура ПередЗаписью(Отказ)
	ПроверитьРеквизиты(Отказ);
	Если Отказ Тогда
		Возврат;
	Конецесли;
КонецПроцедуры

Процедура ПроверитьРеквизиты(Отказ)
	МассивПроверяемыхРеквизитов = ПолучитьМассивПроверяемыхРеквизитов();
	Для каждого ИмяРеквизита из МассивПроверяемыхРеквизитов цикл
		ЗначениеРеквизита = ЭтотОбъект[ИмяРеквизита];
		Если НЕ ЗначениеЗаполнено(ЗначениеРеквизита) Тогда
			Сообщение = Новый СообщениеПользователю;
			Сообщение.Текст = "Ошибка! не заполнен реквизит ["+ИмяРеквизита+"]";
			Сообщение.Поле = "Объект."+ИмяРеквизита;
			Сообщение.Сообщить();
			Отказ = Истина;
		Конецесли;
	Конеццикла;
КонецПроцедуры 

Функция ПолучитьМассивПроверяемыхРеквизитов() Экспорт 
	МассивПроверяемыхРеквизитов = Новый Массив();
	Если НЕ ЭтоГруппа 
		И ПолучатьИзмененияИзХранилища Тогда
		
		// +++ 79Vlad  10.10.2018
		Если НЕ ИспользоватьАльтернативнуюЗагрузкуДанныхИзХранилища Тогда
			//Нет необходимости в заполнении данных параметров
			// --- 79Vlad  10.10.2018			
			МассивПроверяемыхРеквизитов.Добавить("Приложение1с");
			МассивПроверяемыхРеквизитов.Добавить("КаталогТранзитнойБазы");
			МассивПроверяемыхРеквизитов.Добавить("ПользовательТранзитнойБазы");
			МассивПроверяемыхРеквизитов.Добавить("ПарольПользователяВТранзитнуюБазу");
			МассивПроверяемыхРеквизитов.Добавить("ПользовательХранилища");
			МассивПроверяемыхРеквизитов.Добавить("ПарольПользователяВХранилище");
			// +++ 79Vlad  10.10.2018
		КонецЕсли; 
		// --- 79Vlad  10.10.2018
		
		МассивПроверяемыхРеквизитов.Добавить("КаталогХранилища");
		
	Конецесли;
	Возврат МассивПроверяемыхРеквизитов; 
КонецФункции 
