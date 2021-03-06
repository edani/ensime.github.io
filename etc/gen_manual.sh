#!/usr/bin/env bash
WARNING="This file was generated using gen_manual.sh. Do not manually edit!"
MODIFIED_DATE=`date "+%m/%d/%Y"`
SERVER_SOURCE="../../ensime-server"
PROTOCOL_SOURCE="$SERVER_SOURCE/src/main/scala/org/ensime/protocol/SwankProtocol.scala"
CONFIG_SOURCE="$SERVER_SOURCE/src/main/scala/org/ensime/config/ProjectConfig.scala"
PROTOCOL_DATA_DOCS=`python gen_protocol_docs.py data $PROTOCOL_SOURCE`
PROTOCOL_RPC_DOCS=`python gen_protocol_docs.py rpc $PROTOCOL_SOURCE`
PROTOCOL_EVENTS_DOCS=`python gen_protocol_docs.py events $PROTOCOL_SOURCE`
PROTOCOL_VERSION=`python gen_protocol_docs.py version $PROTOCOL_SOURCE`
PROTOCOL_CHANGE_LOG=`python gen_protocol_docs.py changelog $PROTOCOL_SOURCE`
CONFIG_DOCS=`python gen_protocol_docs.py property $CONFIG_SOURCE`

m4 --define=NO_MANUAL_EDIT_WARNING="$WARNING" \
    --define=PROTOCOL_DATA_DOCUMENTATION="$PROTOCOL_DATA_DOCS" \
    --define=PROTOCOL_RPC_DOCUMENTATION="$PROTOCOL_RPC_DOCS" \
    --define=PROTOCOL_EVENTS_DOCUMENTATION="$PROTOCOL_EVENTS_DOCS" \
    --define=PROTOCOL_CHANGE_LOG="$PROTOCOL_CHANGE_LOG" \
    --define=CONFIG_DOCUMENTATION="$CONFIG_DOCS" \
    --define=PROTOCOL_VERSION="$PROTOCOL_VERSION" \
    --define=MODIFIED_DATE="$MODIFIED_DATE" \
    manual.ltx.m4 > manual.ltx

echo "Wrote updated manual.ltx"

echo "Converting manual to html.."
HTML_TARGET="../index.html"
pdflatex manual.ltx

cat manual_head.html > $HTML_TARGET
tth -r -u -e2 -Lmanual < manual.ltx >> $HTML_TARGET
cat manual_tail.html >> $HTML_TARGET

mv manual.pdf ..
