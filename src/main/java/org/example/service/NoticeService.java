package org.example.service;

import java.util.List;

public interface NoticeService {

	List<?> boardList(Object param) throws Exception;

	int insertBoard(Object param) throws Exception;
	}
