
#Область ОбработчикиСобытий

&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	ПараметрыРаботы = СтандартныеПодсистемыКлиентПовтИсп.ПараметрыРаботыКлиентаПриЗапуске();
	ПараметрыРезервногоКопирования = ПараметрыРаботы.РезервноеКопированиеИБ;
	
	ПараметрыФормы = Новый Структура();
	
	Если ПараметрыРезервногоКопирования.Свойство("РезультатКопирования") Тогда
		ПараметрыФормы.Вставить("РежимРаботы", ?(ПараметрыРезервногоКопирования.РезультатКопирования, "УспешноВыполнено", "НеВыполнено"));
		ПараметрыФормы.Вставить("ИмяФайлаРезервнойКопии", ПараметрыРезервногоКопирования.ИмяФайлаРезервнойКопии);
	КонецЕсли;
	
	ОткрытьФорму("Обработка.РезервноеКопированиеИБ.Форма.РезервноеКопированиеДанных", ПараметрыФормы);
	
КонецПроцедуры

#КонецОбласти