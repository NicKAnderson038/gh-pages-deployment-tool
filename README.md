# Deploy create react app or vue cli application bash script.

<br>

### Requirements

1. Install <a scr="https://stedolan.github.io/jq/" target="_blank">JQ</a> onto your operating system.

<ul>

Mac
```bash
brew install jq
```

Windows
```bash
choco install jq
```

Linux >= 16.04LTS 
```bash
sudo apt-get install jq
```
</ul>

#

(If using Vue/cli)
The public path needs to be changed during the build procss. Add the example below to the `vue.config.js` file.

example:
```js
module.exports = {
  publicPath: process.env.PUBLIC_PATH || '/',
}
```

2. Create shell script file at the root of your application: `gh-pages.sh`

3. Copy/paste code into .sh file. Then run `bash gh-pages.sh` from the application root.
```bash
STR="$(echo `jq '.scripts.build' package.json`)"
SUB='react'
account="$(git config --get remote.origin.url | sed 's:.*//github.com/::' | cut -f1 -d"/")"
publicPath="$(git config --get remote.origin.url | sed 's:.*/::' | cut -f1 -d".")"
url="https://""$account"".github.io/""$publicPath""/"

echo "📦 Building application"
if [[ "$STR" == *"$SUB"* ]]
then
    echo "🏠 set homepage: /$publicPath/"
    echo "`jq '.homepage="'/$publicPath/'"' package.json`" > package.json
    react-scripts build
    echo "`jq 'del(.homepage)' package.json`" > package.json
    echo "🔙 package.json restored"
else
    echo "🛣️ set public path: /$publicPath/"
    export PUBLIC_PATH="/$publicPath/"
    vue-cli-service build
    export PUBLIC_PATH='/'
    echo "🔙 public path restored"
fi
echo "🏁 Build complete"

echo "🚀 Begin deployment"
git push origin --delete gh-pages
if [[ "$STR" == *"$SUB"* ]]
then
    git add -f build && git commit -m "Initial build subtree commit" --no-verify
    git subtree push --prefix build origin gh-pages
else
    git add -f dist && git commit -m "Initial dist subtree commit" --no-verify
    git subtree push --prefix dist origin gh-pages
fi

echo "🛁 Clean up process"
if [[ "$STR" == *"$SUB"* ]]
then
    rm -r -v build
    git rm -r --cached build
else
    rm -r -v dist
    git rm -r --cached dist
fi

git add .
git commit -m "cleaned cache"
git push

printf "\n⛅'\e]8;;$url\e\\Github pages url: $publicPath\e]8;;\e\\\'\n"
echo ""

exit 0
read
```

#

#### Application may take awhile to deploy.