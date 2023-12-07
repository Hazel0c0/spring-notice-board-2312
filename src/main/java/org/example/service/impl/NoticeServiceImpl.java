package org.example.service.impl;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.example.dao.NoticeDao;
import org.example.service.NoticeService;
import org.springframework.stereotype.Service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service
@RequiredArgsConstructor
@Slf4j
public class NoticeServiceImpl implements NoticeService {

    private final NoticeDao noticeDao;

    // 게시글 조회
    public Map<String, Object> getBoardList(Map<String, Object> request) throws Exception {
        Map<String, Object> response = new HashMap<>();
        Map param = (Map) request.get("param");

		/*
		LoginVO vo = (LoginVO) EgovUserDetailsHelper.getAuthenticatedUser();
		param.put("ENO", vo.getEno());
		 * Egov framework 를 통해 사용자 객체 반환
		 */

        // 요청한 객체 List<Map> 반환
        List<?> boardList = boardList(param);
        response.put("rsAjax", boardList);

        return response;
    }
    @Override
    public List<?> boardList(Object param) throws Exception {
        return noticeDao.getBoardList(param);
    }

    // 게시글 등록
    public Map<String, Object> savePost(Map<String, Object> dto) throws Exception {
        Map map = (Map) dto.get("param");
        System.out.println("map = " + map);

		/*
		LoginVO vo = (LoginVO) EgovUserDetailsHelper.getAuthenticatedUser();
		param.put("ENO", vo.getEno());
		 * Egov framework 를 통해 사용자 객체 반환
		 */

        Map<String,Object> result = new HashMap<>();
        log.debug("Service : savePost - {}" , insertBoard(map) > 0);

        System.out.println("result = " + result);
        return result;
    }
    @Override
    public int insertBoard(Object param) throws Exception {
        return noticeDao.insertPost(param);
    }

}
