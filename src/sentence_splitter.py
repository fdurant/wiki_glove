import nltk.data
from nltk.tokenize import word_tokenize
import sys
import codecs
import langid

lang = sys.argv[1]
guessLang = sys.argv[2]
printNewLine = sys.argv[3]

lang2name = {'nl':'dutch',
             'fr':'french',
             'en':'english'}

sent_tokenizer = nltk.data.load('tokenizers/punkt/%s.pickle'%lang2name[lang])

def tokenize(text):
    for sentence in sent_tokenizer.tokenize(text):
        yield word_tokenize(sentence)

UTF8Reader = codecs.getreader('utf8')
sys.stdin = UTF8Reader(sys.stdin)

UTF8Writer = codecs.getwriter('utf8')
sys.stdout = UTF8Writer(sys.stdout)

for doc in sys.stdin:
    for sentence in tokenize(doc):
        if guessLang != 'yes':
            for token in sentence:
                print >> sys.stdout, "%s" % token,
        else:
            guessedLanguage = langid.classify(" ".join(sentence))[0]
            if (guessedLanguage == lang):
                for token in sentence:
                    print >> sys.stdout, "%s" % token,

    if printNewLine == 'yes':
        print >> sys.stdout, ""
