import './main.css';
import { Elm } from './elm/Main.elm';
import registerServiceWorker from './registerServiceWorker';
import CodeMirror from 'codemirror';
import CodeMirrorStyle from 'codemirror/lib/codemirror.css';
import CodeMirrorTheme from 'codemirror/theme/material.css';
import CodeMirrorMode from 'codemirror/mode/htmlmixed/htmlmixed';


const app = Elm.Main.init({
    node: document.getElementById('root')
});

app.ports.readFile.send(require('./../posts/test.md'));

app.ports.readFileList.send(readFileList);

const readFileList = () => {
    const fs = require('fs');
    const result = s.readdirSync('/assets/photos/')
    console.log(result);
    return result;
}

app.ports.setPreview.subscribe(preview => {
    const node = document.getElementById('playground__preview');
    node.innerHTML = preview;
});



document.onreadystatechange = () => {
    if (document.readyState === 'interactive') {
        const $playground = document.getElementById('playground');
        const codeMirror = CodeMirror.fromTextArea(
            $playground,
            {
                mode: 'htmlmixed',
                theme: 'material',
                lineNumbers: true
            }
        );
        codeMirror.on('change', (cm, changes) => {
            cm.save();
            const event = new Event('input');
            $playground.dispatchEvent(event);
        });


    }
};

registerServiceWorker();
