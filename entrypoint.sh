#!/bin/sh

JACOCO_XML=${JACOCO_XML:-"JACOCO_XML env var missing: file path in a volume!"}
SRC_MAIN_JAVA_DIR=${SRC_MAIN_JAVA_DIR:-"SRC_MAIN_JAVA_DIR env var missing: the source dir!"}
COBERTURA_XML_FILE=${COBERTURA_XML_FILE:-"COBERTURA_XML_FILE env var missing: file path to cobertura xml file!"}

echo "Translating JaCoco '${JACOCO_XML}' to Cobertura '${COBERTURA_XML_FILE}'"
/tool/cover2cover.py ${JACOCO_XML} ${SRC_MAIN_JAVA_DIR} > ${COBERTURA_XML_FILE}

if [ ! -z ${PRINT_REPORT} ]; then
  if [ -f ${COBERTURA_XML_FILE} ]; then
    echo "Generated cobertura xml at '${COBERTURA_XML_FILE}'"
    ls -la ${COBERTURA_XML_FILE}
    cat ${COBERTURA_XML_FILE}

  else
    echo "ERROR: failed to generate file at '${COBERTURA_XML_FILE}'"
  fi
fi
