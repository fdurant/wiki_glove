# Creation of [GloVe](http://nlp.stanford.edu/projects/glove/) models from [Wikipedia](https://dumps.wikimedia.org) Data

This small repo collects a Makefile and a couple of (partially borrowed a/o adapted) scripts that produce GloVe models from freely available Wikipedia data, in Dutch and in French.

The procedure for Dutch goes as follows:

# Step 1: Download and unzip Wikipedia data

````bash
$ mkdir data
$ cd data
$ wget https://dumps.wikimedia.org/nlwiki/20160501/nlwiki-20160501-pages-articles1.xml.bz2
$ wget https://dumps.wikimedia.org/nlwiki/20160501/nlwiki-20160501-pages-articles2.xml.bz2
$ wget https://dumps.wikimedia.org/nlwiki/20160501/nlwiki-20160501-pages-articles3.xml.bz2
$ wget https://dumps.wikimedia.org/nlwiki/20160501/nlwiki-20160501-pages-articles4.xml.bz2
$ bunzip2 nlwiki-20160501-pages-articles1.xml.bz2
$ bunzip2 nlwiki-20160501-pages-articles2.xml.bz2
$ bunzip2 nlwiki-20160501-pages-articles3.xml.bz2
$ bunzip2 nlwiki-20160501-pages-articles4.xml.bz2
```

