# Условие:

У вас есть большой файл размером несколько гигабайт, содержащий информацию о
транзакциях в текстовом формате. Каждая строка файла представляет одну транзакцию и
имеет следующий формат:
```
	<timestamp>,<transaction_id>,<user_id>,<amount>
```

Пример строки:
```
	2023-09-03T12:45:00Z,txn12345,user987,500.25
```
## Задача: 
Реализуйте программу на Ruby, которая выполняет следующие действия:

1. Читает файл с диска, не загружая его полностью в память.
2. Парсит каждую строку и представляет транзакции в виде объектов.
3. Сортирует транзакции по amount в порядке убывания.
4. Записывает отсортированные транзакции в новый файл, также не загружая все данные
в память одновременно.

### Требования:

• Вы должны использовать методы обработки данных, которые эффективны по
использованию памяти и времени выполнения.

• Предполагается, что объем данных может не помещаться в оперативной памяти,
поэтому использование стримов и ленивой загрузки будет предпочтительным.

• Реализуйте свою версию алгоритма сортировки, а не используйте встроенные методы Ruby для сортировки (например, sort).

• Напишите тесты для вашего кода (Rspec как плюс).

