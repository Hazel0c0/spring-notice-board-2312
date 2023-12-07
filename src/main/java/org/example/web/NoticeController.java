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
	 * @param request : POST_TIT (제목), REGMN_ID (ID), REG_ST_DT, REG_ED_DT (검색 일자)
	 * @return "rsAjax" : boardList
	 */
	@PostMapping("selectNoticeList.do")
	public @ResponseBody Map<String, Object> selectNoticeList(@RequestBody Map<String, Object> request) throws Exception {
		log.debug("selectNoticeList POST : request - {}", request);

		return noticeService.getBoardList(request);
	}


	// 공지사항 등록 페이지 이동
	@GetMapping("reg_Notice.do")
	public String reg_RtAdBook(
			@RequestParam(required = false,value = "post_sqno") String postSqno
			, @RequestParam String job) throws Exception {
		log.debug("reg_Notice GET : postSqno - {}, job - {} ",postSqno,job);


		return "bbs/notice/reg_Notice";
	}
	/**
	 * 공지사항 등록
	 * @param dto
	 * @return Map<String, Object>
	 * @throws Exception
	 */
	@PostMapping("saveNotice.do")
	@ResponseBody
	public Map<String,Object> insertGroupList(@RequestBody Map<String,Object> dto) throws Exception{
		log.debug("savaNotice POST : dto - {}", dto);

		return noticeService.savePost(dto);
	}

}
