#!/bin/bash
# Clean eip-root of excess files

echo "Deleting testing-trace"
rm -rf ./testing-trace 1>/dev/null 2>/dev/null
echo "Deleting transact-cache"
rm -rf ./transact-cache 1>/dev/null 2>/dev/null
echo "Deleting testing-cache"
rm -rf ./testing-cache 1>/dev/null 2>/dev/null
echo "Deleting statistics"
rm -rf ./statistics 1>/dev/null 2>/dev/null
echo "Deleting debug-trace"
rm -rf ./debug-trace 1>/dev/null 2>/dev/null
echo "Deleting transfer-cache"
rm -rf ./transfer-cache 1>/dev/null 2>/dev/null
echo "Deleting .basex logs"
rm -rf ./.basex/data/logs/*