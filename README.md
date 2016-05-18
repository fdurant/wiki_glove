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
$ cd ..
```

# Step 2: Parse the data into smaller files, using Giuseppe Attardi's [wikiextractor](https://github.com/attardi/wikiextractor)

````bash
$ make LANG=nl parsewiki
```

The extracted files are to be found in texts/nl/text[1234]/??/wiki*

# Step 3: Split in sentences and tokenize

```bash
$ make LANG=nl out/nl_corpus.txt
```

# Step 4: Build the vocab file

```bash
$ make LANG=nl VOCAB_MIN_COUNT=3 out/nl_vocab.txt
```

# Step 5: Build the GloVe model

```bash
$ make LANG=nl VECTOR_SIZE=50 out/nl_vectors.txt
```

# Step 6: Publish the final model in [Word2Vec](https://en.wikipedia.org/wiki/Word2vec) format

```bash
$ make LANG=NL publish
```

The final model is written in the directory _models_. It is directly usable with [gensim's Word2Vec](https://radimrehurek.com/gensim/models/word2vec.html) module.
