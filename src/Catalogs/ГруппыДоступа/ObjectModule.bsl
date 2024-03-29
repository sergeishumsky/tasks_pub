#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

Перем СтарыйПрофиль;         // Профиль группы доступа до изменения
                             // для использования в обработчике события ПриЗаписи.

Перем СтараяПометкаУдаления; // Пометка удаления группы доступа до изменения
                             // для использования в обработчике события ПриЗаписи.

Перем СтарыеУчастники;       // Участники группы доступа до изменения
                             // для использования в обработчике события ПриЗаписи.

#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если ЭтоГруппа Тогда
		Возврат;
	КонецЕсли;
	
	Если НЕ ДополнительныеСвойства.Свойство("НеОбновлятьРолиПользователей") Тогда
		Если ЗначениеЗаполнено(Ссылка) Тогда
			СтараяТаблицаПользователи = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Ссылка, "Пользователи");
			СтарыеУчастники = СтараяТаблицаПользователи.Выгрузить().ВыгрузитьКолонку("Пользователь");
		Иначе
			СтарыеУчастники = Новый Массив;
		КонецЕсли;
	КонецЕсли;
	
	СтарыеЗначения = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(
		Ссылка, "Профиль, ПометкаУдаления");
	
	СтарыйПрофиль         = СтарыеЗначения.Профиль;
	СтараяПометкаУдаления = СтарыеЗначения.ПометкаУдаления;
	
	Если Ссылка = Справочники.ГруппыДоступа.Администраторы Тогда
		
		// Всегда предопределенный профиль Администратор.
		Профиль = Справочники.ПрофилиГруппДоступа.Администратор;
		
		// Не может быть персональной группой доступа.
		Пользователь = Неопределено;
		
		// Не может иметь обычного ответственного (только полноправные пользователи).
		Ответственный = Неопределено;
		
		// Изменение разрешено только полноправному пользователю.
		Если НЕ ПривилегированныйРежим()
		   И НЕ УправлениеДоступом.ЕстьРоль("ПолныеПрава") Тогда
			
			ВызватьИсключение
				НСтр("ru = 'Предопределенную группу доступа Администраторы
				           |можно изменять, либо в привилегированном режиме,
				           |либо при наличии роли ""Полные права"".'");
		КонецЕсли;
		
		// Проверка наличия только пользователей.
		Для каждого ТекущаяСтрока Из ЭтотОбъект.Пользователи Цикл
			Если ТипЗнч(ТекущаяСтрока.Пользователь) <> Тип("СправочникСсылка.Пользователи") Тогда
				ВызватьИсключение
					НСтр("ru = 'Предопределенная группа доступа Администраторы
					           |может содержать только пользователей.
					           |
					           |Группы пользователей, внешние пользователи и
					           |группы внешних пользователей недопустимы.'");
			КонецЕсли;
		КонецЦикла;
		
	// Нельзя устанавливать предопределенный профиль Администратор произвольной группе доступа.
	ИначеЕсли Профиль = Справочники.ПрофилиГруппДоступа.Администратор Тогда
		ВызватьИсключение
			НСтр("ru = 'Предопределенный профиль Администратор может быть только
			           |у предопределенной группы доступа Администраторы.'");
	КонецЕсли;
	
	Если НЕ ЭтоГруппа Тогда
		
		// Автоматическая установка реквизитов для персональной группы доступа.
		Если ЗначениеЗаполнено(Пользователь) Тогда
			Родитель         = Справочники.ГруппыДоступа.РодительПерсональныхГруппДоступа();
		Иначе
			Пользователь = Неопределено;
			Если Родитель = Справочники.ГруппыДоступа.РодительПерсональныхГруппДоступа(Истина) Тогда
				Родитель = Неопределено;
			КонецЕсли;
		КонецЕсли;
		
		// При снятии пометки удаления с группы доступа выполняется
		// снятие пометки удаления с профиля этой группы доступа.
		Если НЕ ПометкаУдаления И СтараяПометкаУдаления = Истина Тогда
			ПометкаУдаленияПрофиля = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Профиль, "ПометкаУдаления");
			ПометкаУдаленияПрофиля = ?(ПометкаУдаленияПрофиля = Неопределено, Ложь, ПометкаУдаленияПрофиля);
			Если ПометкаУдаленияПрофиля Тогда
				ЗаблокироватьДанныеДляРедактирования(Профиль);
				ПрофильОбъект = Профиль.ПолучитьОбъект();
				ПрофильОбъект.ПометкаУдаления = Ложь;
				ПрофильОбъект.Записать();
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

// Обновляет:
// - роли добавленных, оставшихся и удаленных пользователей;
// - РегистрСведений.ТаблицыГруппДоступа;
// - РегистрСведений.ЗначенияГруппДоступа.
//
Процедура ПриЗаписи(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если ЭтоГруппа Тогда
		Возврат;
	КонецЕсли;
	
	Если НЕ ДополнительныеСвойства.Свойство("НеОбновлятьРолиПользователей") Тогда
		
		Если ОбщегоНазначенияПовтИсп.РазделениеВключено()
			И Ссылка = Справочники.ГруппыДоступа.Администраторы
			И НЕ ОбщегоНазначенияПовтИсп.СеансЗапущенБезРазделителей()
			И ДополнительныеСвойства.Свойство("ПарольПользователяСервиса") Тогда
			
			ПарольПользователяСервиса = ДополнительныеСвойства.ПарольПользователяСервиса;
		Иначе
			ПарольПользователяСервиса = Неопределено;
		КонецЕсли;
		
		ОбновитьРолиПользователейПриИзмененииГруппыДоступа(ПарольПользователяСервиса);
	КонецЕсли;
	
	Если Профиль         <> СтарыйПрофиль
	 ИЛИ ПометкаУдаления <> СтараяПометкаУдаления Тогда
		
		РегистрыСведений.ТаблицыГруппДоступа.ОбновитьДанныеРегистра(Ссылка);
	КонецЕсли;
	
	РегистрыСведений.ЗначенияГруппДоступа.ОбновитьДанныеРегистра(Ссылка);
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	Если ДополнительныеСвойства.Свойство("ПроверенныеРеквизитыОбъекта") Тогда
		ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(
			ПроверяемыеРеквизиты, ДополнительныеСвойства.ПроверенныеРеквизитыОбъекта);
	КонецЕсли;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Вспомогательные процедуры и функции.

Процедура ОбновитьРолиПользователейПриИзмененииГруппыДоступа(ПарольПользователяСервиса)
	
	УстановитьПривилегированныйРежим(Истина);
	
	// Обновление ролей для добавленных, оставшихся и удаленных пользователей.
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ГруппаДоступа",   Ссылка);
	Запрос.УстановитьПараметр("СтарыеУчастники", СтарыеУчастники);
	
	Если Профиль         <> СтарыйПрофиль
	 ИЛИ ПометкаУдаления <> СтараяПометкаУдаления Тогда
		
		// Выбор всех новых и старых участников группы доступа.
		Запрос.Текст =
		"ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	Данные.Пользователь
		|ИЗ
		|	(ВЫБРАТЬ РАЗЛИЧНЫЕ
		|		СоставыГруппПользователей.Пользователь КАК Пользователь
		|	ИЗ
		|		РегистрСведений.СоставыГруппПользователей КАК СоставыГруппПользователей
		|	ГДЕ
		|		СоставыГруппПользователей.ГруппаПользователей В(&СтарыеУчастники)
		|	
		|	ОБЪЕДИНИТЬ ВСЕ
		|	
		|	ВЫБРАТЬ
		|		СоставыГруппПользователей.Пользователь
		|	ИЗ
		|		Справочник.ГруппыДоступа.Пользователи КАК ГруппыДоступаПользователи
		|			ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.СоставыГруппПользователей КАК СоставыГруппПользователей
		|			ПО ГруппыДоступаПользователи.Пользователь = СоставыГруппПользователей.ГруппаПользователей
		|				И (ГруппыДоступаПользователи.Ссылка = &ГруппаДоступа)) КАК Данные";
	Иначе
		// Выбор изменений участников группы доступа.
		Запрос.Текст =
		"ВЫБРАТЬ
		|	Данные.Пользователь
		|ИЗ
		|	(ВЫБРАТЬ РАЗЛИЧНЫЕ
		|		СоставыГруппПользователей.Пользователь КАК Пользователь,
		|		-1 КАК ВидИзмененияСтроки
		|	ИЗ
		|		РегистрСведений.СоставыГруппПользователей КАК СоставыГруппПользователей
		|	ГДЕ
		|		СоставыГруппПользователей.ГруппаПользователей В(&СтарыеУчастники)
		|	
		|	ОБЪЕДИНИТЬ ВСЕ
		|	
		|	ВЫБРАТЬ РАЗЛИЧНЫЕ
		|		СоставыГруппПользователей.Пользователь,
		|		1
		|	ИЗ
		|		Справочник.ГруппыДоступа.Пользователи КАК ГруппыДоступаПользователи
		|			ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.СоставыГруппПользователей КАК СоставыГруппПользователей
		|			ПО ГруппыДоступаПользователи.Пользователь = СоставыГруппПользователей.ГруппаПользователей
		|				И (ГруппыДоступаПользователи.Ссылка = &ГруппаДоступа)) КАК Данные
		|
		|СГРУППИРОВАТЬ ПО
		|	Данные.Пользователь
		|
		|ИМЕЮЩИЕ
		|	СУММА(Данные.ВидИзмененияСтроки) <> 0";
	КонецЕсли;
	ПользователиДляОбновления = Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Пользователь");
	
	Если Ссылка = Справочники.ГруппыДоступа.Администраторы Тогда
		// Добавление пользователей, связанных с пользователямиИБ, имеющих роль ПолныеПрава.
		
		Для каждого ПользовательИБ Из ПользователиИнформационнойБазы.ПолучитьПользователей() Цикл
			Если ПользовательИБ.Роли.Содержит(Метаданные.Роли.ПолныеПрава) Тогда
				
				НайденныйПользователь = Справочники.Пользователи.НайтиПоРеквизиту(
					"ИдентификаторПользователяИБ", ПользовательИБ.УникальныйИдентификатор);
				
				Если НЕ ЗначениеЗаполнено(НайденныйПользователь) Тогда
					НайденныйПользователь = Справочники.ВнешниеПользователи.НайтиПоРеквизиту(
						"ИдентификаторПользователяИБ", ПользовательИБ.УникальныйИдентификатор);
				КонецЕсли;
				
				Если ЗначениеЗаполнено(НайденныйПользователь)
				   И ПользователиДляОбновления.Найти(НайденныйПользователь) = Неопределено Тогда
					
					ПользователиДляОбновления.Добавить(НайденныйПользователь);
				КонецЕсли;
				
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	
	УправлениеДоступом.ОбновитьРолиПользователей(ПользователиДляОбновления, ПарольПользователяСервиса);
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли