STR="$(echo `jq '.scripts.build' package.json`)"
SUB='react'
publicPath="$(git config --get remote.origin.url | sed 's:.*/::' | cut -f1 -d".")"

echo "📦 Building application"
if [[ "$STR" == *"$SUB"* ]]
then
    echo "🏠 set homepage: `jq '.homepage="'/$publicPath/'"' package.json`" > package.json
    react-scripts build
else
    echo "🛣️ set public path: /$publicPath/"
    export PUBLIC_PATH="/$publicPath/"
    vue-cli-service build
    export PUBLIC_PATH='/'
    echo "🔙 restore path"
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
    # echo "`jq 'del(.homepage)' package.json`" > package.json
    rm -r -v build
    git rm -r --cached build
else
    rm -r -v dist
    git rm -r --cached dist
fi

git add .
git commit -m "cleaned cache"
git push

exit 0
read