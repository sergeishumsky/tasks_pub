
&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	Если ТипЗнч(ПараметрКоманды) = Тип("СправочникСсылка.узЗадачи") Тогда
		Массив = Новый Массив;
		Массив.Добавить(ПараметрКоманды);
	ИначеЕсли ТипЗнч(ПараметрКоманды) = Тип("Массив") Тогда	
		Массив = ПараметрКоманды;
	КонецЕсли;
	
	узОбщийМодульКлиент.СоздатьФайлДляЗадачиНаДиске(Массив);
	
КонецПроцедуры
