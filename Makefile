NRLINESTOREAD=10000
OUTDIR=out
MODELSDIR=models

CORPUS=${OUTDIR}/corpus.txt
VOCAB_FILE=${OUTDIR}/vocab.txt

COOCCURRENCE_FILE=${OUTDIR}/cooccurrence.bin
COOCCURRENCE_SHUF_FILE=${OUTDIR}/cooccurrence.shuf.bin

VECTORSBASENAME=vectors
SAVE_FILE=${OUTDIR}/${VECTORSBASENAME}
VERBOSE=2
MEMORY=4.0
VOCAB_MIN_COUNT=5
VECTOR_SIZE=100
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

parsewiki:
	python src/WikiExtractor.py nlwiki-20160501-pages-articles.xml -o -

${CORPUS}:
	mkdir -p ${OUTDIR}
	for FILE in `ls -1 texts/*/*/wiki*`; do \
		/bin/echo -n "Processing $${FILE} ..."; \
		cat $${FILE} | perl src/1doc_per_line.pl | python src/sentence_splitter.py | perl src/tokenize.pl >> ${CORPUS}; \
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
	VOCAB_SIZE=`/bin/cat ${VOCAB_FILE} | /usr/bin/wc -l | perl -ne "s/\s+//; print"`; \
	MODEL_IN_WORD2VEC_FORMAT=${MODELSDIR}/${VECTORSBASENAME}_$${VOCAB_SIZE}_tokens_${VECTOR_SIZE}_dims.txt; \
	echo $${VOCAB_SIZE} ${VECTOR_SIZE} >> $${MODEL_IN_WORD2VEC_FORMAT}; \
	cat ${SAVE_FILE}.txt >> $${MODEL_IN_WORD2VEC_FORMAT}; \
	cp ${VOCAB_FILE} ${MODELSDIR}/vocab_$${VOCAB_SIZE}_tokens.txt; \
	chmod -w $$MODEL_IN_WORD2VEC_FORMAT; \
	chmod -w ${MODELSDIR}/vocab_$${VOCAB_SIZE}_tokens.txt