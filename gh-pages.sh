STR="$(echo `jq '.scripts.build' package.json`)"
SUB='react'
publicPath="$(git config --get remote.origin.url | sed 's:.*/::' | cut -f1 -d".")"
export PUBLIC_PATH="/$publicPath/"
echo "📰 Github pages path: /$publicPath/"

echo "📦 Building application"
if [[ "$STR" == *"$SUB"* ]]
then
    echo "REACT REACT REACT REACT"
    echo "`jq '.homepage="'/$publicPath/'"' package.json`" > package.json
    react-scripts build
else
    echo "VUE VUE VUE VUE VUE"
    vue-cli-service build
fi
echo "🏁 Build complete"

export PUBLIC_PATH='/'
echo "🔙 restore path"

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
    echo "Remove dist folder & clean cache"
    rm -r -v dist
    git rm -r --cached dist
fi

git add .
git commit -m "cleaned cache"
git push

exit 0
read