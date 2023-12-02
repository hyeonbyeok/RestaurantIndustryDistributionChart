<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-T3c6CoIi6uLrA9TneNEoa7RxnatzjcDSCmG1MXxSR1GAsXEV/Dwwykc2MPK8M2HN" crossorigin="anonymous">
<script src="https://code.jquery.com/jquery-3.7.1.min.js" integrity="sha256-/JqT3SQfawRcv/BIHPThkBvs0OEvtFFmqPF/lYI/Cxo=" crossorigin="anonymous"></script>
<script src="https://code.highcharts.com/highcharts.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/PapaParse/5.3.0/papaparse.min.js"></script>
<style>
	.btn-circle.btn-xl {
		width: 70px;
		height: 70px;
		padding: 16px 16px;
		border-radius: 35px;
		font-size: 12px;
		text-align: center;
	}
</style>
<script>

$(document).ready(function(){
	csvLoad('대전','전체');
});

function csvLoad(r, t){	
	//graph Map
	let dataMap = [];
	let categoryMap = [];
	
	let regionDataMap = [];
	let regionMap = [];
	//지역에 다른 csv파일 read
	let csvUrl = "/data/소상공인시장진흥공단_상가(상권)정보_"+r+"_202309.csv";
	fetch(csvUrl)
    .then(response => response.text())
    .then(data => {
    	Papa.parse(data, {
            header: true,
            dynamicTyping: true,
            complete: function(results) {
                
            	// 결과에서 데이터 가져오기
                const csvData = results.data;
                
                //csv파일 요식업종 filter작업
                const filteredData = fn_dataFilter(csvData, t);
                
             	//요식업 그룹화 및 카운팅
                const groupedData = fn_groupData(filteredData, t == "전체" ? "상권업종중분류명" : "상권업종소분류명" );
				
                viewData(groupedData, filteredData, chart , t, r , "type") 
                
                //지역별 그룹화 및 카운트
                const regionGroupData = fn_groupData(filteredData, r == "전국" ? "시도명" : "시군구명");
                
                viewData(regionGroupData, filteredData, regionChart , t, r , "region");

            	//해당 지역 이동
            	setCenter(latLng[r]["lat"], latLng[r]["lng"], latLng[r]["level"]);
            }
        });
    })
    .catch(error => {
        console.error('파일을 불러오는 중 오류 발생:', error);
    });
	
	
}

function viewData(groupedData, filteredData, chartVar, t, r , type){
	let dataMap = [];
	let categoryMap = [];
	let location = {};
	
	//요식업 분류별 data
    Object.keys(groupedData).forEach(key => {
        const count = groupedData[key].count;
        const data = groupedData[key].data;
		
        dataMap.push(count);
        categoryMap.push(key);
        
        if(type == "region"){
	        location[key] = {
	            "lat": groupedData[key].lat / groupedData[key].count,
	            "lng": groupedData[key].lng / groupedData[key].count,
	            "count" : count
	        };
        }
        
    });
    
	if(type == "region"){
		fn_makeMapOverlay(location)
	}
	
    
    var total = filteredData.length;
    
    var newPlotOptions = {
    		series: {
                borderWidth: 0,
                dataLabels: {
                    enabled: true,
                    formatter: function() {
                        var percentage = (this.y / total) * 100;
                        return Highcharts.numberFormat(percentage, 1) + '%';
                  	}	
                }
            }	
		};

    chartVar.update({
   	  	plotOptions: newPlotOptions
   	});
    
    chartVar.series[0].name =  t == "전체" ? r : r + " / " + t;
    chartVar.series[0].setData(dataMap);
    chartVar.xAxis[0].update({
   	  	categories: categoryMap
   	});

}

function fn_makeMapOverlay(json){
	console.log(json);
	for(var key in json){
		customOverlay(key, json[key].count, json[key].lat, json[key].lng)
	}
	
}

function fn_dataFilter(csvData, t){
	//'상권업종대분류명' 열이 '음식'인 데이터 가져오기
	if(t == "전체"){
    	return csvData.filter(row => row['상권업종대분류명'] === '음식');
    }else{
    	return csvData.filter(row => row['상권업종대분류명'] === '음식' && row["상권업종중분류명"] === t )
    }
}

function fn_groupData(data, rowName){
	
	// 그룹화 및 카운팅
    const groupedData = data.reduce((result, row) => {
        const key = row[rowName];
        // 그룹이 존재하는지 확인
        if (!result[key]) {
            result[key] = {
                count: 1,
                data: [row],
                lat :  row["위도"],
                lng : row["경도"],
            };
        } else {
            result[key].count++;
            result[key].data.push(row);
            result[key].lat += row["위도"];
            result[key].lng += row["경도"];
        }

        return result;
    }, {});
    return groupedData;
}

//위도 경도 JSON
let latLng = {
		"대전" : {"lat" : 36.3504119 , "lng" : 127.3845475, "level" : 8},
		"강원" : {"lat" : 37.5228 ,  "lng" : 128.355, "level" : 11}
};

function fn_search(){
	
	let r = document.getElementById("region").value;
	
	let t = document.getElementById("restaurantType").value;
	
	csvLoad(r,t);
	
}

</script>
</head>
<body>
<div style="display:flex;">
	<div style="width: 50%;">
		<div style="display:flex;">
			<select style="margin:10px;" class="list-group" id="region" name="region" >
				<option class="list-group-item" value="전국">전국</option>
				<option class="list-group-item" value="서울">서울</option>
				<option class="list-group-item" value="인천">인천</option>
				<option class="list-group-item" value="경기">경기</option>
				<option class="list-group-item" value="충북">충북</option>
				<option class="list-group-item" value="충남">충남</option>
				<option class="list-group-item" selected value="대전">대전</option>
				<option class="list-group-item" value="세종">세종</option>
				<option class="list-group-item" value="전북">전북</option>
				<option class="list-group-item" value="전남">전남</option>
				<option class="list-group-item" value="광주">광주</option>
				<option class="list-group-item" value="경북">경북</option>
				<option class="list-group-item" value="경남">경남</option>
				<option class="list-group-item" value="대구">대구</option>
				<option class="list-group-item" value="부산">부산</option>
				<option class="list-group-item" value="울산">울산</option>
				<option class="list-group-item" value="강원">강원</option>
				<option class="list-group-item" value="제주">제주</option>
			</select>
			<select style="margin:10px;" class="list-group" id="restaurantType" name="restaurantType">
				<option class="list-group-item" value="전체">전체</option>
				<option class="list-group-item" value="기타 간이">기타 간이</option>
				<option class="list-group-item" value="주점">주점</option>
				<option class="list-group-item" value="비알코올 ">비알코올 </option>
				<option class="list-group-item" value="중식">중식</option>
				<option class="list-group-item" value="서양식">서양식</option>
				<option class="list-group-item" value="일식">일식</option>
				<option class="list-group-item" value="동남아시아">동남아시아</option>
				<option class="list-group-item" value="구내식당·뷔페">구내식당·뷔페</option>
				<option class="list-group-item" value="한식">한식</option>
			</select>
			<button style="margin:10px;" type="button" class="btn btn-primary" onclick="fn_search();">검색</button>
		</div>
		<div>
			<div id="regieonGraph"></div>
		</div>
		<div>
			<div id="container"></div>
		</div>
	</div>
	<div style="width: 50%;">
		<div id="map" style="width:100%;height:960px;">
		<script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey=a163b9c1554276acb41e377bdbfa6b84&libraries=services"></script>
		<script>
			// 마커를 담을 배열입니다
			var markers = [];
			let regionSet = latLng["대전"];
			var mapContainer = document.getElementById('map'), // 지도를 표시할 div 
			    mapOption = { 
			        center: new kakao.maps.LatLng(regionSet["lat"], regionSet["lng"]), // 지도의 중심좌표
			        level: regionSet["level"] // 지도의 확대 레벨
			    };
			
			
			var map = new kakao.maps.Map(mapContainer, mapOption); // 지도를 생성합니다
			
			function setCenter(lat, lng, level) {
			    // 이동할 위도 경도 위치를 생성합니다 
			    var moveLatLon = new kakao.maps.LatLng(lat, lng);
			    
			    // 지도 중심을 부드럽게 이동시킵니다
			    // 만약 이동할 거리가 지도 화면보다 크면 부드러운 효과 없이 이동합니다
			    map.setCenter(moveLatLon);
			    map.setLevel(level)
			    
			}        
			
				//지동 이동 비활성화
			    map.setDraggable(false);
			    
				//지도 확대 축소 비활성화
			    map.setZoomable(false); 
				
			function customOverlay(region, count, lat, lng){

			    var content = `<label class="btn btn-primary btn-circle btn-xl " style="pointer-events : none;">`+region+`</br>`+count+`</label>`;
	
			 	// 커스텀 오버레이가 표시될 위치입니다 
			 	var position = new kakao.maps.LatLng(lat, lng);  
		
			 	// 커스텀 오버레이를 생성합니다
			 	var customOverlay = new kakao.maps.CustomOverlay({
		    	 	position: position,
			     	content: content   
			 	});
			 	
			 	// 커스텀 오버레이를 지도에 표시합니다
		 		customOverlay.setMap(map);
			 	
			 	
			}
		</script>
	</div>
</div>
<script type="text/javascript" src="/js/graph.js"></script>
</body>
</html>