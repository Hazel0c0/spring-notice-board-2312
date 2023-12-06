package org.example.service.impl;

import lombok.RequiredArgsConstructor;
import org.example.dao.NoticeDao;
import org.example.service.NoticeService;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
@RequiredArgsConstructor
public class NoticeServiceImpl implements NoticeService {

    private final NoticeDao noticeDao;

    @Override
    public List<?> getBoardList(Object param) throws Exception {
        return noticeDao.getBoardList(param);
    }
}
