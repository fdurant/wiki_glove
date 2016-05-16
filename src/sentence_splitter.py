import nltk.data
from nltk.tokenize import word_tokenize
import sys
import codecs

sent_tokenizer = nltk.data.load('tokenizers/punkt/dutch.pickle')

def tokenize(text):
    for sentence in sent_tokenizer.tokenize(text):
        yield word_tokenize(sentence)

#sentences = tokenize('Alle vogels zijn nesten begonnen, behalve ik en jij. Waar wachten wij nu op? Dr. Jan is al naar huis. 2.6 maal 5.12 = 13.19.')

UTF8Reader = codecs.getreader('utf8')
sys.stdin = UTF8Reader(sys.stdin)

UTF8Writer = codecs.getwriter('utf8')
sys.stdout = UTF8Writer(sys.stdout)

for doc in sys.stdin:
    for sentence in tokenize(doc):
        for token in sentence:
            print >> sys.stdout, "%s" % token,
