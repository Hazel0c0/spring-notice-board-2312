<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="context_path" value="${pageContext.request.contextPath}" />
<div>공지사항 등록하기</div>

<div id="reg_BoardNtc">
	<div class="workMainDiv">
		<div class="workContentsDiv">
			<input type="hidden" value="${param.job}"       id="reg_BoardNtc_job_pop">
			<input type="hidden" value="${param.post_sqno}" id="reg_BoardNtc_post_sqno">
			<div class="searchButton">
			    <button type="button" id="reg_BoardNtc_btn_Save_pop"    class="swsButton">저장</button>
			    <c:if test="${param.job == 'U'}">
			    	<button type="button" id="reg_BoardNtc_btn_Del_pop"    class="swsButton">삭제</button>
			    </c:if>
			</div>
		    <table class="inputTable" style="width: 100%;">
		    	<colgroup>
		    		<col width="70px;"/>
					<col width="100%;"/>
				</colgroup>
		    	<c:if test="${sessionScope.loginVO.authCd.contains('ROLE_ADMIN')}">
		    		<tr>
		    			<th scope="row">메인고정</th>
		    			<td>
		    				<input id="reg_BoardNtc_MAIN_VW_POP_MK_YN" type="checkbox" class="swsInput"  style="width: 15px;"/>
		    			</td>
		    		</tr>
				<tr>
					<th scope="row">작성자</th>
					<td>
						<input id="reg_BoardNtc_REGMN_NM" type="text" class="swsInput"  value="${loginVO.empNm}" style="width:100px;" readonly="readonly"/>
					</td>
				</tr>
		    	</c:if>
		    	<tr>
		    		<th scope="row">제목 *</th>
		    		<td >
		    			<input id="reg_BoardNtc_POST_TIT" type="text" data-name='제목' data-minlength="1" data-maxlength="150" data-required='true' class="swsInput" style="width: 97.5%;"/>
		    		</td>
		    	</tr>
		    	<tr>
		    		<th scope="row" style="height: 200px;">내용 *<br><span id="reg_BoardNtc_POST_CNTN_len"></span></th>
		    		<td >
		    			<textarea maxlength="2000" id="reg_BoardNtc_POST_CNTN" data-name='내용' data-minlength="1" data-maxlength="2000" data-required='true' style="width: 99.2%; height: 195px; font-size: 12px;"></textarea>
		    		</td>
		    	</tr>
		    	<tr>
		    		<th scope="row">첨부파일</th>
		    		<td >
						<div class="searchButton">
							<button type="button" id="reg_BoardNtc_ATTFL_ID_allDownload" class="swsButton">전체다운로드</button>
							<button id="reg_BoardNtc_ATTFL_ID_insert" class="swsButton" type="button">추가</button>
							<button id="reg_BoardNtc_ATTFL_ID_delete" class="swsButton" type="button">삭제</button>
						</div>
						<iframe src="${context_path}/cm/FileFrame_B.do" id="reg_BoardNtc_ATTFL_ID" style="width: 100%; height: 130px; border: 0px solid;" onload="objBoardNtcReg.fn_fileOnYN()"></iframe>
		    		</td>
		    	</tr>
		    </table>
		</div>
	</div>
</div>
<c:if test="${param.job.contains('R')}">
<div style="height:50px;">
	<table style="height:100%;" >
		<tr>
			<td>
				<div>
					<label onclick="$('#reg_BoardNtc_1day_disabled').attr('checked', 'checked');" style="cursor:pointer" for="reg_BoardNtc_1day_disabled"><input type="checkbox" id="reg_BoardNtc_1day_disabled" style="width: 15px; vertical-align: middle;" onchange="objBoardNtcReg.fn_1day_disabled()">
					<span style= "display: inline-block; margin-top: 5px;">하루동안 보지않기</span> </label>
				</div>
			</td>
		</tr>
	</table>
</div>
</c:if>
<script type="text/javascript">

	var objBoardNtcReg
	   ,BoardNtcReg_attflId = "";

	objBoardNtcReg = {
		// 게시글 등록
		fn_save_pop: function () {
			if(!objBoardNtcReg.fn_validSave_pop()){return;}

			var isFileSaved = document.getElementById("reg_BoardNtc_ATTFL_ID").contentWindow.objFileFrame_B.fn_save();
			if(isFileSaved != true) {
				return;
			}

			var job = $('#reg_BoardNtc_job_pop').val();
			var service
					, param = new ParameterMap("param");

			if(job == "I") service = new Service("/bbs/notice/saveNotice.do");
			if(job == "U") {
				service = new Service("/bbs/ntc/updateBoard.do");
				param.addParam("POST_SQNO", $('#reg_BoardNtc_post_sqno').val());
			}


			var l_main_vw_pop_mk_yn = 0;
			if($('input:checkbox[id="reg_BoardNtc_MAIN_VW_POP_MK_YN"]').is(":checked") == true){
				l_main_vw_pop_mk_yn = 1;
			}


			param.addParam("POST_TIT", $("#reg_BoardNtc_POST_TIT").val());
			param.addParam("POST_CNTN", $("#reg_BoardNtc_POST_CNTN").val());
			param.addParam("ATTFL_ID", document.getElementById("reg_BoardNtc_ATTFL_ID").contentWindow.objFileFrame_B.fn_getFileId());
			param.addParam("MAIN_VW_POP_MK_YN", l_main_vw_pop_mk_yn);

			service.addMap(param);
			service.request();
			service.addCallBack(function(data) {
				alert('저장 되었습니다.');
				var rtn ={}
				rtn.search_yn=true;
				closePopup('reg_BoardNtc', rtn);
			});
		},
		fn_search_pop: function () {
			var postId = $('#reg_BoardNtc_post_sqno').val();
			var data = {
				POST_SQNO: postId
			};

			fetch(noticeURL+'', {
				method: 'PATCH',
				headers: {
					'Content-Type': 'application/json'
				},
				body: JSON.stringify(data)
			})
					.then(response => response.json())
					.then(data => {
						$("#reg_BoardNtc_POST_TIT").val(data.rsAjax.POST_TIT);
						$("#reg_BoardNtc_POST_CNTN").val(data.rsAjax.POST_CNTN);
						$("#reg_BoardNtc_REGMN_NM").val(data.rsAjax.EMP_NM);

						if (data.rsAjax.MAIN_VW_POP_MK_YN == "1") {
							$('input:checkbox[id="reg_BoardNtc_MAIN_VW_POP_MK_YN"]').attr("checked", true);
						}

						if (data.rsAjax.REGMN_ID != "${loginVO.eno}") {
							$("#reg_BoardNtc_btn_Save_pop").remove();
							$("#reg_BoardNtc_btn_Del_pop").remove();
							$("#reg_BoardNtc_ATTFL_ID_insert").remove();
							$("#reg_BoardNtc_ATTFL_ID_delete").remove();
							$("#reg_BoardNtc_btn_Save_pop").remove();
							$("#reg_BoardNtc_POST_TIT").attr("disabled", true);
							$("#reg_BoardNtc_POST_CNTN").attr("disabled", true);
						}

						BoardNtcReg_attflId = data.rsAjax.ATTFL_ID;

						$("#reg_BoardNtc_POST_CNTN").click();
					})
					.catch(error => {
						console.error('Error:', error);
					});
		},
	    fn_1day_disabled : function() {
	    	var service = new Service("/bbs/ntc/update_1day_disabled.do")
	          , param   = new ParameterMap("param");

	        param.addParam("POST_SQNO", $('#reg_BoardNtc_post_sqno').val());

	        service.addMap(param);
	        service.request();
	        service.addCallBack(function(data) {
				//$("#reg_BoardNtc_POST_TIT").val(data.rsAjax.POST_TIT);
				var rtn ={}
				rtn.search_yn=true;
				closePopup('index_reg_BoardNtc', rtn);
	        });
	    },
		fn_fileOnYN : function() {
  	       document.getElementById("reg_BoardNtc_ATTFL_ID").contentWindow.objFileFrame_B.fn_setFileId(BoardNtcReg_attflId);
		},

	    fn_validSave_pop : function() {
	    	if(!validation("reg_BoardNtc")) return;
	        return confirm("저장 하시겠습니까?");
	    },



	    fn_del_pop : function() {
	        if(!confirm("삭제 하시겠습니까?")) return;


	        var service = new Service("/bbs/ntc/deleteBoard.do")
	          , param   = new ParameterMap("param");

	        param.addParam("POST_SQNO", $('#reg_BoardNtc_post_sqno').val());

	        service.addMap(param);
	        service.request();
	        service.addCallBack(function(data) {
				var attfl_id  = document.getElementById("reg_BoardNtc_ATTFL_ID").contentWindow.objFileFrame_B.fn_getFileId();
				if(!fn_isNull(attfl_id)){
					document.getElementById("reg_BoardNtc_ATTFL_ID").contentWindow.objFileFrame_B.fn_delete();
				}


	            alert('삭제 되었습니다.');
				var rtn ={}
				rtn.search_yn=true;
				closePopup('reg_BoardNtc', rtn);
	        });
	    },


	};

	jQuery().ready(function () {
		$("#reg_BoardNtc_POST_CNTN_len").text( "(0/"+ $('#reg_BoardNtc_POST_CNTN').data('maxlength') + ")" );

		if($("#reg_BoardNtc_job_pop").val() == "U" || $("#reg_BoardNtc_job_pop").val() == "R") {
	    	objBoardNtcReg.fn_search_pop();

	    	// 메인화면에서 공지사항
	    	if($("#reg_BoardNtc_job_pop").val() == "R") {
	    		$('.searchButton button').hide();
	    		$('input:checkbox[id="reg_BoardNtc_MAIN_VW_POP_MK_YN"]').attr("disabled",true);
	    		$('input:text[id="reg_BoardNtc_POST_TIT"]').attr("readonly",true);
	    		$('#reg_BoardNtc_POST_CNTN').attr("readonly",true);
	    	}
	    }else{
	    	$("#reg_BoardNtc_ATTFL_ID_allDownload").attr("hidden", "hidden");
	    }

	    $("#reg_BoardNtc_btn_Save_pop").click(function() {
	        objBoardNtcReg.fn_save_pop();
	    });

	    $("#reg_BoardNtc_btn_Del_pop").click(function() {
	    	objBoardNtcReg.fn_del_pop();
	    });

		$("#reg_BoardNtc_ATTFL_ID_insert").click(function() {
			document.getElementById("reg_BoardNtc_ATTFL_ID").contentWindow.objFileFrame_B.fn_insert_btn();
		});

		$("#reg_BoardNtc_ATTFL_ID_delete").click(function() {
			document.getElementById("reg_BoardNtc_ATTFL_ID").contentWindow.objFileFrame_B.fn_delete_btn();
		});
		$("#reg_BoardNtc_POST_CNTN").on( "keyup keydown mousedown mouseup click change paste input propertychange", function(){
			$("#reg_BoardNtc_POST_CNTN_len").text( "(" + get2Bytes($('#reg_BoardNtc_POST_CNTN').val()) + "/"+ $('#reg_BoardNtc_POST_CNTN').data('maxlength') + ")" );
			var maxlen = $('#reg_BoardNtc_POST_CNTN').data('maxlength');
	    	if ( maxlen < get2Bytes($('#reg_BoardNtc_POST_CNTN').val()) ){
	    		$("#reg_BoardNtc_POST_CNTN_len").css("color","red");
	    	} else {
	    		$("#reg_BoardNtc_POST_CNTN_len").css("color","white");
	    	}
	    });

		//파일일괄다운로드
    	$("#reg_BoardNtc_ATTFL_ID_allDownload").click(function(){
    		document.getElementById("reg_BoardNtc_ATTFL_ID").contentWindow.objFileFrame_B.fn_downloadAllFile();
    	});
	});

</script>
