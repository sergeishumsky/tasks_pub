
////////////////////////////////////////////////////////////////////////////////
// Подсистема "Взаимодействия"
// 
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Возвращает текст запроса, отбирающего контакты (участников) предмета взаимодействия.
// Используется, если в конфигурации определен хотя бы один предмет взаимодействий.
//
// Параметры:
//  ПомещатьВоВременнуюТаблицу - Булево - признак того, что результат выполнения запроса 
//                                        необходимо поместить во временную таблицу.
//  ИмяТаблицы                 - Строка - имя таблицы предмета взаимодействий, в котором будет выполнен поиск.
//
Функция ПолучитьТекстЗапросаПоискКонтактовПоПредмету(
	ПомещатьВоВременнуюТаблицу,
	ИмяТаблицы,
	Объединить = Ложь) Экспорт
	
	
	
	Возврат "";
	
КонецФункции

// Возможность переопределить владельца присоединенных файлов для письма.
// Такая необходимость может возникнуть например при массовых рассылках. В этом случае имеет смысл 
// хранить одни и те же присоединенные файлы в одном месте, а не тиражировать их на все письма рассылки.
//
// Параметры:
//  Письмо  - ДокументСсылка, ДокументОбъект - документ электронное письмо для которого необходимо получить вложения.
//
// Возвращаемое значение:
//  Структура,Неопределено  - Неопределено, если присоединенные файлы хранятся при письме.
//                            Структура, если присоединенные файлы хранятся в другом объекте. Формат структуры:
//                              - Владелец - владелец присоединенных файлов,
//                              - ИмяСправочникаПрисоединенныеФайлы - имя объекта метаданных присоединенных файлов.
//
Функция ПолучитьДанныеОбъектаМетаданныхПрисоединенныхФайловПисьма(Письмо) Экспорт
	
	Возврат Неопределено;
	
КонецФункции

#КонецОбласти
