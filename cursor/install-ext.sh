#!/bin/bash
# extensionts ファイルから拡張機能を一括インストール
while IFS= read -r line; do
  cursor --install-extension "$line"
done < cursor/extensionts