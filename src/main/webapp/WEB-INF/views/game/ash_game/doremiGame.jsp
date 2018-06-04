<%@ page contentType="text/html; charset=UTF-8" %> 
<%@ include file="/ssi/ssi.jsp" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<script type="text/javascript" src="http://code.jquery.com/jquery-1.4.3.min.js" ></script>
<script src="http://www.youtube.com/player_api"></script>
<style type="text/css">
BODY {
	margin: 0 auto;
	text-align:center;
}
DIV {
	text-align:center;
	margin-top : 10px;
}
div.notice {
	position : absolute;
	top : 10;
	float:right;
	border: 1px solid black;
	text-align: left;
	padding : 10px;
	max-width: 380px;

}

</style>
</head>

<body>
<div class="notice" >
[게임 규칙]<br><br>
1. 영상을 재생하여 노래가사를 듣습니다 <br>
2. 정답란에 가사 입력하고 '정답 제출' 버튼을 누릅니다. <br>
3. 틀릴 경우 3가지 힌트 중 하나를 고를 수 있습니다. <br>
4. 노래 감상은 최대 5회 감상할 수 있습니다. <br>  
5. 정답은 10번까지 시도할 수 있습니다. 10번 틀릴 시 정답이 공개됩니다.  <br>  
</div>

<!-- 1. The <iframe> (and video player) will replace this <div> tag. -->
<div style="min-height:380px">
<div id="player" style="display: block; margin: 0 auto;"></div>
</div>
<!-- <iframe id='playerGame' width="620" height="380" frameborder="0" src="https://youtube.com/embed/XFK3kolikoo?version=2&autoplay=0&controls=0&start=80&end=110&loop=0&rel=0&showinfo=0&enablejsapi=1&origin=https://www.example.com"></iframe> -->


<button id="btnPlay" onclick="showPlayer()" style="display:none; margin: 0 auto;">다시 듣기</button> 


<div>[정답 입력]</div>
<div id="inputAns">
</div>
<button id="subAns" onclick="chkAnswer()" style="margin-top:10px;">정답 제출</button>


<div id="hintView">
</div>


<div>[ 메모장 ]</div>
<textarea rows="10" cols="60"></textarea>

<p>↓ 정답을 제출하면 힌트가 보여집니다 ↓
<br>(한번 제출 할때마다 하나씩 선택할 수 있습니다)</p>
<div id="hint_btn" style="margin:10px; display:none;">
<button onclick="consonant(this)">두글자 자음힌트</button>
<button onclick="space(this)">띄어쓰기 힌트</button>
<button onclick="word(this)">한 글자 힌트</button>
<!-- <input type="text" maxlength="2" size="2"> -->
</div>


</body>
<!-- 탭 이동 -->
<script type="text/javascript">
function NextTab(inp,n) {
	        if (inp.value.length >= 2) {
	        		next = n+1;
	           inpNext = "#" + next;
	           $(inpNext).focus();
	       
	            return false;
	
	        }
	
}

/* 보류.. 
function PreTab(inp,p) {
    if (inp.value.length == 0) {
    		prev = p-1;
       inpPrev = "#" + prev;
       $(inpPrev).focus();
   
        return false;

    } 

}
    */


</script>

<script type="text/javascript">
var conHint = "";
var wordHint = "";
var chkHint = 0;
//자음 배열
var lyric = ["ㄴ","ㅉ","ㅇ","ㄹ ","ㄱ ","ㅎ ","ㅁ ","ㅈ ","ㅈ ","ㅇ ","ㅅ ","ㅎ ","ㄲ ",
	"ㄴ ","ㅈ ","ㅎ ","ㅂ ","ㅎ ","ㅇ ","ㅉ","ㅈ ","ㄹ ","ㅈ ","ㄱ ","ㄷ ","ㅁ ","ㅊ ","ㄲ "]; 
// 글자 전체 정답
var lyricAll = ["난 ","쯔 ","위 ","라  ","고  ","해  ","무  ","작  ","정  ","인  ","사  ","할  ","까",
	"내  ","전  ","화  ","번  ","호  ","야  ","쪽 ","지  ","를  ","주  ","고  ","도  ","망  ","칠  ","까  "]; 
var spaceArr = ["#1","#5","#6","#9","#13","#14","#19","#22","#24"];
	
window.onload = function() {
	for(var i=0; i< lyricAll.length; i++){
		$("#inputAns").append("<input type='text' id='"+ i +"' name='answer' maxlength='2' size='2' value='' onkeyup='NextTab(this,"+ i +")' placeholder='" + (i+1) +"' />");
		if(i==12){
			$("#inputAns").append("<br>");
		}
	}
	
}
	
function word(w) {
	chkHint++;
    var word = prompt("확인 할 글자 번호를 입력하시오. ", "");
    if(word == null) {return false;}
    checkNumWord(word);
    
    document.getElementById('hintView').innerHTML += wordHint;
    w.style.display = "none";
    $('#hint_btn').css('display','none');
}

function consonant(c) {
	chkHint++;
    var con1 = prompt("확인 할 자음 중 '첫번째 번호'를 입력하시오. ", "");
    if(con1 == null) {return false;}
    checkNum(con1);
    
    var con2 = prompt("확인 할 자음 중 '두번쨰 번호'를 입력하시오.", "");
    if(con2 == null) {return false;}
    checkNum(con2);
    
    document.getElementById('hintView').innerHTML += conHint;

    c.style.display = "none";
    $('#hint_btn').css('display','none');
}

/* 띄어쓰기 사진 */
function space(s) {
	chkHint++;
	for(var i=0; i<spaceArr.length; i++){
		$(spaceArr[i]).css('margin-left','20px');
	}
	$('#hint_btn').css('display','none');
	
	
}
/* 자음 힌트 체크  */
function checkNum(con) {
		

		if(isNaN(con)){
			con = prompt("숫자 입력하세요", "");
			checkNum(con);
		}else{
			if(1 <= con && con < 29){
				var add = parseInt(con) - 1;
				conHint +=  "  " + con + "번째 자음 : " +lyric[add] + "<br>";
				$('#'+con).val(lyric[add]);
				
			}else{
				con = prompt("1부터 28사이에 숫자를 입력하세요.", "");
				checkNum(con);
			}
		}

}
/* 글자 힌트 체크  */
function checkNumWord(con) {
	
	if(isNaN(con)){
		con = prompt("숫자 입력하세요", "");
		checkNumWord(con);
	}else{
		if(1 <= con && con < 29){
			var add = parseInt(con) - 1;
			wordHint +=  "<br>" + con + "번째 글자  : " +lyricAll[add] + "<br>";
		}else{
			con = prompt("1부터 28사이에 숫자를 입력하세요.", "");
			checkNumWord(con);
		}
	}
	
}


var playCount = 1; //default : 1;
var ansCount = 0;
 
/**
 * Youtube API 로드
 */
var tag = document.createElement('script');
tag.src = "https://www.youtube.com/iframe_api";
var firstScriptTag = document.getElementsByTagName('script')[0];
firstScriptTag.parentNode.insertBefore(tag, firstScriptTag);

// 3. This function creates an <iframe> (and YouTube player)
//    after the API code downloads.
var player;
function onYouTubeIframeAPIReady() {
    player = new YT.Player('player', {
        height: '315',            // <iframe> 태그 지정시 필요없음
        width: '560',             // <iframe> 태그 지정시 필요없음
        videoId: 'XFK3kolikoo',   // <iframe> 태그 지정시 필요없음
        playerVars: {             // <iframe> 태그 지정시 필요없음
            controls: '0',
            /* 추가 */
            version:'2',
            autoplay:'0',
            start:'80',
            end:'110',
            loop:'0',
            rel:'0',
            showinfo:'0'
        },

        events: {
            'onReady': onPlayerReady,               // 플레이어 로드가 완료되고 API 호출을 받을 준비가 될 때마다 실행
            'onStateChange': onPlayerStateChange    // 플레이어의 상태가 변경될 때마다 실행
        }
    });

}

function onPlayerReady(event) {
	
    console.log('onPlayerReady 실행');
    
    // 플레이어 자동실행 (주의: 모바일에서는 자동실행되지 않음)
    //event.target.playVideo();
}

// 5. The API calls this function when the player's state changes.
//    The function indicates that when playing a video (state=1),
//    the player should play for six seconds and then stop.
var playerState;
function onPlayerStateChange(event) {
			var isNone = document.getElementById("player");

            playerState = event.data == YT.PlayerState.ENDED ? '종료됨' :
                    event.data == YT.PlayerState.PLAYING ? '재생 중' :
                    event.data == YT.PlayerState.PAUSED ? '일시중지 됨' :
                    event.data == YT.PlayerState.BUFFERING ? '버퍼링 중' :
                    event.data == YT.PlayerState.CUED ? '재생준비 완료됨' :
                    event.data == -1 ? '시작되지 않음' : '예외';
            
            console.log('onPlayerStateChange 실행: ' + playerState);
           
			if(playerState == '종료됨'){ //  종료 되었을 
				if(isNone.style.display=='block'){ // 영상이 떠 있을때 
					$('#player').css('display','none'); // 영상 사라짐 
					$('#btnPlay').css('display','block');
					player.stopVideo();
					//alert("재생 종료");
				}
				
			} 

}

function showPlayer() {
	
	if(playCount>=5){
		alert('모두 재생되었습니다.');
	}else{
		if(playCount > ansCount){ // 정답 제출 안하고 플레이 할 경우 
			alert('정답을 먼저 제출하시오.');
		}else{
		playCount++;
		alert(playCount + "번째 재생");
		
		$('#player').css('display','block');
		$('#btnPlay').css('display','none');

		player.loadVideoById({videoId:'XFK3kolikoo',
	        startSeconds:'80',
	        endSeconds:'110'});
		}
	}	

	/* player.playVideo(); */
}

function chkAnswer() {
	var incor = 0;
	var ans = document.getElementsByName("answer");
	ansCount++; 
	for(var i=0;i<ans.length;i++){
		if(ans[i].value.trim() != lyricAll[i].trim()){ //같지 않으면
			incor++;
		}
	}
	
	if(incor>0){
		alert('틀렸습니다! 오답 갯수 : '+ incor +"개 ");
		if(chkHint <= 3){ //정답 눌렀을때 .. 
			alert('힌트를 사용할 수 있습니다! ');
			$('#hint_btn').css('display','block');
		}
 		if(ansCount >= 10){
			alert('정답 공개');
 			for(var j=0; j<lyricAll.length; j++){
 				var inp = '#' + j; 
 				document.getElementById(j).value = lyricAll[j];
				} 
			} 
	}else{
		alert("정답입니다! ");
	}

}

</script>


</html>