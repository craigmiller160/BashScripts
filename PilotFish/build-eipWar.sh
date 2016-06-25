#!/bin/bash
# Script to build the eip.war. Hopefully with the dashboard

ant -f resources/build/build_new_main.xml eip.war.buildAll -Dinstall4J.jarLoc=/Applications/install4j\ 5/bin/ant.jar
