
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Если Объект.Ссылка.Пустая() Тогда
		Если Параметры.Свойство("ДобавитьНовыйЭлемент") Тогда
			Объект.Владелец = Параметры.Конфигурация;
			Объект.Задача = Параметры.Задача;
			Объект.Комментарий = "#"+Формат(Объект.Задача.Код,"ЧГ=0") +" "+ Объект.Задача;
		Конецесли;
		Объект.ВводВручную = Истина;
		Объект.ДатаВерсии = ТекущаяДата();
		Объект.ПользовательХранилища = Пользователи.ТекущийПользователь().узКороткоеИмя;				
	Конецесли;
	Если Объект.ВводВручную Тогда
		РазрешеноРедактировать = Истина;		
	Конецесли;
	УстановитьВидимостьДоступность();
КонецПроцедуры

&НаСервере
Процедура УстановитьВидимостьДоступность()
	Элементы.ГруппаРеквизиты.ТолькоПросмотр = Истина;
	Элементы.ГруппаСтраницы.ТолькоПросмотр = Истина;
	Если РазрешеноРедактировать Тогда
		Элементы.ГруппаРеквизиты.ТолькоПросмотр = Ложь;
		Элементы.ГруппаСтраницы.ТолькоПросмотр = Ложь;		
	Конецесли;
КонецПроцедуры 

&НаКлиенте
Процедура РазрешеноРедактироватьПриИзменении(Элемент)
	УстановитьВидимостьДоступность();
КонецПроцедуры

&НаКлиенте
Процедура ВводВручнуюПриИзменении(Элемент)
	РазрешеноРедактировать = Истина;
	УстановитьВидимостьДоступность();
КонецПроцедуры

&НаКлиенте
Процедура ИзмененныеОбъектыПриНачалеРедактирования(Элемент, НоваяСтрока, Копирование)	
	Если НоваяСтрока Тогда
		ПараметрыВвода = Новый Структура();
		ПараметрыВвода.Вставить("СтрокаИзмененныеОбъекты",Элемент.ТекущиеДанные);
		Подсказка = "Укажите полное имя изменненного объекта метаданных";
		Оповещение = Новый ОписаниеОповещения("ПослеВводаСтроки",ЭтаФорма , ПараметрыВвода);
		ПоказатьВводСтроки(Оповещение, "", Подсказка, 0, Истина); 
	Конецесли;
КонецПроцедуры

&НаКлиенте
Процедура ПослеВводаСтроки(ПолноеИмяМетаданных, ПараметрыВвода) Экспорт
    Если ПолноеИмяМетаданных = Неопределено Тогда
        Возврат;
	КонецЕсли;
	
	СтрокаИзмененныеОбъекты = ПараметрыВвода.СтрокаИзмененныеОбъекты;	
	СтрокаИзмененныеОбъекты.ВидИзменения = ПредопределенноеЗначение("Перечисление.узВидыИзменений.Изменен");
	СтрокаИзмененныеОбъекты.ИдентификаторОбъектаМетаданных = ПолучитьИдентификаторОбъектаМетаданныхНаСервереБезКонтекста(ПолноеИмяМетаданных,Объект.Владелец);
КонецПроцедуры

&НаСервереБезКонтекста
Функция ПолучитьИдентификаторОбъектаМетаданныхНаСервереБезКонтекста(ПолноеИмяМетаданных,Конфигурация)
	ОбрОбъект = Обработки.узЗагрузкаИзмененийИзХранилища.Создать();
	ОбрОбъект.Конфигурация = Конфигурация;
	ОбрОбъект.ЗаполнитьмТЗСвойстваМетаданных();
	ОбрОбъект.СоздатьСтруктурумТЗПоискКэш();
	пИдентификаторОбъектаМетаданных = ОбрОбъект.ПолучитьИдентификаторОбъектаМетаданныхПоСтроке(ПолноеИмяМетаданных);
	Возврат пИдентификаторОбъектаМетаданных;
КонецФункции 

&НаКлиенте
Процедура ИзмененныеОбъектыПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа, Параметр)
	Если НЕ ПроверитьЗаполнение() Тогда
		Отказ = Истина;
		Возврат;
	Конецесли;
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	Оповестить("узИсторияХранилища_ЗаписанЭлемент");
КонецПроцедуры
