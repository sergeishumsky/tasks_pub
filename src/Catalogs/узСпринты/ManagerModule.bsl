Функция ПолучитьСпринтКоторыйНеЗавершен() Экспорт 
	                                   	
	Только1АктивныйСпринт = Ложь;
	пСпринт = Неопределено;
	ТекстОшибки = Неопределено;
	
	РезультатФункции = Новый Структура();
	РезультатФункции.Вставить("Только1АктивныйСпринт",Только1АктивныйСпринт);
	РезультатФункции.Вставить("Спринт",пСпринт);
	РезультатФункции.Вставить("ТекстОшибки",ТекстОшибки);
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	узСпринты.Ссылка,
	|	узСпринты.ДатаНачала,
	|	узСпринты.ДатаОкончания,
	|	узСпринты.СпринтЗавершен
	|ИЗ
	|	Справочник.узСпринты КАК узСпринты
	|ГДЕ
	|	НЕ узСпринты.СпринтЗавершен";
	
	РезультатЗапроса = Запрос.Выполнить();
	Если РезультатЗапроса.Пустой() Тогда
		ТекстОшибки = "Ошибка! не удалось найти активные спринты";
	Иначе
		Выборка = РезультатЗапроса.Выбрать();
		Если Выборка.Количество() > 1 Тогда
			Только1АктивныйСпринт = Ложь;
		Иначе
			Только1АктивныйСпринт = Истина;
			Выборка.Следующий();
			пСпринт = Выборка.Ссылка;
		Конецесли;
	Конецесли;	
	
	РезультатФункции.Вставить("Только1АктивныйСпринт",Только1АктивныйСпринт);
	РезультатФункции.Вставить("Спринт",пСпринт);
	РезультатФункции.Вставить("ТекстОшибки",ТекстОшибки);	
	Возврат РезультатФункции;

КонецФункции 

Функция ПолучитьТекущийСпринтДляЗадачи(НаДату,ЗадачаСсылка) Экспорт
	Перем пТекущийСпринт;	
	
	Если НЕ ЗначениеЗаполнено(ЗадачаСсылка) Тогда
		Возврат пТекущийСпринт;
	Конецесли;
	
	МассивЗадач = Новый Массив();
	МассивЗадач.Добавить(ЗадачаСсылка);
	
	ТЗТекущиеСпринтыДляЗадач = ПолучитьТЗТекущиеСпринтыДляЗадач(НаДату,МассивЗадач);	
	Если ТЗТекущиеСпринтыДляЗадач.Количество() = 1 Тогда
		СтрокаТЗТекущиеСпринтыДляЗадач = ТЗТекущиеСпринтыДляЗадач[0];
		пТекущийСпринт = СтрокаТЗТекущиеСпринтыДляЗадач.Спринт;
	ИначеЕсли ТЗТекущиеСпринтыДляЗадач.Количество() > 1 Тогда
		ВызватьИсключение "Ошибка! Нашли более 1 спринта для задачи ["+ЗадачаСсылка+"]";
	Конецесли;
	
	Возврат пТекущийСпринт;
КонецФункции 

Функция ПолучитьТЗТекущиеСпринтыДляЗадач(НаДату,МассивЗадач) Экспорт 
	Перем ТЗТекущиеСпринтыДляЗадач;
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	|	узСпринтыЗадачСрезПоследних.Задача,
	|	узСпринтыЗадачСрезПоследних.Спринт
	|ИЗ
	|	РегистрСведений.узСпринтыЗадач.СрезПоследних(&НаДату, Задача В(&МассивЗадач)) КАК узСпринтыЗадачСрезПоследних
	|";
	
	Запрос.УстановитьПараметр("МассивЗадач",МассивЗадач);
	Запрос.УстановитьПараметр("НаДату",НаДату);
	
	ТЗТекущиеСпринтыДляЗадач = Запрос.Выполнить().Выгрузить();
	
	Возврат ТЗТекущиеСпринтыДляЗадач;
	
КонецФункции 