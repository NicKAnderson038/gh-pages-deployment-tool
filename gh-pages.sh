publicPath="$(git config --get remote.origin.url | sed 's:.*/::' | cut -f1 -d".")"
export PUBLIC_PATH="/$publicPath/"
echo "📰 Github pages path: /$publicPath/"

echo "📦 Building application"
vue-cli-service build
if [ -d dist ] 
then
    vue-cli-service build
else
    react-scripts build
fi
echo "🏁 Build complete"

# export PUBLIC_PATH='/'
# echo "🔙 restore path"

# echo "🚀 Begin deployment"
# git push origin --delete gh-pages
# if [ -d dist ] 
# then
#     echo "Git Add Vue application"
#     git add -f dist && git commit -m "Initial dist subtree commit" --no-verify
# else
#     echo "Git Add React application"
#     git add -f build && git commit -m "Initial dist subtree commit" --no-verify
# fi
# git subtree push --prefix dist origin gh-pages

# echo "🛁 Clean up process"
# if [ -d dist ] 
# then
#     echo "Remove dist folder & clean cache"
#     rm -r -v dist
#     git rm -r --cached dist
# else
#     echo "Remove build folder & clean cache"
#     rm -r -v build
#     git rm -r --cached build
# fi
# git add .
# git commit -m "cleaned cache"
# git push

exit 0
read