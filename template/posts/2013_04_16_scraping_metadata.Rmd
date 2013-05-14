% R Python Bioinformatics

Scraping organism metadata for Treebase repositories from GOLD using Python and R
==================================================================================

I recently wanted to get hold of habitat/phenotype/sequencing metadata for the individual organisms of  an archived [Treebase](http://treebase.org/treebase-web/home.html) project.)

The [GOLD](http://www.genomesonline.org/) database holds  more than 18000 full genomes.  For many of these it provides pretty good metadata ([GOLDcards](http://genomesonline.org/cgi-bin/GOLD/bin/GOLDCards.cgi?goldstamp=Gc00536)) which are indirectly linked  to Treebase via [NCBI](http://www.ncbi.nlm.nih.gov/taxonomy) taxa [IDs](http://www.ncbi.nlm.nih.gov/Taxonomy/Browser/wwwtax.cgi?mode=Info&amp;id=122368).

Unfortunately GOLD does not seem to have any kind of API for systematic downloads, so I hacked together a very [quick-and-dirty scraper](https://gist.github.com/2929217) in Python that reads in taxa from a Treebase repo, follows the links to each species NCBI page and downloads the linked GOLDcard, if it exists.

Here is the code. You will need the external BeautifulSoup and lxml libraries for this to work - both are fantastic. (The Treebase repo here is from Wu et al. 2009**, just change the url string for a different repo...):

Once you have downloaded all of the available files, It would be great to have your metadata in a nice flatfile with one line per taxa, right?  I did this with a little [R script](https://gist.github.com/2929366) using the rather wonderful readHTMLtable() function in the XML (install.packages('XML')) package. 

The output is a semicolon separated file with taxa in the rows and the different categories of metadata in columns. The metadata is often fairly incomplete, and  there are plenty of omissions, but hopefully it will become more useful as more deposits are made to GOLD.


** Wu D., Hugenholtz P., Mavromatis K., Pukall R., Dalin E., Ivanova N.N., Kunin V., Goodwin L., Wu M., Tindall B.J., Hooper S.D., Pati A., Lykidis A., Spring S., Anderson I.J., D’haeseleer P., Zemla A., Singer M., Lapidus A., Nolan M., Copeland A., Chen F., Cheng J., Lucas S., Kerfeld C., Lang E., Gronow S., Chain P., Bruce D., Rubin E.M., Kyrpides N.C., Klenk H., & Eisen J.A. 2009. A phylogeny-driven genomic encyclopaedia of Bacteria and Archaea. Nature, 462(7276): 1056-1060.

