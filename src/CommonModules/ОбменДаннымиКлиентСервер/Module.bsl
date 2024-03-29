////////////////////////////////////////////////////////////////////////////////
// Подсистема "Обмен данными"
// 
////////////////////////////////////////////////////////////////////////////////

#Область СлужебныеПроцедурыИФункции

// Для внутреннего использования.
//
Процедура ПроверитьНедопустимыеСимволыВИмениПользователяWSПрокси(Знач ИмяПользователя) Экспорт
	
	Если СтрокаСодержитСимвол(ИмяПользователя, НедопустимыеСимволыВИмениПользователяWSПрокси()) Тогда
		
		СтрокаСообщения = НСтр("ru = 'В имени пользователя %1 содержатся недопустимые символы.
			|Имя пользователя не должно содержать символы %2.'");
		СтрокаСообщения = СтрШаблон(СтрокаСообщения, ИмяПользователя, НедопустимыеСимволыВИмениПользователяWSПрокси());
		ВызватьИсключение СтрокаСообщения;
	КонецЕсли;
	
КонецПроцедуры

// Для внутреннего использования.
//
Процедура ПроверитьКорректностьФорматаАдресаWSПрокси(Знач АдресWSПрокси) Экспорт
	
	ЭтоИнтернетАдрес           = Ложь;
	ДопустимыеПрефиксыWSПрокси = ДопустимыеПрефиксыWSПрокси();
	
	Для Каждого Префикс Из ДопустимыеПрефиксыWSПрокси Цикл
		Если Лев(НРег(АдресWSПрокси), СтрДлина(Префикс)) = НРег(Префикс) Тогда
			ЭтоИнтернетАдрес = Истина;
			Прервать;
		КонецЕсли;
	КонецЦикла;
	
	Если Не ЭтоИнтернетАдрес Тогда
		СтрокаПрефиксов = "";
		Для Каждого Префикс Из ДопустимыеПрефиксыWSПрокси Цикл
			СтрокаПрефиксов = СтрокаПрефиксов + ?(ПустаяСтрока(СтрокаПрефиксов), """", " или """) + Префикс + """";
		КонецЦикла;
		
		СтрокаСообщения = НСтр("ru = 'Неверный формат адреса ""%1"".
			|Адрес должен начинаться с префикса Интернет протокола %2 (например: ""http://myserver.com/service"").'");
			
		СтрокаСообщения = СтрШаблон(СтрокаСообщения, АдресWSПрокси, СтрокаПрефиксов);
		
		ВызватьИсключение СтрокаСообщения;
	КонецЕсли;
	
КонецПроцедуры

// Для внутреннего использования.
//
Функция НедопустимыеСимволыВИмениПользователяWSПрокси() Экспорт
	
	Возврат ":";
	
КонецФункции

// Для внутреннего использования.
//
Функция ДопустимыеПрефиксыWSПрокси()
	
	Результат = Новый Массив();
	
	Результат.Добавить("http");
	Результат.Добавить("https");
	
	Возврат Результат;
	
КонецФункции

// Для внутреннего использования.
//
Функция СтрокаСодержитСимвол(Знач Строка, Знач СтрокаСимволов)
	
	Для Индекс = 1 По СтрДлина(СтрокаСимволов) Цикл
		Символ = Сред(СтрокаСимволов, Индекс, 1);
		
		Если СтрНайти(Строка, Символ) <> 0 Тогда
			Возврат Истина;
		КонецЕсли;
	КонецЦикла;
	
	Возврат Ложь;
КонецФункции

#КонецОбласти
