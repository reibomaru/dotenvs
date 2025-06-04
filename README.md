# dotenvs

macOS 環境の設定ファイルとアプリケーション設定を管理するリポジトリです。

## 📁 構成

```
.
├── cursor/          # Cursor IDE の設定
├── homebrew/        # Homebrew パッケージ管理
├── raycast/         # Raycast ランチャー設定
└── zsh/            # Zsh シェル設定
```

## 🚀 セットアップ

### 1. リポジトリのクローン

```bash
git clone https://github.com/[username]/dotenvs.git
cd dotenvs
```

### 2. Homebrew パッケージのインストール

```bash
brew bundle --file=homebrew/.Brewfile
```

### 3. Zsh 設定の適用

```bash
ln -sf $(pwd)/zsh/.zshrc ~/.zshrc
source ~/.zshrc
```

### 4. Cursor 拡張機能のインストール

```bash
# extensionts ファイルから拡張機能を一括インストール
while IFS= read -r line; do
  cursor --install-extension "$line"
done < cursor/extensionts
```

### 5. Raycast 設定のインポート

1. Raycast を開く
2. Settings → Advanced → Import Settings
3. `raycast/` フォルダ内の `.rayconfig` ファイルを選択

## 🔧 含まれる設定・ツール

### Homebrew パッケージ

- **開発ツール**: Go, Node.js, Python, Java, Clojure
- **データベース**: PostgreSQL, MongoDB
- **CLI ツール**: gh, jq, tig, direnv, anyenv
- **VSCode 拡張機能**: Copilot, GitLens, Prettier, ESLint など

### Cursor 拡張機能

- GitHub Actions, Docker, Terraform サポート
- 言語サポート: Python, JavaScript/TypeScript, Go, Vue
- ユーティリティ: プレビュー、フォーマッター、スペルチェッカー

### Zsh 設定

- カスタムプロンプト設定
- エイリアス定義
- 環境変数設定

### Raycast 設定

- ホットキー設定
- 拡張機能設定
- ワークフロー設定

## 📝 カスタマイズ

設定をカスタマイズしたい場合は、各ディレクトリ内のファイルを編集してください。
変更後は以下のコマンドで設定を再適用できます：

```bash
# Homebrew パッケージの更新
brew bundle --file=homebrew/.Brewfile

# Zsh 設定の再読み込み
source ~/.zshrc
```

## 🔄 設定の更新・同期

設定を更新した場合：

```bash
# 現在の設定をバックアップ
git add .
git commit -m "Update configurations"
git push
```

他のマシンで設定を同期：

```bash
git pull
# 必要に応じて各セットアップ手順を再実行
```
