////////////////////////////////////////////////////////////////////////////////
// Подсистема "Напоминания пользователя".
//
////////////////////////////////////////////////////////////////////////////////

#Область СлужебныеПроцедурыИФункции

// Выполняет запрос по напоминаниям для текущего пользователя на момент времени ТекущаяДатаСеанса() + 30минут.
// Момент времени смещен от текущего для использования функции из модуля с повторным использованием
// возвращаемых значений.
// При обработке результата выполнения функции необходимо учитывать эту особенность.
//
// Параметры:
//	Нет
//
// Возвращаемое значение
//  Массив - таблица значений, сконвертированная в массив из структур, содержащих данные строк таблицы.
Функция ПолучитьНапоминанияТекущегоПользователя() Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	Напоминания.Пользователь КАК Пользователь,
	|	Напоминания.ВремяСобытия КАК ВремяСобытия,
	|	Напоминания.Источник КАК Источник,
	|	Напоминания.СрокНапоминания КАК СрокНапоминания,
	|	Напоминания.Описание КАК Описание,
	|	2 КАК ИндексКартинки
	|ИЗ
	|	РегистрСведений.НапоминанияПользователя КАК Напоминания
	|ГДЕ
	|	Напоминания.СрокНапоминания <= &ТекущаяДата
	|	И Напоминания.Пользователь = &Пользователь
	|
	|УПОРЯДОЧИТЬ ПО
	|	ВремяСобытия";
	
	Запрос.УстановитьПараметр("ТекущаяДата", ТекущаяДатаСеанса() + 30*60);// +30 минут для кэша
	Запрос.УстановитьПараметр("Пользователь", Пользователи.ТекущийПользователь());
	
	Результат = НапоминанияПользователяСлужебный.ПолучитьМассивСтруктурИзТаблицы(Запрос.Выполнить().Выгрузить());
	
	Возврат Результат;
	
КонецФункции

// Создает новое напоминание на указанное время.
Функция ПодключитьНапоминаниеВУказанноеВремя(Текст, Время, Предмет = Неопределено) Экспорт
	
	Возврат НапоминанияПользователяСлужебный.ПодключитьНапоминаниеВУказанноеВремя(
		Текст, Время, Предмет);
	
КонецФункции

// Создает новое напоминание на время, рассчитанное относительно времени в предмете.
Функция ПодключитьНапоминаниеДоВремениПредмета(Текст, Интервал, Предмет, ИмяРеквизита) Экспорт
	
	Возврат НапоминанияПользователяСлужебный.ПодключитьНапоминаниеДоВремениПредмета(
		Текст, Интервал, Предмет, ИмяРеквизита);
	
КонецФункции

#КонецОбласти
