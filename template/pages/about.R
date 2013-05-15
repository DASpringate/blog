layout <- "default_nocomments.R"
title <- "home"

about.me <- include.markdown(file.path(site, "template/resources/markdown/about_text.md"))
about.the.blog <- include.markdown(file.path(site, "template/resources/markdown/about_blog.md"))

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

