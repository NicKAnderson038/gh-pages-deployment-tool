STR="$(echo `jq '.scripts.build' package.json`)"
SUB='react'
publicPath="$(git config --get remote.origin.url | sed 's:.*/::' | cut -f1 -d".")"

echo "📦 Building application"
if [[ "$STR" == *"$SUB"* ]]
then
    echo "🏠 set homepage: /$publicPath/"
    echo "`jq '.homepage="'/$publicPath/'"' package.json`" > package.json
    react-scripts build
    # echo "`jq 'del(.homepage)' package.json`" > package.json
    # echo "🔙 package.json restored"
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

test="$(git config --get remote.origin.url)"
url="https://nickanderson038.github.io/gh-pages-deployment-tool/"

printf "\n⛅'\e]8;;$url\e\\Github pages url: $publicPath\e]8;;\e\\\'\n"
echo ""
echo "link      https://nickanderson038.github.io/gh-pages-deployment-tool/"
echo "Origins   $test"
exit 0
read