layout <- "default_nocomments.R"
title <- "research"

research_text <- include.markdown(file.path(site, "template/resources/markdown/research_text.md"))


page <- content(m("h1", "My research"),
              research_text)
