package org.example.web;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.example.service.impl.NoticeServiceImpl;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
@Slf4j
@RequiredArgsConstructor
@RequestMapping("/bbs/notice/")
public class NoticeController {

	private final NoticeServiceImpl noticeService;

	 // 공지사항 페이지 이동
	@GetMapping("Notice.do")
	public String RtAdBook(){
		return "bbs/notice/Notice";
	}

	/**
	 * 공지사항 리스트 조회
	 * @param request : title, id, 검색 일자(st ~ ed)
	 * @return "rsAjax" : boardList
	 */
	@PostMapping("selectNoticeList.do")
	public @ResponseBody Map<String, Object> selectNoticeList(@RequestBody Map<String, Object> request) throws Exception {
		Map<String, Object> response = new HashMap<>();
		Map param = (Map) request.get("param");

		/*
		LoginVO vo = (LoginVO) EgovUserDetailsHelper.getAuthenticatedUser();
		param.put("ENO", vo.getEno());
		 * Egov framework 를 통해 사용자 객체 반환
		 */

		// 요청한 객체 List<Map> 반환
		List<?> boardList = noticeService.getBoardList(param);
		response.put("rsAjax", boardList);

		return response;
	}



}
