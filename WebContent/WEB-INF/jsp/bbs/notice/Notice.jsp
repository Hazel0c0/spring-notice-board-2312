<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="context_path" value="${pageContext.request.contextPath}"/>


<div id="BoardNtc">
    <div class="headerDiv">
        <p>공지사항</p>
        <div class="searchButton">
            <button type="button" id="BoardNtc_btn_search" class="swsButton">조회</button>
            <c:if test="${sessionScope.loginVO.authCd.contains('ROLE_ADMIN')}">
                <button type="button" id="Notice_btn_reg" class="swsButton">등록</button>
            </c:if>
        </div>
    </div>
    <div class="workMainDiv">
        <div class="workContentsDiv">
            <div class="searchWrap">
                <table class="inputTable" style="width: 100%;">
                    <colgroup>
                        <col width="90px;"/>
                        <col width="250px;"/>
                        <col width="90px;"/>
                        <col width="200px;"/>
                        <col width="90px;"/>
                        <col width="100%;"/>
                    </colgroup>
                    <tr>
                        <th scope="row">작성기간</th>
                        <td>
                            <input id="BoardNtc_reg_st_dt" type="text" class='swsInput' style='width:100px'
                                   readonly="readonly"
                                   onchange="validYMD($('#BoardNtc_reg_st_dt'),$('#BoardNtc_reg_ed_dt'),'작성기간')"/>
                            ~
                            <input id="BoardNtc_reg_ed_dt" type="text" class='swsInput' style='width:100px'
                                   readonly="readonly"
                                   onchange="validYMD($('#BoardNtc_reg_st_dt'),$('#BoardNtc_reg_ed_dt'),'작성기간')"/>
                        </td>
                        <th>작성자</th>
                        <td>
                            <input id="BoardNtc_eno" type="hidden">
                            <input id="BoardNtc_empNm" class="swsInput" type="text">
                            <span id="BoardNtc_prsSearch" class="ico_search cm_ico"></span>
                            <span id="BoardNtc_resetPrs" class="ico_closeInput cm_ico"></span>
                        </td>
                        <th scope="row">제목</th>
                        <td valign="middle">
                            <input type='text' class='swsInput' id='BoardNtc_post_tit' style="width: 400px;"
                                   onkeyup="if(event.keyCode == 13) $('#BoardNtc_btn_search').click();">
                        </td>

                    </tr>

                </table>
            </div>
            <div style="position: relative; width: 100%; height: 93.8%;" id="gridBoardNtc"></div>
        </div>
    </div>
</div>

<script type="text/javascript">
    let grid_BoardNtc,
        grid_BoardNtcData,
        objBoardNtc;

    objBoardNtc = {

        // 작성기간 초기화
        fn_init: function () {
            const dt = new Date(),
                y = dt.getFullYear(),
                m = dt.getMonth() + 1,
                d = dt.getDate();

            initCal({id: "BoardNtc_reg_st_dt"})
            initCal({id: "BoardNtc_reg_ed_dt"})

            $("#BoardNtc_reg_st_dt").val((y - 3) + "-01-01");
            $("#BoardNtc_reg_ed_dt").val(y + "-12-31");

            objBoardNtc.fn_search();
        },

        // 공지사항 List 요청
        fn_search: function () {
            var service = new Service("/bbs/notice/selectNoticeList.do")
                , param = new ParameterMap("param");

            param.addParam("POST_TIT",$('#BoardNtc_post_tit').val());
            param.addParam("REGMN_ID",$('#BoardNtc_empNm').val());
            param.addParam("REG_ST_DT",$('#BoardNtc_reg_st_dt').val().replace(/-/g,''));
            param.addParam("REG_ED_DT",$('#BoardNtc_reg_ed_dt').val().replace(/-/g,''));
            service.addMap(param);
            service.request();
            service.addCallBack(function(data)
            {
                grid_BoardNtcData = data.rsAjax;

                objBoardNtc.__createSBGrid();
            });
        },

        __createSBGrid: function () {
            var SBGridProperties = {
                parentid: "gridBoardNtc"
                , id: "grid_BoardNtc"
                , jsonref: "grid_BoardNtcData"
                , width: "100%"
                , height: "100%"
                , rowheight: "25"
                , backColorAlternate: "#EAEAEA"
                , explorerbar: "sort"
                , dataReplace: "null?"
                , emptyrecords: "조회된 데이터가 없습니다."
                , emptyrecordsfontstyle: "color:#212d5d; font-size:18px; font-weight:bold;"
                , rowheader: "reverseseq"
                , columns: [
                    {
                        caption: ['제목'],
                        type: "output",
                        id: "POST_TIT",
                        ref: "POST_TIT",
                        width: "50%",
                        style: "text-align:left"
                    }
                    , {
                        caption: ['메인고정'],
                        type: "output",
                        id: "MAIN_VW_POP_MK_YN",
                        ref: "MAIN_VW_POP_MK_YN",
                        width: "5%",
                        style: "text-align:center"
                    }
                    , {
                        caption: ['작성자'],
                        type: "output",
                        id: "EMP_NM",
                        ref: "EMP_NM",
                        width: "10%",
                        style: "text-align:center"
                    }
                    , {
                        caption: ['작성일'],
                        type: "output",
                        id: "REG_DTM",
                        ref: "REG_DTM",
                        width: "14%",
                        style: "text-align:center",
                        format: {type: 'date', rule: 'YYYY-MM-DD HH:mm:ss', origin: 'YYYYMMDDHHmmss'}
                    }
                    , {
                        caption: ['수정일'],
                        type: "output",
                        id: "MOD_DTM",
                        ref: "MOD_DTM",
                        width: "14%",
                        style: "text-align:center",
                        format: {type: 'date', rule: 'YYYY-MM-DD HH:mm:ss', origin: 'YYYYMMDDHHmmss'}
                    }
                    , {
                        caption: ['조회수'],
                        type: "output",
                        id: "SCH_NT",
                        ref: "SCH_NT",
                        width: "7%",
                        style: "text-align:center"
                    }
                ]
            }

            grid_BoardNtc = _SBGrid.create(SBGridProperties);
            grid_BoardNtc.bind("dblclick", "objBoardNtc.eventProcess");
        },
        eventProcess: function (event) {
            openPopup("reg_BoardNtc", "공지사항 수정"
                , 700, 570
                , '/bbs/ntc/reg_BoardNtc.do?job=U&post_sqno='
                + grid_BoardNtcData[grid_BoardNtc.getRow() - 1].POST_SQNO
                , function (rtn) {
                    if (rtn.search_yn) objBoardNtc.fn_search();
                });
        }
    };


    jQuery().ready(function () {

        objBoardNtc.fn_init()

        $('#BoardNtc_btn_search').click(function () {
            objBoardNtc.fn_search();
        });


        $('#Notice_btn_reg').click(function () {

            openPopup("reg_Notice" // id
                , "공지사항 등록" // title
                , 700, 570 // w, h
                , '/bbs/notice/reg_Notice.do?job=I' // url
                , function (rtn) { // cbFunction
                    if (rtn.search_yn) objBoardNtc.fn_search();
                });
        });


        $("#BoardNtc_prsSearch").click(function () {
            openPopup("popup_auditor", "작성자", 530, 430, "/cm/popup_auditor.do", function (obj) {
                if (obj.search_yn) {
                    $("#BoardNtc_eno").val(obj.ENO);
                    $("#BoardNtc_empNm").val(obj.EMP_NM);
                }
            });
        });

        $("#BoardNtc_resetPrs").click(function () {
            $("#BoardNtc_eno").val("");
            $("#BoardNtc_empNm").val("");
        });
    });

</script>