import React, { useState, useEffect } from 'react'
import logo from './logo.svg'
import './App.css'
// const readmePath = require('./README.md')

function App() {
  // const [markdown, setMarkdown] = useState({})

  // useEffect(() => {
  //   fetch(readmePath)
  //     .then((response) => {
  //       return response.text()
  //     })
  //     .then((text) => {
  //       setMarkdown(marked(text))
  //     })
  // }, [])

  const bashScript = `
STR="$(echo \`jq '.scripts.build' package.json\`)"
SUB='react'
account="$(git config --get remote.origin.url | sed 's:.*//github.com/::' | cut -f1 -d"/")"
publicPath="$(git config --get remote.origin.url | sed 's:.*/::' | cut -f1 -d".")"
url="https://""$account"".github.io/""$publicPath""/"

echo "📦 Building application"
if [[ "$STR" == *"$SUB"* ]]
then
    echo "🏠 set homepage: /$publicPath/"
    echo "\`jq '.homepage="'/$publicPath/'"' package.json\`" > package.json
    react-scripts build
    echo "\`jq 'del(.homepage)' package.json\`" > package.json
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
  `

  return (
    <div className="App">
      <header className="App-header">
        <img src={logo} className="App-logo" alt="logo" width="100" />
        <p>Bash script information</p>
        <a
          className="App-link"
          href="https://github.com/NicKAnderson038/gh-pages-deployment-tool/tree/master"
          target="_blank"
          rel="noopener noreferrer">
          Source code
        </a>
        <br></br>
        {/* <section>
          <article dangerouslySetInnerHTML={{ __html: bashScript }}></article>
        </section> */}
      </header>
    </div>
  )
}

export default App
