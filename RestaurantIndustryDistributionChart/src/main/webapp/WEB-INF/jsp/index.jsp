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
<script>
function csvLoad(r, t){
	
	//graph Map
	let dataMap = [];
	let categoryMap = [];
	
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
                
             	// 그룹화 및 카운팅
                const groupedData = fn_groupData(filteredData, t);
				
                //요식업 분류별 data
                Object.keys(groupedData).forEach(key => {
                    const count = groupedData[key].count;
                    const data = groupedData[key].data;
					
                    console.log(`Key: `,key,` Count: `, count);
                    dataMap.push(count);
                    categoryMap.push(key);
                });
                
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

                chart.update({
               	  	plotOptions: newPlotOptions
               	});
				chart.series[0].name = r;
                chart.series[0].setData(dataMap);
                chart.xAxis[0].update({
               	  	categories: categoryMap
               	});
                
            }
        });
    })
    .catch(error => {
        console.error('파일을 불러오는 중 오류 발생:', error);
    });
	
	
}


function fn_dataFilter(csvData, t){
	//'상권업종대분류명' 열이 '음식'인 데이터 가져오기
	if(t == "전체"){
    	return csvData.filter(row => row['상권업종대분류명'] === '음식');
    }else{
    	return csvData.filter(row => row['상권업종대분류명'] === '음식' && row["상권업종중분류명"] === t )
    }
}

function fn_groupData(data, t){
	let rowName;
	
	if(t == "전체"){
		rowName = '상권업종중분류명';
    }else{
    	rowName = '상권업종소분류명';
    }
	
	// 그룹화 및 카운팅
    const groupedData = data.reduce((result, row) => {
        const key = row[rowName]; // '세부업종명'은 실제 CSV 파일의 열 이름으로 변경해야 합니다.
        
        // 그룹이 존재하는지 확인
        if (!result[key]) {
            result[key] = {
                count: 1,
                data: [row]
            };
        } else {
            result[key].count++;
            result[key].data.push(row);
        }

        return result;
    }, {});
    
    return groupedData;
}

function fn_regionGroupData(){
	
}

function fn_search(){
	
	let r = document.getElementById("region").value;
	
	let t = document.getElementById("restaurantType").value;
	
	csvLoad(r,t);
	
}

</script>
</head>
<body>
<div>
	<div>
		<div style="display:flex;">
			<select style="margin:10px;" class="list-group" id="region" name="region" >
				<option class="list-group-item" value="전국">전국</option>
				<option class="list-group-item" value="서울">서울</option>
				<option class="list-group-item" value="인천">인천</option>
				<option class="list-group-item" value="경기">경기</option>
				<option class="list-group-item" value="충북">충북</option>
				<option class="list-group-item" value="충남">충남</option>
				<option class="list-group-item" value="대전">대전</option>
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
				<option class="list-group-item" value="한식">한식</option>
			</select>
			<button style="margin:10px;" type="button" class="btn btn-primary" onclick="fn_search();">검색</button>
		</div>
		<div>
			<div id="container"></div>
		</div>
	</div>
</div>
<script type="text/javascript" src="/js/graph.js"></script>
</body>
</html>