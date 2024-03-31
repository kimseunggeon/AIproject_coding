<%@ page language="java" contentType="text/html; charset=utf-8"%>
<!DOCTYPE html>
<html>
<head>
<link rel="shortcut icon" href="#">
<meta charset="UTF-8">
<title>Insert title here</title>
<style>
	#editor {
		height: 800px !important;
 		font-size: 15px;
	}
	
	#desc {
		height: 800px;
		font-size: 15px;
	}
</style>
</head>
<body>
 	<div style="display:flex;">
 		<div style="flex:0 0 30%;">
 			<div id="desc">
 				<b>문제 설명</b><br>
 				무한히 큰 배열에 다음과 같이 분수들이 적혀있다.<br>
            1/1   1/2   1/3   1/4   1/5   …<br>
            2/1   2/2   2/3   2/4   …   …<br>
            3/1   3/2   3/3   …   …   …<br>
            4/1   4/2   …   …   …   …<br>
            5/1   …   …   …   …   …<br>
            …   …   …   …   …   …<br>
            이와 같이 나열된 분수들을 1/1 → 1/2 → 2/1 → 3/1 → 2/2 → … 과 같은 지그재그 순서로 차례대로 1번, 2번, 3번, 4번, 5번, … 분수라고 하자.
            X가 주어졌을 때, X번째 분수를 구하는 프로그램을 작성하시오.<br>
            <br>
            <b>제한사항</b><br>
            X(1 ≤ X ≤ 10,000,000)가 주어진다.<br>
            <br>
            <b>입력 예제1</b><br>
            x = 1<br>
            <br>
            <b>출력 예제1</b><br>
            1/1<br>
            <br>
            <b>입력 예제2</b><br>
            x = 3<br>
            <br>
            <b>출력 예제2</b><br>
            2/1<br>
			</div>
 			<div style="margin-top:20px;">
				<button onclick="send_compiler();" style="width: 200px; height: 100px; vertical-align:top;">Run</button>
				<div style="margin:5px 0 0 20px;">
					<div>결과: <span id="result"></span></div>
					<div>경과시간: <span id="performance"></span> m/s</div>
				</div>
			</div>
 		</div>
 		<div style="flex:0 0 70%;">
 			<div id="editor"></div>
			<div style="display:flex; margin-top:20px;">
				<div>정확도 :</div>
				<div id="OUTPUT" style="flex:1 1 auto; padding-left:10px; white-space:pre;">실행 결과가 여기에 표시됩니다.</div>
			</div>
 		</div>
	</div>
	
	
	<script src="https://cdnjs.cloudflare.com/ajax/libs/ace/1.2.3/ace.js"></script>
	<script src="//code.jquery.com/jquery-3.3.1.min.js"></script>
	<script>
		var editor = ace.edit("editor");
		$(function() {
			editor.setTheme("ace/theme/pastel_on_dark");
			editor.getSession().setMode("ace/mode/java");
			editor.setOptions({ maxLines: 1000 });
			
			
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
	            data : JSON.stringify({"lang":"python","code":code,"input":['1']}),
	            dataType: "json",
	            contentType: 'application/json; charset=utf-8',
	            success: function(data,status) {
	               console.log("status: ", status);
	               console.log("data: ",data["output"][0]);
	               
	               // 응답 값 출력
	               output=data["output"][0];     
	               output=output.slice(0,-1);
	               document.getElementById("OUTPUT").innerHTML = output; 
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