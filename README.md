# kh-scripts

Набор баш-скриптов для решения *любой проблемы* (исследования механизмов реакций в [Природе](http://rad.chem.msu.ru/~laikov))

## TODO
Добавить описание остальных скриптов

## Скрипты

### rx

```
rx mol.rx mol.out1 mol.out2
```

Склеивает две выдачи IRC в один путь реакции (`mol.out1` и `mol.out2` получены с `back=1` и `back=0`).

### rrx

```
rrx mol.rx mol.rrx
```

Разворачивает полученную склейку задом наперёд.

### debutfin

```
debutfin mol.rx
```

Создаёт файлы `mol.rx.1.in` и `mol.rx.2.in` с первой и последней структурами из склейки и шапкой из `mol.in`.

### en

```
en mol1.in mol2.in <...> molN.in
```

Выводит список файлов по маске `mol1~mol2~<...>~mol3_*.in` и энергии относительно E(mol1)+E(mol2)+...+E(molN) в ккал/моль.

Если имя файла содержит `x` или `y` (переходное состояние), и а) в нём нет вторых производных, энергия печатается розовыми буквами, 
б) нет соответствующего файла `.rx` --- синими.
Если запущен процесс с именем файла в аргументах, энергия печатается на красном фоне.

### ensort

```
ensort mol suf
```

Переименовывает файлы `mol_<номер>.suf.in` по возрастанию энергии.

### sm

```
sm mol.out
```

Вставляет в `mol.in` структуру с максимальной энергией (`mol.out` получена с `task=scan`).

### gs

```
gs mol.out N
```

Создаёт файл `mol.scanN.in` с шапкой из `mol.in` и N-ой точкой скана из `mol.out` (нумерация с 0)

### lm

```
lm mol.out
```

Вставляет в `mol.in` последнюю структуру из `mol.out`, если оптимизация не сошлась.



