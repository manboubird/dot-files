#!/bin/sh
SCHEMACRAWLER_HOME=${SCHEMACRAWLER_HOME:-"$HOME/local/Cellar/schemacrawler/latest/_schemacrawler"}
java -cp $(echo ${SCHEMACRAWLER_HOME}/lib/*.jar | tr ' ' ':') schemacrawler.Main $*
