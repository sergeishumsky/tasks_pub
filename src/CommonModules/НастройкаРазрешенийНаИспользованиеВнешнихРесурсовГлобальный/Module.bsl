////////////////////////////////////////////////////////////////////////////////
// Подсистема "Базовая функциональность".
// Серверные процедуры и функции общего назначения:
// - Управление разрешениями в профилях безопасности из текущей ИБ.
//
////////////////////////////////////////////////////////////////////////////////

#Область СлужебныеПроцедурыИФункции

// Выполняет асинхронную обработку оповещения о закрытии форм мастера настройки разрешений на
// использование внешних ресурсов при вызове через подключение обработчика ожидания.
// В качестве результата в обработчик передается значение КодВозвратаДиалога.ОК.
//
// Процедура не предназначена для непосредственного вызова.
//
Процедура ЗавершитьНастройкуРазрешенийНаИспользованиеВнешнихРесурсов() Экспорт
	
	НастройкаРазрешенийНаИспользованиеВнешнихРесурсовКлиент.ЗавершитьНастройкуРазрешенийНаИспользованиеВнешнихРесурсовСинхронно(КодВозвратаДиалога.ОК);
	
КонецПроцедуры

// Выполняет асинхронную обработку оповещения о закрытии форм мастера настройки разрешений на
// использование внешних ресурсов при вызове через подключение обработчика ожидания.
// В качестве результата в обработчик передается значение КодВозвратаДиалога.Отмена.
//
// Процедура не предназначена для непосредственного вызова.
//
Процедура ПрерватьНастройкуРазрешенийНаИспользованиеВнешнихРесурсов() Экспорт
	
	НастройкаРазрешенийНаИспользованиеВнешнихРесурсовКлиент.ЗавершитьНастройкуРазрешенийНаИспользованиеВнешнихРесурсовСинхронно(КодВозвратаДиалога.Отмена);
	
КонецПроцедуры

#КонецОбласти