# Adapted from https://github.com/stanfordnlp/GloVe/blob/master/demo.sh

NRLINESTOREAD=10000
DATADIR=data
OUTDIR=out
MODELSDIR=models
TEXTSDIR=texts

LANG=fr
CORPUS=${OUTDIR}/${LANG}_corpus.txt
VOCAB_FILE=${OUTDIR}/${LANG}_vocab.txt

COOCCURRENCE_FILE=${OUTDIR}/${LANG}_cooccurrence.bin
COOCCURRENCE_SHUF_FILE=${OUTDIR}/${LANG}_cooccurrence.shuf.bin

VECTORSBASENAME=vectors
SAVE_FILE=${OUTDIR}/${LANG}_${VECTORSBASENAME}
VERBOSE=2
MEMORY=4.0
VOCAB_MIN_COUNT=3
VECTOR_SIZE=50
MAX_ITER=15
WINDOW_SIZE=15
BINARY=2
NUM_THREADS=8
X_MAX=10

default: what

what:
	cat Makefile | grep ":" | perl -ne "s/^\s.*//; print"

clean:
	rm -rf ${OUTDIR}

# Wiki files downloaded from https://dumps.wikimedia.org/nlwiki/20160501/
# and unzipped into ${DATADIR} 

parsewiki:
	mkdir -p ${TEXTSDIR}/${LANG}
	NRXMLFILES=`ls -1 ${DATADIR}/${LANG}*.xml | wc -l | perl -ne 's/\s*(\d+)\s*/\1/; print'`; \
	echo "found $$NRXMLFILES XML files"; \
	for ((COUNTER=1; COUNTER <= $$NRXMLFILES; COUNTER++)); do \
		echo "Processing loop $${COUNTER}"; \
		mkdir -p ${TEXTSDIR}/${LANG}/text$${COUNTER}; \
		python src/WikiExtractor.py ${DATADIR}/${LANG}wiki*$${COUNTER}.xml -o ${TEXTSDIR}/${LANG}/text$${COUNTER}; \
	done

${CORPUS}:
	mkdir -p ${OUTDIR}
	for FILE in `ls -1 ${TEXTSDIR}/${LANG}/*/*/wiki*`; do \
		/bin/echo -n "Processing $${FILE} ..."; \
		cat $${FILE} | perl src/1doc_per_line.pl | python src/sentence_splitter.py ${LANG} | perl src/tokenize.pl >> ${CORPUS}; \
		/bin/echo "done"; \
	done

${VOCAB_FILE}: ${CORPUS}
	vocab_count -min-count ${VOCAB_MIN_COUNT} -verbose ${VERBOSE} < ${CORPUS} > ${VOCAB_FILE}

${COOCCURRENCE_FILE}: ${VOCAB_FILE}
	cooccur -memory ${MEMORY} -vocab-file ${VOCAB_FILE} -verbose ${VERBOSE} -window-size ${WINDOW_SIZE} < ${CORPUS} > ${COOCCURRENCE_FILE}

${COOCCURRENCE_SHUF_FILE}: ${COOCCURRENCE_FILE}
	shuffle -memory ${MEMORY} -verbose ${VERBOSE} < ${COOCCURRENCE_FILE} > ${COOCCURRENCE_SHUF_FILE}

${SAVE_FILE}.txt: ${COOCCURRENCE_SHUF_FILE}
	glove -save-file ${SAVE_FILE} -threads ${NUM_THREADS} -input-file ${COOCCURRENCE_SHUF_FILE} -x-max ${X_MAX} -iter ${MAX_ITER} -vector-size ${VECTOR_SIZE} -binary ${BINARY} -vocab-file ${VOCAB_FILE} -verbose ${VERBOSE}

publish: ${SAVE_FILE}.txt
	mkdir -p ${MODELSDIR}
	VOCAB_SIZE=`/bin/cat ${VOCAB_FILE} | /usr/bin/wc -l | perl -ne "s/\s+//; print int($$_) + 1"`; \
	MODEL_IN_WORD2VEC_FORMAT=${MODELSDIR}/${VECTORSBASENAME}_${LANG}_$${VOCAB_SIZE}_tokens_${VECTOR_SIZE}_dims.txt; \
	echo $${VOCAB_SIZE} ${VECTOR_SIZE} >> $${MODEL_IN_WORD2VEC_FORMAT}; \
	cat ${SAVE_FILE}.txt >> $${MODEL_IN_WORD2VEC_FORMAT}; \
	cp ${VOCAB_FILE} ${MODELSDIR}/vocab_${LANG}_$${VOCAB_SIZE}_tokens.txt; \
	chmod -w $$MODEL_IN_WORD2VEC_FORMAT; \
	chmod -w ${MODELSDIR}/vocab_${LANG}_$${VOCAB_SIZE}_tokens.txt
