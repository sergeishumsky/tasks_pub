////////////////////////////////////////////////////////////////////////////////
// Подсистема "Управление доступом".
// 
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Заполняет виды доступа, используемые в ограничениях прав доступа.
// Виды доступа Пользователи и ВнешниеПользователи уже заполнены.
// Их можно удалить, если они не требуются для ограничения прав доступа.
//
// Параметры:
//  ВидыДоступа - ТаблицаЗначений - с колонками:
//   * Имя                    - Строка - имя используемое в описании поставляемых
//                                       профилей групп доступа и текстах ОДД.
//   * Представление          - Строка - представляет вид доступа в профилях и группах доступа.
//   * ТипЗначений            - Тип    - тип ссылки значений доступа.
//                                       Например, Тип("СправочникСсылка.Номенклатура").
//   * ТипГруппЗначений       - Тип    - тип ссылки групп значений доступа.
//                                       Например, Тип("СправочникСсылка.ГруппыДоступаНоменклатуры").
//   * НесколькоГруппЗначений - Булево - Истина указывает, что для значения доступа (Номенклатуры), можно
//                                       выбрать несколько групп значений (Групп доступа номенклатуры).
//
Процедура ПриЗаполненииВидовДоступа(ВидыДоступа) Экспорт
	
	
	
КонецПроцедуры

// Заполняет описания поставляемых профилей групп доступа и
// переопределяет параметры обновления профилей и групп доступа.
//
// Для автоматической подготовки содержимого процедуры следует воспользоваться инструментами
// разработчика для подсистемы Управление доступом.
//
// Параметры:
//  ОписанияПрофилей    - Массив - массив структур, в который нужно добавить описания.
//                        Пустая структура должна быть получена при помощи функции.
//                        УправлениеДоступом.НовоеОписаниеПрофиляГруппДоступа.
//
//  ПараметрыОбновления - Структура - структура со свойствами:
//   * ОбновлятьИзмененныеПрофили - Булево - начальное значение Истина.
//   * ЗапретитьИзменениеПрофилей - Булево - начальное значение Истина.
//       Если установить Ложь, тогда поставляемые профили можно не только просматривать, но и редактировать.
//   * ОбновлятьГруппыДоступа     - Булево - начальное значение Истина.
//   * ОбновлятьГруппыДоступаСУстаревшимиНастройками - Булево - начальное значение Ложь.
//       Если установить Истина, то настройки значений, выполненные администратором для
//       вида доступа который был удален из профиля, будут также удалены из групп доступа.
//
Процедура ПриЗаполненииПоставляемыхПрофилейГруппДоступа(ОписанияПрофилей, ПараметрыОбновления) Экспорт
	
	
	
КонецПроцедуры

// Заполняет зависимости прав доступа "подчиненного" объекта, например, задачи ЗадачаИсполнителя,
// от "ведущего" объекта, например,  бизнес-процесса Задание, которые отличаются от стандартных.
//
// Зависимости прав используются в стандартном шаблоне ограничения доступа для вида доступа "Объект":
// 1) стандартно при чтении "подчиненного" объекта
//    проверяется наличие права чтения "ведущего" объекта
//    и проверяется отсутствие ограничения чтения "ведущего" объекта;
// 2) стандартно при добавлении, изменении, удалении "подчиненного" объекта
//    проверяется наличие права изменения "ведущего" объекта
//    и проверяется отсутствие ограничения изменения "ведущего" объекта.
//
// Допускается только одно переназначение по сравнению со стандартным:
// в пункте "2)" вместо проверки права изменения "ведущего" объекта установить
// проверку права чтения "ведущего" объекта.
//
// Параметры:
//  ЗависимостиПрав - ТаблицаЗначений - с колонками:
//   * ВедущаяТаблица     - Строка - например, Метаданные.БизнесПроцессы.Задание.ПолноеИмя().
//   * ПодчиненнаяТаблица - Строка - например, Метаданные.Задачи.ЗадачаИсполнителя.ПолноеИмя().
//
Процедура ПриЗаполненииЗависимостейПравДоступа(ЗависимостиПрав) Экспорт
	
	
	
КонецПроцедуры

// Заполняет описания возможных прав, назначаемых для объектов, указанных типов.
// 
// Параметры:
//  ВозможныеПрава - ТаблицаЗначений - с колонками, описание которых см. в комментарии
//                   к функции РегистрыСведений.НастройкиПравОбъектов.ВозможныеПрава().
//
Процедура ПриЗаполненииВозможныхПравДляНастройкиПравОбъектов(ВозможныеПрава) Экспорт
	
КонецПроцедуры

// Определяет вид используемого интерфейса пользователя для настройки доступа.
//
// Параметры:
//  УпрощенныйИнтерфейс - Булево - начальное значение Ложь.
//
Процедура ПриОпределенииИнтерфейсаНастройкиДоступа(УпрощенныйИнтерфейс) Экспорт
	
КонецПроцедуры

// Заполняет использование видов доступа в зависимости от функциональных опций конфигурации,
// например, ИспользоватьГруппыДоступаНоменклатуры.
//
// Параметры:
//  ВидДоступа    - Строка - имя вида доступа заданное в процедуре ПриЗаполненииВидовДоступа.
//  Использование - Булево - начальное значение Истина.
// 
Процедура ПриЗаполненииИспользованияВидаДоступа(ВидДоступа, Использование) Экспорт
	
	
	
КонецПроцедуры

// Заполняет состав видов доступа, используемых при ограничении прав объектов метаданных.
// Если состав видов доступа не заполнен, отчет "Права доступа" покажет некорректные сведения.
//
// Обязательно требуется заполнить только виды доступа, используемые в шаблонах ограничения доступа
// явно, а виды доступа, используемые в наборах значений доступа могут быть получены из текущего
// состояния регистра сведений НаборыЗначенийДоступа.
//
//  Для автоматической подготовки содержимого процедуры следует воспользоваться инструментами
// разработчика для подсистемы Управление доступом.
//
// Параметры:
//  Описание     - Строка - многострочная строка формата <Таблица>.<Право>.<ВидДоступа>[.Таблица объекта].
//                 Например, Документ.ПриходнаяНакладная.Чтение.Организации
//                           Документ.ПриходнаяНакладная.Чтение.Контрагенты
//                           Документ.ПриходнаяНакладная.Изменение.Организации
//                           Документ.ПриходнаяНакладная.Изменение.Контрагенты
//                           Документ.ЭлектронныеПисьма.Чтение.Объект.Документ.ЭлектронныеПисьма
//                           Документ.ЭлектронныеПисьма.Изменение.Объект.Документ.ЭлектронныеПисьма
//                           Документ.Файлы.Чтение.Объект.Справочник.ПапкиФайлов
//                           Документ.Файлы.Чтение.Объект.Документ.ЭлектронноеПисьмо
//                           Документ.Файлы.Изменение.Объект.Справочник.ПапкиФайлов
//                           Документ.Файлы.Изменение.Объект.Документ.ЭлектронноеПисьмо
//                 Вид доступа Объект предопределен, как литерал. Этот вид доступа используется в
//                 шаблонах ограничений доступа, как "ссылка" на другой объект, по которому
//                 ограничивается текущий объект таблицы.
//                 Когда вид доступа "Объект" задан, также требуется задать типы таблиц,
//                 которые используются для этого вида доступа. Т.е. перечислить типы,
//                 которые соответствуют полю, использованному в шаблоне ограничения доступа
//                 в паре с видом доступа "Объект". При перечислении типов по виду доступа "Объект"
//                 нужно перечислить только те типы поля, которые есть у поля.
//                 РегистрыСведений.НаборыЗначенийДоступа.Объект, остальные типы лишние.
// 
Процедура ПриЗаполненииВидовОграниченийПравОбъектовМетаданных(Описание) Экспорт
	
	
	
КонецПроцедуры

// Позволяет реализовать перезапись зависимых наборов значений доступа других объектов.
//
//  Вызывается из процедур:
// УправлениеДоступомСлужебный.ЗаписатьНаборыЗначенийДоступа(),
// УправлениеДоступомСлужебный.ЗаписатьЗависимыеНаборыЗначенийДоступа().
//
// Параметры:
//  Ссылка       - СправочникСсылка, ДокументСсылка, ... - ссылка на объект для которого
//                 записаны наборы значений доступа.
//
//  СсылкиНаЗависимыеОбъекты - Массив - массив элементов типа СправочникСсылка, ДокументСсылка, ...
//                 Содержит ссылки на объекты с зависимыми наборами значений доступа.
//                 Начальное значение - пустой массив.
//
Процедура ПриИзмененииНаборовЗначенийДоступа(Ссылка, СсылкиНаЗависимыеОбъекты) Экспорт
	
	
	
КонецПроцедуры

#КонецОбласти
