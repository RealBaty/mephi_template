# Руководство для агента по MEPhI Typst-отчетам

Этот документ описывает, как агенту писать и править отчеты на базе текущего шаблона. Корневой проект является полноценным примером НИР: в нем есть титульный лист, лист задания, реферат, главы, библиография, приложения, изображения и листинги. Для лабораторных обычно нужен не весь пример, а только его структура, оформление и проверки.

> **Канон против примера.** Канон шаблона — это структура файлов, правила оформления (фигуры, подписи, ссылки, библиография) и проверки перед сдачей. Конкретное наполнение корневого проекта (тема про PostgreSQL, тексты глав, листинги на Rust, изображения, пункты задания) — лишь демонстрация; при создании новой работы оно заменяется целиком. Не переноси чужой текст и листинги в новый отчёт.

## Когда править шаблон

- Если пользователь просит отчет в отдельной папке `labN/`, работай в папке лабораторной и не меняй корневой шаблон.
- Если пользователь просит обновить шаблон, документацию или общий каркас, можно править файлы этого репозитория.
- Если есть ближайший `AGENTS.md` внутри папки лабораторной, его правила уточняют эти инструкции.

## Роли файлов текущего шаблона

- `main.typ` -- точка входа: поля страницы, базовый текст и абзацы, титульный лист, лист задания, нумерация страниц, настройки заголовков и списков, подключение `contents.typ`.
- `preamble.typ` -- переменные документа и helper-функции: `work_name`, `student_name`, `student_group`, `supervisor_name`, `document_type`, `thesis_theme`, `underlined`, `text_xpt(...)`, `table_figure(...)`, `file_listing(...)`.
- `contents.typ` -- структура основной части: реферат, оглавления, правила фигур и ссылок, порядок глав, библиография, приложения.
- `title/title.typ` -- титульный лист. Данные импортируются из `preamble.typ`.
- `task/task.typ` и `task/task_table.typ` -- лист задания для полного отчета.
- `chapters/*.typ` -- содержательные разделы. Не складывай главы в `main.typ`.
- `appendices/*.typ` -- приложения, обычно большие листинги или дополнительные материалы.
- `images/` -- логотип, схемы, скриншоты и другие растровые изображения.
- `listings/` -- внешние файлы кода для вставки через `file_listing(...)`.
- `biblio.typ`, `chapters/biblio.bib`, `chapters/gost-r-7-0-5-2008-numeric.csl` -- библиография полного отчета.

## Выбор формата

Сначала определи тип работы. Что входит в каждый формат:

| Раздел / файл | Лабораторная | НИР (ПЗ) |
| --- | :---: | :---: |
| `title/` — титульный лист | да | да |
| `task/` — лист задания | нет | да |
| Реферат (`chapters/abstract.typ`) | нет | да |
| Введение / Заключение | по требованию | да |
| Содержательные главы | да (по пунктам задания) | да |
| Библиография (`biblio.typ`, `.bib`, `.csl`) | обычно нет | да |
| Приложения (`appendices/`) | обычно нет | да |
| `listings/` | по необходимости | по необходимости |

Полный отчет по образцу НИР уместен, когда нужны реферат, лист задания, библиография, заключение и приложения. Обычно копируются:

```text
Makefile
main.typ
preamble.typ
contents.typ
title/
task/
chapters/
appendices/
images/mephi.png
listings/
biblio.typ
```

Если используется библиография, также нужны:

```text
chapters/biblio.bib
chapters/gost-r-7-0-5-2008-numeric.csl
```

Компактная лабораторная обычно начинается с минимального набора:

```text
Makefile
main.typ
preamble.typ
contents.typ
title/title.typ
images/mephi.png
chapters/
```

Добавляй только реально нужные ресурсы:

```text
listings/*               # если в PDF вставляются внешние листинги
```

Для лабораторной чаще всего не нужны `task/`, `appendices/`, `biblio.typ`, `chapters/biblio.bib`, `chapters/gost-r-7-0-5-2008-numeric.csl`, шаблонные главы НИР и старые изображения. Не копируй их "на всякий случай".

## Что обязательно адаптировать

- Название выходного PDF в `Makefile`.
- Значения в `preamble.typ`: вид работы, тема, ФИО, группа, руководитель.
- Титульный лист в `title/title.typ`, если формат лабораторной отличается от НИР.
- Список и порядок `#include` в `contents.typ`.
- Наличие или отсутствие листа задания в `main.typ`.
- Наличие или отсутствие реферата, библиографии и приложений в `contents.typ`.
- Пути к изображениям и листингам.
- Глобальные правила `#set/#show` для фигур, подписей и ссылок.

## Каркас компактной лабораторной

`main.typ` остается коротким оркестратором. Для лабораторной без отдельного листа задания используй такой принцип:

```typst
#set page(
  margin: (
    right: 10mm,
    bottom: 20mm,
    left: 30mm,
    top: 20mm,
  ),
)
#set text(font: "Times New Roman", lang: "ru", hyphenate: true, size: 12pt)
#set par(justify: true, first-line-indent: (amount: 1.25cm, all: true), spacing: 1em, leading: 1em)

#include "title/title.typ"

#pagebreak()
#set page(numbering: "1")
#counter(page).update(2)
#set heading(numbering: "1.1.")
// heading sizes per guide: level 1 -- 14pt bold, level 2 -- 13pt bold, level 3+ -- 12pt bold
#show heading: set text(size: 12pt, weight: "bold")
#show heading.where(level: 2): set text(size: 13pt)
#show heading.where(level: 1): set text(size: 14pt)
#show heading: set align(left)
#show heading.where(level: 1): set align(center)
#set enum(indent: 7mm)
#set list(indent: 7mm, marker: [--])
// formulas: centered (Typst default), sequential number "(N)" on the right — GOST
#set math.equation(numbering: "(1)")

#include "contents.typ"
```

Для полного отчета с листом задания после титульника оставь:

```typst
#include "title/title.typ"
#include "task/task.typ"
```

`preamble.typ` не является местом для глобальной верстки. Храни там данные и helper-функции:

```typst
#let underlined = table.cell(stroke: (bottom: 1pt))[]

#let text_xpt(txt, x) = {
  text(size: x * 1pt)[#txt]
}

#let table_figure(tbl, cap) = {
  figure(
    align(right)[#tbl],
    caption: [#cap],
  )
}

#let file_listing(file, lang, cap) = {
  figure(raw(read(file), lang: lang, block: true), caption: [#cap])
}

#let work_name = "Лабораторная работа N"
#let student_name = "Фамилия И.О."
#let supervisor_name = "Фамилия И.О."
#let student_group = "М00-000"
#let document_type = "Отчет по лабораторной работе"
#let thesis_theme = "Тема работы"
```

Helper-функции и переменные из `preamble.typ`:

| Имя | Назначение |
| --- | --- |
| `table_figure(tbl, cap)` | таблица как `figure` с подписью |
| `file_listing(file, lang, cap)` | внешний файл кода как листинг-`figure`; путь от корня отчёта (`listings/...`) |
| `text_xpt(txt, x)` | задать размер текста `x` pt (таблицы титульника и задания) |
| `underlined` | пустая ячейка таблицы с нижней линией (поле для подписи) |
| `work_name`, `document_type`, `thesis_theme` | вид работы, тип документа, тема |
| `student_name`, `student_group`, `supervisor_name` | ФИО, группа, руководитель |

Минимальный `contents.typ` для лабораторной:

```typst
#outline(title: [Содержание])
#pagebreak()

// setup figure enumeration
#set figure(supplement: none)
#show figure: set place(clearance: 1cm)
#show figure: set block(spacing: 1cm)
#show figure: f => {
  if f.kind == table or f.kind == raw {
    set figure.caption(position: top)
    set align(left)
    // tables/listings: no paragraph indent, single line spacing
    set par(first-line-indent: (amount: 0pt, all: true), leading: 0.65em)
    f
  } else {
    f
  }
}
// captions: 12pt, no first-line indent
#show figure.caption: set text(size: 12pt)
#show figure.caption: set par(first-line-indent: (amount: 0pt, all: true))
#show figure.caption: it => context {
  let custom-prefix = if it.kind == image {
    [Рисунок]
  } else if it.kind == table {
    [Таблица]
  } else if it.kind == raw {
    [Листинг]
  } else { [] }
  [
    #custom-prefix
    #it.counter.display(it.numbering)
    --
    #it.body
  ]
}
#set ref(supplement: it => {
  if it.func() == figure {
    if it.kind == image {
      "рис."
    } else if it.kind == table {
      "табл."
    } else {
      "лист."
    }
  } else if it.func() == heading {
    "разд."
  } else {
    ""
  }
})

#include "chapters/section-1.typ"
#include "chapters/section-2.typ"
```

В каждом файле главы импортируй только нужное:

```typst
#import "../preamble.typ": table_figure, file_listing

= Название раздела
```

## Оглавление, приложения и разделы

В полном шаблоне `contents.typ` делает отдельные оглавления для основной части и приложений:

```typst
#outline(target: selector(heading).before(<fst_appendix>, inclusive: false))
#outline(target: selector(heading).after(<fst_appendix>, inclusive: true), title: [Приложения])
```

Первое приложение должно иметь метку на заголовке:

```typst
= Реализация основных интерфейсов <fst_appendix>
```

Перед приложениями шаблон сбрасывает счетчик заголовков и меняет формат:

```typst
#counter(heading).update(0)
#set heading(numbering: "A.1.", supplement: [Приложение])
#show figure: set block(breakable: true)
#include "appendices/appendix1.typ"
```

Если приложений нет, удали оба outline-блока для приложений, метку `<fst_appendix>`, сброс `counter(heading)`, смену `heading(numbering: "A.1.")` и `#include "appendices/..."`.

Разделы "Реферат", "Введение", "Заключение" добавляй только если этого требует формат работы. Для небольшой лабораторной обычно достаточно содержательных разделов по заданию.

## Реферат и динамические счетчики

`chapters/abstract.typ` в полном шаблоне использует вычисляемые значения:

```typst
#context { counter(page).at(<conclusion>).at(0) }
#context { counter(page).final().first() }
#context { query(cite).dedup().len() }
#context { query(heading.where(level: 1).after(<fst_appendix>, inclusive: true)).len() }
```

Если копируешь реферат, обязательно сохрани:

- метку `<conclusion>` на заголовке заключения;
- метку `<fst_appendix>` на первом приложении, если приложения есть;
- библиографию и реальные цитирования, если считаешь число источников.

Если в документе нет заключения, приложений или библиографии, не копируй этот реферат без переработки: счетчики станут бессмысленными или сломают сборку.

## Рисунки, таблицы и листинги

Все изображения, таблицы и подписанные листинги оформляй через `figure(...)`. Это сохраняет единую нумерацию, подписи и ссылки.

Рисунок:

```typst
#figure(
  image("../images/example.png", width: 70%),
  caption: [Пример архитектуры],
) <fig:architecture>
```

Таблица через helper:

```typst
#import "../preamble.typ": table_figure

#table_figure(
  table(
    columns: 3,
    [Параметр], [Значение], [Описание],
    [a], [1], [пример],
  ),
  "Параметры эксперимента",
) <tbl:params>
```

Короткий листинг прямо в главе:

````typst
#figure(
```cpp
struct Request {
  int id;
  int priority;
};
```,
  caption: [Структура запроса],
) <lst:request>
````

Внешний листинг:

```typst
#import "../preamble.typ": file_listing

#file_listing("listings/registrar.cpp", "cpp", "Реализация регистратора") <lst:registrar>
```

В текущем шаблоне helper `file_listing(...)` определен в корневом `preamble.typ`, поэтому для него используется стиль путей от корня отчета: `listings/file.rs`. Не меняй такие пути на `../listings/...` механически; после изменения структуры проверь сборку.

Правила подписей:

- у таблиц и листингов подпись сверху;
- у рисунков подпись снизу;
- для `raw`-листингов отключается абзацный отступ;
- не вставляй важный код голым fenced-блоком, если у него должна быть подпись;
- для широких таблиц можно локально использовать `#pad(left: -15mm, block(table(...)))`, но после этого обязательно проверить PDF визуально.

## Пути

Относительные пути в обычных вставках считаются от файла, где они написаны:

```typst
// из title/title.typ или task/task.typ
#image("../images/mephi.png")

// из chapters/*.typ
#image("../images/result.png")
```

Для файлов, прочитанных helper-функциями из `preamble.typ`, следуй стилю текущего helper и проверяй итоговую сборку.

## Ссылки и библиография

Ставь метки сразу после объектов и используй понятные префиксы:

```typst
<fig:architecture>
<tbl:params>
<lst:request>
```

Ссылка в тексте:

```typst
Как показано на @fig:architecture, ...
```

В полном шаблоне библиография подключается в `contents.typ`:

```typst
#show link: underline
#bibliography(
  "chapters/biblio.bib",
  title: [Список литературы],
  style: "chapters/gost-r-7-0-5-2008-numeric.csl",
  full: false,
)
```

Источники цитируются по ключам из `.bib`:

```typst
PostgreSQL использует реляционную модель данных @rel.
```

Если список источников не требуется, не копируй библиографический блок, `biblio.typ`, `.bib` и `.csl`. Не добавляй пустой раздел источников.

Каждая глава с цитатами `@key` начинается этими двумя строками:

```typst
#import "../biblio.typ": *   // языковой сервер видит ключи источников при правке файла в одиночку
#show bibliography: none     // сам список литературы выводится один раз — в contents.typ
```

Это штатный приём (канон шаблона), а не временный костыль. `biblio.typ` объявляет `#let bibl = bibliography(...)`; импорт заставляет языковой сервер прочитать `.bib`, поэтому при правке отдельного файла главы цитаты `@key` резолвятся и работает автодополнение ключей — без ложных ошибок «label does not exist». Сам список литературы при этом не печатается (значение `bibl` не вставляется), а `#show bibliography: none` скоупится файлом главы и не влияет на настоящую библиографию в `contents.typ`. Альтернатива без этих строк — закрепить корень проекта (`main.typ`) в Tinymist, тогда одиночные файлы анализируются в контексте всего документа.

## Makefile

Минимальный `Makefile`:

```make
all: report.pdf

report.pdf: main.typ
	typst compile main.typ report.pdf

.PHONY: all clean

clean:
	rm -f report.pdf
```

В текущем корневом шаблоне целевой PDF называется `main.pdf`. Для отдельной лабораторной переименуй его осмысленно, например `lab3-report.pdf` или `report.pdf`.

Предупреждение вида `pyenv: cannot rehash: ... isn't writable`, если оно появляется, не относится к Typst и само по себе не ломает сборку.

## Проверка перед сдачей

Шаблон проверен на **Typst 0.14.2**; он использует современный синтаксис (`first-line-indent: (amount: .., all: true)`, `place(clearance: ..)`, `outline.entry.where(..)`), поэтому нужна версия не ниже 0.13.

После изменений в Typst, изображениях или листингах:

1. Собери PDF через `make` или `typst compile main.typ report.pdf`.
2. Исправь все ошибки и предупреждения Typst, относящиеся к отчету.
3. Проверь страницы с крупными таблицами, листингами и скриншотами.
4. Убедись, что PDF автономен: в тексте нет локальных путей, названий служебных файлов, структуры проекта, `task.md`, `raw/`, `mephi_template-main`, `typst compile` или `make`.

Грубая текстовая проверка:

```sh
strings report.pdf | rg "task\\.md|raw|mephi_template-main|/Users|typst compile|make"
```

Визуальный рендер страниц:

```sh
typst compile main.typ /tmp/report-{n}.png
```

Если нет возможности рендерить все страницы, проверь хотя бы страницы с нестандартными объектами.

## Частые ошибки

- Глобальные `#set/#show` помещены в `preamble.typ`, а потом повторяются при каждом импорте.
- В лабораторный отчет случайно попали НИР-разделы, лист задания, библиография или приложения.
- `contents.typ` содержит outline приложений, но в документе нет заголовка с `<fst_appendix>`.
- `chapters/abstract.typ` скопирован без меток `<conclusion>` и `<fst_appendix>`.
- Из `chapters/*.typ` используются пути вида `images/...` вместо `../images/...`.
- Важный код вставлен обычным fenced-блоком без `figure(...)` и подписи.
- Таблицы и листинги получили подписи снизу.
- Итоговый PDF содержит локальные пути, команды сборки или описание внутренней структуры проекта.
