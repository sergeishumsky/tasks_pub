#Область ОбработчикиСобытий

&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	ПолноеИмяФормы = "Справочник.УчетныеЗаписиЭлектроннойПочты.ФормаОбъекта";
	
	ПараметрыФормы = Новый Структура("Ключ", ПредопределенноеЗначение("Справочник.УчетныеЗаписиЭлектроннойПочты.СистемнаяУчетнаяЗаписьЭлектроннойПочты"));
	
	ВладелецФормы = ПараметрыВыполненияКоманды.Источник;
	УникальностьФормы = ПараметрыВыполненияКоманды.Уникальность;
	
	#Если ВебКлиент Тогда
	ОкноФормы = ПараметрыВыполненияКоманды.Окно;
	#Иначе
	ОкноФормы = ПараметрыВыполненияКоманды.Источник;
	#КонецЕсли
	
	ОткрытьФорму(ПолноеИмяФормы, ПараметрыФормы, ВладелецФормы, УникальностьФормы, ОкноФормы);
	
КонецПроцедуры

#КонецОбласти
