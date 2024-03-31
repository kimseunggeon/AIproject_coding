<%@ page language="java" contentType="text/html; charset=utf-8"%>

<!DOCTYPE html>
<html>
<head>
<link rel="shortcut icon" href="#">
<meta charset="UTF-8">
<title>Iris Classification</title>
<style>
   #editor {
      margin-left:60px;
      margin-right:60px;
      min-height:300px;
       font-size: 15px;
   }
   
   #desc {
      height: 800px;
      font-size: 15px;
   }
</style>
</head>
<body bgcolor="#202022">
    <div style="margin-left:60px; margin-right:60px; margin-top:60px; margin-bottom: 80px">
       <div style="height:400px;">
          <div id="desc">
             <b style="color:white">붓꽃</b>
             <img src="resources/img/iris_info.png" alt="붓꽃" style="height:300px;display:block;margin:auto auto"/>
             <p style="color:white">대충 붓꽃 설명</p>
          </div>
       </div>
       <div id="editor"></div>
       <div style="display:flex; justify-content:center; margin:20px;">
          <button onclick="send_compiler();" style="width: 200px;height: 50px;background-color:#353537;color:white;border:none;cursor:pointer;margin:auto 5px">
             <b style="font-size:15px">실행</b>
          </button>
          <button onclick="download();" style="width: 200px;height: 50px;background-color:#353537;color:white;border:none;cursor:pointer;margin:auto 5px">
             <b style="font-size:15px">모델 다운로드</b>
          </button>
          <a class="btn" href="resources/img/iris_info.png" download>img download</a>
       </div>
       <div id="OUTPUT" style="flex:1 1 auto; padding-left:10px;">
          <p style="color:white">결과</p>
       </div>
       
   </div>
   <script src="https://cdnjs.cloudflare.com/ajax/libs/ace/1.2.3/ace.js"></script>
   <script src="//code.jquery.com/jquery-3.3.1.min.js"></script>
   <script>
      var editor = ace.edit("editor");
      $(function() {
         editor.setTheme("ace/theme/pastel_on_dark");
         editor.getSession().setMode("ace/mode/python");
         editor.setOptions({ maxLines: 1000 });
         editor.setValue("from sklearn.datasets import load_iris\nfrom sklearn.neighbors import KNeighborsClassifier\nfrom sklearn.model_selection import train_test_split\nimport numpy as np\n\niris_dataset = load_iris()\nknn = KNeighborsClassifier(n_neighbors=1)\nX_train, X_test, y_train, y_test = train_test_split(iris_dataset['data'], iris_dataset['target'], random_state=0)\n\nknn.fit(X_train, y_train)\ny_pred = knn.predict(X_test)\nprint(\"정확도 :\",np.mean(y_pred == y_test))");         
      })
      
      function getEditorValue() {   
          // Ace 에디터의 현재 내용을 반환
         return editor.getValue();
      }
      var code = "";
      var output = "";
      function send_compiler() {
         code = getEditorValue();
         console.log(code);
          $.ajax({
            type: "POST",
            url: "http://localhost:8080/controller/postman",
            data : JSON.stringify({"lang":"python","code":code}),
            dataType: "json",
            contentType: 'application/json; charset=utf-8',
            success: function(data,status) {
               console.log("status: ", status);
               console.log("data: ",data["output"][0]);
               
            // 응답 값 출력
            console.log("data:",data);
            output=""
            for(i=0;i<data["output"].length;i++){
               output=output+data["output"][i]+"\n";
            }
            document.getElementById("OUTPUT").innerHTML = output;   
            document.getElementById("OUTPUT").style.color = "white";
         },
         error: function(xhr, status,err) {
            console.log("status: ", xhr.status);
            console.log("statusText: ", xhr.statusText);
            console.log("responseText: ", xhr.responseText);
            console.log("err", err);
         } 
      })
      }
      function download() {
           $.ajax({
             type: "POST",
             url: "http://localhost:8080/controller/download_model",
             data : JSON.stringify({"name":"model","file":".h5"}),
             dataType: "json",
             contentType: 'application/json; charset=utf-8',
             success: function(data,status) {
                console.log("status: ", status);
                //console.log("data: ",data.getClass().getName());
                
             // 응답 값 출력
             console.log("data:",typeof(data));
         },
         error: function(xhr, status,err) {	
        	 console.log("status: ", xhr.status);
             console.log("statusText: ", xhr.statusText);
             console.log("responseText: ", xhr.responseText);
             console.log("err", err);
         } 
      })
      }
   </script>
</body>
</html>