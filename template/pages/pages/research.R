layout <- "default.R"
title <- "research"

research_text <- markdownToHTML(file.path(site, "template/markdown/research_text.md"), fragment.only= TRUE)


page <- content(m("h1", "My research"),
              research_text)
