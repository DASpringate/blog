layout <- "default.R"
title <- "home"

page <- content(m("h2", "My scribblings:"),
               html.postlist(site))
 