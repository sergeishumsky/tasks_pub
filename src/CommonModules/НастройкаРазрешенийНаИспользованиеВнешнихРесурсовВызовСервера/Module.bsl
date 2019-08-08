////////////////////////////////////////////////////////////////////////////////
// Подсистема "Базовая функциональность".
// Серверные процедуры и функции общего назначения:
// - Управление разрешениями в профилях безопасности из текущей ИБ.
//
////////////////////////////////////////////////////////////////////////////////

#Область СлужебныеПроцедурыИФункции

// Проверяет завершение операции применения разрешений на использование внешних ресурсов.
// Используется для диагностики ситуаций, в которых изменения в настройки профилей безопасности
// в кластере серверов были внесены, но не была завершена операция, в рамках которой требовалось
// изменить настройки разрешений на использование внешних ресурсов.
//
// Возвращаемое значение - Структура:
//  РезультатПроверки - Булево - если Ложь - то операция не была завершена и требуется предложить
//                      пользователю выполнить отмену изменений в настройках профилей
//                      безопасности в кластере серверов,
//  ИдентификаторыЗапросов - Массив(УникальныйИдентификатор) - массив идентификаторов запросов
//                           на использование внешних ресурсов, которые должны быть применены для
//                           отмены изменений в настройках профилей безопасности в кластере серверов,
//  АдресВременногоХранилища - Строка - адрес во временном хранилище, по которому было помещено
//                             состояние применения запросов разрешений, которые должны быть применены
//                             для отмены изменений в настройках профилей безопасности в кластере
//                             серверов,
//  АдресВременногоХранилищаСостояния - Строка - адрес во временном хранилище, по которому было помещено
//                                      внутреннее состояние обработки.
//                                      НастройкаРазрешенийНаИспользованиеВнешнихРесурсов.
//
Функция ПроверитьПрименениеРазрешенийНаИспользованиеВнешнихРесурсов() Экспорт
	
	Возврат Обработки.НастройкаРазрешенийНаИспользованиеВнешнихРесурсов.ВыполнитьОбработкуЗапросовПроверкиПрименения();
	
КонецФункции

// Удаляет запросы на использование внешних ресурсов, если пользователь отказался от их применения.
//
// Параметры:
//  ИдентификаторыЗапросов - Массив(УникальныйИдентификатор) - массив идентификаторов запросов на
//                           использование внешних ресурсов.
//
Процедура ОтменаПримененияЗапросовНаИспользованиеВнешнихРесурсов(Знач ИдентификаторыЗапросов) Экспорт
	
	РегистрыСведений.ЗапросыРазрешенийНаИспользованиеВнешнихРесурсов.УдалитьЗапросы(ИдентификаторыЗапросов);
	
КонецПроцедуры

#КонецОбласти
