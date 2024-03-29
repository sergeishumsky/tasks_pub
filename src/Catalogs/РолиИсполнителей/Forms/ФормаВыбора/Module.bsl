#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	ТолькоПростыеРоли = Ложь;
	Если Параметры.Свойство("ТолькоПростыеРоли", ТолькоПростыеРоли) И ТолькоПростыеРоли = Истина Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
			Список, "ВнешняяРоль", Истина, , , Истина);
		КонецЕсли;
		
	ОтборГде = " ГДЕ РолиИсполнителейНазначение.ТипПользователей = ЗНАЧЕНИЕ(Справочник.Пользователи.ПустаяСсылка)";
	ЭтоВнешнийПользователь = ПользователиКлиентСервер.ЭтоСеансВнешнегоПользователя();
	Если ЭтоВнешнийПользователь Тогда
		Если Элементы.КоманднаяПанель.ПодчиненныеЭлементы.Найти("ФормаИзменить") <> Неопределено Тогда
			Элементы.КоманднаяПанель.ПодчиненныеЭлементы.ФормаИзменить.Видимость = Ложь;
		КонецЕсли;
		ТекущийВнешнийПользователь =  ПользователиКлиентСервер.ТекущийВнешнийПользователь();
		Имя = ТекущийВнешнийПользователь.ОбъектАвторизации.Метаданные().Имя;
		ОтборГде = " ГДЕ РолиИсполнителейНазначение.ТипПользователей = ЗНАЧЕНИЕ(Справочник." + Имя + ".ПустаяСсылка)";
	КонецЕсли;
	Список.ТекстЗапроса = Список.ТекстЗапроса + ОтборГде;

	
КонецПроцедуры

&НаКлиенте
Процедура СписокПередНачаломИзменения(Элемент, Отказ)
	Если ЭтоВнешнийПользователь Тогда
		Отказ =Истина;
	КонецЕсли;
КонецПроцедуры

#КонецОбласти
