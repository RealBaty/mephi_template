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


// title
#include "title/title.typ"
// task
#include "task/task.typ"

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
#include "contents.typ"

