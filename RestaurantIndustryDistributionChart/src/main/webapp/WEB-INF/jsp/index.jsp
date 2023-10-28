<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-T3c6CoIi6uLrA9TneNEoa7RxnatzjcDSCmG1MXxSR1GAsXEV/Dwwykc2MPK8M2HN" crossorigin="anonymous">
<script src="https://code.jquery.com/jquery-3.7.1.min.js" integrity="sha256-/JqT3SQfawRcv/BIHPThkBvs0OEvtFFmqPF/lYI/Cxo=" crossorigin="anonymous"></script>
<script>

</script>
</head>
<body>
<div>
	<div>
		<select class="list-group" id="region" name="region" onclick="fn_regieonSelect();">
			<option class="list-group-item" value="">전국</option>
			<option class="list-group-item" value="서울">서울</option>
			<option class="list-group-item" value="인천">인천</option>
			<option class="list-group-item" value="경기">경기</option>
			<option class="list-group-item" value="충북">충북</option>
			<option class="list-group-item" value="충남">충남</option>
			<option class="list-group-item" value="대전/세종">대전/세종</option>
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
		<select>
			<option selected disabled value="">전체</option>
		</select>
		<button type="button" class="btn btn-primary">검색</button>
	</div>
</div>

</body>
</html>