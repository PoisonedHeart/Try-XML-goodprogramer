require "rexml/document" #Подключаем парсер Rexml
require "date" #будем использовать операции с датами
#1)Исходыный файл для анализа будем искать в той е папке где лежит программа
current_path = File.dirname(__FILE__)
file_name = current_path + "/expenses.xml"
abort "Хозяин файл XML не найден." unless File.exist?(file_name)
#Чтобы скормить файл в парсер нуно его открыть
file = File.new (file_name)
#Создаем переменную doc - объект наего парсинга вызовом специального класса
doc = REXML::Document.new(file)
# Будем извлекать информацию в виде
# ассоциативного массива, где ключем будет дата а
# значением сумма трат полученных за этот день
# отсортируем по возрастанию даты
amount_by_day = Hash.new
# Далее в цикле наполним этоот массив
# Пробежимся по нашему XML дереву по массиву expenses и наполним массив amount_by_day
# значениями трат за каждый день
# Для того чтобы пробежаться по всем элементам дерева в парсере REXML есть метод elements
# XPath = формат адресации расположения элементов внутри XML документа
doc.elements.each("expenses/expense") do |item|
# Заведем переменную loss_sum - сколько было потрачено. В этом теге expence, атрибут amount
# И перобразуем все это в числа т.к. это все отдается строками.
loss_sum = item.attributes["amount"].to_i
# Тоже самое по дате но в виде даты. Парсим дату.
loss_day = Date.parse(item.attributes["date"])
# В наш массив amount_by_day записать по ключу loss_day записать сумму трат за этот день.
# Выражение ||= значение -условное присвоение: присвоить выражению значени, если выражение пусто.
amount_by_day[loss_day] ||= 0
# Добавим в это значение текущую сумму траты
amount_by_day[loss_day] += loss_sum
end
file.close
#2) Создадим отдльный массив, который будет хранить сумму затрат за каждый месяц
# ключем в нем будет строка кокретный месяц конкретного года
# Сортируем по месяцам
sum_by_month = Hash.new
# Установим указатель current_month в самый первый месяц нашей самой первой даты
# Берем все ключи, сортируем их и берем самый первый элемент [0] с помощью форматирования времени преобразуем ее
current_month = amount_by_day.keys.sort[0].strftime("%B %Y")

amount_by_day.keys.sort.each do |key|
  sum_by_month[key.strftime("%B %Y")] ||= 0
  sum_by_month[key.strftime("%B %Y")] += amount_by_day[key]
end
# выводим заголовок для первого месяца!
puts "-----[#{current_month}, всего отрачено: #{sum_by_month[current_month]} р.] -----"

amount_by_day.keys.sort.each do |key|
  if key.strftime("%B %Y") != current_month
    current_month = key.strftime("%B %Y")
    puts "----[ #{current_month}, всего отрчено: #{sum_by_month[current_month]} р.]-------"
  end
  puts "\t#{key.day}: #{amount_by_day[key]} р."
end
