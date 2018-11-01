import './main.css';
import { Elm } from './elm/Main.elm';
import registerServiceWorker from './registerServiceWorker';
import CodeMirror from 'codemirror';
import CodeMirrorStyle from 'codemirror/lib/codemirror.css';
import CodeMirrorTheme from 'codemirror/theme/material.css';
import CodeMirrorMode from 'codemirror/mode/htmlmixed/htmlmixed';


const node = document.getElementById('root');

const app = Elm.Main.init({ node: node });


document.onreadystatechange = () => {
    if (document.readyState === 'interactive') {
        const $playground = document.getElementById('playground__editor');
        const codeMirror = CodeMirror.fromTextArea(
            $playground,
            {
                mode: 'htmlmixed',
                theme: 'material',
                lineNumbers: true
            }
        );
        codeMirror.on('change', (cm, changes) => {
            const node = document.getElementById('playground__preview');
            node.innerHTML = codeMirror.getValue();
        });


    }
};

registerServiceWorker();
