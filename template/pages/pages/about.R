layout <- "default.R"
title <- "home"

about.me <- markdownToHTML(file.path(site, "template/markdown/about_text.md"), fragment.only= TRUE)
about.the.blog <- markdownToHTML(file.path(site, "template/markdown/about_blog.md"), fragment.only= TRUE)

page <- content(
    m("h1", "About me"),
    m("div.row-fluid",
      m("div.span4", 
        image.link(uri="/img/me_crop_bw.jpg", opts= list(HEIGHT = 365, WIDTH = 339))),
        m("div.span7", 
          about.me)),
    m("h1", "About this blog"),
    m("div.row-fluid", 
      about.the.blog))

