import React, { useState, useEffect } from 'react'
import marked from 'marked'
import logo from './logo.svg'
import './App.css'
const readmePath = require('./Readme.md')

function App() {
  const [markdown, setMarkdown] = useState({})

  useEffect(() => {
    fetch(readmePath)
      .then((response) => {
        return response.text()
      })
      .then((text) => {
        setMarkdown(marked(text))
      })
  }, [])

  return (
    <div className="App">
      <header className="App-header">
        <img src={logo} className="App-logo" alt="logo" />
        <p>
          Edit <code>src/App.js</code> and save to reload.
        </p>
        <a
          className="App-link"
          href="https://reactjs.org"
          target="_blank"
          rel="noopener noreferrer">
          Learn React
        </a>
        <section>
          <article dangerouslySetInnerHTML={{ __html: markdown }}></article>
        </section>
      </header>
    </div>
  )
}

export default App
