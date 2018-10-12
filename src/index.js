import './main.css';
import { Elm } from './elm/Main.elm';
import registerServiceWorker from './registerServiceWorker';
import CodeMirror from 'codemirror';
import CodeMirrorStyle from 'codemirror/lib/codemirror.css';
import CodeMirrorTheme from 'codemirror/theme/material.css';
import CodeMirrorMode from 'codemirror/mode/htmlmixed/htmlmixed';

var app = Elm.Main.init({
    node: document.getElementById('root')
});

app.ports.readMarkDown.send(require('./../posts/test.md'));

document.onreadystatechange = () => {
    if (document.readyState === 'interactive') {
        var playground = CodeMirror.fromTextArea(
            document.getElementById('playground'),
            {
                mode: 'htmlmixed',
                theme: 'material',
                lineNumbers: true
            }
        );
    }
};

registerServiceWorker();
