
&НаСервереБезКонтекста
Процедура ЗаполнитьНастройкамиПоУмолчаниюНаСервере()
	
	РегистрыСведений.узПроксиСерверы.ЗаполнитьНастройкамиПоУмолчанию();	
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьНастройкамиПоУмолчанию(Команда)
	ЗаполнитьНастройкамиПоУмолчаниюНаСервере();
	Элементы.Список.Обновить();
КонецПроцедуры
