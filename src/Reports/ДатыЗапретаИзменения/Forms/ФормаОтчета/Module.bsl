
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	УстановитьВариантНаСервере();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ПервыйВариант(Команда)
	
	УстановитьВариантНаСервере(1);
	
КонецПроцедуры

&НаКлиенте
Процедура ВторойВариант(Команда)
	
	УстановитьВариантНаСервере(2);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьВариантНаСервере(Вариант = 0)
	
	Отчеты.ДатыЗапретаИзменения.УстановитьВариант(ЭтотОбъект, Вариант);
	
КонецПроцедуры

#КонецОбласти
