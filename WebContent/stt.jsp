<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
   <head>
     
      <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
        <title>STT 적용 예제</title>
      <style>
         *
         {
            -webkit-box-sizing: border-box;
            -moz-box-sizing: border-box;
            box-sizing: border-box;
         }
         body
         {
            max-width: 500px;
            margin: 2em auto;
            padding: 0 0.5em;
            font-size: 20px;
         }
         h1
         {
            text-align: center;
         }
         .buttons-wrapper
         {
            text-align: center;
         }
         .api-support
         {
            display: block;
         }
         .hidden
         {
            display: none;
         }
         
         #transcription,
         #log
         {
            display: block;
            width: 100%;
            height: 5em;
            overflow-y: scroll;
            border: 1px solid #333333;
            line-height: 1.3em;
         }
         .button-demo
         {
            padding: 0.5em;
            display: inline-block;
            margin: 1em auto;
         }
         .author
         {
            display: block;
            margin-top: 1em;
         }
      </style>
   </head>
   <body>
      

      <h1>STT 적용 예제</h1>

      <span id="ws-unsupported" class="api-support hidden">API not supported</span>

      <h2>번역 결과</h2>
      <textarea id="transcription" readonly="readonly"></textarea>

      <span>Results:</span>
      <label><input type="radio" name="recognition-type" value="final" checked="checked" /> 결과만 출력 </label>
      <label><input type="radio" name="recognition-type" value="interim" /> 과정 및 결과 출력</label>

      <h3>로그</h3>
      <div id="log"></div>

      <div class="buttons-wrapper">
         <button id="button-play-ws" class="button-demo">예제실행</button>
         <button id="button-stop-ws" class="button-demo">예제중지</button>
         <button id="clear-all" class="button-demo">클리어</button>
      </div>

    
      <script>
         // Test browser support
         window.SpeechRecognition = window.SpeechRecognition        ||
                                    window.webkitSpeechRecognition  ||
                                    null;
         if (window.SpeechRecognition === null) {
            document.getElementById('ws-unsupported').classList.remove('hidden');
            document.getElementById('button-play-ws').setAttribute('disabled', 'disabled');
            document.getElementById('button-stop-ws').setAttribute('disabled', 'disabled');
         } else {
            var recognizer = new window.SpeechRecognition();
            var transcription = document.getElementById('transcription');
            var log = document.getElementById('log');
            // Recogniser doesn't stop listening even if the user pauses
            recognizer.continuous = true;
            // Start recognising
            recognizer.onresult = function(event) {
               transcription.textContent = '';
               for (var i = event.resultIndex; i < event.results.length; i++) {
                  if (event.results[i].isFinal) {
                     transcription.textContent = event.results[i][0].transcript + ' (Confidence: ' + event.results[i][0].confidence + ')';
                  } else {
                     transcription.textContent += event.results[i][0].transcript;
                  }
               }
            };
            // Listen for errors
            recognizer.onerror = function(event) {
               log.innerHTML = 'Recognition error: ' + event.message + '<br />' + log.innerHTML;
            };
            document.getElementById('button-play-ws').addEventListener('click', function() {
               // Set if we need interim results
               recognizer.interimResults = document.querySelector('input[name="recognition-type"][value="interim"]').checked;
               try{
                  recognizer.start();
                  log.innerHTML = 'Recognition started' + '<br />' + log.innerHTML;
               } catch(ex) {
                  log.innerHTML = 'Recognition error: ' + ex.message + '<br />' + log.innerHTML;
               }
            });
            document.getElementById('button-stop-ws').addEventListener('click', function() {
               recognizer.stop();
               log.innerHTML = 'Recognition stopped' + '<br />' + log.innerHTML;
            });
            document.getElementById('clear-all').addEventListener('click', function() {
               transcription.textContent = '';
               log.textContent = '';
            });
         }
      </script>
   </body>
</html>